package bee.chart.elements.legend.item 
{
    import bee.abstract.CComponent;
    import bee.chart.elements.legend.LegendEvent;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.printers.IStatePrinter;
    import flash.events.Event;
    import flash.events.MouseEvent;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LegendItem extends CComponent
    {
        
        static public var defaultStatePrinter:IStatePrinter = new LegendItemSimplePrinter;
        static public var defaultPerformer:IPerformer = SimplePerformer.instance;
        
        public function LegendItem(data:LegendItemData=null) 
        {
            if (!data) {
                data = new LegendItemData();
            }
            super(data);
            
            skin.statePrinter = defaultStatePrinter;
            skin.performer = defaultPerformer;
            mouseChildren = false;
        }
        
        override protected function initView():void 
        {
            super.initView();
            addEventListeners();
        }
        
        override public function dispose():void 
        {
            removeEventListeners();
            super.dispose();
        }
        
        override public function toString():String
        {
            return 'LegendItem of ' + __model.label;
        }
        
        private function get __model():LegendItemData
        {
            return dataModel as LegendItemData;
        }
        
        public function get active():Boolean { return __model.active; }
        public function set active(value:Boolean):void 
        {
            __model.active = value;
        }
        
        public function get blur():Boolean { return __model.blur; }
        public function set blur(value:Boolean):void 
        {
            __model.blur = value;
        }
        
        public function get index():int { return __model.index; }
        public function set index(value:int):void 
        {
            __model.index = value;
        }
        
        private function addEventListeners():void {
           addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
           addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
           addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        }
        
        private function removeEventListeners():void {
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        }
        
        private function mouseOverHandler(e:MouseEvent):void 
        {
            dispatchLegendEvent(LegendEvent.MOUSE_OVER);
        }
        
        private function mouseOutHandler(e:MouseEvent):void 
        {
            dispatchLegendEvent(LegendEvent.MOUSE_OUT);
        }
        
        private function onMouseDown(e:MouseEvent):void 
        {
            var type:String = __model.active ? LegendEvent.TURN_OFF : LegendEvent.TURN_ON;
            dispatchLegendEvent(type);
        }
        
        private function dispatchLegendEvent(evtType:String):void {
            dispatchEvent(new LegendEvent(evtType, __model.index, true, true));
        }
    }

}