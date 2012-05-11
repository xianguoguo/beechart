package bee.chart.demo
{
    import bee.chart.BarChart;
    import bee.chart.data.DataCenter;
    
    import flash.events.Event;
    
    
    
    /**
     * ...
     * @author hua.qiuh
     */
    public class BarChartDemoPlus extends ChartDemoPlusBase
    {
        public function BarChartDemoPlus()
        {
            super();
        }
        
        override protected function init(e:Event = null):void
        {
            super.init(e);
            
            chart = new BarChart();
            dataCenter = new DataCenter(chart);
            addChild(chart);
            chart.parse(getDataXML());
        }
        
        override protected function getDataXML():XML
        {
            return <chart>
                    <data>
                        <indexAxis name="月份">
                            <labels>1月, 2月, 3月, 4月, 5月, 6月, 7月, 8月, 9月</labels>
                        </indexAxis>
                        <valueAxis name="营业额" unit="亿元" />
                        <dataSets>
                            <set name="A公司">
                                <values>43, 50, 24, 13, 15, 8, 37, 58, 52</values>
                            </set>	
                            <set name="B公司">
                                <values>59, 39, 45, 65, 37, 66, 69, 33, 71</values>
                            </set>
                            <set name="C公司">
                                <values>39, 39, 43,44,45,45,44,43,43</values>
                            </set>
                        </dataSets>
                    </data>
                    
                    <css>
                        <![CDATA[
                            chart{
                                chartWidth:500;
                                chartHeight:300;
                                colors:#A8CE55, #E9930F, #4D99DA, #CE5555, #DCBB29,#55BECE,#AF80DE;
                            }
                            legend{
                                position:left;
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
                                fillAlpha         : 0.5;
                                dropShadow        : none;
                            }
                            line dot{
                                color : inherit#color;
                            }
                            yAxis{
                                tickColor     : #666666;
                                lineThickness : null;
                                tickThickness : null;
                            }
                            xAxis{
                                lineThickness : 0;
                                tickThickness : 0;
								labelPosition  : center;
                            }
                            tooltip{
                                enabled:true;
                            }
                            bar{
                                thickness:10;
                            }
                        ]]>
                    </css>
                </chart>;
        }
    }

}