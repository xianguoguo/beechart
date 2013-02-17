package bee.chart.elements.canvas
{
    import bee.chart.abstract.ChartElement;
    import flash.geom.Point;
    
    /**
     * ...
     * @author hua.qiuh
     */
    public class ChartCanvas extends ChartElement
    {
        
        public function ChartCanvas()
        {
            setModel(new CanvasData());
            setView(new ChartCanvasView(this));
            mouseChildren = false;
            mouseEnabled = false;
        }
        
        public function get canvasData():CanvasData
        {
            return model as CanvasData;
        }
        
        public function get secLinePoses():Vector.<Point>
        {
            return canvasData.secLinePoses;
        }
        
        public function set secLinePoses(value:Vector.<Point>):void
        {
            canvasData.secLinePoses = value;
        }
    
    }

}