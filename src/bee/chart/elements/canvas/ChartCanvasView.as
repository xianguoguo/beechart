package bee.chart.elements.canvas 
{
    import bee.chart.abstract.ChartElementView;
    import flash.display.DisplayObjectContainer;
	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartCanvasView extends ChartElementView
    {
        static public const BG_SHAPE_NAME:String = 'CanvasBg';
        static public const ALTER_BG_SHAPE_NAME:String = 'alter_bg';
        static public const BORDER_SHAPE_NAME:String = 'CanvasBorder';
        
        public function ChartCanvasView(host:ChartCanvas) 
        {
            super(host);
            skin.statePrinter = new ChartCanvasSimplePrinter();
        }
        
        override protected function get defaultStyles():Object { 
            return {
                'backgroundColor'   : '#FFFFFF',
                'backgroundAlpha'   : '1',
                'width'             : '0',
                'height'            : '0',
                'borderAlpha'       : '1',
                'borderColor'       : '#FFFFFF'
            }; 
        }
    }

}