package bee.chart.demo.line
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class TimeTrace extends Sprite
	{
		
		private const eachYearMonths:int = 12;
		private const eachMonthDays:int = 31;
		private const YEAR:String = "2006";
		private var printStr:String = "";
		private var str:String ="";
		
		public function TimeTrace()
		{
			for (var i:int = 1; i <= eachYearMonths; i++)
			{
				
				for (var j:int = 1; j <= eachMonthDays; j++)
				{
					str = "\"" + YEAR + "/" + formatDayOrMonth(i) + "/" + formatDayOrMonth(j) + "\"";
					printStr += str + ", ";
				}
				printStr += "\n";
			}
			trace(printStr);
		}
	
		private function formatDayOrMonth(value:Number):String
		{
			return ((value + "").length == 1) ? "0"+value:value+"";
		}
	}

}