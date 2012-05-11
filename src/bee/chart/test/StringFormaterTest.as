/**
 * (c) Alibaba.com All Right(s) Reserved
 */
package bee.chart.test 
{
    import asunit.framework.TestCase;
    import asunit.textui.TestRunner;
    import bee.chart.util.StringFormater;
    import flash.display.Sprite;
	/**
    * ...
    * @author hua.qiuh
    */
    public class StringFormaterTest extends TestRunner
    {
        static public function getTestCase():TestCase
        {
            return new FormatterTestCase("testNumber, testFloat, testDate");
        }
        
        public function StringFormaterTest() 
        {
            doRun( getTestCase() );
        }
        
    }

}

import asunit.framework.TestCase;
import bee.chart.util.StringFormater;
class FormatterTestCase extends TestCase
{
    public function FormatterTestCase(methods:String)
    {
        super(methods);
    }
    
    public function testNumber():void
    {
        assertEquals('1', formatNumber(1));
        assertEquals('111', formatNumber(111));
        assertEquals('1,111', formatNumber(1111));
        assertEquals('1,111', StringFormater.format('1,111', null, 'number'));
        assertEquals('111,111,111,111', formatNumber(111111111111));
        assertEquals(0, format(0, null, 'number'));
        assertEquals("", format(null));
        // date
        var now:Date = new Date();
        assertEquals(now.fullYear.toString(), format(now, '%Y'));
        format(now, '%f');
        format(now, '%F');
        format(now, '%M');
        format(now, '%T');
        format(now, '%D');
        format(now, '%Y-%m-%d %H:%M:%S');
        
        // number
        assertEquals(1, format(1.0000000001, ''));
        assertEquals(1, format(1.0000000001, '\t'));
        assertEquals(1, format(1.0000000001, ' '));
        assertEquals(1, format(1.0000000001, '*'));
        assertEquals(10, format(10.0000000001, '*'));
        assertEquals("1",format(1.0000001, '*.#3')+"");
        assertEquals("01.00",format(1.000001, '#2.#2')+"");
        assertEquals("100.000",format(100.000001, '#2.#3')+"");
        assertEquals("100", format(100, '#2.#3')+"");
    }
    
    public function testFloat():void
    {
        assertEquals('0.8567', formatNumber(0.8567));
        assertEquals('100.8567', formatNumber(100.8567));
        assertEquals('1,100.8567', formatNumber(1100.8567));
        assertEquals('2.32', formatNumber(2.3200000000000003));
    }
    
	public function testDate():void
	{
		assertEquals('星期四', format("2012-03-01", '%A', 'date'));
		assertEquals('三月', format("2012-03-01", '%B', 'date'));
		assertEquals('12', format("2012-03-01", '%y', 'date'));
		assertEquals('2012', format("2012-03-01", '%Y', 'date'));
		assertEquals('03', format("2012-03-01", '%m', 'date'));
		assertEquals('01', format("2012-03-01", '%d', 'date'));
		assertEquals('03/11/12', format("2012-03-11", '%D', 'date'));
		assertEquals('2012-03-01', format("2012-03-01", '%F', 'date'));
		assertEquals('2012年03月01日', format("2012-03-01", '%f', 'date'));
		assertEquals('14', format("2012-03-01 14:15:16", '%H', 'date'));
		assertEquals('2', format("2012-03-01 14:15:16", '%I', 'date'));
		assertEquals('14', format("2012-03-01 14:15:16", '%k', 'date'));
		assertEquals('2', format("2012-03-01 02:15:16", '%k', 'date'));
		assertEquals('12', format("2012-03-01 00:15:16", '%l', 'date'));
		assertEquals('0', format("2012-03-01 12:15:16", '%l', 'date'));
		assertEquals('15', format("2012-03-01 12:15:16", '%M', 'date'));
		assertEquals('am', format("2012-03-01 11:15:16", '%p', 'date'));
		assertEquals('pm', format("2012-03-01 12:15:16", '%p', 'date'));
		assertEquals('AM', format("2012-03-01 11:15:16", '%P', 'date'));
		assertEquals('PM', format("2012-03-01 12:15:16", '%P', 'date'));
		assertEquals('16', format("2012-03-01 12:15:16", '%S', 'date'));
		assertEquals('12:15:16', format("2012-03-01 12:15:16", '%T', 'date'));
		
		assertEquals('11-26', format("2010-11-26", '%m-%d', 'date'));
		assertEquals('01-26', format("2010-01-26", '%m-%d', 'date'));
		assertEquals('2010-01-26', format("2010-01-26", '%Y-%m-%d', 'date'));
		assertEquals('10-01-26', format("2010-01-26", '%y-%m-%d', 'date'));
		assertEquals('10-01-26', format("2010-01-26", '%y-%m-%d', 'date'));
		assertEquals('12-03-01', format("2012-03-01", '%y-%m-%d', 'date'));
		
		assertEquals('Jan', format('Jan'));
		assertEquals('10,101', format(10101));
	}
	
    private function formatNumber(n:Number):String
    {
        return StringFormater.format(n, null, 'number');
    }
    private function format(src:Object, formater:String=null, type:String=null):String
    {
        return StringFormater.format(src, formater, type);
    }
}