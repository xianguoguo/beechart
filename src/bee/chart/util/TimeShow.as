package bee.chart.util
{
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class TimeShow
	{
		private static var time:uint;
		private static var firstTime:uint;
		
		static public function init():void
		{
			time = firstTime = getTimer();
		}
		
		static public function showTime(name:String):void
		{
			var currentTime:uint = getTimer();
			trace(name, " _useTime: ", currentTime - time, " _totalTime: ", currentTime - firstTime);
			time = currentTime;
		}
	
	}

}