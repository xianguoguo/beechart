package bee.chart.builder.events
{
	import flash.events.DataEvent;
	import flash.events.Event;

	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class BuilderEvent extends DataEvent
	{
		/** 选择不同的图表类型 **/
		static public const CHART_TYPE_CHANGE:String='chart_type_change';
		/** 切换图表类型,回到主界面时，给子界面分发的事件 */
		static public const RESET:String='reset';
		/**子界面被选中时，分发的事件 */
		static public const SELECTED:String="selected";

		/**
		 *
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	data
		 */
		public function BuilderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null)
		{
			super(type, bubbles, cancelable, data);
		}

		override public function clone():Event
		{
			return new BuilderEvent(type, bubbles, cancelable, data);
		}

	}

}