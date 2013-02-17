package bee.chart.demo
{
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSliceData;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import net.hires.debug.Stats;

    /**
     * pieSlice平滑过渡例子(无法成功运行)
     * @author jianping.shenjp
     */
    public class PieChartSmoothDemo extends Sprite
    {
        private var pieSlice:PieSlice;

        private var btn:Sprite;

        public function PieChartSmoothDemo()
        {
            if (stage)
            {
                init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
        }

        private function init(e:Event=null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            initPieSlice();
            initBtn();
        }

        private function initPieSlice():void
        {
            pieSlice = new PieSlice();
            addChild(pieSlice);
            var data:PieSliceData = new PieSliceData();
            data.value = 100;
            data.name = "123456";
            data.index = 0;
            data.radian = Math.PI / 3;
            data.radius = 200;
            data.startRadian = 0;
            data.color = 0xFFFF00;
            data.pieSliceCanvasX = stage.stageWidth / 2;
            data.pieSliceCanvasY = stage.stageHeight / 2;
            pieSlice.setModel(data);
            pieSlice.name = 'slice' + 0;
            pieSlice.setStyles( { 'smooth': true } );
            //pieSlice.state = "normal";
            stage.addChild(new Stats());

        }

        private function initBtn():void
        {
            btn = new Sprite();
            var g:Graphics = btn.graphics;
            g.beginFill(0xFF0000);
            g.drawRect(0, 0, 50, 50);
            g.endFill();
            addChild(btn);
            btn.x = 500;
            btn.addEventListener(MouseEvent.CLICK, clickHandler);
        }

        private function clickHandler(e:Event):void
        {
            var data:PieSliceData = (pieSlice.model as PieSliceData);
            data.value = 10;
            var radian:Number = Math.PI / 2 * Math.random();
            //trace("before:", radian);
            data.radian = radian;
            data.startRadian = radian;
        }
    }

}