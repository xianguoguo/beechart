package bee.chart.elements.legend.item.icon 
{
    import cn.alibaba.util.DisplayUtil;
    import bee.util.StyleUtil;
    import flash.display.CapsStyle;
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
    import bee.printers.IStatePrinter;
    import flash.display.Graphics;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
	/**
     * ...
     * @author hua.qiuh
     */
    public class LegendItemIconSimplePrinter implements IStatePrinter 
    {
        
        public function LegendItemIconSimplePrinter() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            var icon:LegendItemIcon = host as LegendItemIcon;
            if (icon) {
                DisplayUtil.clearSprite(context);
                
                var sp:Shape  = new Shape();
                var g:Graphics  = sp.graphics;
                var size:Number = StyleUtil.getNumberStyle(icon, 'size', 20);
                var color:uint  = StyleUtil.getColorStyle(icon);
                g.lineStyle(size, color, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
                g.moveTo(0, 0);
                g.lineTo(size, 0);
                context.addChild(sp);
            }
        }
        
    }

}