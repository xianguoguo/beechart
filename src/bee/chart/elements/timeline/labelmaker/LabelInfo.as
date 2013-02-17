package bee.chart.elements.timeline.labelmaker
{
    import flash.geom.Point;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class LabelInfo
    {
        private var _index:int = -1;
        private var _text:String = "";
        private var _textVisible:Boolean;
        private var _lineVisible:Boolean;
        private var _pos:Point;
        private var _width:Number;
        private var _height:Number;
        
        public function LabelInfo(text:String = "", textVisible:Boolean = false, lineVisible:Boolean = false)
        {
            this.text = text;
            this.textVisible = textVisible;
			this.lineVisible = lineVisible;
        }
        
        public function get index():int
        {
            return _index;
        }
        
        public function set index(value:int):void
        {
            if (value != _index)
            {
                _index = value;
            }
        }
        
        public function get textVisible():Boolean
        {
            return _textVisible;
        }
        
        public function set textVisible(value:Boolean):void
        {
            if (value != _textVisible)
            {
                _textVisible = value;
            }
        }
        
		public function get lineVisible():Boolean
        {
            return _lineVisible;
        }
        
        public function set lineVisible(value:Boolean):void
        {
            if (value != _lineVisible)
            {
                _lineVisible = value;
            }
        }
		
        public function get text():String
        {
            return _text;
        }
        
        public function set text(value:String):void
        {
            if (value != _text)
            {
                _text = value;
            }
        }
        
        public function get pos():Point
        {
            return _pos ? _pos.clone() : null;
        }
        
        public function set pos(value:Point):void
        {
            if (!_pos || (value && !value.equals(_pos)))
            {
                _pos = value;
            }
        }
        
        public function get width():Number
        {
            return _width;
        }
        
        public function set width(value:Number):void
        {
            _width = value;
        }
        
        public function get height():Number
        {
            return _height;
        }
        
        public function set height(value:Number):void
        {
            _height = value;
        }
        
        public function getLabelHorCenter():Number
        {
            return _pos.x + (width >> 1);
        }
        
        public function clone():LabelInfo
        {
            var clone:LabelInfo = new LabelInfo();
            clone.index = _index;
            clone.text = _text;
            clone.textVisible = _textVisible;
            clone.lineVisible = textVisible;
            clone.pos = _pos;
            clone.width = _width;
            clone.height = _height;
            return clone;
        }
    }
}