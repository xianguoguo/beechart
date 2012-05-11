package bee.chart.demo.demo1dot5
{
    import bee.abstract.CComponent;
    import bee.chart.LineChart;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.AutoColorUtil;
    
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.text.StyleSheet;
    import flash.utils.Timer;
    
    import net.hires.debug.Stats;
	
    /**
    * 折线图表平滑过渡例子
    * @author hua.qiuh
    */
    public class LineChartSmoothDemo extends YIDDemoBase 
    {
        
        private var isData1:Boolean = false;
        
        private var btn:Sprite;
        
        private var _timer:Timer = new Timer(1500);
        
        private const DATA_XML1:XML = 
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
                    <category name='12/17' /> 
                    <category name='12/24' /> 
                    <category name='12/31' /> 
                    <category name='01/07' /> 
                    <category name='01/14' /> 
                    <category name='01/18' /> 
                </categories>
                <dataset seriesName='重庆细绒棉出厂价a' color='0080FF' anchorRadius='4'  anchorBorderColor='0080FF' anchorBgColor='FFFFFF'>
                    <set value='27000' /> 
                    <set value='27200' /> 
                    <set value='27500' /> 
                    <set value='27725' /> 
                    <set value='27560' /> 
                    <set value='27560' /> 
                </dataset>
                 <dataset seriesName='重庆细绒棉出厂价b' color='F080F0' anchorRadius='4'  anchorBorderColor='0080FF' anchorBgColor='FFFFFF'>
                    <set value='27050' /> 
                    <set value='27500' /> 
                    <set value='27200' /> 
                    <set value='27725.15' /> 
                    <set value='27500.10' /> 
                    <set value='27500.10' /> 
                </dataset>
            </graph>;
        
        public function LineChartSmoothDemo():void 
        {
            super();
        }
        
        override protected function init(e:Event = null):void 
        {
            super.init(e);
            initTimer();
        }
        
        override protected function initChart():void 
        {
            //所有类型图表的CController都是同一个：Chart
            chart = new LineChart();
            addChild(chart);
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
                'thickness.active'  : 5,
                'lineMethod'        : 'line'
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
                'labelGap'      : 0
            });
            
            style.setStyle('legend', {
                'position'      : 'bottom',
                'layout'        : 'vertical',
                'valign'        : 'top'
            });
            
            style.setStyle('tooltip', {
                'borderColor'   : '#' + DATA_XML1.@hovercapborder,
                'backgroundColor'   : '#' + DATA_XML1.@hovercapbg,
                'backgroundAlpha'   : 1
                //'borderColor'   : '#FF0000'
            });
            
            style.setStyle('line dot label', {
                'visibility'        : 'visible',
                'color'             : '#333333'
            });
            //chart.setStyle('paddingLeft', '50');
            //chart.setStyle('paddingRight', '30');
            //chart.setStyle('paddingBottom', '50');
            //chart.setStyle('paddingTop', '50');
            chart.setStyle('leftAxisVisibility', 'visible');
            chart.setStyle('smooth', 'true');
            chart.setStyle('animate', 'true');
            chart.setStyle('fix', 'auto');
			chart.setStyle(
				'colors', ["#A8CE55",
					"#E9930F", 
					"#4D99DA", 
					"#CE5555", 
					"#DCBB29",
					"#55BECE",
					"#AF80DE"].join(',')
			);
            //设置图表的尺寸，图表的主体将会显示在这个范围内
            chart.chartWidth = 600;
            chart.chartHeight = 300;
            chart.parse(DATA_XML1);
            
//            stage.addChild( new Stats() );
        }
        
        override public function dispose():void 
        {
            super.dispose();
            _timer.stop();
            _timer = null;
        }
        
        private function initTimer():void 
        {
            _timer.addEventListener(TimerEvent.TIMER, clickHandler);
            _timer.start();
        }
        
        private function clickHandler(e:Event):void
        {
            var data:CartesianChartData = chart.data as CartesianChartData;
            data.clear();
            data.defineLabel('');
            data.defineValue('', '');
            data.labels = new <String>[
                "12/17", "12/24", "12/31", "01/07", "01/14", "01/18"
            ];
            for (var i:int = 0; i < 2; i++) 
            {
                var dateSet:ChartDataSet;
                if (i == 0)
                {
                    dateSet = new ChartDataSet(
                        "重庆细绒棉出厂价a", 
                        new <Number>[27000*Math.random()>>0, 27000*Math.random()>>0, 27000*Math.random()>>0, 27000*Math.random()>>0, 27000*Math.random()>>0, 27000*Math.random()>>0],
                        {
                            style: {
                                color:'0080FF'
                            }
                        }
                    )
                }
                if (i == 1)
                {
                    dateSet = new ChartDataSet(
                        "重庆细绒棉出厂价b",     //name
                        new <Number>[27000*Math.random()>>0, 27000*Math.random()>>0, 27000*Math.random()>>0, 27000*Math.random()>>0, 27000*Math.random()>>0, 27000*Math.random()>>0], //values
                        //special configs
                        {
                            style: {
                                color:'F080F0'
                            }
                        }
                    )
                }

                data.addSet(dateSet);
            }
        }
		
    }

}