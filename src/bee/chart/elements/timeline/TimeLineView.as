package bee.chart.elements.timeline
{
    import cn.alibaba.util.DisplayUtil;
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartElementView;
    import bee.chart.abstract.ChartViewer;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class TimeLineView extends ChartElementView
    {
        
        private var _rangeSelector:RangeSelector;
        private var chartView:ChartViewer;
        
        public function TimeLineView(host:ChartElement)
        {
            super(host);
        }
        
        override protected function get defaultStyles():Object { 
            return {
                'smooth'         	 : true,
				'height' 		 	 : 50,
				'previewFillColor'	 : "#D7D7D7",//时间线预览区的颜色值
				'previewLineColor'	 : "#CCCCCC",//时间线预览区边框的颜色值
				'selectedFillColor'  : "#E5F1FE",//时间选区选中的颜色值
				'selectedLineColor'  : "#A2C2E2",//时间选区选中边框的颜色值
				'boardColor'		 : "#CCCCCC" //时间线预览区边框颜色值
            };
        }
        
        override protected function initView():void
        {
            super.initView();
            skin.statePrinter = new TimeLinePrinter();
            addScrollThumb();
            addEventListeners();
            if (chart)
            {
                chartView = chart.view as ChartViewer;
            }
        }
        
        override public function dispose():void
        {
            removeEventListeners();
            DisplayUtil.clearSprite(_rangeSelector);
            _rangeSelector = null;
            chartView = null;
            super.dispose();
        }
        
        /**
         * 重写update方法，调用updateNow方法，立即重绘。
         * 目的：立即重绘时间选择区已选区域，达到良好的体验。
         */
        override public function update():void 
        {
            needRedraw = false;
            updateNow();
        }
        
        public function get timeLineModel():TimeLineModel
        {
            return dataModel as TimeLineModel;
        }
        
        public function get rangeSelector():RangeSelector
        {
            return _rangeSelector;
        }
        
        private function addScrollThumb():void
        {
            _rangeSelector = new RangeSelector(new Rectangle(0, 0, timeLineModel.width, timeLineModel.height));
            addContent(_rangeSelector);
        }
        
        private function addEventListeners():void
        {
            addEventListener(DragEvent.DRAG, dragHandler);
        }
        
        private function removeEventListeners():void
        {
            removeEventListener(DragEvent.DRAG, dragHandler);
        }
        
        private function dragHandler(e:DragEvent):void
        {
            if (chartView)
            {
                chartView.isDragging = e.isDragging;
            }
        }
    }

}