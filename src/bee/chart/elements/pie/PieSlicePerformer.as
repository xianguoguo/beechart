package bee.chart.elements.pie 
{
    import bee.abstract.IStatesHost;
    import bee.chart.assemble.pie.PieChartViewer;
    import bee.chart.elements.scalerect.ScaleRect;
    import bee.controls.label.Label;
    import bee.performers.IPerformer;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import com.greensock.easing.Strong;
    import com.greensock.TweenLite;
    /**
     * Pie的状态展现类
     * @author jianping.shenjp
     */
    public class PieSlicePerformer implements IPerformer
    {
        static private const SHOW_TIME:Number = 1;
        
        public function performTransition(host:IStatesHost, fromState:String, toState:String):void 
        {
            var view:PieSliceView   = host as PieSliceView;
            var content:Sprite          = view.content;
            var oldX:Number         = content.x;
            var oldY:Number         = content.y;
            host.printState(toState);
            var moveToX:Number      = content.x;
            var moveToY:Number      = content.y;
            var delayTime:Number = 0.0;
            
            content.x = oldX;
            content.y = oldY;
            
            TweenLite.to(content, SHOW_TIME, { 
                x       : moveToX, 
                y       : moveToY, 
                ease    : Strong.easeOut,
                delay   : toState === PieSliceStates.HIGH_LIGHT ? .2 : 0
            });
            
            var label:Label = view.label;
            var line:PieLine = view.line;
            var detailView:DisplayObject = view.detailView;
            
            if (label)
            {
                label.alpha = 1;
            }
            
            if (line)
            {
                line.alpha = 1;
            }
            
            if (detailView)
            {
                detailView.alpha = 0;
            }
            if ((fromState == PieSliceStates.DETAIL || fromState == PieSliceStates.BLUR) && toState == PieSliceStates.NORMAL )
            {
                delayTime = PieChartViewer.ROTATION_SHOW_TIME * 2;
                if (label)
                {
                    label.alpha = 0;
                    tweenAlphaTo(label, 1, delayTime);
                }
                
                if (line)
                {
                    line.alpha = 0;
                    tweenAlphaTo(line, 1, delayTime);
                }
                
                if (detailView)
                {
                    detailView.alpha = 1;
                    tweenAlphaTo(detailView, 0, delayTime);
                }
            }
            
            if (toState == PieSliceStates.DETAIL || toState == PieSliceStates.BLUR)
            {
                if (label)
                {
                    tweenAlphaTo(label, 0);
                }
                if (line)
                {
                    tweenAlphaTo(line, 0);
                }
                if (detailView)
                {
                    tweenAlphaTo(detailView, 1, PieChartViewer.ROTATION_SHOW_TIME);
                }
            }
        }
        
        private function tweenAlphaTo(target:DisplayObject, alpha:Number, delay:Number = 0):void
        {
            TweenLite.to(target, SHOW_TIME, { 
                alpha:alpha,
                delay:delay
            });
        }
        
        
    }

}