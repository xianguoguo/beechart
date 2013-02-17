package bee.plugins.pie.pieslice.printer {
    import bee.chart.elements.pie.LabelPosition;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSlice2dDrawPrinterWithLabel;
    import bee.chart.events.ChartEvent;
    import bee.printers.IStatePrinter;

	/**
     * PieSlice展现插件
	 * PieSlice标签水平，自动判断内侧/外侧
	 * @author jianping.shenjp
	 */
	public class PieSlice2dDrawPrinterWithLabelPlugin extends PieSlice2dDrawPrinterPlugin {

		public function PieSlice2dDrawPrinterWithLabelPlugin(){
			super();

		}

		override protected function afterAddViewElement(e:ChartEvent):void {
			super.afterAddViewElement(e);
			var pieSlice:PieSlice = e.data as PieSlice;
			if (pieSlice){
				if (needChangeStatePrinter(pieSlice)){
					var printer:IStatePrinter = pieSlice.skin.statePrinter;
					pieSlice.skin.statePrinter = new PieSlice2dDrawPrinterWithLabel(printer);
				}
			}
		}

		private function needChangeStatePrinter(pieSlice:PieSlice):Boolean {
			return !(pieSlice.skin.statePrinter is PieSlice2dDrawPrinterWithLabel) && (!_labelPosition || _labelPosition == LabelPosition.INSIDE);
		}
	}

}