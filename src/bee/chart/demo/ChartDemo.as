package bee.chart.demo 
{
	import flash.display.Sprite;
    import flash.events.Event;
    import net.hires.debug.Stats;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class ChartDemo extends Sprite 
    {
        
        public function ChartDemo() 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            stage.align = 'TL';
            stage.scaleMode = 'noScale';
            
            stage.addChild( new Stats() );
            
            initChart();
        }
        
        protected function initChart():void
        {
            
        }
        
    }

}