package bee.chart.external 
{
    import cn.alibaba.core.IDisposable;
    import bee.chart.abstract.Chart;
    
    /**
    * ...
    * @author hua.qiuh
    */
    public interface IChartInterface extends IDisposable
    {
        /**
        * 初始化图表的对外接口
        * @param	chart
        */
        function initChartExternal(chart:Chart):void;
    }
    
}