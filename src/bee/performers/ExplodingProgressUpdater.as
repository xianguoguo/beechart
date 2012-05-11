package bee.performers 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import bee.abstract.CComponent;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class ExplodingProgressUpdater implements ITransitionProgressUpdater
	{
		private var _fromBmpd:BitmapData;
		private var _runtimeBmpd:BitmapData;
		//private var _particles:Vector.<BitmapData>;
		
		public function ExplodingProgressUpdater() 
		{
			
		}
		
		/* INTERFACE cn.alibaba.yid.performers.ITransitionProgressUpdater */
		
		public function updateProgress(progress:Number, 
			host:CComponent, 
			fromView:DisplayObject, 
			toView:DisplayObject
		):void {
			
			var halfPast:Boolean = progress > 0.5;
			if (halfPast) {
				toView.visible = true;
				fromView.visible = false;
				fromView.filters = [];
			} else {
				toView.visible = false
				fromView.visible = true;
				fromView.filters = [ new BlurFilter(progress * 50, 0)];
			}
			
			var w:Number = _runtimeBmpd.width >> 2;
			var h:Number = _runtimeBmpd.height >> 2;
			var newx:Number = -w - progress
		}
		
		public function prepare(host:CComponent, fromView:DisplayObject, toView:DisplayObject):void
		{
			//TODO: make explose effect
			_fromBmpd = new BitmapData(host.width, host.height);
			_fromBmpd.draw(host);
			_runtimeBmpd = new BitmapData(host.width << 1, host.height << 1, true, 0x5FFF7300);
			var sp:Sprite = new Sprite();
			var bmp:Bitmap = new Bitmap(_runtimeBmpd);
			sp.mouseEnabled = false;
			sp.mouseChildren = false;
			sp.addChild(bmp);
			sp.x = host.x - (host.width >> 1);
			sp.y = host.y - (host.height >> 1);
			//host.parent.addChild(sp);
			
			updateProgress(0, host, fromView, toView);
		}
		
		public function dispose():void
		{
			_fromBmpd.dispose();
			_runtimeBmpd.dispose();
			
		}
		
	}

}