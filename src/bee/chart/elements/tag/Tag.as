package bee.chart.elements.tag 
{
	import bee.chart.abstract.ChartElement;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class Tag extends ChartElement 
    {
        
        public function Tag(tagModel:TagModel=null) 
        {
			setModel( tagModel ? tagModel : new TagModel() );
            setView( new TagView(this) );
        }
        
        override public function clone():ChartElement 
        {
            var tg:Tag = new Tag(__model);
            tg.skin.statePrinter = skin.statePrinter;
            tg.skin.performer = skin.performer;
            return tg;
        }
        
        
        
        public function get text():String { return __model.text; }
        public function set text(value:String):void 
        {
            __model.text = value;
        }
        
        public function get locationX():Number { return __model.locationX; }
        public function set locationX(value:Number):void 
        {
            __model.locationX = value;
        }
        
        public function get locationY():Number { return __model.locationY; }
        public function set locationY(value:Number):void 
        {
            __model.locationY = value;
        }
        
        public function get locationXReg():String { return __model.locationXReg; }
        public function set locationXReg(value:String):void 
        {
            __model.locationXReg = value;
        }
        
        public function get locationYReg():String { return __model.locationYReg; }
        public function set locationYReg(value:String):void 
        {
            __model.locationYReg = value;
        }
        
        private function get __model():TagModel
        {
            return _model as TagModel;
        }
        
    }

}