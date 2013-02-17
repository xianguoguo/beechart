package bee.chart.elements.dot 
{
    import cn.alibaba.util.ColorUtil;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
    import bee.printers.IStatePrinter;
    import flash.display.Graphics;
    import flash.display.Sprite;
    /**
    * ...
    * @author hua.qiuh
    */
    public class DotSimplePrinter implements IStatePrinter
    {
        static private var _instance:DotSimplePrinter;
        static public function get instance():DotSimplePrinter
        {
            if (!_instance) {
                _instance = new DotSimplePrinter();
            }
            return _instance;
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            var dotView:Dot = host as Dot;
            if (dotView) {
                
                dotView.clearContent();
                
                var sp:Sprite       = new Sprite();
                var grph:Graphics   = sp.graphics;
                var rad:uint        = uint(dotView.getStyle('radius'));
                if (rad != 0)
                {
                    var color:uint      = ColorUtil.str2int(dotView.getStyle('color'));
                    var bgAlpha:Number  = StyleUtil.getNumberStyle(dotView, 'alpha', 1);
                    var bdAlpha:Number  = StyleUtil.getNumberStyle(dotView, 'borderAlpha', bgAlpha);
                    var bdColor:uint    = ColorUtil.str2int(dotView.getStyle('borderColor'));
                    var thickness:Number = Number(dotView.getStyle('borderThickness'));
                    
                    grph.lineStyle(thickness, bdColor, bdAlpha);
                    grph.beginFill(color, bgAlpha);
                    var type:String = dotView.getStyle('shape');
                    switch(type) {
                        case 'square':
                            grph.drawRoundRect( -rad, -rad, rad * 2, rad * 2, 0, 0);
                            break;
                        case 'diamond':
                            var r:Number = rad * 1.414;
                            grph.moveTo(0, -r);
                            grph.lineTo( -r, 0);
                            grph.lineTo(0, r);
                            grph.lineTo(r, 0);
                            grph.lineTo(0, -r);
                            break;
                        case 'circle':
                        default:
                            grph.drawCircle(0, 0, rad);
                            
                        }
                    grph.endFill();
                    sp.filters = StyleUtil.getFilterStyle(dotView);
                    context.addChild(sp);
                }
                grph = null;
                sp = null;
            }
        }
        
    }

}