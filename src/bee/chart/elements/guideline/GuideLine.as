package bee.chart.elements.guideline
{
	import cn.alibaba.core.IDisposable;
	import cn.alibaba.util.ColorUtil;
    import bee.abstract.CComponent;
	import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartElement;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.printers.IStatePrinter;
	import flash.display.Graphics;
	import flash.display.Shape;
    import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class GuideLine extends CComponent
	{
        
        static public var defaultStatePrinter:IStatePrinter = new GuideLineSimplePrinter;
        static public var defaultPerformer:IPerformer = SimplePerformer.instance;
        private var _isTweening:Boolean = false;
        
		public function GuideLine()
		{
            skin.statePrinter   = defaultStatePrinter;
            skin.performer      = defaultPerformer;
		}
        
        public function hide():void 
        {
            TweenLite.killTweensOf(this, true);
            TweenLite.to(this, 1, 
                {
                    alpha:0
                }
            ); 
            _isTweening = false;
        }
        
        public function show():void 
        {
            if ( alpha < 1 && !_isTweening) 
            {
                TweenLite.killTweensOf(this, true);
                TweenLite.to(this, 1, 
                    {
                        alpha:1,
                        onStart:function():void
                        {
                            _isTweening = true;
                        },
                        onComplete:function():void
                        {
                            _isTweening = false;
                            alpha = 1;
                        }
                    }
                );
            }
        }
        
        override protected function get defaultStyles():Object 
        {
            return {
                color : '#BBBBBB',
                alpha : 1,
                thickness : 1
            };
        }
	}

}
