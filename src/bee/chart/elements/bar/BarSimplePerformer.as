package bee.chart.elements.bar
{
    import bee.abstract.IStatesHost;
    import bee.performers.IPerformer;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class BarSimplePerformer implements IPerformer
    {
        /** 当状态发生变化时调用 **/
        public function performTransition(host:IStatesHost, fromState:String, toState:String):void
        {
            host.printState(toState);
            VisibleToggler.toggleVisibleState(host, fromState,  toState);
        }
    }
}