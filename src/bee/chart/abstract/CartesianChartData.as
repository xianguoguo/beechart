package bee.chart.abstract 
{
	import bee.chart.abstract.ChartData;
    import bee.chart.util.TicksGenerater;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class CartesianChartData extends ChartData 
    {
        protected var _keyValues:Vector.<Number> = new Vector.<Number>();
        protected var _yTicks:Vector.<Number>;
        protected var _minTickValue:Number = 0;
        protected var _maxTickValue:Number = 0;
        protected var _yTickCount:Number = 6;
        
        public function CartesianChartData() 
        {
            super();
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Public Functions
        
        public function addKeyValue(value:Number):void
        {
            if(_keyValues.indexOf(value) === -1){
                _keyValues.push(value);
                if (value > _maxTickValue || value < _minTickValue) {
                    updateStat();
                    notifyChange();
                }
            }
        }
        
        public function removeKeyValue(value:Number):void
        {
            var idx:int = _keyValues.indexOf(value);
            if ( idx != -1) {
                _keyValues.splice( idx, 1 );
                if (value == _maxTickValue || value == _minTickValue) {
                    updateStat();
                    notifyChange();
                }
            }
        }
        
        override public function dispose():void 
        {
            _keyValues = null;
            _yTicks = null;
            super.dispose();
        }
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        /**
        * 最小刻度值
        */
        public function get minTickValue():Number { return _minTickValue; }
        
        /**
        * 最大刻度值
        */
        public function get maxTickValue():Number { return _maxTickValue; }
        
        /**
        * y轴的刻度
        */
        public function get yTicks():Vector.<Number> { return _yTicks ? _yTicks.concat() : new Vector.<Number>(); }
        
        override protected function updateStat():void 
        {
            _minValue = Number.MAX_VALUE;
            _maxValue = Number.MIN_VALUE;
            _maxSetLength = labels.length;
            _visibleSetCount = 0;
            _total = 0;
			
			for each (var dSet:ChartDataSet in _setsInCurrentRange) 
			{
				if (!dSet.visible) {
                    continue;
                }
                _visibleSetCount ++;
                var len:uint = dSet.length;
                var min:Number = dSet.min;
                var max:Number = dSet.max;
                if (len > _maxSetLength) _maxSetLength = len;
                if (min < _minValue) _minValue = min;
                if (max > _maxValue) _maxValue = max;
                
                _total += dSet.total;
			}
            
            for each(var value:Number in _keyValues) {
                if (value > _maxValue) _maxValue = value;
                if (value < _minValue) _minValue = value;
            }
            if (_minValue == Number.MAX_VALUE) {
                _minValue = 0;
            }
            if (_maxValue == Number.MIN_VALUE) {
                _maxValue = 10;
            }
            
            _yTicks = TicksGenerater.make(_maxValue, _minValue, _yTickCount, _valueType);
            _maxTickValue = _yTicks[_yTicks.length - 1];
            _minTickValue = _yTicks[0];
            
            _visibleSets = _setsInCurrentRange.filter(function(dSet:ChartDataSet, ...args):Boolean {
                return dSet.visible;
            });
        }
        
    }

}