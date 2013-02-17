package bee.chart.elements.timeline.labelmaker
{
	import cn.alibaba.core.IDisposable;
	import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.DataIndexRange;
    
    /**
     * 生成图表时间数据的辅助类，可以根据配置生成按天，周，月的数据；
	 * 目前只成按天的数据.
     * @author jianping.shenjp
     */
    public class TimeUnitDataMaker implements IDisposable
    {
        private var _newTimeUnitSets:Vector.<ChartDataSet>;
        private var _newTimeUnitLabels:Vector.<String>;
        private var _mainSets:Vector.<ChartDataSet>;
        private var _labels:Vector.<String>;
        private var _timeUnit:String;
        private var _isGenerated:Boolean = false;
        private var _dataIndexRange:DataIndexRange;
        
        public function initParamter(mainSets:Vector.<ChartDataSet>, labels:Vector.<String>, timeUnit:String,dataIndexRange:DataIndexRange):void
        {
            if (labels.length || mainSets.length)
            {
                _newTimeUnitSets = new Vector.<ChartDataSet>();
                _newTimeUnitLabels = new Vector.<String>();
                this._mainSets = mainSets;
                this._labels = labels;
                this._timeUnit = timeUnit;
				this._dataIndexRange = dataIndexRange;
            }
        }
        
        public function generateLabel():Vector.<String>
        {
            if (!_isGenerated)
            {
                generate();
            }
            return _newTimeUnitLabels;
        }
        
        public function generateSets():Vector.<ChartDataSet>
        {
            if (!_isGenerated)
            {
                generate();
            }
            return _newTimeUnitSets;
        }
        
        public function dispose():void 
        {
            _newTimeUnitSets = null;
            _newTimeUnitLabels = null;
            this._mainSets = null;
            this._labels = null;
            _dataIndexRange = null;
        }
        
        private function generate():void
        {
            switch (_timeUnit)
            {
                case DateTimeUnit.DAY: 
                default: 
                    dayUnit();
                    break;
                case DateTimeUnit.WEEK: 
                    weekUnit();
                    break;
                case DateTimeUnit.MONTH: 
                    monthUnit();
                    break;
            }
            _isGenerated = true;
        }
        
        private function dayUnit():void
        {
            var cloneDataSet:ChartDataSet;
            for each (var dataSet:ChartDataSet in _mainSets)
            {
                cloneDataSet = dataSet.clone();
                cloneDataSet.values = dataSet.values.slice(_dataIndexRange.rangeStart, _dataIndexRange.rangeEnd);
                _newTimeUnitSets.push(cloneDataSet);
            }
            _newTimeUnitLabels = _labels.slice(_dataIndexRange.rangeStart, _dataIndexRange.rangeEnd);
        }
        
        private function weekUnit():void
        {
        
        }
        
        private function monthUnit():void
        {
        
        }
    
    }

}