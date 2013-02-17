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
    * ...
    * @author hua.qiuh
    */
    public class LineChartDemo6 extends Sprite 
    {
        
        private const DATA_XML:XML = 
            <graph 
                seriesNameInToolTip = '0' 
                toolTipSepChar = ' '
                bgColor = 'FFFFFF' 
                borderColor = 'FFFFFF' 
                subcaption = '' 
                hovercapbg = 'FFECAA' 
                hovercapborder = 'F47E00' 
                formatNumberScale = '0' 
                decimalPrecision = '0' 
                showvalues = '0' 
                numdivlines = '5' 
                numVdivlines = '0' 
                yaxisminvalue = '13850' 
                yaxismaxvalue = '30590'    
                rotateYAxisName = '1'   
                rotateNames = '1' 
                slantLabels = '1' 
                showhovercap = '1' 
                baseFontSize = '12' 
                yAxisName=''  >
                <categories>
                    <category name='02/26' /> 
                    <category name='03/05' /> 
                    <category name='03/12' /> 
                    <category name='03/19' /> 
                    <category name='03/26' /> 
                    <category name='04/02' /> 
                    <category name='04/09' /> 
                    <category name='04/16' /> 
                    <category name='04/23' /> 
                    <category name='04/30' /> 
                    <category name='05/07' /> 
                    <category name='05/14' /> 
                    <category name='05/21' /> 
                    <category name='05/28' /> 
                    <category name='06/04' /> 
                    <category name='06/11' /> 
                    <category name='06/18' /> 
                    <category name='06/25' /> 
                    <category name='07/02' /> 
                    <category name='07/09' /> 
                    <category name='07/16' /> 
                    <category name='07/23' /> 
                    <category name='07/30' /> 
                    <category name='08/06' /> 
                    <category name='08/13' /> 
                    <category name='08/20' /> 
                    <category name='08/27' /> 
                    <category name='09/03' /> 
                    <category name='09/10' /> 
                    <category name='09/17' /> 
                    <category name='09/24' /> 
                    <category name='10/01' /> 
                    <category name='10/08' /> 
                    <category name='10/15' /> 
                    <category name='10/22' /> 
                    <category name='10/29' /> 
                    <category name='11/05' /> 
                    <category name='11/12' /> 
                    <category name='11/19' /> 
                    <category name='11/26' /> 
                    <category name='12/03' /> 
                    <category name='12/10' /> 
                    <category name='12/17' /> 
                    <category name='12/24' /> 
                    <category name='12/31' /> 
                    <category name='01/07' /> 
                    <category name='01/14' /> 
                </categories>
                <dataset seriesName='重庆细绒棉出厂价' color='0080FF' anchorRadius='4'  anchorBorderColor='0080FF' anchorBgColor='FFFFFF'>
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='15280' /> 
                    <set value='15600' /> 
                    <set value='15600' /> 
                    <set value='15600' /> 
                    <set value='15600' /> 
                    <set value='16160' /> 
                    <set value='17000' /> 
                    <set value='17000' /> 
                    <set value='17000' /> 
                    <set value='17200' /> 
                    <set value='17500' /> 
                    <set value='17500' /> 
                    <set value='17500' /> 
                    <set value='17500' /> 
                    <set value='17500' /> 
                    <set value='17500' /> 
                    <set value='17700' /> 
                    <set value='17660' /> 
                    <set value='17700' /> 
                    <set value='17700' /> 
                    <set value='17700' /> 
                    <set value='17700' /> 
                    <set value='17700' /> 
                    <set value='18225' /> 
                    <set value='18400' /> 
                    <set value='22560' /> 
                    <set value='24040' /> 
                    <set value='25620' /> 
                    <set value='25800' /> 
                    <set value='30175' /> 
                    <set value='30440' /> 
                    <set value='29000' /> 
                    <set value='29000' /> 
                    <set value='28100' /> 
                    <set value='27500' /> 
                    <set value='27500' /> 
                    <set value='27500' /> 
                    <set value='27725' /> 
                    <set value='27560' /> 
                </dataset>
            </graph>;
        
        public function LineChartDemo6():void 
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
            
            //所有类型图表的CController都是同一个：Chart
            var chart:LineChart = new LineChart();
            var data:ChartData = chart.data;
            
            //添加数据
            
            /**
            * 来自FusionChart的数据
            */
            //1. 以dataProvider的方式提供数据
            //chart.dataProvider = ...
            //2. 直接修改数据
            data.defineLabel('日期');
            data.defineValue('价格', '元/吨');
            chart.parse(DATA_XML);
			//*/
            var style:StyleSheet = chart.styleSheet;
            style.setStyle('canvas', {
                'backgroundColor2'  : '#F7F7F7',
                'gridThickness'     : 1,
                'gridColor'         : '#C1C1C1',
                //'gridColor'         : '#FF0000',
                'borderThickness'   : 2,
                'borderColor'       : '#545454',
                'xgap'              : 0
            });
            
            style.setStyle('line', {
                'thickness'         : 2,
                'alpha'	            : 1,
                'thickness.active'  : 2,
                'lineMethod'        : 'line',
                "fillType"          :"gradient",
                'fillAlpha.active'  :0.1
            });
            
            style.setStyle('line dot', {
                'color'         : '#FFFFFF',
                'color.hl'      : 'inherit#color',
                'borderThickness'   : 1,
                'borderThickness.hl'   : 2,
                'borderColor'   : 'inherit#color',
                'borderColor.hl'   : '#FFFFFF',
                'radius'        : 3,
                'radius.hl'     : 6
            });
            
            style.setStyle('yAxis', {
                'tickColor'     : '#666666',
                'lineThickness' : null,
                'tickThickness' : null
            });
            
            style.setStyle('xAxis', {
                'lineThickness' : null,
                'tickThickness' : null,
                'labelGap'      : 2
            });
            
            style.setStyle('legend', {
                'position'      : 'bottom',
                'layout'        : 'vertical',
                'valign'        : 'top'
            });
            
            style.setStyle('tooltip', {
                'borderColor'   : '#' + DATA_XML.@hovercapborder,
                'backgroundColor'   : '#' + DATA_XML.@hovercapbg,
                'backgroundAlpha'   : 1
                //'borderColor'   : '#FF0000'
                
            });
            style.setStyle('line dot label', {
                'visibility'        : 'visible',
                'color'             : '#333333'
            });
            chart.setStyle('leftAxisVisibility', 'visible');
            
            //设置图表的尺寸，图表的主体将会显示在这个范围内
            chart.chartWidth = 600;
            chart.chartHeight = 300;
            
            addChild(chart);
            
            stage.addChild( new Stats() );
            
        }
        
        
    }

}