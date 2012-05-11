package bee.chart.demo.line
{
	import flash.display.Sprite;
	import org.casalib.util.DateUtil;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class TimeTest extends Sprite
	{
		private var mil:Number = 1120176000000; //2005/7/1
		private var dateStr:String = "2005/7/1"; //2005/7/1
		
		public function TimeTest()
		{
			trace(showFormatDate(mil));
			trace(dateLabel2miliseconds(dateStr));
			trace(DateUtil.getWeekOfTheYear(new Date()));
		}
		
		private function showFormatDate(mil:Number):String
		{
			var formatDate:String = "";
			var date:Date = new Date(mil);
			formatDate = date.getUTCFullYear() + " " + (date.getUTCMonth() + 1) + " " + date.getUTCDate();
			return formatDate;
		}
		
		private function dateLabel2miliseconds(dateLabel:String):Number
		{
			var dateReg:RegExp = /(\d+)\/(\d+)\/(\d+)/;
			var m:Array = dateLabel.match(dateReg);
			if (m)
			{
				return Date.UTC(string2Number(m[1]), string2Number(m[2]) -1, string2Number( m[3]));
			}
			return Number.NaN;
		}
		
		private function string2Number(str:String):Number
		{
			return Number(str);
		}
	}

}