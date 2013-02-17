package bee.chart.demo
{
    import bee.abstract.CComponent;
    import bee.chart.PieChart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.data.DataCenter;
    import bee.chart.util.StyleLoader;
    import bee.util.YIDStyleSheet;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.StyleSheet;
    
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieChartDemoPlus extends ChartDemoPlusBase
    {
        public function PieChartDemoPlus()
        {
            super();
        }
        
        override protected function init(e:Event = null):void
        {
            super.init(e);
            
            chart = new PieChart();
            dataCenter = new DataCenter(chart);
            addChild(chart);
            chart.parse(getDataXML());
        }
        
        override protected function getDataXML():XML
        {
            return <chart>
					  <data>
						<indexAxis name="">
							<labels></labels>
						</indexAxis>
						<valueAxis name="" unit="" />
						<dataSets>
							<set name="分类A">
								<values>11</values>
							</set>
							<set name="分类B">
								<values>10</values>
							</set>
							<set name="分类C">
								<values>17</values>
							</set>
							<set name="分类D">
								<values>9</values>
							</set>
							<set name="分类E">
								<values>13</values>
							</set>
							<set name="分类F">
								<values>14</values>
							</set>
							<set name="分类G">
								<values>7.5</values>
							</set>
						</dataSets>
					</data>
                    
                    <css>
                        <![CDATA[
                            chart { 
                                chartWidth:300;
                                mouseAnimate:true;
                                colors:#A8CE55, #E9930F, #4D99DA, #CE5555, #DCBB29,#55BECE,#AF80DE;
                            }
                            legend {
                                position:left;
								itemEachColumn:4;/*legend显示的列数*/
                            }
                            slice {
                                /*labelSetType:normal;*/
                                labelPosition   : outside;
                                label:#label#;
                            }
                            tooltip {
                                enabled:true;
                                tip:#label#<br>#value# of #total#<br>#percent#;
                                borderColor         :   #F47E00;
                                backgroundColor     :   #FFECAA;
                                backgroundAlpha     :   1;
                            }
                        ]]>
                    </css>
                </chart>;
        }
    }

}