package bee.chart.elements.dot 
{
	import cn.alibaba.core.mvcapp.IModel;
	import bee.printers.NullPrinter;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class NullDot extends Dot 
	{
		
		public function NullDot(data:IModel=null) 
		{
			super(data);
			skin.statePrinter = NullPrinter.instance;
		}
		
	}

}