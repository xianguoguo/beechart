package bee.chart.demo 
{
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.BarChart;
    import flash.display.Sprite;
    import flash.events.Event;
    import net.hires.debug.Stats;
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarChartDemo6_Fail extends Sprite
    {
        
        public function BarChartDemo6_Fail() 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            stage.align = 'TL';
            stage.scaleMode = 'noScale';
            
            //所有类型图表的CController都是同一个：Chart
            var chart:BarChart = new BarChart();
            var data:CartesianChartData = chart.data as CartesianChartData;
            
            //chart.chartWidth = 500;
            
            //chart.skin.performer = new BarChartEnterAnimator();
            addChild(chart);
            
            //chart.parse(<chart status="fail" msg="TEST: message" />.toXMLString());
            chart.parse('{ "status": "fail", "msg": "<p><b>TEST: message</b></p><p>抱歉未能获取数据</p>" }');
            
            stage.addChild( new Stats() );
        }
        
    }

}