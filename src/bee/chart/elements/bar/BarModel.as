package bee.chart.elements.bar 
{
	import cn.alibaba.core.mvcapp.CModel;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarModel extends CModel 
    {
        
        private var _horizontal:Boolean = false;
        private var _value:Number = 0;
        private var _index:uint = 0;
        private var _x:int;
        private var _barName:String = "";
        private var _group:String = "";//组别，如FF,IE
        private var _groupKey:String = "";//组的id，如FF1,FF2,IE1,IE2
        private var _visible:Boolean = true;    
        
        public function BarModel() 
        {
            
        }
        
        public function get horizontal():Boolean { return _horizontal; }
        public function set horizontal(value:Boolean):void 
        {
            if(_horizontal != value){
                _horizontal = value;
                notifyChange();
            }
        }
        
        public function get value():Number { return _value; }
        public function set value(n:Number):void 
        {
            if(_value != n) {
                _value = n;
                notifyChange();
            }
        }
        
        public function get index():uint { return _index; }
        public function set index(value:uint):void 
        {
            if(_index != value){
                _index = value;
                notifyChange();
            }
        }
        
        public function get x():int { return _x; }
        public function set x(value:int):void 
        {
            if(_x != value){
                _x = value;
                notifyChange();
            }
        }
        
        public function get barName():String { return _barName; }
        public function set barName(value:String):void 
        {
            if(_barName != value){
                _barName = value;
                notifyChange();
            }
        }
        
        public function get group():String { return _group; }
        
        public function set group(value:String):void 
        {
            _group = value;
        }
        
        public function get groupKey():String { return _groupKey; }
        
        public function set groupKey(value:String):void 
        {
            _groupKey = value;
        }
        
        public function get visible():Boolean { return _visible; }
        
        public function set visible(value:Boolean):void 
        {
            _visible = value;
        }
        
    }

}