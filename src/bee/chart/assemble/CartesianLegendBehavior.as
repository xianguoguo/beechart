package bee.chart.assemble 
{
	import bee.chart.abstract.Chart;
	import bee.chart.elements.legend.ILegendBehavior;
	import bee.chart.elements.legend.item.LegendItem;
	import bee.chart.elements.legend.LegendEvent;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class CartesianLegendBehavior implements ILegendBehavior 
    {
        
        public function CartesianLegendBehavior() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.chart.elements.legend.ILegendBehavior */
        
        public function dealEvent(legendItem:LegendItem, chart:Chart, type:String, index:uint):void
        {
            switch(type) {
                case LegendEvent.TURN_ON:
                    chart.setDatasetVisibility( index, true );
                    legendItem.active = true;
                    break;
                case LegendEvent.TURN_OFF:
                    chart.setDatasetVisibility( index, false);
                    legendItem.active = false;
                    break;
                case LegendEvent.MOUSE_OVER:
                    //LineChart这两个接口还有点问题
                    //chart.setDatasetActivity( index, true);
                    break;
                case LegendEvent.MOUSE_OUT:
                    //同上
                    //chart.setDatasetActivity( index, false);
                    break;
            }
            
        }
        
    }
}