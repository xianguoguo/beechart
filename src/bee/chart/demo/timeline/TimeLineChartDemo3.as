package bee.chart.demo.timeline 
{
    import bee.chart.abstract.Chart;
	import bee.chart.assemble.line.timeline.TimeLineChartPrinter;
    import bee.chart.demo.ChartDemo;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.chart.LineChart;
	import bee.chart.test.DotPool;
	import cn.alibaba.yid.chart.TimeLineChart;
	import flash.display.Sprite;
	import flash.display.StageQuality;
    import flash.events.Event;
    import net.hires.debug.Stats;
	
	/**
     * 短时间测试
     * @author hua.qiuh
     */
    public class TimeLineChartDemo3 extends ChartDemo 
    {
        
        public function TimeLineChartDemo3() 
        {
			super();
        }
		
        override protected function initChart():void 
        {
            DotPool.initialize(100,50);
            var chart:Chart = new TimeLineChart();
            addChild(chart);
			chart.skin.statePrinter = new TimeLineChartPrinter();
			chart.chartWidth = 800;
            chart.chartHeight = 400;
			//--chart.loadCSS('..-demo-css-single-dark.css');
            //--chart.load('..-demo-data-data-xml-single.xml');
				
            chart.parse('{\
                "data" : {\
                    "indexAxis" : {\
                        "name" : "日期",\
                        "unit" : "",\
                        "labels" : ["2005-01-01", "2005-01-02", "2005-01-03", "2005-01-04", "2005-01-05", "2005-01-06", "2005-01-07", "2005-01-08", "2005-01-09", "2005-01-10", "2005-01-11", "2005-01-12", "2005-01-13", "2005-01-14", "2005-01-15", "2005-01-16", "2005-01-17", "2005-01-18", "2005-01-19", "2005-01-20", "2005-01-21", "2005-01-22", "2005-01-23", "2005-01-24", "2005-01-25", "2005-01-26", "2005-01-27", "2005-01-28", "2005-01-29", "2005-01-30", "2005-01-31", \
									"2005-02-01", "2005-02-02", "2005-02-03", "2005-02-04", "2005-02-05", "2005-02-06", "2005-02-07", "2005-02-08", "2005-02-09", "2005-02-10", "2005-02-11", "2005-02-12", "2005-02-13", "2005-02-14", "2005-02-15", "2005-02-16", "2005-02-17", "2005-02-18", "2005-02-19", "2005-02-20", "2005-02-21", "2005-02-22", "2005-02-23", "2005-02-24", "2005-02-25", "2005-02-26", "2005-02-27", "2005-02-28", \
									"2005-03-01", "2005-03-02", "2005-03-03", "2005-03-04", "2005-03-05", "2005-03-06", "2005-03-07", "2005-03-08", "2005-03-09", "2005-03-10", "2005-03-11", "2005-03-12", "2005-03-13", "2005-03-14", "2005-03-15", "2005-03-16", "2005-03-17", "2005-03-18", "2005-03-19", "2005-03-20", "2005-03-21", "2005-03-22", "2005-03-23", "2005-03-24", "2005-03-25", "2005-03-26", "2005-03-27", "2005-03-28", "2005-03-29", "2005-03-30", "2005-03-31", \
									"2005-04-01", "2005-04-02", "2005-04-03", "2005-04-04", "2005-04-05", "2005-04-06", "2005-04-07", "2005-04-08", "2005-04-09", "2005-04-10", "2005-04-11", "2005-04-12", "2005-04-13", "2005-04-14", "2005-04-15", "2005-04-16", "2005-04-17", "2005-04-18", "2005-04-19", "2005-04-20", "2005-04-21", "2005-04-22", "2005-04-23", "2005-04-24", "2005-04-25", "2005-04-26", "2005-04-27", "2005-04-28", "2005-04-29", "2005-04-30"]\
                    },\
                    \
                    "valueAxis" : {\
                        "name" : "价格",\
                        "unit" : "元-吨"\
                    },\
                    \
                    "dataSets" : [\
                        {\
                            "name" : "滨州细绒棉出厂价",\
                            "values" : [10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 15100,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 11600,\
										14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 27280, 27380,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 14500,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 16000,\
										14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 28020,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 16000,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 16000,\
										14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 28020,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 16000,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 14500,\
										14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 27280, 27380,\
										\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 16000,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 12500,\
										14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 27280, 28280,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500,  14500,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 16000,\
										14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 28020,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 15500,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 16000,\
										14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 28020,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 15000, 15500,\
										10000, 11000, 12000, 11500, 10000, 12000, 11000, 12000, 12500, 13000, 11000, 11300, 12000, 11500, 10500, 10000, 11500, 11000, 13500, 14000, 10000, 11300, 12000, 13500, 17500, 15000, 11500, 15000, 13500, 14500,\
										14750, 14810, null , 15300, 15680, 15900, 15900, 15930, 15380, 15180, 15100, 15200, 15500, 16940, 17120, 17371, 15900, 21966, 22200, 23240, 24340, 25800, 27340, 29100, 30660, 28940, 26400, null, 27020, 27280 ,28280],\
                            "style" : {\
                                "color" : "#E9584D"\
                            }\
                        },\
                        {\
                            "name" : "泰州细绒棉出厂价",\
                            "values" : [10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 15000,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 13500,\
										14950, 14950, null, 15050, 15350, 15480, 16000, 16000, 16000, 16000, 16700, 16700, 16700, 17300, 17300, 16000, 25140, 26300, 27440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 30000, 31000,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14500,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 15000,\
										14950, 14950, null, 15050, 15350, 15480, 16000, 16000, 16000, 16000, 16700, 16700, 16700, 17300, 17300, 16000, 25140, 26300, 27440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 31000,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 15000,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 14500,\
										14950, 14950, null, 15050, 15350, 15480, 16000, 16000, 16000, 16000, 16700, 16700, 16700, 17300, 17300, 16000, 25140, 26300, 27440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 30500,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 15000,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14500,\
										14950, 14950, null, 15050, 15350, 15480, 16000, 16000, 16000, 16000, 16700, 16700, 16700, 17300, 17300, 16000, 25140, 26300, 27440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 30000, 31000,\
										\
										11100, 15700, 11000, 11500, 13500, 13000, 13000, 12000, 14500, 13000, 11000, 10500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 15000,\
										15100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 13500,\
										14950, 14950, null, 15050, 15350, 15480, 16000, 16000, 16000, 16000, 16700, 16700, 16700, 17300, 17300, 16000, 25140, 26300, 27440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 30000, 30500,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 12500, 12100, 11500, 12000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14500,\
										10100, 11500, 11100, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 12500, 13000, 14000, 11000, 12000, 15500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 14500,\
										14950, 14950, null, 13050, 15350, 14040, 17000, 16000, 16000, 16000, 12700, 15700, 17900, 19300, 14300, 15000, 25140, 25300, 26440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 30500,\
										11100, 15700, 11000, 11500, 13500, 13000, 13000, 12000, 14500, 13000, 11000, 10500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 14500,\
										15100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 11500, 11000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 14500,\
										14950, 14950, null, 15050, 15350, 15480, 16000, 16000, 16000, 16000, 16700, 16700, 16700, 17300, 17300, 16000, 25140, 26300, 27440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 31000,\
										10100, 11500, 11000, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 12500, 12100, 11500, 12000, 13000, 10000, 13000, 13500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14000, 15000,\
										10100, 11500, 11100, 11500, 13000, 12000, 11000, 12000, 12500, 12000, 14000, 11500, 12100, 12500, 13000, 14000, 11000, 12000, 15500, 11000, 11000, 15300, 14000, 13500, 11500, 14000, 12500, 11500, 13500, 14500,\
										14950, 14950, null, 13050, 15350, 14040, 17000, 16000, 16000, 16000, 12700, 15700, 17900, 19300, 14300, 15000, 25140, 25300, 26440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 30000, 31000\
										],\
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
                        "gridColor"         : "#CCCCCC",\
                        "gridThickness"     : 1,\
                        "gridAlpha"         : 1,\
						"vLineStyle"		: "dashed",\
						"secLineThickness"	: 1,\
						"secLineColor"		: "#CCCCCC",\
						"secLineGap"		: 20\
                    },\
                    \
                    "line" : {\
                        "thickness"         : 1,\
                        "alpha"	            : 1,\
                        "thickness.active"  : 5,\
                        "lineMethod"        : "line",\
                        "dropShadow"        : "none"\
                    },\
                    \
                    "line dot" : {\
                        "color"	: "#FFFFFF",\
                        "borderColor"	: "inherit#color",\
                        "borderThickness"	: "2",\
                        "shape"	: "circle",\
                        "radius"	: "0",\
                        "color.hl" : "inherit#color",\
                        "borderColor.hl" : "#FFFFFF",\
                        "radius.hl"	: "3"\
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
                        "tickThickness" : 3,\
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
					"legend item label": {\
						"color":"inherit"\
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
            
        }
        
    }

}