package bee.chart.demo 
{
    import bee.chart.elements.bar.StackedBar;
    import flash.display.Sprite;
	/**
    * ...
    * @author hua.qiuh
    */
    public class StackedBarDemo extends Sprite
    {
        
        public function StackedBarDemo() 
        {
            var stack:StackedBar = new StackedBar();
            stack.x = 100;
            stack.y = 100;
            addChild(stack);
            
            var bar:bee.chart.elements.bar.Bar = new bee.chart.elements.bar.Bar();
            bar.setStyles({'length': 50});
            //bar.y = 100;
            //addChild(bar);
            stack.addBar( bar );
            
            bar = new bee.chart.elements.bar.Bar();
            //stack.addBar( bar );
            bar.setStyles( {
                'length': 50,
                'color' : '#FF0000'
            });
            //bar.y = 100;
            //addChild(bar);
            stack.addBar( bar );
        }
        
    }

}