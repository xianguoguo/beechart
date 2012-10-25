package bee.chart.demo 
{
    import bee.chart.release.BeePieChart;
    import bee.chart.abstract.Chart;
    import bee.chart.PieChart;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieChartDemo extends ChartDemo 
    {
        
        override protected function initChart():void 
            
        {
            var chart:Chart = new BeePieChart();
            addChild(chart);
            
            chart.chartWidth = 450;
            chart.chartHeight = 220;
            
            chart.loadCSS('../demo/v1.5/css/donut.css');
            chart.load('../demo/v1.5/data/3-serials.xml');
        }
        
    }

}