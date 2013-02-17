package bee.test 
{
    import asunit.framework.TestCase;
    import bee.abstract.CComponent;
    import bee.abstract.Skin;
    import bee.performers.SimplePerformer;
    import bee.printers.NullPrinter;
	/**
    * skin的设置测试
    * @author hua.qiuh
    */
    public class YIDSkinTest extends TestCase
    {
        
        private var _host:CComponent;
        private var _skin:Skin;
        
        public function YIDSkinTest(testMethods:String) 
        {
            super(testMethods);
        }
        
        override protected function setUp():void 
        {
            _host = new CComponent();
            _skin = _host.skin;
        }
        
        override protected function tearDown():void 
        {
            _host.dispose();
            _skin = null;
        }
        
        /**
        * 测试printer设置功能是否正常
        */
        public function testSetPrinter():void
        {
            //默认不做任何处理
            assertTrue( _skin.statePrinter is NullPrinter);
            
            var printer:TestPrinter = new TestPrinter();
            _skin.statePrinter = printer;
            assertEquals(printer, _skin.statePrinter);
            
            _host.state = 'AAA';
            assertTrue( /renderState "AAA"/.test(printer.output) );
            
            _host.state = 'BBB';
            assertTrue( /renderState "BBB"/.test(printer.output) );
        }
        
        /**
        * 测试performer功能是否正常
        */
        public function testSetPerformer():void
        {
            //默认不做转换，直接输出状态
            assertTrue( _skin.performer is SimplePerformer );
            
            var printer:TestPrinter = new TestPrinter();
            _skin.statePrinter = printer;
            var pfm:TestPerformer = new TestPerformer();
            _skin.performer = pfm;
            assertTrue(pfm, _skin.performer);
            
            _host.state = 'AAA';
            assertEquals( 'perform "null" to "AAA"', pfm.output );
            assertEquals( 'renderState "AAA"', printer.output );
            
            _host.state = 'BBB';
            assertEquals( 'perform "AAA" to "BBB"', pfm.output );
            assertEquals( 'renderState "BBB"', printer.output );
        }
        
    }

}
import bee.abstract.IStatesHost;
import bee.performers.IPerformer;
import bee.printers.IStatePrinter;
import flash.display.DisplayObjectContainer;

class TestPrinter implements IStatePrinter
{

    public var output:String = "";
    
    public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
    {
        output = 'renderState "' + state + '"';
    }
    
}

class TestPerformer implements IPerformer 
{

    public var output:String = "";
    
    public function performTransition(host:IStatesHost, fromState:String, toState:String):void
    {
        output = 'perform "' + fromState + '" to "' + toState +'"';
        host.printState(toState);
    }
    
}











