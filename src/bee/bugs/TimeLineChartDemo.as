package bee.bugs 
{
    import bee.chart.abstract.Chart;
	import bee.chart.assemble.line.timeline.TimeLineChartPrinter;
    import bee.chart.demo.ChartDemo;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.chart.LineChart;
    import bee.chart.release.BeeTimeLineChart;
	import flash.display.Sprite;
	import flash.display.StageQuality;
    import flash.events.Event;
    import net.hires.debug.Stats;
	
	/**
     * 数据少,index计算错误
     * @author hua.qiuh
     */
    public class TimeLineChartDemo extends ChartDemo 
    {
        
        public function TimeLineChartDemo() 
        {
			super();
        }
		
        override protected function initChart():void 
        {
            var chart:Chart = new BeeTimeLineChart();
            addChild(chart);
			chart.skin.statePrinter = new TimeLineChartPrinter();
			chart.chartWidth = 800;
            chart.chartHeight = 400;
			//chart.loadCSS('..-demo-css-single-dark.css');
            //chart.load('..-demo-data-data-xml-single.xml');
				
            chart.parse('{   "data" :{      "indexAxis" :{         "labels" :["2013-01-01", "2013-01-02", "2013-01-03", "2013-01-04", "2013-01-05"],         "name" :"时间"      },      "valueAxis" :{         "unit" :"个",         "name" :"安装数"      },      "dataSets" :[{         "values" :["49", "10", "4", "7", "13"],         "style" :{         },         "name" :"客户端安装柱状图"      }]   }} ');
            
        }
        
    }

}