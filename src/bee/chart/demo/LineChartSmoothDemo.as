package bee.chart.demo
{
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.elements.line.Line;
    import bee.chart.elements.line.LineData;
    import bee.chart.LineChart;
    import bee.chart.util.LineUtil;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.text.StyleSheet;
    import flash.utils.Timer;
    import net.hires.debug.Stats;

    /**
     * 连线平滑过渡例子
     * @author hua.qiuh
     */
    public class LineChartSmoothDemo extends Sprite
    {

        private var line:Line;

        private var btn:Sprite;

        private var num_dot:int = 10; //点的数量

        private var dot_dist:Number = 30; //点的距离

        private var _timer:Timer = new Timer(1500);
        
        private var uid:int = 0;
        
        public function LineChartSmoothDemo():void
        {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event=null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            stage.align = 'TL';
            stage.scaleMode = 'noScale';

            initChart();
            initBtn();
            initTimer();
        }

        private function initChart():void
        {
            //所有类型图表的CController都是同一个：Chart
            line = new Line();
            line.x = line.y = 200;
            var lnData:LineData = new LineData();
            var dotPositions:Vector.<Point> = new Vector.<Point>();
            for (var i:int = 1; i <= num_dot; i++)
            {
                dotPositions.push(new Point(i * dot_dist, LineUtil.handleNumberForFlashPos(i * dot_dist * Math.random())));
            }
            lnData.dotPositions = dotPositions;
            line.setModel(lnData);

            line.setStyle('smooth', 'true');
            addChild(line);
            line.state = 'normal';
            //stage.addChild( new Stats() );
        }

        private function initBtn():void
        {
            btn = new Sprite();
            var g:Graphics = btn.graphics;
            g.beginFill(0xFF0000);
            g.drawRect(0, 0, 50, 50);
            g.endFill();
            addChild(btn);
            btn.x = 500;
            btn.addEventListener(MouseEvent.CLICK, clickHandler);
        }

        private function initTimer():void 
        {
            _timer.addEventListener(TimerEvent.TIMER, clickHandler);
            //_timer.start();
        }
        
        private function clickHandler(e:Event):void
        {
            trace(uid,"....................................................................................");
            var lnData:LineData = line.model as LineData;
            var dotPositions:Vector.<Point> = new Vector.<Point>();
            for (var i:int = 1; i <= num_dot; i++)
            {
                dotPositions.push(new Point(i * dot_dist, LineUtil.handleNumberForFlashPos(i * dot_dist * Math.random())));
            }
            
            lnData.dotPositions = dotPositions;
            uid++;
        }
    }

}