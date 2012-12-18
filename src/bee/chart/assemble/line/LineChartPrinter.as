package bee.chart.assemble.line
{
    import bee.chart.elements.legend.Legend;
	import cn.alibaba.util.ColorUtil;
	import bee.abstract.IStatesHost;
	import bee.chart.abstract.ChartData;
	import bee.chart.abstract.ChartDataSet;
	import bee.chart.abstract.ChartElement;
	import bee.chart.abstract.ChartStates;
	import bee.chart.abstract.ChartViewer;
	import bee.chart.assemble.CartesianChartPrinter;
	import bee.chart.assemble.line.LineChartViewer;
	import bee.chart.elements.axis.Axis;
	import bee.chart.elements.canvas.ChartCanvas;
	import bee.chart.elements.line.Line;
	import bee.chart.elements.line.LineData;
	import bee.chart.elements.line.LineSimplePrinter;
	import bee.chart.elements.line.LineWithNumberPrinter;
	import bee.chart.util.ChartUtil;
	import bee.printers.IStatePrinterWithUpdate;
	import bee.util.StyleUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class LineChartPrinter extends CartesianChartPrinter implements IStatePrinterWithUpdate
	{
		public function LineChartPrinter()
		{
		}
		
		override protected function renderNormalState(host:ChartViewer, context:DisplayObjectContainer):void
		{
			super.renderNormalState(host, context);
			drawLines(_viewer as LineChartViewer, context);
			_viewer.makeSelfCenter();
		}
		
		/**
		 * 绘制线条
		 */
		protected function drawLines(host:LineChartViewer, context:DisplayObjectContainer):void
		{
			var data:ChartData = host.chartModel.data;
			var sets:Vector.<ChartDataSet> = data.sets;
			var ln:Line, dataSet:ChartDataSet;
			var len:uint = sets.length;
			var lineContainer:Sprite = new Sprite();
			lineContainer.name = 'lines';
			lineContainer.mouseEnabled = false;
			lineContainer.mouseChildren = false;
			while (len--)
			{
				dataSet = sets[len];
				if (!dataSet.visible)
				{
					continue;
				}
				
				var lnData:LineData = LineData.fromDataSet(dataSet);
				ln = host.requestElement(Line) as Line;
				ln.name = 'line' + len;
				setLineStyle(ln, lnData, len);
				updateLineDotPositions(ln);
				
				host.addElement(ln);
				lineContainer.addChild(ln);
				context.addChild(lineContainer);
				ln.state = 'normal';
			}
		
		}
		
		/**
		 * 设置line的style和value
		 * @param	ln
		 * @param	lnData
		 * @param	len
		 * @param	host
		 */
		private function setLineStyle(ln:Line, lnData:LineData, index:int):void
		{
			var labelConfig:Object = _viewer.styleSheet.getStyle('line dot label');
			if (labelConfig['visibility'] === 'visible')
			{
				if (!(ln.skin.statePrinter is LineWithNumberPrinter))
				{
					ln.skin.statePrinter = new LineWithNumberPrinter(new LineSimplePrinter());
				}
			}
			var dfltStyle:Object = _viewer.styleSheet.getStyle('line');
			var style:Object = StyleUtil.mergeStyle(lnData.styleConfig, dfltStyle);
			
			//若无指定颜色，就采用自动配置颜色
			if (!lnData.config.style || !lnData.config.style.color)
			{
				style["color"] = ColorUtil.int2str(ChartUtil.getColor(lnData, index));
			}
			
			ln.setStyles(style);
			ln.styleSheet.setStyle('dot', StyleUtil.mergeStyle(lnData.getSheet('dot'), _viewer.styleSheet.getStyle('line dot')));
			ln.styleSheet.setStyle('dot label', labelConfig);
		}
		
		public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void
		{
			if (state === ChartStates.NORMAL)
			{
				if (!shouldSmoothUpdate(host as LineChartViewer, context))
				{
					renderState(host, state, context);
					return;
				}
				initParamter(host, context);
				for each (var el:ChartElement in _viewer.elements)
				{
					smoothUpdateElement(el);
				}
				clearParamter();
			}
		}
		
		private function shouldSmoothUpdate(viewer:LineChartViewer, context:DisplayObjectContainer):Boolean
		{
			var lines:Sprite = context.getChildByName('lines') as Sprite;
            trace((lines && lines.numChildren),viewer.chart.allSets.length);
			return lines && lines.numChildren == viewer.chart.allSets.length;
		}
		
		private function smoothUpdateElement(el:ChartElement):void
		{
			if (el is Line) {
				updateLineDotPositions(el as Line);
			} else if (el is Axis) {
				updateAxisLabels(el as Axis);
			} else if (el is ChartCanvas) {
				updateCanvas(el as ChartCanvas);
			} else if (el is Legend) {
                //Bugfix:数据条数未改变，但数据内容改变，需要重绘数据显示
                var tempLegend:Legend = el as Legend;
                tempLegend.dataSets = this._viewer.chartModel.data.allSets;
                tempLegend = null;
            }
			el.smoothUpdate();
		}
		
		private function updateLineDotPositions(line:Line, index:uint = 0):void
		{
			var index:uint = getLineIndex(line);
            
			var dataSet:ChartDataSet = _viewer.chart.getChartSetAt(index);
			
			var lnData:LineData = LineData.fromDataSet(dataSet);
			
			var values:Vector.<Number> = lnData.values;
			
			var pts:Vector.<Point> = new Vector.<Point>();
			var idx:int = 0;
			for each (var value:Number in values)
			{
				pts.push(_viewer.chart.chartToViewXY(idx, value));
				idx++;
			}
			lnData.dotPositions = pts;
			line.setModel(lnData);
		}
		
		private function getLineIndex(line:Line):uint
		{
			return uint(line.name.match(/\d+$/)[0]);
		}
	
	}

}
