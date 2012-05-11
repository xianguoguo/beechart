package bee.chart.assemble.line.timeline
{
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.CartesianChartViewer;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.assemble.line.LineChartPrinter;
    import bee.chart.assemble.line.LineChartViewer;
    import bee.chart.elements.cursor.Cursor;
    import bee.chart.elements.cursor.CursorManager;
	import bee.chart.elements.timeline.RangeLocationEvent;
    import bee.chart.elements.timeline.TimeLine;
    import bee.chart.elements.timeline.TimeLineModel;
	import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class TimeLineChartPrinter extends LineChartPrinter
    {
        
        public function TimeLineChartPrinter()
        {
            super();
        
        }
        
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
                drawLines(_viewer as LineChartViewer, context);
                drawTimeline(host, w, h, context, rect);
                addCustomCursor(viewer, context);
                //drawLegend(viewer, w, h, context, rect);
                viewer.makeSelfCenter();
            }
        }
        
        private function drawTimeline(viewer:ChartViewer, w:Number, h:Number, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var data:CartesianChartData = viewer.chartModel.data as CartesianChartData;
            var model:TimeLineModel = new TimeLineModel();
            model.dataIndexRange = data.dataIndexRange;
            model.labels = data.allLabels;
            model.dataSets = data.allSets;
			model.chartPosFunction = viewer.chartToViewXY;
			model.chartHeight = viewer.chartModel.chartHeight;
            var timeLine:TimeLine = new TimeLine();
			timeLine.name = 'timeline';
			timeLine.setStyles(_viewer.styleSheet.getStyle('timeline'));
			model.width = viewer.chartModel.chartWidth;
            model.height = StyleUtil.getNumberStyle(timeLine,"height");
            timeLine.setModel(model);
            viewer.addElement(timeLine);
            model.dispatchBtnLocationEvent();
            context.addChild(timeLine);
            timeLine.y = rect.bottom;
			model.dispatchEvent(new RangeLocationEvent(RangeLocationEvent.SET_ONE_TIME_RANGE, Number.NaN, Number.NaN, true));
			viewer.updateNow();
		}
        
        private function addCustomCursor(viewer:CartesianChartViewer, context:DisplayObjectContainer):void
        {
            CursorManager.getInstance().addCursorTo(context);
        }
    }

}