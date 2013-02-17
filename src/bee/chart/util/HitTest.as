package bee.chart.util 
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	/**
     * 高级碰撞测试类
     * @author jianping.shenjp
     */
    public class HitTest 
    {
        /**
        * 检测两个displayObject是否在界面上有重叠的部分
        * @param	displayObject
        * @param	testTarget
        * @param	stage
        * @return
        */
        static public function isHit(displayObject:DisplayObject, testTarget:DisplayObject, stage:Stage):Boolean {
            
            var rect:Rectangle = displayObject.getRect(stage);
            var target:Rectangle = testTarget.getRect(stage);
            return rect.intersects(target);
        }
    }

}