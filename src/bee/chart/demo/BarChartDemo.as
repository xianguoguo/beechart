package bee.chart.demo 
{
    import cn.alibaba.product.chart.AliBarChart;
    import bee.chart.abstract.Chart;
    import bee.chart.HBarChart;
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarChartDemo extends ChartDemo
    {
        
        override protected function initChart():void 
        {
            var chart:Chart = new AliBarChart();
            addChild(chart);
            
            chart.load('../demo/v1.5/data/3-serials.xml');
            chart.loadCSS('../demo/v1.5/css/ali-bar.css');
        }
        
    }

}