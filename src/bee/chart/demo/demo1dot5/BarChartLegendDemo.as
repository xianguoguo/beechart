package bee.chart.demo.demo1dot5 
{
    import cn.alibaba.util.ColorUtil;
    import bee.abstract.CComponent;
    import bee.chart.BarChart;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.assemble.bar.BarChartViewer;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.AutoColorUtil;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    import net.hires.debug.Stats;

	/**
    * 柱状图（不分组）legend切换效果
    * @author hua.qiuh
    */
    public class BarChartLegendDemo extends YIDDemoBase
    {
        
        public function BarChartLegendDemo() 
        {
            super();
        }
        
        override protected function initChart():void 
        {
            super.initChart();
            //所有类型图表的CController都是同一个：Chart
            chart = new BarChart();
            addChild(chart);
            //添加数据
            var data:XML = 
            <chart>
              <data>
                <indexAxis name="日期">
                  <labels>
                    01/12,01/13,01/14,01/17,01/18,01/19
                  </labels>
                </indexAxis>
                <valueAxis name="价格"/>
                <dataSets>
                  <set name="辛塔">
                    <values>
                      93,97,95,96,97,98
                    </values>
                  </set>
                  <set name="大庆">
                    <values>
                      23,24,25,26,27,28
                    </values>
                  </set>
                  <set name="胜利">
                    <values>
                      53,54,55,56,57,58
                    </values>
                  </set>
                </dataSets>
              </data>
              <css>
                <![CDATA[
                    xAxis {
                        tickThickness  : 0;
                        tickLength     : 5;
                        tickPosition   : center;
                        labelPosition  : center;
                        labelGap       : auto;
                    }

                    yAxis {
                        tickThickness  : 0;
                        tickPosition   : left;
                        labelPosition  : left;
                    }

                    canvas {
                        borderThickness   : 4;
                        borderColor       : #666666;
                        backgroundColor   : #FFFFFF;
                        backgroundColor2  : #FFF7F3;
                        gridColor         : #FFEBE1;
                        gridThickness     : 1;
                    }

                    bar {
                        dropShadow: none;
                        valueVisibility: visible;
                        brightness : 0;
                        brightness.hl : 0.2;
                    }

                    bar label {
                        fontSize: 15;
                    }

                    chart {
                        colors        : #A9CF56,#EA9410,#4E9ADB;
                        leftAxisVisibility: visible;
                        animate : false;
                        paddingTop : 50;
                        width: 600;
                        height: 300;
                        smooth:true;
                    }

                    legend {
                        position:bottom;
                    }
                 ]]>
              </css>
            </chart>;
            
            
            var viewer:BarChartViewer = new BarChartViewer(chart);
            chart.setViewer(viewer);
            chart.parse(data);
			
        }
    }

}