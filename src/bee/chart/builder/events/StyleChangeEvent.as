package bee.chart.builder.events
{
	import flash.events.Event;

	/**
	 * 改变样式相关的事件
	 * @author jianping.shenjp
	 *
	 */
	public class StyleChangeEvent extends Event
	{
		static public const STYLE_CHANGE:String="styleChange";
		static public const CSS_CHANGE:String="cssChange";
		//样式名字
		public var styleName:String;
		//样式对象
		public var styleObject:Object;

		/**
		 *
		 * @param type
		 * @param styleNameValue
		 * @param styleObjectValue
		 * @param bubbles
		 * @param cancelable
		 *
		 */
		public function StyleChangeEvent(type:String, styleNameValue:String, styleObjectValue:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			styleName=styleNameValue;
			styleObject=styleObjectValue;
		}

		override public function clone():Event
		{
			return new StyleChangeEvent(type, styleName, styleObject, bubbles, cancelable);
		}
	}
}