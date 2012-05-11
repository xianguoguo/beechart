package bee.printers
{
	import bee.abstract.IStatesHost;
	import bee.button.ButtonStates;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class OverGlowPrinter extends PrinterDecorator
	{
		
		private var _filter:BitmapFilter = new GlowFilter(0xFF0000, .2, 5, 5);
		
		public function OverGlowPrinter(base:IStatePrinter=null)
		{
			super(base);
		}
		
		override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
		{
			super.renderState(host, state, context);
			
			if (state == ButtonStates.OVER){
				context.filters = [ _filter ];
			} else {
				context.filters = [];
			}
		}
		
		public function get filter():BitmapFilter { return _filter.clone(); }
		public function set filter(value:BitmapFilter):void 
		{
			_filter = value.clone();
		}
		
	}

}