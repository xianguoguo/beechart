package bee.chart.abstract 
{
    import bee.chart.abstract.CartesianChartViewer;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.abstract.I2VPoint;
    import bee.chart.elements.axis.Axis;
    import bee.chart.util.LineUtil;
    import bee.util.StyleUtil;
    import flash.geom.Point;
	/**
    * 使用笛卡尔直角坐标系统的图表
    * @author hua.qiuh
    */
    public class CartesianChartViewer extends ChartViewer 
    {
		protected var _cachePaddingLeft:Number    = 0;
		protected var _cachePaddingRight:Number   = 0;
		protected var _cachePaddingTop:Number     = 0;
		protected var _cachePaddingBottom:Number  = 0;
		protected var _cacheWidth:Number          = 0;
		protected var _cacheHeight:Number         = 0;
		protected var _cacheXStep:Number          = 0;
		protected var _cacheYMax:Number           = 0;
		protected var _cacheYMin:Number           = 0;
		protected var _cachePoints:Vector.<I2VPoint>;
        protected var _chartWidth:Number;
        protected var _chartHeight:Number;
        
        protected var _indexAxis:Axis;
        private var _horizontal:Boolean = false;
        private var _hx:Number;
        private var _vy:Number;
        
        public function CartesianChartViewer(chart:Chart = null) 
        {
            super(chart);
            updateCache();
        }
        
        /**
        * 获取或设置x轴
        */
        public function get indexAxis():Axis 
        { 
            if (_indexAxis && !content.contains(_indexAxis)) {
                _indexAxis.dispose();
                _indexAxis = null; 
            }
            return _indexAxis; 
        }
        public function set indexAxis(value:Axis):void 
        {
            _indexAxis = value;
        }
        
        public function get horizontal():Boolean { return _horizontal; }
        public function set horizontal(value:Boolean):void 
        {
            if (_horizontal != value) {
                if (_indexAxis) {
                    _indexAxis.dispose();
                    _indexAxis = null;
                }
                _horizontal = value;
                updateDataCache();
                needRedraw = true;
            }
        }
        
        /**
        * 将数据坐标转换成视图上的坐标位置
        * @param	idx
        * @param	value
        * @return
        */
        override public function chartToViewXY(idx:Number, value:Number):Point 
        {
            if (isNaN(idx) || isNaN(value)) {
                //该点数据已缺失
                return null;
            }
            var y:Number;
            var x:Number;
            if (_horizontal) {
                x = (value- _cacheYMin) * _hx + _cachePaddingLeft;
                y = -_cacheHeight + _cachePaddingTop + idx * _cacheXStep;
            } else {
                x = _cachePaddingLeft + idx * _cacheXStep;
                if (_cacheYMax === _cacheYMin) {
                    y = 0;
                } else {
                    y = -(value- _cacheYMin) * _vy - _cachePaddingBottom;
                }
                
            }
            //处理坐标数据，对百分位进行四舍五入
            x = LineUtil.handleNumberForFlashPos(x);
            y = LineUtil.handleNumberForFlashPos(y);
            return new Point(x, y);
        }
        
        /**
        * 将视图上的坐标转换为数据坐标
        * @param	x
        * @param	y
        * @return
        */
        override public function viewToChartXY(x:Number, y:Number):Point 
        {
            var value:Number;
            var idx:Number;
            x = LineUtil.handleNumberForFlashPos(x);
            y = LineUtil.handleNumberForFlashPos(y);
            if (_horizontal) {
                idx = (y + _cacheHeight - _cachePaddingTop) / _cacheXStep;
                value = _cacheYMin + (_cacheYMax - _cacheYMin) * (x - _cachePaddingLeft) / _cacheWidth;
            } else {
                idx = (_cacheXStep != 0) ? ((x - _cachePaddingLeft) / _cacheXStep) : 0;
                value = _cacheYMin -(y + _cachePaddingBottom) * (_cacheYMax - _cacheYMin) / _cacheHeight;
            }
            return new Point(idx, value);
        }
        
        /**
        * 获取最近的数据点
        * @param	x   目标x坐标（视图中的坐标系）
        * @param	y   目标y坐标（视图中的坐标系）
        * @param	maxDistance 最大检测距离
        * @return
        */
        public function getNearestPoint(x:Number, y:Number, maxDistance:Number=50, dots:Vector.<I2VPoint>=null):I2VPoint
        {
            var thePt:I2VPoint, nearestDist:Number = Number.MAX_VALUE;
            if (!dots) {
                dots = _cachePoints;
            }
            
            var ptx:Number, pty:Number, tmpPoint:Point;
            for each(var pt:I2VPoint in dots)
            {
                ptx = pt.x;
                pty = pt.y;
				if (Math.abs(ptx * _cacheXStep -x) > maxDistance) {
                    continue;
                }
				tmpPoint = chartToViewXY(ptx, pty);
                if(tmpPoint){
                    var dx:Number = x - tmpPoint.x;
                    var dy:Number = y - tmpPoint.y;
                    if (Math.abs(dx) > maxDistance || Math.abs(dy) > maxDistance) {
                        continue;
                    }
                    var dist:Number = dx * dx + dy * dy;
                    if ( dist < nearestDist && dist < maxDistance * maxDistance ) {
                        nearestDist = dist;
                        thePt = pt.clone();
                    }
                }
			}
            
            return thePt;
        }
        
        /**
        * 更新缓存的数据
        */
        public function updateCache():void
        {
			_cachePaddingLeft   = StyleUtil.getNumberStyle(this, 'paddingLeft');
			_cachePaddingRight  = StyleUtil.getNumberStyle(this, 'paddingRight');
			_cachePaddingTop    = StyleUtil.getNumberStyle(this, 'paddingTop');
			_cachePaddingBottom = StyleUtil.getNumberStyle(this, 'paddingBottom');
            _chartWidth         = chartModel.chartWidth;
            _chartHeight        = chartModel.chartHeight;
            
            updateDataCache();
            
        }
        
        public function updateDataCache():void
        {
			var data:CartesianChartData  = chartModel.data as CartesianChartData;
            _cacheHeight    = _chartHeight -  _cachePaddingTop - _cachePaddingBottom;
            _cacheWidth     = _chartWidth - _cachePaddingRight - _cachePaddingLeft;
            
            var dataLen:uint = data.maxSetLength;
            var valueLen:Number = _horizontal ? _cacheHeight : _cacheWidth;
            _cacheXStep     = dataLen > 1 ? valueLen / (dataLen - 1) : 0;
            _cacheYMax      = data.maxTickValue;
            _cacheYMin      = data.minTickValue;
            _hx = 1 / (_cacheYMax - _cacheYMin) * _cacheWidth;
            _vy = 1 / (_cacheYMax - _cacheYMin) * _cacheHeight;
            _cachePoints    = new Vector.<I2VPoint>();
			for each (var dSet:ChartDataSet in data.visibleSets) 
			{
				var idx:int = 0;
				for each (var v:Number in dSet.values) 
				{
					_cachePoints.push(new I2VPoint(idx, v));
					idx++;
				}
			}
        }
        
        override public function applyStyleNow():void 
        {
            updateCache();
            super.applyStyleNow();
        }
        
        override public function dispose():void 
        {
            _indexAxis = null;
            super.dispose();
        }
        
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        override protected function get defaultStyles():Object { 
            return StyleUtil.mergeStyle({
                'paddingLeft'   : '0',
                'paddingRight'  : '0',
                'paddingTop'    : '0',
                'paddingBottom' : '0',
                'xAxisVisibility' : 'visible'
            }, super.defaultStyles); 
        }
        
        override public function get state():String { return super.state; }
        override public function set state(value:String):void 
        {
            if(value === ChartStates.NORMAL){
                updateCache();
            }
            super.state = value;
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Private Functions
        
        override protected function redraw():void 
        {
            updateCache();
            super.redraw();
        }
        
    }

}