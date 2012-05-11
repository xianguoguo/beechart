package bee.performers 
{
	import bee.abstract.CComponent;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public interface ITransitionProgressUpdater 
	{
		/**
		 * 开始前的准备
		 * @param	host
		 * @param	fromView
		 * @param	toView
		 */
		function prepare(host:CComponent, fromView:DisplayObject, toView:DisplayObject):void;
		
		/**
		 * 更新
		 * @param	progress
		 * @param	host
		 * @param	fromView
		 * @param	toView
		 */
		function updateProgress(progress:Number, host:CComponent, fromView:DisplayObject, toView:DisplayObject):void;
		
		/**
		 * 完成后的清理
		 */
		function dispose():void;
	}
	
}