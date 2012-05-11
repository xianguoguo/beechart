package bee.printers
{
	import bee.abstract.IStatesHost;
	import bee.button.Button;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	
	/**
	 * 按钮状态简单输出
	 * @author hua.qiuh
	 */
	public class SimpleBtnSttPrinter extends PrinterDecorator implements IStatePrinter
	{
		public function SimpleBtnSttPrinter(base:IStatePrinter=null)
		{
			super(base);
		}
		
		
		/**
		 * 渲染按钮的状态
		 * @param	host	按钮
		 * @param	state 按钮状态，如果不指定，则使用按钮的当前状态
		 * @param	context 显示容器。如果不指定，则使用按钮的content
		 * @return 返回渲染结果
		 */
		override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
		{
			super.renderState(host, state, context);
			
			var btn:Button = host as Button;
			var bmpd:BitmapData = btn.getSttBmpd( state );
			
			if ( context && 
				'graphics' in context && 
				context['graphics'] is Graphics
			){
				var grph:Graphics = context['graphics'];
				grph.clear();
				grph.beginBitmapFill( bmpd, null, false );
				grph.drawRect(	0, 0, bmpd.width, bmpd.height );
				grph.endFill();
			}
			
			//apply style
			var alpha:Number = parseFloat(btn.getStyle("alpha"))
			if (!isNaN(alpha)) {
				context.alpha = alpha;
			} else {
				context.alpha = 1;
			}
		}
		
	}

}