package bee.chart.release 
{
    import bee.chart.abstract.CartesianChart;
	import bee.chart.assemble.line.timeline.TimeLineChartView;
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
            super(TimeLineChartView, null, pluginClz);
        }
		
        override protected function initChart():void 
        {
            var presetCSS:String = <![CDATA[
                chart {
                    colors          : #1b75d2,#5f9618,#eead23,#b3351b,#ff862e,#925100;
                    smooth          : true;
                    leftAxisVisibility: visible;
                    fix             : auto;
                }

                line {
                    dropshadow      : none;
                    lineMethod      : curve;
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
                    labelGap        : auto;
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
                    borderThickness   : 1;
                    borderColor 	  : #CCCCCC,
                    gridAlpha        : 1;
                    priLineThickness: 1;
                    priLineColor    : #F2F2F2;
                    priLineAlpha    : 1;
                    vLineStyle"     : dashed;
                    secLineThickness  : 1;
                    secLineColor      : #CCCCCC;
                    secLineGap"       : 20;
                    secLineStyle      : dashed;
                    priLineColor      : "CCCCCC;
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