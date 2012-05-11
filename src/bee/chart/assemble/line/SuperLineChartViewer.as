package bee.chart.assemble.line 
{
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.I2VPoint;
    import bee.chart.elements.guideline.GuideLine;
    import bee.chart.elements.line.Line;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.events.ChartUIEvent;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
    import flash.geom.Point;
	
	/**
    * 特点：
    * 1.具有引导线；
    * 2.引导线上的点全部高亮显示；
    * 3.tip提示显示高亮点的全部信息；
    * @author jianping.shenjp
    */
    public class SuperLineChartViewer extends LineChartViewer 
    {
        private var _guideLine:GuideLine;
        private var currentHighlitingPt:I2VPoint;
        
        public function SuperLineChartViewer(chart:Chart = null) 
        {
            super(chart);
            Tooltip.instance.textGen = MultipleLineTipGen.getTipText;
        }
        
        override public function highlightPointsNear(x:Number, y:Number, hlLines:Boolean = true):void 
        {
            var xIndex:int = Math.round(viewToChartXY(x, 0).x);
            var dots:Vector.<I2VPoint> = getPointsAtIndex(xIndex, x);
            var nearestPt:I2VPoint;
            if (dots && dots.length) 
            {
                var pos:Point = chartToViewXY(xIndex, dots[0].value);
                
                highlightAxisAtIndex(xIndex);
                
                //有最近的点，高亮最近的点；否则高亮该X坐标线上的所有点。
                nearestPt = getNearestPoint(x, y, 50, dots);
                if (hasFocusChanged(xIndex, nearestPt))
                {
                    if (nearestPt) 
                    {
                        updateLinesHLState(xIndex, nearestPt.value);
                    } else {
                        clearHLLines();
                    }
                    showAndSetGuideLineAt(pos.x);
                    showTip(xIndex, pos, nearestPt);
                }
                if (!nearestPt) 
                {
                    highlightDotsAt(xIndex);
                }
            } 
            else 
            {
                clearHlObjs();
            }
            currentHighlitingPt = nearestPt;
        }
        
		/**
		 * 修复用户鼠标移动到x坐标轴之下再上移，点不高亮的bug
		 * @param	e
		 */
		override protected function onRollOut(e:MouseEvent):void 
		{
			super.onRollOut(e);
			currentHighlitingPt = null;
		}
		
        private function hasFocusChanged(xIndex:int, nearestPt:I2VPoint):Boolean
        {
            return currentHighlitingPt && xIndex != currentHighlitingPt.x
                || (nearestPt == null && currentHighlitingPt == null ) 
                || (nearestPt && !nearestPt.equals(currentHighlitingPt)) 
                || (!nearestPt && currentHighlitingPt);
        }
        
        private function updateLinesHLState(xIndex:int, value:Number):void 
        {
            for each(var line:Line in getVisibleLines()) 
            {
                if (line.canHighlightDotAt(xIndex, value)) 
                {
                    if (!chart.isTimeline())
                    {
                        highLightLine(line);
                    }
                    line.highlightDotAt(xIndex, value);
                    dispatchLineEvent(line, ChartUIEvent.FOCUS_ITEM);
                } 
                else 
                {
                    clearHLLine(line);
                    line.clearHighlightDot();
                }
            }
        }
        
        override protected function clearHlObjs():void 
        {
            super.clearHlObjs();
            
            if (_guideLine) {
                _guideLine.hide();
            }
        }
        
        private function highlightDotsAt(xIndex:int):void 
        {
            var lines:Vector.<Line> = getVisibleLines();
            for each(var line:Line in lines) {
                if (line.highlightIndex != xIndex) {
                    line.highlightIndex = xIndex;
                }
            }
        }
        
        private function showTip(xIndex:int, pos:Point, nearestPt:I2VPoint):void 
        {
            if (chartModel.enableTooltip) 
            {
                var tip:Tooltip = Tooltip.instance;
                tip.printTipAt(xIndex, nearestPt? nearestPt.value : Number.NaN);
                tip.state = 'normal';
                tip.goto(pos.x, pos.y);
            }
        }
        
        private function showAndSetGuideLineAt(x:Number):void 
        {
            if (!_guideLine)
            {
                addGuideLine();
				ajustLineZIndex();
            }
            _guideLine.show();
            _guideLine.x = x;
        }
        
        private function addGuideLine():void 
        {
			if(_guideLine) {
				disposeGuideLine();
			}
            _guideLine = new GuideLine();
            StyleUtil.inheritStyleSheet(_guideLine, 'guideline', this);
            _guideLine.setStyle('length', _chartHeight.toString());
            _guideLine.y = -chart.chartHeight;
            _guideLine.alpha = 0;
            _guideLine.mouseEnabled = false;
            content.addChild(_guideLine);
        }

        override public function set state(value:String):void 
        {
			prepareForRedraw();
			super.state = value;
        }

		private function prepareForRedraw():void
		{
			disposeGuideLine();
			_linesContainer = null;
		}

		override protected function redrawDirectly():void
		{
			prepareForRedraw();
			super.redrawDirectly();
		}
        
        private function ajustLineZIndex():void
        {
            content.addChild(_guideLine);
            _guideLine.cacheAsBitmap = true;
            
            var lineContainer:DisplayObjectContainer = getLinesContainer();
            if (lineContainer)
            {
                content.addChild(lineContainer);
            }

        }
        
        /**
        * 获取最近的数据点
        * @param	x   目标x坐标（视图中的坐标系）
        * @param	maxDistance 最大检测距离
        * @return
        */
        private function getPointsAtIndex(xIndex:int, x:Number, maxDistance:Number=50):Vector.<I2VPoint>
        {
            if (Math.abs(x - chartToViewXY(xIndex, 0).x) <= maxDistance) {
                return chart.data.getVisiblePointsInCol(xIndex);
            } else {
                return null;
            }
        }
        
        override public function dispose():void 
        {
            currentHighlitingPt = null;
            disposeGuideLine();
            super.dispose();
        }
        
        private function disposeGuideLine():void 
        {
            if (_guideLine)
            {
                if (_guideLine.parent) {
                    _guideLine.parent.removeChild(_guideLine);
                }
                _guideLine.dispose();
                _guideLine = null;
            }
        }
    }

}
