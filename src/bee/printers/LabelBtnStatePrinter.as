package bee.printers
{
	import bee.abstract.IStatesHost;
	import bee.button.LabelButton;
	import cn.alibaba.util.ColorUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class LabelBtnStatePrinter extends PrinterDecorator
	{
		
		public function LabelBtnStatePrinter(base:IStatePrinter=null)
		{
			super(base);
		}
		
		override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer ):void 
		{
            basePrinter.renderState(host, state, context);
                
			if (host is LabelButton) {
				var btn:LabelButton = host as LabelButton;
				var btnContent:Sprite = btn.content;
				
				var tf:TextField = btnContent.getChildByName('labelTF') as TextField;
				if(!tf){
					tf = new TextField();
					tf.name = 'labelTF';
				} 
				tf.autoSize = TextFieldAutoSize.LEFT;
                
                
				var tfm:TextFormat = new TextFormat(
					btn.getStyle("fontFamily"), 
					btn.getStyle("fontSize"),
					ColorUtil.str2int(btn.getStyle("color")),
					btn.getStyle("fontWeight") == 'bold',
					btn.getStyle("fontStyle"),
					btn.getStyle("underline"),
					null,
					null,
					btn.getStyle("textAlign"),
					btn.getStyle("paddingLeft"),
					btn.getStyle("paddingRight"),
					btn.getStyle("indent"),
					btn.getStyle("leading")
				);
				tf.defaultTextFormat = tfm;
				tf.setTextFormat(tfm);
				tf.text = btn.label;
                
				//tf.height = tf.textHeight;
				//tf.background = true; //for debug
				try { btnContent.removeChild(tf); } catch(e:Error){}
				btn.addContent(tf);
				btn.decorator = tf;
				context.addChild(tf);
			}
		}
		
		private function cloneTextField(tf:TextField):TextField
		{
			var textfield:TextField = new TextField();
			textfield.text = tf.text;
			return textfield;
		}
		
	}

}