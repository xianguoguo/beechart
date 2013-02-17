package bee.chart.test 
{
    import asunit.framework.TestCase;
	import asunit.textui.TestRunner;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class FusionConverterTest extends TestRunner 
    {
        
        static public function getTestCase():TestCase
        {
            return new FusionConvertTestCase("testLineBasic");
        }
        
        public function FusionConverterTest() 
        {
            doRun( getTestCase() );
        }
        
    }

}

import asunit.framework.TestCase;
import bee.chart.abstract.ChartDataSet;
import bee.chart.LineChart;
import bee.chart.util.FusionConverter;

class FusionConvertTestCase extends TestCase
{
    public function FusionConvertTestCase(methods:String = null)
    {
        super(methods);
    }
    
    public function testLineBasic():void
    {
        var data:XML = 
        <graph 	caption="Daily Visits" 
                    subcaption="(from 8/6/2006 to 8/12/2006)" 
                    lineThickness="1" 
                    showValues="0" 
                    formatNumberScale="0" 
                    anchorRadius="2" 
                    divLineAlpha="20" 
                    divLineColor="CC3300" 
                    showAlternateHGridColor="1" 
                    alternateHGridColor="CC3300" 
                    shadowAlpha="40"  
                    numvdivlines="5" 
                    chartRightMargin="35" 
                    bgColor="FDF5F3" 
                    alternateHGridAlpha="5" 
                    limitsDecimalPrecision='0' 
                    divLineDecimalPrecision='0' 
                    decimalPrecision="0">

            <categories>
                <category name="8/6/2006"/>
                <category name="8/7/2006"/>
                <category name="8/8/2006"/>
                <category name="8/9/2006"/>
                <category name="8/10/2006"/>
                <category name="8/11/2006"/>
                <category name="8/12/2006"/>
            </categories>

            <dataset seriesname="Offline Marketing" color="1D8BD1" anchorBorderColor="1D8BD1" anchorBgColor="1D8BD1">
                <set value="1327"/>
                <set value="1826"/>
                <set value="1699"/>
                <set value="1511"/>
                <set value="1904"/>
                <set value="1957"/>
                <set value="1296"/>
            </dataset>

            <dataset seriesName="Search" color="F1683C" anchorBorderColor="F1683C" anchorBgColor="F1683C">
                <set value="2042"/>
                <set value="3210"/>
                <set value="2994"/>
                <set value="3115"/>
                <set value="2844"/>
                <set value="3576"/>
                <set value=""/>
            </dataset>

            <dataset seriesName="Paid Search" color="2AD62A" anchorBorderColor="2AD62A" anchorBgColor="2AD62A">
                <set value="850"/>
                <set value="1010"/>
                <set value="1116"/>
                <set value="1234"/>
                <set value="1210"/>
                <set value="1054"/>
                <set value="802"/>
            </dataset>

            <dataset seriesName="From Mail" color="DBDC25" anchorBorderColor="DBDC25" anchorBgColor="DBDC25">
                <set value="541"/>
                <set value="781"/>
                <set value="920"/>
                <set value="754"/>
                <set value="840"/>
                <set value="893"/>
                <set value="451"/>
            </dataset>

        </graph>;
        
        var chart:LineChart = new LineChart();
        chart.parse(FusionConverter.convertXML(data));
        var dataSet:ChartDataSet;
        
        assertEquals(4, chart.data.dataSetCount);
        
        dataSet = chart.data.allSets[0];
        assertEquals(data.dataset[0].@seriesname, dataSet.name);
        assertEqualsArrays([1327, 1826, 1699, 1511, 1904, 1957, 1296], dataSet.values.join(',').split(','));
        
        dataSet = chart.data.allSets[1];
        assertEquals(data.dataset[1].@seriesName, dataSet.name);
        assertEqualsArrays([2042, 3210, 2994, 3115, 2844, 3576], dataSet.values.join(',').split(',').slice(0, 6));
        assertTrue( isNaN(dataSet.values[6]) );
        
    }
}