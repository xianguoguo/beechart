package bee.chart.test 
{
	import asunit.errors.UnimplementedFeatureError;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * for each 与Array.forEach 的运行效率比较
	 * @author jianping.shenjp
	 */
	public class ForEachTest extends Sprite 
	{
		private var numbers:Vector.<Number>;
		private var points:Vector.<Point>;
		
		public function ForEachTest() 
		{
			setup();
			testNumber();
			testPoint();
		}
		
		private function setup():void 
		{
			numbers = new Vector.<Number>();
			points = new Vector.<Point>();
			for (var i:int = 0; i < 100000; i++) 
			{
				numbers.push(Math.random());
				points.push(new Point(Math.random(),Math.random()));
			}
		}
		
		private function testNumber():void 
		{
			var time:int = getTimer();
			for each (var value:Number in numbers) 
			{
				
			}
			trace("number for each:", getTimer() - time);
			time = getTimer();
			numbers.forEach(function(value:Number,idx:int,vec:Vector.<Number>):void {
				
			},null);
			trace("number Array.forEach:", getTimer() - time);
		}
		
		private function testPoint():void 
		{
			var time:int = getTimer();
			for each (var point:Point in points) 
			{
				
			}
			trace("point for each:", getTimer() - time);
			time = getTimer();
			points.forEach(function(point:Point,idx:int,vec:Vector.<Point>):void {
				
			},null);
			trace("point Array.forEach:", getTimer() - time);
		}
		
	}

}