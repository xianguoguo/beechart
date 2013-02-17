package bee.performers 
{
	import flash.display.DisplayObject;
	import bee.abstract.CComponent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
    import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class RotateTransitionProgressUpdater implements ITransitionProgressUpdater
	{
		private var width:Number;
		private var height:Number;
		
		/* INTERFACE cn.alibaba.yid.performers.ITransitionProgressUpdater */
		
		public function updateProgress(progress:Number, host:CComponent, fromView:DisplayObject, toView:DisplayObject):void
		{
			if (fromView && toView) {
				var halfPast:Boolean = progress > 0.5;
				if (halfPast) {
					toView.visible = true;
					fromView.visible = false;
					toView.transform.matrix3D.identity();
					//toView.transform.matrix3D.appendRotation((progress-1) * 180, Vector3D.Y_AXIS, new Vector3D(width, height, 0));
					toView.transform.matrix3D.appendRotation((progress-1) * 180, Vector3D.X_AXIS, new Vector3D(width, height, 0));
					toView.filters = [ new BlurFilter(0, (1-progress) * 100)];
				} else {
					toView.visible = false;
					fromView.visible = true;
					fromView.transform.matrix3D.identity();
					//fromView.transform.matrix3D.appendRotation(progress*180, Vector3D.Y_AXIS, new Vector3D(width, height, 0));
					fromView.transform.matrix3D.appendRotation(progress*180, Vector3D.X_AXIS, new Vector3D(width, height, 0));
					fromView.filters = [ new BlurFilter(0, progress * 100)];
				}
			}
		}
		
		/* INTERFACE cn.alibaba.yid.performers.ITransitionProgressUpdater */
		
		public function prepare(host:CComponent, fromView:DisplayObject, toView:DisplayObject):void
		{
			width = host.width >> 1;
			height = host.height >> 1;
			fromView.z = 0;
			toView.z = 0;
			var pt:Point = new Point(width, height);
            var pp:PerspectiveProjection = new PerspectiveProjection();
            pp.projectionCenter = pt.clone();
            fromView.transform.perspectiveProjection = pp;
            toView.transform.perspectiveProjection = pp;
			updateProgress(0, host, fromView, toView);
		}
		
		public function dispose():void
		{
			
		}
		
	}

}