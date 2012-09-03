package bee.chart.release 
{
    import bee.chart.abstract.CartesianChart;
    import bee.chart.abstract.Chart;
    import bee.chart.assemble.pie.PieChartViewer;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.plugins.pie.performer.ClockwisePerformerPlugin;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class BeePieChart extends CartesianChart 
    {
        
        public function BeePieChart() 
        {
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            
            var pluginClz:Vector.<Class> = (new <Class>[ClockwisePerformerPlugin]);
            
            super(PieChartViewer, null, pluginClz);
        }
        
        override protected function initChart():void 
        {
            var presetCSS:String = <![CDATA[
                chart {
                    colors          : #FA6222,#FEC53F,#DBEE27,#87C822,#49AFB1;
                    animate         : clockwise;
                    order           : asc;
                }

                tooltip {
                    tip : <b>#label#</b><br>#percent#<br>#value# / #total#;
                    backgroundAlpha : .95;
                    backgroundType:slash;
                }

                slice {
                    labelPosition   : callout;
                    frameThickness  : 5;
                    frameColor      : #FFFFFF;
                }

                legend {
                    position        : bottom;
                    align           : center;
                    paddingRight    : 0;
                }

                legend item label {
                    color           : inherit;
                }
            ]]>;
            
            parseCSS(presetCSS);
            
            super.initChart();
        }
        
    }

}