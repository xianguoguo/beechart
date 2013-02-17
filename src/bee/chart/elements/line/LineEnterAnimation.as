package bee.chart.elements.line 
{
    import cn.alibaba.util.ColorUtil;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.util.LineUtil;
    import bee.util.StyleUtil;
    import flash.display.DisplayObject;
    import bee.abstract.CComponent;
    import bee.performers.ITransitionProgressUpdater;
    import flash.display.Graphics;
    import flash.geom.Point;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LineEnterAnimation implements ITransitionProgressUpdater
    {
        
        private var _dots:Vector.<Point>;
        private var _lineColor:uint;
        private var _lineThickness:Number;
        private var _lineAlpha:Number;
        private var _segements:uint;
        
        /* INTERFACE cn.alibaba.yid.performers.ITransitionProgressUpdater */
        
        public function prepare(host:CComponent, fromView:DisplayObject, toView:DisplayObject):void
        {
            toView.visible = false;
            fromView.visible = false;
            
            var line:LineView   = host as LineView;
            var data:LineData   = host.dataModel as LineData;
            _dots               = data.dotPositions;
            _lineAlpha          = StyleUtil.getNumberStyle(host, 'alpha', 1);
            _lineColor          = StyleUtil.getColorStyle(host);
            _lineThickness      = StyleUtil.getNumberStyle(host, 'thickness');
            _segements          = host.getStyle('lineMethod') == 'curve' ? 10 : 1;
            
        }
        
        public function updateProgress(progress:Number, host:CComponent, fromView:DisplayObject, toView:DisplayObject):void
        {
            var tmpDots:Vector.<Point> = new Vector.<Point>();
            var pt:Point, i:uint = 0;
            var y0:Number = 0;
            var g:Graphics = host.content.graphics;
            
            
            g.clear();
            g.lineStyle(_lineThickness, _lineColor, _lineAlpha);
            
            for each(var dot:Point in _dots) {
                if (dot)
                {
                    pt = dot.clone();
                    if(i> 0 && i<_dots.length-1){
                        pt.y = y0 + ((progress - 0.5) * 2 - 1) * 100 + (progress - 0.5) * 2 * (dot.y - y0);
                    }
                    tmpDots.push(pt);
                } else {
                    tmpDots.push(null);
                }
                i++;
            }
            
            LineUtil.curveThrough(g, tmpDots, _segements);
        }
        
        public function dispose():void
        {
            _dots = null;
        }
        
    }

}