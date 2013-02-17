package bee.abstract
{
	import bee.performers.IPerformer;
	import bee.printers.IStatePrinter;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 拥有多种状态的对象，状态之间可以切换
	 * @author hua.qiuh
	 */
	public interface IStatesHost 
	{
		/**
		 * 获取或改变当前状态
		 */
		function get state():String;
		function set state(value:String):void;
		
		/**
		 * 将状态输出显示
		 * @param	state
		 * @param	context
		 */
		function printState(state:String = null, context:DisplayObjectContainer = null):void;
		
	}
	
}