package bee.chart.demo
{
    import bee.chart.elements.bar.Bar;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import com.greensock.TweenLite;

    /**
     * bar平滑过渡例子(无法成功运行)
     * @author jianping.shenjp
     */
    public class BarChartSmoothDemo extends Sprite
    {
        private var bar:Bar = new Bar();
        
        private var btn:Sprite = new Sprite();
        
        private var _timer:Timer = new Timer(1500);
        
        public function BarChartSmoothDemo()
        {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event=null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            initBar();
            initControlBtn();
            
            _timer.addEventListener(TimerEvent.TIMER, clickHandler);
            _timer.start();
		}
        
        private function initBar():void 
        {
            addChild(bar);
            bar.index = 0;
            bar.xIndex = 0;
            bar.value = 100;
            bar.x = 100;
            bar.y = 200;
            bar.setStyles( { 
                smooth : "true",
                valueVisibility:"visible",
                color:  "#FF0000",
                length: 50
            });
        }
        
        private function initControlBtn():void 
        {
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
            var value:Number = 50 + Math.floor(Math.random() * 100);
            bar.value = value;
            bar.setStyles( { 
                length: value
            });
		}
    }

}