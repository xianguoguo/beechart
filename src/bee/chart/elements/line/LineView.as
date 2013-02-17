package bee.chart.elements.line 
{
    import bee.chart.abstract.ChartElementView;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.elements.dot.Dot;
    import bee.chart.elements.dot.NullDot;
    import bee.chart.elements.line.Line;
    import bee.chart.elements.line.LineData;
    import bee.chart.elements.line.LineView;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.printers.IStatePrinter;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import com.greensock.TweenLite;
    /**
    * ...
    * @author hua.qiuh
    */
    public class LineView extends ChartElementView
    {
        static public var defaultStatePrinter:IStatePrinter = new LineSimplePrinter();
        static public var defaultPerformer:IPerformer = SimplePerformer.instance;
        
        public var dotPositions:Vector.<Point>;
        
        private var tweens:Vector.<TweenLite>;//存储缓动类，用于当用户在缓动过程中变换数据时，将之前的滑动清除
        
        public function LineView(host:Line) 
        {
            super(host);
            
            skin.statePrinter = defaultStatePrinter;
            skin.performer = defaultPerformer;
            
            tweens = new Vector.<TweenLite>();
            mouseChildren = false;
            state = 'ready';
        }
        
        override protected function get defaultStyles():Object { 
            return {
                'thickness'         : '2',
                'transDuration'     : '.5',
                'dropShadow'        : 'none'
            };
        }
        
        override public function dispose():void 
        {
            if (dotPositions)
            {
                dotPositions.length = 0;
                dotPositions = null;
            }
            if (tweens)
            {
                tweens.length = 0;
                tweens = null;
            }
            super.dispose();
        }
        
        public function getCurrentDotPositions():Vector.<Point> 
        {
            var dots:Vector.<Dot> = (host as Line).dots;
            var points:Vector.<Point> = new Vector.<Point>();
            var pt:Point;
            for each (var dot:Dot in dots) 
            {
                if (dot is NullDot)
                {
                    pt = null;
                }else
                {
                    pt = new Point(dot.x, dot.y);
                }
                points.push(pt);
            }
            return points;
        }
        
        public function recordDotPositions(dots:Vector.<Point>):void 
        {
            dotPositions = dots;
        }

        override public function smoothUpdate(state:String = null, context:DisplayObjectContainer = null):void 
        {
            super.smoothUpdate(state, context);
            if (!chart.isTimeline())
            {
                tweenPositions();
            }
            else
            {
                printState();
            }
        }
        
        private function tweenPositions():void 
        {
            var lineData:LineData = this.dataModel as LineData;
            var lnv:LineView = this;
            var line:Line = lnv.host as Line;
            var chartview:ChartViewer = lnv.chart.view as ChartViewer;
            if (chartview.isSmoothing && tweens)
            {
                for each (var tween:TweenLite in tweens) 
                {
                    //这里不能使用 killTweensOf(target,true)。
                    //原因有二：
                    //1.快速切换legend过程中，必定会继续执行之前的onUpdate和onComplete,会导致线条的显示与否与实际不符；
                    //2.快速切换legend，变化不平滑，影响体验；
                    TweenLite.killTweensOf(tween.target);
                    tween = null;
                }
            }
            tweens.length = 0;
            var dotsPosBeforeTween:Vector.<Point> = getCurrentDotPositions();
            var dotsPosAfterTween:Vector.<Point> = lineData.dotPositions;
            if (dotsCountChanged())
            {
                printState();
                return;
            }
            
            dealWithNaNDots(dotsPosBeforeTween, dotsPosAfterTween);
            dealWithInvisibleDots(dotsPosAfterTween, line);
            dealWithLineVisible(lnv, line);
            
            if (!needRedrawForDots(dotsPosBeforeTween,dotsPosAfterTween))
            {
                return;
            }
            var loopNum:int = dotsPosAfterTween.length;
            var before_point:Point;
            var after_point:Point;
            var isStartTween:Boolean = true;
            var easeCnf:Object;
            for (var j:int = 0; j < loopNum; j++) 
            {
                before_point = dotsPosBeforeTween[j];
                after_point = dotsPosAfterTween[j];
                if (shouldDoTween(before_point,after_point))
                {
                    easeCnf = {
                        x:after_point.x,
                        y:after_point.y
                    }
                    
                    if (isStartTween)
                    {
                        isStartTween = false;  
                        easeCnf.onStart = function():void
                        {
                            state = 'normal';
                            chartview.isSmoothing = true;
                        };
                                
                        easeCnf.onUpdate = function():void
                        {
                            lnv.recordDotPositions(dotsPosBeforeTween);
                            onUpdate();
                        };
                                
                        easeCnf.onComplete = function():void
                        {
                            lnv.recordDotPositions(null);
                            onUpdate();
                            chartview.isSmoothing = false;
                        };
                    }
                    tweens.push(TweenLite.to(before_point , 1 , easeCnf));
                }
            }
            
            function dotsCountChanged():Boolean
            {
                return dotsPosBeforeTween.length != dotsPosAfterTween.length;
            }
        }
        
        /**
         * 若前后点全部相同则无需重绘，否则就重绘
         * @param	dotsPosBeforeTween
         * @param	dotsPosAfterTween
         * @return
         */
        private function needRedrawForDots(dotsPosBeforeTween:Vector.<Point>, dotsPosAfterTween:Vector.<Point>):Boolean 
        {
            if (dotsPosBeforeTween.length != dotsPosAfterTween.length)
            {
                return true;
            }
            var loopNum:int = dotsPosBeforeTween.length;
            var before_point:Point;
            var after_point:Point;
            for (var i:int = 0; i < loopNum; i++) 
            {
                before_point = dotsPosBeforeTween[i];
                after_point = dotsPosAfterTween[i];
                if (!isEqualsByPoint(before_point, after_point))
                {
                    return true;
                }
            }
            return false;
        }
        
        private function isEqualsByPoint(before_point:Point, after_point:Point):Boolean 
        {
            if (before_point == null && after_point == null)
            {
                return true;
            }
            if (before_point != null && after_point != null)
            {
                if (before_point.equals(after_point))
                {
                    return true;
                }
            }
            return false;
        }
        
        /**
         * 针对前后点为null的情况作处理，防止缓动发生问题
         * @param	dotsPosBeforeTween
         * @param	dotsPosAfterTween
         */
        private function dealWithNaNDots(dotsPosBeforeTween:Vector.<Point>, dotsPosAfterTween:Vector.<Point>):void 
        {
            var numloop:int = dotsPosBeforeTween.length;
            var before_point:Point;
            var after_point:Point;
            for (var i:int = 0; i < numloop; i++) 
            {
                before_point = dotsPosBeforeTween[i];
                after_point = dotsPosAfterTween[i];
                if (after_point==null && before_point!=null)
                {
                    dotsPosBeforeTween[i] = null;
                }else if (after_point!=null && before_point==null)
                {
                    dotsPosBeforeTween[i] = after_point;
                }
            }
        }
        
        private function dealWithInvisibleDots(dotsPosAfterTween:Vector.<Point>, line:Line):void
        {
            if (!line.lineVisible)
            {
                for each (var pt:Point in dotsPosAfterTween) 
                {
                    if (pt)
                    {
                        pt.y = 0;
                    }
                }
            }
        }
        
        private function dealWithLineVisible(lnv:LineView, line:Line):void 
        {
            lnv.visible = true;
            if (!line.lineVisible)
            {
                tweens.push(
                    TweenLite.to(lnv , 1 ,
                        {
                            alpha:0,
                            onComplete:function():void
                                    {
                                        lnv.visible = false;
                                        lnv.alpha = 0;
                                    }
                        }
                    )
                );
            }else
            {
                lnv.visible = true;
                lnv.alpha = 1;
            }
        }
        
        private function shouldDoTween(before_point:Point, after_point:Point):Boolean 
        {
            var result:Boolean = false;
            if (before_point != null && after_point != null)
            {
                result = true;
            }
            return result;
        }
        
        private function onUpdate():void
        {
            printState();
        }
        
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Event Handlers
        
    }

}