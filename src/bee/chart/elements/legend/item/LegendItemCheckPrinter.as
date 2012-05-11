package bee.chart.elements.legend.item
{
    import bee.chart.elements.legend.CheckBoxItem;
    import bee.abstract.IStatesHost;
    import flash.display.DisplayObjectContainer;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class LegendItemCheckPrinter extends LegendItemSimplePrinter
    {
        override protected function drawIcon():void 
        {
			if(_host.getStyle('iconType') === 'square'){
				super.drawIcon();
			} else {
				var checkbox:CheckBoxItem = new CheckBoxItem(_data.color, _data.active);
				checkbox.y = -Math.round(checkbox.height / 2);
				_context.addChild(checkbox);
			}
        }
    }

}
