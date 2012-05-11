package bee.chart.elements.pie 
{
    import flash.events.Event;
	
	/**
	 * PieSliceEvent的自定义事件(暂时不用)
	 * @author jianping.shenjp
	 */
	public class PieSliceEvent extends Event 
	{
		public static const RESET_PIE:String = "resetPie";
		//public var view:ChartElementView;
		
		/**
		 * 构造函数
		 * @param	viewValue 事件带的ChartElementView
		 * @param	type 类型
		 * @param	bubbles 是否冒泡
		 * @param	cancelable 是否可取消
		 */
		public function PieSliceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			//this.view = viewValue;
		}
		
		override public function clone():Event 
		{
			return new PieSliceEvent(type,bubbles,cancelable);
		}
		
	}

}