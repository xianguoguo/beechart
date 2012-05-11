package bee.chart.demo 
{
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.LineChart;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import net.hires.debug.Stats;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LineChartDemo9_decNumber extends Sprite
    {
        
        public function LineChartDemo9_decNumber() 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            
            //所有类型图表的CController都是同一个：Chart
            var chart:LineChart = new LineChart();
            var data:ChartData = chart.data;            
            addChild(chart);
            chart.parse(
                <chart>
                    <data>
                        <indexAxis name="月份" unit="">
                            <labels>1月, 2月, 3月, 4月, 5月, 6月, 7月, 8月, 9月</labels>
                        </indexAxis>
                        <valueAxis name="营业额" unit="亿元" />
                        <dataSets>
                            <set name="A公司">
                                <values>0,0,0.8,0,0</values>
                                <style>
                                    <item name="color" value="#F7B521" />
                                </style>
                            </set>
                        </dataSets>
                    </data>
                    <css>
                        <![CDATA[
                            canvas {
                                backgroundColor   : #FFFFFF;
                                backgroundColor2  : #E4F2F5;
                                backgroundAlpha   : 1;
                                gridColor         : #29A5F7;
                            }
                            
                            line {
                                thickness         : 3;
                                alpha	            : 1;
                                thickness.active  : 5;
                                lineMethod        : curve;
                            }
                            
                            line dot label {
                                visibility        : visible;
                                color             : #333333;
                            }
                            
                            Line dot {
                                radius.hl : 7;
                            }
                            
                            yAxis {
                                tickColor     : #666666;
                                lineThickness : null;
                                tickThickness : null;
                            }
                            
                            xAxis {
                                lineThickness : 2;
                                tickThickness : null;
                            }
                            
                            legend {
                                position      : bottom;
                                align         : center;
                            }
                            
                            legend label {
                                color         : #333333;
                            }
                            
                            chart {
                                rightAxisVisibility : hidden;
                                leftAxisVisibility  : visible;
                                paddingBottom : 16;
                                enableMouseTrack : true;
                                enableTooltip: true;
                                width: 500;
                                height: 250;
                            }
                        ]]>
                    </css>
                </chart>
            );
            
            stage.addChild( new Stats() );
            
        }
        
    }

}