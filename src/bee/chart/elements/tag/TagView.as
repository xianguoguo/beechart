package bee.chart.elements.tag 
{
	import bee.chart.abstract.ChartElement;
	import bee.chart.abstract.ChartElementView;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class TagView extends ChartElementView 
    {
        
        public function TagView(host:ChartElement) 
        {
            super(host);
			
            skin.statePrinter = new TagSimplePrinter();
        }
        
    }

}