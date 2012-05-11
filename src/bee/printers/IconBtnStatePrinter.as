package bee.printers 
{
	import bee.abstract.IStatesHost;
	import bee.button.IconButton;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class IconBtnStatePrinter extends PrinterDecorator
	{
		
		public function IconBtnStatePrinter(base:IStatePrinter=null) 
		{
			super(base);
		}
		
		/* INTERFACE cn.alibaba.yid.abstract.IStatePrinter */
		
		override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
		{
			if (host is IconButton) {
				
				var btn:IconButton = host as IconButton;
				var btnContent:Sprite = btn.content;
				
				var container:Sprite = btnContent.getChildByName(IconButton.CONTAINER_NAME) as Sprite;
				if (!container) {
					container = new Sprite();
					container.name = IconButton.CONTAINER_NAME;
				} else {
					while (container.numChildren) {
						container.removeChildAt(0);
					}
				}
				var icon:DisplayObject = btn.getStateIcon(state);
				if (icon) {
					container.addChild(icon);
				}

				var cont:DisplayObject, i:uint;
				var offsetX:uint, offsetY:uint;
				
				switch(btn.getStyle('iconAlign')) {
					case 'right':
						break;
					case 'left':
					default:
						var bounds:Rectangle = btnContent.getBounds(btnContent);
						//container.x = bounds.left - container.width;
						break;
				}
				
				//btnContent.addChild(container);
				btn.addContent(container, 'left');
				btn.decorator = container;
				context.addChild(container);
				
			}
		}
		
	}

}