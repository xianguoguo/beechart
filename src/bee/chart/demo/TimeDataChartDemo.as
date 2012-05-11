package bee.chart.demo 
{
	import cn.alibaba.product.chart.AliLineChart;
	import bee.chart.abstract.Chart;
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class TimeDataChartDemo extends ChartDemo 
	{
		
		public function TimeDataChartDemo() 
		{
			
		}
		
		override protected function initChart():void 
        {
            var chart:Chart = new AliLineChart();
            
            //chart.load('../demo/v1.5/data/time-serials.xml');
            chart.load('../demo/v1.5/data/time-label-data.xml');

            chart.chartWidth = 850;
			chart.chartHeight = 390;
            addChild(chart);
        }
	}

}