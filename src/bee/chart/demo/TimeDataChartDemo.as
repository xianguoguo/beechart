package bee.chart.demo 
{
    import bee.chart.events.ChartEvent;
    import bee.chart.events.ChartUIEvent;
    import bee.chart.events.ParserEvent;
    import bee.chart.release.BeeLineChart;
    import bee.chart.abstract.Chart;
    import bee.chart.release.BeeTimeLineChart;
    import flash.utils.setTimeout;
    /**
     * ...
     * @author jianping.shenjp
     */
    public class TimeDataChartDemo extends ChartDemo 
    {
        
        public function TimeDataChartDemo() 
        {
            
        }
        
        override protected function initChart():void 
        {
            var chart:Chart = new BeeTimeLineChart();
            
            //chart.load('../demo/v1.5/data/time-serials.xml');
            //chart.load('../demo/v1.5/data/time-label-data.xml');
            var data:XML = <chart>
                                <data>
                                    <indexAxis name="月份">
                                        <labels>
                                            Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
                                        </labels>
                                    </indexAxis>
                                    <valueAxis name="温度" unit="度"></valueAxis>
                                    <dataSets>
                                        <set name="Tokyo">
                                            <values>
                                            7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6
                                            </values>
                                        </set>
                                        <set name="London">
                                            <values>
                                            3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8
                                            </values>
                                        </set>
                                    </dataSets>
                                </data>
                            </chart>;
            var css:String = "chart {\
                colors          : #E34F1E,#84BC0D,#00ABD9,#FF00A8;\
                paddingRight    : 2;\
                paddingLeft     : 2;\
                smooth:true;\
            }\
            line {\
                thickness.active : 3;\
            }\
            line dot {\
                radius          : 4;\
                color           : inherit;\
                borderThickness : null;\
                borderThickness.hl : 8;\
                borderAlpha     : .5;\
                borderColor     : inherit#color;\
            }\
            xAxis {\
                labelGap        : auto;\
                tickLength      : 0;\
                lineThickness   : 0;\
            }\
            yAxis {\
                tickLength      : 0;\
                lineThickness   : 0;\
            }\
            canvas {\
                backgroundColor : #2B2929;\
                priLineThickness: 1;\
                priLineColor    : #303030;\
                priLineAlpha    : 1;\
                secLineThickness: 1;\
                secLineColor    : #303030;\
            }\
            tooltip {\
                backgroundType  : simple;\
                color           : #FFFFFF;\
                backgroundColor : #000000;\
                borderThickness : null;\
                backgroundAlpha : .8;\
            }\
            legend {\
                position        : bottom;\
                align           : center\
            }"
            //chart.chartWidth = 850;
            //chart.chartHeight = 390;
            chart.addEventListener(ChartEvent.SWF_READY, function(event:ChartEvent):void {
                trace("!!!!!!!!!!!!!!!!!!!!");
                chart.parse(data);
                chart.parseCSS(css);
            });
            chart.addEventListener(ParserEvent.DATA_PARSED, function():void {
                setTimeout(function():void {
                    trace("~~~~~~~~~~~~~~~~");
                    chart.setDatasetVisibility(0,false);
                },100);
            });
            addChild(chart);
        }
    }

}