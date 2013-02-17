package bee.plugins.line {
    import bee.chart.abstract.Chart;
    import bee.chart.elements.line.LineEnterPerformer;
    import bee.chart.elements.line.LineView;
    import bee.plugins.IPlugin;
    import bee.plugins.PluginBasic;

	/**
	 * Line初始动画插件
	 * @author jianping.shenjp
	 */
	public class LineChartEnterAnimatorPlugin implements IPlugin
    {

		public function LineChartEnterAnimatorPlugin()
        {

		}

		public function initPlugin(chart:Chart):void 
        {
            //TODO: 这里有bug，当线条数量超过1条时，只能
            //显示出一条动画，原因是performer不能公用
            LineView.defaultPerformer = new LineEnterPerformer;
		}
        
        public function dispose():void {}
	}

}