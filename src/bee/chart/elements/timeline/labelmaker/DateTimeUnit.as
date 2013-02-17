package bee.chart.elements.timeline.labelmaker
{
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class DateTimeUnit
	{
		static public const DAY:String = "day";
		static public const WEEK:String = "week";
		static public const MONTH:String = "month";
		static public const YEAR:String = "year";
		
		static public const MILISECONDS_PER_DAY:Number = 86400000;
		static public const MILISECONDS_PER_YEAR:Number = 31536000000;
		
		public static function increaseDate(majorIntervalValue:Number, intervalUnit:String, intervalIndex:Number):Number
		{
			var date:Date = new Date(majorIntervalValue);
			switch (intervalUnit)
			{
				case DateTimeUnit.YEAR: 
				{
					DateUtils.addYear(date, intervalIndex);
					break;
				}
				case DateTimeUnit.MONTH: 
				{
					DateUtils.addMonths(date, intervalIndex);
					break;
				}
				case DateTimeUnit.DAY: 
				{
					DateUtils.addDays(date, intervalIndex);
					break;
				}
				default: 
				{
					break;
				}
			}
			return date.getTime();
		} 
		
		public static function getEvenStepDate(majorIntervalUnit:String, majorInterval:int, minimum:Number, fullMinimum:Number, flat:Boolean):Number
		{
			var utcYear:int;
			var date:Date;
			var fullMinimum_year:int;
			var temp:int;
			var minimumDate:Date = new Date(minimum);
			var flatNum:int = (flat) ? 1 : 0;
			utcYear = minimumDate.getUTCFullYear();
			var utcMonth:int = minimumDate.getUTCMonth();
			var utcDate:int = minimumDate.getUTCDate();
			var isFirstMonth:Boolean = (utcMonth == 0);
			var isFirstDate:Boolean = (utcDate == 1);
			switch (majorIntervalUnit)
			{
				case DateTimeUnit.YEAR: 
				default: 
					date = new Date(fullMinimum);
					fullMinimum_year = date.getUTCFullYear();
					temp = (Math.floor(((utcYear - fullMinimum_year) / majorInterval)) * majorInterval);
					if (flat && isFirstMonth && isFirstDate && (utcYear == temp))
					{
						return (minimum);
					}
					return (Date.UTC((temp + flatNum), 0));
				case DateTimeUnit.MONTH: 
					if (flat && isFirstDate)
					{
						return (minimum);
					}
					utcMonth = (Math.floor(((utcMonth + flatNum) / majorInterval)) * majorInterval);
					return (Date.UTC(utcYear, utcMonth));
				case DateTimeUnit.DAY: 
					if (flat)
					{
						return (minimum);
					}
					utcDate = (Math.floor(((utcDate + flatNum) / majorInterval)) * majorInterval);
					return (Date.UTC(utcYear, utcMonth, utcDate));
			}
		}
		
		public static function getPassedIntervalsCount(majorIntervalStartDate:Number, minimum:Number, majorIntervalUnit:String, majorInterval:int):Number
		{
			var majorYear:Number = 0;
			var minimumYear:Number = 0;
			var passedYearsNum:int = 0;
			var majorDate:Date = new Date(majorIntervalStartDate);
			var minimumDate:Date = new Date(minimum);
			majorYear = majorDate.getUTCFullYear();
			var majorMonth:Number = majorDate.getUTCMonth();
			minimumYear = minimumDate.getUTCFullYear();
			var minimumMonth:Number = minimumDate.getUTCMonth();
			switch (majorIntervalUnit)
			{
				case DateTimeUnit.YEAR: 
				{
					return Math.floor(passedYears(majorYear, minimumYear) / majorInterval);
				}
				case DateTimeUnit.MONTH: 
				{
					passedYearsNum = passedYears((majorYear + 1), minimumYear);
					return Math.floor((passedYearsNum * 12 + passedMonth(majorMonth, minimumMonth, passedYearsNum > 0)) / majorInterval);
				}
				case DateTimeUnit.DAY: 
				{
					return Math.floor(Math.floor((minimum - majorIntervalStartDate) / MILISECONDS_PER_DAY) / majorInterval);
				}
				default: 
				{
					break;
				}
			}
			return 0.0;
		}
		
		private static function passedYears(year1:int, year2:int):int
		{
			return year1 <= year2 ? (year2 - year1) : (0);
		}
		
		private static function passedMonth(month1:int, month2:int, moreThanOneYear:Boolean):int
		{
			return moreThanOneYear ? (12 - month2 + month1) : (month2 - month1);
		}
	}

}