package bee.chart.demo
{
    import bee.chart.abstract.Chart;
    import bee.chart.PieChart;
    import bee.chart.util.FusionConverter;
    import bee.plugins.pie.performer.ClockwisePerformerPlugin;
    import bee.plugins.pie.pieslice.printer.PieSlice2dDrawPrinterForNormalPlugin;
    import bee.plugins.pie.pieslice.printer.PieSlice2dDrawPrinterWithLabelPlugin;
    import bee.plugins.tooltip.ToolTipCirclePrinterPlugin;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getTimer;
    import net.hires.debug.Stats;

    /**
    *  饼图插件测试
    * @author hua.qiuh
    */
    public class PieChartDemo5 extends Sprite 
    {
        
        public function PieChartDemo5():void 
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
            
            var t:uint = getTimer();
            
            var chart:Chart = new PieChart(new <Class>[
                ClockwisePerformerPlugin,
                PieSlice2dDrawPrinterForNormalPlugin,
                PieSlice2dDrawPrinterWithLabelPlugin,
                ToolTipCirclePrinterPlugin
            ]);
            addChild(chart);
            var fcData:XML = 
            <graph  caption='Pie Chart' 
                    decimalPrecision='0' 
                    showPercentageValues='1' 
                    showNames='1' 
                    numberPrefix='$' 
                    showValues='1' 
                    showPercentageInLabel='0' 
                    pieYScale='45' 
                    pieBorderAlpha='100' 
                    pieRadius='100' 
                    animation='1' 
                    shadowXShift='4' 
                    shadowYShift='4' 
                    shadowAlpha='40' 
                    pieFillAlpha='95' 
                    pieBorderColor='FFFFFF' 
                    bgColor="f1f1f1">
               <set value='25' name='Item A' color='AFD8F8'/>
               <set value='17' name='Item B' color='F6BD0F'/>
               <set value='23' name='Item C' color='8BBA00' isSliced='1'/>
               <set value='65' name='Item D' color='A66EDD'/>
               <set value='22' name='Item E' color='F984A1'/>

            </graph>;
            
            
            chart.parseCSS('lxAxis {\
                    tickThickness  : 50;\
                    tickLength     : 5;\
                    tickPosition   : left;\
                    labelPosition  : left;\
                }\
\
                yAxis {\
                    tickTickness   : 50;\
                    tickPosition   : left;\
                    labelPosition  : left;\
                }\
\
                canvas {\
                    borderThickness   : 2;\
                    borderColor       : #666666;\
                    backgroundColor   : #FFFFFF;\
                    backgroundColor2  : #E4F2F5;\
                }\
\
                legend {\
                    position            : bottom;\
                }\
\
                line dot {\
                    color         : inherit;\
                    radius        : 5;\
                    fontSize      : 15;\
                }\
\
                chart {\
                    paddingLeft   : 20;\
                    paddingRight  : 20;\
                    width         : 300;\
                    height        : 300;\
                    colors        : #FF0000,#000000;\
                    leftAxisVisibility: visible;\
					animate:clockwise;\
                }\
                slice {\
                    labelPosition   : inside;\
                }');

            //设置图表的尺寸，图表的主体将会显示在这个范围内
            chart.chartWidth = 500;
            chart.chartHeight = 250;
            
            //chart.setStyle('mouseAnimate', 'false');
            
            chart.parse(FusionConverter.convertXML(fcData));
            trace('3: Time Elapsed:', getTimer() - t, 'ms');
            
            stage.addChild( new Stats() );
            
        }
        
        
        
    }

}