package bee.chart.elements.tooltip
{
	import cn.alibaba.util.ColorUtil;
	import bee.abstract.IStatesHost;
	import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
	import flash.display.CapsStyle;
	import flash.display.DisplayObjectContainer;
    import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
    import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class TooltipSimplePrinter implements IStatePrinter
	{
		protected var tooltip:TooltipView;
		
		/* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
		
		public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
		{
			tooltip = host as TooltipView;
			if (tooltip)
			{
				if (context == tooltip.content)
				{
					tooltip.clearContent();
				}
				if (state == 'normal')
				{
					var container:Sprite = new Sprite();
					drawContent(container);
					drawBackground(container);
					context.addChild(container);
				}
				
				tooltip = null;
				
			}
		}
		
		protected function drawContent(container:Sprite):void
		{
			var padding:Number = Number(tooltip.getStyle('padding'));
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = StyleUtil.getTextFormat(tooltip);
			tf.x = tf.y = padding;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.htmlText = tooltip.getTipText();
			container.addChild(tf);
		}
		
		protected function drawBackground(container:Sprite):void
		{
			var bgColor:uint = ColorUtil.str2int(tooltip.getStyle('backgroundColor'));
			var bgAlpha:Number = Number(tooltip.getStyle('backgroundAlpha'));
			var bdColor:uint = ColorUtil.str2int(tooltip.getStyle('borderColor'));
			var bdAlpha:Number = Number(tooltip.getStyle('borderAlpha'));
			var bdThick:Number = Number(tooltip.getStyle('borderThickness'));
			var padding:Number = Number(tooltip.getStyle('padding'));
			
			var grph:Graphics = container.graphics;
			grph.lineStyle(bdThick, bdColor, bdAlpha, true);
			grph.beginFill(bgColor, bgAlpha);
			grph.drawRoundRect(0, 0, container.width + padding * 2, container.height + padding * 2, 10, 10);
			grph.endFill();
		}
	
	}

}