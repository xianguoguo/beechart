package bee.test 
{
    import asunit.framework.*;
    import cn.alibaba.util.*;
    import cn.alibaba.yid.button.*;
    import cn.alibaba.yid.performers.*;
    import cn.alibaba.yid.printers.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class YIDButtonTest extends TestCase
	{
        [Embed(source='../../common/ui/assets/Golden-Button-rect.png')]
		static public const IMG_SKIN:Class;
		
		[Embed(source = '../../common/ui/assets/Silver-Button.png')]
		static public const SILVER_SKIN:Class;
        
        [Embed(source='../../common/ui/assets/Simple-Silver-Button.png')]
        static public const BLUE_SKIN:Class;
		
		private var _btn:Button;
		
		public function YIDButtonTest(testMethod:String) 
		{
			super(testMethod);
		}
		
		
		override protected function setUp():void 
		{
			_btn = new Button();
			context.addChild(_btn);
		}
		
		override protected function tearDown():void 
		{
			_btn.dispose();
			context.removeChild(_btn);
		}
		
		/**
		 * 测试简单按钮
		 */
		public function testSimpleBtn():void
		{
			var bmpd:BitmapData = new BitmapData(50, 40, false);
			bmpd.fillRect(new Rectangle(0, 0, 50, 20), 0xFF0000);
			bmpd.fillRect(new Rectangle(0, 20, 50, 20), 0xFFFF00);
			_btn.setBackground(bmpd, 2);
			assertTrue(context.contains(_btn));
			assertEquals(50, _btn.width);
			assertEquals(20, _btn.height);
		}
		
		/**
		 * 测试设置和清除样式
		 */
		public function testSimpleBtnStyle():void
		{
			_btn.setStyle("alpha", "0.5");
			assertEquals("0.5", _btn.getStyle("alpha"));
			assertEquals(1, _btn.alpha);
			
			_btn.updateNow();
			assertEquals(0.5, _btn.content.alpha);
			
			_btn.unsetStyle("alpha");
			_btn.updateNow();
			assertEquals(1, _btn.alpha);
		}
		
		/**
		 * 测试图片作为背景图
		 */
		public function testImgBtn():void
		{
			_btn.y = 40;
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
		
		/**
		 * 测试渐变效果
		 */
		public function testTransition():void
		{
			var asset:BitmapData = DisplayUtil.assets2bmpd(IMG_SKIN);
			var up:BitmapData = new BitmapData(asset.width, asset.height / 5, true, 0x00FFFFFF);
			up.setVector( up.rect, asset.getVector(up.rect) );
			
			_btn.y = 100;
			_btn.name = 'aabb';
			_btn.setBackground(asset, 4, false, true);
			_btn.skin.performer = new TransitionPerformer();
			assertTrue(_btn.skin.performer is TransitionPerformer);
			//TODO: make more test on this
			
		}
		
		public function testBreathTransition():void
		{
			var asset:BitmapData = DisplayUtil.assets2bmpd(IMG_SKIN);
			var btn:LabelButton = new LabelButton();
			btn.label = "按钮测试 ButtonTest";
			btn.setBackground(asset, 4, false, true);
			btn.setSize(100, 50);
			btn.y = 100;
			btn.x = 250;
			
			btn.setStyles({
                "color.up": "#934002",
                "color.over": "#333333",
                "fontSize": "14",
                "fontWeight": "bold",
                "fontFamily": "微软雅黑,Arial"
            });
			btn.skin.statePrinter = new OverGlowPrinter(btn.skin.statePrinter);
			btn.skin.performer = new TransitionPerformer();
			context.addChild(btn);
		}
		
		public function testIconButton():void
		{
			var asset:BitmapData = DisplayUtil.assets2bmpd(IMG_SKIN);
			var btn:IconButton = new IconButton();
			btn.setBackground(asset, 4, false, true);
			//btn.setSize(100, 50);
			btn.y = 160;
			btn.x = 250;
			
			var iconBmpd:BitmapData = new BitmapData(10, 10, false, 0xFF0000);
			var icon:Bitmap = new Bitmap(iconBmpd.clone());
			//iconBmpd.floodFill(1, 1, 0xFF7300);
			var overIcon:Bitmap = new Bitmap(new BitmapData(20, 20, false, 0xFFFFFF));
			btn.setIconOfState(icon, ButtonStates.UP);
			btn.setIconOfState(overIcon, ButtonStates.OVER);
			btn.skin.statePrinter = new OverGlowPrinter(btn.skin.statePrinter);
			//btn.skin.performer = new TransitionPerformer();
			context.addChild(btn);
		}
		
		public function testIconAndLabelBtn():void
		{
			var asset:BitmapData = DisplayUtil.assets2bmpd(IMG_SKIN);
			var btn:Button = new IconButton();
			btn.setBackground(asset, 4, false, true);
			btn.setSize(100, 50);
			btn.y = 220;
			btn.x = 250;
			
			var iconBmpd:BitmapData = new BitmapData(10, 10, false, 0xFF0000);
			var icon:Bitmap = new Bitmap(iconBmpd.clone());
            
			var overIcon:Bitmap = new Bitmap(new BitmapData(20, 20, false, 0xFFFFFF));
			IconButton(btn).setIconOfState(icon, ButtonStates.UP);
			IconButton(btn).setIconOfState(overIcon, ButtonStates.OVER);
            
			btn = new LabelButton(btn);
			LabelButton(btn).label = 'Icon';
			context.addChild(btn);
		}
		
		public function testExplodeTransition():void
		{
			var asset:BitmapData = DisplayUtil.assets2bmpd(SILVER_SKIN);
			var btn:LabelButton = new LabelButton();
			btn.setBackground(asset, 1, false, false);
			btn.scale9Grid = new Rectangle(5, 5, 98, 22);
			btn.setSize(100, 50);
			btn.y = 280;
			btn.x = 250;
			
			btn.label = "按钮测试 ButtonTest";
			btn.setStyles({
                "color.up": "#934002",
                "color.over": "#333333",
                "fontSize": "14",
                "fontWeight": "bold",
                "fontFamily": "微软雅黑,Arial"
            });
            
            var transPfm:TransitionPerformer = new TransitionPerformer();
			transPfm.updater = new ExplodingProgressUpdater();
			transPfm.duration = .5;
			btn.skin.performer = transPfm;
            
            var filter:BitmapFilter = new DropShadowFilter(2, 45, 0x333333, .2, 5, 5);
            var printer:OverGlowPrinter = new OverGlowPrinter(btn.skin.statePrinter);
            printer.filter = filter;
			btn.skin.statePrinter = printer;
			context.addChild(btn);
		}
		
        /**
        * 旋转切换效果测试
        */
		public function testRotateTransition():void
		{
			var asset:BitmapData = DisplayUtil.assets2bmpd(IMG_SKIN);
			var btn:LabelButton = new LabelButton();
			btn.setBackground(asset, 4, false, true);
			btn.setSize(100, 50);
			btn.y = 340;
			btn.x = 250;
			
			btn.label = "按钮测试 ButtonTest 翻转效果";
			btn.setStyles({
                "color.up": "#934002",
                "color.over": "#333333",
                "fontSize": "14",
                "fontWeight": "bold",
                "fontFamily": "微软雅黑,Arial"
            });
            
            var transPfm:TransitionPerformer = new TransitionPerformer();
			transPfm.updater = new RotateTransitionProgressUpdater();
			transPfm.duration = .5;
			btn.skin.performer = transPfm;
			btn.skin.statePrinter = new OverGlowPrinter(btn.skin.statePrinter);
			context.addChild(btn);
		}
		
        /**
        * Simple blue
        */
		public function testBlue():void
		{
			var asset:BitmapData = DisplayUtil.assets2bmpd(BLUE_SKIN);
			var btn:Button = new Button();
			btn.setBackground(asset);
            btn.scale9Grid = new Rectangle(5, 5, 50, 12);
			btn.setSize(200, 100);
			btn.y = 400;
			btn.x = 250;
			context.addChild(btn);
		}
        
        public function testLabelBtn():void
        {
            var btn:LabelButton = new LabelButton();
            btn.name = "test-label-btn";
			var asset:BitmapData = DisplayUtil.assets2bmpd(IMG_SKIN);
            btn.setBackground(asset, 4, false, true);
            btn.y = 510;
            btn.x = 250;
            //btn.setSize(200, 50);
            btn.label = "按钮测试";
            context.addChild(btn);
        }
        
        public function testSimpleRotate():void
        {
            var btn:Button = new Button();
            btn.setBackground( DisplayUtil.assets2bmpd(SILVER_SKIN), 1 );
            btn.y = 510;
            btn.x = 550;
            btn.skin.performer = new TransitionPerformer(
                new RotateTransitionProgressUpdater()
            );
            context.addChild(btn);
        }
		
		
		
		
	}

}