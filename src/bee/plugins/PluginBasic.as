package bee.plugins {
    import bee.chart.abstract.Chart;
    import flash.display.DisplayObject;

	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class PluginBasic implements IPlugin {
        
        protected var chart:Chart;

		public function PluginBasic(){

		}

		/* INTERFACE cn.alibaba.yid.chart.assemble.plugins.IPlugin */

		public function initPlugin(chart:Chart):void 
        {
            this.chart = chart;
		}
        
        public function dispose():void
        {
            chart = null;
        }
	}

}