package bee.chart.test
{
	import bee.chart.elements.dot.Dot;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class DotPool
	{
		
		private static var MAX_VALUE:uint;
		private static var GROWTH_VALUE:uint;
		private static var counter:uint;
		private static var pool:Vector.<Dot>;
		
		//private static var currentSprite:Apple;
		
		public static function initialize(maxPoolSize:uint, growthValue:uint):void
		{
			MAX_VALUE = maxPoolSize;
			GROWTH_VALUE = growthValue;
			counter = maxPoolSize;
			var i:uint = maxPoolSize;
			pool = new Vector.<Dot>(MAX_VALUE);
			while (--i > -1)
			{
				pool[i] = new Dot();
			}
		}
		
		public static function getDot():Dot
		{
			if (counter > 0)
			{
				return pool[--counter];
			}
			if (GROWTH_VALUE == 0)
			{
				throw new Error("DotPool GROWTH_VALUE not be zero");
			}
			var i:uint = GROWTH_VALUE;
			while (--i > -1)
			{
				pool.unshift(new Dot());
			}
			counter = GROWTH_VALUE;
			return getDot();
		}
		
		public static function disposedDot(disposedDot:Dot):void
		{
			pool[counter++] = disposedDot;
		}
	}

}