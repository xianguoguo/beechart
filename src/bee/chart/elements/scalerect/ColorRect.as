package bee.chart.elements.scalerect 
{
	import bee.chart.abstract.ChartElement;
    import bee.chart.elements.pie.PieSliceData;
	
	/**
    * ...
    * @author jianping.shenjp
    */
    public class ColorRect extends ChartElement 
    {
        
        public function ColorRect() 
        {
            super();
			setModel(new ColorRectData());
            setView(new ColorRectView(this));
            mouseChildren = false;
        }
        
        override public function get height():Number
        {
            return __data.height;
        }
        
        public function get viewHeight():Number
        {
            return view.height;
        }
        
        public function get viewRectHeight():Number
        {
            return __view.rectHeight;
        }
        
        public function getLabelOffsetForBelow():Number
        {
            return __view.getLabelOffsetForBelow();
        }
        
        public function getLabelOffsetForAbove():Number
        {
            return __view.getLabelOffsetForAbove();
        }
        
        private function get __view():ColorRectView
        {
            return view as ColorRectView;
        }
        
        private function get __data():ColorRectData
        {
            return model as ColorRectData;
        }
    }

}