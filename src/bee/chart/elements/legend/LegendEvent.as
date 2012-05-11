package bee.chart.elements.legend 
{
    import flash.events.Event;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LegendEvent extends Event
    {
        static public const TURN_ON:String      = 'turnon';
        static public const TURN_OFF:String     = 'turnoff';
        static public const MOUSE_OVER:String   = 'lgd_over';
        static public const MOUSE_OUT:String    = 'lgd_out';
        
        /**
        * 触发legend on/off事件的对象的索引
        */
        public var index:int;
        
        public function LegendEvent(type:String, index:int, bubbles:Boolean=false, cancelable:Boolean=false) 
        {
            this.index = index;
            super(type, bubbles, cancelable);
        }
        
    }

}