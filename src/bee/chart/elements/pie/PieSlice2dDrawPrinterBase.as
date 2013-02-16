package bee.chart.elements.pie
{
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.CComponent;
    import bee.abstract.IStatesHost;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.pie.PieSliceView;
    import bee.chart.util.TO_RADIANS;
    import bee.printers.IStatePrinter;
    import bee.printers.PrinterDecorator;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Matrix;
    
    /**
     * pie图表的圆饼绘制类(该类为默认配置)
     * @author jianping.shenjp
     */
    public class PieSlice2dDrawPrinterBase implements IStatePrinter
    {
        private var canvas:PieSliceCanvas;
        protected var data:PieSliceData;
        protected var view:PieSliceView;
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            view = host as PieSliceView;
            if (view && view.chart)
            {
                DisplayUtil.clearSprite(context);
                
                data = view.dataModel as PieSliceData;
                if (data && data.radius)
                {
                    drawPieSliceCanvas(view, context);
                    if (data.isGroup() && state == PieSliceStates.DETAIL)
                    {
                        (new PieSliceDetail()).showDetail(view as GroupPieSliceView);
                    }
                }
                
                var hlOffset:Number = Number(view.getStyle('offsetRadius'));
                if (hlOffset)
                {
                    var red:Number = data.getPositionRadian();
                    if (view.isRecodeWorkable())
                    {
                        red = view.getPositionRadian();
                    }
                    context.x = hlOffset * Math.cos(red);
                    context.y = hlOffset * Math.sin(red);
                }
                else
                {
                    context.x = context.y = 0;
                }
            }
            data = null;
            view = null;
            canvas = null;
        }
        
        /**
         * 绘制pieslice的绘图区
         * @param	view
         * @param	context
         */
        protected function drawPieSliceCanvas(view:PieSliceView, context:DisplayObjectContainer):void
        {
            canvas = createCanvas();    
            context.addChild(canvas);     
            
            drawBaseCanvas();
            drawInnerMask();
        }
        
        private function createCanvas():PieSliceCanvas 
        {
            var canvas:PieSliceCanvas = new PieSliceCanvas(data.radius, data.radian, data.startRadian);
            canvas.name = "canvas";
            canvas.x = data.pieSliceCanvasX;
            canvas.y = data.pieSliceCanvasY;
            
            //view.startRadian 为 -1 时，说明没有记录上一次的 startRadian
            var startRadian:Number = view.startRadian >= 0 ? view.startRadian : data.startRadian;
            
            canvas.rotation = startRadian / TO_RADIANS;
            return canvas;
        }
        
        protected function drawBaseCanvas():void 
        {
            var color:uint              = view.color;
            var alpha:Number            = StyleUtil.getNumberStyle(view, "pieSliceAlpha", 1);
            var frameThickness:Number   = StyleUtil.getNumberStyle(view, "frameThickness");
            var frameColor:uint         = StyleUtil.getColorStyle(view, "frameColor");   
            var base:Shape              = drawArcShape(0, 0, data.radius, view.angle, 0, color, alpha, frameThickness, frameColor);
            canvas.addChild(base);
        }
        
        protected function drawInnerMask():void 
        {
            if (!data.isGroup())
            {
                var donutThickness:Number = StyleUtil.getNumberStyle(view, 'donutThickness');
                if (donutThickness) {
                    donutThickness = donutThickness > data.radius ? data.radius : donutThickness;
                    var color:Number = StyleUtil.getColorStyle(view, 'donutMaskColor', false);
                    var alpha:Number = StyleUtil.getNumberStyle(view, 'donutMaskAlpha', 0.85);
                    var innerCover:Shape = drawArcShape(0, 0, data.radius - donutThickness, view.angle, 0, color, alpha);
                    canvas.addChild(innerCover);
                }
            }
        }
        
        /**
         * 绘制圆饼的方法
         * @param x x坐标
         * @param y y坐标
         * @param radius 半径
         * @param angle 度数
         * @param startForm 起始角度
         * @param color 颜色
         * @param pieSliceAlpha 透明度
         * @param frameThickness 边框粗细
         * @param frameColor 边框颜色
         * @return
         */
        private function drawArcShape(x:Number, y:Number, radius:Number, angle:Number, startFrom:Number=0, color:uint=1, alpha:Number=1, frameThickness:Number=0, frameColor:uint=0):Shape
        {
            var arc:Shape = new Shape();
            var g:Graphics = arc.graphics;
            g.beginFill(color, alpha);
            if (frameThickness > 0)
            {
                g.lineStyle(frameThickness, frameColor, alpha);
            }
            drawArc(g, x, y, radius, angle, startFrom);
            return arc;
        }
        
        /**
         * 绘制圆饼的算法
         * @param g Graphics
         * @param x x坐标
         * @param y y坐标
         * @param radius 半径
         * @param angle 度数
         * @param startForm 起始角度
         */
        private function drawArc(g:Graphics, x:Number, y:Number, radius:Number, angle:Number, startFrom:Number):void
        {
            g.moveTo(x, y);
            angle = (Math.abs(angle) > 360) ? 360 : angle;
            
            var n:Number = Math.ceil(Math.abs(angle) / 45);
            var angleA:Number = angle / n;
            angleA = angleA * TO_RADIANS;
            startFrom = startFrom * TO_RADIANS;
            g.lineTo(x + radius * Math.cos(startFrom), y + radius * Math.sin(startFrom));
            for (var i:int = 1; i <= n; i++)
            {
                startFrom += angleA;
                var anglea:Number = angleA / 2;
                var cosAnglea:Number = Math.cos(anglea);
                var angleMid:Number = startFrom - angleA / 2;
                var bx:Number = x + radius / cosAnglea * Math.cos(angleMid);
                var by:Number = y + radius / cosAnglea * Math.sin(angleMid);
                var cx:Number = x + radius * Math.cos(startFrom);
                var cy:Number = y + radius * Math.sin(startFrom);
                g.curveTo(bx, by, cx, cy);
            }
            if (angle != 360)
            {
                g.lineTo(x, y);
            }
            g.endFill();
        }
    
    }
}