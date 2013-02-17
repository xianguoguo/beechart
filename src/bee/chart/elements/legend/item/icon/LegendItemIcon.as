package bee.chart.elements.legend.item.icon 
{
    import bee.abstract.CComponent;
    import bee.chart.elements.legend.item.LegendItem;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.printers.IStatePrinter;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class LegendItemIcon extends CComponent 
    {
        static public var defaultStatePrinter:IStatePrinter = new LegendItemIconSimplePrinter;
        static public var defaultPerformer:IPerformer = SimplePerformer.instance;
        
        private var _hostItem:LegendItem;
        
        public function LegendItemIcon(hostItem:LegendItem) 
        {
            _hostItem = hostItem;
            skin.statePrinter = defaultStatePrinter;
            skin.performer = defaultPerformer;
        }
        
    }

}