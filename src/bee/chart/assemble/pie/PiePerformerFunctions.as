package bee.chart.assemble.pie
{
    import bee.chart.elements.pie.PieLine;
    import bee.chart.elements.pie.PieSliceCanvas;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.util.TO_RADIANS;
    import bee.controls.label.Label;
    import com.greensock.easing.Back;
    import com.greensock.easing.Strong;
    import com.greensock.TweenLite;

	/**
	 * pie展现效果简单工厂类
	 * @author jianping.shenjp
	 * 
	 */    
    public class PiePerformerFunctions
    {
        /**
         * 根据动画类型返回对应的处理逻辑
         * @param animate
         * @return
         *
         */
        public static function getPerformerFunction(animate:String):Function
        {
            var returnValue:Function;
            switch (animate)
            {
                case PiePerformers.CLOCKWISE:
                    returnValue = PiePerformerFunctions.pieClockwisePerformerFunction;
                    break;
                case PiePerformers.COUNTER_CLOCKWISE:
                    returnValue = PiePerformerFunctions.pieCounterClockwisePerformerFunction;
                    break;
                case PiePerformers.COMPOSITE:
                    returnValue = PiePerformerFunctions.pieCompositePerformerFunction;
                    break;
                case PiePerformers.EXPAND:
                    returnValue = PiePerformerFunctions.pieExpandPerformerFunction;
                    break;
                default:
					returnValue = null;
                    break;
            }
            return returnValue;
        }

		//顺时针展现效果
        static public var pieClockwisePerformerFunction:Function = function(pieSliceCanvas:PieSliceCanvas, pieSliceLabel:Label, pieSliceLine:PieLine, data:PieSliceData, ...rest):void
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
			
		//逆时针展现效果
		static public var pieCounterClockwisePerformerFunction:Function = function(pieSliceCanvas:PieSliceCanvas, pieSliceLabel:Label, pieSliceLine:PieLine, data:PieSliceData, ...rest):void
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
					rotation: startAngle - 360, 
					ease: Strong.easeOut
				});
			}
		}
			
		//组合效果
		static public var pieCompositePerformerFunction:Function = function(pieSliceCanvas:PieSliceCanvas, pieSliceLabel:Label, pieSliceLine:PieLine, data:PieSliceData, ...rest):void
		{
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
		
		//中心展开效果
		static public var pieExpandPerformerFunction:Function = function(pieSliceCanvas:PieSliceCanvas, pieSliceLabel:Label, pieSliceLine:PieLine, data:PieSliceData, ...rest):void
		{
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