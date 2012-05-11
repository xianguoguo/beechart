package bee.chart.elements.tooltip 
{
    import bee.abstract.CComponent;
    import bee.abstract.IStatesHost;
    import bee.performers.ITransitionProgressUpdater;
    import bee.performers.TransitionPerformer;
    import com.greensock.TweenLite;
	/**
    * ...
    * @author hua.qiuh
    */
    public class TooltipTransitionPerformer extends TransitionPerformer
    {
        
        public function TooltipTransitionPerformer(updater:ITransitionProgressUpdater=null) 
        {
            super(updater);
        }
        
        override protected function shouldAnimate(host:CComponent, fromState:String, toState:String):Boolean 
        {
            return true;
        }
        
        override public function performTransition(host:IStatesHost, fromState:String, toState:String):void 
        {
            super.performTransition(host, fromState, toState);
            
            var view:TooltipView = host as TooltipView;
            if (view && view.chart) {
                hideTip(view);
            }
        }
        
        private function hideTip(view:TooltipView):void 
        {
            var duration:Number = Number(view.getStyle('transDuration')) || 0.5;
            var x:Number = view.x;
            TweenLite.to( view, duration, {
                x: x > view.chart.chartWidth >> 1 ? x - 20 : x + 20
            });
        }
    }
}