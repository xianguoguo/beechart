package bee.chart.demo
{
    import bee.chart.elements.bar.Bar;
    import bee.chart.elements.bar.StackedBar;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * srackedBar平滑过渡例子（无法成功运行）
     * @author jianping.shenjp
     */

    public class BarChartSmoothDemo2 extends Sprite
    {
        private var stack:StackedBar = new StackedBar();

        private var btn:Sprite = new Sprite();

        private var _timer:Timer = new Timer(1500);

        public function BarChartSmoothDemo2()
        {
            if (stage)
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event=null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            _timer.addEventListener(TimerEvent.TIMER, clickHandler);
            _timer.start();

            initStack();

            initControlBtn();
        }

        private function initStack():void
        {
            addChild(stack);
            var bar:Bar = new Bar();
            bar.index = 0;
            bar.xIndex = 0;
            bar.value = 100;
            bar.x = bar.y = 100;
            bar.barName = "test";
            var barStyle:Object = { };
            barStyle["smooth"] = "true";
            barStyle["color"] = "0xFF0000";
            barStyle['length'] = 50;
            bar.setStyles(barStyle);

            stack.addBar(bar);

            var bar2:Bar = new Bar();
            bar2.index = 1;
            bar2.xIndex = 1;
            bar2.value = 150;
            bar2.x = 200;
            bar2.y = 100;
            bar2.barName = "test2";
            var barStyle2:Object = { };
            barStyle2["smooth"] = "true";
            barStyle2["color"] = "0xFFFF00";
            barStyle2['length'] = 75;
            bar2.setStyles(barStyle2);
            stack.addBar(bar2);
            
            stack.x = stack.y = 200;
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

            var barStyle:Object = {};
            for each (var bar:Bar in stack.bars)
            {
                //bar.smoothUpdateValue(50+Math.floor(Math.random()*100));
                var value:Number = 50 + Math.floor(Math.random() * 100);
                bar.value = value;
                bar.setStyles( { 
                    length: value
                });
            }
        }
    }
}