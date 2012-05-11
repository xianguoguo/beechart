package bee.chart.demo
{
    import bee.abstract.CComponent;
    import bee.chart.PieChart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.data.DataCenter;
    import bee.chart.util.StyleLoader;
    import bee.util.YIDStyleSheet;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
	

	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class PieChartDemo2 extends Sprite
	{
		private var chart:PieChart;
		private var dataCenter:DataCenter;

		public function PieChartDemo2()
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;


			chart=new PieChart();
			dataCenter=new DataCenter(chart);
			//dataCenter.loadStyle("../styles/pieChart.css");

			var chartData:Vector.<ChartDataSet>=new Vector.<ChartDataSet>;
			var num:int=20;
			for (var i:int=0; i < num; i++)
			{

				var vec:Vector.<Number>=new Vector.<Number>();
				vec.push(10 * Math.random());
				var styleObject:Object;

//				styleObject={color:"#0xff0000"};
				styleObject={};

				chartData.push(new ChartDataSet("test_" + i, vec, {style: styleObject}));
			}
			dataCenter.setData(chartData);
			if (dataCenter.isLoadingStyle)
			{
				dataCenter.addEventListener(StyleLoader.LOADED, start);
			}
			else
			{
				start();
			}

			//读取css文件
//			var styleLoader:StyleLoader = new StyleLoader("../styles/chart.css",startChart);
//			styleLoader.start();

		}

		private function start(event:Event=null):void
		{
			dataCenter.removeEventListener(StyleLoader.LOADED, start);
			chart.state = ChartStates.NORMAL;
			addChild(chart);
			dispatchEvent(new Event("start"));
		}


		public function setStyleByName(styleName:String, styleObject:Object):void
		{
			dataCenter.setStyleByName(styleName, styleObject);
		}

		public function setStyle(cssString:String):void
		{
			dataCenter.setStyle(cssString);
			var styleSheet:YIDStyleSheet=new YIDStyleSheet();
			styleSheet.parseCSS(cssString);
			dataCenter.redrawChart(styleSheet);
		}

		/**
		 * 清除数据的接口
		 * */
		public function dispose():void{
			(chart.view as CComponent).clearContent();
			chart.dispose();
		}
		
		public function getName():String
		{
			return "jianping.shenjp";
		}
	}

}