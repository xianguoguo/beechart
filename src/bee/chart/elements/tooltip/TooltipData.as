package bee.chart.elements.tooltip 
{
    import cn.alibaba.core.mvcapp.CModel;
    import bee.chart.abstract.Chart;
	import bee.chart.abstract.I2VPoint;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	/**
    * ...
    * @author hua.qiuh
    */
    public class TooltipData extends CModel
    {
        
        private var _text:String = "";
        private var _bounds:Rectangle;
        private var _location:I2VPoint = new I2VPoint();
        private var _textGen:Function;
        
        public function TooltipData() 
        {
            
        }
        
        public function getTipText( chart:Chart, location:I2VPoint = null):String
        {
            location = location || _location;
            return _textGen is Function ? _textGen( chart, location.index, location.value ) : _text;
        }
        
        /**
        * 寻找(centerX, centerY)附近的最佳位置以显示提示
        * 匹配原则：
        * 1. 不超出 bounds 和 margin 指定的范围
        * 2. 尽量不挡住鼠标。尽量显示在中心点的左侧区域。
        * @param	centerX 中心点横坐标
        * @param	centerY 中心点纵坐标
        * @param	width   tip的宽度
        * @param	height  tip的高度
        * @param    distX   tip在x方向上与中心点的距离
        * @param    distY   tip在y方向上与中心点的距离
        * @param    marginX tip在x方向上与边界的距离
        * @param    marginY tip在y方向上与边界的距离
        * @return   tip的最佳位置
        */
        public function getFixedPosition(centerX:Number, centerY:Number, width:Number=0, height:Number=0, distX:Number=0, distY:Number=0, marginX:Number=0, marginY:Number=0):Point
        {
            var x:Number, y:Number;
            if (_bounds) {
                
                var rect:Rectangle = new Rectangle(
                    _bounds.x + marginX, _bounds.y + marginY,
                    _bounds.width - marginX * 2, _bounds.height - marginY * 2
                );
                var bdcX:Number = rect.left + (rect.width >> 1);
                var bdcY:Number = rect.top + (rect.height >> 1);
                if (centerX > rect.left + distX + width) {
                    //在右侧区域
                    x = centerX - distX - width;
                } else {
                    //左侧区域
                    x = centerX + distX;
                }
                if (centerY > bdcY) {
                    //下方区域
                    y = centerY - distY - height;
                } else {
                    //上方区域
                    y = centerY + distY;
                }
                if (x > rect.right - width) x = rect.right - width;
                if (x < rect.left) x = rect.left;
                if (y > rect.bottom - height) y = rect.bottom - height;
                if (y < rect.top) y = rect.top;
                
            } else {
                x = centerX + distX;
                y = centerY + distY;
            }
            return new Point(x, y);
        }
        
        override public function dispose():void 
        {
            _bounds = null;
            _location = null;
            _textGen = null;
            super.dispose();
        }
        
        public function get text():String { return _text; }
        public function set text(value:String):void 
        {
            if(value != _text){
                _text = value;
                notifyChange();
            }
        }
        
        public function get bounds():Rectangle { return _bounds.clone(); }
        public function set bounds(value:Rectangle):void 
        {
            if(!_bounds || !_bounds.equals(value)){
                _bounds = value ? value.clone() : null;
                notifyChange();
            }
        }
        
        public function get location():I2VPoint { return _location; }
        public function set location(value:I2VPoint):void 
        {
            if(value && (!_location || !value.equals(_location))){
                _location = value.clone();
                notifyChange();
            }
        }
        
        public function get textGen():Function { return _textGen; }
        public function set textGen(value:Function):void 
        {
            _textGen = value;
        }
        
    }

}