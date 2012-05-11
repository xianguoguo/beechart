package bee.chart.demo 
{
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.scalerect.ScaleRect;
    import bee.chart.elements.scalerect.ScaleRectData;
    import bee.chart.elements.tooltip.Tooltip;
	import flash.display.Sprite;
    import flash.geom.Rectangle;
	
	/**
    * ...
    * @author jianping.shenjp
    */
    public class ScaleRectTest extends Sprite 
    {
        
        public function ScaleRectTest() 
        {
            super();
            var _sliceDatas:Vector.<PieSliceData> = new Vector.<PieSliceData>();
            for (var i:int = 0; i < 10; i++) 
            {
                var data:PieSliceData = new PieSliceData();
                data.index  = i;
                data.name  = "test_" + i;
                //data.radian = radEach * value;
                //data.radius = radius;
                data.color  = 0xFFFFFF * Math.random();
                data.value = 100 * Math.random();
                //data.startRadian    = tempRotation / 180 * Math.PI;
                //data.pieSliceCanvasX = centerX;
                //data.pieSliceCanvasY = centerY;
                _sliceDatas.push(data);
            }
            var scaleRectdata:ScaleRectData = new ScaleRectData();
            scaleRectdata.sliceDatas = _sliceDatas;
            scaleRectdata.width = 100;
            scaleRectdata.height = 500;
			var rect:ScaleRect = new ScaleRect();
            rect.enableMouseTrack = true;
            rect.enableTooltip = true;
            rect.setModel(scaleRectdata);
            rect.state = "nromal";
            addChild(rect);
            var tooltip:Tooltip = Tooltip.instance;
			tooltip.bounds = new Rectangle(0, 0, 500, 500);
            addChild(tooltip);
            //trace("rect:",rect.width,rect.height);
        }
    }

}