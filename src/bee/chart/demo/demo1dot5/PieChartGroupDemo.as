package bee.chart.demo.demo1dot5 
{
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.assemble.pie.PieChartViewer;
    import bee.chart.PieChart;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.StyleSheet;
    import flash.utils.getTimer;
    import net.hires.debug.Stats;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieChartGroupDemo extends YIDDemoBase 
    {
        public function PieChartGroupDemo() 
        {
            super();
        }   
            
        override protected function initChart():void 
        {
            super.initChart();
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
                            <set name="Chrome 10">
                                <values>1000</values>
                            </set>
                            <set name="IE6.0" stackGroup="IE系列">
                                <values>1000</values>
                            </set>
                            <set name="IE8.0" stackGroup="IE系列">
                                <values>3000</values>
                            </set>

                            <set name="Firefox 3.6" stackGroup="FF系列">
                                <values>850</values>
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
                                tip : #label#<br>#value# of #total#<br>#percent#;
                            }
                            legend {
                                position      : bottom;
                                align         : left;
                                paddingRight  : 0;
                            }
                            chart {
                                colors: #A8CE55, #E9930F, #4D99DA, #CE5555, #DCBB29, #55BECE, #AF80DE;
                                animate:clockwise;
                            }
                        ]]>
                    </css>
                </chart>;
            
            chart.parse(content);
            
            //initBtn();
        }
        
        //private function initBtn():void
        //{
            //var btn:Sprite = new Sprite();
            //var g:Graphics = btn.graphics;
            //g.beginFill(0xFF0000);
            //g.drawRect(0, 0, 50, 50);
            //g.endFill();
            //addChild(btn);
            //btn.x = 500;
            //btn.addEventListener(MouseEvent.CLICK, clickHandler);
        //}
        //
        //private function clickHandler(e:MouseEvent):void 
        //{
            //dispose();
        //}
    }

}