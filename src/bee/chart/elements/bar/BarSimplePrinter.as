package bee.chart.elements.bar 
{
	import cn.alibaba.util.ColorUtil;
	import cn.alibaba.util.DisplayUtil;
	import bee.abstract.IStatesHost;
	import bee.chart.abstract.ChartViewer;
	import bee.chart.elements.bar.BarView;
	import bee.controls.label.Label;
	import bee.printers.IStatePrinterWithUpdate;
	import bee.util.StyleUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
    
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarSimplePrinter implements IStatePrinterWithUpdate
    {
        protected var width:Number;
        protected var height:Number;
        protected var startX:Number;
        protected var startY:Number;
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            DisplayUtil.clearSprite(context);
            
            var barview:BarView     = host as BarView;
            var length:Number       = StyleUtil.getNumberStyle(barview, 'length');
            var thickness:Number    = StyleUtil.getNumberStyle(barview, 'thickness');
            
			addBar(barview, context, length, thickness);
			
            addLabel(barview, context, length, thickness);
        }
		
		private function addBar(barview:BarView, context:DisplayObjectContainer, length:Number, thickness:Number):void 
		{
			var model:BarModel      = barview.dataModel as BarModel;
            var horizontal:Boolean  = model.horizontal;
            var color:uint          = StyleUtil.getColorStyle(barview, 'color');
            var alpha:Number        = StyleUtil.getNumberStyle(barview, 'alpha', 1);
            var scale:Number        = StyleUtil.getNumberStyle(barview, 'thicknessScale', 1);
            var brFade:Number       = StyleUtil.getNumberStyle(barview, 'brightnessFading');
            
            //就算是没有数据，也画一根线
            if (Math.abs(length) < 1) {
                length = length >= 0 ? 1 : -1;
            }
            if (Math.abs(thickness) < 1) {
                thickness = thickness >= 0 ? 1 : -1;
            }
            
            var sp:Shape = new Shape();
            sp.name = "shape";
            var g:Graphics = sp.graphics;
            g.clear();
            var hasBorderThickness:Boolean = barview.hasStyle('borderThickness');
            var borderThickness:Number;
            if (hasBorderThickness) {
                var borderColor:uint = StyleUtil.getColorStyle(barview, 'borderColor');
                var borderAlpha:Number = StyleUtil.getNumberStyle(barview, 'borderAlpha', 1);
                borderThickness = Number(barview.getStyle('borderThickness'));
                g.lineStyle(borderThickness, borderColor, borderAlpha);
            }
			
            if (horizontal) {
                startX = 0;
                startY = thickness * (0.5 - scale / 2);
                width = length;
                height = thickness * scale;
            } else {
                startX = thickness * (0.5 - scale / 2);
                startY = -length;
                width = thickness * scale;
                height = length;
            }
			
            if (brFade) {
                var bottomColor:uint = ColorUtil.adjstRGBBrightness(color, brFade);
                var mtx:Matrix = new Matrix();
                mtx.createGradientBox(width, height, horizontal? Math.PI : Math.PI/2 , startX, startY);
                g.beginGradientFill( GradientType.LINEAR, [color, bottomColor], [alpha, alpha], [127, 255], mtx);
            } else {
                g.beginFill(color, alpha);
            }
            g.drawRect(startX, startY, width, height);
            g.endFill();
            
            if (hasBorderThickness)
            {
                addScale9Grid(sp,startX,startY,width,height,borderThickness);
            }

            sp.filters = StyleUtil.getFilterStyle(barview);
            context.addChild(sp);
		}
        
        private function addLabel(barview:BarView, context:DisplayObjectContainer, length:Number, thickness:Number):void 
        {
            if (barview.getStyle('valueVisibility') == 'visible') {
                var model:BarModel = barview.dataModel as BarModel;
                var horizontal:Boolean = model.horizontal;
                var lbl:Label = new Label(model.value.toString());
				context.addChild(lbl);
                lbl.name = "label";
                var labelStyle:Object = barview.styleSheet.getStyle('label');
                for (var each:String in labelStyle) {
                    if (/^inherit$/i.test(labelStyle[each])) 
                    {
                        labelStyle[each] = barview.getStyle(each);
                    } else {
                        var reg:RegExp = /inherit#(.+)/i;
                        var mtc:Array = String(labelStyle[each]).match(reg);
                        if (mtc) {
                            labelStyle[each] = barview.getStyle(mtc[1]);
                        }
                    }
                }
                lbl.setStyles(labelStyle);
                lbl.updateNow();
                if (horizontal) {
                    lbl.x = length;
                    lbl.y = (thickness - lbl.height) >> 1;
                } else {
                    lbl.x = (thickness - lbl.width) >> 1;
                    lbl.y = -length - lbl.height - 8;
                }
            }
        }
        
        /**
        * 给显示对象加入scale9Grid，保证放大缩小时，边框保持不变
        * @param	sp
        * @param	startX
        * @param	startY
        * @param	setW
        * @param	setH
        * @param	borderThickness
        */
        private function addScale9Grid(sp:Shape, startX:Number, startY:Number, setW:Number, setH:Number, borderThickness:Number):void 
        {
            if (setH>borderThickness && setW>borderThickness)
            {
                var grid:Rectangle = new Rectangle(startX+borderThickness/2,startY+borderThickness/2,setW-borderThickness,setH-borderThickness);
                sp.scale9Grid = grid; 
            }
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinterWithUpdate */
        
        public function smoothUpdate(host:IStatesHost,state:String, context:DisplayObjectContainer):void 
        {
            if (!context.numChildren) {
                renderState(host, state, context);
                return;
            }
            var barview:BarView = host as BarView;
            var shape:DisplayObject = context.getChildByName("shape");
            var w:Number = shape.width;
            var h:Number = shape.height;
            var chartview:ChartViewer = barview.chart.view as ChartViewer;
            var lbl:DisplayObject = context.getChildByName("label");
            var lblY:Number=0.0;
            if (lbl)
            {
                lblY = lbl.y;
            }
            renderState(host, state, context);
            shape = context.getChildByName("shape");
            if (shape)
            {
				TweenLite.killTweensOf(shape, true);
                TweenLite.from(
                    shape,
                    0.5,
                    {
                        width:w,
                        height:h,
                        onStart:function():void 
                        {
                            barview.state = 'normal';
                            chartview.isSmoothing = true;
                        },
                        onComplete:function():void 
                        {
                            chartview.isSmoothing = false;
                        }
                    }
                );
            }
          
            if (lbl)
            {
				TweenLite.killTweensOf(lbl, true);
                TweenLite.from(
                    lbl,
                    .5,
                    {
                        y:lblY
                    }
                );
            }
        }
    }

}