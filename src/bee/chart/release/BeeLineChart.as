package bee.chart.release 
{
    import bee.chart.abstract.CartesianChart;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.Chart;
    import bee.chart.assemble.line.LineChartEnterAnimator;
    import bee.chart.assemble.line.LineChartViewer;
    import bee.chart.assemble.line.SuperLineChartViewer;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    /**
     * ...
     * @author hua.qiuh
     */
    public class BeeLineChart extends CartesianChart 
    {
        
        public function BeeLineChart(pluginClz:Vector.<Class> = null) 
        {
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            LineChartViewer.defaultPerformer = new LineChartEnterAnimator;
            
            super(SuperLineChartViewer, CartesianChartData, pluginClz);
        }
        
        override protected function initChart():void 
        {
            var presetCSS:String = <![CDATA[
            chart {
                colors              : #1b75d2,#5f9618,#eead23,#b3351b,#ff862e,#925100;
                smooth              : true;
                leftAxisVisibility  : visible;
                enableTooltip       : true;
                animate             : true;
                paddingLeft         : 0;
                paddingRight        : 0;
                paddingTop          : 0;
                paddingBottom       : 0;
            }

            line {
                dropshadow      : none;
                lineMethod      : line;
                thickness       : 3;
                fillType        : gradient;
                fillAlpha.active: .3;
            }

            line dot {
                color	        : #FFFFFF;
                borderColor	    : inherit#color;
                borderThickness	: 2;
                shape	        : circle;
                radius	        : 3;
                color.hl        : inherit#color;
                borderColor.hl  : #FFFFFF;
                radius.hl	    : 7;
                dropShadow.hl   : light;
            }

            xAxis {
                lineColor       : #666666;
                lineThickness   : 3;
                tickThickness   : 0;
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
                align           : center;
                itemEachColumn  : 4;
                interactive     : true;
            }

            legend item label {
                color           : inherit;
            }
            
            tooltip {
                backgroundAlpha   : 0.95;
                backgroundType    : slash;
                backgroundColor   : #FFFFFF;
                backgroundAlpha   : 0.8;
                borderColor       : #666666;
                borderAlpha       : 1;
                borderThickness   : 2;
            }
            ]]>;
            
            parseCSS(presetCSS);
            
            super.initChart();
        }
        
    }

}