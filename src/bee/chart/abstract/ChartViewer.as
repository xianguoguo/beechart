package bee.chart.abstract 
{
    import bee.abstract.CComponent;
    import bee.chart.events.ChartEvent;
    import bee.chart.events.ChartUIEvent;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    /**
    * ...
    * @author hua.qiuh
    */
    public class ChartViewer extends CComponent
    {
        public var chart:Chart;
        
        protected var _elements:Vector.<ChartElement> = new Vector.<ChartElement>();
        private var _isSmoothing:Boolean;//是否在缓动过程中
        private var _isDragging:Boolean;//是否在图表拖拽过程中
        
        public function ChartViewer(chart:Chart=null) 
        {
            if (chart)
            {
                this.chart = chart;
                chart.addChild(this);
                super(chart.chartModel);
            }
        }
        
        /**
        * 添加部件
        * @param	el
        */
        public function addElement(el:ChartElement):void
        {
            var evt:Event = new ChartEvent(ChartEvent.BEFORE_ADD_VIEW_ELEMENT, el, true, true)
            dispatchEvent(evt);
            if(!evt.isDefaultPrevented()){
                if (_elements.indexOf(el) == -1) {
                    el.chart = this.chart;
                    _elements.push(el);
                    addContent(el);
                }
            }
            dispatchEvent(new ChartEvent(ChartEvent.AFTER_ADD_VIEW_ELEMENT, el, true, true));
        }
        
        /**
        * 删除部件
        * @param	el
        */
        public function removeElement(el:ChartElement):void
        {
            var idx:int = _elements.indexOf(el);
            if (idx != -1) {
                _elements.splice(idx, 1);
                content.removeChild(el);
            }
        }
        
        public function getElementByName(name:String):ChartElement
        {
            var result:ChartElement;
            for each(var el:ChartElement in _elements)
            {
                if (el.name == name)
                {
                    result = el;
                }
            }
            return result;
        }
        
        override public function clearContent():void
        {
            for each(var el:ChartElement in _elements) 
            {
                if (!el.reusable) {
                    el.dispose();
                }
            }
            _elements.length = 0;
            super.clearContent();
        }
        
        /**
        * 设置某一条数据是否高亮显示
        * @param	index
        * @param	active
        */
        public function setDatasetActivity(index:uint, active:Boolean):void 
        {
        }
        
        /**
        * 设置某一条数据是否显示
        * @param	index
        * @param	active
        */
        public function setDatasetVisibility(index:uint, visible:Boolean):void 
        {
        }
        
        /**
        * 根据点的数值返回对应的坐标
        * @param	idx
        * @param	value
        * @return
        */
        public function chartToViewXY(idx:Number, value:Number):Point
        {
            return new Point();
        }
        
        /**
        * 根据视图上的坐标获得图表上对应的值
        * @param	x
        * @param	y
        * @return
        */
        public function viewToChartXY(x:Number, y:Number):Point
        {
            return new Point();
        }
        
        /**
        * 把自己放到舞台的正中间
        */
        public function makeSelfCenter():void 
        {
            if (stage) {
                var rect:Rectangle = getBounds(this);
                x = ((stage.stageWidth - rect.width) >> 1) - rect.left;
                y = ((stage.stageHeight - rect.height) >> 1) - rect.top;
            }
        }
        
        /**
         * 垃圾回收
         */
        override public function dispose():void 
        {
            chart = null;
            super.dispose();
        }
        
        /**
        * 重用或重新生成一个部件
        * @param	cls
        * @return
        */
        public function requestElement(cls:Class):ChartElement
        {
            return new cls();
        }

        /**
        * 监听事件
        */
        protected function addEventListeners():void {
            
        }
        
        /**
        * 移除事件
        */
        protected function removeEventListeners():void {
            
        }
        
        /**
        * 获取或改变视图的数据模块
        */
        public function set chartModel(value:ChartModel):void
        {
            dataModel = value;
        }
        
        public function get chartModel():ChartModel
        {
            return dataModel as ChartModel;
        }
        
        public function get elements():Vector.<ChartElement> { return _elements.concat(); }
        
        override protected function get defaultStyles():Object { 
            return {
                'backgroundColor'   : '#FFFFFF',
                'valueLabelFormat'  : '*.#2'
            };
        }
        
        public function get isSmoothing():Boolean { return _isSmoothing; }
        
        /**
         * isSmoothing
         * true:移除事件监听，缓动过程中，不允许事件交互
         * false:添加事件监听
         */
        public function set isSmoothing(value:Boolean):void 
        {
            if (value == _isSmoothing)
            {
                return;
            }
            if (value)
            {
                removeEventListeners();
                dispatchChartUIEvent(ChartUIEvent.SMOOTHING_START, null);
            }else 
            {
                addEventListeners();
                dispatchChartUIEvent(ChartUIEvent.SMOOTHING_END, null);
            }
            _isSmoothing = value;
        }
        
        public function get isDragging():Boolean 
        {
            return _isDragging;
        }
        
        public function set isDragging(value:Boolean):void 
        {
            if (_isDragging != value)
            {
                _isDragging = value;
                //图表进行过了拖拽，停止拖拽时，进行图表重绘。主要应用在折线图，是否添加Dot上，为了提高效率。
                if (!value)
                {
                    updateNow();
                }
            }
        }
                
        /**
        * 分发ChartUIEvent事件
        * @param	type
        * @param	data
        */
        protected function dispatchChartUIEvent(type:String,data:Object):void 
        {
            var evt:ChartUIEvent = new ChartUIEvent(type, data);
            dispatchEvent(evt);
        }
    }

}
