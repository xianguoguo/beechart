package bee.plugins.pie.pieslice.printer {
    import bee.chart.abstract.Chart;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.events.ChartEvent;
    import bee.plugins.IPlugin;
    import bee.plugins.PluginBasic;

	/**
	 *  PieSlice展现插件基类
	 * @author jianping.shenjp
	 */
	public class PieSlice2dDrawPrinterPlugin extends PluginBasic implements IPlugin {

         /**
         * 根据配置设定printer.
         * labelPosition:
         * （仅在labelSetType不为normal的时候才有作用）
         *      none:只有小圆饼；
         *      inside:(默认设置)label水平放置，自动判断是否放置在圆饼内外侧;
         *      inside!:label水平放置，并且只在出现在圆饼内部；
         *      outside:label倾斜放置，且出现在外部；
         *
         * labelSetType: 
         *      normal:文字水平放置，且放置在圆饼外部;
         */
		protected var _labelSetType:String;
		protected var _labelPosition:String;

		public function PieSlice2dDrawPrinterPlugin(){
			super();
		}

		override public function initPlugin(chart:Chart):void {
			super.initPlugin(chart);
			chart.addEventListener(ChartEvent.AFTER_ADD_VIEW_ELEMENT, afterAddViewElement);
		}

		protected function afterAddViewElement(e:ChartEvent):void {
			var pieSlice:PieSlice = e.data as PieSlice;
			if (pieSlice){
				_labelSetType = pieSlice.getStyle("labelSetType");
				_labelPosition = pieSlice.getStyle("labelPosition");
			}
		}

		override public function dispose():void {
			chart.removeEventListener(ChartEvent.AFTER_ADD_VIEW_ELEMENT, afterAddViewElement);
			super.dispose();
		}

	}

}