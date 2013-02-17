package bee.chart.elements.timeline
{
    import flash.events.Event;
    
    /**
     * 分发移动时间选区的事件
     * @author jianping.shenjp
     */
    public class DragEvent extends Event
    {
        static public const DRAG:String = 'drag';
        public var isDragging:Boolean = false;
        
        /**
         *
         * @param	type
         * @param	btnXOne 按钮坐标1
         * @param	btnXTwo 按钮坐标2
         * @param	bubbles
         * @param	cancelable
         */
        public function DragEvent(type:String, isDragging:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.isDragging = isDragging;
        }
        
        override public function clone():Event
        {
            return new DragEvent(type, isDragging, bubbles, cancelable);
        }
    
    }

}