package bee.chart.demo.bar 
{
    import bee.chart.abstract.Chart;
    import bee.chart.BarChart;
	import bee.chart.demo.ChartDemo;
    import bee.chart.elements.bar.BarWithSlashBgPrinter;
    import bee.chart.elements.bar.BarView;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class BarChartDemo_AliStyle_Slash extends ChartDemo 
    {
        
        public function BarChartDemo_AliStyle_Slash() 
        {
			super();
        }
        
        override protected function initChart():void 
        {
            
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            BarView.defaultStatePrinter = new BarWithSlashBgPrinter;
            
            var chart:Chart = new BarChart();
            chart.chartWidth = 500;
            chart.chartHeight = 250;
            addChild(chart);
            
            chart.parse('{\
                "data" : {\
                    "indexAxis" : {\
                        "name" : "日期",\
                        "unit" : "",\
                        "labels" : ["20110307" ,"20110314" ,"20110321" ,"20110328"]\
                    },\
                    "valueAxis" : {\
                        "name" : "访客数",\
                        "unit" : ""\
                    },\
                    "dataSets" : [\
                        {\
                            "name" : "中高质量访客数",\
                            "values" : [120, 140, 130, 110] \
                        },\
                        {\
                            "name" : "主动洽谈中高质量访客数",\
                            "values" : [80, 90, 80, 70] \
                        },\
                        {\
                            "name" : "主动洽谈并成功中高质量访客数",\
                            "values" : [60, 70, 60, 70] \
                        }\
                    ]\
                },\
                \
                "css" : {\
                    \
                    "chart" : {\
                        "colors"            : "#F8BC15,#6CA91E,#F05500", \
                        "smooth"            : "true",\
                        "leftAxisVisibility" : "visible", \
                        "paddingLeft"       : 0, \
                        "paddingTop"        : 0, \
                        "paddingRight"      : 0 \
                    },\
                    "canvas" : {\
                        "borderThickness"   : 1, \
                        "borderColor"       : "#F1F1F1", \
                        "backgroundColor2"  : "#F8F8F8",\
                        "vLineStyle"        : "dashed", \
                        "gridColor"         : "#F2F2F2",\
                        "gridThickness"     : 1,\
                        "gridAlpha"         : 1\
                    },\
                    \
                    "bar" : {\
                        "dropShadow"        : "none",\
                        "thickness"         : 19,\
                        "borderThickness"   : 1, \
                        "borderColor"       : "#FFFFFF", \
                        "brightnessFading"  : -0.3, \
                        "color.hl"          : "#C5C5C5", \
                        "backgroundType.hl" : "slash" \
                    },\
                    \
                    "yAxis" : {\
                        "lineColor"     : "#666666",\
                        "lineThickness" : 3,\
                        "tickThickness" : 0\
                    },\
                    \
                    "xAxis" : {\
                        "lineColor"     : "#666666",\
                        "lineThickness" : 3,\
                        "tickThickness" : 0,\
                        "labelGap"      : "auto", \
                        "labelPosition" : "center" \
                    },\
                    \
                    "yAxis label" : {\
                        "color"         : "#666666"\
                    },\
                    \
                    "xAxis label" : {\
                        "color"         : "#666666"\
                    },\
                    \
                    "legend" : {\
                        "position"      : "bottom",\
                        "align"         : "center"\
                    },\
                    \
                    "legend item label" : {\
                        "color"         : "inherit"\
                    },\
                    \
                    "tooltip" : { \
                        "maxchar"       : 0 \
                    } \
                }\
            }');
        }
        
    }

}