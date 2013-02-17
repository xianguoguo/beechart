package bee.chart.elements.legend.item 
{
    import cn.alibaba.core.mvcapp.CModel;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LegendItemData extends CModel
    {
        
        private var _label:String = "";
        private var _iconType:uint = 0;
        private var _color:uint = 0;
        private var _active:Boolean = true;
        private var _blur:Boolean = false;
        
        public var index:int;
        
        /**
        * 
        * @param	label   标签
        * @param	iconType    图标类型
        */
        public function LegendItemData(label:String="", iconType:uint=0, color:uint=0) 
        {
            this.label      = label;
            this.iconType   = iconType;
            this.color      = color;
        }
        
        /**
        * 标签
        */
        public function get label():String { return _label; }
        public function set label(value:String):void 
        {
            if(_label != value){
                _label = value;
                notifyChange();
            }
        }
        
        /**
        * 图标类型
        */
        public function get iconType():uint { return _iconType; }
        public function set iconType(value:uint):void 
        {
            if (_iconType != value) {
                _iconType = value;
                notifyChange();
            }
        }
        
        /**
        * 颜色
        */
        public function get color():uint { return _color; }
        public function set color(value:uint):void 
        {
            if(_color != value){
                _color = value;
                notifyChange();
            }
        }
        
        public function get active():Boolean { return _active; }
        public function set active(value:Boolean):void 
        {
            if(_active != value){
                _active = value;
                notifyChange();
            }
        }
        
        public function get blur():Boolean { return _blur; }
        
        public function set blur(value:Boolean):void 
        {
            if(_blur != value){
                _blur = value;
                notifyChange();
            }
        }
        
    }

}