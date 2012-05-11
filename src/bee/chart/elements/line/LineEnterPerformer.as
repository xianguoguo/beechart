package bee.chart.elements.line 
{
    import bee.abstract.CComponent;
    import bee.performers.ITransitionProgressUpdater;
    import bee.performers.TransitionPerformer;
    import com.greensock.easing.Back;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LineEnterPerformer extends TransitionPerformer
    {
        
        public function LineEnterPerformer(updater:ITransitionProgressUpdater=null) 
        {
            if (!updater) {
                updater = new LineEnterAnimation();
            }
            super(updater);
            easing = Back.easeOut;
        }
        
        override protected function shouldAnimate(host:CComponent, fromState:String, toState:String):Boolean 
        {
            return fromState === 'ready' && toState === 'normal';
        }
        
    }

}