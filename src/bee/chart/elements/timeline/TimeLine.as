package bee.chart.elements.timeline
{
    import bee.chart.abstract.ChartElement;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class TimeLine extends ChartElement
    {
        public function TimeLine()
        {
            setView(new TimeLineView(this));
            setModel(new TimeLineModel());
        }
        
        override protected function initController():void
        {
            super.initController();
            addEventListener(RangeLocationEvent.RANGE_LOCATION, forwardLocatoinEvent);
            if (timeLineModel)
            {
                timeLineModel.addEventListener(RangeLocationEvent.SET_RANGE_LOCATION, setLocationHandler);
            }
        }
        
        override public function dispose():void
        {
            if (timeLineModel)
            {
                timeLineModel.removeEventListener(RangeLocationEvent.SET_RANGE_LOCATION, setLocationHandler);
            }
            removeEventListener(RangeLocationEvent.RANGE_LOCATION, forwardLocatoinEvent);
            super.dispose();
        }
        
        public function get timeLineModel():TimeLineModel
        {
            return model as TimeLineModel;
        }
        
        private function setLocationHandler(e:RangeLocationEvent):void
        {
            (view as TimeLineView).rangeSelector.dispatchEvent(e);
        }
        
        private function forwardLocatoinEvent(e:RangeLocationEvent):void
        {
            timeLineModel.dispatchEvent(e);
        }
    }

}