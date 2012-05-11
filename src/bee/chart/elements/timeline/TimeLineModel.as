package bee.chart.elements.timeline
{
    import cn.alibaba.core.mvcapp.CModel;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.DataIndexRange;
	import bee.chart.elements.timeline.labelmaker.LabelInfo;
    import bee.chart.util.ChartUtil;
    import bee.chart.util.LineUtil;
    import flash.events.Event;
    import flash.geom.Point;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class TimeLineModel extends CModel
    {
        private var _labels:Vector.<String>;
        private var _width:Number = 0.0;
        private var _height:Number = 0.0;
        private var _dataIndexRange:DataIndexRange;
        private var _dataSets:Vector.<ChartDataSet>;
        private var _cacheLabelsPosXs:Vector.<Number>; //存储label所在的x轴位置
        private var _timeLineDots:Vector.<Point>;
        
        private var _isRangeLocationHandling:Boolean = false; //是否在处理RangeLocationHandler函数逻辑，如果为true，则不处理onDataIndexRangeChangeHandler函数中的逻辑。防止重复绘制时间选择区。
        private var _startX:Number;
        private var _offset:Number;
        
		private var _btnPos:Point;//记录时间选区两个按钮的位置，在此用来定位选区mask的位置和宽度
		
		public var labelInfos:Vector.<LabelInfo>;
		public var chartPosFunction:Function;
		public var chartHeight:Number;
		
		public function TimeLineModel()
        {
            super();
            addEventListeners();
        }
        
        private function addEventListeners():void
        {
            addEventListener(RangeLocationEvent.RANGE_LOCATION, rangeLocationHandler);
            addEventListener(RangeLocationEvent.SET_ONE_TIME_RANGE, setOneTimeRangeLocationHandler);
        }
        
        private function removeEventListeners():void
        {
            removeEventListener(RangeLocationEvent.RANGE_LOCATION, rangeLocationHandler);
			removeEventListener(RangeLocationEvent.SET_ONE_TIME_RANGE, setOneTimeRangeLocationHandler);
        }
		
        override public function dispose():void
        {
            if (_cacheLabelsPosXs)
            {
                _cacheLabelsPosXs.length = 0;
                _cacheLabelsPosXs = null;
            }
            if (_labels)
            {
                _labels.length = 0;
                _labels = null;
            }
            if (_dataIndexRange)
            {
                _dataIndexRange.removeEventListener(Event.CHANGE, onDataIndexRangeChangeHandler);
                _dataIndexRange = null;
            }
            if (_dataSets)
            {
                _dataSets.length = 0;
                _dataSets = null;
            }
            removeEventListeners();
            super.dispose();
        }
        
        public function set dataIndexRange(value:DataIndexRange):void
        {
            if (!value.equel(_dataIndexRange))
            {
                if (_dataIndexRange)
                {
                    _dataIndexRange.removeEventListener(Event.CHANGE, onDataIndexRangeChangeHandler);
                }
                _dataIndexRange = value;
                _dataIndexRange.addEventListener(Event.CHANGE, onDataIndexRangeChangeHandler);
            }
        }
        
        public function dispatchBtnLocationEvent():void
        {
            if (_cacheLabelsPosXs && _cacheLabelsPosXs.length)
            {
                var btnXOne:Number = _cacheLabelsPosXs[_dataIndexRange.rangeStart];
                var btnXTwo:Number = _cacheLabelsPosXs[_dataIndexRange.rangeEnd - 1];
                dispatchEvent(new RangeLocationEvent(RangeLocationEvent.SET_RANGE_LOCATION, btnXOne, btnXTwo, true));
            }
        }
        
        public function get height():Number
        {
            return _height;
        }
        
        public function set height(value:Number):void
        {
            _height = value;
            updateState();
            notifyChange();
        }
        
        public function get width():Number
        {
            return _width;
        }
        
        public function set width(value:Number):void
        {
            _width = value;
            updateState();
            notifyChange();
        }
        
        public function get labels():Vector.<String>
        {
            return _labels ? _labels.concat() : null;
        }
        
        public function set labels(value:Vector.<String>):void
        {
            _labels = value;
            updateState();
            notifyChange();
        }
        
        public function get dividingStart():Number
        {
            return 0;
        }
        
        public function get dividingWidth():Number
        {
            return width;
        }
        
        public function get eachDividingWidth():Number
        {
            return dividingWidth / (_labels.length - 1);
        }
        
        public function get cacheLabelsPosXs():Vector.<Number>
        {
            return _cacheLabelsPosXs != null ? _cacheLabelsPosXs.concat() : null;
        }
        
        public function get timeLineDots():Vector.<Point>
        {
            return _timeLineDots != null ? _timeLineDots.concat() : null;
        }
        
        public function get dataSets():Vector.<ChartDataSet>
        {
            return _dataSets != null ? _dataSets.concat() : null;
        }
        
        public function set dataSets(value:Vector.<ChartDataSet>):void
        {
            if (value != null)
            {
                _dataSets = value;
                updateState();
                notifyChange();
            }
        }
        
        public function get startX():Number
        {
            return _startX;
        }
        
        public function get offset():Number
        {
            return _offset;
        }
		
		public function get btnPos():Point 
		{
			return _btnPos;
		}
		
		public function set btnPos(pt:Point):void 
		{
			if (!_btnPos || !pt.equals(_btnPos))
			{
				_btnPos = pt;
			}
		}
        
        private function rangeLocationHandler(e:RangeLocationEvent):void
        {
            if (_dataIndexRange)
            {
                _isRangeLocationHandling = true;
                const btnXOne:Number = e.btnXOne;
				const btnXTwo:Number = e.btnXTwo;
                var rangeStart:int = ChartUtil.getIndex(btnXOne, _cacheLabelsPosXs);
                var rangeEnd:int = ChartUtil.getIndex(btnXTwo, _cacheLabelsPosXs) + 1;
                //由RangeSelector改变range范围
                _dataIndexRange.changeRangeBySelector(rangeStart, rangeEnd);
				btnPos = new Point(btnXOne, btnXTwo);
                _isRangeLocationHandling = false;
				notifyChange();
            }
        }
		
		private function setOneTimeRangeLocationHandler(e:RangeLocationEvent):void 
		{
			if (_dataIndexRange)
            {
                var rangeStart:int = labelInfos[0].index;
                var rangeEnd:int = labelInfos[1].index;
                //由RangeSelector改变range范围
                _dataIndexRange.changeRangeBySelector(rangeStart, rangeEnd);
            }
		}
		
        private function onDataIndexRangeChangeHandler(e:Event = null):void
        {
            if (!_isRangeLocationHandling)
            {
                dispatchBtnLocationEvent();
                changeBtnPosByChange();
            }
        }
        
        private function changeBtnPosByChange():void
        {
            var btnXOne:Number = _cacheLabelsPosXs[_dataIndexRange.rangeStart];
			var btnXTwo:Number = _cacheLabelsPosXs[_dataIndexRange.rangeEnd - 1];
			btnPos = new Point(btnXOne, btnXTwo);
			notifyChange();
        }
            
        private function updateState():void
        {
            if (isDataReady())
            {
                updateDataCache();
                newLabelsPosXs();
                newTimeLineDots();
            }
            function isDataReady():Boolean
            {
                return _labels && _labels.length && _width > 0 && _height > 0;
            }
        }
        
        private function updateDataCache():void
        {
            _startX = chartPosFunction(0, 0).x;
        }
        
        private function newLabelsPosXs():void
        {
            if (width > 0 && _labels && _labels.length)
            {
                _cacheLabelsPosXs = new Vector.<Number>();
                var numLabel:int = _labels.length;
                var dividingStart:Number = dividingStart;
                var eachWidth:Number = eachDividingWidth;
                var _x:Number = 0;
                for (var i:int = 0; i < numLabel; i++)
                {
                    _x = eachWidth * i + dividingStart;
                    _cacheLabelsPosXs.push(LineUtil.handleNumberForFlashPos(_x));
                }
            }
        }
        
        private function newTimeLineDots():void
        {
            if (_dataSets && _dataSets.length)
            {
                _timeLineDots = new Vector.<Point>();
				//TODO:这里以数据的第一条数据为原型绘制时间线,后面加入的线暂时不考虑
                var chartDataSet:ChartDataSet = _dataSets[0];
                var values:Vector.<Number> = chartDataSet.values;
				var idx:int = 0;
				for each (var val:Number in values) 
				{
					_timeLineDots.push(chartPt2TimeLinePt(idx, val));
					idx++;
				}
				_offset = chartPt2TimeLinePt(0, chartDataSet.max).y;
            }
        }

		 /**
		  * 将图表的坐标转换为时间线的坐标;
		  * x左边因为chart有paddingLeft或paddingRight属性，若沿用会导致时间线左右空白，故重新计算；
		  * y坐标根据高度比例关系换算；
		  * @param	idx
		  * @param	val
		  * @return
		  */
		private function chartPt2TimeLinePt(idx:int, val:Number):Point
		{
			var pt:Point = chartPosFunction(idx, val);
			if (!pt)
			{
				return null;
			}
			pt.x = _cacheLabelsPosXs[idx];
			pt.y *= height / chartHeight;
			return pt;
		}
    }
}