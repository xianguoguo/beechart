package bee.chart.assemble.bar 
{
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.Group;
    import bee.chart.util.TicksGenerater;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarChartData extends CartesianChartData 
    {
        static public const CONFIG_GROUP:String = 'stackGroup';
        static public const DATASET_GROUP_TYPE:String = "CDS";
        
        public function BarChartData() 
        {
			
        }
        
        public function get stackedColumnsCount():uint
        {
            var count:uint = 0;
            for each(var dSet:ChartDataSet in _mainSets){
                if (dSet.visible && !dSet.config[CONFIG_GROUP]) {
                   count ++;
                }
            };
            var groups:Vector.<Group> = Group.filter(DATASET_GROUP_TYPE);
            for each(var grp:Group in groups) {
                if (grp.items.some(function(dSet:ChartDataSet, ...args):Boolean {
                    return dSet.visible;
                })) {
                    count ++;
                }
            }
            return count;
        }
        
        override public function addSet(st:ChartDataSet):void 
        {
            var stackName:String = st.config[CONFIG_GROUP];
            if (stackName) {
                var stack:Group = Group.create(stackName, DATASET_GROUP_TYPE);
                stack.addItem(st);
            }
            
            super.addSet(st);
        }
        
        override public function removeSet(st:ChartDataSet):void 
        {
            Group.removeItemFromGroup(st, st.config[CONFIG_GROUP]);
            super.removeSet(st);
        }
        
        override public function removeSetAt(idx:int):void 
        {
            var st:ChartDataSet = _mainSets[idx];
            Group.removeItemFromGroup(st, st.config[CONFIG_GROUP]);
            super.removeSetAt(idx);
        }
        
        private  function stackValues():void
        {
            var total:Number;
            var groups:Vector.<Group> = Group.filter(DATASET_GROUP_TYPE);
            for (var i:uint = 0, len:uint = maxSetLength; i < len; i++) {
                total = 0;
                for each(var group:Group in groups) {
                    for each(var dSet:ChartDataSet in group.items) {
                        if(dSet.visible && i< dSet.values.length){
                            total += dSet.values[i];
                        }
                    };
                    
                }
                if (total > _maxValue) _maxValue = total;
                if (total < _minValue) _minValue = total;
            }
        }
        
        override public function clear():void 
        {
            Group.disposeAll();
            super.clear();
        }
        
        override protected function updateStat():void 
        {
            _minValue = Number.MAX_VALUE;
            _maxValue = Number.MIN_VALUE;
            _maxSetLength = _labels.length;
            _visibleSetCount = 0;
            _total = 0;
            for each (var dSet:ChartDataSet in _mainSets) 
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
            stackValues();
            
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
            
            _yTicks = TicksGenerater.make(_maxValue, _minValue, _yTickCount);
            _maxTickValue = _yTicks[_yTicks.length - 1];
            _minTickValue = _yTicks[0];
            
            _visibleSets = _mainSets.filter(function(dSet:ChartDataSet, ...args):Boolean {
                return dSet.visible;
            });
        }
        
    }
    

}

