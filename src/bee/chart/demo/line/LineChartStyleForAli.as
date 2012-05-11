package bee.chart.demo.line 
{
    import bee.chart.abstract.Chart;
    import bee.chart.demo.ChartDemo;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.chart.LineChart;
    import bee.chart.test.DotPool;
	import flash.display.Sprite;
    import flash.events.Event;
    import net.hires.debug.Stats;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class LineChartStyleForAli extends ChartDemo 
    {
        
        public function LineChartStyleForAli() 
        {
        }
        
        override protected function initChart():void 
        {
            DotPool.initialize(100,50);
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            
            var chart:Chart = new LineChart();
            
            chart.parse('{\
                "data" : {\
                    "indexAxis" : {\
                        "name" : "日期",\
                        "unit" : "",\
                        "labels" : ["02/26" ,"03/05" ,"03/12" ,"03/19" ,"03/26" ,"04/02" ,"04/09" ,"04/16" ,"04/23" ,"04/30" ,"05/07" ,"05/14" ,"05/21" ,"05/28" ,"06/04" ,"06/11" ,"07/16" ,"10/01" ,"10/08" ,"10/15" ,"10/22" ,"10/29" ,"11/05" ,"11/12" ,"11/19" ,"11/26" ,"12/03" ,"12/10" ,"12/17" ,"12/24" ,"12/31" ,"01/07" ,"01/14" ,"01/21" ,"01/28" ,"02/11"]\
                    },\
                    \
                    "valueAxis" : {\
                        "name" : "价格",\
                        "unit" : "元/吨"\
                    },\
                    \
                    "dataSets" : [\
                        {\
                            "name" : "滨州细绒棉出厂价",\
                            "values" : [14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 27280, 27500, 27500, 27580, 27625, 27837, 28400],\
                            "style" : {\
                                "color" : "#E9584D"\
                            }\
                        },\
                        {\
                            "name" : "泰州细绒棉出厂价",\
                            "values" : [14950, 14950, null, 15050, 15350, 15480, 16000, 16000, 16000, 16000, 16700, 16700, 16700, 17300, 17300, 16000, 25140, 26300, 27440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 30000, 30000, 30000, 30000, null, 30000, 30000],\
                            "style" : {\
                                "color" : "#4088E0"\
                            }\
                        }\
                    ]\
                },\
                \
                "css" : {\
                    \
                    "chart" : {\
                        "smooth"            : "true",\
                        "leftAxisVisibility" : "visible", \
                        "paddingLeft"       : 20, \
                        "paddingRight"      : 20, \
                        "paddingBottom"     : 20, \
                        "paddingTop"        : 20 \
                    },\
                    "canvas" : {\
                        "backgroundColor2"  : "#F8F8F8",\
                        "gridColor"         : "#F2F2F2",\
                        "gridThickness"     : 1,\
                        "gridAlpha"         : 1\
                    },\
                    \
                    "line" : {\
                        "thickness"         : 3,\
                        "alpha"	            : 1,\
                        "thickness.active"  : 3,\
                        "lineMethod"        : "line",\
                        "dropShadow"        : "none",\
                        "fillType"      :"gradient",\
                        "fillAlpha.active"  :"0.1"\
                    },\
                    \
                    "line dot" : {\
                        "color"	: "#FFFFFF",\
                        "borderColor"	: "inherit#color",\
                        "borderThickness"	: "2",\
                        "shape"	: "circle",\
                        "radius"	: "3",\
                        "color.hl" : "inherit#color",\
                        "borderColor.hl" : "#FFFFFF",\
                        "radius.hl"	: "7", \
                        "dropShadow.hl" : "light" \
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
                        "labelGap"      : "auto"\
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
                    "tooltip" : { \
                        "backgroundAlpha" : 0.92 \
                    }, \
                    \
                    "moveline":{\
                        "color":"#BBBBBB",\
                        "thickness":"1"\
                    }\
                }\
            }');
            
            chart.chartWidth = 500;
            chart.chartHeight = 250;
            
            addChild(chart);
            
            //stage.addChild( new Stats() );
            
        }
        
    }

}