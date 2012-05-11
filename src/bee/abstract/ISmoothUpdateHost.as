package bee.abstract
{
    import flash.display.DisplayObjectContainer;

    /**
     * ...
     * @author jianping.shenjp
     */
    public interface ISmoothUpdateHost
    {
        function smoothUpdate(state:String=null, context:DisplayObjectContainer=null):void;
    }
}