package bee.chart.demo {
    import bee.abstract.CComponent;
    import bee.chart.BarChart;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.AutoColorUtil;
    
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import net.hires.debug.Stats;
	
	/**
	 * BarChart 平滑过渡例子(没有组概念)
	 * @author hua.qiuh
	 */
	public class BarChartSmoothDemo3 extends Sprite {
		private var chart:BarChart = new BarChart();

		private var isUseData1:Boolean = true;

        private var _timer:Timer = new Timer(1500);

		public function BarChartSmoothDemo3(){
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
//            initBtn();
            initTimer();
		}
        
        private function initChart():void 
        {
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
                            'color'             : '#F7B521'
                        }
                    }
                )
            );
			//*/
			///*
            data.addSet(
                new ChartDataSet(
                    "B公司",     //name
                    new <Number>[59, 39, 64, 65, 66, 66, 69, 69, 71], //values
                    //special configs
                    {
                        style: {
                            color: '#9CDE29'
                        }
                    }
                )
            );
            
            chart.styleSheet.setStyle('xAxis', {
                'tickThickness'  : 2,
                'tickLength'     : 5,
                'tickPosition'   : 'left',
                'labelPosition'  : 'center',
                'labelGap'       : 'auto'
            });
            
            chart.styleSheet.setStyle('canvas', {
                'backgroundColor2'  : '#F7F7F7',
                'gridThickness'     : 1,
                'gridColor'         : '#C1C1C1',
                //'gridColor'         : '#FF0000',
                'borderThickness'   : 2,
                'borderColor'       : '#545454',
                'xgap'              : 0
            });
            
            chart.styleSheet.setStyle('bar', {
                //'borderThickness'         : 1,
                'dropShadow'    : 'none',
                'color.hl' : '#FF7300'
            });
            
            chart.styleSheet.setStyle('bar label', {
                'color'         : 'inherit',
                'fontSize'      : 15
            });
            
            chart.styleSheet.setStyle('legend', {
                'position'      : 'left',
                'align'         : 'right',
                'paddingRight'  : 0
            });
            chart.styleSheet.setStyle('chart', {
                'enableMouseTrack'      : 'false',
                'enableTooltip'         : 'false'
            });
            
            chart.setStyles( {
                'paddingLeft'   : 20,
                'paddingRight'  : 20,
                'leftAxisVisibility': 'visible',
                'smooth'    :'true',
                'fix'       : 'auto'
            });
            
			chart.chartWidth = 600;
			chart.chartHeight = 300;
            chart.state = ChartStates.NORMAL;
            
//            stage.addChild( new Stats() );
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
        
		private function clickHandler(e:Event):void {
            var data:CartesianChartData = chart.data as CartesianChartData;
            data.clear();
            data.defineLabel('月份');
            data.defineValue('营业额', '亿元');
            data.labels = new <String>[
                "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月"
            ];
            for (var i:int = 0; i < 2; i++) 
            {
                var dateSet:ChartDataSet;
                if (i == 0)
                {
                    dateSet = new ChartDataSet(
                        "A公司", 
                        new <Number>[343*Math.random(), 350*Math.random(), 424*Math.random(), 413*Math.random(), 415*Math.random(), 408*Math.random(), 437*Math.random(), 458*Math.random()],
                        {
                            style: {
                                'color'             : '#F7B521'
                            }
                        }
                    )
                }
                if (i == 1)
                {
                    dateSet = new ChartDataSet(
                        "B公司",     //name
                        new <Number>[59*Math.random(), 39*Math.random(), 64*Math.random(), 65*Math.random(), 66*Math.random(), 66*Math.random(), 69*Math.random(), 69*Math.random(), 71*Math.random()], //values
                        //special configs
                        {
                            style: {
                                color: '#9CDE29'
                            }
                        }
                    )
                }
                data.addSet(dateSet);
            }
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
			Tooltip.instance.styleSheet.clear();
		}
	}

}