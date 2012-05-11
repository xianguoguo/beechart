package bee.chart.demo
{
    import bee.chart.LineChart;
    import bee.chart.data.DataCenter;
    
    import flash.events.Event;
    
    /**
     * ...
     * @author hua.qiuh
     */
    public class LineChartDemoPlus extends ChartDemoPlusBase
    {
        public function LineChartDemoPlus():void
        {
            super();
        }
        
        override protected function init(e:Event = null):void
        {
            super.init(e);
            
            chart = new LineChart();
            dataCenter = new DataCenter(chart);
            addChild(chart);
            chart.parse(getDataXML());
        }
        
        override protected function getDataXML():XML
        {
            return <chart>
                    <data>
                        <indexAxis name="日期">
                            <labels>2010-11-26, 2010-11-28, 2010-12-4, 2010-12-6, 2010-12-10, 2010-12-12, 2010-12-14, 2010-12-16</labels>
                        </indexAxis>
                        <valueAxis name="温度" unit="摄氏度" />
                        <dataSets>
                            <set name="最低温度">
                                <values>-3, 3, 4, 8, 8, 7, 9, 5</values>
                            </set>
                            <set name="最高温度">
                                <values>10, 15, 8, 8, 22, 18, 17, 19</values>
                            </set>
                        </dataSets>
                    </data>
                    
                    <css>
                        <![CDATA[
                            chart{
                                chartWidth:500;
                                chartHeight:300;
                                colors:#A8CE55, #E9930F, #4D99DA, #CE5555, #DCBB29,#55BECE,#AF80DE;
                                leftAxisVisibility: visible;
                            }
                            
                            legend{
                                position        : left;
                                align			: left;
                                paddingRight	: 0;
                            }
                            
                            canvas{
                                gridColor         : #C1C1C1;
                                gridThickness     : 1;
                                gridAlpha         : .5;
								borderThickness   : 2;
								borderColor       : #CADBF1;
                            }
                            
                            line{
                                thickness         : 3;
                                alpha	          : 1;
                                thickness.active  : 5;
                                lineMethod        : line;
                                dropShadow        : none;
                            }
                            
                            line dot{
                                color : inherit#color;
								radius : 5;
                            }
			
			                line dot label{
								visibility:visible;
							}
                            
                            yAxis{
                                tickColor     : #666666;
                                lineThickness : null;
                                tickThickness : null;
                            }
                            
                            xAxis{
                                lineThickness : 0;
                                tickThickness : 0;
                                labelDataType : date;
                                labelFormat   : %m-%d;
                            }
                            
                            tooltip{
                                enabled:true;
                            }
                        
                        ]]>
                    </css>
                </chart>;
        }
    }

}