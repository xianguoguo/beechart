package bee.printers 
{
    import bee.abstract.IStatesHost;
    import flash.display.DisplayObjectContainer;
    
    /**
    * ...
    * @author jianping.shenjp
    */
    public interface IStatePrinterWithUpdate extends IStatePrinter
    {
        function smoothUpdate(host:IStatesHost,state:String, context:DisplayObjectContainer):void;
    }
    
}