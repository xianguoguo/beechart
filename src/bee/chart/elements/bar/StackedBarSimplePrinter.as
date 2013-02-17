package bee.chart.elements.bar 
{
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.ChartViewer;
    import bee.printers.IStatePrinterWithUpdate;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import com.greensock.TweenLite;
	
	/**f
    * ...
    * @author hua.qiuh
    */
    public class StackedBarSimplePrinter implements IStatePrinterWithUpdate, IStackedBarPrinter
    {
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            var view:StackedBarView = host as StackedBarView;
            if (view) {
                var stack:StackedBar = view.host as StackedBar;
                clearSprite(context);
                var bars:Vector.<Bar> = stack.bars;
                for each(var bar:Bar in bars) 
                {
                    context.addChild(bar);
                }
            }
        }
        
        public function getBarIndexAt(x:Number, y:Number, context:DisplayObjectContainer):int
        {
            var total:uint = context.numChildren;
            var bar:DisplayObject;
            for (var i:uint = 0; i < total; i++) {
                bar = context.getChildAt(i);
                if (bar.getRect(context).contains(x, y)) {
                    return i;
                }
            }
            return -1;
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinterWithUpdate */
        
        public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            if (!context.numChildren) {
                renderState(host, state, context);
                return;
            }
            var view:StackedBarView = host as StackedBarView;
            var h:Number = view.height;
            var setX:Number = view.x;
            var stack:StackedBar = view.host as StackedBar;
            updateBars(stack);
            var chartview:ChartViewer = view.chart.view as ChartViewer;
            TweenLite.from(view, .5,
                {
                    height:h,
                    onStart:function():void
                    {
                        view.state = 'normal';
                        chartview.isSmoothing = true;
                    },
                    onComplete:function():void
                    {
                        chartview.isSmoothing = false;
                    }
                }
            )
        }
        
        private function updateBars(stack:StackedBar):void 
        {
            var bars:Vector.<Bar> = stack.bars;
            for each (var bar:Bar in bars) 
            {
                bar.updateViewNow();
            }
        }
        
        private function clearSprite( sp:DisplayObjectContainer ):void
        {
            while (sp.numChildren) {
                sp.removeChildAt(0);
            }
            if(sp is Sprite){
                Sprite(sp).graphics.clear();
                Sprite(sp).filters = [];
            }
        }
    }
}