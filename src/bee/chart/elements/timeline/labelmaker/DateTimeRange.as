package bee.chart.elements.timeline.labelmaker 
{

    public class DateTimeRange
    {
        private static const MULTIPLIER:Number = 8.64e+7;//1天的毫秒值
        private static const MONTH_DAY:Number = 8.64e+7;//相差1天
        private static const MONTH_7DAYS:Number = 6.048e+8;//相差7天
        private static const YEAR_2MONTH:Number = 5.184e+9;//相差4月
        private static const YEAR_QUARTER:Number = 7.776e+9;//相差三个季度
        private static const YEAR_MONTH:Number = 2.592e+9;//相差11月
        private static const YEAR_HALF:Number = 1.5552e+10;//相差半年
        private static const YEAR_YEAR:Number = 3.1536e+10;//相差一年

        public static function calculateIntervals(dateTimeInterval:DateTimeInterval, ticksCount:uint) : void
        {
            var tickTime:Number = (dateTimeInterval.maximum - dateTimeInterval.minimum) / ticksCount;
            if (tickTime < MONTH_DAY)
            {
                dateTimeInterval.minorIntervalUnit = DateTimeUnit.DAY;
                dateTimeInterval.minorInterval = 1;
                dateTimeInterval.majorIntervalUnit = DateTimeUnit.MONTH;
                dateTimeInterval.majorInterval = 1;
            }
            else if (tickTime < MONTH_7DAYS)
            {
                dateTimeInterval.minorIntervalUnit = DateTimeUnit.DAY;
                dateTimeInterval.minorInterval = 7;
                dateTimeInterval.majorIntervalUnit = DateTimeUnit.MONTH;
                dateTimeInterval.majorInterval = 1;
            }
            else if (tickTime < YEAR_MONTH)
            {
                dateTimeInterval.minorIntervalUnit = DateTimeUnit.MONTH;
                dateTimeInterval.minorInterval = 1;
                dateTimeInterval.majorIntervalUnit = DateTimeUnit.YEAR;
                dateTimeInterval.majorInterval = 1;
            }
            else if (tickTime < YEAR_2MONTH)
            {
                dateTimeInterval.minorIntervalUnit = DateTimeUnit.MONTH;
                dateTimeInterval.minorInterval = 2;
                dateTimeInterval.majorIntervalUnit = DateTimeUnit.YEAR;
                dateTimeInterval.majorInterval = 1;
            }
            else if (tickTime < YEAR_QUARTER)
            {
                dateTimeInterval.minorIntervalUnit = DateTimeUnit.MONTH;
                dateTimeInterval.minorInterval = 3;
                dateTimeInterval.majorIntervalUnit = DateTimeUnit.YEAR;
                dateTimeInterval.majorInterval = 1;
            }
            else if (tickTime < YEAR_HALF)
            {
                dateTimeInterval.minorIntervalUnit = DateTimeUnit.MONTH;
                dateTimeInterval.minorInterval = 6;
                dateTimeInterval.majorIntervalUnit = DateTimeUnit.YEAR;
                dateTimeInterval.majorInterval = 1;
            }
            else
            {
                dateTimeInterval.minorIntervalUnit = DateTimeUnit.YEAR;
                dateTimeInterval.minorInterval = Math.ceil(tickTime / (365 * MULTIPLIER));
                dateTimeInterval.majorIntervalUnit = DateTimeUnit.YEAR;
                dateTimeInterval.majorInterval = dateTimeInterval.minorInterval * 2;
            }
        }
    }
}
