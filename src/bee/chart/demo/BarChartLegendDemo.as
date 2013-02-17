package bee.chart.demo 
{
    import cn.alibaba.util.ColorUtil;
    import bee.abstract.CComponent;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.BarChart;
    import bee.chart.assemble.bar.BarChartViewer;
    import bee.chart.util.AutoColorUtil;
    import flash.display.Sprite;
    import flash.events.Event;
    import net.hires.debug.Stats;
	/**
    * 柱状图（不分组）legend切换效果
    * @author hua.qiuh
    */
    public class BarChartLegendDemo extends Sprite
    {
        
        private var chart:BarChart;
        
        public function BarChartLegendDemo() 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            stage.align = 'TL';
            stage.scaleMode = 'noScale';
            
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
                      93,97,97,97,97,96
                    </values>
                  </set>
                  <set name="大庆">
                    <values>
                      23,27,27,27,27,27
                    </values>
                  </set>
                  <set name="胜利">
                    <values>
                      57,51,51,51,51,51
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
                        animate : true;
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