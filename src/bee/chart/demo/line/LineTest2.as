package bee.chart.demo.line
{
    import asunit.errors.AbstractError;
    import bee.chart.util.LineUtil;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.getTimer;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class LineTest2 extends Sprite
    {
        
        private const WIDTH:Number = stage.stageWidth;
        private const HEIGHT:Number = stage.stageHeight;
        private var container:Shape = new Shape();
        private var container2:Shape = new Shape();
        private var coords:Vector.<Number> = new Vector.<Number>();
        
        public function LineTest2()
        {
            super();
            init();
        }
        
        private function init():void
        {
            createData();
            draw1();
            draw2();
        }
        
        private function createData():void
        {
            coords.push(10, 10);
            coords.push(50, 50);
            coords.push(100, 0);
            //coords.push(150, 10);
        }
        
        private function draw1():void
        {
            var time:uint = getTimer();
            addChild(container);
            var dots:Vector.<Point> = new Vector.<Point>();
            var pt:Point;
            var numloop:int = coords.length;
            for (var i:int = 0; i < numloop; i = i + 2)
            {
                pt = new Point(coords[i], coords[i + 1]);
                dots.push(pt);
            }
            var g:Graphics = container.graphics;
            g.lineStyle(0, 0xFF0000);
            LineUtil.curveThrough(g, dots, 10);
            trace("time3:", getTimer() - time);
        }
        
        //巴塞尔曲线
        private function draw2():void
        {
            var time:uint = getTimer();
            addChild(container2);
            container2.x = 200;
            var dots:Vector.<Point> = new Vector.<Point>();
            var pt:Point;
            var numloop:int = coords.length;
            for (var i:int = 0; i < numloop; i = i + 2)
            {
                pt = new Point(coords[i], coords[i + 1]);
                dots.push(pt);
            }
            var g:Graphics = container2.graphics;
            g.lineStyle(0, 0x0000FF);
            drawCurve(g, dots);
            trace("time3:", getTimer() - time);
        }
        
        private function drawCurve(g:Graphics, dots:Vector.<Point>):void
        {
            var p0:Point = dots[0];
            var p1:Point = dots[1];
            var p2:Point = dots[2];
            var cx:Number = 2 * p1.x + (p0.x + p2.x) * 0.5;
            var cy:Number = 2 * p1.y + (p0.y + p2.y) * 0.5;
            g.moveTo(p0.x, p0.y);
            g.curveTo(cx, cx, p2.x, p2.y);
            g.endFill();
        }
    
    /*   private function drawCurve(g:Graphics, dots:Vector.<Point>):void
       {
       var numloop:int = dots.length;
       g.moveTo(dots[0].x, dots[0].y);
       var i:int = 0;
       for (i = 0; i < numloop - 1; i++)
       {
       //var dx:Number = (dots[i].x + dots[i + 1].x) * 0.5;
       //var dy:Number = (dots[i].y + dots[i + 1].y) * 0.5;
       var dx:Number = (dots[i].x + dots[i + 1].x) * 0.5;
       var dy:Number = (dots[i].y + dots[i + 1].y) * 0.5;
       var cx:Number = dx * 2 - (dots[i].x + dots[i + 1].x) / 2;
       var cy:Number = dy * 2 - (dots[i].y + dots[i + 1].y) / 2;
       trace(dx,dy,cx,cy);
       //g.curveTo(dots[i+1].x, dots[i+].y, dx, dy);
       g.curveTo(cx, cy, dots[i + 1].x, dots[i + 1].y);
       }
       //g.curveTo(dots[i].x, dots[i].y, dots[i +1].x, dots[i + 1].y);
       g.endFill();
     }*/
    
        //private function drawCurve(g:Graphics, dots:Vector.<Point>):void 
        //{
        //var numloop:int = dots.length;
        //g.moveTo(dots[0].x, dots[0].y);
        //var i:int = 0;
        //for ( i = 1; i < numloop - 2; i += 2) 
        //{
        //var dx:Number = (dots[i].x + dots[i + 1].x) * 0.5;
        //var dy:Number = (dots[i].y + dots[i + 1].y) * 0.5;
        //g.curveTo(dots[i].x, dots[i].y, dx, dy);
        //}
        //g.curveTo(dots[i].x, dots[i].y, dots[i +1].x, dots[i + 1].y);
        //g.endFill();
        //}
    
    }

}