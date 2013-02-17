package bee.plugins.pie.performer {
    import bee.chart.abstract.Chart;
	import bee.chart.assemble.pie.PiePerformers;
    import bee.chart.elements.pie.PieLine;
    import bee.chart.elements.pie.PieSliceCanvas;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.util.TO_RADIANS;
    import bee.controls.label.Label;
    import flash.display.DisplayObject;
    import com.greensock.easing.Strong;
    import com.greensock.TweenLite;

	/**
	 * 顺时针展现效果
	 * @author jianping.shenjp
	 */
	public class ClockwisePerformerPlugin extends PerformerPlugin 
    {

		public function ClockwisePerformerPlugin() 
        {
			_performerName = PiePerformers.CLOCKWISE;
		}
        
		override protected function performerFun(pieSliceCanvas:PieSliceCanvas, pieSliceLabel:Label, pieSliceLine:PieLine, data:PieSliceData, ... rest):void 
        {
            var startAngle:Number;
            var showTime:Number = 2;
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
                startAngle = data.startRadian / TO_RADIANS;
                pieSliceCanvas.rotation = 0;
                TweenLite.to(pieSliceCanvas, showTime, {
					rotation: startAngle, 
					ease: Strong.easeOut
				});
            }
		}
	}
}