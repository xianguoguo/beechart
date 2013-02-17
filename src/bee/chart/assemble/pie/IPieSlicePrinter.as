package bee.chart.assemble.pie 
{
    import bee.chart.elements.pie.PieSliceView;
    
    /**
    * ...
    * @author hua.qiuh
    */
    public interface IPieSlicePrinter 
    {
        function updateLabelAndLinePos(view:PieSliceView):void;
    }
    
}