package bee.chart.elements.line 
{
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.util.CartesianUtil;
    import bee.chart.util.LineUtil;
    import bee.chart.util.StringFormater;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import bee.printers.PrinterDecorator;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import com.greensock.TweenLite;
    
	
	/**
    * 这个printer的作用是在线条上显示文字
    * @author hua.qiuh
    */
    public class LineWithNumberPrinter extends PrinterDecorator
    {
        private var host:IStatesHost;
        private var state:String;
        private var context:DisplayObjectContainer;
        
        public function LineWithNumberPrinter(basePrinter:IStatePrinter = null) 
        {
            super(basePrinter);
        }
        
        /**
        * 渲染状态
        * @param	host
        * @param	state
        * @param	context
        */
        override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            this.context = context;
            this.state = state;
            this.host = host;
            
            drawLine();
            
            if (shouldDrawLabel()) {
                drawLabel();
            }
            
            this.context = null;
            this.state = null;
            this.host = null;
        }
        
        private function shouldDrawLabel():Boolean
        {
            return state === 'normal' || state === 'active';
        }
        
        private function drawLine():void
        {
            super.renderState(host, state, context);
        }
        
        private function drawLabel():void
        {
            var labels:Vector.<Label> = new Vector.<Label>();
            var view:LineView = host as LineView;
            var line:Line     = view.host as Line;
            if (view && view.chart && line) {
                var lineData:LineData = view.dataModel as LineData;
                var chart:Chart = view.chart;
                var pt:Point;
                var dotPositions:Vector.<Point> = view.dotPositions || lineData.dotPositions;
                var values:Vector.<Number>  = lineData.values;
                var numValues:int = values.length;
                var numloop:int = dotPositions.length;
                if (numValues != numloop)
                {
                    return;
                }
				if(!chart || !chart.chartModel)
				{
					return;
				}
                var value:Number;
                var label:Label;
                var isMinValueInCol:Boolean;
                var labelStyle:Object = StyleUtil.inheritStyle(
                    view.styleSheet.getStyle('dot label'),
                    view
                );
                for (var i:int = 0; i < numloop; i++) 
                {
                    pt = dotPositions[i];
                    if (pt)
                    {
                        value = values[i];
                        isMinValueInCol = chart.data.visibleSetCount > 1 && chart.data.getMinValueInCol(i) == value;
                        label = new Label(StringFormater.format(value, null, lineData.valueType || 'number'));
                        label.setStyles(labelStyle);
						context.addChild(label);
						label.updateNow();
                        label.x = pt.x - label.width / 2;
                        label.y = pt.y - label.height / 2 + 16 * (isMinValueInCol?1: -1);
                        labels.push(label);
                    }
                }
                if (CartesianUtil.needFixForLine(view.chart))
                {
                    fixLabelPos(labels);
                }
            }
            labels.length = 0;
            labels = null;
        }
        
        private function fixLabelPos(labels:Vector.<Label>):void
        {
            var chart:Chart = (host as LineView).chart;
            var chartW:Number = chart.chartWidth;
            var label:Label = labels[0];
            if (label)
            {
                label.x = 0;
            }
            label = labels[labels.length - 1];
            if (label)
            {
                label.x = chartW-label.contentWidth;
            }
        }
    }
}