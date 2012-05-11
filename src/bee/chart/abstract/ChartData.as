package bee.chart.abstract
{
	import cn.alibaba.core.mvcapp.CModel;
	import cn.alibaba.core.mvcapp.IModel;
	import bee.chart.abstract.ChartDataSet;
	import bee.chart.elements.timeline.labelmaker.DateTimeUnit;
	import bee.chart.elements.timeline.labelmaker.TimeUnitDataMaker;
	import flash.events.Event;
	
	/**
	 * 负责处理图表核心数据的类。
	 *
	 * ChartData只存储图表的<b>数据</b>，
	 * 而不关心图表展示时候的配置。
	 * 例如一个LineChart，序列是
	 *
	 * @author hua.qiuh
	 */
	public class ChartData extends CModel implements IModel
	{
		protected var _labels:Vector.<String> = new Vector.<String>(); //所有label数据
		protected var _mainSets:Vector.<ChartDataSet> = new Vector.<ChartDataSet>(); //所有数据
		protected var _visibleSets:Vector.<ChartDataSet> = new Vector.<ChartDataSet>();
		protected var _maxSetLength:uint = 0;
		protected var _minValue:Number = 0;
		protected var _maxValue:Number = 0;
		protected var _labelDesc:String = "";
		protected var _labelUnit:String = "";
		protected var _valueDesc:String = "";
		protected var _valueUnit:String = "";
		protected var _valueType:String = "";
		protected var _visibleSetCount:uint = 0;
		protected var _total:Number = 0;
		
		protected var _dataIndexRange:DataIndexRange = null; //数据显示范围
		protected var _labelsInCurrentRange:Vector.<String>; //显示的label数据
		protected var _setsInCurrentRange:Vector.<ChartDataSet>; //显示的数据
		
		protected var _timeUnitLabels:Vector.<String>; //时间范围的label数据
		protected var _timeUnitMainSets:Vector.<ChartDataSet>; //时间范围的数据
		protected var _timeUnit:String = DateTimeUnit.DAY;
		private var _tempIndex:int = 0;
		
		
		public function ChartData()
		{
			init();
		}
		
		private function init():void
		{
			_setsInCurrentRange = new Vector.<ChartDataSet>();
			_labelsInCurrentRange = new Vector.<String>();			
			_timeUnitMainSets = _mainSets;
			_timeUnitLabels = _labels;
			_dataIndexRange = new DataIndexRange();
			_dataIndexRange.addEventListener(Event.CHANGE, onDataIndexRangeChangeHandler);
			updateDatasetRangeAndTimeData();
		}
		
		/**
		 * 设置数据数组
		 * @param	sets
		 */
		public function setDataSets(sets:Vector.<ChartDataSet>):void
		{
			_mainSets = sets.concat();
			_timeUnitMainSets = _mainSets;
			for each (var dataSet:ChartDataSet in sets)
			{
				dataSet.index = _tempIndex;
				_tempIndex++;
			}
            updateDatasetRangeAndTimeData();
		}
		
		/**
		 * 添加一条数据
		 * @param	st
		 */
		public function addSet(st:ChartDataSet):void
		{
			st.index = _tempIndex++;
			_mainSets.push(st);
			updateDatasetRangeAndTimeData();
		}
		
		/**
		 * 删除一个数据序列
		 * @param	st
		 */
		public function removeSet(st:ChartDataSet):void
		{
			var idx:int = _mainSets.indexOf(st);
			if (idx != -1)
			{
				_mainSets.splice(idx, 1);
				updateDatasetRangeAndTimeData();
			}
		}
		
		/**
		 * 删除一个
		 * @param	idx
		 */
		public function removeSetAt(idx:int):void
		{
			_mainSets.splice(idx, 1)[0];
			updateDatasetRangeAndTimeData();
		}
		
		/**
		 * 在指定位置插入一个数据序列
		 * @param	st
		 * @param	idx
		 * @return
		 */
		public function insertSetAt(st:ChartDataSet, idx:uint = 0):ChartDataSet
		{
			_mainSets.splice(idx, 0, st);
			updateStat();
			return st;
		}
		
		/**
		 * 删除所有元素.
		 */
		public function clear():void
		{
			var dataSet:ChartDataSet;
			for each (dataSet in _mainSets)
			{
				dataSet.dispose();
			}
			for each (dataSet in _visibleSets)
			{
				dataSet.dispose();
			}
			_labels.length = 0;
			_mainSets.length = 0;
			if (_setsInCurrentRange)
			{
				_setsInCurrentRange.length = 0;
			}
			if (_labelsInCurrentRange)
			{
				_labelsInCurrentRange.length = 0;
			}
			if (_timeUnitMainSets)
			{
				_timeUnitMainSets.length = 0;
			}
			if (_timeUnitLabels)
			{
				_timeUnitLabels.length = 0;
			}
			_visibleSets.length = 0;
			_maxSetLength = 0;
			_minValue = _maxValue;
			_maxValue = 0;
			_labelDesc = "";
			_labelUnit = "";
			_valueDesc = "";
			_valueUnit = "";
			_visibleSetCount = 0;
			_total = 0;
			_tempIndex = 0;
			
			updateStat();
			notifyChange();
		}
		
		/**
		 * 垃圾回收
		 */
		override public function dispose():void
		{
			clear();
			_labels = null;
			_mainSets = null;
			_visibleSets = null;
			_setsInCurrentRange = null;
			_labelsInCurrentRange = null;
			_timeUnitMainSets = null;
			_timeUnitLabels = null;
			if (_dataIndexRange)
			{
				_dataIndexRange.removeEventListener(Event.CHANGE, onDataIndexRangeChangeHandler);
				_dataIndexRange = null;
			}
			super.dispose();
		}
		
		public function clone():ChartData
		{
			var data:ChartData = new ChartData();
			//TODO: fill datas
			return data;
		}
		
		/**
		 * 获取某一列的最小值
		 * @param	idx
		 */
		public function getMinValueInCol(idx:uint):Number
		{
			return getMinMaxValueInCol(idx)[0];
		}
		
		/**
		 * 获取某一列数据的最大值
		 * @param	idx
		 * @return
		 */
		public function getMaxValueInCol(idx:uint):Number
		{
			return getMinMaxValueInCol(idx)[1];
		}
		
		public function getVisibleIndex(dataSet:ChartDataSet):int
		{
			return _visibleSets.indexOf(dataSet);
		}
		
		public function getIndex(dataSet:ChartDataSet):int
		{
			return _setsInCurrentRange.indexOf(dataSet);
		}
		
		/**
		 * 获取某一列数据的最大和最小值
		 * @param	idx
		 * @return
		 */
		public function getMinMaxValueInCol(idx:uint):Vector.<Number>
		{
			var vect:Vector.<Number> = new Vector.<Number>(2, true);
			
			if (idx < 0 || idx >= maxSetLength)
			{
				vect[0] = vect[1] = Number.NaN;
			}
			var max:Number = Number.MIN_VALUE, min:Number = Number.MAX_VALUE;
			var value:Number;
			for each (var dSet:ChartDataSet in _setsInCurrentRange)
			{
				if (dSet.visible)
				{
					value = dSet.getValueAt(idx);
					if (value > max)
					{
						max = value;
					}
					if (value < min)
					{
						min = value;
					}
				}
			}
			vect[0] = min;
			vect[1] = max;
			return vect;
		
		}
		
		/**
		 * 定义标签的含义
		 * @param	description
		 * @param	unit
		 */
		public function defineLabel(description:String, unit:String = ""):void
		{
			_labelDesc = description;
			_labelUnit = unit;
		}
		
		/**
		 * 定义数据值的含义
		 * @param	description
		 * @param	unit
		 */
		public function defineValue(description:String, unit:String = "",type:String = ""):void
		{
			_valueDesc = description;
			_valueUnit = unit;
			_valueType = type;
		}
		
		/**
		 * 设置某一条数据是否显示出来
		 * @param	index
		 * @param	visible
		 */
		public function setDatasetVisibility(index:uint, visible:Boolean):void
		{
			_mainSets[index].visible = visible;
			_setsInCurrentRange[index].visible = visible;
			_timeUnitMainSets[index].visible = visible;
			updateStat();
			notifyChange();
		}
		
		/**
		 * 获取某一条数据是否显示出来
		 * @param	index
		 * @return
		 */
		public function getDatasetVisibility(index:uint):Boolean
		{
			return _mainSets[index].visible;
		}
		
		public function setDatasetActivity(index:uint, active:Boolean):void
		{
			_mainSets[index].active = active;
			_setsInCurrentRange[index].active = active;
			_timeUnitMainSets[index].active = active;
		}
		
		/**
		 * 获取某一条数据是否正在显示中
		 * @param	index
		 * @return
		 */
		public function getDatasetActivity(index:uint):Boolean
		{
			return _mainSets[index].active;
		}
		
		/**
		 * 更变数据显示范围
		 * @param	value
		 */
		public function dataIndexRangeOffset(value:int):void 
		{
			if (_dataIndexRange)
			{
				dataIndexRange.offset(value);
			}
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Getters & Setters
		
		public function get allSets():Vector.<ChartDataSet>
		{
			return _timeUnitMainSets.concat();
		}
		
		public function get sets():Vector.<ChartDataSet>
		{
			return _setsInCurrentRange.concat();
		}
		
		public function get allLabels():Vector.<String>
		{
			return _timeUnitLabels ? _timeUnitLabels.concat() : null;
		}
		
		public function get visibleSets():Vector.<ChartDataSet>
		{
			return _visibleSets.concat();
		}
		
		/**
		 * 数据序列中最大的长度
		 */
		public function get maxSetLength():uint
		{
			return _maxSetLength;
		}
		
		/**
		 * 数据序列中的最小数据值
		 */
		public function get minValue():Number
		{
			return _minValue;
		}
		
		/**
		 * 数据序列中的最大值
		 */
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		/**
		 * 数据的标签
		 */
		public function get labels():Vector.<String>
		{
			return _labelsInCurrentRange ? _labelsInCurrentRange.concat() : null;
		}
		
		public function set labels(value:Vector.<String>):void
		{
			_labels = value.concat();
			_timeUnitLabels = _labels;
			updateDatasetRangeAndTimeData();
			updateStat();
		}
		
		/**
		 * 标签的含义
		 */
		public function get labelDesc():String
		{
			return _labelDesc;
		}
		
		/**
		 * 标签的单位
		 */
		public function get labelUnit():String
		{
			return _labelUnit;
		}
		
		/**
		 * 数值的含义
		 */
		public function get valueDesc():String
		{
			return _valueDesc;
		}
		
		/**
		 * 数值的单位
		 */
		public function get valueUnit():String
		{
			return _valueUnit;
		}
		
		/**
		 * 数据条数
		 */
		public function get dataSetCount():uint
		{
			return _mainSets.length;
		}
		
		/**
		 * 当前可见的的数据条数
		 */
		public function get visibleSetCount():uint
		{
			return _visibleSetCount;
		}
		
		/**
		 * 所有数据的总和
		 */
		public function get total():Number
		{
			return _total;
		}
		
		public function get dataIndexRange():DataIndexRange
		{
			return _dataIndexRange;
		}
		
		public function get timeUnit():String 
		{
			return _timeUnit;
		}
		
		public function set timeUnit(value:String):void 
		{
			if (value != _timeUnit)
			{
				_timeUnit = value;
				updateDatasetRangeAndTimeData();
			}
		}
		
		public function get valueType():String 
		{
			return _valueType;
		}
		
		public function set valueType(value:String):void 
		{
			_valueType = value;
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Private Functions
		
        private function updateDatasetRangeAndTimeData():void 
        {
            updateDatasetRange();
            updateTimeData();
        }
        
		private function updateTimeData():void 
		{
			if (_labels.length > 0 || _mainSets.length > 0)
			{
				_timeUnitMainSets = new Vector.<ChartDataSet>();
				_timeUnitLabels = new Vector.<String>();
				var timeMaker:TimeUnitDataMaker = new TimeUnitDataMaker();
				timeMaker.initParamter(_mainSets.concat(), _labels.concat(), _timeUnit, _dataIndexRange.clone());
				_timeUnitLabels = timeMaker.generateLabel();
				_timeUnitMainSets = timeMaker.generateSets();
				timeMaker.dispose();
				timeMaker = null;
				onDataIndexRangeChangeHandler();
			}
		}
		
		public function updateDatasetRange():void
		{
			if (_dataIndexRange)
			{
                if (_timeUnitLabels && _timeUnitLabels.length)
                {
                    _dataIndexRange.initParameter(0, _timeUnitLabels.length, _timeUnitLabels.length);
                }
				//没有设置label的情况
				else if(_mainSets && _mainSets.length)
                {
                    _dataIndexRange.initParameter(0, _mainSets[0].values.length, _mainSets[0].values.length);
                }
			}
		}
		
		private function onDataIndexRangeChangeHandler(e:Event = null):void
		{
			
			if (dataIndexRange.isAvailable())
			{
				_setsInCurrentRange = new Vector.<ChartDataSet>();
				
				_labelsInCurrentRange = new Vector.<String>();
				
				var cloneDataSet:ChartDataSet;
				for each (var dataSet:ChartDataSet in _timeUnitMainSets)
				{
					cloneDataSet = dataSet.clone();
					cloneDataSet.values = dataSet.values.slice(dataIndexRange.rangeStart, dataIndexRange.rangeEnd);
					_setsInCurrentRange.push(cloneDataSet);
				}
				_labelsInCurrentRange = _timeUnitLabels.slice(dataIndexRange.rangeStart, dataIndexRange.rangeEnd);
				updateStat();
				notifyChange();
				//trace("onDataIndexRangeChangeHandler~~~~~~~~~~~", dataIndexRange,_labelsInCurrentRange.length,_setsInCurrentRange.length);
			}
		}
		
		protected function updateStat():void
		{
			_minValue = Number.MAX_VALUE;
			_maxValue = Number.MIN_VALUE;
			_maxSetLength = labels.length;
			_visibleSetCount = 0;
			_total = 0;
			for each (var dSet:ChartDataSet in _setsInCurrentRange) 
			{
				if (!dSet.visible)
				{
					continue;
				}
				_visibleSetCount++;
				var len:uint = dSet.length;
				var min:Number = dSet.min;
				var max:Number = dSet.max;
				if (len > _maxSetLength)
					_maxSetLength = len;
				if (min < _minValue)
					_minValue = min;
				if (max > _maxValue)
					_maxValue = max;
				
				_total += dSet.total;
			}
			if (_minValue == Number.MAX_VALUE)
			{
				_minValue = 0;
			}
			if (_maxValue == Number.MIN_VALUE)
			{
				_maxValue = 10;
			}
			
			_visibleSets = _setsInCurrentRange.filter(function(dSet:ChartDataSet, ... args):Boolean
				{
					return dSet.visible;
				});
		
		}
		
		/**
		 * 获取某个位置上的label
		 * @param	index
		 * @return
		 */
		public function getLabelAt(index:uint):String
		{
			if (index < _labelsInCurrentRange.length)
			{
				return _labelsInCurrentRange[index];
			}
			return '';
		}
		
		/**
		 * 获取某一列上的所有数据值
		 * @param	idx
		 * @return
		 */
		public function getAllValuesInCol(idx:uint):Vector.<Number>
		{
			var values:Vector.<Number> = new Vector.<Number>;
			var value:Number;
			for each (var dSet:ChartDataSet in _setsInCurrentRange)
			{
				if (idx < dSet.length && !isNaN(value = dSet.getValueAt(idx)))
				{
					values.push(value);
				}
			}
			return values;
		}
		
		public function getAllPointsInCol(idx:uint):Vector.<I2VPoint>
		{
			var pts:Vector.<I2VPoint> = new Vector.<I2VPoint>;
			var value:Number;
			for each (var dSet:ChartDataSet in _setsInCurrentRange)
			{
				if (idx < dSet.length && !isNaN(value = dSet.getValueAt(idx)))
				{
					pts.push(new I2VPoint(idx, value));
				}
			}
			return pts;
		}
		
		/**
		 * 获取某一列上所有可见的点
		 * @param	idx
		 * @return
		 */
		public function getVisibleValuesInCol(idx:uint):Vector.<Number>
		{
			var values:Vector.<Number> = new Vector.<Number>;
			var value:Number;
			for each (var dSet:ChartDataSet in _visibleSets)
			{
				if (idx < dSet.length && !isNaN(value = dSet.getValueAt(idx)))
				{
					values.push(value);
				}
			}
			return values;
		}
		
		public function getVisiblePointsInCol(idx:uint):Vector.<I2VPoint>
		{
			var pts:Vector.<I2VPoint> = new Vector.<I2VPoint>;
			var value:Number;
			for each (var dSet:ChartDataSet in _visibleSets)
			{
				if (idx < dSet.length && !isNaN(value = dSet.getValueAt(idx)))
				{
					pts.push(new I2VPoint(idx, value));
				}
			}
			return pts;
		}
	}

}
