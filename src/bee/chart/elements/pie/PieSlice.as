package bee.chart.elements.pie 
{
    import bee.chart.abstract.ChartElement;
    import bee.chart.assemble.pie.PieChartViewer;
    import bee.controls.label.Label;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieSlice extends ChartElement 
    {
        public function PieSlice() 
        {
            setModel(new PieSliceData());
            setView(new PieSliceView(this));
            //使得对象的子项是不支持鼠标，鼠标点击事件分发着为PieSlice.
            this.mouseChildren = false;
        }
        
        /**
        * 对Slice的标签位置（半径）进行调整
        * @param	dr
        */
        public function modifyLabelRadiusBy(dr:Number):void
        {
            __data.labelRadiusAdj += dr;
            __view.updateLabelAndLinePos();
        }
        
        public function getContentCenter(coord:DisplayObject=null):Point
        {
            return __view.getContentCenter(coord);
        }
        
        /**
         * 获得对应的label
         * */
        public function get label():Label
        {
            return __view.label;
        }
        
        public function get index():int { return __data.index; }
        public function set index(value:int):void 
        {
            __data.index = value;
        }
        
        public function get displayIndex():int { return __data.displayIndex; }
        public function set displayIndex(value:int):void 
        {
            __data.displayIndex = value;
        }
        
        private function get __data():PieSliceData
        {
            return _model as PieSliceData;
        }
        
        private function get __view():PieSliceView
        {
            return _view as PieSliceView;
        }
        
        public function createPieSlice(viewer:PieChartViewer):PieSlice 
        {
            var pieSlice:PieSlice = viewer.requestElement(PieSlice) as PieSlice;
            pieSlice.name = PieChartViewer.SLICE + index;
            return pieSlice;
        }
        
        override public function toString():String 
        {
            return "[PieSlice#" + index + " " + __data.name + "]";
        }

    }

}