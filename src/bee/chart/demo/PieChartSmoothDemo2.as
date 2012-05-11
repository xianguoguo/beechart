package bee.chart.demo 
{
    import bee.abstract.CComponent;
    import bee.chart.PieChart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.AutoColorUtil;
    import net.hires.debug.Stats;
    
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.text.StyleSheet;
    import flash.utils.Timer;

    /**
     * pieChart图表平滑过渡例子
     * @author jianping.shenjp
     */
    public class PieChartSmoothDemo2 extends Sprite 
    {
        private var chart:PieChart;	
        
        private var num:int = 10;
        
        private var btn:Sprite;
        
        private var _timer:Timer = new Timer(1500);
        
        public function PieChartSmoothDemo2() 
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
            
            initChart();
            //initBtn();
            initTimer();
        }
        
        private function initTimer():void 
        {
            _timer.addEventListener(TimerEvent.TIMER, clickHandler);
            _timer.start();
        }
        
        private function initChart():void 
        {
            chart = new PieChart(new <Class>[
                //ClockwisePerformerPlugin,
                //PieSlice2dDrawPrinterForNormalPlugin
                //PieSlice2dDrawPrinterWithLabelPlugin
                //ToolTipCirclePrinterPlugin
            ]);
            addChild(chart);
            addData(chart);
            var styleSheet:StyleSheet = chart.styleSheet;
            styleSheet.setStyle('slice', {
                //'labelSetType'  : 'normal',
                'labelPosition':'callout'
                //'pieLineColor'    :  '#000000'
            });
            styleSheet.setStyle('slice label', {
                'fontSize' : 20,
                'color' : '#FF0000'
            });
            styleSheet.setStyle('tooltip', {
                'tip'               : '#value# of #total#<br>#percent#'
            });
            styleSheet.setStyle('legend', {
                'position'      : 'bottom',
                'align'         : 'left',
                'paddingRight'  : 0
            });
            chart.setStyles({
                'colors': ["#A8CE55",
                        "#E9930F", 
                        "#4D99DA", 
                        "#CE5555", 
                        "#DCBB29",
                        "#55BECE",
                        "#AF80DE"].join(','),
                'animate':'clockwise',
                'smooth':true
                //'sortType':"desc"
            });
            
            //chart.data.setLabels(new < String > ["", "", ""]);
            chart.chartHeight = 400;
            chart.chartWidth = 400;
            chart.state = ChartStates.NORMAL;
          /*  chart.x = 300;
            chart.y = 300;*/
            stage.addChild(new Stats());

        }
        
        private function initBtn():void 
        {
            btn = new Sprite();
            var g:Graphics = btn.graphics;
            g.beginFill(0xFFFF00);
            g.drawRect(0, 0, 50, 50);
            g.endFill();
            addChild(btn);
            btn.x = 500;
            btn.addEventListener(MouseEvent.CLICK, clickHandler);
        }
        
        private function clickHandler(e:Event):void 
        {
            chart.data.clear();
            addData(chart);
        }
		
        private function addData(chart:PieChart):void
        {
            var dataSet:ChartDataSet;
            for (var i:int = 0; i < num; i++ ) {
                var vec:Vector.<Number>= new Vector.<Number>();
                vec.push((Math.random() * 100) >> 0 );
                var config:Object = { };
                if (i == 1 || i == 3)
                {
                    config.stackGroup = "FF系列";
                }
                dataSet = new  ChartDataSet("test_" + i, vec, config);
                chart.data.addSet(dataSet);
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