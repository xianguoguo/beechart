package bee.test 
{
	import asunit.framework.TestSuite;
	import cn.alibaba.util.TheStage;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class YIDAllTest extends TestSuite
	{
		
		public function YIDAllTest() 
		{
			super();
			
			var cmpTestMethods:String = [
				"testInstantiated",
				"testSetStyle",
				"testState",
				"testEnable",
				"testPrintState"
			].join(",");
			var cmpTest:ComponentTest = new ComponentTest(cmpTestMethods);
			cmpTest.setContext( TheStage.stage );
			addTest( cmpTest );
			
            
			var btnTestMethods:String = [
				"testSimpleBtn",
				"testSimpleBtnStyle",
				"testImgBtn",
				"testTransition",
				"testBreathTransition",
				"testIconButton",
				"testIconAndLabelBtn",
				"testExplodeTransition",
				"testRotateTransition",
				"testBlue",
				"testLabelBtn",
				"testSimpleRotate"
			].join(",");
			var btnTest:YIDButtonTest = new YIDButtonTest(btnTestMethods);
			btnTest.setContext( TheStage.stage );
			addTest( btnTest );
            
            var skinTestMethods:String = [
                "testSetPrinter",
                "testSetPerformer"
            ].join(",");
            var skinTest:YIDSkinTest = new YIDSkinTest(skinTestMethods);
            addTest( skinTest );
            
			/*
			var btnDcrtTestMethods:String = Vector.<String>([
				"testBackground"
			]).join(",");
			var btnDcrtTest:YIDButtonDecoratorTest = new YIDButtonDecoratorTest(btnDcrtTestMethods);
			btnDcrtTest.setContext( TheStage.stage );
			addTest( btnDcrtTest );
			*/
		}
		
	}

}