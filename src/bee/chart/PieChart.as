package bee.chart 
{
    import bee.chart.abstract.Chart;
    import bee.chart.assemble.pie.PieChartViewer;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public final class PieChart extends Chart 
    {
        
        /**
        * 如果要给PieChart指定自定义的Viewer和ChartData类型
        * 请使用 chart.setViewer 和 chart.chartModel.setData
        */
        public function PieChart(pluginClz:Vector.<Class>=null) 
        {
            super(PieChartViewer, null, pluginClz);
        }
        
    }

}