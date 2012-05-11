package bee.chart.elements.timeline
{
	import cn.alibaba.core.IDisposable;
	import cn.alibaba.util.DisplayUtil;
	import bee.chart.elements.cursor.Cursor;
	import bee.chart.elements.cursor.CursorManager;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class RangeSelector extends Sprite implements IDisposable
	{
		static private const BG_COLOR:Number = 0xFFF000;
		private var MIN_BTN_DIS:Number = 10;
		private var _hostRange:Rectangle;
		private var _leftThumb:Thumb;
		private var _rightThumb:Thumb;
		private var _rangeSp:RangeSprite;
		private var _currentBtn:Sprite;
		private var _isMouseDown:Boolean = false;
		private var _oldMouseX:Number;
		private var _oldRangeWidth:Number;
		private var _oldRangeX:Number;
		private var _cursorManager:CursorManager = CursorManager.getInstance();
		
		public function RangeSelector(hostRange:Rectangle)
		{
			_hostRange = hostRange;
			drawBg();
			addBtnRangeSp();
			addBtns();
			drawAndMoveBtnRangeSp();
			addEventListeners();
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(RangeLocationEvent.SET_RANGE_LOCATION, setLocationHandler);
			removeEventListeners();
			DisplayUtil.clearSprite(this);
			_hostRange = null;
			_currentBtn = null;
			_cursorManager = null;
		}
		
		private function setThumbsState(state:String):void
		{
			if (_leftThumb && _rightThumb)
			{
				_leftThumb.state = state;
				_rightThumb.state = state;
			}
		}
		
		private function setLocationHandler(e:RangeLocationEvent):void
		{
			_leftThumb.x = e.btnXOne;
			_rightThumb.x = e.btnXTwo;
			drawAndMoveBtnRangeSp();
		}
		
		private function addEventListeners():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(RangeLocationEvent.SET_RANGE_LOCATION, setLocationHandler);
		}
		
		private function removeEventListeners():void
		{
			if (_leftThumb)
			{
				_leftThumb.removeEventListener(MouseEvent.MOUSE_DOWN, btnMouseDownHandler);
			}
			if (_rightThumb)
			{
				_rightThumb.removeEventListener(MouseEvent.MOUSE_DOWN, btnMouseDownHandler);
			}
			_rangeSp.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseOverHandler(e:MouseEvent):void
		{
			removeEventListeners();
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_rangeSp.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_leftThumb.addEventListener(MouseEvent.MOUSE_DOWN, btnMouseDownHandler);
			_rightThumb.addEventListener(MouseEvent.MOUSE_DOWN, btnMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseOutHandler(e:MouseEvent):void
		{
			if (!isMouseDown)
			{
				_cursorManager.hideCursor();
				removeEventListeners();
				isMouseDown = false;
				_currentBtn = null;
			}
		}
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			if (isMouseDown)
			{
				changeRange();
				dispatchDragEvent(true);
			}
			changeCursorAndThumbState(e);
			moveCursor();
			e.updateAfterEvent();
		}
		
		private function changeCursorAndThumbState(e:MouseEvent):void
		{
			var target:Sprite = e.target as Sprite;
			if (target is Thumb)
			{
				setThumbState(target as Thumb, Thumb.OVER);
				_cursorManager.setCursorState(Cursor.BTN_MOUSE_OVER);
				_cursorManager.showCursor();
			}
			else if (target is RangeSprite)
			{
				//防止用户在拖动按钮进行变换选区时，引起两边按钮都成DOWN状态
				if (_currentBtn)
				{
					return ;
				}
				
				setThumbsState(Thumb.NORMAL);
				if (isMouseDown)
				{
					_cursorManager.setCursorState(Cursor.DOWN);
					setThumbsState(Thumb.OVER);
				}
				else
				{
					_cursorManager.setCursorState(Cursor.OVER);
				}
				_cursorManager.showCursor();
				
			}
			else if (target is RangeSelector)
			{
				_cursorManager.hideCursor();
				setThumbsState(Thumb.NORMAL);
			}
			//用户在当前容器外放开鼠标等情况
			else
			{
				//setThumbsState(Thumb.NONE);
				_cursorManager.hideCursor();
				removeEventListeners();
			}
		}
		
		private function moveCursor():void
		{
			_cursorManager.followMouse();
		}
		
		private function changeRange():void
		{
			//当移动滑块时
			if (_currentBtn && _isMouseDown)
			{
				moveThumb();
				drawAndMoveBtnRangeSp();
				dispatchBtnLocationEvent();
			}
			//当移动时间选区时
			else if (_isMouseDown)
			{
				moveRange();
				dispatchBtnLocationEvent();
			}
		}
		
		private function moveThumb():void
		{
			_currentBtn.x = calculateThumbX(_currentBtn);
		}
		
		private function moveRange():void
		{
			_rangeSp.x = calculateRangeX();
			_leftThumb.x = _rangeSp.x;
			_rightThumb.x = _rangeSp.x + _rangeSp.width;
		}
		
		/**
		 * 计算rangeSp的X值，防止超出范围。
		 * @return
		 */
		private function calculateRangeX():Number
		{
			var rangeX:Number = mouseX - _oldMouseX;
			if (rangeX < _hostRange.left)
			{
				rangeX = _hostRange.left;
			}
			else if ((rangeX + _rangeSp.width) > _hostRange.right)
			{
				rangeX = _hostRange.right - _rangeSp.width;
			}
			return rangeX;
		}
		
		/**
		 * 计算btn的x值，使得x的值符合规则：
		 * 1.左边按钮的x值<右边按钮的x值；
		 * 2.按钮x值不超出范围;
		 * @param	currentBtn
		 * @return
		 */
		private function calculateThumbX(currentBtn:Sprite):Number
		{
			var result:Number = mouseX;
			if (currentBtn === _leftThumb)
			{
				if (_leftThumb.x > _rightThumb.x)
				{
					swapThumb();
					currentBtn = _rightThumb;
				}
			}
			else if (currentBtn === _rightThumb)
			{
				if (_rightThumb.x < _leftThumb.x)
				{
					swapThumb();
					currentBtn = _leftThumb;
				}
			}
			//边界条件
			if (result < _hostRange.left)
			{
				result = _hostRange.left;
			}
			else if (result > _hostRange.right)
			{
				result = _hostRange.right;
			}
			return result;
		}
		
		private function swapThumb():void
		{
			var tempThumb:Thumb;
			tempThumb = _leftThumb;
			_leftThumb = _rightThumb;
			_rightThumb = tempThumb;
			tempThumb = null;
		}
		
		private function btnMouseDownHandler(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_currentBtn = e.target as Sprite;
			_oldRangeX = _rangeSp.x;
			isMouseDown = true;
			e.stopPropagation();
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_oldMouseX = mouseX - _rangeSp.x;
			_oldRangeWidth = _rangeSp.width;
			isMouseDown = true;
			changeCursorAndThumbState(e);
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			dispatchDragEvent(false);
			isMouseDown = false;
			_currentBtn = null;
			changeCursorAndThumbState(e);
		}
		
		private function dispatchBtnLocationEvent():void
		{
			dispatchEvent(new RangeLocationEvent(RangeLocationEvent.RANGE_LOCATION, _leftThumb.x, _rightThumb.x, true));
		}
		
		private function dispatchDragEvent(isDragging:Boolean):void
		{
			dispatchEvent(new DragEvent(DragEvent.DRAG, isDragging, true));
		}
		
		/**
		 * 绘制一份透明的背景，防止相关事件监听不到.
		 */
		private function drawBg():void
		{
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(BG_COLOR, 0);
			g.drawRect(_hostRange.x, _hostRange.y, _hostRange.width, _hostRange.height);
			g.endFill();
		}
		
		private function addBtnRangeSp():void
		{
			_rangeSp = new RangeSprite();
			addChild(_rangeSp);
		}
		
		private function drawBtnRangeSp():void
		{
			//trace("drawBtnRangeSp~~~~~");
			const width:Number = _rightThumb.x - _leftThumb.x;
			const height:Number = maxHeight;
			var g:Graphics = _rangeSp.graphics;
			g.clear();
			g.lineStyle(0, 0x666666);
			g.beginFill(0xFF0000, 0);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		private function moveBtnRangeSp():void
		{
			_rangeSp.x = _leftThumb.x;
		}
		
		private function addBtns():void
		{
			_leftThumb = new Thumb();
			addChild(_leftThumb);
			
			_rightThumb = new Thumb();
			addChild(_rightThumb);
			
			_leftThumb.y = _rightThumb.y = (maxHeight - Thumb.THUMB_HEIGHT) * 0.5;
			setThumbsState(Thumb.NORMAL);
		}
		
		private function drawAndMoveBtnRangeSp():void
		{
			drawBtnRangeSp();
			moveBtnRangeSp();
		}
		
		private function setThumbState(thumb:Thumb, state:String):void
		{
			if (thumb)
			{
				thumb.state = state;
			}
		}
		
		private function get maxWidth():Number
		{
			return _hostRange.width;
		}
		
		private function get maxHeight():Number
		{
			return _hostRange.height;
		}
		
		private function get isMouseDown():Boolean
		{
			return _isMouseDown;
		}
		
		private function set isMouseDown(value:Boolean):void
		{
			if (_isMouseDown != value)
			{
				_isMouseDown = value;
			}
		}
	
	}

}