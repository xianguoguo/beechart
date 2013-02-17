package bee.chart.elements.scalerect 
{
	import bee.chart.abstract.ChartElement;
	import bee.chart.abstract.ChartElementView;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.printers.IStatePrinter;
    import flash.geom.Rectangle;
	
	/**
    * ...
    * @author jianping.shenjp
    */
    public class ColorRectView extends ChartElementView 
    {
        static public var minHeight:Number = 4;
        
        static public var defaultStatePrinter:IStatePrinter = new ColorRectSimplePrinter;
        static public var defaultPerformer:IPerformer = SimplePerformer.instance;
        
        public function ColorRectView(host:ChartElement) 
        {
            super(host);
            
            skin.statePrinter = defaultStatePrinter;
            skin.performer = defaultPerformer;
        }
        
        public function get rectHeight():Number
        {
            return Math.max(minHeight, ColorRectData(dataModel).height);
        }
        
        public function get rectWidth():Number
        {
            return Math.max(ColorRectData(dataModel).width, 10)
        }
        
        public function getLabelOffsetForBelow():Number
        {
            var bounds:Rectangle = getBounds(this);
            return Math.max(0, bounds.bottom - rectHeight);
        }
        
        public function getLabelOffsetForAbove():Number
        {
            var bounds:Rectangle = getBounds(this);
            return Math.max(0, -bounds.top);
        }
        
        override protected function get defaultStyles():Object 
        {
            return { 
                lineWidth   : 20,
                linePadding : 4,
                borderThickness : 0,
                borderColor     : '#FFFFFF',
                borderAlpha     : 1
            };
        }
    }

}