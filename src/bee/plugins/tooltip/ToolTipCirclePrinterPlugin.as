package bee.plugins.tooltip {
	import bee.chart.abstract.Chart;
	import bee.chart.elements.tooltip.Tooltip;
	import bee.chart.events.ChartEvent;
	import bee.plugins.PluginBasic;

	/**
	 * Tooltip展现插件
	 * @author jianping.shenjp
	 */
	public class ToolTipCirclePrinterPlugin extends PluginBasic {

		public function ToolTipCirclePrinterPlugin(){
			super();
		}

		override public function initPlugin(chart:Chart):void {
			super.initPlugin(chart);
			chart.addEventListener(ChartEvent.AFTER_ADD_VIEW_ELEMENT, afterAddViewElement);
		}

		private function afterAddViewElement(e:ChartEvent):void {
			var tooltip:Tooltip = e.data as Tooltip;
			if (tooltip){
				if (!(tooltip.skin.statePrinter is TooltipCirclePrinter)){
					tooltip.skin.statePrinter = new TooltipCirclePrinter();
				}
			}
		}

		override public function dispose():void {
			chart.removeEventListener(ChartEvent.AFTER_ADD_VIEW_ELEMENT, afterAddViewElement);
			super.dispose();
		}
	}

}