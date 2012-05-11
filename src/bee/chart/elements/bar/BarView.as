package bee.chart.elements.bar 
{
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartElementView;
    import bee.performers.IPerformer;
    import bee.printers.IStatePrinter;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarView extends ChartElementView 
    {
        
        static public var defaultStatePrinter:IStatePrinter = new BarSimplePrinter();
        static public var defaultPerformer:IPerformer = new BarEnterAnimator();
        
        public function BarView(host:ChartElement) 
        {
            super(host);
            skin.statePrinter = defaultStatePrinter;
            skin.performer = defaultPerformer;
        }
        
        public function get horizontal():Boolean 
        {
            return (dataModel as BarModel).horizontal;
        }
        
        override protected function get defaultStyles():Object { 
            return {
                'color'         : '#FF7300',
                'thickness'     : 10,
                'dropShadow'    : 'light',
                'borderAlpha'   : 1,
                'borderColor'   : '#FFFFFF'
            };
        }
    }

}