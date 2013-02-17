package bee.chart.elements.legend 
{
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartElement;
    import bee.chart.elements.legend.item.LegendItem;
	/**
    * 图表标题
    * @author hua.qiuh
    */
    public class Legend extends ChartElement
    {
        private var _behavior:ILegendBehavior = new LegendNullBehavior();
        
        public function Legend() 
        {
            setModel( new LegendData() );
            setView( new LegendView(this) );
        }
        
        public function setLegendItemBlur(index:int, isActive:Boolean):void
        {
            (view as LegendView).setLegendItemBlur(index, isActive);
        }
        
        override public function dispose():void 
        {
            removeEventListener(LegendEvent.TURN_OFF, onTurn);
            removeEventListener(LegendEvent.TURN_ON, onTurn);
            removeEventListener(LegendEvent.MOUSE_OVER, onTurn);
            removeEventListener(LegendEvent.MOUSE_OUT, onTurn);
            super.dispose();
        }
        
        override protected function initController():void 
        {
            addEventListener(LegendEvent.TURN_OFF, onTurn);
            addEventListener(LegendEvent.TURN_ON, onTurn);
            addEventListener(LegendEvent.MOUSE_OVER, onTurn);
            addEventListener(LegendEvent.MOUSE_OUT, onTurn);
        }
        
        public function get dataSets():Vector.<ChartDataSet> { return __model.dataSets; }
        public function set dataSets(value:Vector.<ChartDataSet>):void 
        {
            __model.dataSets = value;
        }
        
        private function get __model():LegendData
        {
            return _model as LegendData;
        }
        
        public function get behavior():ILegendBehavior { return _behavior; }
        public function set behavior(value:ILegendBehavior):void 
        {
            _behavior = value;
        }
        
        private function onTurn(e:LegendEvent):void 
        {
            if (chart) {
                _behavior.dealEvent(e.target as LegendItem, chart, e.type, e.index);
            }
        }
        
    }

}