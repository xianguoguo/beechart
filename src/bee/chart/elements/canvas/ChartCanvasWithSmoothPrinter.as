package bee.chart.elements.canvas
{
	import bee.abstract.IStatesHost;
	import bee.chart.abstract.Chart;
	import bee.chart.util.CartesianUtil;
	import bee.printers.IStatePrinter;
	import bee.printers.IStatePrinterWithUpdate;
	import bee.printers.PrinterDecorator;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.greensock.TweenLite;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class ChartCanvasWithSmoothPrinter extends PrinterDecorator implements IStatePrinterWithUpdate
    {
        static public const LINE_MAX_MARGIN:int = 50;
        private var _oldhlines:Vector.<Shape>;
        private var _newhlines:Vector.<Shape>;
        private var _host:IStatesHost;
        private var _chart:Chart;
        private var _state:String;
        private var _context:DisplayObjectContainer;
        private var _tempLinesContainer:Sprite;
        private var maxVal:Number;
        private var minVal:Number;
        private var maxPt:Point;
        private var minPt:Point;
        private var difference:Number;
        private var h:Number;
        private var w:Number;

        //private var hlinesPos:Dictionary;

        public function ChartCanvasWithSmoothPrinter(basePrinter:IStatePrinter=null)
        {
            super(basePrinter);
        }

        public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            _host = host;
            _state = state;
            _context = context;
            _chart = (host as ChartCanvasView).chart;
            if (shouldTween())
            {
                if (getHlineContainer())
                {
                    renderStateWithOldLines();
                    saveNewLines();
                }
                animate();
            }
            else
            {
                renderState(host, state, context);
            }
        }

        private function shouldTween():Boolean
        {
            var hlineContainer:Sprite = getHlineContainer();
            var view:ChartCanvasView = _host as ChartCanvasView;
            var notTimeLine:Boolean = view && view.chart && view.chart.getStyle("chartType") != "timeline" ;
            return notTimeLine && ((hlineContainer && hlineContainer.numChildren > 0) || getBackgroundShape());
        }

        private function isOnlyBG():Boolean
        {
            var hlineContainer:Sprite = getHlineContainer();
            var bgsp:Shape = getBackgroundShape();
            return (hlineContainer == null) && (bgsp != null);
        }
        
        private function renderStateWithOldLines():void
        {
            saveOldLines();
            renderState(_host, _state, _context);
            restoreOldLines();
        }

        private function saveOldLines():void
        {
            _oldhlines = new Vector.<Shape>();
            _tempLinesContainer = new Sprite();
            var hlineContainer:Sprite = getHlineContainer();
            var numloop:int = hlineContainer.numChildren;
            var line:Shape;
            for (var i:int = numloop - 1; i >= 0; i--)
            {
                line = hlineContainer.getChildAt(i) as Shape;
                _oldhlines.push(line);
                _tempLinesContainer.addChild(line);
            }
            line = _oldhlines[_oldhlines.length-1];
            minVal = Number(line.name);
            minPt = new Point(line.x, line.y);
            
            line = _oldhlines[0];
            maxVal = Number(line.name);
            maxPt = new Point(line.x, line.y);
            
            difference = maxVal - minVal;
            h = maxPt.y - minPt.y;
            w = maxPt.x - minPt.x;
        }

        private function restoreOldLines():void
        {
            _context.addChild(_tempLinesContainer);
        }

        private function saveNewLines():void
        {
            _newhlines = new Vector.<Shape>();
            var newhlineContainer:Sprite = getHlineContainer();
            if (newhlineContainer && newhlineContainer.numChildren > 0)
            {
                var numloop:int = newhlineContainer.numChildren;
                var line:Shape;
                for (var i:int = 0; i < numloop; i++)
                {
                    line = newhlineContainer.getChildAt(i) as Shape;
                    _newhlines.push(line);
                }
            }
        }

        private function animate():void
        {
            if (getHlineContainer())
            {
				var line:Shape;
				for each (line in _oldhlines) 
				{
					fadeOutLine(line);
				}
				for each (line in _newhlines) 
				{
					fadeInLine(line);
				}
            }
            animateBackground();
        }
        
        private function animateBackground():void 
        {
            var bgsp:Shape = getBackgroundShape();
            if (bgsp)
            {
                if (isOnlyBG())
                {
                    renderState(_host, _state, _context);
                } else {
            
                    var alterBgSp:Shape = getAlterBackground();
                    if (alterBgSp)
                    {
                        alterBgSp.alpha = 0;
                        TweenLite.to(alterBgSp, 0.5, {
                            alpha: 1,
                            delay: 0.5
                        });
                    }
                
                }
            }
        }

        private function fadeOutLine(line:Shape):void
        {
            var afterPos:Point = getNewPosition(line);
            var pt:Point = adjustPointToFitChart(afterPos);
            TweenLite.to(line, 0.5, {
                x:pt.x,
                y:pt.y,
                alpha: 0
            });
        }

        private function onAnimateComplete():void
        {
            if (_tempLinesContainer != null)
            {
                if (_context.contains(_tempLinesContainer))
                {
                    _context.removeChild( _tempLinesContainer );
                }
                _tempLinesContainer = null;
                _oldhlines.length = 0;
                _newhlines.length = 0;
                _host = null;
                _state = null;
                _context = null;
                _chart = null;
            }
        }

        private function fadeInLine(line:Shape):void
        {
            var beforePos:Point = getBeforePos( line );
            var pt:Point = adjustPointToFitChart(beforePos);
            TweenLite.from(line, 0.5, {
                x: pt.x,
                y: pt.y,
                alpha: 0
            });
        }
        
        private function getNewPosition(line:Shape):Point 
        {
            var pt:Point = _chart.chartToViewXY(0, Number(line.name));
            if (isNormal(_host as ChartCanvasView)) {
                pt.x = 0;
            }else {
                pt.y = 0;
            }
            return pt;
        }
        
        private function getBeforePos(line:Shape):Point 
        {
            var value:Number = Number(line.name);
            var y:Number = minPt.y + (value-minVal) / difference * h;
            var x:Number = minPt.x + (value-minVal) / difference * w;
            return new Point( x, y );
        }

        private function getBackgroundShape():Shape
        {
            return _context.getChildByName(ChartCanvasView.BG_SHAPE_NAME) as Shape;
        }
        
        private function getAlterBackground():Shape 
        {
            return _context.getChildByName(ChartCanvasView.ALTER_BG_SHAPE_NAME) as Shape;
        }
        
        private function adjustPointToFitChart(pos:Point):Point
        {
            var adjustX:Number, adjustY:Number;
            if (isNormal(_host as ChartCanvasView)) {
                adjustX = Number.NaN;
                adjustY = LINE_MAX_MARGIN;
            } else {
                adjustX = LINE_MAX_MARGIN;
                adjustY = Number.NaN;
            }
            return CartesianUtil.adjustPointToFitChart( pos, _chart, adjustX, adjustY );
        }
        
        private function isNormal(view:ChartCanvasView):Boolean 
        {
            return view.getStyle('mode') === 'normal';
        }
        
        private function getHlineContainer():Sprite 
        {
            return _context.getChildByName('hline') as Sprite;
        }
    }

}