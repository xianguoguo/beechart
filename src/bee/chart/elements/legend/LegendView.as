package bee.chart.elements.legend 
{
    import cn.alibaba.core.mvcapp.IModel;
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartElementView;
    import bee.chart.elements.legend.item.LegendItem;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LegendView extends ChartElementView
    {
        
        public function LegendView(host:Legend) 
        {
            super(host);
            skin.statePrinter = new LegendSimplePrinter();
        }
        
        override protected function get defaultStyles():Object { 
            return {
                'layout'    : 'horizontal',
                'position'  : 'right',
                'align'     : 'center',
                'valign'    : 'middle',
                'backgroundColor'   : '#FFFFFF',
                'backgroundAlpha'   : 1,
                'borderThickness'   : null,
                'borderColor'       : '#FF7300',
                'borderAlpha'       : 1,
                'paddingLeft'       : 8,
                'paddingRight'      : 8,
                'paddingTop'        : 8,
                'paddingBottom'     : 8
            }; 
        }

        public function setLegendItemBlur(index:int, isBlur:Boolean):void
        {
            var legendItem:LegendItem = getLegendItem(index);
            if (legendItem)
            {
                legendItem.blur = isBlur;
            }
        }
        
        private function getLegendItem(index:int):LegendItem 
        {
            return content.getChildByName("item" + index) as LegendItem;
        }
        
    }

}
