package bee.chart.demo
{
	import bee.chart.abstract.Chart;
	import bee.chart.assemble.line.LineChartEnterAnimator;
	import bee.chart.LineChart;
	import bee.chart.util.FusionConverter;
	import bee.plugins.line.LineChartEnterAnimatorPlugin;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import net.hires.debug.Stats;

    /**
    * ...
    * @author hua.qiuh
    */
    public class LineChartDemo7 extends Sprite 
    {
        
        public function LineChartDemo7():void 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            stage.align = 'TL';
            stage.scaleMode = 'noScale';
            
            var t:uint = getTimer();
            
            var chart:Chart = new LineChart(new <Class>[LineChartEnterAnimatorPlugin]);
            //var chart:Chart = new BarChart();
            addChild(chart);
            var fcData:XML = 
            < graph 	caption = "Daily Visits" 
                    xAxisName="Date"
                    yAxisName="Value"
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

                <dataset seriesName="Offline Marketing" color="1D8BD1" anchorBorderColor="1D8BD1" anchorBgColor="1D8BD1">
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
                    <set value="1862"/>
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
            
           

            //设置图表的尺寸，图表的主体将会显示在这个范围内
            chart.chartWidth = 500;
            chart.chartHeight = 250;
            chart.skin.performer = new LineChartEnterAnimator();
            chart.parse(FusionConverter.convertXML(fcData));
            //chart.state = ChartStates.NORMAL;
            
            trace('3: Time Elapsed:', getTimer() - t, 'ms');
            
            stage.addChild( new Stats() );
            
        }
        
        
        
    }

}