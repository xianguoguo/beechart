package bee.chart.elements.bar
{
    import bee.chart.elements.bar.BarView;
    import bee.chart.util.SlashMask;
	import flash.display.DisplayObjectContainer;
	import bee.abstract.IStatesHost;
	
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class BarWithSlashBgPrinter extends BarSimplePrinter
	{
		
		public function BarWithSlashBgPrinter()
		{
		
		}
		
		override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
		{
			super.renderState(host, state, context);
			
			var view:BarView = host as BarView;
			if (view.getStyle('backgroundType') == 'slash')
			{
                var slash:SlashMask = new SlashMask(width, height);
                slash.x = startX;
                slash.y = startY;
                context.addChild(slash);
			}
		}
	}

}