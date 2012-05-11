package bee.plugins.pie.performer {
	import bee.chart.elements.pie.PieSliceData;
	import bee.chart.elements.pie.PieLine;
	import bee.controls.label.Label;
	import bee.chart.assemble.pie.PiePerformers;
	import bee.chart.elements.pie.PieSliceCanvas;
    import com.greensock.easing.Back;
    import com.greensock.easing.Strong;
    import com.greensock.TweenLite;

	/**
	 * 中心展开效果
	 * @author jianping.shenjp
	 */
	public class ExpandPerformerPlugin extends PerformerPlugin {

		public function ExpandPerformerPlugin(){
			performerName = PiePerformers.EXPAND;
		}

		override public function performer(pieSliceCanvas:PieSliceCanvas, pieSliceLabel:Label, pieSliceLine:PieLine, data:PieSliceData, ... rest):void {
			super.performer(pieSliceCanvas, pieSliceLabel, pieSliceLine, data);
            var showTime:Number = 1;
			if (pieSliceCanvas)
			{
				if (pieSliceLine)
				{
					TweenLite.from(pieSliceLine, 1, {
						alpha: 0, 
						ease: Strong.easeOut, 
						delay: showTime
					});
				}
				if (pieSliceLabel)
				{
					TweenLite.from(pieSliceLabel, 1, {
						alpha: 0, 
						ease: Strong.easeOut, 
						delay: showTime
					});
				}
				TweenLite.from(pieSliceCanvas, showTime, {
					height: 0, 
					ease: Back.easeOut
				});
			}
		}
	}

}