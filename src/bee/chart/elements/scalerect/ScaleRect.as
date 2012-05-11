package bee.chart.elements.scalerect 
{
	import bee.chart.abstract.ChartElement;
	
	/**
    * ...
    * @author jianping.shenjp
    */
    public class ScaleRect extends ChartElement 
    {
        public var enableMouseTrack:Boolean = false;
        public var enableTooltip:Boolean = false;
        
        public function ScaleRect() 
        {
            super();
            setModel(new ScaleRectData());
			setView( new ScaleRectView(this) );
        }
    }

}