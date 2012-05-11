package bee.chart.assemble.pie
{
    import bee.chart.abstract.Chart;
    import bee.chart.elements.pie.PieSlice;

    /**
     * ...
     * @author jianping.shenjp
     */
    public interface IGetoutJam
    {
        function arrangeSliceLabels(chart:Chart, pieSlices:Vector.<PieSlice>):void;
    }
}