package bee.chart 
{
    import bee.chart.abstract.CartesianChart;
    import bee.chart.assemble.line.SuperLineChartViewer;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public final class LineChart extends CartesianChart 
    {
        
        /**
        * 如果要给LineChart指定自定义的Viewer和ChartData类型
        * 请使用 chart.setViewer 和 chart.chartModel.setData
        */
        
        public function LineChart(pluginClz:Vector.<Class> = null) 
        {
            super(SuperLineChartViewer,null,pluginClz);
        }
        
    }

}