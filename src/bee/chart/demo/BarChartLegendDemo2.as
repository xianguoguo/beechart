package bee.chart.demo {
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.BarChart;
    import bee.chart.release.BeeBarChart;
    import bee.chart.release.BeeHBarChart;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import net.hires.debug.Stats;
	import bee.abstract.CComponent;
	import bee.chart.util.AutoColorUtil;
	/**
	 * BarChart平滑过渡例子（组概念）
	 * @author hua.qiuh
	 */
	public class BarChartLegendDemo2 extends Sprite {
        
		private var chart:BeeBarChart = new BeeBarChart();

        private var _timer:Timer = new Timer(1500);
        
		private var xmlData1:XML =  <chart>
				<data>
					<indexAxis name="日期">
						<labels>2011-1-1, 2011-1-2</labels>
						<labelType>String</labelType>
					</indexAxis>
					<valueAxis name="UV" unit="">
					</valueAxis>
					<dataSets>
                    
                        <set name="Firefox 1.0" stackGroup="FF">
                            <values>2000,4000</values>
                        </set>
						<set name="Firefox 3.6" stackGroup="FF">
							<values>4000,8000</values>
						</set>
                        <!--
                        <set name="IE6.0" stackGroup="IE">
                            <values>1000,2000</values>
                        </set>
						<set name="IE8.0" stackGroup="IE">
							<values>3000,6000</values>
						</set>
                        -->
                        <!--
                            <set name="Firefox 3.6" stackGroup="FFA">
                                <values>4000,8000</values>
                            </set>
                            <set name="Firefox 1.0" stackGroup="FF">
                                <values>2000,4000</values>
                            </set>
                            <set name="apache 2.0">
                                <values>2000,4000</values>
                            </set>
                            <set name="Firefox 3.6" stackGroup="FF">
                                <values>4000,8000</values>
                            </set>
                            <set name="IE6.0" stackGroup="IE">
                                <values>1000,2000</values>
                            </set>
                            <set name="apache 3.0">
                                <values>3500,4500</values>
                            </set>
                            <set name="IE8.0" stackGroup="IE">
                                <values>3000,6000</values>
                            </set>
						 -->
					</dataSets>
				</data>
			</chart>;

        private var xmlData2:XML =  <chart>
				<data>
					<indexAxis name="日期">
						<labels>2011-1-1, 2011-1-2</labels>
						<labelType>String</labelType>
					</indexAxis>
					<valueAxis name="UV" unit="">
					</valueAxis>
					<dataSets>
                        <set name="Firefox 1.0" stackGroup="FF">
                            <values>4000,8000</values>
                        </set>
						<set name="Firefox 3.6" stackGroup="FF">
							<values>8000,16000</values>
						</set>
                        <set name="IE6.0" stackGroup="IE">
                                <values>2000,4000</values>
                        </set>
						<set name="IE8.0" stackGroup="IE">
							<values>4000,8000</values>
						</set>
					</dataSets>
				</data>
			</chart>;

		public function BarChartLegendDemo2(){
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event=null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.align = 'TL';
			stage.scaleMode = 'noScale';

            initChart();
            //initBtn();
            //initTimer();
		}
        
        private function initChart():void 
        {
            addChild(chart);
            //所有类型图表的CController都是同一个：Chart
			chart.chartWidth = 600;	
			chart.chartHeight = 300;

			//------------------ styles --------------

			chart.styleSheet.setStyle('xAxis', {
                'tickTickness'  : 5,
                'tickLength'    : 5,
                'labelGap'      : 'auto',
                'tickPosition'  : 'left',
                'labelPosition' : 'center',
                'labelDataType' : 'date',
                'labelFormat'   : '%Y-%m-%d'
            });
            
            chart.styleSheet.setStyle('canvas', {
                'gridThickness' : 1,
                'gridColor'     : '#CCCCCC',
                'backgroundColor'   : '#FFFFFF',
                //'backgroundColor2'  : '#EEEEEE'
                '--': null
            });
            
            chart.styleSheet.setStyle('bar', {
                //'valueVisibility':"visible",
                'dropShadow'    : 'none',
                'thicknessScale.hl' : 1.1,
                'brightness' : 0,
                'brightness.hl' : 0.2
            });
            
            chart.styleSheet.setStyle('bar label', {
                'color'         : 'inherit',
                'fontSize'      : 15
            });
            
            chart.styleSheet.setStyle('legend', {
                'position'      : 'bottom'
            });
            chart.setStyles( {
                'paddingLeft':'20',
                'paddingRight':'30',
                'leftAxisVisibility': 'visible',
                'spacing'   : 1,
                'colors': ["#A8CE55",
                        "#E9930F", 
                        "#4D99DA", 
                        "#CE5555", 
                        "#DCBB29",
                        "#55BECE",
                        "#AF80DE"].join(','),
                'animate'   : 'true',
                'smooth'    : 'true',
                'fix'       : 'auto'
            });

			chart.parse(xmlData1);
            
            //clickHandler();
            //chart.state = ChartStates.NORMAL;
			//stage.addChild(new Stats());
        }
        
        private function initBtn():void 
        {
            var btn:Sprite = new Sprite();
			var g:Graphics = btn.graphics;
			g.beginFill(0xFF0000);
			g.drawRect(0, 0, 50, 50);
			g.endFill();
			addChild(btn);
			btn.x = 500;
			btn.addEventListener(MouseEvent.CLICK, clickHandler);
        }

        private function initTimer():void 
        {
            _timer.addEventListener(TimerEvent.TIMER, clickHandler);
            _timer.start();
        }
        
		private function clickHandler(e:Event = null):void {
            
            //return;
            var data:CartesianChartData = chart.data as CartesianChartData;
            data.clear();
            data.defineLabel('日期');
            data.defineValue('UV', '');
            data.labels = new <String>[
                "2011-1-1", "2011-1-2"
            ];
            for (var i:int = 0; i < 4; i++) 
            {
                var dateSet:ChartDataSet;
                if (i == 0)
                {
                    dateSet = new ChartDataSet(
                        "Firefox 1.0", 
                        new <Number>[2000*Math.random()>>0, 4000*Math.random()>>0],
                        {
                            stackGroup:"FF",
                            style: {
                            }
                        }
                    )
                }
                if (i == 1)
                {
                    dateSet = new ChartDataSet(
                        "Firefox 3.6",     //name
                        new <Number>[4000*Math.random()>>0, 8000*Math.random()>>0], //values
                        //special configs
                        {
                            stackGroup:"FF",
                            style: {
                            }
                        }
                    )
                }
                if (i == 2)
                {
                    dateSet = new ChartDataSet(
                        "IE6.0",     //name
                        new <Number>[1000*Math.random()>>0, 2000*Math.random()>>0], //values
                        //special configs
                        { 
                            stackGroup:"IE",
                            style: {
                            }
                        }
                    )
                }
                if (i == 3)
                {
                    dateSet = new ChartDataSet(
                        "IE8.0",     //name
                        new <Number>[3000*Math.random()>>0, 6000*Math.random()>>0], //values
                        //special configs
                        {
                            stackGroup:"IE",
                            style: {
                            }
                        }
                    )
                }
                data.addSet(dateSet);
            }
import bee.chart.util.AutoColorUtil;

		}
		
		/**
		 * 清除数据的接口
		 * */
		public function dispose():void
		{
			(chart.view as CComponent).clearContent();
			chart.dispose();
			_timer.stop();
			_timer=null;
			AutoColorUtil.reset();
		}

	}

}