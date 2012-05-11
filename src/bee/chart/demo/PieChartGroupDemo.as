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
    public class PieChartGroupDemo extends Sprite 
    {
        private var chart:Chart;		
        public function PieChartGroupDemo() 
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
                            <set name="Chrome 9">
                                <values>1327</values>
                            </set>
                            <set name="IE9.0" stackGroup="IE系列">
                                <values>1800</values>
                            </set>
                            <set name="Chrome 10">
                                <values>1000</values>
                            </set>
                            <set name="IE6.0" stackGroup="IE系列">
                                <values>1500</values>
                            </set>
                            <set name="IE7.0">
                                <values>1000</values>
                            </set>
                            <set name="IE8.0" stackGroup="IE系列">
                                <values>3000</values>
                            </set>

                            <set name="Firefox 3.6" stackGroup="FF系列">
                                <values>850</values>
                            </set>
                            <set name="Firefox 4.0" stackGroup="FF系列">
                                <values>1541</values>
                            </set>
                            <set name="Firefox 1.0" stackGroup="FF系列">
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
                                colors: #A8CE55, #E9930F, #4D99DA, #CE5555, #DCBB29, #55BECE, #AF80DE;
                                animate:clockwise;
                                order:asc;
                            }
                        ]]>
                    </css>
                </chart>;
            
            chart.parse(content);
            
        }
        
    }

}