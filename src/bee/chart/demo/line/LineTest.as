package bee.chart.demo.line
{
    import bee.chart.util.LineUtil;
    import flash.display.Graphics;
    import flash.display.GraphicsPathCommand;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.getTimer;
    import net.hires.debug.Stats;
    
    /**
     * 测试集中绘制线条方法的效率
     * @author jianping.shenjp
     */
    public class LineTest extends Sprite
    {
        private const WIDTH:Number = stage.stageWidth;
        private const HEIGHT:Number = stage.stageHeight;
        private var container:Shape = new Shape();
        private var coords:Vector.<Number> = new Vector.<Number>();
        
        //container.graphics.beginFill(0x442299);
        //var coords:Vector.<Number> = Vector.<Number>([132, 20, 46, 254, 244, 100, 20, 98, 218, 254]);
        //container.graphics.moveTo ( coords[0], coords[1] );
        //container.graphics.lineTo ( coords[2], coords[3] );
        //container.graphics.lineTo ( coords[4], coords[5] );
        //container.graphics.lineTo ( coords[6], coords[7] );
        //container.graphics.lineTo ( coords[8], coords[9] );
        //addChild( container );
        //var container:Shape = new Shape();
        //container.graphics.beginFill(0x442299);
        //var commands:Vector.<int> = Vector.<int>([1,2,2,2,2]);
        //var coords:Vector.<Number> = Vector.<Number>([132, 20, 46, 254, 244, 100, 20, 98, 218, 254]);
        //container.graphics.drawPath(commands, coords);
        //addChild( container );
        
        public function LineTest()
        {
            init();
            addChild(new Stats());
        }
        
        private function init():void
        {
            addChild(container);
            createData();
            for (var i:int = 0; i < 10; i++) 
            {
                setup();
                test1();
                tearDown();
                setup();
                test2();
                tearDown();
                setup();
                test3();
                tearDown();
                setup();
                test4();
                tearDown();
            }
        }
        
        private function createData():void
        {
            for (var i:int = 0; i < 5000; i++)
            {
                coords.push(Math.random() * WIDTH);
                coords.push(Math.random() * HEIGHT);
            }
        }
        
        private function setup():void
        {
            //container.graphics.beginFill(0x442299);
            container.graphics.lineStyle(0, 0xFF7300);
        }
        
        private function test1():void
        {
            var time:uint = getTimer();
            var g:Graphics = container.graphics;
            g.moveTo(coords[0], coords[1]);
            var numloop:int = coords.length;
            for (var i:int = 2; i < numloop; i = i + 2)
            {
                g.lineTo(coords[i], coords[i + 1]);
            }
            g.endFill();
            trace("time:", getTimer() - time);
        }
        
        private function test2():void
        {
            var time:uint = getTimer();
            var g:Graphics = container.graphics;
            var commands:Vector.<int> = new Vector.<int>();
            commands.push(GraphicsPathCommand.MOVE_TO);
            var numloop:int = coords.length;
            for (var i:int = 2; i < numloop; i = i + 2)
            {
                commands.push(GraphicsPathCommand.LINE_TO);
            }
            g.drawPath(commands, coords);
            g.endFill();
            trace("time2:", getTimer() - time);
        }
        
        private function test3():void 
        {
            var time:uint = getTimer();
            var dots:Vector.<Point> = new Vector.<Point>();
            var pt:Point;
            var numloop:int = coords.length;
            for (var i:int = 0; i < numloop; i = i + 2)
            {
                pt = new Point(coords[i], coords[i + 1]);
               dots.push(pt);
            }
            var g:Graphics = container.graphics;
            LineUtil.curveThrough(g, dots, 50); 
            trace("time3:", getTimer() - time);
        }
        
        private function test4():void 
        {
            var time:uint = getTimer();
            var dots:Vector.<Point> = new Vector.<Point>();
            var pt:Point;
            var numloop:int = coords.length;
            for (var i:int = 0; i < numloop; i = i + 2)
            {
                pt = new Point(coords[i], coords[i + 1]);
               dots.push(pt);
            }
            var g:Graphics = container.graphics;
            LineUtil.curveThrough(g, dots, 1); 
            trace("time4:", getTimer() - time);
        }
        
        private function tearDown():void
        {
            container.graphics.clear();
        }
    
    }

}