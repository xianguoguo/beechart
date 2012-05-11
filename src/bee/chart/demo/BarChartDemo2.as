package bee.chart.demo 
{
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.BarChart;
    import flash.display.Sprite;
    import flash.events.Event;
    import net.hires.debug.Stats;
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarChartDemo2 extends Sprite
    {
        private var jsondata:String='{\
    "data" : {\
        "indexAxis" : {\
            "name" : "日期",\
            "unit" : "",\
            "labels" : ["20110307" ,"20110314" ,"20110321" ,"20110328"]\
        },\
        "valueAxis" : {\
            "name" : "访客数",\
            "unit" : ""\
        },\
        "dataSets" : [\
            {\
                "name" : "中高质量访客数",\
                "values" : [120, 140, 130, 110],\
                "style" : {\
                    "color" : "#0080FF"\
                }\
            },\
            {\
                "name" : "主动洽谈中高质量访客数",\
                "values" : [80, 90, 80, 70],\
                "style" : {\
                    "color" : "#FF7300"\
                }\
            },\
            {\
                "name" : "主动洽谈并成功中高质量访客数",\
                "values" : [60, 70, 60, 70],\
                "style" : {\
                    "color" : "#008034"\
                }\
            }\
        ]\
    }\
}';

        private var xmldata:XML = <chart>
                    <data>
                        <indexAxis name="日期">
                            <labels>2011-1-1, 2011-1-2, 2011-1-3, 2011-1-4, 2011-1-5, 2011-1-6, 2011-1-7, 2011-1-8, 2011-1-9, 2011-1-10, 2011-1-11, 2011-1-12</labels>
                            <labelType>String</labelType>
                        </indexAxis>
                        <valueAxis name="UV" unit="">
                        </valueAxis>
                        <dataSets>
                            
                            <set name="Firefox 1.0" stackGroup="FF">
                                <values>,,	4,	2,	4,	9,	3,	2,	5,	8,	8,	4</values>
                            </set>
                            
                            <set name="Firefox 2.0" stackGroup="FF">
                                <values>0,	53,	60,	75,	79,	76,	64,	59,	49,	50,	74,	68</values>
                            </set>
                            
                            <set name="Firefox 3.0" stackGroup="FF">
                                <values>42,4218,4516,5102,5424,5368,4958,4917,4963,5255,4926,4978</values>
                            </set>
                            
                            <set name="Firefox 3.5" stackGroup="FF">
                                <values>177,180,207,329,297,293,289,238,216,310,321,317</values>
                            </set>
                            
                            <set name="Firefox 3.6" stackGroup="FF">
                                <values>1277,1611,1935,3541,2672,2688,2654,1838,1742,2667,2581,2601</values>
                            </set>
                            
                            <set name="IE6.0" stackGroup="IE">
                                <values>146752,154962,249394,	293299,	295479,	292983,	288782,	190934,	166869,	296142,	296481,	288012</values>
                            </set>
                            
                            <set name="IE7.0" stackGroup="IE">
                                <values>71374,	75873,	136381,	158218,	158166,	155799,	149686,	91916,	79503,	149493,	149393,	147414</values>
                            </set>
                            
                            <set name="IE8.0" stackGroup="IE">
                                <values>38993,	44292,	52112,	65375,	68054,	65938,	61728,	52261,	48123,	62717,	62358,	61842</values>
                            </set>
                        </dataSets>
                    </data>
                </chart>;
        
                private var cssdata:String='line dot {\
                                               color   : inherit#color;\
                                            }\
                                            legend {\
                                               paddingRight   : 0;\
                                               position   : top;\
                                               align   : left;\
                                            }\
                                            chart {\
                                               animate   : true;\
                                               chartWidth   : 500;\
                                               chartHeight   : 300;\
                                               colors   : #A8CE55, #E9930F, #4D99DA, #CE5555, #DCBB29, #55BECE, #AF80DE;\
                                               leftAxisVisibility: visible;\
                                            }\
                                            xaxis {\
                                               tickThickness   : 0;\
                                               lineThickness   : 0;\
                                               labelPosition : center;\
                                            }\
                                            yaxis {\
                                               tickThickness   : null;\
                                               tickColor   : #666666;\
                                               lineThickness   : null;\
                                            }\
                                            tooltip {\
                                               enabled   : true;\
                                            }\
                                            canvas {\
                                               gridThickness   : 1;\
                                               gridColor   : #C1C1C1;\
                                               gridAlpha   : .5;\
                                               borderThickness   : 2;\
                                               borderColor   : #CADBF1;\
                                            }\
                                            bar {\
                                               thickness   : 10;\
                                            }';
                                            
        public function BarChartDemo2() 
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
            var chart:BarChart = new BarChart();
            addChild(chart);
            chart.chartWidth = 600;
            
            //------------------ styles --------------
            
            //chart.styleSheet.setStyle('xAxis', {
                //'tickTickness'  : 5,
                //'tickLength'    : 5,
                //'labelGap'      : 'auto',
                //'tickPosition'  : 'left',
                //'labelPosition' : 'center'
                //'labelDataType' : 'date',
                //'labelFormat'   : '%Y-%m-%d'
            //});
            //
            //chart.styleSheet.setStyle('canvas', {
                //'gridThickness' : 1,
                //'gridColor'     : '#CCCCCC',
                //'backgroundColor'   : '#FFFFFF',
                //'backgroundColor2'  : '#EEEEEE'
                //'--': null
            //});
            //
            //chart.styleSheet.setStyle('bar', {
                //'dropShadow'    : 'none',
                //'thicknessScale.hl' : 1.1
            //});
            //
            //chart.styleSheet.setStyle('bar label', {
                //'color'         : 'inherit',
                //'fontSize'      : 15
            //});
            //
            //chart.styleSheet.setStyle('legend', {
                //'position'      : 'bottom'
            //});
            //
            //chart.setStyles( {
                //'paddingLeft'   : 20,
                //'paddingRight'  : 20
                //'leftAxisVisibility': 'visible',
                //'spacing'   : 1,
                //'colors'    : '#FF7300,#000000',
                //'animate'   : 'true'
            //});
            
            chart.parseCSS(cssdata);
            chart.parse(jsondata);
            
            
            stage.addChild( new Stats() );
        }
        
    }

}