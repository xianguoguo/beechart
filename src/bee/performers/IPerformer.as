package bee.performers
{
	import bee.abstract.IStatesHost;
	
	/**
	 * 组件状态变化处理器接口
	 * 组件的状态发生变化时，Performer负责将变化反映到界面上
	 * @author hua.qiuh
	 */
	public interface IPerformer 
	{
		/** 当状态发生变化时调用 **/
		function performTransition(host:IStatesHost, fromState:String, toState:String):void;
	}
	
}