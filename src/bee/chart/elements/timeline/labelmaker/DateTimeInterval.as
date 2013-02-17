package bee.chart.elements.timeline.labelmaker
{
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class DateTimeInterval
	{
		public var minimum:Number; //当前显示时间的初始值
		public var maximum:Number; //当前显示时间的结束值
		
		public var majorInterval:int; //主时间单位间隔
		public var minorInterval:int; //副时间单位间隔
		public var majorIntervalUnit:String; //主时间单位
		public var minorIntervalUnit:String; //副时间单位
		protected var maxTicksCount:int = 20; //显示时间段的数量
		
		public var fullMaximum:Number; //时间初始值
		public var fullMinimum:Number; //时间结束值
		
		protected var majorIntervalStartDate:Number; //主时间单位的起始时间
		protected var startMajorIntervalIndex:Number; //主时间单位跨度
		
		public function initVisibleOnScale(min:Number, max:Number):void
		{
			minimum = min;
			maximum = max;
			DateTimeRange.calculateIntervals(this, maxTicksCount);
			majorIntervalStartDate = DateTimeUnit.getEvenStepDate(majorIntervalUnit, majorInterval, minimum, fullMinimum, false);
			startMajorIntervalIndex = DateTimeUnit.getPassedIntervalsCount(majorIntervalStartDate, minimum, majorIntervalUnit, majorInterval) + 1;
		}
		
		public function initializeMinMax(fullmin:Number, fullmax:Number):void
		{
			fullMinimum = fullmin;
			fullMaximum = fullmax;
		}
		
		public function getMajorIntervalValue(majorIntervalIndex:Number):Number
		{
			majorIntervalIndex = majorIntervalIndex + startMajorIntervalIndex;
			return DateTimeUnit.increaseDate(majorIntervalStartDate, majorIntervalUnit, majorIntervalIndex * majorInterval);
		}
		
		public function getMinorIntervalValue(majorIntervalValue:Number, minorIntervalIndex:int):Number
		{
			return DateTimeUnit.increaseDate(majorIntervalValue, minorIntervalUnit, minorIntervalIndex * minorInterval);
		}
		
		public function toString():String
		{
			return "majorIntervalUnit:" + majorIntervalUnit + " _majorInterval:" + majorInterval + " _minorIntervalUnit:" + minorIntervalUnit + " _minorInterval:" + minorInterval + " _majorIntervalStartDate:" + majorIntervalStartDate + (new Date(majorIntervalStartDate));
		}
	}

}