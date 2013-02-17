package bee.chart.elements.cursor
{
	import cn.alibaba.core.IDisposable;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class CursorManager implements IDisposable
	{
		static private var _intance:CursorManager;
		private var _container:DisplayObjectContainer;
		private var _cursor:Cursor;
		
		public function CursorManager(inClass:InClass)
		{
			if (inClass == null)
			{
				throw new IllegalOperationError("inClass can't be null");
			}
		}
		
		static public function getInstance():CursorManager
		{
			if (!_intance)
			{
				_intance = new CursorManager(new InClass());
			}
			return _intance;
		}
		
		public function addCursorTo(container:DisplayObjectContainer):void
		{
			if (_cursor == null || (_cursor && !_cursor.isExist))
			{
				_cursor = new Cursor();
                _cursor.visible = false;
			}
			if (container)
			{
				_container = container;
				container.addChild(_cursor);
			}
		}
		
		public function showCursor():void
		{
            if (!_cursor)
            {
                return;
            }
            if (!_cursor.visible)
            {
                Mouse.hide();
                _cursor.visible = true;
            }
            if (_container)
            {
                _container.addChild(_cursor);
            }
        }
		
		public function hideCursor():void
		{
			if (!_cursor)
			{
				return;
			}
			Mouse.show();
			_cursor.state = Cursor.NONE;
			_cursor.visible = false;
		}
		
		public function setCursorState(state:String):void
		{
			if (_cursor)
			{
				_cursor.state = state;
			}
		}
		
		public function getCursorState():String
		{
			if (_cursor)
			{
				return _cursor.state;
			}
			return "";
		}
		
		public function followMouse():void
		{
			if (_cursor && _container)
			{
				_cursor.x = _container.mouseX;
				_cursor.y = _container.mouseY;
			}
		}
		
		public function dispose():void
		{
			if (_cursor)
			{
				_cursor.dispose();
				_cursor = null;
			}
			_intance = null;
            _container = null;
		}
	}

}

class InClass
{

}