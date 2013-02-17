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
    public class PieChartDemo3 extends Sprite 
    {
        private var chart:Chart;		
        public function PieChartDemo3() 
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
            
            var t:uint = getTimer();
            
            chart = new PieChart();
            addChild(chart);
            //vec = new <Number>[52236,9560,6367,5870,2627,2360,2068,1747,1231,1187,500,500,600,700];
            //测试
            var num:int = 30;
            for (var i:int = 0; i < num; i++ ) {
                   /* if (i == 10||i==11||i==12) {
                    vec.push(100);
                    }else{
                    vec.push(1);
                    }*/
                var vec:Vector.<Number>= new Vector.<Number>();
                vec.push(10 * Math.random() );
                var styleObject:Object;
               /* if (i < num/2) {
                    styleObject={
                            labelSetType    : 'normal',
                            labelPosition   : 'inside'
                        };
                } else {
                    styleObject={
                            labelSetType    : 'dip',
                            labelPosition   : 'inside'
                        };
                }*/
                styleObject={};

                chart.data.addSet(new ChartDataSet("test_"+i, vec,{
                        style: styleObject
                    }));
            }
            
            //var styleSheet:StyleSheet = chart.styleSheet;
            //styleSheet.setStyle('slice', {
                //'labelSetType'    : 'normal',
                //'labelPosition'   : 'outside',
                //'offsetRadius'    : 20,
                //'offsetRadius.hl' : 40
            //});
            //styleSheet.setStyle('tooltip', {
                //'tip'               : '#value# of #total#<br>#percent#'
            //});
            //styleSheet.setStyle('legend', {
                //'position'      : 'bottom',
                //'align'         : 'left',
                //'paddingRight'  : 0
            //});
            //styleSheet.setStyle('chart', {
                //'colors':["#A8CE55", 
                        //"#E9930F", 
                        //"#4D99DA", 
                        //"#CE5555", 
                        //"#DCBB29",
                        //"#55BECE",
                        //"#AF80DE"]
            //});
            chart.parseCSS("chart{colors:#A8CE55, #E9930F, #4D99DA, #CE5555, #DCBB29,#55BECE,#AF80DE}slice {labelPosition:outside!;}");
            //chart.data.setLabels(new < String > ["", "", ""]);
            //chart.chartHeight = 250;
            //chart.chartWidth = 250;
            chart.state = ChartStates.NORMAL;
            
            trace('3: Time Elapsed:', getTimer() - t, 'ms');
            
            stage.addChild(new Stats());
            

        }
        
    }

}