package bee.chart.data 
{
    
    /**
    * ...
    * @author hua.qiuh
    */
    public interface ILoadAndParser extends IParser
    {
        function load(url:String, charset:String=null):void;
        function loadCSS(url:String, charset:String=null, toAppend:Boolean = false):void;
    }
    
}