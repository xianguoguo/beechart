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
                    colors          : #1b75d2,#5f9618,#eead23,#b3351b,#ff862e,#925100;
                    smooth          : true;
                    leftAxisVisibility: visible;
                }

                line {
                    dropshadow      : none;
                    lineMethod      : line;
                    thickness       : 3;
                    fillType        : line;
                }

                xAxis {
                    lineColor       : #666666;
                }

                xAxis label {
                    padding         : 5;
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
            ]]>;
            
            parseCSS(presetCSS);
            
            super.initChart();
        }
        
    }

}