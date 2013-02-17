package cn.alibaba.core.mvcapp 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class CModel extends EventDispatcher implements IModel
	{
		
		protected var _changed:Boolean = false;
		
		public function CModel() 
		{
			
		}
		
		protected function notifyChange():void
		{
			_changed = true;
			dispatchEvent( new Event( Event.CHANGE ) );
		}
        
        public function get changed():Boolean
        {
            return _changed;
        }
		
		public function set changed(value:Boolean):void
		{
			_changed = value;
		}
        
        public function dispose():void
        {
        }
        
	}

}