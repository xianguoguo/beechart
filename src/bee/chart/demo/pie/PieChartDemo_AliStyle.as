package bee.chart.demo.pie 
{
    import bee.chart.abstract.Chart;
	import bee.chart.demo.ChartDemo;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.chart.PieChart;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class PieChartDemo_AliStyle extends ChartDemo 
    {
        
        public function PieChartDemo_AliStyle() 
        {
            
        }
        
        override protected function initChart():void 
        {
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            
            var chart:Chart = new PieChart();
            
            var content:XML = 
                <chart>
                    <data>
                        <dataSets>
                            <set name="Chrome 9">
                                <values>1327</values>
                            </set>
                            <set name="IE9.0" stackGroup="IE系列">
                                <values>1800</values>
                            </set>
                            <set name="Chrome 10">
                                <values>1000</values>
                            </set>
                            <set name="IE6.0" stackGroup="IE系列">
                                <values>1500</values>
                            </set>
                            <set name="IE7.0" stackGroup="IE系列">
                                <values>1000</values>
                            </set>
                            <set name="IE8.0">
                                <values>3000</values>
                            </set>

                            <set name="Firefox 3.6" stackGroup="FF系列">
                                <values>850</values>
                            </set>
                            <set name="Firefox 4.0" stackGroup="FF系列">
                                <values>1541</values>
                            </set>
                            <set name="Firefox 1.0" stackGroup="FF系列">
                                <values>541</values>
                            </set>

                        </dataSets>
                    </data>
                    <css>
                        <![CDATA[
                            slice {
                                //labelSetType    : normal;
                                labelPosition   : callout;
                                frameThickness  : 5;
                                frameColor      : #FFFFFF;
                            }
                            tooltip {
                                tip : #value# of #total#<br>#percent#;
                            }
                            legend {
                                position      : bottom;
                                align         : left;
                                paddingRight  : 0;
                            }
                            legend item icon {
                                size          : 15;
                            }
                            legend item label {
                                color         : inherit;
                            }
                            chart {
                                colors: #FA6222, #FEC53F, #DBEE27, #87C822, #49AFB1;
                                animate:clockwise;
                                order:asc;
                                smooth:true;
                            }
                        ]]>
                    </css>
                </chart>;
            
            
            
            chart.chartWidth = 430;
            chart.chartHeight = 430;
            
            addChild(chart);
            
            chart.parse(content);
        }
        
    }

}