package bee.bugs
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
    * 数据平缓后再上扬，曲线算法，导致数据低于坐标轴，容易对用户产生误导
    * @author hua.qiuh
    */
    public class LineChartDemo extends Sprite 
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
                </categories>
                <dataset seriesName='重庆细绒棉出厂价' color='0080FF' anchorRadius='4'  anchorBorderColor='0080FF' anchorBgColor='FFFFFF'>
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='15000' /> 
                    <set value='14000' /> 
                    <set value='14000' /> 
                    <set value='15280' /> 
                    <set value='15600' /> 
                </dataset>
            </graph>;
        
        public function LineChartDemo():void 
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
                'lineMethod'        : 'curve',
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