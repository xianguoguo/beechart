package bee.chart.demo 
{
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.assemble.bar.BarChartHorizontalPrinter;
    import bee.chart.BarChart;
    import bee.chart.HBarChart;
    import flash.display.Sprite;
    import flash.events.Event;
    import net.hires.debug.Stats;
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarChartDemo4 extends Sprite
    {
        
        public function BarChartDemo4() 
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
            var chart:HBarChart = new HBarChart();
            addChild(chart);
            var data:CartesianChartData = chart.data as CartesianChartData;
            
            //添加数据
            //1. 以dataProvider的方式提供数据
            //chart.dataProvider = ...
            //2. 直接修改数据
            data.defineLabel('月份');
            data.defineValue('营业额', '亿元');
            data.labels = new <String>[
                "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月"
            ];
			///*
            data.addSet(
                new ChartDataSet(
                    "A公司", 
                    new <Number>[343, 350, 424, 413, 415, 408, 437, 458, 452],
                    {
                        style: {
                            'valueVisibility'   : 'visible'
                        }
                    }
                )
            );
			//*/
			///*
            data.addSet(
                new ChartDataSet(
                    "B公司",     //name
                    new <Number>[59, 39, 64, 65, 66, 66, 69, 69, 71]
                )
            );
			//*/
			///*
            data.addSet(
                new ChartDataSet(
                    "C公司",     //name
                    new <Number>[39, 39, 43,44,45,45,44,43,43]
                )
            );
			//*/
			
			/**
			 * 性能压力测试
			 */
			/*
			for (var i:uint = 0; i < 100; i++) {
				var values:Vector.<Number> = new Vector.<Number>();
				for (var j:uint = 0; j < 10; j++) {
					values[j] = Math.floor(Math.random() * 500);
				}
				chart.data.addSet(
					new ChartDataSet(
						"数据"+i,
						"",
						values,
                        {
                            style: {
                                color: ColorUtil.int2str(ColorUtil.getHighSaturationColor())
                            }
                        }
					)
				);
			}
			//*/
            
            //------------------ styles --------------
            
            chart.styleSheet.setStyle('xAxis', {
                'tickThickness'  : 2,
                'tickLength'     : 5,
                'tickPosition'   : 'left',
                'labelPosition'  : 'left'
            });
            
            chart.styleSheet.setStyle('xAxis label', {
                'color' : '#FF7300',
                'color.hl' : '#FFFFFF',
                'backgroundColor.hl' : '#000000'
            });
            
            chart.styleSheet.setStyle('yAxis', {
                'tickThickness'  : 2,
                'tickLength'     : 5,
                'tickPosition'   : 'left',
                'labelPosition'  : 'center'
            });
            
            chart.styleSheet.setStyle('canvas', {
                'gridThickness' : 1,
                'gridColor'     : '#CCCCCC',
                'backgroundColor'   : '#FFFFFF',
                //'backgroundColor2'  : '#EEEEEE'
                '--': null
            });
            
            chart.styleSheet.setStyle('bar', {
                'thickness'     : 10,
                'dropShadow'    : 'none',
                'dropShadow.hl' : 'light'
            });
            
            chart.styleSheet.setStyle('bar label', {
                'color'         : 'inherit',
                'fontSize'      : 20
            });
            
            chart.styleSheet.setStyle('legend', {
                'position'      : 'bottom',
                'align'         : 'right',
                'paddingRight'  : 0
            });
            
            chart.setStyles( {
                //'paddingLeft'   : 20,
                //'paddingRight'  : 20
                'smooth'            : true,
                'leftAxisVisibility': 'visible',
                'colors': 'A9CF56,EA9410,4E9ADB,CF5656,DDBC2A,56BFCF,B081DF'
            });
            
            chart.state = ChartStates.NORMAL;
            
            stage.addChild( new Stats() );
        }
        
    }

}