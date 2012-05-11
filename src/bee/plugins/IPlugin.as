package bee.plugins {
    import cn.alibaba.core.IDisposable;
    import bee.chart.abstract.Chart;
    import flash.display.DisplayObject;

	/**
	 * 
	 * @author jianping.shenjp
	 */
	public interface IPlugin extends IDisposable {
        
		function initPlugin(chart:Chart):void;
	}

}