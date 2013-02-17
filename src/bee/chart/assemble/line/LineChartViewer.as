package bee.chart.assemble.line 
{
    import bee.chart.abstract.CartesianChartViewer;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.I2VPoint;
    import bee.chart.assemble.line.LineChartPrinter;
    import bee.chart.elements.line.Line;
    import bee.chart.elements.line.LineData;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.events.ChartUIEvent;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.printers.IStatePrinter;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    /**
     * ...
     * @author qhwa
     */
    public class LineChartViewer extends CartesianChartViewer
    {
        
        static public var defaultStatePrinter:IStatePrinter = new LineChartPrinter();
        static public var defaultPerformer:IPerformer = SimplePerformer.instance;
        
        protected var _canvasRange:Rectangle;
        protected var _linesContainer:DisplayObjectContainer;
        
        public function LineChartViewer(chart:Chart=null) 
        {
            super(chart);
            Tooltip.instance.textGen = LineChartTipTextGen;
        }
        
        override protected function initView():void 
        {
            super.initView();
            
            skin.statePrinter = defaultStatePrinter;
            skin.performer = defaultPerformer;
            
            if (chartModel.enableMouseTrack)
            {
                addEventListeners();
            }
        }
        
        /**
        * 高亮(x,y)附近的点和线
        * @param	x   当前x坐标
        * @param	y   当前y坐标
        * @param	hlLines 是否也要高亮点所在的线
        */
        public function highlightPointsNear(x:Number, y:Number, hlLines:Boolean=true):void 
        {
            var nearPt:I2VPoint = getNearestPoint(x, y);
            if(nearPt){
                var line:Line = getHighLightLine(nearPt);
                highLightLineAndDot(line, nearPt, hlLines);
                if(chartModel.enableTooltip){
                    var pos:Point = chartToViewXY(nearPt.x, nearPt.y);
                    
                    var tip:Tooltip = Tooltip.instance;
                    tip.goto(pos.x, pos.y);
                    tip.printTipAt( nearPt.x, nearPt.y );
                    tip.state = 'normal';
                }
                if (_indexAxis) {
                    _indexAxis.highlightAt( nearPt.x );
                }
                dispatchLineEvent(line, ChartUIEvent.FOCUS_ITEM);
                line = null;
                
            } else {
                clearHlObjs();
            }
        }
        
        /**
         * 用来特殊处理只有一条数据时的显示
         * @param	idx
         * @param	value
         * @return
         */
        override public function chartToViewXY(idx:Number, value:Number):Point 
        {
            var pt:Point = super.chartToViewXY(idx, value);
            if (chart.data.maxSetLength === 1) {
                makeTheOnlyDotCenter(pt);
            }
            return pt;
        }
        
        private function makeTheOnlyDotCenter(pt:Point):void 
        {
            pt.x = _cachePaddingLeft + _cacheWidth >> 1;
        }
        
        /**
        * 设置某条线是否绘制出来
        * @param	index
        * @param	active
        */
        override public function setDatasetActivity(index:uint, active:Boolean):void 
        {
            var line:Line = getLine(index);
            if (line) {
                line.state = active ? 'active' : 'normal';
            }
        }
        
        /**
         * 垃圾回收
         */
        override public function dispose():void 
        {
            if (_canvasRange)
            {
                _canvasRange = null;
            }
            _linesContainer = null;
            removeEventListeners();
            super.dispose();
        }
        
        override public function setStyle(name:String, value:String):void 
        {
            super.setStyle(name, value);
            if (name === 'animate') {
                setLinePerformer(value);
            }
        }
        
        public function get canvasRange():Rectangle
        {
            if (!_canvasRange)
            {
                updateCanvasRange();
            }
            return _canvasRange;
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Private Functions
        
        override protected function addEventListeners():void 
        {
            super.addEventListeners();
            addEventListener(MouseEvent.CLICK, onClick);
            addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.ROLL_OUT, onRollOut);
        }
        
        override protected function removeEventListeners():void 
        {
            super.removeEventListeners();
            removeEventListener(MouseEvent.CLICK, onClick);
            removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
        }
        
        protected function getLine(index:uint):Line
        {
            var container:DisplayObjectContainer = getLinesContainer();
            if (container) {
                return container.getChildByName('line' + index) as Line;
            }
            return null;
        }
        
        protected function getLinesContainer():DisplayObjectContainer 
        {
            if (!_linesContainer)
            {
                _linesContainer = content.getChildByName('lines') as DisplayObjectContainer;
            }
            return _linesContainer;
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Event Handlers
        
        /**
        * 鼠标移动时的处理
        * @param	e
        */
        protected function onMouseMove(e:MouseEvent):void 
        {
            updateMousePos(mouseX, mouseY);
        }
        
        protected function onMouseUp(e:MouseEvent):void 
        {
            dispatchChartUIEventForLineChart(e, ChartUIEvent.MOUSE_UP_ITEM);
        }
      
        protected function onMouseDown(e:MouseEvent):void 
        {
            dispatchChartUIEventForLineChart(e,ChartUIEvent.MOUSE_DOWN_ITEM);
        }
        
        protected function onClick(e:MouseEvent):void 
        {
            dispatchChartUIEventForLineChart(e,ChartUIEvent.CLICK_ITEM);
        }
        
        protected function onRollOut(e:MouseEvent):void 
        {
            clearHlObjs();
        }
        
        /**
        * 清除所有线条
        */
        protected function clearLines():void
        {
            for each(var el:ChartElement in elements) {
                if (el is Line) {
                    removeElement(el);
                }
            }
        }
        
        protected function getVisibleLines():Vector.<Line> 
        {
            var elements:Vector.<ChartElement> = elements;
            var lines:Vector.<Line> = new Vector.<Line>();
            for each(var el:ChartElement in elements) {
                if (isVisibleLine(el)) {
                    lines.push( el as Line );
                }
            }
            return lines;
        }
        
        protected function getHighLightLine(nearPt:I2VPoint):Line 
        {
            var result:Line;
            var idx:uint = nearPt.x;
            var value:Number = nearPt.y;
            for each(var line:Line in getVisibleLines()) {
                if (line.canHighlightDotAt(idx, value)) {
                    result = line;
                    break;
                } 
            }
            return result;
        }
        
        protected function highLightLine(line:Line):void 
        {
            line.parent.addChild(line);
            line.state = 'active';
        }
        
        protected function highLightDot(line:Line, nearPt:I2VPoint, hlLines:Boolean=true):void 
        {
            if (line && hlLines && line.lineVisible)
            {
                line.highlightDotAt(nearPt.x, nearPt.y);
            }
        }
        
        protected function highlightAxisAtIndex(xIndex:uint):void
        {
            if (indexAxis) {
                indexAxis.highlightAt( xIndex );
            }
        }
        
        protected function dispatchLineEvent(line:Line,type:String):void
        {
            if (line)
            {
                var info:Object = getChartUIEventData(line);
                if (info)
                {
                    dispatchChartUIEvent(type, info);
                }
            }
        }
        
        protected function clearHlLineDotsAndAxis():void
        {
            clearHLLinesAndDots();
            clearHLAxis();
        }
        
        protected function clearHLLinesAndDots():void
        {
            for each (var line:Line in getVisibleLines())
            {
                clearHLLine(line);
                line.clearHighlightDot();
            }
        }
        
        protected function clearHLLine(line:Line):void 
        {
            if (line && line.state != 'normal') {
                line.state = 'normal';
                dispatchLineEvent(line, ChartUIEvent.BLUR_ITEM);
            }
        }
        
        protected function clearHLLines():void
        {
            for each (var line:Line in getVisibleLines())
            {
                clearHLLine(line);
            }
        }
        
        protected function clearHLAxis():void 
        {
            if(_indexAxis) {
                _indexAxis.clearHighlight();
            }
        }
        
        protected function updateCanvasRange():void 
        {
            var canvas:DisplayObject = content.getChildByName("canvas");
            if (canvas)
            {
                _canvasRange = canvas.getBounds(this);
            }
        }
        
        /**
        * 清除所有被高亮的点的高亮状态和tooltip提示
        */
        protected function clearHlObjs():void 
        {
            clearHlLineDotsAndAxis();
            hideTooltip();
        }
        
        protected function updateMousePos(x:Number, y:Number):void 
        {
            if (!isInRange()) {
                clearHlObjs();
            } else {
                highlightPointsNear(x, y);
            }
        }
        
        protected function isInRange():Boolean
        {
            if (canvasRange && canvasRange.contains(mouseX, mouseY))
            {
                return true;
            }
            return false;
        }
        
        private function isVisibleLine(el:ChartElement):Boolean 
        {
            return (el is Line) && (el as Line).lineVisible;
        }
        
        private function hideTooltip():void 
        {
            var tip:Tooltip = Tooltip.instance;
            tip.state = 'hidden';
        }
        
        private function highLightLineAndDot(line:Line, nearPt:I2VPoint, hlLines:Boolean=true):void 
        {
            highLightLine(line);
            highLightDot(line, nearPt, hlLines );
        }
        
        /**
         * 根据配置设置line的Performer.
         */
        private function setLinePerformer(animate:String):void 
        {
            var performer:IPerformer;
            switch (animate)
            {
                case "true":
                    performer = new LineChartEnterAnimator();
                    break;
                default:
                    performer=SimplePerformer.instance;
                    break;
            }
            if (performer)
            {
                skin.performer = performer;
            }
        }
        
        private function getChartUIEventData(line:Line):Object
        {
            var result:Object = { };
            if (line)
            {
                var xIndex:int = line.highlightIndex;
                var data:LineData = line.model as LineData;
                //增加对索引最大值的判断，防止出现索引超出范围报错的问题
                if (xIndex > data.values.length)
                {
                    return null;
                }
                result = {
                    name: data.name,
                    xIndex: xIndex,
                    value: (xIndex >= 0) ? data.values[xIndex] : null,
                    label: chart.data.getLabelAt(xIndex)
                };
            }
            return result;
        }
        
        private function dispatchChartUIEventForLineChart(e:MouseEvent, type:String):void 
        {
            if (e.target is Line) {
                dispatchLineEvent(e.target as Line,type);
            }
        }
    }
}
