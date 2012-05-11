package bee.chart.elements.tooltip 
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	/**
    * ...
    * @author hua.qiuh
    */
    public class TooltipTest extends Sprite
    {
        private var _tooltip:Sprite;
        private var _model:TooltipData;
        
        public function TooltipTest() 
        {
            init();
        }
        
        private function init():void
        {
            _tooltip = new Sprite();
            _tooltip.graphics.beginFill(0, .3);
            _tooltip.graphics.drawRoundRect(0, 0, 100, 50, 5, 5);
            addChild(_tooltip);
            
            _model = new TooltipData();
            _model.bounds = new Rectangle(100, 100, 500, 400);
            
            graphics.lineStyle(0, 0xFF7300, .5);
            graphics.drawRect(100, 100, 500, 400);
            
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        
        private function setTipPos(x:Number, y:Number):void
        {
           var pt:Point = _model.getFixedPosition(x, y, _tooltip.width, _tooltip.height, 20, -_tooltip.height>>1, 40, 40);
           _tooltip.x = pt.x;
           _tooltip.y = pt.y;
        }
        
        private function onMouseMove(e:MouseEvent):void 
        {
            setTipPos(mouseX, mouseY);
            e.updateAfterEvent();
        }
        
    }

}