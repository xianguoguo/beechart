package bee.chart.elements.guideline 
{
    import cn.alibaba.util.DisplayUtil;
    import bee.util.StyleUtil;
    import flash.display.CapsStyle;
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
    import bee.printers.IStatePrinter;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
	/**
     * ...
     * @author hua.qiuh
     */
    public class GuideLineSimplePrinter implements IStatePrinter 
    {
        
        public function GuideLineSimplePrinter() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            var view:GuideLine = host as GuideLine;
            if (view) 
            {
                DisplayUtil.clearSprite(context);
                var sp:Shape        = new Shape();
                var g:Graphics      = sp.graphics;
                var color:uint      = StyleUtil.getColorStyle(view);
                var length:Number   = StyleUtil.getNumberStyle(view, 'length');
                var alpha:Number    = StyleUtil.getNumberStyle(view, 'alpha', 1);
                var fat:Number      = StyleUtil.getNumberStyle(view, 'thickness');
                g.lineStyle(fat, color, alpha, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.BEVEL);
                g.lineTo(0, length);
                context.addChild(sp);
            }
        }
        
    }

}
