package bee.chart.elements.canvas 
{
	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartCanvasData 
    {
        
        private var _width:Number   = 0;
        private var _height:Number  = 0;
        
        public function ChartCanvasData() 
        {
            
        }
        
        /**
        * 背景的宽度
        */
        public function get width():Number { return _width; }
        public function set width(value:Number):void 
        {
            _width = value;
        }
        
        /**
        * 背景的高度
        */
        public function get height():Number { return _height; }
        public function set height(value:Number):void 
        {
            _height = value;
        }
        
        
    }

}