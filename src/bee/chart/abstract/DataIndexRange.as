package bee.chart.abstract
{
	import cn.alibaba.core.mvcapp.CModel;
	
	/**
	 * 数据表示显示范围的类
	 * _rangeStart &lt; _numData,_rangeEnd &lt;= _numData
	 * @author jianping.shenjp
	 */
	public class DataIndexRange extends CModel
	{
		private var _rangeStart:int = -1;
		private var _rangeEnd:int = -1;
		private var _numData:int = 0;
		
		/**
		 * 设置条件：rangeStart &gt;= 0,rangeEnd &gt; 0,numData &gt; 0;rangeEnd &gt; rangeStart,rangeEnd &lt;= numData,
		 * @param	rangeStart
		 * @param	rangeEnd
		 * @param	numData
		 */
		public function initParameter(rangeStart:int, rangeEnd:int, numData:int):void
		{
			if (rangeStart < 0 || rangeEnd <= 0 || numData < 0 || rangeStart >= rangeEnd || rangeEnd > numData)
			{
				throw new ArgumentError("argumets error!");
			}
			this.numData = numData;
			if (isNewRangeEndAvailable(rangeEnd))
			{
				_rangeEnd = rangeEnd;
			}
			if (isNewRangeStartAvailable(rangeStart))
			{
				_rangeStart = rangeStart;
			}
			notifyChange();
		}
		
		public function get rangeStart():int
		{
			return _rangeStart;
		}
		
		public function set rangeStart(value:int):void
		{
			if (isNewRangeStartAvailable(value))
			{
				_rangeStart = value;
				notifyChange();
			}
		}
		
		public function get rangeEnd():int
		{
			return _rangeEnd;
		}
		
		public function set rangeEnd(value:int):void
		{
			if (isNewRangeEndAvailable(value))
			{
				_rangeEnd = value;
				notifyChange();
			}
		}
		
		public function get numData():int
		{
			return _numData;
		}
		
		public function set numData(value:int):void
		{
			if (_numData != value && value > 0)
			{
				_numData = value;
				if (_rangeStart >= _numData)
				{
					_rangeStart = value - 1;
				}
				if (_rangeEnd >= _numData)
				{
					_rangeEnd = value;
				}
				notifyChange();
			}
		}
		
		/**
		 * 由RangeSelector改变range范围
		 * @param	rangeStart
		 * @param	rangeEnd
		 */
		public function changeRangeBySelector(rangeStart:int, rangeEnd:int):void
		{
			if ((rangeStart != _rangeStart) || (rangeEnd != _rangeEnd))
			{
				if (rangeStart < rangeEnd && rangeStart < numData && rangeEnd <= numData)
				{
					_rangeStart = rangeStart;
					_rangeEnd = rangeEnd;
					notifyChange();
				}
			}
		}
		
		public function offset(value:int):void
		{
			if (value == 0 || (_rangeEnd + value > numData) || (_rangeStart + value < 0))
			{
				return;
			}
			_rangeEnd += value;
			_rangeStart += value;
			notifyChange();
		}
		
		public function isAvailable():Boolean
		{
			if (_rangeStart >= 0 && _rangeEnd >= 0 && _numData > 0)
			{
				return true;
			}
			return false;
		}
		
		public function equel(range:DataIndexRange):Boolean
		{
			if (range)
			{
				if (range.rangeStart == _rangeStart && range.rangeEnd == _rangeEnd)
				{
					return true;
				}
			}
			return false;
		}
		
		public function clone():DataIndexRange
		{
			var result:DataIndexRange = new DataIndexRange();
			result._rangeStart = _rangeStart;
			result._rangeEnd = _rangeEnd;
			result._numData = _numData;
			return result;
		}
		
		private function isNewRangeStartAvailable(value:Number):Boolean
		{
			if (_rangeStart != value && value < _rangeEnd && value < _numData)
			{
				return true;
			}
			return false;
		}
		
		private function isNewRangeEndAvailable(value:Number):Boolean
		{
			if (_rangeEnd != value && value >= _rangeStart && value <= _numData)
			{
				return true;
			}
			return false;
		}
		
		override public function toString():String
		{
			return "[rangeStart:" + rangeStart + " rangeEnd:" + rangeEnd + " numData:" + numData + "]";
		}
	}

}