package bee.chart.elements.axis 
{
    
    /**
    * ...
    * @author hua.qiuh
    */
    public interface IAxisWithLabelPrinter 
    {
        function highlightLabelAt(host:AxisView, index:int):void;
        function clearHighlightLabel(host:AxisView):void;
    }
    
}