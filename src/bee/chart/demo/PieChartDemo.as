package bee.chart.demo 
{
    import cn.alibaba.product.chart.AliPieChart;
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
            
            var chart:Chart = new AliPieChart();
            addChild(chart);
            
            chart.chartWidth = 450;
            chart.chartHeight = 220;
            
            chart.loadCSS('../demo/v1.5/css/donut.css');
            chart.load('../demo/v1.5/data/3-serials.xml');
        }
        
    }

}