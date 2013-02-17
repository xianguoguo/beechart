package bee.chart.test 
{
    import asunit.framework.TestCase;
    import asunit.textui.TestRunner;
	/**
    * ...
    * @author hua.qiuh
    */
    public class CSSTest extends TestRunner
    {
        
        static public function getTestCase():TestCase
        {
            return new CSSTestCase("testSpace, testChartCSS");
        }
        
        public function CSSTest() 
        {
            doRun( getTestCase() );
        }
        
    }

}
import asunit.framework.TestCase;
import bee.util.YIDStyleSheet;
import flash.text.StyleSheet;

class CSSTestCase extends TestCase
{
    
    private var _sheet:StyleSheet;
    
    public function CSSTestCase(methods:String = null) {
        super(methods);
    }
    
    override protected function setUp():void 
    {
        _sheet = new YIDStyleSheet();
    }
    
    override protected function tearDown():void 
    {
        _sheet = null;
    }
    
    public function testPerformance():void
    {
        var src:String = "";
        var itemCount:uint = 500;
        var styleCount:uint;
        while (itemCount--) {
            styleCount = 500;
            src = src.concat('line item'.concat(itemCount).concat(' {\n\n'));
            while (styleCount--) {
                src = src.concat('style'.concat(styleCount).concat(' : value').concat(styleCount));
            }
            src = src.concat('}\n\n');
        }
        _sheet.parseCSS(src);
    }
    
    public function testSpace():void
    {
        _sheet.parseCSS('line { color   : green; } \n\n'
                        + 'line dot { color : blue; }');
                        
        assertEquals('green', _sheet.getStyle('line').color);
        assertEquals('blue', _sheet.getStyle('line dot').color);
        
        _sheet.setStyle('button label', { color: 'red' } );
        
        _sheet.parseCSS('line dot { color\n\t: red\n\n; }' ); //可以忽略回车
        _sheet.parseCSS('line dot 2 { color: red; }' );
        _sheet.parseCSS('line dot 2 { color: blue; } /** 改成蓝色的 **/' );
        _sheet.parseCSS('line dot 3 { color: red ; } \n\n line dot 4 { color.hl:blue !important; }' ); //多行
        _sheet.parseCSS('/* line dot 5 { color: red; } */' ); //注释应该不起作用
        _sheet.parseCSS('/*line dot 6 { color: red; }*/' ); //注释应该不起作用 
        //换行，第一行缺少分号
        _sheet.parseCSS('line dot 7 { color: red \n\n size:inherit|size ; /*换行，第一行缺少分号*/}' ); 
        _sheet.parseCSS('chart { paddingTop:20; } legend { } legend label { color: red; }');
        
        assertEqualsArraysIgnoringOrder(
            ['line', 'button label', 'line dot', 'line dot 2', 'line dot 3', 'line dot 4', 'line dot 7', 'legend label', 'chart'],
            _sheet.styleNames
        );
        
        
        assertEquals('green', _sheet.getStyle('line').color);
        assertEquals('red', _sheet.getStyle('button label').color);
        assertEquals('red', _sheet.getStyle('line dot').color);
        assertEquals('red', _sheet.getStyle('line dot').color);
        assertEquals('blue', _sheet.getStyle('line dot 2').color);
        assertEquals('red', _sheet.getStyle('line dot 3').color);
        assertEquals('blue !important', _sheet.getStyle('line dot 4')['color.hl']);
        assertNull(_sheet.getStyle('line dot 5').color);
        assertNull(_sheet.getStyle('line dot 6').color);
        assertEquals('red', _sheet.getStyle('line dot 7').color);
        assertEquals('inherit|size', _sheet.getStyle('line dot 7').size);
        assertEquals('red', _sheet.getStyle('legend label').color);
        assertEquals('20', _sheet.getStyle('chart').paddingTop);
    }
    
    public function testChartCSS():void
    {
        var css:String = "chart{\n\n\n\
labelPosition:outside;\n\n\n\
chartWidth:500;\n\n\n\
chartHeight:250;\n\n\n\
mouseAnimate:true;\n\n\n\
animate:counter_clockwise;\n\n\n\
}\n\n\n\
legend{\n\
position: top;\n\
align         : right;\n\
paddingRight   : 0;\n\
}\n\
\n\
canvas{\n\
gridColor         : #29A5F7;\n\
gridThickness     : 1;\n\
gridAlpha         : .5;\n\
}\n\
\n\
line{\n\
thickness         : 3;\n\
alpha             : 0.3;\n\
thickness.active  : 5;\n\
lineMethod        : line;\n\
fillAlpha         : 0.5;\n\
dropShadow        : none;\n\
}\n\
\n\
line dot{\n\
color : inherit#color;\n\
}\n\
\n\
yAxis{\n\
tickColor     : #666666;\n\
lineThickness : null;\n\
tickThickness : null;\n\
}\n\
\n\
xAxis{\n\
lineThickness : 2;\n\
tickThickness : null;\n\
labelDataType : date;\n\
labelFormat   : '%m-%d';\n\
}\n\
\n\
tooltip{\n\
enabled:true;\n\
}";
        _sheet.parseCSS(css);
        assertEquals('0.3', _sheet.getStyle('line').alpha);
    }
}










