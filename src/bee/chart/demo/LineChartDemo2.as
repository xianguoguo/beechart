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
    * y轴数据自动生成，小数点过长bug
    * @author hua.qiuh
    */
    public class LineChartDemo2 extends Sprite
    {
        
        public function LineChartDemo2() 
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
            addChild(chart);
            var data:ChartData = chart.data;
            //chart.parse(
                //<chart>
                    //<data>
                        //<indexAxis name="月份" unit="">
                            //<labels>1月, 2月, 3月, 4月, 5月, 6月, 7月, 8月, 9月</labels>
                        //</indexAxis>
                        //<valueAxis name="营业额" unit="亿元" />
                        //<dataSets>
                            //<set name="A公司">
                                //<values></values>
                                //<style>
                                    //<item name="color" value="#F7B521" />
                                //</style>
                            //</set>
                            //<set name="B公司">
                                //<values>59, 39, 64, 65, 66, 66, 69, 69, 71</values>
                                //<style>
                                    //<item name="color" value="#9CDE29" />
                                //</style>
                            //</set>
                            //<set name="C公司">
                                //<values>39, 39, 43,44,45,45,44,43,43</values>
                                //<style>
                                    //<item name="color" value="#4AADF7" />
                                //</style>
                            //</set>
                        //</dataSets>
                    //</data>
                    //<css>
                        //<![CDATA[
                            //canvas {
                                //backgroundColor   : #FFFFFF;
                                //backgroundColor2  : #E4F2F5;
                                //backgroundAlpha   : 1;
                                //gridColor         : #29A5F7;
                            //}
                            //
                            //line {
                                //thickness         : 3;
                                //alpha	            : 1;
                                //thickness.active  : 5;
                                //lineMethod        : curve;
                            //}
                            //
                            //line dot label {
                                //visibility        : visible;
                                //color             : #333333;
                            //}
                            //
                            //Line dot {
                                //radius.hl : 7;
                            //}
                            //
                            //yAxis {
                                //tickColor     : #666666;
                                //lineThickness : null;
                                //tickThickness : null;
                            //}
                            //
                            //xAxis {
                                //lineThickness : 2;
                                //tickThickness : null;
                            //}
                            //
                            //legend {
                                //position      : bottom;
                                //align         : center;
                            //}
                            //
                            //legend label {
                                //color         : #333333;
                            //}
                            //
                            //chart {
                                //rightAxisVisibility : hidden;
                                //leftAxisVisibility  : hidden;
                                //paddingBottom : 16;
                                //enableMouseTrack : false;
                                //enableTooltip: true;
                                //width: 500;
                                //height: 250;
                            //}
                        //]]>
                    //</css>
                //</chart>
            //); 
            chart.parse(
                <chart> <data> <indexAxis> <labels>04-19,04-20,04-21,04-22,04-23,04-24,04-25</labels> </indexAxis> <valueAxis name="点击" unit="次" /> <dataSets> <set> <values>0.85,0.85,0,0,0,0,0</values> <style> <item name="color" value="#f4671e" /> </style> </set> </dataSets> </data> 
                <css>
                        <![CDATA[
                           canvas {
                                backgroundColor: #FFFFFF;
                                backgroundColor2: #fff7f3;
                                backgroundAlpha: 1;
                                gridColor: #ffeee5;
                                gridThickness: 1;
                            }
                            line {
                                thickness: 3;
                                alpha: 1;
                                thickness.active: 3;
                                lineMethod:curve;
                                color:#f4671e;
                            }
                            line dot {
                                radius.hl : 4;
                                shape: circle;
                                radius:3;
                                color:#FFFFFF;
                                borderColor:inherit#color;
                                borderThickness: 2;
                                lineColor:#f4671e;
                            }
                            /*鼠标经过tip*/
                            tooltip {
                                enabled: true;
                                backgroundColor: #f4671e;
                                color: #ffffff;
                                borderThickness: null;
                            }
                            /*点上小tip*/
                            line dot label {
                                visibility: hidden;
                            }
                            yAxis {
                                tickColor: #6593cf;
                                lineThickness: 2;
                                tickThickness: null;
                                lineColor:#9dbae0;
                            }
                            xAxis {
                                lineThickness: 2;
                                tickThickness: null;
                                lineColor:#9dbae0;
								tickThickness  : 2;
								tickLength   	: 5;
								tickPosition:reverse;
                            }
                            legend {
                                position: bottom;
                                align: center;
                            }
                            legend label {
                                color: #ffffff;
                            }
                            chart {
                                //rightAxisVisibility: hidden;
                                //leftAxisVisibility: visible;
								xAxisVisibility :none;
                                paddingBottom: 16;
                                colors: #f4671e;
                            }
                        ]]>
                    </css>
                    </chart>
            );

            //设置展示方式为折线图
            var style:StyleSheet = chart.styleSheet;
            
            chart.state = ChartStates.NORMAL;
            
            stage.addChild( new Stats() );
            
        }
        
    }

}