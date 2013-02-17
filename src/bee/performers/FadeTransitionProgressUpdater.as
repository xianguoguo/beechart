package bee.performers 
{
	import flash.display.DisplayObject;
	import bee.abstract.CComponent;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class FadeTransitionProgressUpdater implements ITransitionProgressUpdater
	{
		
		/* INTERFACE cn.alibaba.yid.performers.ITransitionProgressUpdater */
		
		public function updateProgress(progress:Number, host:CComponent, fromView:DisplayObject, toView:DisplayObject):void
		{
			if (fromView && toView) {
				var halfPast:Boolean = progress > 0.5;
				if (halfPast) {
					toView.alpha = 1;
					fromView.alpha = 2 - progress * 2;
				} else {
					toView.alpha = progress * 2;
					fromView.alpha = 1;
				}
			}
			
		}
		
		public function prepare(host:CComponent, fromView:DisplayObject, toView:DisplayObject):void
		{
			updateProgress(0, host, fromView, toView);
		}
		
		public function dispose():void
		{
			
		}
		
	}

}