package bee.chart.demo 
{
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.assemble.pie.PieChartViewer;
    import bee.chart.PieChart;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import flash.utils.getTimer;
    import net.hires.debug.Stats;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieChartDemo4 extends Sprite 
    {
        private var chart:Chart;		
        public function PieChartDemo4() 
        {
            if (stage) {
                init();
            }
            else {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
        }
            
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            stage.scaleMode=StageScaleMode.NO_SCALE;
            stage.align=StageAlign.TOP_LEFT;
            
            chart = new PieChart();
            
            chart.chartHeight = 400;
            chart.chartWidth = 400;
            addChild(chart);
            
            var content:XML = 
                <chart>
                    <data>
                        <dataSets>
                            <set name="Offline Marketing">
                                <values>1327</values>
                            </set>

                            <set name="Search">
                                <values>2042</values>
                            </set>

                            <set name="Paid Search">
                                <values>850</values>
                            </set>

                            <set name="From Mail">
                                <values>541</values>
                            </set>
                        </dataSets>
                    </data>
                    <css>
                        <![CDATA[
                            slice {
                                labelSetType    : normal;
                                labelPosition   : outside;
                            }
                            tooltip {
                                tip : #value# of #total#<br>#percent#;
                            }
                            legend {
                                position      : bottom;
                                align         : left;
                                paddingRight  : 0;
                            }
                            chart {
                                colors: #A8CE55,#E9930F,#4D99DA,#CE5555,#DCBB29,#55BECE,#AF80DE;
                            }
                        ]]>
                    </css>
                    
                </chart>;
            
            chart.parse(content);
            //chart.state = ChartStates.NORMAL;
            
        }
        
    }

}