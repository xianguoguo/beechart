package cn.alibaba.util.test 
{
	import asunit.framework.TestCase;
    import cn.alibaba.util.NumberUtil;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class NumberUtil_ByteStringTest extends TestCase 
    {
        
        public function NumberUtil_ByteStringTest(testMethod:String = null) 
        {
            super(testMethod);
        }
        
        public function testZero():void
        {
            assertEquals( '0B', NumberUtil.bytes2string(0) );
        }
        
        public function testSmallThan1024():void
        {
            assertEquals( '1B', NumberUtil.bytes2string(1) );
            assertEquals( '1023B', NumberUtil.bytes2string(1023) );
        }
        
        public function testKB():void
        {
            assertEquals( '1.1KB', NumberUtil.bytes2string(1.1*1024) );
        }
        
        public function testMB():void
        {
            assertEquals( '1.1MB', NumberUtil.bytes2string(1.1*1024*1024) );
        }
        
        public function testGB():void
        {
            assertEquals( '1.1GB', NumberUtil.bytes2string(1.1*1024*1024*1024) );
        }
        
        public function testTB():void
        {
            assertEquals( '5.2TB', NumberUtil.bytes2string(5.2*1024*1024*1024*1024) );
        }
        
    }

}