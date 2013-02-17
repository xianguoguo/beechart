package bee.chart.elements.timeline.labelmaker 
{
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class DateUtils 
    {

        public static function addYear(date:Date, intervalIndex:Number) : void
        {
            var floorIntervalIndex:Number = Math.floor(intervalIndex);
            date.setUTCFullYear(date.getUTCFullYear() + floorIntervalIndex);
            if (intervalIndex != floorIntervalIndex)
            {
                addMonths(date, (intervalIndex - floorIntervalIndex) * 12);
            }
        }

		public static function addMonths(date:Date, intervalIndex:Number) : void
        {
            var floorIntervalIndex:Number = Math.floor(intervalIndex);
            date.setUTCMonth(date.getUTCMonth() + floorIntervalIndex);
            if (intervalIndex != floorIntervalIndex)
            {
                addDays(date, (intervalIndex - floorIntervalIndex) * 30);
            }
        }
		
		public static function addDays(date:Date, intervalIndex:Number) : void
        {
            var floorIntervalIndex:Number = Math.floor(intervalIndex);
            date.setUTCDate(date.getUTCDate() + floorIntervalIndex);
        }
		
		public static function formatDate(dateToFormat:Date, formatString:String):String 
		{
			var returnString:String = '';
			var char:String;
			var i:int = -1;
			var l:uint = formatString.length;
			var t:Number;
			
			while (++i < l) {
				char = formatString.substr(i, 1);
				
				if (char == '^')
					returnString += formatString.substr(++i, 1);
				else {
					switch (char) {
						// 24-hour format of an hour with leading zeros
						case 'H' :
							returnString += addLeadingZero(dateToFormat.getHours());
							break;
						// Minutes with leading zeros
						case 'i' :
							returnString += addLeadingZero(dateToFormat.getMinutes());
							break;
						// Seconds, with leading zeros
						case 's' :
							returnString += addLeadingZero(dateToFormat.getSeconds());
							break;
						default :
							returnString += formatString.substr(i, 1);
					}
				}
			}
			return returnString;
		}
		
		public static function addLeadingZero(value:Number):String 
		{
			return (value < 10) ? '0' + value : value.toString();
		}
    }

}