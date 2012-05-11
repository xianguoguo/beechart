package bee.chart.elements.axis 
{
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartElementView;
	/**
    * ...
    * @author hua.qiuh
    */
    public class AxisView extends ChartElementView
    {
        
        public function AxisView(host:Axis) 
        {
            super(host);
            skin.statePrinter = new AxisSimplePrinter();
        }
        
        /**
        * 突出显示坐标轴的某个标签
        * @param	value
        */
        public function highlightAt(value:Number):void 
        {
            var printer:IAxisWithLabelPrinter = skin.statePrinter as IAxisWithLabelPrinter;
            if (printer) {
                printer.highlightLabelAt(this, value);
            }
        }
        
        /**
        * 清除当前的效果
        */
        public function clearHighlight():void 
        {
            var printer:IAxisWithLabelPrinter = skin.statePrinter as IAxisWithLabelPrinter;
            if (printer) {
                printer.clearHighlightLabel(this);
            }
        }
        
        public function get hightLightValue():int
        {
            return (dataModel as AxisData).highlightValue;
        }
        
        override protected function get defaultStyles():Object { 
            return {
                'paddingLeft'   : '0',
                'lineThickness' : '2',
                'lineColor'     : '#666666',
                'tickLength'    : '5',
                'tickThickness' : '2',
                'tickColor'     : '#666666',
                'tickPosition'  : 'normal'
            };
        }
    }

}