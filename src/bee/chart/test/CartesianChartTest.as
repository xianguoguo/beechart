package bee.chart.test
{
    import asunit.framework.TestCase;
	import asunit.textui.TestRunner;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class CartesianChartTest extends TestRunner 
    {
        static public function getTestCase():TestCase
        {
            return new CartesianChartTestCase("testLocation, testHorizontal");
        }
        
        
        public function CartesianChartTest() 
        {
            doRun( getTestCase() );
        }
        
    }

}
import asunit.framework.TestCase;
import bee.chart.abstract.CartesianChart;
import bee.chart.abstract.CartesianChartData;
import bee.chart.abstract.CartesianChartViewer;
import bee.chart.abstract.Chart;
import bee.chart.abstract.ChartDataSet;
import flash.geom.Point;
class CartesianChartTestCase extends TestCase
{
    private var _viewer:CartesianChartViewer;
	private var chart:CartesianChart;
    
    public function CartesianChartTestCase(testMethods:String = null)
    {
        super(testMethods);
    }
    
    override protected function setUp():void 
    {
        chart = new CartesianChart();
        chart.chartWidth = 500;
        chart.chartHeight = 300;
        var dSet:ChartDataSet = new ChartDataSet("", 
            new <Number>[1, 3, 4, 5, 9, 20]
        );
        chart.data.addSet(dSet);
        _viewer = chart.view as CartesianChartViewer;
		addChild(chart);
		_viewer.updateNow();
    }
    
    override protected function tearDown():void 
    {
        chart.dispose();
		removeChild(chart);
        _viewer = null;
    }
    
    public function testLocation():void
    {
        assertTrue(_viewer.chartToViewXY(0, 0).equals(new Point()));
        assertTrue(_viewer.viewToChartXY(0, 0).equals(new Point(0, 0)));
        assertEquals(100, _viewer.chartToViewXY(1, 1).x);
        assertEquals(-12, _viewer.chartToViewXY(1, 1).y);
    }
    
    public function testHorizontal():void 
    {
        _viewer.horizontal = true;
        assertTrue(_viewer.horizontal);
        assertTrue(_viewer.chartToViewXY(0, 0).equals(new Point(0, -300)));
        assertTrue(_viewer.chartToViewXY(5, 0).equals(new Point(0, 0)));
        
        var maxTick:Number = CartesianChartData(_viewer.chartModel.data).maxTickValue;
        assertTrue(_viewer.chartToViewXY(0, 1).equals(new Point(500 / maxTick, -300)));
        assertTrue(_viewer.chartToViewXY(0, 2).equals(new Point(1000 / maxTick, -300)));
        assertTrue(_viewer.viewToChartXY(0, 0).equals(new Point(5, 0)));
        assertTrue(_viewer.viewToChartXY(0, -300).equals(new Point(0, 0)));
        assertTrue(_viewer.viewToChartXY(500, -300).equals(new Point(0, maxTick)));
        assertTrue(_viewer.viewToChartXY(500, 0).equals(new Point(5, maxTick)));
    }
}