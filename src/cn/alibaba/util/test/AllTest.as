package cn.alibaba.util.test 
{
	import asunit.textui.TestRunner;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class AllTest extends TestRunner 
    {
        
        public function AllTest() 
        {
            doRun( new NumberUtilTest() );
        }
        
    }

}