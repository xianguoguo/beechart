package bee.chart.elements.bar 
{
	import bee.abstract.IStatesHost;
	import bee.chart.abstract.ChartElementView;
	import flash.display.Sprite;
	import com.greensock.TweenLite;
    
	/**
    * ...
    * @author jianping.shenjp
    */
    public class VisibleToggler 
    {
        static public function toggleVisibleState(host:IStatesHost, fromState:String, toState:String):void 
        {
            const SHOW_TIME:Number = 0.5;
            var view:ChartElementView   = host as ChartElementView;
            var content:Sprite = view.content;
            if (toState === 'visible') {
                TweenLite.to(content, SHOW_TIME, {
                    alpha: 1,
                    onStart:function():void
                    {
                        content.visible = true;
                    }
                });
            } else if(toState === 'invisible') {
                TweenLite.to(content, SHOW_TIME, {
                    alpha: 0,
                    onComplete:function():void
                    {
                        content.visible = false;
                    }
                });
            }
        }
    }
}