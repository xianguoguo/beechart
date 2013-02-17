package bee.chart.elements.tooltip 
{
    import bee.chart.abstract.ChartElement;
	import bee.chart.abstract.I2VPoint;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	/**
    * ...
    * @author hua.qiuh
    */
    public class Tooltip extends ChartElement
    {
        
        static private var _instance:Tooltip;
        static public function get instance():Tooltip
        {
            if (!_instance) {
                _instance = new Tooltip( new SingletoneEnforcer() );
            }
            return _instance;
        }
        
        public function Tooltip(enforcer:SingletoneEnforcer) 
        {
            mouseEnabled = false;
            mouseChildren = false;
            reusable = true;
            
            setModel( new TooltipData() );
            setView( new TooltipView(this) );
        }
        
        override public function dispose():void 
        {
            super.dispose();
            _instance = null;
        }
        
        /**
        * 显示某个点的提示
        * @param	xIndex  x轴坐标
        * @param	value   y轴值
        */
        public function printTipAt( xIndex:Number, value:Number=0 ):void
        {
            __model.location = new I2VPoint(xIndex, value);
        }
        
        public function goto(x:Number, y:Number):void
        {
            __view.goto(x, y);
        }
        
        public function get bounds():Rectangle { return __model.bounds; }
        public function set bounds(value:Rectangle):void 
        {
            __model.bounds = value;
        }
        
        private function get __model():TooltipData
        {
            return _model as TooltipData;
        }
        
        private function get __view():TooltipView
        {
            return _view as TooltipView;
        }
        
        public function get text():String { return __model.text; }
        public function set text(value:String):void 
        {
            __model.text = value;
        }
        
        public function get textGen():Function { return __model.textGen; }
        public function set textGen(value:Function):void 
        {
            __model.textGen = value;
        }
    }
}

class SingletoneEnforcer { }