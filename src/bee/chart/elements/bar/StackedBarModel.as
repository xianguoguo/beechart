package bee.chart.elements.bar 
{
	import cn.alibaba.core.mvcapp.CModel;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class StackedBarModel extends CModel 
    {
        
        private var _stackName:String = "";
        private var _index:int;
        private var _x:int;
        private var _value:Number = 0;
        
        public function StackedBarModel() 
        {
			
        }
        
        public function get stackName():String { return _stackName; }
        public function set stackName(value:String):void 
        {
            if(_stackName != value){
                _stackName = value;
                notifyChange();
            }
        }
        
        public function get x():int { return _x; }
        public function set x(value:int):void 
        {
            _x = value;
        }
        
        public function get index():int { return _index; }
        public function set index(value:int):void 
        {
            _index = value;
        }
        
        public function get value():Number { return _value; }
        public function set value(value:Number):void 
        {
            if(_value != value){
                _value = value;
                notifyChange();
            }
        }
        
    }

}