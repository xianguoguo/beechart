package bee.test 
{
	import asunit.errors.AssertionFailedError;
	import asunit.framework.Test;
	import asunit.framework.TestListener;
	
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class ResultPrinter extends asunit.textui.ResultPrinter implements TestListener 
	{
		
		public function ResultPrinter(showTrace:Boolean=false) 
		{
			super(showTrace);
		}
		
		/* INTERFACE asunit.framework.TestListener */
		
		public function run(test:Test):void
		{
			
		}
		
		public function startTest(test:Test):void
		{
			
		}
		
		public function addFailure(test:Test, t:AssertionFailedError):void
		{
			
		}
		
		public function addError(test:Test, t:Error):void
		{
			
		}
		
		public function startTestMethod(test:Test, methodName:String):void
		{
			
		}
		
		public function endTestMethod(test:Test, methodName:String):void
		{
			
		}
		
		public function endTest(test:Test):void
		{
			
		}
		
	}

}