package bee.chart.demo.demo1dot5
{
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.PieChart;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.text.StyleSheet;
    import flash.utils.Timer;
	/**
    * ...
    * @author jianping.shenjp
    */
    public class PieChartSmoothDemo extends YIDDemoBase 
    {
        
        private var _timer:Timer = new Timer(1500);
        
        private var num:int = 10;
        
        public function PieChartSmoothDemo() 
        {
            super();
        }
        
        override protected function init(e:Event = null):void 
        {
            super.init(e);
            initTimer();
        }
        
        override protected function initChart():void 
        {
            super.initChart();
            chart = new PieChart(new <Class>[
            ]);
            addChild(chart);
            for (var i:int = 0; i < num; i++ ) {
                var vec:Vector.<Number>= new Vector.<Number>();
                vec.push(i==4 ? 100 :1);
                chart.data.addSet(new ChartDataSet("test_"+i, vec));
            }
            var styleSheet:StyleSheet = chart.styleSheet;
            styleSheet.setStyle('slice', {
                //'labelSetType'  : 'normal',
                'labelPosition':'callout'
            });
            styleSheet.setStyle('slice label', {
                'fontSize' : 20,
                'color' : '#FF0000'
            });
            styleSheet.setStyle('tooltip', {
                'tip'               : '#value# of #total#<br>#percent#'
            });
            styleSheet.setStyle('legend', {
                'position'      : 'bottom',
                'align'         : 'left',
                'paddingRight'  : 0
            });
            chart.setStyles({
                'colors': ["#A8CE55",
                        "#E9930F", 
                        "#4D99DA", 
                        "#CE5555", 
                        "#DCBB29",
                        "#55BECE",
                        "#AF80DE"].join(','),
                'animate':'clockwise',
                'smooth':true
            });
            
            chart.chartHeight = 400;
            chart.chartWidth = 400;
            chart.state = ChartStates.NORMAL;
        }
        
        override public function dispose():void 
        {
            super.dispose();
            _timer.stop();
            _timer = null;
        }
        
        private function initTimer():void 
        {
            _timer.addEventListener(TimerEvent.TIMER, clickHandler);
            _timer.start();
        }
        
        private function clickHandler(e:Event):void 
        {
            chart.data.clear();
            for (var i:int = 0; i < num; i++ ) {
                var vec:Vector.<Number>= new Vector.<Number>();
                vec.push((Math.random()*100)>>0 );
                chart.data.addSet(new ChartDataSet("test_"+i, vec));
            }
        }
        
    }

}