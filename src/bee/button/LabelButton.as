package bee.button
{
	import bee.printers.LabelBtnStatePrinter;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class LabelButton extends ButtonDecorator
	{
		static public const TEXTFIELD_NAME:String = "labelTextField";
		
		private var _label:String = "";
		
		public function LabelButton(btn:Button=null) 
		{
			super(btn);
			
			skin.statePrinter = new LabelBtnStatePrinter();
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Public Functions
		
		/**
		 * 
		 * @return
		 */
		override public function toString():String
		{
			return super.toString() + ', label';
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Getters & Setters
		
		public function get label():String { return _label; }		
		public function set label(value:String):void 
		{
			_label = value;
            needRedraw = true;
		}
		
		override protected function get defaultStyles():Object
		{
			return {
				'fontSize' : '12',
				'padding'  : '8'
			}
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Private Functions
	}

}