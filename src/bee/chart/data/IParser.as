package bee.chart.data 
{
    import cn.alibaba.core.IDisposable;
    import flash.events.IEventDispatcher;
    
    /**
    * ...
    * @author hua.qiuh
    */
    public interface IParser extends IDisposable, IEventDispatcher
    {
        function parse(src:String):void;
        function parseCSS(src:String, toAppend:Boolean=false):void;
    }
    
}