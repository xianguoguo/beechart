package bee.chart.test 
{
    import asunit.textui.TestRunner;
    import flash.display.Sprite;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class AllTest extends TestRunner
    {
        
        public function AllTest() 
        {
            start(YIDChartTestSuite);
        }
        
    }

}


import asunit.framework.TestSuite;
import bee.chart.test.*;
import bee.chart.test.line.LineChartTest;

class YIDChartTestSuite extends TestSuite {
    
    public function YIDChartTestSuite() 
    {
        addTest( GroupTest.getTestCase() );
        addTest( CartesianChartTest.getTestCase() );
        addTest( ColorGeneraterTest.getTestCase() );
        addTest( CSSTest.getTestCase() );
        addTest( StringFormaterTest.getTestCase() );
        addTest( FusionConverterTest.getTestCase() );
        addTest( DataIndexRangeTest.getTestCase() );
        addTest( LineChartTest.getTestCase() );
    }
}