package bee.chart.demo.demo1dot5 
{
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.CComponent;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.Group;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.AutoColorUtil;
	import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import com.greensock.TweenLite;
	
	/**
    * ...
    * @author jianping.shenjp
    */
    public class YIDDemoBase extends Sprite 
    {
        
        protected var chart:Chart;	
        
        public function YIDDemoBase() 
        {
            super();
            if (stage) {
                init();
            }
            else {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
			
        }
        
        protected function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            stage.scaleMode=StageScaleMode.NO_SCALE;
            stage.align=StageAlign.TOP_LEFT;
            
            initChart();
        }
        
        protected function initChart():void 
        {
            
        }
        
        /**
		 * 清除数据的接口
		 * */
		public function dispose():void
		{
            Group.disposeAll();
			AutoColorUtil.reset();
			Tooltip.instance.styleSheet.clear();
            DisplayUtil.clearSprite(this);
            chart = null;
            var masterList:Dictionary = TweenLite.masterList;
            for(var obj:Object in masterList)
            {
                TweenLite.killTweensOf(obj, true);
            }
		}
    }

}