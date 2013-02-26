package bee.chart.demo.pie 
{
    import bee.chart.abstract.Chart;
	import bee.chart.demo.ChartDemo;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.chart.PieChart;
    import bee.chart.release.BeePieChart;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class PieChartDemo_Group_AliStyle extends ChartDemo 
    {
        
        public function PieChartDemo_Group_AliStyle() 
        {
            
        }
        
        override protected function initChart():void 
        {
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            
            var chart:Chart = new BeePieChart();
            
            var content:XML = 
                <chart>
                    <data>
                        <dataSets>
                            <set name="Chrome 9">
                                <values>1327</values>
                            </set>
                            <set name="IE9.0">
                                <values>1800</values>
                            </set>
                            <set name="Chrome 10">
                                <values>1000</values>
                            </set>
                            <set name="IE6.0">
                                <values>1500</values>
                            </set>
                            <set name="IE7.0">
                                <values>1000</values>
                            </set>
                            <set name="IE8.0">
                                <values>3000</values>
                            </set>

                            <set name="Firefox 3.6" stackGroup="FireFox">
                                <values>850</values>
                            </set>
                            <set name="Firefox 4.0" stackGroup="FireFox">
                                <values>1541</values>
                            </set>
                            <set name="Firefox 1.0" stackGroup="FireFox">
                                <values>541</values>
                            </set>

                        </dataSets>
                    </data>
                   
                </chart>;
            
            
            
            chart.chartWidth = 430;
            chart.chartHeight = 430;
            
            addChild(chart);
            chart.parse(content);
        }
        
    }

}