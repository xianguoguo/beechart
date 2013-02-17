package bee.chart.demo 
{
	import cn.alibaba.product.chart.AliBarChart;
	import bee.chart.abstract.Chart;
	import bee.chart.events.ChartUIEvent;
	import flash.display.Sprite;
	
	/**
	 * 柱状图测试Focus和Blue事件
	 * @author jianping.shenjp
	 */
	public class Focus_Blue_Event_Bar_test extends Sprite 
	{
		
		public function Focus_Blue_Event_Bar_test() 
		{
            var chart:Chart = new AliBarChart();
            
			var data:String = '{"data":{"indexAxis":{"name":"日期","unit":"","labels":["04-05","04-06","04-07","04-08","04-09","04-10"]},"valueAxis":{"name":"无效关键词比例(%)","unit":"%","type":""},"dataSets":[{"name":"无效关键词比例(%)","values":[0,0,0,9.09,1.46,0]}]}}';
			chart.parse(data);

            chart.chartWidth = 850;
			chart.chartHeight = 390;
            addChild(chart);
			var dataObj:Object;
			var text:String;
			chart.addEventListener(ChartUIEvent.FOCUS_ITEM, function(e:ChartUIEvent):void {
				dataObj = e.data;
				text = returnDataTxt(dataObj);
				trace(ChartUIEvent.FOCUS_ITEM,"... "+text);
			});
			chart.addEventListener(ChartUIEvent.BLUR_ITEM, function(e:ChartUIEvent):void {
				dataObj = e.data;
				text = returnDataTxt(dataObj);
				trace("    ...",ChartUIEvent.BLUR_ITEM,"___ "+text);
			});
		}
		
		private function returnDataTxt(data:Object):String 
		{
			var txt:String = "";
			for (var name:String in data) 
			{
				txt += name +":" + data[name]+" ";
			}
			return txt;
		}
	}

}