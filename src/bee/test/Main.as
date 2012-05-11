package bee.test 
{
	import asunit.textui.TestRunner;
	import cn.alibaba.util.TheStage;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class Main extends Sprite
	{
		
		public function Main() 
		{
			
			TheStage.stage = stage;
			
			var tester:TestRunner = new TestRunner();
			stage.addChild(tester);
			
			tester.start(YIDAllTest);
		}
		
	}

}