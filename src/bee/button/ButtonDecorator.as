package bee.button 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class ButtonDecorator extends Button
	{
		private var _decorator:DisplayObject;
		protected var _btn:Button;
		
		public function ButtonDecorator(btn:Button) 
		{
			if (!btn) {
				btn = new Button();
			}
			_btn = btn;
			addChildAt(btn, 0);
			super();
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Public Functions
		
		/**
		 * 设置背景图片
		 * @param	value
		 * @param	statesCount
		 * @param	withSelectedStates
		 * @param	withRect
		 */
		override public function setBackground(value:BitmapData, statesCount:int = 4, withSelectedStates:Boolean = false, withRect:Boolean = false):void 
		{
			_btn.setBackground(value, statesCount, withSelectedStates, withRect);
		}
		
		/**
		 * 垃圾回收
		 */
		override public function dispose():void 
		{
			_btn.dispose();
			_btn = null;
			super.dispose();
		}
		
		override public function printState(state:String = null, context:DisplayObjectContainer = null):void 
		{
			if (!state) {
				state = this.state;
			}
			if (!context) {
				context = content;
			}
			//
			_btn.printState(state, context);
			super.printState(state, context);
		}
		
		/**
		 * 获得所有装饰物 
		 * @return
		 */
		public function getDecorators():Vector.<DisplayObject> 
		{
			var vct:Vector.<DisplayObject> = getBaseDecorators();
			if (decorator) {
				vct.push(decorator);
			}
			return vct;
		};
		
		/**
		 * 获取除当前装饰物之外的其他装饰物
		 * @return
		 */
		public function getBaseDecorators():Vector.<DisplayObject>
		{
			if (_btn is ButtonDecorator) {
				return ButtonDecorator(_btn).getDecorators();
			} else {
				return new Vector.<DisplayObject>();
			}
		}
		
		/**
		 * 获取装饰物
		 * @return
		 */
		public function getDecoratorBounds(vct:Vector.<DisplayObject>, targetCoord:DisplayObject):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			if(vct.length){
				var addRect:Function = function(obj:DisplayObject, ...args):void {
					if (!rect) {
						rect = obj.getBounds(targetCoord);
					} else {
						rect = rect.union(obj.getBounds(targetCoord));
					}
				};
				vct.forEach(addRect, this);
			}
			return rect;
		}
		
		/**
		 * 调整装饰内容的位置
		 */
		public function layoutDecorator():void
		{
			var vct:Vector.<DisplayObject> = getDecorators();
			if (vct.length) {
				
				//获得装饰物相对于content的范围
				var rect:Rectangle = getDecoratorBounds( getDecorators(), content);
				var w:int = rect.width;
				var h:int = rect.height;
				var padding:int = parseFloat(getStyle("padding"));
				if (!isNaN(padding)) {
					w += padding * 2;
					h += padding * 2;
				}
				var bgW:int = width;
				var bgH:int = height;
				var offX:int = 0, offY:int = 0;
				
				if (w > bgW) {
					//content lager than background
					width = w;
				} else {
					offX = ((bgW - w) >> 1) - rect.left + padding;
				}
                
				if (h > bgH) {
					//content lager than background
					height = h;
				} else {
					offY = ((bgH - h) >> 1) - rect.top + padding;
				}
                
				if (offX || offY) {
					vct.forEach(function(obj:DisplayObject, ...args):void
					{
						obj.x += offX;
						obj.y += offY;
					}, this);
				}
			}
		}
		
		/**
		 * 设置样式
		 * @param	name
		 * @param	value
		 */
		override public function setStyle(name:String, value:String):void 
		{
			_btn.setStyle(name, value);
			super.setStyle(name, value);
		}
		
		/**
		 * 清除内容
		 */
		override public function clearContent():void 
		{
			super.clearContent();
			_decorator = null;
		}
		
		override public function addContent(content:DisplayObject, align:String = 'right'):void 
		{
			var rect:Rectangle = getDecoratorBounds( getBaseDecorators(), this.content);
			if (align == 'left') {
				content.x = rect.left - content.width;
			} else {
				content.x = rect.right;
			}
			content.y = (this.content.height - content.height) >> 1;
			this.content.addChild(content);
            layoutDecorator();
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Getters & Setters
		
		/**
		 * 按钮宽度由原始按钮宽度决定
		 */
		override public function get width():Number { return _btn.width; }
		override public function set width(value:Number):void 
		{
			_btn.width = value;
		}
		
		/**
		 * 按钮高度由原始按钮高度决定
		 */
		override public function get height():Number { return _btn.height; }
		override public function set height(value:Number):void 
		{
			_btn.height = value;
		}
		
		/**
		 * 设置尺寸
		 * @param	w
		 * @param	h
		 */
		override public function setSize(w:int, h:int):void 
		{
			_btn.setSize(w, h);
		}
		
		/**
		 * 设置可用状态
		 */
		override public function set enabled(value:Boolean):void {
			_btn.enabled = value; 
			super.enabled = value;
		}
		
		/**
		 * 设置九宫缩放
		 */
		override public function get scale9Grid():Rectangle { return _btn.scale9Grid; }
		override public function set scale9Grid(value:Rectangle):void 
		{
			_btn.scale9Grid = value;
		}
		
		/**
		 * 状态
		 */
		override public function get state():String { return _btn.state; }
		override public function set state(value:String):void 
		{
			_btn.state = value;
			super.state = value;
		}
		
		/**
		 * 
		 */
		override public function get content():Sprite { 
			//内容都集中在一起
			return _btn.content; 
		}
		
		/**
		 * 当前的装饰物
		 */
		public function get decorator():DisplayObject { return _decorator; }
		public function set decorator(value:DisplayObject):void 
		{
			_decorator = value;
			layoutDecorator();
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Private Functions
		
		override protected function redraw():void 
		{
			_btn.updateNow();
			super.redraw();
		}
		
	}

}