package bee.chart.elements.canvas 
{
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.IStatesHost;
    import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
    
    import flash.display.CapsStyle;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.Shape;

	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartCanvasSimplePrinter implements IStatePrinter
    {
        
        public function ChartCanvasSimplePrinter() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            var canvas:ChartCanvasView = host as ChartCanvasView;
            if(canvas){
                var color:uint          = StyleUtil.getColorStyle(canvas, 'backgroundColor');
                var alpha:Number        = StyleUtil.getNumberStyle(canvas, 'backgroundAlpha', 1);
                var bdThickness:Number  = StyleUtil.getNumberStyle(canvas, 'borderThickness');
                var bdColor:uint        = StyleUtil.getColorStyle(canvas, 'borderColor');
                var bdAlpha:Number      = StyleUtil.getNumberStyle(canvas, 'borderAlpha', 1);
                var width:Number        = StyleUtil.getNumberStyle(canvas, 'width');
                var height:Number       = StyleUtil.getNumberStyle(canvas, 'height');
                
                DisplayUtil.clearSprite(context);
                
                var sp:Shape = new Shape();
                sp.name = ChartCanvasView.BG_SHAPE_NAME;
                var grph:Graphics = sp.graphics;
                grph.beginFill( color, alpha );
                grph.drawRect( 0, -height, width, height );
                grph.endFill();
                context.addChild(sp);
                
                if (bdThickness) {
                    sp = new Shape();
                    sp.name = ChartCanvasView.BORDER_SHAPE_NAME;
                    grph = sp.graphics;
                    grph.lineStyle(bdThickness, bdColor, bdAlpha, true, 'normal', CapsStyle.NONE, JointStyle.BEVEL);
                    grph.drawRect( 0, -height, width, height );
                    grph.lineStyle();
                }
                context.addChild(sp);
                
            }
        }
        
    }

}