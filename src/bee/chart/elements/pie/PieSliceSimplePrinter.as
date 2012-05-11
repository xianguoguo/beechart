package bee.chart.elements.pie 
{
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
    import bee.printers.IStatePrinter;
    import flash.display.Graphics;
    import flash.display.Sprite;
    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieSliceSimplePrinter  implements IStatePrinter
    {
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            var view:PieSliceView = host as PieSliceView;
            var data:PieSliceData = view.data as PieSliceData;
            if (view) {
                while (context.numChildren) {
                    context.removeChildAt(0);
                }
                
                if (view.host.chart) {
                    var sp:Sprite = new Sprite();
                    var g:Graphics = sp.graphics;
                    g.clear();
                    g..beginFill(0xFFFFFF * Math.random());
                    g.drawRect(0, 0, view.host.chart.chartWidth, (data as PieSliceData).degree);
                    g.endFill();
                    context.addChild(sp);
                }
              
            }
        
        }
    }
}