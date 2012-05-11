package bee.chart.util 
{
    import assets.SlashBackground;
    import cn.alibaba.core.IDisposable;
    import cn.alibaba.util.DisplayUtil;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;
	
	/**
     * 滚动的斜线图案
     * @author hua.qiuh
     */
    public class SlashMask extends Sprite implements IDisposable
    {
        static private const BGIMG:BitmapData = new SlashBackground(4,4);
        private var shape:Shape;
        private var _width:Number = 0;
        private var _height:Number = 0;
        
        public function SlashMask(width:Number=0, height:Number=0) 
        {
            initShape();
            setSize(width, height);
        }
        
        public function setSize(width:Number, height:Number):void 
        {
            _width = width;
            _height = height;
            
            if (width && height) {
                
                drawMask();
                startScroll();
            } else {
                stopScroll();
            }
        }
        
        private function drawMask():void 
        {
            var grph:Graphics = shape.graphics;
            grph.clear();
            grph.beginBitmapFill( BGIMG );
            grph.drawRect(0, 0, _width-2, _height>0 ? _height+5 : _height-5);
            grph.endFill();
            shape.y = shape.x = 1;
            
            shape.scrollRect = new Rectangle(0, 0, _width, _height > 0 ? _height-1 : _height + 1);
        }
        
        public function startScroll():void 
        {
            addEventListener(Event.ENTER_FRAME, doScroll);
        }
        
        public function stopScroll():void 
        {
            removeEventListener(Event.ENTER_FRAME, doScroll);
        }
        
        public function dispose():void
        {
            stopScroll();
            removeEventListener(Event.ADDED_TO_STAGE, onAdd);
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
            DisplayUtil.clearSprite(this);
        }
        
        override public function set width(value:Number):void 
        {
            setSize(value, _height);
        }
        
        override public function set height(value:Number):void 
        {
            setSize(_width, value);
        }
        
        private function initShape():void 
        {
            shape = new Shape();
            addChild(shape);
            
            addEventListener(Event.ADDED_TO_STAGE, onAdd);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
        }
        
        private function doScroll(e:Event=null):void 
        {
            var rect:Rectangle = shape.scrollRect;
            var y:Number = rect.y + 1;
            if (y >= 4) y = 0;
            rect.y = y;
            shape.scrollRect = rect;
        }
        
        private function onRemove(e:Event):void 
        {
            stopScroll();
        }
        
        private function onAdd(e:Event):void 
        {
            if(_width && _height) startScroll();
        }
        
    }

}