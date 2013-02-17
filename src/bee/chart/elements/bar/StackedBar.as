package bee.chart.elements.bar 
{
    import bee.chart.abstract.ChartElement;
    import bee.chart.elements.bar.Bar;
	/**
    * ...
    * @author hua.qiuh
    */
    public class StackedBar extends ChartElement
    {
        
        private const _BARS:Vector.<Bar> = new Vector.<Bar>();
        
        public function StackedBar() 
        {
            setModel( new StackedBarModel() );
            setView( new StackedBarView(this) );
        }
        
        override protected function initController():void 
        {
            mouseChildren = false;
        }
        
        public function addBar(bar:Bar):void 
        {
            if (_BARS.indexOf(bar) == -1) {
                _BARS.push(bar);
            }
            updateView();
        }
        
        public function removeBar(bar:Bar):void
        {
            var idx:int = _BARS.indexOf(bar);
            if (idx != -1) {
                _BARS.splice(idx, 1);
            }
            updateView();
        }
        
        override public function toString():String 
        {
            return 'StackedBar: ' + stackName + '#' + xIndex + '\n'
                    + 'total: ' + value + '\n'
                    + 'bars: ' + _BARS.toString();
        }
        
        public function toXML():XML
        {
            var xml:XML = <stackedBar />;
            xml.name = stackName;
            xml.value = value;
            var bars:XML = <bars />
            for each(var bar:Bar in _BARS) {
                bars.appendChild(bar.toXML());
            }
            xml.appendChild(bars);
            return xml;
        }
        
        /**
        * 返回某个坐标点上的Bar的信息
        * @param	x
        * @param	y
        * @return
        */
        public function getBarAt(x:Number, y:Number):Bar
        {
            var pritner:IStackedBarPrinter = skin.statePrinter as IStackedBarPrinter;
            var idx:int = pritner.getBarIndexAt(x, y, __view.content);
            if (idx != -1) {
                return _BARS[idx];
            }
            return null;
        }
        
        public function get bars():Vector.<Bar> { return _BARS; }
        
        public function get stackName():String { return __model.stackName; }
        public function set stackName(value:String):void 
        {
            __model.stackName = value;
        }
        
        public function get index():int { return __model.index; }
        public function set index(value:int):void 
        {
            __model.index = value;
        }
        
        public function get xIndex():int { return __model.x; }
        public function set xIndex(value:int):void 
        {
            __model.x = value;
        }
        
        public function get value():Number 
        { 
            var returnValue:Number = 0.0;
            for each (var bar:Bar in _BARS) 
            {
                if (!isNaN(bar.value))
                {
                    returnValue += bar.value;
                }
            }
            return returnValue; 
        }
        
        override public function get state():String { return super.state; }
        override public function set state(value:String):void 
        {
            for each(var bar:Bar in _BARS) {
                bar.state = value;
            }
            super.state = value;
        }
        
        private function get __model():StackedBarModel
        {
            return _model as StackedBarModel;
        }
        
        private function get __view():StackedBarView
        {
            return _view as StackedBarView;
        }
        
        
        
    }

}