package bee.chart.assemble
{
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.CartesianChartViewer;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.elements.axis.Axis;
    import bee.chart.elements.axis.AxisDirection;
    import bee.chart.elements.axis.AxisView;
    import bee.chart.elements.axis.AxisWithSmoothPrinter;
    import bee.chart.elements.axis.XAxis;
    import bee.chart.elements.canvas.AlternatingBgPrinter;
    import bee.chart.elements.canvas.ChartCanvas;
    import bee.chart.elements.canvas.ChartCanvasWithGridPrinter;
    import bee.chart.elements.canvas.ChartCanvasWithSmoothPrinter;
    import bee.chart.elements.legend.item.LegendItem;
    import bee.chart.elements.legend.item.LegendItemCheckPrinter;
    import bee.chart.elements.legend.Legend;
    import bee.chart.elements.legend.LegendAlign;
    import bee.chart.elements.legend.LegendPosition;
	import bee.chart.elements.timeline.labelmaker.LabelInfo;
	import bee.chart.elements.timeline.labelmaker.XAxisLabelInfosMaker;
    import bee.chart.util.StringFormater;
    import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /**
     * 笛卡尔直角坐标系的图表的一些通用方法
     * @author hua.qiuh
     */
    public class CartesianChartPrinter extends ChartBasicPrinter implements IStatePrinter
    {
        private var _labelInfosMaker:XAxisLabelInfosMaker;
        private var _labelInfos:Vector.<LabelInfo>;
        
        public function CartesianChartPrinter()
        {
            LegendItem.defaultStatePrinter = new LegendItemCheckPrinter();
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        override protected function renderNormalState(host:ChartViewer, context:DisplayObjectContainer):void
        {
            var viewer:CartesianChartViewer = host as CartesianChartViewer;
            if (viewer && viewer.chart)
            {
                var w:Number = viewer.chartModel.chartWidth;
                var h:Number = viewer.chartModel.chartHeight;
                
                clearContent(context);
                
                var rect:Rectangle = new Rectangle(0, -h, w, h);
                drawCanvas(viewer, w, h, context, rect);
                drawAxis(viewer, w, h, context, rect);
                
                if (viewer.chartModel.enableTooltip)
                {
                    drawTooltip(viewer, w, h, context);
                }
                
                drawLegend(viewer, w, h, context, rect);
                drawCustomElements(viewer, w, h, context, rect);
            }
        }
        
        override protected function initParamter(host:IStatesHost, context:DisplayObjectContainer):void
        {
			this._context = context;
            this._viewer = host as ChartViewer;
            super.initParamter(host, context);
            if (!_labelInfosMaker || !_viewer.isDragging)
            {
                _labelInfosMaker = new XAxisLabelInfosMaker();
                var tempXAxis:Axis = getStyledXAxis(_viewer);
				tempXAxis.name = "tempXAxis";
                _labelInfosMaker.initParamter(tempXAxis.view as AxisView, _viewer.chart);
            }
            newLabelInfos();
        }
        
        override protected function clearParamter():void
        {
            super.clearParamter();
            _labelInfos = null;
        }
        
        protected function newLabelInfos(needReCreate:Boolean = false):Vector.<LabelInfo>
        {
            if (needReCreate || (!labelInfos && _viewer.chart))
            {
                labelInfos = _labelInfosMaker.getLabelInfos();
            }
            return labelInfos;
        }
        
        /**
         * 绘制背景
         */
        protected function drawCanvas(host:CartesianChartViewer, width:Number, height:Number, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var canvas:ChartCanvas = host.requestElement(ChartCanvas) as ChartCanvas;
            canvas.name = 'canvas';
            var style:Object = host.styleSheet.getStyle('canvas');
            canvas.setStyles(style);
            canvas.setStyles(
                {
                    width: width, 
                    height: height, 
                    mode: host.horizontal ? 'horizontal' : 'normal', 
                    paddingLeft: host.getStyle('paddingLeft'), 
                    paddingRight: host.getStyle('paddingRight'), 
                    paddingTop: host.getStyle('paddingTop'), 
                    paddingBottom: host.getStyle('paddingBottom') 
                }
            );
            canvas.secLinePoses = transLinePosFromLabel();
            reSetCanvasPrinter(canvas, host.getStyle('smooth'));
            host.addElement(canvas);
			canvas.updateViewNow();
            context.addChild(canvas);
        }
        
        private function transLinePosFromLabel():Vector.<Point>
        {
            var points:Vector.<Point> = new Vector.<Point>();
            var pt:Point;
            for each (var labelInfo:LabelInfo in _labelInfos)
            {
                if (labelInfo.lineVisible)
                {
                    pt = labelInfo.pos;
                    pt.x = labelInfo.getLabelHorCenter();
                    points.push(pt);
                }
            }
            return points;
        }
        
        private function reSetCanvasPrinter(canvas:ChartCanvas, smoothstyle:String):void
        {
            var printer:IStatePrinter = canvas.skin.statePrinter;
            if (canvas.hasStyle('backgroundColor2'))
            {
                printer = new AlternatingBgPrinter(printer);
            }
            if (canvas.hasStyle('priLineThickness') || canvas.hasStyle('secLineThickness') || canvas.hasStyle('gridThickness'))
            {
                printer = new ChartCanvasWithGridPrinter(printer);
            }
            if (smoothstyle === 'true')
            {
                printer = new ChartCanvasWithSmoothPrinter(printer);
            }
            canvas.skin.statePrinter = printer;
        }
        
        /**
         * 绘制坐标轴
         */
        protected function drawAxis(host:CartesianChartViewer, width:Number, height:Number, context:DisplayObjectContainer, rect:Rectangle):void
        {
            
            if (host.getStyle('xAxisVisibility') === 'visible')
            {
                drawXAxis(host, context, rect);
            }
            
            drawYAxis(host, context, rect);
        }
        
        protected function drawYAxis(host:CartesianChartViewer, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var data:CartesianChartData = host.chartModel.data as CartesianChartData;
            var toDrawLYAxis:Boolean = host.getStyle('leftAxisVisibility') === 'visible';
            var toDrawRYAxis:Boolean = host.getStyle('rightAxisVisibility') === 'visible';
            if (toDrawLYAxis || toDrawRYAxis)
            {
                var ticks:Vector.<Number> = data.yTicks;
                var labels:Vector.<String> = new <String>[];
                if (ticks)
                {
					for each (var tick:Number in ticks) 
					{
						labels.push(StringFormater.format(tick, ''));
					}
                }
                if (toDrawLYAxis)
                {
                    drawLeftYAxis(host, labels, context, rect);
                }
                if (toDrawRYAxis)
                {
                    drawRightYAxis(host, labels, context, rect);
                }
            }
        }
        
        protected function drawXAxis(host:CartesianChartViewer, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var xAxis:XAxis = getStyledXAxis(host) as XAxis;
			xAxis.name = "XAxis";
            xAxis.length = host.chartModel.chartWidth;
			xAxis.setStyle("smooth", host.getStyle("smooth"));
            reSetAxisPrinter(xAxis, host.getStyle('smooth'));
            
            var data:CartesianChartData = host.chartModel.data as CartesianChartData;
            xAxis.labels = data.labels;
            
            xAxis.labelInfos = newLabelInfos();
            
            xAxis.mouseEnabled = false;
            host.addElement(xAxis);
            context.addChild(xAxis);
            xAxis.updateViewNow();
            host.indexAxis = xAxis;
            
            if (shouldXAxisStickToZero(xAxis, data))
            {
                var y:Number = host.chartToViewXY(0, 0).y;
                xAxis.y = y;
                if (y > -xAxis.height)
                {
                    rect.bottom += xAxis.height + y + 8;
                }
            }
            else
            {
                xAxis.y = rect.bottom;
                rect.bottom += xAxis.height + 8;
            }
        }
        
        protected function reSetAxisPrinter(axis:Axis, smoothstyle:String):void
        {
            if (smoothstyle === "true")
            {
                if (!(axis.skin.statePrinter is AxisWithSmoothPrinter))
                {
                    axis.skin.statePrinter = new AxisWithSmoothPrinter();
                }
            }
        }
        
        protected function shouldXAxisStickToZero(axis:Axis, chartData:ChartData):Boolean
        {
            return axis.getStyle('position') === 'zero' && chartData.minValue < 0;
        }
        
        protected function getStyledXAxis(host:ChartViewer):Axis
        {
            var xAxis:XAxis = host.requestElement(XAxis) as XAxis;
            StyleUtil.inheritStyleSheet(xAxis, 'xaxis', host);
            return xAxis;
        }
        
		protected function createYAxis(host:CartesianChartViewer, labels:Vector.<String>, isValueAxis:Boolean = true, direction:uint = AxisDirection.UP):Axis
		{
			var data:CartesianChartData = host.chartModel.data as CartesianChartData;
            var yAxis:Axis = host.requestElement(Axis) as Axis;
			yAxis.name = "yAxis";
			yAxis.setStyle("labelFormat",host.getStyle("valueLabelFormat"));
			yAxis.setStyle("smooth", host.getStyle("smooth"));
            reSetAxisPrinter(yAxis, host.getStyle('smooth'));
            yAxis.mouseEnabled = false;
            yAxis.direction = direction;
            yAxis.length = host.chartModel.chartHeight;
            yAxis.isValueAxis = isValueAxis;
			
			yAxis.axisData.valueType = data.valueType;
			
            host.addElement(yAxis);
            StyleUtil.inheritStyleSheet(yAxis, 'yAxis', host);
			yAxis.labels = labels;
			return yAxis;
		}
		
        protected function drawLeftYAxis(host:CartesianChartViewer, labels:Vector.<String>, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var yAxis:Axis = createYAxis(host,labels);
			context.addChild(yAxis);
            yAxis.updateViewNow();
            yAxis.x = rect.left;
            rect.left -= yAxis.width;
        }
        
        protected function drawRightYAxis(host:CartesianChartViewer, labels:Vector.<String>, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var yAxisR:Axis = createYAxis(host,labels);
			yAxisR.x = host.chartModel.chartWidth;
			context.addChild(yAxisR);
            yAxisR.updateViewNow();
            yAxisR.x = rect.right;
            rect.right += yAxisR.width;
        }
        
        /**
         * 绘制Legend
         * @param	host
         * @param	width
         * @param	height
         * @param	context
         */
        protected function drawLegend(host:CartesianChartViewer, width:Number, height:Number, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var style:Object = StyleUtil.mergeStyle({}, host.styleSheet.getStyle('legend'));
            if (!style['position'] || style['position'] == 'none')
            {
                return;
            }
            
            var legend:Legend = new Legend();
            legend.dataSets = host.chartModel.data.allSets;
            var pos:String = style['position'];
            switch (pos)
            {
                case LegendPosition.OUT_BOTTOM: 
                    style['maxWidth'] = width;
                    break;
                case LegendPosition.OUT_TOP: 
                    style['maxWidth'] = width;
                    break;
                case LegendPosition.OUT_LEFT: 
                    style['maxHeight'] = height;
                    break;
                case LegendPosition.OUT_RIGHT: 
                    style['maxHeight'] = height;
                    break;
            }
            StyleUtil.inheritStyleSheet(legend, 'legend', host);
            legend.setStyles(style);
            legend.behavior = new CartesianLegendBehavior();
            host.addElement(legend);
            context.addChild(legend);
            legend.updateViewNow();
            
            var align:String = style['align'] || LegendAlign.CENTER;
            var valign:String = style['valign'] || LegendAlign.MIDDLE;
            var x:Number = 0, y:Number = 0;
            var checkH:Boolean = false;
            var checkV:Boolean = false;
            const PADDING:uint = 0;
            
            var bound:Rectangle = legend.getBounds(legend);
            var w:Number = bound.width;
            var h:Number = bound.height;
            
            switch (pos)
            {
                case LegendPosition.INNER: 
                    checkH = checkV = true;
                    break;
                case LegendPosition.OUT_BOTTOM: 
                    checkH = true;
                    checkV = false;
                    y = rect.bottom + PADDING;
                    rect.bottom += h + PADDING;
                    break;
                case LegendPosition.OUT_TOP: 
                    checkH = true;
                    checkV = false;
                    y = rect.top - h - PADDING;
                    rect.top -= h + 1;
                    break;
                case LegendPosition.OUT_LEFT: 
                    checkH = false;
                    checkV = true;
                    x = rect.left - w - PADDING;
                    rect.left -= w + 1;
                    break;
                case LegendPosition.OUT_RIGHT: 
                    checkH = false;
                    checkV = true;
                    x = rect.right + PADDING;
                    rect.right += w + 1;
                    break;
            }
            
            if (checkH)
            {
                switch (align)
                {
                    case LegendAlign.LEFT: 
                        x = pos == LegendPosition.INNER ? PADDING : 0;
                        break;
                    case LegendAlign.RIGHT: 
                        x = width - w;
                        break;
                    case LegendAlign.CENTER: 
                    default: 
                        x = (width - w) >> 1;
                        break;
                }
            }
            
            if (checkV)
            {
                switch (valign)
                {
                    case LegendAlign.TOP: 
                        y = -height;
                        break;
                    case LegendAlign.BOTTOM: 
                        y = -h;
                        break;
                    case LegendAlign.MIDDLE: 
                    default: 
                        y = -((height - h) >> 1);
                        break;
                }
            }
            legend.x = Math.round(x - bound.left);
            legend.y = Math.round(y - bound.top);
        }
        
        protected function drawCustomElements(viewer:CartesianChartViewer, w:Number, h:Number, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var els:Vector.<ChartElement> = viewer.chartModel.customElements;
            for each (var el:ChartElement in els)
            {
                viewer.addElement(el);
                context.addChild(el);
            }
        }
        
        protected function updateAxisLabels(axis:Axis):void
        {
            if (!_viewer)
            {
                return;
            }
            var data:CartesianChartData = _viewer.chartModel.data as CartesianChartData;
            var ticks:Vector.<Number> = data.yTicks;
            var labels:Vector.<String> = new <String>[];
            if (axis.isValueAxis)
            {
                if (ticks)
                {
					for each (var tick:Number in ticks) 
					{
						labels.push(StringFormater.format(tick, ''));
					}
                }
            }
            else
            {
                labels = data.labels;
				//Hbar情况下该条件不成立
				if (axis is XAxis)
				{
					(axis as XAxis).labelInfos = newLabelInfos(true);
				}
            }
            axis.labels = labels;
        }
        
        protected function updateCanvas(chartCanvas:ChartCanvas):void
        {
            chartCanvas.secLinePoses = transLinePosFromLabel();
        }
        
        public function get labelInfos():Vector.<LabelInfo> 
        {
            return _labelInfos;
        }
        
        public function set labelInfos(value:Vector.<LabelInfo>):void 
        {
            if (value != null)
            {
                 _labelInfos = value;
            }
           
        }
    
    }

}