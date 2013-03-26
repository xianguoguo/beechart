package bee.bugs 
{
    import bee.chart.abstract.Chart;
    import bee.chart.BarChart;
    import bee.chart.demo.ChartDemo;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.chart.release.BeeBarChart;
	import flash.display.Sprite;
	
	/**
     * 数据大小差异大，导致显示问题
     * @author jianping.shenjp
     */
    public class BarChartBug extends ChartDemo 
    {
        
        public function BarChartBug() 
        {
            
        }
        
        override protected function initChart():void 
        {
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            
            var chart:Chart = new BeeBarChart();
            chart.chartWidth = 500;
            chart.chartHeight = 250;
            addChild(chart);
            
            chart.parse('{\
                "data": {\
                    "indexAxis": {\
                        "labels": [\
                            "图片",\
                            "音频",\
                            "视频",\
                            "文本"\
                        ],\
                        "name": "客户端"\
                    },\
                    "valueAxis": {\
                        "unit": "个",\
                        "name": "安装数"\
                    },\
                    "dataSets": [\
                        {\
                            "values": [\
                                "52223715017",\
                                "589686476",\
                                "40992661756",\
                                "155056691456"\
                            ],\
                            "style": {},\
                            "name": "文件容量分布"\
                        },\
                        {\
                            "values": [\
                                "164973",\
                                "167",\
                                "965",\
                                "285938"\
                            ],\
                            "style": {},\
                            "name": "文件数量分布"\
                        }\
                    ]\
                }\
            }');
        }
        
    }

}