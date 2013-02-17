package bee.plugins.tooltip {
    import cn.alibaba.util.ColorUtil;
	import bee.abstract.IStatesHost;
    import bee.chart.elements.tooltip.TooltipView;
	import bee.printers.IStatePrinter;
	import bee.util.StyleUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class TooltipCirclePrinter implements IStatePrinter {

		public function TooltipCirclePrinter(){

		}

		/* INTERFACE cn.alibaba.yid.printers.IStatePrinter */

		public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void {
			var tip:TooltipView = host as TooltipView;
			if (tip){
				if (context == tip.content){
					tip.clearContent();
				}
				if (state == 'normal'){
					var bgColor:uint = ColorUtil.str2int(tip.getStyle('backgroundColor'));
					var bgAlpha:Number = Number(tip.getStyle('backgroundAlpha'));
					var bdColor:uint = ColorUtil.str2int(tip.getStyle('borderColor'));
					var bdAlpha:Number = Number(tip.getStyle('borderAlpha'));
					var bdThick:Number = Number(tip.getStyle('borderThickness'));
					var padding:Number = Number(tip.getStyle('padding'));

					var sp:Sprite = new Sprite();
					var tf:TextField = new TextField();
					tf.defaultTextFormat = StyleUtil.getTextFormat(tip);
					tf.x = tf.y = padding;
					tf.autoSize = 'left';
					tf.htmlText = tip.getTipText();
					sp.addChild(tf);

					var grph:Graphics = sp.graphics;
					grph.lineStyle(bdThick, bdColor, bdAlpha);
					grph.beginFill(bgColor, bgAlpha);
					var w:Number = tf.width + padding * 2;
					var h:Number = tf.height + padding * 2
					grph.drawEllipse(0, 0, w, h);
					grph.endFill();
					context.addChild(sp);
				}
			}

		}
	}
}