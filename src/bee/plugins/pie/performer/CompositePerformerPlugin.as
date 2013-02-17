package bee.plugins.pie.performer {
	import bee.chart.elements.pie.PieSliceData;
	import bee.chart.elements.pie.PieLine;
	import bee.controls.label.Label;
	import bee.chart.assemble.pie.PiePerformers;
	import bee.chart.elements.pie.PieSliceCanvas;
    import com.greensock.easing.Strong;
    import com.greensock.TweenLite;

	/**
	 * 组合效果
	 * @author jianping.shenjp
	 */
	public class CompositePerformerPlugin extends PerformerPlugin 
    {

		public function CompositePerformerPlugin()
        {
			performerName = PiePerformers.COMPOSITE;
		}

		override public function performer(pieSliceCanvas:PieSliceCanvas, pieSliceLabel:Label, pieSliceLine:PieLine, data:PieSliceData, ... rest):void 
        {
			super.performer(pieSliceCanvas, pieSliceLabel, pieSliceLine, data);
            if (pieSliceCanvas)
			{
				var time:int = rest[0] as int;//执行的次数
				var delayTime:Number = 0.05 * time;//延迟时间
				var showTime:Number = 1.5;
				var rad:Number = data.getPositionRadian();
				var tempX:Number = data.pieSliceCanvasX + Math.cos(rad) * 50;
				var tempY:Number = data.pieSliceCanvasY + Math.sin(rad) * 50;
				if (pieSliceLine)
				{
					TweenLite.from(pieSliceLine, 1, {
						alpha: 0, 
						ease: Strong.easeOut, 
						delay: showTime + delayTime
					});
				}
				if (pieSliceLabel)
				{
					TweenLite.from(pieSliceLabel, 1, {
						alpha: 0, 
						ease: Strong.easeOut, 
						delay: showTime + delayTime
					});
				}
				TweenLite.from(pieSliceCanvas, showTime, {
					alpha: 0, 
					x: tempX, 
					y: tempY, 
					ease: Strong.easeOut, 
					delay: delayTime
				});
			}
		}
	}

}