package bee.chart.util 
{
    import bee.chart.abstract.Chart;
    import bee.chart.elements.axis.AxisView;
    import bee.util.StyleUtil;
    import flash.geom.Point;
	/**
    * ...
    * @author jianping.shenjp
    */
    public class CartesianUtil 
    {
        
        static public function adjustPointToFitChart(beforePos:Point, chart:Chart, adjustDistX:Number=Number.NaN, adjustDistY:Number=Number.NaN):Point 
        {
            var y:Number = beforePos.y;
            if(!isNaN(adjustDistY)){
                y = Math.max( -chart.chartHeight - adjustDistY, y);
                y = Math.min(y, adjustDistY);
            }
            
            var x:Number = beforePos.x;
            if (!isNaN(adjustDistX)) {
                x = Math.max( -adjustDistX, x);
                x = Math.min(x, chart.chartWidth + adjustDistX);
            }
            return new Point(x, y);
        }
        
        static public function needFixForLine(chart:Chart):Boolean 
        {
            return chart.getStyle('fix') == 'auto';
        }
        
        static public function needFixForAxis(chart:Chart, ax:AxisView):Boolean 
        {
            return chart.getStyle('fix') == 'auto' && StyleUtil.getNumberStyle(ax, 'labelRotation') == 0;
        }
    }
}