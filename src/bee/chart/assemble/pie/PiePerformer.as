package bee.chart.assemble.pie
{
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.ChartElement;
    import bee.chart.elements.pie.PieLine;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSliceCanvas;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.pie.PieSliceView;
    import bee.controls.label.Label;
    import bee.performers.IPerformer;
    
    public class PiePerformer implements IPerformer
    {
        //最终执行的缓动效果函数
        protected var _performerFunction:Function;
        
        public function set performerFunction(value:Function):void
        {
            if (value != null)
            {
                _performerFunction = value;
            }
        }
        
        public function PiePerformer($performerFunction:Function)
        {
            if ($performerFunction != null)
            {
                _performerFunction = $performerFunction;
            }
        }
        
        public function performTransition(host:IStatesHost, fromState:String, toState:String):void
        {
            var viewer:PieChartViewer = host as PieChartViewer;
            var vec:Vector.<ChartElement>;
            var pieSlice:PieSlice;
            var data:PieSliceData;
            var view:PieSliceView;
            var pieSliceCanvas:PieSliceCanvas;
            var pieSliceLabel:Label;
            var pieSliceLine:PieLine;
            var time:int = 0; //执行的次数
            if (viewer)
            {
				viewer.printState(toState);
                if (_performerFunction == null)
                {
                    return;
                }
                if (toState == PieStates.NORMAL)
                {
                    vec = viewer.elements;
                    
                    for each (var el:ChartElement in vec)
                    {
                        pieSlice = el as PieSlice;
                        if (pieSlice)
                        {
                            view = pieSlice.view as PieSliceView;
                            data = pieSlice.model as PieSliceData;
                            pieSliceCanvas = view.canvas;
                            pieSliceLabel = view.label;
                            pieSliceLine = view.line;
                            _performerFunction(pieSliceCanvas, pieSliceLabel, pieSliceLine, data, time);
                            time++;
							pieSliceCanvas = null;
							pieSliceLabel = null;
							pieSliceLine = null;
                        }
                    }
                }
            }
        }
    }
}