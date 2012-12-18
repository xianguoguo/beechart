package bee.chart.demo
{
    import bee.chart.release.BeeLineChart;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.assemble.line.LineChartEnterAnimator;
    import bee.chart.elements.line.LineSimplePrinter;
    import bee.chart.LineChart;
    import bee.chart.util.AutoColorUtil;
    import bee.plugins.IPlugin;
    import bee.plugins.line.LineChartEnterAnimatorPlugin;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import flash.utils.getTimer;
	import flash.utils.setTimeout;
    import net.hires.debug.Stats;

    /**
    * ...
    * @author hua.qiuh
    */
    public class LineChartDemo extends ChartDemo 
    {
        
        override protected function initChart():void 
        {
            //super.initChart();
            var chart:Chart = new BeeLineChart();
            
            //chart.load('../demo/data/data-xml-single.xml');
            //chart.loadCSS('../demo/css/single-dark.css');
            
            //chart.load('../demo/data/2-serials.xml');
            //chart.loadCSS('../demo/css/2-lines-light.css');
            
            //chart.load('../demo/data/2-serials.xml');
            //chart.loadCSS('../demo/css/2-lines-dark.css');
            
            //chart.load('../demo/data/data-xml-single.xml');
            //chart.loadCSS('../demo/css/single-dark-2.css');
            
            //chart.load('../demo/data/1-serial-with-null.xml');
            //chart.loadCSS('../demo/css/single-dark-2.css');
            
            chart.load('../demo/v1.5/data/time-label-data.xml');
            //chart.load('../demo/v1.5/data/time-serials.xml');
			//setTimeout(function():void{
				//chart.loadCSS('../demo/v1.5/css/single-dark.css');
			//}, 1000);
			//setTimeout(function():void{
				chart.loadCSS('../demo/v1.5/css/time-label-data.css');
			//}, 2000);
			
			//setTimeout(function():void {
				//chart.parseCSS('line {\
					//dropshadow      : none;\
					//lineMethod      : curve;\
					//thickness       : 2;\
					//fillType        : gradient;\
					//fillAlpha       : .3;\
					//dropshadow      : light;\
				//}');
			//},2000);
            //chart.loadCSS('../demo/css/ali-line.css');
            chart.chartWidth = 850;
			chart.chartHeight = 390;
            addChild(chart);
        }
        
        
    }

}