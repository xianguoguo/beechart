package bee.chart.elements.timeline
{
	import bee.chart.elements.cursor.Cursor;
	import bee.chart.elements.cursor.CursorManager;
	import flash.display.Sprite;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class TimeLineTest extends Sprite
    {

        public function TimeLineTest()
        {
			CursorManager.getInstance().addCursorTo(this);
            var model:TimeLineModel = new TimeLineModel();
            model.width = 600;
            model.height = 100;
            var timeline:TimeLine = new TimeLine();
            timeline.setModel(model);
            addChild(timeline);
			timeline.x = timeline.y = 100;

        }

    }

}