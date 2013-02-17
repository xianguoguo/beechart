package bee.chart.assemble.pie 
{
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.elements.legend.ILegendBehavior;
    import bee.chart.elements.legend.LegendEvent;
    import bee.chart.elements.legend.item.LegendItem;
    import bee.chart.elements.pie.PieSliceView;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class PieLegendBehavior implements ILegendBehavior 
    {
        /* INTERFACE cn.alibaba.yid.chart.elements.legend.ILegendBehavior */
        
        public function dealEvent(legendItem:LegendItem, chart:Chart, type:String, index:uint):void
        {
            if ((chart.view as ChartViewer).isSmoothing)
            {
                return;
            }
            var viewer:PieChartViewer = chart.view as PieChartViewer;
            switch(type) {
                case LegendEvent.MOUSE_OVER:
                    chart.setDatasetActivity(index, true);
                    break;
                case LegendEvent.MOUSE_OUT:
                    chart.setDatasetActivity(index, false);
                    break;
                case LegendEvent.TURN_ON:
                case LegendEvent.TURN_OFF:
                    viewer.toggleSliceIndex(index);
                    break;
            }
        }
        
    }

}