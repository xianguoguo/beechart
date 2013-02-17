package bee.chart.demo
{
    import bee.abstract.CComponent;
    import bee.chart.LineChart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.AutoColorUtil;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.StyleSheet;
    
    import net.hires.debug.Stats;
	
    /**
    * ...
    * @author hua.qiuh
    */
    public class LineChartDemo4 extends Sprite 
    {
        
		private var chart:LineChart;
		
        public function LineChartDemo4():void 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            stage.align = 'TL';
            stage.scaleMode = 'noScale';
            
            chart = new LineChart();
            
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
                                "color" : "#0080FF"\
                            }\
                        },\
                        {\
                            "name" : "泰州细绒棉出厂价",\
                            "values" : [14950, 14950, null, 15050, 15350, 15480, 16000, 16000, 16000, 16000, 16700, 16700, 16700, 17300, 17300, 16000, 25140, 26300, 27440, 29400, 32400, 32720, 32000, 32000, 32000, 30000, 30000, 30000, 30000, 30000, 30000, 30000, 30000, null, 30000, 30000],\
                            "style" : {\
                                "color" : "#FF7300"\
                            }\
                        }\
                    ]\
                },\
                \
                "css" : {\
                    "canvas" : {\
                        "backgroundColor2"  : "#E4F2F5",\
                        "gridColor"         : "#29A5F7",\
                        "gridThickness"     : null,\
                        "gridAlpha"         : 0.5,\
                        "xgap"              : 2\
                    },\
                    \
                    "line" : {\
                        "thickness"         : 3,\
                        "alpha"	            : 1,\
                        "thickness.active"  : 5,\
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
                        "radius"	: "4",\
                        "radius.hl"	: "6"\
                    },\
                    \
                    "yAxis" : {\
                        "tickColor"     : "#666666",\
                        "lineThickness" : 2,\
                        "tickThickness" : null\
                    },\
                    \
                    "xAxis" : {\
                        "lineThickness" : 2,\
                        "tickThickness" : 2,\
                        "labelDataType" : "date",\
                        "labelFormat"   : "%Y-%m-%d",\
                        "labelRotation" : 45,\
                        "position"      : "zero",\
                        "labelGap"      : 0\
                    },\
                    \
                    "xAxis label" : {\
                        "color"         : "#0000FF"\
                    },\
                    \
                    "legend" : {\
                        "position"      : "bottom",\
                        "align"         : "center"\
                    },\
                    "moveline":{\
                        "color":"#BBBBBB",\
                        "thickness":"1"\
                    }\
                }\
            }');
            
            //设置图表的尺寸，图表的主体将会显示在这个范围内
            chart.chartWidth = 500;
            chart.chartHeight = 250;
            
            addChild(chart);
            
            //stage.addChild( new Stats() );
            
        }
        
		/**
		 * 清除数据的接口
		 * */
		public function dispose():void
		{
			(chart.view as CComponent).clearContent();
			chart.dispose();
			AutoColorUtil.reset();
//			Tooltip.instance.dispose();
		}
        
    }

}