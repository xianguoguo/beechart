package bee.controls.label 
{
    import cn.alibaba.core.mvcapp.CModel;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LabelModel extends CModel
    {
        public var value:Number = 0;
        private var _text:String = "";
        private var _rotation:Number = 0;
        
        public function LabelModel() 
        {
            
        }
        
        public function get text():String { return _text; }
        public function set text(value:String):void 
        {
            if(value != _text){
                _text = value;
                notifyChange();
            }
        }
        
        public function get rotation():Number { return _rotation; }
        public function set rotation(value:Number):void 
        {
            if(value != _rotation){
                _rotation = value;
                notifyChange();
            }
        }
		
        
    }

}