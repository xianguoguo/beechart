package bee.controls.label 
{
	import cn.alibaba.util.ColorUtil;
	import cn.alibaba.util.DisplayUtil;
	import bee.abstract.IStatesHost;
	import bee.abstract.IStylable;
	import bee.chart.util.ChartUtil;
	import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class LabelSimplePrinter implements IStatePrinter 
    {
        
        public function LabelSimplePrinter() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            
            var label:Label = host as Label;
            if (label) {
                
                DisplayUtil.clearSprite(context as Sprite);
                
                var tf:TextField = LabelSimplePrinter.getFormatTextField(label);
				tf.htmlText = ChartUtil.getRestrictTxt(label.text, Number(label.getStyle('maxchar')));
				if (label.rotation) {
					var bmpd:BitmapData = new BitmapData(tf.width, tf.height, true, 0);
					bmpd.draw(tf);
					var bmp:Bitmap = new Bitmap(bmpd);
					bmp.pixelSnapping = PixelSnapping.ALWAYS;
					bmp.smoothing = true;
					context.addChild(bmp);
                }else
				{
					context.addChild(tf);
				}
				
                if (label.hasStyle('backgroundColor')) {
                    //draw bg
                    var bgColor:uint = ColorUtil.str2int(label.getStyle('backgroundColor'));
                    var bgApha:Number = Number(label.getStyle('backgroundAlpha'));
                    var crRadius:Number = Number(label.getStyle('cornerRadius'));
                    var bg:Shape = new Shape();
                    var grph:Graphics = bg.graphics;
                    grph.beginFill(bgColor, bgApha);
                    grph.drawRoundRect(0, 0, context.width, context.height, crRadius, crRadius);
                    grph.endFill();
                    context.addChildAt(bg, 0);
                }
                
            }
            
        }
		
		static public function getFormatTextField(host:IStylable):TextField 
		{
			var tf:TextField = new TextField();
			var tfm:TextFormat = StyleUtil.getTextFormat(host as IStylable);
			tf.setTextFormat(tfm);
			tf.defaultTextFormat = tfm;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.mouseEnabled = false;
			return tf;
		}
        
    }
}