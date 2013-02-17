package bee.chart.elements.legend 
{
    import bee.chart.abstract.Chart;
    import bee.chart.elements.legend.item.LegendItem;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LegendNullBehavior implements ILegendBehavior 
    {
        
        /* INTERFACE cn.alibaba.yid.chart.elements.legend.ILegendBehavior */
        
        public function dealEvent(legendItem:LegendItem, chart:Chart, type:String, index:uint):void
        {
            //Do nothing
        }
        
    }

}