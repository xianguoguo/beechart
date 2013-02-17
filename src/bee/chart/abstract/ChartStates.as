package bee.chart.abstract 
{
	/**
    * ...
    * @author hua.qiuh
    */
    public final class ChartStates 
    {
        /** 初始状态，等待数据 **/
        static public const READY:String = 'ready';
        
        /** 加载数据状态 **/
        static public const LOADING:String = 'loading';
        
        /** 数据加载完毕状态 **/
        static public const NORMAL:String = 'normal';
        
        /** 数据加载失败状态 **/
        static public const LOAD_FAIL:String = 'load_fail';
        
        /** 数据解析失败状态 **/
        static public const PARSE_FAIL:String = 'parse_fail';
        
        /** 由数据决定的自定义失败状态 **/
        static public const CUSTOM_FAIL:String = 'custom_fail';
        
    }

}