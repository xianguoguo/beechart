package bee.button 
{
	import bee.printers.IconBtnStatePrinter;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.utils.Dictionary;
	
	/**
	 * 含有图标的按钮组件
	 * 
	 * 目前已知的问题：当icon和label都存在时，
	 * 使用transitionPerformer时会有问题，导
	 * 致尺寸计算出错
	 * @author hua.qiuh
	 */
	public class IconButton extends ButtonDecorator
	{
		static public const CONTAINER_NAME:String = "iconContainer";
		
		private var _iconsLookup:Dictionary 		= new Dictionary(true);
		
		public function IconButton(btn:Button=null) 
		{
			super(btn);
			skin.statePrinter = new IconBtnStatePrinter();
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Public Functions
		
		/**
		 * 设置某个状态的按钮
		 * @param	icon 按钮
		 * @param	state 状态
		 */
		public function setIconOfState(icon:DisplayObject, state:String):void
		{
			_iconsLookup[state] = icon;
			if (state == this.state) {
				redraw();
			}
		}
		
		/**
		 * 垃圾回收
		 */
		override public function dispose():void 
		{
			for (var each:String in _iconsLookup) {
				delete _iconsLookup[each];
			}
			_iconsLookup = null;
			
			super.dispose();
		}
		
		override public function toString():String
		{
			return super.toString() + ', icon';
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Getters & Setters
		
		/**
		 * 获取某个状态的icon
		 * @param	state
		 * @return
		 */
		public function getStateIcon(state:String):DisplayObject
		{
			return _iconsLookup[state] as DisplayObject;
		}
		
		override protected function get defaultStyles():Object { 
			return {
				'iconAlign': 'left',
				'iconOffsetX': '0',
				'iconOffsetY': '0',
				'iconMargin' : '8'
			};
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Private Functions
		
	}

}