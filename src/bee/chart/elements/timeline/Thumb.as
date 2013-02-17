package bee.chart.elements.timeline
{
    import assets.ThumbHover;
    import assets.ThumbNormal;
    import cn.alibaba.core.IDisposable;
    import cn.alibaba.util.DisplayUtil;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class Thumb extends Sprite implements IDisposable
    {
        static public const THUMB_WIDTH:Number = 9;
        static public const THUMB_HEIGHT:Number = 16;
        static public const NONE:String = "";
        static public const NORMAL:String = "normal";
        static public const OVER:String = "over";
        private var thumbs:Object = {};
        private var _lastThumb:DisplayObject;
        private var _state:String = "";
        
        public function Thumb()
        {
            mouseChildren = false;
            init();
        }
        
        internal function get state():String
        {
            return _state;
        }
        
        internal function set state(value:String):void
        {
            if (_state != value)
            {
                _state = value;
                changeState(value);
            }
        }
        
        private function changeState(state:String):void
        {
            if (_lastThumb && this.contains(_lastThumb))
            {
                removeChild(_lastThumb);
            }
            if (state in thumbs)
            {
                _lastThumb = thumbs[state];
                _lastThumb.x = -Thumb.THUMB_WIDTH * 0.5;
                addChild(_lastThumb);
            }
            else
            {
                state = Thumb.NONE;
            }
        }
        
        public function dispose():void
        {
            if (thumbs)
            {
                for (var str:String in thumbs)
                {
                    delete thumbs[str];
                }
            }
            DisplayUtil.clearSprite(this);
            thumbs = null;
        }
        
        private function init():void
        {
            thumbs[Thumb.NORMAL] = new ThumbNormal();
            thumbs[Thumb.OVER] = new ThumbHover();
        }
    }

}