package bee.chart.assemble.line 
{
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartStates;
    import bee.chart.elements.line.Line;
    import bee.chart.elements.line.LineEnterPerformer;
	import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class LineChartEnterAnimator implements IPerformer 
    {
        /* INTERFACE cn.alibaba.yid.performers.IPerformer */
        
        public function performTransition(host:IStatesHost, fromState:String, toState:String):void
        {
            var viewer:LineChartViewer = host as LineChartViewer;
            viewer.printState(toState);
            
            var toAnimate:Boolean = toState === ChartStates.NORMAL;
            var pfm:IPerformer = SimplePerformer.instance;
            for each(var el:ChartElement in viewer.elements)
            {
                if (el is Line) {
                    if(toAnimate){
                        el.skin.performer = new LineEnterPerformer();
                        el.state = 'ready';
                        el.state = 'normal';
                    } else {
                        el.skin.performer = pfm;
                        el.state = 'normal';
                    }
                }
            }
        }
        
    }

}