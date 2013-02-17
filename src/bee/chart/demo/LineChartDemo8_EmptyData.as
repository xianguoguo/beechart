package bee.chart.demo 
{
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.LineChart;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import net.hires.debug.Stats;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LineChartDemo8_EmptyData extends Sprite
    {
        
        public function LineChartDemo8_EmptyData() 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            
            //所有类型图表的CController都是同一个：Chart
            var chart:LineChart = new LineChart();
            var data:ChartData = chart.data;            
            addChild(chart);
            //chart.parse(new XML());
            chart.loadCSS("line-demo3.css");
            //chart.load("empty.xml");
            chart.load("twice_1.xml");
            
            stage.addChild( new Stats() );
            
        }
        
    }

}