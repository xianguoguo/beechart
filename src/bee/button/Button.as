package bee.button
{
	import cn.alibaba.common.nullobjs.NullBitmapData;
	import bee.abstract.CComponent;
	import bee.printers.SimpleBtnSttPrinter;
	import cn.alibaba.util.DisplayUtil;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 由图片定制皮肤的按钮组件
	 * @author qhwa, http://china.alibaba.com
	 */
	public class Button extends CComponent
	{
		private var _width:Number;
		private var _height:Number;
		private var _toggle:Boolean = false;
		private var _selected:Boolean = false;
		private var _assets:BitmapData;
		private var _scale9Grid:Rectangle;

		private var _upBmpdSrc:BitmapData;
		private var _overBmpdSrc:BitmapData;
		private var _downBmpdSrc:BitmapData;
		private var _disableBmpdSrc:BitmapData;
		
		private var _upBmpd:BitmapData;
		private var _overBmpd:BitmapData;
		private var _downBmpd:BitmapData;
		private var _disableBmpd:BitmapData;
		
		private var _selUpBmpdSrc:BitmapData;
		private var _selOverBmpdSrc:BitmapData;
		private var _selDownBmpdSrc:BitmapData;
		private var _selDisableBmpdSrc:BitmapData;
		
		private var _selUpBmpd:BitmapData;
		private var _selOverBmpd:BitmapData;
		private var _selDownBmpd:BitmapData;
		private var _selDisableBmpd:BitmapData;
		
		public function Button() 
		{
			initBitmapDatas();
			addMouseListeners();
			skin.statePrinter		= new SimpleBtnSttPrinter();
			state 					= ButtonStates.UP;
			buttonMode 				= true;
			focusRect 				= false;
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Public Functions
		
		/**
		 * 垃圾回收
		 */
		override public function dispose():void 
		{
			removeMouseListeners();
			disposeAllBitmapData();
			super.dispose();
		}
		
		/**
		 * 设置背景图片
		 * @param	value	将各个状态集中在一张图片中的背景图(bitmapData)
		 * @param	statesCount	这张背景图中包含了多少种状态
		 */
		public function setBackground(value:BitmapData, statesCount:int = 4, withSelectedStates:Boolean = false, withScale9:Boolean = false):void 
		{
			disposeAllBitmapData();
			if (withScale9) statesCount ++;
			extractBmpds(value, statesCount, withSelectedStates);
			
			//包含scale9，计算出scale9Grid
			if (withScale9) {
				var resultGrid:Rectangle = new Rectangle();
				var vh:int 				= value.height, vw:int = value.width;
				var w:int 				= withSelectedStates ? (vw >> 1) : vw;
				var h:int 				= vh / statesCount;
				var rect:Rectangle 		= new Rectangle(w >> 1, vh - h, 1, h);
				var vctV:Vector.<uint> 	= value.getVector(rect);
				rect 					= new Rectangle(0, vh - (h >> 1), w, 1);
				var vctH:Vector.<uint> 	= value.getVector(rect);
				vctV.fixed 				= true;
				vctH.fixed 				= true;
				
				var startColor:int = vctV[0], prev:uint;
				var checker:Function = function(color:uint, id:int, vct:Vector.<uint>):Boolean {
					if (id == 0) {
						prev = color;
						return false;
					}
					var done:Boolean = false;
					var diff:Boolean =  id != 0 && color != prev;
					var prop:String;
					if (diff) {
						if (prev == startColor) {
							prop = vct == vctH ? 'left' : 'top';
							resultGrid[prop] = id;
						} else if(color==startColor) {
							prop = vct == vctH ? 'right' : 'bottom';
							resultGrid[prop] = id;
							done = true;
						}
					}
					prev = color;
					return done;
				}
				vctV.some(checker, this);
				vctH.some(checker, this);
				if (resultGrid.width && resultGrid.height) {
					scale9Grid = resultGrid;
				}
			}
			_assets = value.clone();
			updateNow();
		}
		
		/**
		 * 设置尺寸
		 * @param	w	宽度
		 * @param	h	高度
		 */
		public function setSize(w:int, h:int):void
		{
			_width 			= w;
			_height 		= h;
			if (!w || !h) return;
			_upBmpd 		= DisplayUtil.resizeBitmap(_upBmpdSrc, w, h, scale9Grid);
			_overBmpd 		= DisplayUtil.resizeBitmap(_overBmpdSrc, w, h, scale9Grid);
			_downBmpd 		= DisplayUtil.resizeBitmap(_downBmpdSrc, w, h, scale9Grid);
			_disableBmpd 	= DisplayUtil.resizeBitmap(_disableBmpdSrc, w, h, scale9Grid);
			
			if(toggle){
				_selUpBmpd 		= DisplayUtil.resizeBitmap(_selUpBmpdSrc, w, h, scale9Grid);
				_selOverBmpd 	= DisplayUtil.resizeBitmap(_selOverBmpdSrc, w, h, scale9Grid);
				_selDownBmpd 	= DisplayUtil.resizeBitmap(_selDownBmpdSrc, w, h, scale9Grid);
				_selDisableBmpd = DisplayUtil.resizeBitmap(_selDisableBmpdSrc, w, h, scale9Grid);
			}
			updateNow();
		}
		
		/**
		 * 将按钮根据内容的大小重新设置尺寸
		 */
		public function fitConent():void
		{
		}
        
        override public function setStyle(name:String, value:String):void 
        {
            super.setStyle(name, value);
            if (name === 'width') {
                width = Number(value);
            } else if (name === 'height') {
                height = Number(value);
            }
        }
		
		/**
		 * 获取背景图片BitmapData对象
		 * @param	state 状态名称
		 * @param source 是否是未经缩放的位图
		 * @return
		 */
		public function getSttBmpd( state:String = null ):BitmapData
		{
			if (!state) {
				state = this.state;
			}
			switch(state) {
				case ButtonStates.UP: 
					return _upBmpd.clone();
				case ButtonStates.OVER: 
					return _overBmpd.clone();
				case ButtonStates.DOWN: 
					return _downBmpd.clone();
				case ButtonStates.DISABLED: 
					return _disableBmpd.clone();
				case ButtonStates.SELECTED_UP: 
					return _selUpBmpd.clone();
				case ButtonStates.SELECTED_OVER: 
					return _selOverBmpd.clone();
				case ButtonStates.SELECTED_DOWN: 
					return _selDownBmpd.clone();
				case ButtonStates.SELECTED_DISABLED: 
					return _selDisableBmpd.clone();
				default:
					return _upBmpd.clone();
			}
		}
		
		/**
		 * 获取背景图片BitmapData对象
		 * @param	state 状态名称
		 * @param source 是否是未经缩放的位图
		 * @return
		 */
		public function getSttSrcBmpd( state:String = null ):BitmapData
		{
			if (!state) {
				state = this.state;
			}
			switch(state) {
				case ButtonStates.UP: 
					return _upBmpdSrc.clone();
				case ButtonStates.OVER: 
					return _overBmpdSrc.clone();
				case ButtonStates.DOWN: 
					return _downBmpdSrc.clone();
				case ButtonStates.DISABLED: 
					return _disableBmpdSrc.clone();
				case ButtonStates.SELECTED_UP: 
					return _selUpBmpdSrc.clone();
				case ButtonStates.SELECTED_OVER: 
					return _selOverBmpdSrc.clone();
				case ButtonStates.SELECTED_DOWN: 
					return _selDownBmpdSrc.clone();
				case ButtonStates.SELECTED_DISABLED: 
					return _selDisableBmpdSrc.clone();
				default:
					return _upBmpdSrc.clone();
			}
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Private Functions
		
		override protected function initView():void 
		{
			super.initView();
			mouseChildren = false;
		}
		
		protected function extractBmpds(
			assets:BitmapData, 
			statesCount:uint, 
			withSel:Boolean = false
		):void
		{
			//GC
			getBitmapNameVector().forEach(disposeBitmapData, null);
			
			var w:int 			= withSel ? assets.width >> 1 : assets.width;
			var h:int 			= assets.height / statesCount;
			var rect:Rectangle 	= new Rectangle(0, 0, w, h);
			var pt:Point 		= new Point();
			var current:int 	= 0;
			var distRect:Rectangle = new Rectangle(0, 0, w, h);
			
			var names:Array = [
				'_upBmpdSrc', 
				'_selUpBmpdSrc',
				'_overBmpdSrc', 
				'_selOverBmpdSrc',
				'_downBmpdSrc', 
				'_selDownBmpdSrc',
				'_disableBmpdSrc',
				'_selDisableBmpdSrc'
			];
			var bmpdName:String, selBmpdName:String;
			for (var i:int = 0, len:int = names.length; i < len; i+=2) {
				bmpdName = names[i];
				selBmpdName = names[i + 1];
				var bmpd:BitmapData = new BitmapData(w, h, true, 0x00FFFFFF);
				bmpd = new BitmapData(w, h, true, 0x00FFFFFF);
				rect.x = 0;
				bmpd.setVector( distRect, assets.getVector(rect));
				this[bmpdName] = bmpd.clone();
				if(withSel){
					rect.x = w;
					bmpd.setVector( distRect, assets.getVector(rect));
					this[selBmpdName] = bmpd.clone();
				}
				bmpd.dispose();
				
				if (++current < statesCount) {
					rect.y += h;
				}
				
			}
			
			setSize(w, h);
		}
		
		protected function addMouseListeners():void
		{
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		protected function removeMouseListeners():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onOver);
			removeEventListener(MouseEvent.ROLL_OUT, onOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function initBitmapDatas():void
		{
			_assets = new NullBitmapData();
			getBitmapNameVector().forEach(initBitmapData, null);
			
		}
		
		private function getBitmapNameVector():Vector.<String>
		{
			var vcts:Vector.<String> = Vector.<String>([
				'_upBmpd', '_upBmpdSrc', 
				'_overBmpd', '_overBmpdSrc', 
				'_downBmpd', '_downBmpdSrc',
				'_disableBmpd','_disableBmpdSrc',
				'_selUpBmpd', '_selUpBmpdSrc',
				'_selOverBmpd', '_selOverBmpdSrc',
				'_selDownBmpd', '_selDownBmpdSrc',
				'_selDisableBmpd', '_selDisableBmpdSrc'
			]);
			vcts.fixed = true;
			return vcts;
			
		}
		
		private function disposeAllBitmapData():void
		{
			_assets.dispose();
			getBitmapNameVector().forEach(disposeBitmapData, null);
		}
		
		
		private function disposeBitmapData(name:String, idx:uint, vct:Vector.<String>):void
		{
			var bmpd:BitmapData = BitmapData(this[name]);
			if (bmpd) {
				bmpd.dispose();
				this[name] = null;
			}
		}
		
		private function initBitmapData(name:String, idx:uint, vct:Vector.<String>):void
		{
			this[name] = new NullBitmapData();
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Getters & Setters
		
		/**
		 * 是否可以切换选中/非选中状态
		 */
		public function get toggle():Boolean { return _toggle; }		
		public function set toggle(value:Boolean):void 
		{
			_toggle = value;
			if (value) {
				setSize( width , height);
			}
		}
		
		/**
		 * 是否处于选中状态
		 */
		public function get selected():Boolean { return _selected; }		
		public function set selected(value:Boolean):void 
		{
			if (!toggle) return;
			if(_selected != value){
				_selected = value;
				state = value ? ButtonStates.SELECTED_UP : ButtonStates.UP;
			}
		}
		
		/**
		 * 缩放时保持形状不走样的设置
		 */
		override public function get scale9Grid():Rectangle { return _scale9Grid; }		
		override public function set scale9Grid(value:Rectangle):void 
		{
			_scale9Grid = value;
			setSize( width, height );
		}
		
		/**
		 * 像素宽度
		 */
		public function get pixelWidth():int {
			return super.width;
		}
		
		public function get pixelHeight():int {
			return super.height;
		}
		
		/**
		 *宽度
		 */
		override public function get width():Number { return _width; }		
		override public function set width(value:Number):void 
		{
			_width = value;
			setSize( value, height );
		}
		
		/**
		 * 高度
		 */
		override public function get height():Number { return _height; }		
		override public function set height(value:Number):void 
		{
			_height = value;
			setSize( width, value );
		}
		
		/**
		 * 设置enabled属性时，更改状态
		 */
		override public function set enabled(value:Boolean):void 
		{
			var old:Boolean = enabled;
			super.enabled = value;
			
			if (value != old) {
				if(value){
					state = selected ? ButtonStates.SELECTED_UP : ButtonStates.UP;
				} else {
					state = selected ? ButtonStates.SELECTED_DISABLED : ButtonStates.DISABLED;
				}
			}
			
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Event Handlers
		
		private function onUp(e:MouseEvent):void 
		{
			if (hitTestPoint(e.stageX, e.stageY)) {
				state = selected ? ButtonStates.SELECTED_OVER : ButtonStates.OVER;				
			} else {
				state = selected ? ButtonStates.SELECTED_UP : ButtonStates.UP;
			}
		}
		
		private function onDown(e:MouseEvent):void 
		{
			if (toggle) {
				selected = !selected;
			} else {
				state = selected ? ButtonStates.SELECTED_DOWN : ButtonStates.DOWN;
			}
		}
		
		private function onOut(e:MouseEvent):void 
		{
			if(enabled){
				state = selected ? ButtonStates.SELECTED_UP : ButtonStates.UP;
			}
		}
		
		/**
		 * 鼠标移入时，进入over状态
		 * 当处于禁用状态时，不会响应鼠标事件，所以这里不用判断enable
		 * @param	e
		 */
		private function onOver(e:MouseEvent):void 
		{
			state = selected ? ButtonStates.SELECTED_OVER : ButtonStates.OVER;
		}
		
		override public function toString():String 
		{
			return "YID-Button#" + this.name;
		}
		
		
	}
	
}