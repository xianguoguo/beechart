package bee.chart.demo
{
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.LineChart;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import net.hires.debug.Stats;

    /**
    * Legend数据信息过长，导致超出图表范围问题.
    * @author hua.qiuh
    */
    public class LineChartDemo8 extends Sprite 
    {
        
        public function LineChartDemo8():void 
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
            
            var chart:LineChart = new LineChart();
            var jsondata:String = '{"data":{"indexAxis":{"unit":"鏃ユ湡","labels":["05\/16","05\/17","05\/18","05\/19","05\/20","05\/21","05\/22"],"name":"鏃ユ湡"},"valueAxis":{"unit":"","name":"exposurepv"},"dataSets":[{"values":["null","null","null",0,3623,1203,"null"],"name":"瀹跺眳棣栭〉杞挱鍙婂洟鎵规棩鐢ㄧ櫨璐у亸濂?"},{"values":["null","null","null",0,34689,11196,"null"],"name":"瀹跺眳棣栭〉杞挱鍙婂洟鎵归粯璁よ鍒?"}]}}';
            var cssdata:String = 'xAxis {tickColor      : #666666;tickThickness  : null;tickLength     : 0;tickPosition   : left;labelPosition  : left;labelGap       : auto;}yAxis {tickThickness  : 0;tickPosition   : left;labelPosition  : left;}canvas {borderThickness   : 2;borderColor       : #666666;backgroundColor   : #FFFFFF;backgroundColor2  : #F7F7F7;gridThickness     : 1;gridAlpha         : 0.1;vLineStyle        : dashed;}line {thickness         : 3;brighness.active:.5;thickness.active  : 4;dropShadow        : none;}line dot {color:  inherit;color.hl      : #FFFFFF;borderColor   : inherit#color;borderThickness : 3;radius        : 3;radius.hl     : 6;}chart {leftAxisVisibility: visible;colors	: #A8CE55,#E9930F,#4D99DA,#CE5555,#DCBB29,#55BECE,#AF80DE;animate : true;width: 600;height: 400;}tooltip{borderColor         :   #F47E00;backgroundColor     :   #FFFFFF;backgroundAlpha     :   0.8;}legend{position:right;paddingLeft:16;align:left;layout:vertical;valign:top;}legend label{maxchar:10}';
            //chart.loadCSS('http://style.china.alibaba.com/css/app/cbu/cms/module/chart.css');
            //设置图表的尺寸，图表的主体将会显示在这个范围内
            addChild(chart);
            chart.chartWidth = 500;
            chart.chartHeight = 830;
            chart.parseCSS(cssdata);
            chart.parse(jsondata);
            
            stage.addChild( new Stats() );
            
        }
        
        
        
    }

}