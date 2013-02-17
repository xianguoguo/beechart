package bee.chart.demo 
{
    import cn.alibaba.util.ColorUtil;
    import bee.abstract.CComponent;
    import bee.chart.BarChart;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.assemble.bar.BarChartViewer;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.AutoColorUtil;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    import net.hires.debug.Stats;

	/**
    * 柱状图,只有单个Bar的时候（bug重现）
    * @author hua.qiuh
    */
    public class BarChartDemo5 extends Sprite
    {
        
        private var chart:BarChart;
        
        public function BarChartDemo5() 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            stage.align = 'TL';
            stage.scaleMode = 'noScale';
            
            //所有类型图表的CController都是同一个：Chart
            chart = new BarChart();
            addChild(chart);
            
            chart.parse('{"data":{"indexAxis":{"name":"日期","unit":"天","labels":["2011-11-25"]},"valueAxis":{"name":"展示数","unit":"次"},"dataSets":[{"name":"1024","values":[123]},{"name":"2048","values":[123]}]}}');
            //chart.load('../demo/v1.5/data/performance-trends.txt');
            chart.loadCSS('../demo/v1.5/css/from-suxu.css');
        }
        
        /**
		 * 清除数据的接口
		 * */
		public function dispose():void
		{
			(chart.view as CComponent).clearContent();
			chart.dispose();
			AutoColorUtil.reset();
//			Tooltip.instance.dispose();
			Tooltip.instance.styleSheet.clear();
		}
        
    }

}