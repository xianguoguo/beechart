package bee.chart.test 
{
    import asunit.framework.TestCase;
	import asunit.textui.TestRunner;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class ColorGeneraterTest extends TestRunner 
    {
        
        static public function getTestCase():TestCase
        {
            return new ColorGenTest("testZeroLength, testFewBaseColors");
        }
        
        public function ColorGeneraterTest() 
        {
            doRun( getTestCase() );
        }
        
    }

}
import asunit.framework.TestCase;
import bee.chart.util.AutoColorUtil;
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Matrix;

class ColorGenTest extends TestCase
{
    public function ColorGenTest(methods:String)
    {
        super(methods);
    }
    
    override protected function setUp():void 
    {
        AutoColorUtil.reset();
    }
    
    public function testZeroLength():void
    {
        assertEquals(0, AutoColorUtil.getColor(0));
        assertEquals(0, AutoColorUtil.getColor(1));
        assertEquals(0, AutoColorUtil.getColor(2));
        assertEquals(0, AutoColorUtil.getColor(3));
    }
    
    public function testFewBaseColors():void
    {
        AutoColorUtil.baseColors = new <uint>[0xFF0000, 0x00FF00, 0x0000FF];
        AutoColorUtil.generaterColorNum = 3;
        
        assertEquals(0xFF0000, AutoColorUtil.getColor(0));
        assertEquals(0x00FF00, AutoColorUtil.getColor(1));
        assertEquals(0x0000FF, AutoColorUtil.getColor(2));
        
        var genCnt:uint = 100;
        AutoColorUtil.generaterColorNum = genCnt;
        for (var i:int = 0; i < genCnt; i++) {
            var color:uint = AutoColorUtil.getColor(i);
            drawRect(color, i);
        }
        
        function drawRect(color:uint, idx:uint):void
        {
            const WIDTH:uint = 1;
            const HEIGHT:uint = 100;
            var sp:Shape = new Shape();
            var g:Graphics = sp.graphics;
            g.beginFill(color);
            g.drawRect(0, 0, WIDTH, HEIGHT);
            g.endFill();
            sp.x = WIDTH * idx+200;
            sp.y = 200;
            context.addChild(sp);
        }
    }
}








