package bee.chart.elements.tag 
{
    import cn.alibaba.core.mvcapp.CModel;
	/**
    * ...
    * @author hua.qiuh
    */
    public class TagModel extends CModel
    {
        private var _text:String = "";
        private var _locationX:Number = 0;
        private var _locationY:Number = 0;
        private var _locationXReg:String;
        private var _locationYReg:String;
        
        public function TagModel(text:String="", x:Number=0, y:Number=0, xreg:String=null, yreg:String=null) 
        {
            this.text = text;
            this.locationX = x;
            this.locationY = y;
            this.locationXReg = xreg;
            this.locationYReg = yreg;
        }
        
        public function clone():TagModel {
            return new TagModel(_text, _locationX, _locationY, _locationXReg, _locationYReg);
        }
        
        public function get text():String { return _text; }
        public function set text(value:String):void 
        {
            if(_text != value){
                _text = value;
                notifyChange();
            }
        }
        
        public function get locationX():Number { return _locationX; }
        public function set locationX(value:Number):void 
        {
            _locationX = value;
        }
        
        public function get locationY():Number { return _locationY; }
        public function set locationY(value:Number):void 
        {
            _locationY = value;
        }
        
        public function get locationXReg():String { return _locationXReg; }
        public function set locationXReg(value:String):void 
        {
            _locationXReg = value;
        }
        
        public function get locationYReg():String { return _locationYReg; }
        public function set locationYReg(value:String):void 
        {
            _locationYReg = value;
        }
        
    }

}