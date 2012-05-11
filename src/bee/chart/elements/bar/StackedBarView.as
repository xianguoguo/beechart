package bee.chart.elements.bar 
{
	import bee.chart.abstract.ChartElement;
	import bee.chart.abstract.ChartElementView;
    import bee.printers.IStatePrinter;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class StackedBarView extends ChartElementView 
    {
        
        static public var defaultStatePrinter:IStatePrinter =  new StackedBarSimplePrinter();
        
        public function StackedBarView(host:ChartElement) 
        {
            super(host);
            skin.statePrinter = defaultStatePrinter;
        }
        
    }

}