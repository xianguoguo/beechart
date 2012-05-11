package bee.chart.assemble.line.timeline
{
	import bee.chart.abstract.Chart;
	import bee.chart.abstract.ChartModel;
	import bee.chart.assemble.line.LineChartViewer;
	import bee.chart.assemble.line.SuperLineChartViewer;
	import bee.chart.assemble.line.timeline.TimeLineChartPrinter;
	import bee.chart.elements.cursor.Cursor;
	import bee.chart.elements.cursor.CursorManager;
	import bee.chart.elements.tooltip.Tooltip;
	import bee.util.StyleUtil;
	import flash.events.Event;
	import flash.events.MouseEvent;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class TimeLineChartView extends SuperLineChartViewer
    {
        private var _isMouseOverOnCanvas:Boolean = false; //鼠标是否在图表主区域上
        private var _isMouseDownOnCanvas:Boolean = false; //鼠标在图表主区域上是否按下
        private var _cursorManager:CursorManager;
        private var _mouseDownX:Number = 0.0;
        private var _canvasWidth:Number = 0.0;
        private var saveMoveGrid:int = 0;
        
        public function TimeLineChartView(chart:Chart = null)
        {
			LineChartViewer.defaultStatePrinter = new TimeLineChartPrinter();
            super(chart);
			_cursorManager = CursorManager.getInstance();
        }
        
		override public function applyStyleNow():void 
		{
			//重新加载style时候，需要将数据的range还原
			(dataModel as ChartModel).data.updateDatasetRange();
			super.applyStyleNow();
		}
		
        override protected function get defaultStyles():Object
        {
            return StyleUtil.mergeStyle(
				{
					"chartType": "timeline",
					"smooth":true 
				}, 
				super.defaultStyles
			);
        }
        
        override protected function addEventListeners():void
        {
            addEventListener(MouseEvent.CLICK, onClick);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        override protected function removeEventListeners():void
        {
            removeEventListener(MouseEvent.CLICK, onClick);
            removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        private function moveCursor():void
        {
            _cursorManager.followMouse();
        }
		
        override public function dispose():void
        {
            _cursorManager = null;
            super.dispose();
        }
        
        override protected function onRollOut(e:MouseEvent):void
        {
            if (!isDragging)
            {
                super.onRollOut(e);
                reset();
                _cursorManager.hideCursor();
            }
        }
        
        override protected function onMouseDown(e:MouseEvent):void
        {
			if (_isMouseOverOnCanvas)
			{
				super.onMouseDown(e);
				isMouseDownOnCanvas = true;
				_mouseDownX = mouseX;
			}
        }
        
        override protected function onMouseUp(e:MouseEvent):void
        {
			super.onMouseUp(e);
			isDragging = false;
			isMouseDownOnCanvas = false;
        }

        override protected function onMouseMove(e:MouseEvent):void
        {
			changeMouseOverOnCanvas();
            if (!isDragging)
            {
                super.onMouseMove(e);
            }
			//拖动图表的逻辑
            if (isMouseDownOnCanvas)
            {
                isDragging = true;
                clearHlObjs();
                var tempMoveGrid:int = 0;
                var moveDis:Number = 0.0;
                moveDis = _mouseDownX - mouseX;
                tempMoveGrid = moveDis / eachDividingWidth;
                var abc:int = tempMoveGrid - saveMoveGrid;
				saveMoveGrid = tempMoveGrid;
				chart.dataIndexRangeOffset(abc);
            }else
			{
				changeCursorState();
			}
			moveCursor();
        }
		
        private function reset():void
        {
			isDragging = false;
            isMouseDownOnCanvas = false;
            isMouseOverOnCanvas = false;
        }
        
        private function changeCursorState():void
        {
            if (isMouseDownOnCanvas)
            {
                _cursorManager.setCursorState(Cursor.DOWN);
            }
            else
            {
                _cursorManager.setCursorState(Cursor.OVER);
            }
        }
		
		private function changeMouseOverOnCanvas():void 
		{
			isMouseOverOnCanvas = isInRange();
		}
        
        private function get isMouseDownOnCanvas():Boolean
        {
            return _isMouseDownOnCanvas;
        }
        
        private function set isMouseDownOnCanvas(value:Boolean):void
        {
            if (_isMouseDownOnCanvas != value)
            {
                saveMoveGrid = 0;
                _isMouseDownOnCanvas = value;
                changeCursorState();
            }
        }
        
        private function get isMouseOverOnCanvas():Boolean
        {
            return _isMouseOverOnCanvas;
        }
        
        private function set isMouseOverOnCanvas(value:Boolean):void
        {
            if (_isMouseOverOnCanvas != value)
            {
                _isMouseOverOnCanvas = value;
				if (isDragging)
				{
					return;
				}
                if (value)
                {
                    changeCursorState();
					_cursorManager.showCursor();
                }
                else
                {
                    _cursorManager.hideCursor();
                    reset();
                }
            }
        }
        
        private function get eachDividingWidth():Number
        {
            var maxSetLength:Number = chart.data.maxSetLength;
            return Math.min(canvasWidth / maxSetLength, 50);
        }
        
        private function get canvasWidth():Number
        {
            if (_canvasWidth == 0.0)
            {
                _canvasWidth = canvasRange.width;
            }
            return _canvasWidth;
        }
    
    }

}