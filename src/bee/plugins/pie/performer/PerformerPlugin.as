package bee.plugins.pie.performer {
    import bee.chart.abstract.Chart;
    import bee.chart.assemble.pie.PiePerformer;
    import bee.chart.elements.pie.PieLine;
    import bee.chart.elements.pie.PieSliceCanvas;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.events.ChartEvent;
    import bee.controls.label.Label;
    import bee.plugins.IPlugin;
    import bee.plugins.PluginBasic;
    import flash.events.Event;

	/**
	 * 动画插件的基类
	 * @author jianping.shenjp
	 */
	public class PerformerPlugin extends PluginBasic implements IPlugin {
        
		protected var _performerName:String; //展现效果的名称
		protected var _performer:PiePerformer;

		public function PerformerPlugin(){
			_performer = new PiePerformer(performerFun);
		}

		override public function initPlugin(chart:Chart):void {
			super.initPlugin(chart);
            
            chart.addEventListener(ChartEvent.BEFORE_PRINT_STATE, beforeChartPrint);
		}
        
        private function beforeChartPrint(e:Event):void 
        {
            if (needChangePerformer()) {
                chart.skin.performer = _performer;
            }
        }
        
        protected function needChangePerformer():Boolean 
        {
            return chart.skin.performer != _performer && chart.getStyle("animate") == _performerName
        }
        
        protected function performerFun(pieSliceCanvas:PieSliceCanvas, pieSliceLabel:Label, pieSliceLine:PieLine, data:PieSliceData, ... rest):void
        {
            
        }

		override public function dispose():void {
			if (_performer){
				_performer = null;
			}
            chart.removeEventListener(ChartEvent.BEFORE_PRINT_STATE, beforeChartPrint);
            super.dispose();
		}
	}

}