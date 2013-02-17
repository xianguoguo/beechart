package cn.alibaba.core.history 
{
	/**
     * ...
     * @author hua.qiuh
     */
    public class CommandStack
    {
        
        private var _cmds:Vector.<IRedoableCommand>;
        private var _index:int;
        
        public function CommandStack() 
        {
            _cmds = new Vector.<IRedoableCommand>;
            _index = 0;
        }
        
		/**
		 * 添加新命令
		 * @param	command
		 */
        public function push(cmd:IRedoableCommand):void
        {
            _cmds[_index++] = cmd;
			//GC
            var unused:Vector.<IRedoableCommand> = _cmds.splice( _index, _cmds.length - _index );
			unused.forEach( disposeCmd, null);
        }
		
		private function disposeCmd(cmd:IRedoableCommand, ...args):void
		{
			cmd.dispose();
		}
        
		/**
		 * 回退
		 * @return
		 */
        public function previous():IRedoableCommand
        {
            if( hasPrevious() ){
                return _cmds[--_index];
            } else {
                return null;
            }
        }
        
		/**
		 * 前进
		 * @return
		 */
        public function next():IRedoableCommand
        {
            if (hasNext()) {
                return _cmds[_index++];
            } else {
                return null;
            }
        }
        
		/**
		 * 是否还能回退
		 * @return
		 */
        public function hasPrevious():Boolean
        {
            return _index > 0;
        }
        
		/**
		 * 是否能前进
		 * @return
		 */
        public function hasNext():Boolean
        {
            return _cmds.length > 0 && _index < _cmds.length;
        }
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			_cmds.forEach( disposeCmd, null );
		}
        
    }

}