package bee.chart.test 
{
    import asunit.framework.TestCase;
    import asunit.textui.TestRunner;
    import flash.display.Sprite;
    import flash.events.Event;
	/**
    * ...
    * @author hua.qiuh
    */
    public class GroupTest extends TestRunner
    {
        
        static public function getTestCase():TestCase
        {
            return new GroupTestCase("testStatics, testAddItem, testGetItem, testFilter");
        }
        
        public function GroupTest() 
        {
            doRun(getTestCase());
        }
        
    }

}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test Suits

import asunit.framework.TestCase;
import bee.chart.abstract.Group;

class GroupTestCase extends TestCase
{
    public function GroupTestCase(testMethods:String = null)
    {
        super(testMethods);
    }
    
    override protected function setUp():void 
    {
    }
    
    override protected function tearDown():void 
    {
        Group.disposeAll();
    }
    
    public function testStatics():void
    {
        assertNull(Group.getGroup(null));
        assertNull(Group.getGroup('anygroup'));
        assertEquals(0, Group.all.length);
        
        var grp:Group = Group.create("myGroup");
        //test Goup.create
        assertSame(grp, Group.getGroup("myGroup"));
        assertNotSame(grp, Group.getGroup("my"));
        assertEquals(0, Group.all.indexOf(grp));
        
        grp = Group.create("yellow");
        assertEquals("yellow", grp.name);
        assertEquals(grp, Group.all[1]);
        assertEquals("myGroup", Group.all[0].name);
        
        Group.create("red");
        assertEquals(3, Group.all.length);
        Group.disposeGroup("red");
        assertEquals(2, Group.all.length);
        
        grp.dispose();
        assertEquals(1, Group.all.length);
        assertEquals("myGroup", Group.all[0].name);
        
        Group.disposeAll();
        assertEquals(0, Group.all.length);
        assertNull(Group.getGroup("yellow"));
        assertNull(Group.getGroup("myGroup"));
        
    }
    
    public function testFilter():void
    {
        var colors:Group = Group.create("colors");
        colors.itemType = "Color";
        
        var girls:Group = Group.create("girls");
        var boys:Group = Group.create("boys");
        
        assertEquals(colors, Group.filter("Color")[0]);
        assertEquals(girls, Group.filter(null)[0]);
        assertEquals(boys, Group.filter(null)[1]);
    }
    
    public function testAddItem():void
    {
        var students:Group = Group.create("students");
        var children:Group = Group.create("children");
        assertEquals(0, students.count);
        assertEquals(0, children.count);
        
        var john:Object = { name: 'John' };
        var rucy:Object = { name: 'rucy', age:10 };
        students.addItem( john );
        students.addItem( rucy );
        children.addItem( rucy );
        
        assertEquals(2, students.count);
        assertEquals(1, children.count);
        assertTrue(students.contains(john));
        assertTrue(students.contains(rucy));
        assertFalse(children.contains(john));
        assertTrue(children.contains(rucy));
        
        students.clear();
        assertEquals(0, students.count);
        assertFalse(students.contains(john));
        assertFalse(students.contains(rucy));
        assertTrue(children.contains(rucy));
        
        assertFalse(students.addItemAt(null, 0));
        assertEquals(0, students.count);
        assertTrue(students.addItem(rucy));
        assertFalse(students.addItem(rucy));
        assertFalse(students.addItemAt(rucy, 0));
        assertTrue(students.addItemAt(john, 2));
        assertEquals(2, students.count);
        
        assertTrue(Group.isItemInGroup( john, "students" ));
        assertFalse(Group.isItemInGroup( john, "children" ));
    }
    
    public function testGetItem():void
    {
        var colors:Group = Group.create("colors");
        colors.addItem("red");
        colors.addItem("green");
        colors.addItem("blue");
        colors.addItem(0xFF7300);
        assertEquals("green", colors.getItemAt(1));
        assertNull(colors.getItemAt(10));
        
        colors.removeItem("green");
        assertEquals("blue", colors.getItemAt(1));
    }
}












