package bee.chart.release 
{
    import bee.chart.abstract.CartesianChart;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.Chart;
    import bee.chart.assemble.bar.BarChartData;
    import bee.chart.assemble.bar.BarChartViewer;
    import bee.chart.elements.bar.BarView;
    import bee.chart.elements.bar.BarWithSlashBgPrinter;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class BeeBarChart extends CartesianChart 
    {
        
        public function BeeBarChart(pluginClz:Vector.<Class>=null) 
        {
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            BarView.defaultStatePrinter = new BarWithSlashBgPrinter;
            
            super(BarChartViewer, BarChartData, pluginClz);
        }
        
        override protected function initChart():void 
        {
            var presetCSS:String = <![CDATA[
                chart {
                    colors          : #1b75d2,#5f9618,#eead23,#b3351b,#ff862e,#925100;
                    smooth          : true;
                    leftAxisVisibility: visible;
                }

                bar {
                    color.hl        : #C5C5C5;
                    dropShadow      : none;
                    borderThickness : 1;
                    borderColor     : #FFFFFF;
                    brightnessFading: -0.2;
                    backgroundType.hl : slash;
                }

                xAxis {
                    lineColor       : #666666;
                    lineThickness   : 3;
                    tickThickness   : 0;
                    labelPosition   : center;
                }
            
                xAxis label {
                    paddingLeft     : 0;
                    paddingRight    : 0;
                    color           : #666666;
                }

                yAxis {
                    lineColor       : #666666;
                    lineThickness   : 3;
                    tickThickness   : 0;
                    labelGap        : auto;
                }

                canvas {
                    backgroundColor2: #F8F8F8;
                    backgroundColor : #FFFFFF;
                    priLineThickness: 1;
                    priLineColor    : #F2F2F2;
                    priLineAlpha    : 1;
                }

                guideLine {
                    color           : #BBBBBB;
                }

                legend {
                    position        : bottom;
                    align           : center
                }

                legend item label {
                    color           : inherit;
                }

                tooltip {
                    backgroundAlpha : .95;
                    backgroundType:slash;
                }
            ]]>;
            
            parseCSS(presetCSS);
            
            super.initChart();
            CartesianChartData(data).addKeyValue(0);
        }
        
    }

}