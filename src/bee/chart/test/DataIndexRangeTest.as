package bee.chart.test
{
	import asunit.textui.TestRunner;
	import asunit.framework.TestCase;
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class DataIndexRangeTest extends TestRunner
	{
		
		static public function getTestCase():TestCase
		{
			return new DataIndexRangeCase("testFunction,testFunction2,testError");
		}
		
		public function DataIndexRangeTest()
		{
			doRun(getTestCase());
		}
	}

}
import asunit.framework.TestCase;
import bee.chart.abstract.DataIndexRange;

class DataIndexRangeCase extends TestCase
{
	private var dataRange:DataIndexRange;
	
	public function DataIndexRangeCase(testMethods:String = null)
	{
		super(testMethods);
	}
	
	override protected function setUp():void
	{
		dataRange = new DataIndexRange();
	}
	
	override protected function tearDown():void
	{
		dataRange.dispose();
		dataRange = null;
	}
	
	public function testFunction():void
	{
		dataRange.initParameter(0, 10, 10);
		assertEquals(0,dataRange.rangeStart);
		assertEquals(10, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
		
		dataRange.rangeStart = 5;
		assertEquals(5,dataRange.rangeStart);
		assertEquals(10, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
		
		//设置错误的rangeStart
		dataRange.rangeStart = 10;
		assertEquals(5,dataRange.rangeStart);
		assertEquals(10, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
		
		dataRange.rangeEnd = 9;
		assertEquals(5,dataRange.rangeStart);
		assertEquals(9, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
		
		//设置错误的rangeEnd
		dataRange.rangeEnd = 11;
		assertEquals(5,dataRange.rangeStart);
		assertEquals(9, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
		
		dataRange.numData = 11;
		assertEquals(5,dataRange.rangeStart);
		assertEquals(9, dataRange.rangeEnd);
		assertEquals(11, dataRange.numData);
		
		dataRange.numData = 8;
		assertEquals(5,dataRange.rangeStart);
		assertEquals(8, dataRange.rangeEnd);
		assertEquals(8, dataRange.numData);
		
		dataRange.numData = 5;
		assertEquals(4,dataRange.rangeStart);
		assertEquals(5, dataRange.rangeEnd);
		assertEquals(5, dataRange.numData);
		
		dataRange.numData = 0;
		assertEquals(4,dataRange.rangeStart);
		assertEquals(5, dataRange.rangeEnd);
		assertEquals(5, dataRange.numData);
		
		dataRange.changeRangeBySelector(1, 6);
		assertEquals(4,dataRange.rangeStart);
		assertEquals(5, dataRange.rangeEnd);
		assertEquals(5, dataRange.numData);
		
		dataRange.rangeEnd = 4;
		dataRange.changeRangeBySelector(1, 5);
		assertEquals(1,dataRange.rangeStart);
		assertEquals(5, dataRange.rangeEnd);
		assertEquals(5, dataRange.numData);
	}
	
	
	public function testFunction2():void
	{
		dataRange.initParameter(0, 10, 10);
		dataRange.rangeEnd = 5;
		dataRange.offset(5);
		assertEquals(5,dataRange.rangeStart);
		assertEquals(10, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
		
		dataRange.offset(5);
		assertEquals(5,dataRange.rangeStart);
		assertEquals(10, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
		
		dataRange.offset(-6);
		assertEquals(5,dataRange.rangeStart);
		assertEquals(10, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
		
		dataRange.offset(-5);
		assertEquals(0,dataRange.rangeStart);
		assertEquals(5, dataRange.rangeEnd);
		assertEquals(10, dataRange.numData);
	}
	
	public function testError():void
	{
		assertThrows(ArgumentError, function():void {
			dataRange.initParameter(0, 0, 0);
			}
		);
		assertThrows(ArgumentError, function():void {
			dataRange.initParameter(-1, 0, 0);
			}
		);
		assertThrows(ArgumentError, function():void {
			dataRange.initParameter(0, 1, 0);
			}
		);
		assertThrows(ArgumentError, function():void {
			dataRange.initParameter(0, -1, 0);
			}
		);
		assertThrows(ArgumentError, function():void {
			dataRange.initParameter(0, 4, 3);
			}
		);
		assertThrows(ArgumentError, function():void {
			dataRange.initParameter(3, 3, 3);
			}
		);
	}
}