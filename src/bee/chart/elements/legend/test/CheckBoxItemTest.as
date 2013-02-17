package bee.chart.elements.legend.test 
{
    import assets.CheckBox;
    import bee.chart.elements.legend.CheckBoxItem;
	import flash.display.Sprite;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class CheckBoxItemTest extends Sprite 
    {
        
        public function CheckBoxItemTest() 
        {
            var cb:CheckBoxItem = new CheckBoxItem(0xFF0000, true);
            addChild( cb );
            
            cb.x = cb.y = 250;
        }
        
    }

}