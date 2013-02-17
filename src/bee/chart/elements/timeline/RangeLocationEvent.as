package bee.chart.elements.timeline
{
    import flash.display.InterpolationMethod;
    import flash.events.Event;
    
    /**
     * 时间轴上滑块位置相关的事件
     * @author jianping.shenjp
     */
    public class RangeLocationEvent extends Event
    {
        static public const RANGE_LOCATION:String = 'range_location';//分发RangeSelector中Btn位置坐标的事件
        static public const SET_RANGE_LOCATION:String = 'set_range_location';//分发位置信息,以设置RangeSelector中Btn位置坐标的事件
        static public const SET_ONE_TIME_RANGE:String = 'set_one_time_range';//分发设置一个时间段的事件
        public var btnXOne:Number = 0.0;
        public var btnXTwo:Number = 0.0;
        
        /**
         *
         * @param	type
         * @param	btnXOne 按钮坐标1
         * @param	btnXTwo 按钮坐标2
         * @param	bubbles
         * @param	cancelable
         */
        public function RangeLocationEvent(type:String, btnXOne:Number, btnXTwo:Number, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.btnXOne = btnXOne;
            this.btnXTwo = btnXTwo;
        }
        
        override public function clone():Event
        {
            return new RangeLocationEvent(type, btnXOne, btnXTwo, bubbles, cancelable);
        }
    
    }

}