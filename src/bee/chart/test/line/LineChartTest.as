package bee.chart.test.line
{
	import asunit.framework.TestCase;
	import asunit.textui.TestRunner;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class LineChartTest extends TestRunner
	{
		static public function getTestCase():TestCase
		{
			return new LineChartTestCase("testLineSwitchVisible");
		}
		
		public function LineChartTest()
		{
			doRun(getTestCase());
		}
	
	}

}
import asunit.framework.TestCase;
import cn.alibaba.product.chart.AliLineChart;
import bee.chart.abstract.CartesianChartViewer;
import bee.chart.abstract.Chart;
import bee.chart.abstract.ChartElement;
import bee.chart.events.ChartUIEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.setTimeout;

class LineChartTestCase extends TestCase
{
	private var data:XML = <chart>
			<data>
				<indexAxis name="月份">
					<labels>Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec</labels>
					<labelType>String</labelType>
				</indexAxis>
				<valueAxis name="温度" unit="度">
				</valueAxis>
				<dataSets>
					<set name="Tokyo">
						<values>7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6</values>
					</set>
					<set name="London">
						<values>3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8</values>
					</set>
				</dataSets>
			</data>
		</chart>;		
	
	private var chart:Chart;
	
	private var _eventDispatch:IEventDispatcher;
	static private const DELAY:Number = 5000;
	
	public function LineChartTestCase(testMethods:String = null)
	{
		super(testMethods);
	}
	
	override protected function setUp():void
	{
		super.setUp();
		chart = new AliLineChart();
		chart.parse(data);
		addChild(chart);
		chart.x = 500;
		_eventDispatch = new EventDispatcher();
	}
	
	override protected function tearDown():void
	{
		super.tearDown();
		chart.dispose();
		removeChild(chart);
		chart = null;
		_eventDispatch = null;
	}
	
	public function testLineSwitchVisible():void
	{
		//var lindxContent:DisplayObject = chart.view.getChildByName("lines");
		chart.setDatasetVisibility(0, false);
		
		chart.setDatasetVisibility(1, false);
		
		setTimeout(function():void
		{
			chart.setDatasetVisibility(0, true);
			
			chart.setDatasetVisibility(0, true);
			
			setTimeout(function():void
			{
				chart.setDatasetVisibility(0, false);
				chart.setDatasetVisibility(0, true);
				
				chart.setDatasetVisibility(1, false);
			},300);
		},300);
		var smoothingEndHandler:Function = function(e:ChartUIEvent):void
		{
			chart.removeEventListener(e.type, arguments.callee);
			dispatchCompleteEvent();
		}
		chart.addEventListener(ChartUIEvent.SMOOTHING_END, smoothingEndHandler);
		
		addAsyncHandler(function():void
		{
			assertTrue(chart.getDatasetVisibility(0));
			assertFalse(chart.getDatasetVisibility(1));
			var view:CartesianChartViewer = chart.view as CartesianChartViewer;
			var line:ChartElement;
			line = view.getElementByName("line0");
			//第1条线对应的control或view不可见
			assertTrue(line.visible || line.view.visible);
			//第2条线对应的control或view不可见
			line = view.getElementByName("line1");
			assertFalse(!line.visible || !line.view.visible);
		});
	}

	
	private function addAsyncHandler(fun:Function):void
	{
		_eventDispatch.addEventListener(Event.COMPLETE, addAsync(fun,DELAY));
	}
	
	private function dispatchCompleteEvent():void
	{
		_eventDispatch.dispatchEvent(new Event(Event.COMPLETE));
	}
}