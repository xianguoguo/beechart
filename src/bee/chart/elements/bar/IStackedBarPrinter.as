package bee.chart.elements.bar 
{
    import flash.display.DisplayObjectContainer;
    
    /**
    * ...
    * @author hua.qiuh
    */
    public interface IStackedBarPrinter
    {
        function getBarIndexAt(x:Number, y:Number, context:DisplayObjectContainer):int;
    }
    
}