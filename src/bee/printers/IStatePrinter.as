package bee.printers 
{
	import bee.abstract.IStatesHost;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 将组件渲染成UI界面
	 * @author hua.qiuh
	 */
	public interface IStatePrinter
	{
		/** 渲染指定的状态 **/
		function renderState(
			host:IStatesHost, 
			state:String,
			context:DisplayObjectContainer
		):void;
	}
	
}