package bee.bugs {
    import bee.chart.HBarChart;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import net.hires.debug.Stats;

	/**
	 * BarChart(水平放置)平滑过渡例子（组概念），显示有问题。
	 * @author hua.qiuh
	 */
	public class BarChartSmoothDemo6 extends Sprite {
		private var chart:HBarChart = new HBarChart();

		private var isUseData1:Boolean = true;

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
                        <set name="IE6.0" stackGroup="IE">
                            <values>1000,2000</values>
                        </set>
						<set name="IE8.0" stackGroup="IE">
							<values>3000,6000</values>
						</set>
                       
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

		public function BarChartSmoothDemo6(){
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
            initBtn();
            initTimer();
		}
        
        private function initChart():void 
        {
            addChild(chart);
            //所有类型图表的CController都是同一个：Chart
			chart.chartWidth = 600;

			//------------------ styles --------------

			chart.styleSheet.setStyle('xAxis', {
                'tickTickness'  : 5,
                'tickLength'    : 5,
                'labelGap'      : 'auto',
                'tickPosition'  : 'left',
                'labelPosition' : 'center',
                'labelDataType' : 'date'
            });
            
            chart.styleSheet.setStyle('canvas', {
                'gridThickness' : 1,
                'gridColor'     : '#CCCCCC',
                'backgroundColor'   : '#FFFFFF',
                //'backgroundColor2'  : '#EEEEEE'
                '--': null
            });
            
            chart.styleSheet.setStyle('bar', {
                'valueVisibility':"visible",
                'dropShadow'    : 'none',
                'thicknessScale.hl' : 1.1
            });
            
            chart.styleSheet.setStyle('bar label', {
                'color'         : 'inherit',
                'fontSize'      : 15
            });
            
            chart.styleSheet.setStyle('legend', {
                'position'      : 'bottom'
            });
            
            chart.setStyles( {
                //'paddingLeft'   : 20,
                //'paddingRight'  : 20
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
                'smooth'    : 'true'
            });

			chart.parse(xmlData1);
            
			stage.addChild(new Stats());
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
            //_timer.start();
        }
        
		private function clickHandler(e:Event):void {
            if (isUseData1){
				chart.parse(xmlData2);
			} else {
                chart.parse(xmlData1);
			}
			isUseData1 = !isUseData1;
		}

	}

}