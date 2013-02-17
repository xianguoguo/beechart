package bee.chart.elements.scalerect 
{
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartElementView;
    import bee.chart.elements.scalerect.ColorRect;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.ChartUtil;
    import flash.events.MouseEvent;
	
	/**
    * ...
    * @author jianping.shenjp
    */
    public class ScaleRectView extends ChartElementView 
    {
        
        private var _colorRects:Vector.<ColorRect>;
        
        public function ScaleRectView(host:ChartElement) 
        {
            super(host);
            _colorRects = new Vector.<ColorRect>();
        }
        
        override protected function initView():void 
        {
            super.initView();
            if (scaleRect.enableMouseTrack)
            {
                addEventListeners();
            }
            skin.statePrinter = new ScaleRectSimplePrinter();
        }
        
        override public function dispose():void 
        {
            removeEventListeners();
            clearColorRects();
            _colorRects = null;
            super.dispose();
        }
        
        public function clearColorRects():void
        {
            for each (var colorRect:ColorRect in _colorRects) 
            {
                colorRect.dispose();
                colorRect = null;
            }
			if (_colorRects)
			{
				_colorRects.length = 0;
			}
        }
        
        private function addEventListeners():void 
        {
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        }
        
        private function removeEventListeners():void 
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        }
        
        private function get scaleRect():ScaleRect
        {
            return host as ScaleRect;
        }
        
        private function mouseMoveHandler(e:MouseEvent):void 
        {
            var colorRect:ColorRect = getHitColorRect(e);
            if (colorRect)
            {
                var tip:Tooltip = Tooltip.instance;
                tip.text = getTip(colorRect);
                tip.state = 'normal';
                tip.goto(e.stageX, e.stageY);
            }
        }
        
        private function getHitColorRect(e:MouseEvent):ColorRect
        {
            var result:ColorRect;
            for each (var colorRect:ColorRect in _colorRects) 
            {
				if (colorRect.hitTestPoint(e.stageX, e.stageY, false))
                {
                    result = colorRect;
                    break;
                }
            }
            return result;
        }
        
        private function mouseOutHandler(e:MouseEvent):void 
        {
            hideTooltip();
        }
        
        private function getTip(colorRect:ColorRect):String 
        {
            var result:String = "";
            var data:ColorRectData = colorRect.model as ColorRectData;
            result = data.name + "\n" + ChartUtil.getPercentStr(data.percent);
            result = "<b><font color='" + '#000000' + "'>" + result + "</font></b>";
            return result;
        }
        
        private function hideTooltip():void 
        {
            if(scaleRect.enableTooltip){
                ChartUtil.hideTooltip();
            }
        }
        
        
        public function get colorRects():Vector.<ColorRect> { return _colorRects; }
        
        public function set colorRects(value:Vector.<ColorRect>):void 
        {
            _colorRects = value;
        }
    }

}