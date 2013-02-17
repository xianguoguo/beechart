package bee.test 
{
	import asunit.framework.TestCase;
	import bee.button.Button;
	import bee.button.ButtonDecorator;
	import bee.button.ButtonStates;
	import cn.alibaba.util.DisplayUtil;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class YIDButtonDecoratorTest extends TestCase
	{
		[Embed(source='../../common/ui/assets/Golden-Button-rect.png')]
		static public const IMG_SKIN:Class;
		
		private var _btn:ButtonDecorator;
		
		public function YIDButtonDecoratorTest(testMethods:String) 
		{
			super(testMethods);
		}
		
		override protected function setUp():void 
		{
			_btn = new ButtonDecorator(new Button());
			context.addChild(_btn);
		}
		
		override protected function tearDown():void 
		{
			
		}
		
		public function testBackground():void
		{
			var asset:BitmapData = DisplayUtil.assets2bmpd(IMG_SKIN);
			var up:BitmapData = new BitmapData(asset.width, asset.height / 5, true, 0x00FFFFFF);
			up.setVector( up.rect, asset.getVector(up.rect) );
			
			_btn.setBackground(asset, 4, false, true);
			_btn.setBackground(asset, 4, false, true);
			_btn.setSize(400, 25);
			assertEquals(_btn.width, 400);
			assertEquals(_btn.height, 25);
			
			var cmp:Object = up.compare(_btn.getSttSrcBmpd(ButtonStates.UP));
			assertEquals("source match", 0, cmp);
		}
		
	}

}