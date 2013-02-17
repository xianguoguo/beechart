package cn.alibaba.core.history 
{
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class HistoryManager
	{
		private var _stack:CommandStack = new CommandStack();
		
		public function HistoryManager() 
		{
		}
		
		/**
		 * 插入一条指令
		 * @param	cmd
		 */
		public function insertCmd(cmd:IRedoableCommand, execute:Boolean=true):void
		{
			_stack.push(cmd);
			//自动执行
			if (execute) {
				cmd.execute();
			}
		}
		
		/**
		 * 撤销
		 * @return
		 */
		public function redo():Boolean
		{
			var cmd:IRedoableCommand = _stack.next();
			if (cmd) {
				cmd.redo();
			}
			return _stack.hasNext();
		}
		
		/**
		 * 重做
		 * @return
		 */
		public function undo():Boolean
		{
			var cmd:IRedoableCommand = _stack.previous();
			if (cmd) {
				cmd.undo();
			}
			return _stack.hasPrevious();
		}
		
		/**
		 * 清除
		 */
		public function clear():void
		{
			_stack.dispose();
			_stack = new CommandStack();
			
		}
        
        public function dispose():void
        {
            _stack.dispose();
            _stack = null;
        }
		
		/**
		 * 是否可以重做
		 */
		public function get canRedo():Boolean { 
			return _stack.hasNext(); 
		}	
		
		/**
		 * 是否可以撤销
		 */
		public function get canUndo():Boolean { 
			return _stack.hasPrevious(); 
		}
		
        
	}

}