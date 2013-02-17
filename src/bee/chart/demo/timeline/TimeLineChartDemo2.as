package bee.chart.demo.timeline 
{
    import bee.chart.abstract.Chart;
	import bee.chart.assemble.line.timeline.TimeLineChartPrinter;
    import bee.chart.demo.ChartDemo;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.chart.LineChart;
    import bee.chart.TimeLineChart;
	import flash.display.Sprite;
	import flash.display.StageQuality;
    import flash.events.Event;
    import net.hires.debug.Stats;
	
	/**
     * 长时间测试
     * 普通线条
     * @author hua.qiuh
     */
    public class TimeLineChartDemo2 extends ChartDemo 
    {
        
        public function TimeLineChartDemo2() 
        {
			super();
        }
		
        override protected function initChart():void 
        {
            var chart:Chart = new TimeLineChart();
            addChild(chart);
			chart.load("../demo/v1.6/data/small_data.json");
			chart.loadCSS("../demo/v1.6/css/timeline.css");
        }
        
    }

}