package bee.chart.elements.axis 
{
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.Chart;
    import bee.chart.elements.axis.AxisData;
    import bee.chart.elements.axis.AxisView;
    import bee.chart.util.CartesianUtil;
    import bee.chart.util.StringFormater;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
    import flash.display.CapsStyle;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /**
    * ...
    * @author hua.qiuh
    */
    public class AxisSimplePrinter implements IStatePrinter, IAxisWithLabelPrinter
    {
        private var ax:AxisView;
        private var data:AxisData;
        private var tckPosNormal:Boolean;
        private var tickLength:Number;
        private var sp:Sprite;
        private var grph:Graphics;
        private var ticksAvailable:Boolean;
        private var labelsAvailable:Boolean;
        private var isTempCreatedLabel:Dictionary;
        
        protected var labelContainer:Sprite;
        protected var labels:Vector.<Label>;
        
        private var _range:Rectangle;
        
        private var _needFixForAxis:Boolean = false;
        
        private var _labelStyle:Object;
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            if (host is AxisView && AxisView(host).chart ) 
            {
                reset( context );
                printState( host, state, context );
            }
        }
        
        protected function printState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            ax = host as AxisView;
            data = ax.dataModel as AxisData;
            
            initObj();
            drawMainLine();
            drawTicksAndLabels();
            clean();
        }
        
        private function initObj():void 
        {
            _labelStyle = StyleUtil.inheritStyle(
                ax.styleSheet.getStyle('label'),
                ax);
        }
        
        protected function reset(context:DisplayObjectContainer):void 
        {
            labels = new Vector.<Label>();
            resetContext( context );
        }
        
        protected function resetContext( context:DisplayObjectContainer ):void 
        {
            DisplayUtil.clearSprite(context);
            
            sp = new Sprite();
            grph = sp.graphics;
            context.addChild(sp);
            
            labelContainer = new Sprite();
            labelContainer.name = 'labels';
            context.addChild(labelContainer);
        }
        
        protected function drawMainLine():void
        {
            var len:Number = data.length;
            var fat:Number = Number(ax.getStyle('lineThickness'));
            if(fat){
                var lineColor:uint = ColorUtil.str2int(ax.getStyle('lineColor'));
                grph.lineStyle(fat, lineColor, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.BEVEL);
                switch(data.direction) {
                    case AxisDirection.UP:
                        grph.lineTo( 0, -len );
                        break;
                    case AxisDirection.LEFT:
                        grph.lineTo( -len, 0 );
                        break;
                    case AxisDirection.DOWN:
                        grph.lineTo( 0, len );
                        break;
                    case AxisDirection.RIGHT:
                    default:
                        grph.lineTo( len, 0 );
                }
            }
        }
        
        protected function drawTicksAndLabels():void
        {
            var tickThickness:Number;
            tickLength = StyleUtil.getNumberStyle(ax, 'tickLength');
            tickThickness = StyleUtil.getNumberStyle(ax, 'tickThickness');
            ticksAvailable = tickThickness && tickLength;
            labelsAvailable = ax.styleSheet.getStyle('label')['visibility'] !== 'hidden';
            tckPosNormal = ax.getStyle('tickPosition') != 'reverse';
            _needFixForAxis = CartesianUtil.needFixForAxis(ax.chart, ax);
            if (ticksAvailable) 
            {
                grph.lineStyle( tickThickness, ColorUtil.str2int(ax.getStyle('tickColor')));
            }
            isTempCreatedLabel = new Dictionary(true);
            var idx:int = 0;
            for each (var label:String in data.labels) 
            {
                drawEachTickAndLabel(label,idx);
                idx++;
            }
        }
    
        /**
        * 画刻度和标签
        * @param	label
        * @param	idx
        * @param	labels
        */
        protected function drawEachTickAndLabel(label:String, idx:uint):void
        {
            if(ticksAvailable){
                drawTickAt(label, idx);
            }
            if(isLabelAvailableAt(idx, ax)){
                drawLabelAt(idx);
            }
        }
        
        protected function drawTickAt(label:String, idx:uint):void
        {
            var pt:Point;
            if (data.isValueAxis) {
                var value:Number = getNumber(label);
            }
            var tickXPos:Number = ax.getStyle('tickPosition') === 'center' ? idx + 0.5 : idx;
            var chart:Chart = ax.chart;
            switch(data.direction) 
            {
                case AxisDirection.UP:
                case AxisDirection.DOWN:
                    if (data.isValueAxis) {
                        pt = chart.chartToViewXY(0, value);
                    } else {
                        pt = chart.chartToViewXY(tickXPos, 0);
                        pt.y += chart.chartHeight;
                    }
                    grph.moveTo(0, pt.y);
                    grph.lineTo( (tckPosNormal ? -1:1) * tickLength, pt.y);
                    break;
                    
                case AxisDirection.RIGHT:
                case AxisDirection.LEFT:
                    if (data.isValueAxis) {
                        pt = chart.chartToViewXY(0, value);
                    } else {
                        pt = chart.chartToViewXY(tickXPos, 0);
                    }
                    grph.moveTo( pt.x, 0);
                    grph.lineTo( pt.x, tickLength);
                    break;
            }
        }
        
        protected function drawLabelAt(idx:uint):Label
        {
            var label:String = data.labels[idx];
            var text:String;
            var value:Number;
            var boundsBeforeAdd:Rectangle = labelContainer.getBounds(sp);
            
            if (data.isValueAxis) {
                value = getNumber(label);
                text = StringFormater.format(
                    value, 
                    ax.getStyle('labelFormat'), 
                    data.valueType
                );
            } else {
                text = StringFormater.format(
                    label, 
                    ax.getStyle('labelFormat'),
                    ax.getStyle('labelDataType')
                );
            }
            
            var lbl:Label = new Label(text);
            lbl.setStyles(_labelStyle);
            lbl.name = 'label' + idx;
            lbl.dataValue = value;
            labelContainer.addChildAt(lbl, 0);
            labels.push(lbl);
            
            lbl.setStyles(StyleUtil.mergeStyle(
                ax.styleSheet.getStyle('label'),
                {
                    'backgroundColor.hl' : '#29A5F7',
                    'color.hl' : '#FFFFFF'
                }
            ));
            lbl.updateNow();
            
            var pt:Point = getLabelPosition( lbl ,ax);
            lbl.x = pt.x;
            lbl.y = pt.y;
            
            modifyForTimeType(idx, data, lbl);
            
            if (_needFixForAxis || ax.getStyle('labelGap') === 'auto')
            {
                var labelBounds:Rectangle = lbl.getBounds(sp);
                if (labelBounds.intersects(boundsBeforeAdd)) {
                    isTempCreatedLabel[idx] = true;
                    labelContainer.removeChild(lbl);
                    labels.splice(labels.indexOf(lbl), 1);
                }
            }
            return lbl;
        }
        
        private function modifyForTimeType(idx:uint, data:AxisData, lbl:Label):void 
        {
            if (data.valueType == "time") {
                //解决Y轴为时间刻度时最大值显示当天的24:00:00点为00:00:00
                if ((idx == data.labels.length - 1) && (lbl.text == "00:00:00")) {
                    lbl.text = "24:00:00";
                }
                if ((idx == data.labels.length - 1) && (lbl.text == "00:00")) {
                    lbl.text = "24:00";
                }
            }
        }
        
        protected function getLabelPosition(lbl:Label, ax:AxisView):Point 
        {
            var pt:Point;
            var chart:Chart = ax.chart;
            var value:Number = lbl.dataValue;
            
            var idx:uint = getLabelIdx(lbl);
            var adjust:Number = ax.getStyle('labelPosition') === 'center' ? 0.5 : 0;
            var data:AxisData = ax.dataModel as AxisData;
            switch(data.direction) 
            {
                case AxisDirection.UP:
                case AxisDirection.DOWN:
                    if (data.isValueAxis) {
                        pt = chart.chartToViewXY(0, value);
                    } else {
                        pt = chart.chartToViewXY(idx + adjust, 0);
                        pt.y += chart.chartHeight;
                    }
                    
                    pt.x = tckPosNormal ? -tickLength - lbl.width : tickLength;
                    
                    pt.y -= (lbl.contentHeight >> 1);
                    break;
                    
                case AxisDirection.RIGHT:
                case AxisDirection.LEFT:
                    if (data.isValueAxis) {
                        pt = chart.chartToViewXY(0, value);
                    } else {
                        pt = chart.chartToViewXY(idx + adjust, 0);
                    }
                    var rot:Number = StyleUtil.getNumberStyle(ax, 'labelRotation');
                    if (rot) {
                        lbl.rotation = -rot;
                        var h:Number = rot == 90? lbl.contentHeight >> 1 : lbl.contentHeight;
                        pt.x = pt.x - lbl.width + h * Math.sin(rot / 180 * Math.PI);
                        pt.y = lbl.height;
                    } else {
                        pt.x -= lbl.width >> 1;
                        pt.y = tckPosNormal ? tickLength : -tickLength - lbl.height;
                    }
                    break;
            }
            if (_needFixForAxis)
            {
               pt = fixLabelPos(lbl, pt, ax, data);
            }
            return pt;
        }
        
        private function getLabelIdx(lbl:Label):uint 
        {
            return uint(lbl.name.substr(5));
        }
        
        private function fixLabelPos(lbl:Label, pt:Point, ax:AxisView, data:AxisData):Point
        {
            var idx:uint = getLabelIdx(lbl);
            var dir:uint = data.direction;
            var length:Number = data.length;
            if (!_range)
            {
                if (dir == AxisDirection.LEFT || dir == AxisDirection.RIGHT)
                {
                    _range = new Rectangle(ax.x, ax.y, length, ax.height);
                }
            }
            if (dir == AxisDirection.LEFT || dir == AxisDirection.RIGHT)
            {
                if (idx == 0)
                {
                    if (pt.x < _range.left)
                    {
                        pt.x = _range.left;
                    }
                }else if (idx == (data.labels.length-1))
                {
                    if (pt.x + lbl.contentWidth > _range.right)
                    {
                        pt.x = _range.right - lbl.contentWidth;
                    }
                }
            }
            return pt;
        }
        
        protected function highlightLabel(lbl:Label):void
        {
            if(lbl){
                lbl.state = 'hl';
                labelContainer.addChild(lbl);
            }
        }
        
        protected function clean():void 
        {
            ax     		= null;
            data   		= null;
            sp     		= null;
            grph   		= null;
            _range  	= null;
            _labelStyle = null;
        }
        
        protected function isLabelAvailableAt(idx:uint, host:AxisView):Boolean
        {   
            return shouldLabelsBeDrawed(host) && !(idx % (uint(host.getStyle('labelGap')) + 1));
        }

        protected function shouldLabelsBeDrawed(host:AxisView):Boolean
        {
            var labelStyle:Object = host.styleSheet.getStyle('label');
            return labelStyle['visibility'] != 'hidden';
        }
        
        protected function getNumber(label:String):Number
        {
            return Number(label.replace(/[^-.0-9e]/g, ''));
        }
        
        /* INTERFACE cn.alibaba.yid.chart.elements.axis.IAxisWithLabelPrinter */
        
        public function highlightLabelAt(host:AxisView, index:int):void
        {
            if(labelsAvailable){
                ax = host;
                data = ax.dataModel as AxisData;
                
                var label:Label = getLabelAt(index, host) || drawLabelAt(index);
                highlightLabel(label);
                
                ax = null;
                data = null;
            }
        }
        
        public function clearHighlightLabel(host:AxisView):void
        {
            var data:AxisData = host.dataModel as AxisData;
            var idx:int = data.highlightValue;
            if (idx >= 0) {
                var label:Label = getLabelAt(idx, host);
                if(label){
                    if (!isLabelAvailableAt(idx, host) || isTempCreatedLabel[idx]) {
                        label.parent.removeChild(label);
                    } else {
                        label.state = 'normal';
                    }
                }
            }
        }
        
        private function getLabelAt(index:int, host:AxisView):Label
        {
            labelContainer = host.content.getChildByName('labels') as Sprite;
            if (labelContainer) {
                return labelContainer.getChildByName('label' + index) as Label;
            }
            return null;
        }
    }

}
