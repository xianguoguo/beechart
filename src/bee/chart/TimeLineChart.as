package bee.chart 
{
    import bee.chart.abstract.CartesianChart;
	import bee.chart.assemble.line.timeline.TimeLineChartView;
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class TimeLineChart extends CartesianChart 
	{
		
		/**
        * 如果要给LineChart指定自定义的Viewer和ChartData类型
        * 请使用 chart.setViewer 和 chart.chartModel.setData
        */
        public function TimeLineChart(pluginClz:Vector.<Class> = null) 
        {
            super(TimeLineChartView, null, pluginClz);
        }
		
	}

}