package bee.chart.events 
{
    import flash.events.Event;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartUIEvent extends ChartEvent 
    {
        /** 点击一个图表上的元素 **/
        static public const CLICK_ITEM:String = 'click_item';
        /** 鼠标经过一个图表上的元素 **/
        static public const FOCUS_ITEM:String = 'focus_item';
        /** 鼠标离开一个图表上的元素 **/
        static public const BLUR_ITEM:String = 'blur_item';
        /** 鼠标弹起一个图表上的元素 **/
        static public const MOUSE_UP_ITEM:String = 'mouse_up_item';
        /** 鼠标按下一个图表上的元素 **/
        static public const MOUSE_DOWN_ITEM:String = 'mouse_down_item';
		/** 图表元素开始动画过程 **/
        static public const SMOOTHING_START:String = 'smoothing_start';
		/** 图表元素结束动画过程 **/
        static public const SMOOTHING_END:String = 'smoothing_end';
		/** 数据隐藏\显示切换事件
		 * var data:Object = 
			{ 
				"name"		: chartdata.name,
				"index"		: chartdata.index,
				"visible"   : isVisible
			};
		 * **/
        static public const DATA_VISIBLE_CHANGE:String = 'data_visible_change';
        
        public function ChartUIEvent(type:String, data:*=null, bubbles:Boolean = true, cancelable:Boolean = true) 
        {
            super(type, data, bubbles, cancelable);
        }
        
        override public function clone():Event 
        {
            return new ChartUIEvent(type, data, bubbles, cancelable);
        }
    }

}