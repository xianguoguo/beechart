package bee.chart.elements.bar 
{
	import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartViewer;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class Bar extends ChartElement 
    {
		
		static public const DEFAULT_THICKNESS:uint = 20;
		  
        public function Bar() 
        {
            setModel(new BarModel());
            setView(new BarView(this));
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Public Functions
        
        override public function toString():String 
        {
            return 'Bar ' + barName + ' (' + value + ')';
        }
        
        public function toXML():XML
        {
            var xml:XML = <bar />;
            xml.name = barName;
            xml.index = index;
            xml.xIndex = xIndex;
            xml.value = value;
            return xml;
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        public function get horizontal():Boolean { return __model.horizontal; }
        public function set horizontal(value:Boolean):void 
        {
            __model.horizontal = value;
        }
        
        public function get value():Number { return __model.value; }
        public function set value(value:Number):void 
        {
            __model.value = value;
        }
        
        public function get index():uint { return __model.index; }
        public function set index(value:uint):void 
        {
            __model.index = value;
        }
        
        public function get xIndex():int { return __model.x; }
        public function set xIndex(value:int):void 
        {
            __model.x = value;
        }
        
        private function get __model():BarModel
        {
            return _model as BarModel;
        }
        
        private function get __view():BarView
        {
            return _view as BarView;
        }
        
        public function get barName():String { return __model.barName; }
        public function set barName(value:String):void 
        {
            __model.barName = value;
        }
        
        public function get group():String { return __model.group; }
        public function set group(value:String):void 
        {
            __model.group = value;
        }
        
        public function get groupKey():String { return __model.groupKey; }
        public function set groupKey(value:String):void 
        {
            __model.groupKey = value;
        }
        
        public function get barVisible():Boolean { return __model.visible; }
        public function set barVisible(value:Boolean):void 
        {
            if (barVisible != value)
            {
                __model.visible = value;
                mouseEnabled = value;
                if (value)
                {
                    state = "visible";
                }else
                {
                    state = "invisible";
                }
            }
        }
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Private Functions
        
        override protected function initController():void 
        {
            mouseChildren = false;
        }
        
    }

}