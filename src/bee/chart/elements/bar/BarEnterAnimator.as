package bee.chart.elements.bar 
{
    import bee.abstract.IStatesHost;
    import bee.performers.IPerformer;
    import flash.display.Sprite;
    import com.greensock.easing.Back;
    import com.greensock.TweenLite;
    
    /**
    * ...
    * @author hua.qiuh
    */
    public class BarEnterAnimator implements IPerformer 
    {
        
        public function BarEnterAnimator()
        {
        }
        
        public function performTransition(host:IStatesHost, fromState:String, toState:String):void
        {
            if (!(host is Sprite))
            {
                return;
            }
            var view:BarView = host as BarView;
            //为初始动画服务
            if (fromState === null && toState === 'normal' && !(view.dataModel as BarModel).group) 
            {
                var bv:Sprite = host as Sprite;
                host.printState(toState);
                var easeConfig:Object = {
                    ease     : Back.easeOut,
                    delay    : Math.random() * 1
                };
                if(view.horizontal){
                    easeConfig.scaleX = 0;
                } else {
                    easeConfig.scaleY = 0;
                }
                TweenLite.from(bv, .5, easeConfig);
                
            } 
            //bar显示/隐藏
            else if (toState === 'visible' || toState === 'invisible')
            {
                VisibleToggler.toggleVisibleState(host, fromState, toState);
            }
            else{
                host.printState(toState);
            }
        }
    }
}