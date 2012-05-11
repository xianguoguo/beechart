package bee.chart 
{
    import bee.chart.abstract.CartesianChart;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.assemble.bar.BarChartData;
    import bee.chart.assemble.bar.BarChartViewer;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public final class BarChart extends CartesianChart 
    {
        
        /**
        * 如果要给BarChart指定自定义的Viewer和ChartData类型
        * 请使用 chart.setViewer 和 chart.chartModel.setData
        */
        public function BarChart() 
        {
            super(BarChartViewer, BarChartData);
        }
        
        override protected function initChart():void 
        {
            super.initChart();
            CartesianChartData(data).addKeyValue(0);
        }
        
    }

}