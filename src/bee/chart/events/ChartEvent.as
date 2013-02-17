package bee.chart.events 
{
	import flash.events.Event;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartEvent extends Event 
    {
        /** 接口准备完毕，可以被外部调用了 **/
        static public const SWF_READY:String = 'swfReady';
        
        static public const BEFORE_PRINT_STATE:String = 'beforePrintState';
        
        static public const AFTER_PRINT_STATE:String = 'afterPrintState';
        
        static public const BEFORE_ADD_VIEW_ELEMENT:String = 'beforeAddViewElement';
        
        static public const AFTER_ADD_VIEW_ELEMENT:String = 'afterAddViewElement';
        
        private var _data:*;
        
        public function ChartEvent(type:String, data:*=null, bubbles:Boolean = false, cancelable:Boolean = false) 
        {
            _data = data;
            super(type, bubbles, cancelable);
        }
        
        override public function clone():Event 
        {
            return new ChartEvent(type, data, bubbles, cancelable);
        }
        
        public function get data():* { return _data; }
        public function set data(value:*):void 
        {
            _data = value;
        }
        
        override public function toString():String 
        {
            return ['[ChartEvent:', type, data, ']'].join(' ');
        }
        
    }

}