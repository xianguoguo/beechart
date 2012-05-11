package bee.chart.elements.cursor
{
    import assets.DragExec;
    import assets.DragNormal;
    import assets.MouseMoveIcon;
    import cn.alibaba.core.IDisposable;
    import cn.alibaba.util.DisplayUtil;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class Cursor extends Sprite implements IDisposable
    {
        static public const BTN_MOUSE_OVER:String = "btn_mouse_over"; //在时间选区滑块柄上的鼠标状态
        static public const OVER:String = "over"; //在时间选区、图表上鼠标移动时的状态
        static public const DOWN:String = "down"; //在时间选区、图表上鼠标按下时的状态
        static public const NONE:String = "";
        private var _cursors:Object;
        private var _lastCursor:DisplayObject;
        private var _state:String = "";
		private var _isExist:Boolean;
		
        public function Cursor()
        {
            super();
            initCursors();
            mouseChildren = false;
            mouseEnabled = false;
			_isExist = true;
        }
        
        public function dispose():void
        {
            if (_cursors)
            {
                for (var str:String in _cursors)
                {
                    delete _cursors[str];
                }
            }
            
            _cursors = null;
            _lastCursor = null;
            DisplayUtil.clearSprite(this);
			_isExist = false;
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
		
		public function get isExist():Boolean 
		{
			return _isExist;
		}
        
        private function initCursors():void
        {
			_cursors = { };
            _cursors[Cursor.BTN_MOUSE_OVER] = new MouseMoveIcon();
            _cursors[Cursor.OVER] = new DragNormal();
            _cursors[Cursor.DOWN] = new DragExec();
        }
        
        private function changeState(state:String):void
        {
            if (_lastCursor && this.contains(_lastCursor))
            {
                removeChild(_lastCursor);
            }
            if (state in _cursors)
            {
                _lastCursor = _cursors[state];
                addChild(_lastCursor);
                if (state != Cursor.BTN_MOUSE_OVER)
                {
                    _lastCursor.x = -_lastCursor.width * 0.5;
                }
            }
            else
            {
                state = Cursor.NONE;
            }
        }
    
    }

}