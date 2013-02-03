package bee.chart.elements.axis
{
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.Chart;
    import bee.chart.util.CartesianUtil;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinterWithUpdate;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Point;
    import com.greensock.TweenLite;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class AxisWithSmoothPrinter extends AxisSimplePrinter implements IStatePrinterWithUpdate
    {
        static private const SHOW_TIME:Number = 0.5;
        private var maxVal:Number = 0.0;
        private var minVal:Number = 0.0;
        private var maxPt:Point = new Point();
        private var minPt:Point = new Point();
        private var _host:IStatesHost;
        private var _state:String;
        private var _context:DisplayObjectContainer;
        private var _tempLabelContainer:Sprite;
        private var _oldLabels:Vector.<Label>;
        private var difference:Number;
        private var h:Number;
        private var w:Number;
        static public const LABEL_MAX_MARGIN:int = 50;
        
        public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            this._context = context;
            this._state = state;
            this._host = host;
            
            if (shouldTween())
            {
                renderStateWithOldLabels();
                animate();
            } else {
                renderState(host, state, context);
            }
        }
        
        private function animate():void 
        {
            var label:Label;
            for each (label in _oldLabels) 
            {
                fadeOutLabel(label);
            }
            for each (label in this.labels) 
            {
                fadeInLabel(label);
            }
        }
        
        private function fadeOutLabel(label:Label):void 
        {
            var afterPos:Point = getAfterPos( label );
            var pt:Point = adjustPointToFitChart(afterPos);
            TweenLite.to( label, SHOW_TIME, {
                x: pt.x,
                y: pt.y,
                alpha: 0,
                onComplete: onLabelAnimationComplete
            });
        }
        
        private function onLabelAnimationComplete():void 
        {
            if ( _tempLabelContainer )
            {
                if (_context.contains(_tempLabelContainer))
                {
                    _context.removeChild( _tempLabelContainer );
                }
                DisplayUtil.clearSprite(_tempLabelContainer);
                _tempLabelContainer = null;
                _oldLabels.length = 0;
                _context = null;
                _state = null;
                _host = null;
            }
        }
        
        private function fadeInLabel(label:Label):void 
        {
            var beforePos:Point = getBeforePos( label );
            var pt:Point = adjustPointToFitChart(beforePos);
            TweenLite.from(label, SHOW_TIME, {
                x: pt.x,
                y: pt.y,
                alpha: 0
            });
        }
        
        private function adjustPointToFitChart(pos:Point):Point
        {
            var chart:Chart = (_host as AxisView).chart;
            var adjustX:Number, adjustY:Number;
            if (isVertical(_host as AxisView)) {
                adjustX = Number.NaN;
                adjustY = LABEL_MAX_MARGIN;
            } else {
                adjustX = LABEL_MAX_MARGIN;
                adjustY = Number.NaN;
            }
            return CartesianUtil.adjustPointToFitChart( pos, chart, adjustX, adjustY );
        }
        
        private function isVertical(axis:AxisView):Boolean 
        {
            var dir:uint = (axis.dataModel as AxisData).direction;
            return dir == AxisDirection.UP || dir == AxisDirection.DOWN;
        }
        
        private function getAfterPos( label:Label ):Point 
        {
            return getNewPosition( label );
        }
        
        private function getBeforePos( label:Label ):Point 
        {
            return backToBefore( label );
        }
        
        private function backToBefore( label:Label ):Point
        {
            var value:Number = getNumber(label.text);
            var x:Number=label.x;
            var y:Number=label.y;
            var view:AxisView = _host as AxisView;
            var axis:Axis = view.host as Axis;
            if (axis.direction == AxisDirection.LEFT || axis.direction == AxisDirection.RIGHT)
            {
                x = minPt.x + (value-minVal) / difference * w;
            }else {
                y = minPt.y + (value-minVal) / difference * h;
            }
            return new Point( x, y );
        }
        
        private function renderStateWithOldLabels():void 
        {
            saveOldLabels();
            renderState(_host, _state, _context);  //min, max value is changed
            restoreOldLabels();
        }
        
        private function saveOldLabels():void 
        {
            _tempLabelContainer = new Sprite();
            var label:Label;
            for each(label in labels)
            {
                _tempLabelContainer.addChild( label );
            }
            _oldLabels = labels.concat();
            label = labels[labels.length -1];
            minVal = getNumber( label.text );
            minPt = new Point(label.x, label.y);
            
            label = labels[0];
            maxVal = getNumber( label.text );
            maxPt = new Point(label.x, label.y);
            difference = maxVal - minVal;
            h = maxPt.y - minPt.y;
            w = maxPt.x - minPt.x;
        }
        
        private function restoreOldLabels():void 
        {
            _context.addChild( _tempLabelContainer );
        }
        
        private function getNewPosition(label:Label):Point 
        {
            return getLabelPosition(label,_host as AxisView);
        }

        private function shouldTween():Boolean
        {
            var axisView:AxisView = _host as AxisView;
            var isTimeLine:Boolean = axisView.chart.getStyle("chartType") == "timeline" ;
            return AxisData(axisView.dataModel).isValueAxis && labels && labels.length > 0 && !isTimeLine; 
        }
    }

}