package bee.chart.elements.legend 
{
    import bee.chart.abstract.Chart;
    import bee.chart.elements.legend.item.LegendItem;
    
    /**
    * ...
    * @author hua.qiuh
    */
    public interface ILegendBehavior 
    {
        function dealEvent(legendItem:LegendItem, chart:Chart, type:String, index:uint):void;
    }
    
}