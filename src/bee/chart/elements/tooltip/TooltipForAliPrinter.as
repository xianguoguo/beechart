package bee.chart.elements.tooltip
{
	import cn.alibaba.util.ColorUtil;
	import bee.util.StyleUtil;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class TooltipForAliPrinter extends TooltipSimplePrinter
	{
		
		public function TooltipForAliPrinter()
		{
		
		}
		
		override protected function drawBackground(container:Sprite):void
		{
            if (tooltip.getStyle('backgroundType') === 'simple') {
                super.drawBackground(container);
                return;
            }
            
			var bgColor:uint    = StyleUtil.getColorStyle(tooltip, 'backgroundColor');
			var bgAlpha:Number  = StyleUtil.getNumberStyle(tooltip, 'backgroundAlpha', 1);
			var bdAlpha:Number  = StyleUtil.getNumberStyle(tooltip, 'borderAlpha', 1);
			var padding:Number  = StyleUtil.getNumberStyle(tooltip, 'padding');
			
			var grph:Graphics = container.graphics;
			var w:uint = container.width + padding * 2;
			var h:uint = container.height + padding * 2;
			
			grph.lineStyle(0, 0xE9E9E9, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL);
			grph.drawRect(0, 0, w, h);
			grph.endFill();
			
			grph.lineStyle(0, 0xFFFFFF, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL);
			var mtx:Matrix = new Matrix();
			mtx.createGradientBox(w, h, 0, 0, 0);
			grph.beginGradientFill(GradientType.RADIAL, [0xFEFEFE, 0xEEEEEE], [bgAlpha, bgAlpha], [0, 255], mtx);
			grph.drawRect(1, 1, w - 2, h - 2);
			grph.endFill();
			
			grph.lineStyle(0, 0xBCBCBC, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL);
			grph.moveTo(10, 1);
			grph.lineTo(1, 1);
			grph.lineTo(1, 10);
			
			grph.moveTo(w - 10, 1);
			grph.lineTo(w - 1, 1);
			grph.lineTo(w - 1, 10);
			
			grph.moveTo(10, h - 1);
			grph.lineTo(1, h - 1);
			grph.lineTo(1, h - 10);
			
			grph.moveTo(w - 10, h - 1);
			grph.lineTo(w - 1, h - 1);
			grph.lineTo(w - 1, h - 10);
			grph.endFill();
		}
	
	}

}