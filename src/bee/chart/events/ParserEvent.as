package bee.chart.events 
{
    import flash.events.Event;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class ParserEvent extends ChartEvent 
    {
        
        static public const LOAD_START:String = 'load_start';
        static public const LOAD_FAIL:String = 'load_fail';
        static public const LOAD_FINISH:String = 'load_finish';
        static public const PARSE_FAIL:String = 'parse_fail';
        static public const DATA_PARSED:String = 'data_parsed';
        static public const CSS_PARSED:String = 'css_parsed';
        
        public function ParserEvent(type:String, data:* = '', bubble:Boolean = false, cancelable:Boolean = false) 
        {
            super(type, data, bubble, cancelable);
        }
        
        override public function clone():Event 
        {
            return new ParserEvent(type, data, bubbles, cancelable);
        }
        
    }

}