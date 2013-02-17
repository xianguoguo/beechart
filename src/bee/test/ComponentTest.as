package bee.test {
	
	import asunit.framework.TestCase;
	import bee.abstract.CComponent;
	import bee.performers.SimplePerformer;
	import flash.display.Sprite;

	/**
	 * 组件基本功能单元测试
	 */
	public class ComponentTest extends TestCase {
		
		private var instance:CComponent;

		public function ComponentTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():void {
			instance = new CComponent();
			addChild(instance);
		}

		protected override function tearDown():void 
		{
			removeChild(instance);
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("AbstractComponent instantiated", instance is CComponent);
		}
		
		/**
		 * 测试样式设置
		 */
		public function testSetStyle():void 
		{
			assertFalse(instance.hasStyle("color"));
			
			instance.setStyle("color", "#FFFFFF");
			assertEquals(instance.getStyle("color"), "#FFFFFF");
			assertTrue(instance.hasStyle("color"));
			
			instance.setStyle("color", null);
			assertNull(instance.getStyle("color"));
			assertFalse(instance.hasStyle("color"));
			
			instance.unsetStyle("color");
			assertNull(instance.getStyle("color"));
			assertFalse(instance.hasStyle("color"));
			
			instance.setStyle(null, '---');
			assertNull(instance.getStyle(null));
			
			instance.setStyles( { 
				'name': 'qhwa',
				'name.state1': 'user',
				'age': 17,
				'sex': 'male',
				'sex.state1' : 'female'
			} );
			instance.unsetStyleInAllStates('sex');
			assertFalse(instance.hasStyle("sex"));
			assertEquals(instance.getStyle('name'), 'qhwa');
			assertSame(instance.getStyle('age'), '17');
			assertNull(instance.getStyle('sex'));
			assertNull(instance.getStyle('sex.state1'));
			assertFalse(instance.hasStyle("sex.state1"));
			assertFalse(instance.hasStyle("sex"));
			
			instance.state = 'state1';
			assertEquals('user', instance.getStyle('name'));
			assertNull(instance.getStyle('sex'));
			assertEquals('17', instance.getStyle('age'));
			assertNull(instance.getStyle(null));
			assertNull(instance.getStyle('not-exisit'));
            
            instance.setStyle('newStyle.state1', 'value');
            assertTrue(instance.hasStyle('newStyle'));
            
            instance.state = 'state2';
            assertFalse(instance.hasStyle('newStyle'));
            assertTrue(instance.hasStyle('newStyle.state1'));
            
            //清除
            instance.unsetStyle('newStyle');
            instance.state = 'state1';
            assertTrue(instance.hasStyle('newStyle'));
			
		}
		
		/**
		 * 测试状态的获取和设置功能
		 */
		public function testState():void
		{
			instance.state = 'aa';
			assertEquals("new state", instance.state, 'aa' );
			instance.state = null;
			assertNotNull("ignore null", instance.state);
			
			var stateHandler:SimplePerformer = SimplePerformer.instance;
			instance.skin.performer = stateHandler;
			assertEquals(instance.skin.performer, stateHandler);
			
		}
		
		/**
		 * 测试enabled属性的获取和设置
		 */
		public function testEnable():void
		{
			assertTrue(instance.enabled);
			
			instance.enabled = false;
			assertFalse(instance.enabled);
			
			instance.enabled = true;
			assertTrue(instance.enabled);
		}
		
		/**
		 * 测试状态输出是否正常
		 */
		public function testPrintState():void
		{
			instance.skin.statePrinter = new TestPrinter();
			instance.state = 'state1';
			instance.setStyle('alpha', '0.5');
			var sp:Sprite = new Sprite();
			
			instance.printState(null, sp);
			assertEquals(sp.name, 'state10.5');
			
			instance.state = 'state2';
			instance.setStyle('alpha', '0.8');
			instance.printState(null, sp);
			assertEquals(sp.name, 'state20.8');
		}
	}
}

import bee.abstract.CComponent;
import bee.abstract.IStatesHost;
import bee.printers.IStatePrinter;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

class TestPrinter implements IStatePrinter
{
	public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
	{
		if (context) {
			context.name = state + CComponent(host).getStyle('alpha');
		}
	}
}
