package bee.chart.release 
{
    import bee.chart.abstract.CartesianChart;
    import bee.chart.assemble.line.timeline.TimeLineChartView;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    /**
     * ...
     * @author jianping.shenjp
     */
    public class BeeTimeLineChart extends CartesianChart 
    {
        
        /**
        * 如果要给LineChart指定自定义的Viewer和ChartData类型
        * 请使用 chart.setViewer 和 chart.chartModel.setData
        */
        public function BeeTimeLineChart(pluginClz:Vector.<Class> = null) 
        {
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            super(TimeLineChartView, null, pluginClz);
        }
        
        override protected function initChart():void 
        {
            var presetCSS:String = <![CDATA[
                chart {
                    colors              : #1b75d2,#5f9618,#eead23,#b3351b,#ff862e,#925100;
                    smooth              : true;
                    leftAxisVisibility  : visible;
                    enableTooltip       : true;
                    paddingLeft         : 0;
                    paddingRight        : 0;
                    paddingTop          : 0;
                    paddingBottom       : 0;
                }

                line {
                    dropshadow      : none;
                    lineMethod      : line;
                    thickness       : 3;
                    fillType        : line;
                }

                xAxis {
                    lineColor       : #666666;
                    lineThickness   : 3;
                    tickColor       : #666666;
                    tickThickness   : 0;
                    tickLength      : 3;
                }

                xAxis label {
                    padding         : 5;
                    color           : #666666;
                }

                yAxis {
                    lineColor       : #666666;
                    lineThickness   : 3;
                    tickColor       : #666666;
                    tickThickness   : 0;
                    tickLength      : 3;
                    labelGap        : auto;
                }
                
                 yAxis label {
                    paddingLeft     : 0;
                    paddingRight    : 0;
                    color           : #666666;
                    visibility      : visible;
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