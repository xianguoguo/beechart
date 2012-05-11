package bee.chart.elements.ctxmenu 
{
    import cn.alibaba.core.IDisposable;
    import bee.chart.abstract.Chart;
    
    /**
    * ...
    * @author hua.qiuh
    */
    public interface IChartCtxMenu extends IDisposable
    {
        function initChartCtxMenu(chart:Chart):void;
    }
    
}