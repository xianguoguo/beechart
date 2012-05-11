package bee.chart.test
{
    import bee.chart.elements.dot.Dot;
    import cn.alibaba.yid.chart.elements.dot.DotPool;
    import flash.display.Sprite;
    import flash.utils.getTimer;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class DotTest extends Sprite
    {
        private var _dots:Vector.<Dot>;
        private const DOT_NUM:uint = 6000;
        private const WIDTH:Number = stage.stageWidth;
        private const HEIGHT:Number = stage.stageHeight;
        
        
        public function DotTest()
        {
            DotPool.initialize(500, 100);
           for (var i:int = 0; i < 10; i++) 
           {
               testTime();
           }
        }
        
        private function testTime():void 
        {
            setup();
            test();
            tearDown();
        }
        
        private function setup():void 
        {
            _dots = new Vector.<Dot>();
        }
        
        private function test():void 
        {
            var time:uint = getTimer();
            for (var i:int = 0; i < DOT_NUM; i++)
            {
                var dot:Dot = getNewDot();
                dot.x = WIDTH * Math.random();
                dot.y = HEIGHT * Math.random();
                addChild(dot);
                _dots.push(dot);
            }
            trace("usetime:", getTimer() - time);
        }
        
        private function tearDown():void 
        {
            for each(var dot:Dot in _dots)
            {
                //dot.dispose();
                DotPool.disposedDot(dot);
                removeChild(dot);
            }
        }
        
        private function getNewDot():Dot
        {
            //var dot:Dot = new Dot();
            var dot:Dot = DotPool.getDot();
            dot.setStyle("radius", Math.random() * 10 + "");
            dot.setStyle("color", Math.random() * 0xFFFFFF + "");
            dot.setStyle("alpha", Math.random() * 1 + "");
            dot.setStyle("borderAlpha", Math.random() * 1 + "");
            dot.setStyle("borderColor", Math.random() * 0xFFFFFF + "");
            dot.setStyle("borderThickness", Math.random() * 1 + "");
            return dot;
        }
    }

}