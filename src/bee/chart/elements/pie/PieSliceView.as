package bee.chart.elements.pie 
{
	import cn.alibaba.util.ColorUtil;
	import bee.chart.abstract.ChartData;
	import bee.chart.abstract.ChartElement;
	import bee.chart.abstract.ChartElementView;
	import bee.chart.abstract.ChartViewer;
	import bee.chart.assemble.pie.IPieSlicePrinter;
	import bee.chart.util.ChartUtil;
	import bee.chart.util.TO_RADIANS;
	import bee.controls.label.Label;
	import bee.util.StyleUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieSliceView extends ChartElementView 
    {
        /** pieCanvas距离pieLabel的距离 **/
        static public const TICK_SIZE:Number = 4;
        
        /** pieLabel水平放置时，line上横线的长度 **/
        static public const TICK_EXTENSION_SIZE:Number = 4;
        
        /** pieLabel水平放置时，pieLabel偏移对应line的距离 **/
        static public const LABEL_MARGIN:Number = 2;
        
        public var radian:Number = -1;
        public var startRadian:Number = -1;
        public var serialNum:int = 0;
        public var offset:Number = 0.0;
        
        private var _labelWidth:Number;
        private var _labelHeight:Number;
        
        public function PieSliceView(host:ChartElement) 
        {
            super(host);
        }
		
		/**
		 * 根据配置获取pieLabel的显示文本
		 */		
		public function getLabelText():String 
        {
            if (!chart) {
                return '';
            }
            
			var data:PieSliceData = __data;
            var name:String = data.name;
            
            //TODO: 这部分的代码需要优化，不可出现中文字符
            // 并尽量转移到外部配置
            if (data.isGroup()) {
                name = '【 ' + name + ' 】';
            }
            
            var titleColor:String = ColorUtil.int2str(color);
            var coloredName:String = '<font color="' + titleColor + '">' + name + '</font>';
			var labelStr:String = getStyle('label') || getStyle('text');
			var brReg:RegExp=/<br(?: *\/)?>/g;
			if (labelStr) {
				var chartData:ChartData = chart.data;
				var value:Number = data.value;
				var total:Number = chartData.total;
				var percentStr:String = ChartUtil.getPercentStr(value / total);
				labelStr = labelStr.replace("#label#", coloredName)
					.replace("#name#", name)
					.replace("#title#", name)
					.replace("#value#", value)
					.replace("#total#", total)
					.replace("#percent#", percentStr)
					.replace(brReg,"\n");
			}else{
				labelStr =  name; 
			}
			return labelStr;
		}
        
        public function getContentCenter(coord:DisplayObject=null):Point
        {
            var center:Point = new Point();
            var view:PieSliceView = this;
            var rad:Number = __data.getPositionRadian();
            if (view.isRecodeWorkable())
            {
                rad = view.getPositionRadian();
            }
            var radius:Number = __data.radius * .618;
            center.x = __data.pieSliceCanvasX + (Math.cos(rad) * radius);
            center.y = __data.pieSliceCanvasY + (Math.sin(rad) * radius);
            
            if (coord) {
                center = this.localToGlobal(center);
                center = coord.globalToLocal(center);
            }
            return center;
        }
        
        /**
        * 更新文字和线条
        */
        public function updateLabelAndLinePos():void
        {
            if (skin.statePrinter is IPieSlicePrinter) {
                IPieSlicePrinter(skin.statePrinter).updateLabelAndLinePos(this);
            }
        }
        
        // shouldn't this in Util package?
        public function setLineStyle(g:Graphics):void 
        {
            var alpha:Number = StyleUtil.getNumberStyle(this, "pieLineAlpha", 1);
            var pieLineThickness:Number = Number(getStyle("pieLineThickness"));
            var pieLineColor:uint = 0;
            if (hasStyle("pieLineColor")) {
                pieLineColor = ColorUtil.str2int(getStyle("pieLineColor"));
            }else {
                pieLineColor = __data.color;
            }
            g.lineStyle(pieLineThickness, pieLineColor, alpha);
        }
        
        public function removeLabel():void
        {
            if (label) {
                content.removeChild(label);
            }
        }
        
        override protected function initView():void 
        {
            super.initView();
            skin.statePrinter = new PieSlice2dDrawPrinterBase();
            skin.performer = new PieSlicePerformer();
        }
        
        override public function toString():String
        {
            return '[PieSliceView '.concat(name).concat(']');
        }
        
        public function recordRadian(value:Number):void 
        {
            radian = value;
        }
        
        public function recordSerialNum(value:int):void 
        {
            serialNum = value;
        }
        
        public function isRecodeWorkable():Boolean 
        {
            return radian > 0 && startRadian >= 0;
        }
        
        /**
         * 返回数据所处位置的中间弧度
         * @return
         */
        public function getPositionRadian():Number {
            return startRadian + radian/ 2;
        }
        
        public function setOffset(value:Number):void 
        {
            if (value != offset)
            {
                offset = value;
                updateLabelAndLinePos();
            }
        }
        
        public function recordStartRadian(value:Number):void 
        {
            startRadian = value;
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
		public function get canvas():PieSliceCanvas 
		{
			return content.getChildByName('canvas') as PieSliceCanvas;
		}
		
        public function get label():Label 
        {
            var lbl:Label = content.getChildByName('label') as Label;
            if (lbl && !_labelWidth) {
                var rect:Rectangle = lbl.getBounds(lbl);
                _labelWidth     = rect.width;
                _labelHeight    = rect.height;
            }
            return lbl; 
        }

		public function get line():PieLine 
		{
			return content.getChildByName('line') as PieLine;
		}
        
        public function get detailView():DisplayObject 
		{
			return content.getChildByName(PieSliceStates.DETAIL);
		}
        
        override protected function get defaultStyles():Object 
        { 
            return {
                pieSliceAlpha           : '1',
                'pieSliceAlpha.blur'    : '0.5',
                frameThickness          : '2',
                frameColor              : '#FFFFFF',
                pieLineThickness        : '1',
                pieLineAlpha            : '1',
                offsetRadius            : '0',
                'offsetRadius.hl'       : '20',
                'offsetRadius.detail'   : '20'
            }; 
        }
        
        public function get color():uint
        {
            if (hasStyle('color')) {
                return StyleUtil.getColorStyle(this);
            } else {
                return __data.color;
            }
        }
        
        private function get __data():PieSliceData
        {
            return dataModel as PieSliceData;
        }
        
        public function get labelWidth():Number { return label ? _labelWidth : _labelWidth; }
        public function get labelHeight():Number { return label ? _labelHeight : _labelHeight; }
        
        //返回占据的角度
        public function get angle():Number 
        {
            if (isRecodeWorkable()) {
                var _angle:Number = 0;
                if(radian){
                    _angle =  radian / TO_RADIANS; 
                }
                return _angle;
            } else {
                return __data.angle;
            }
        }
        
        override public function smoothUpdate(state:String = null, context:DisplayObjectContainer = null):void 
        {
            super.smoothUpdate(state, context);
            onTween();
        }
        
        private function onTween():void 
        {
            var view:PieSliceView = this as PieSliceView;
            var data:PieSliceData = this.dataModel as PieSliceData;
            var context:DisplayObjectContainer = content;
            var chartview:ChartViewer = view.chart.view as ChartViewer;
            if (!context.numChildren) {
                printState();
            }
            var canvas:PieSliceCanvas = context.getChildByName("canvas") as PieSliceCanvas;
            if (canvas) {
            
                //记录之前的所占弧度，起始弧度
                var obj:Object = { 
                                    radian:canvas.radian,
                                    startRadian:canvas.startRadian
                                 };
                TweenLite.to(obj, 1 ,
                    {
                        radian : data.radian,
                        startRadian : data.startRadian,
                        onStart:function():void 
                        {
                            view.state = PieSliceStates.NORMAL;
                            chartview.isSmoothing = true;
                        },
                        onUpdate:function():void
                        {
                            view.recordRadian(obj.radian);
                            view.recordStartRadian(obj.startRadian);
                            onUpdate();
                        },
                        onComplete:function():void 
                        {
                            view.recordRadian(-1);
                            view.recordStartRadian( -1);
                            chartview.isSmoothing = false;
                        }
                    }
                );
            }
        }
          
        private function onUpdate():void
        {
            printState();
        }
    }

}