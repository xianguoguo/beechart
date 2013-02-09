package bee.chart.elements.canvas 
{
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.Chart;
    import bee.chart.util.LineUtil;
    import bee.printers.IStatePrinter;
    import bee.printers.PrinterDecorator;
    import bee.util.StyleUtil;
    import flash.display.CapsStyle;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Point;
    
	/**
    * 具有横线、竖线和小格填充的图表背景
    * @author hua.qiuh
    */
    public class ChartCanvasWithGridPrinter extends PrinterDecorator implements IStatePrinter
    {
        
        private var priLinesContainer:Sprite;
        private var canvasView:ChartCanvasView;
        
        public function ChartCanvasWithGridPrinter(basePrinter:IStatePrinter=null) 
        {
            super(basePrinter);
        }
        
        override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            super.renderState(host, state, context);
            
            canvasView = host as ChartCanvasView;
            
            if (canvasView && canvasView.chart) {
                
                var chart:Chart             = canvasView.chart;
                var data:CartesianChartData = chart.data as CartesianChartData;
                var sp:Shape                = getBackgroundShape(context);
                var grph:Graphics           = sp.graphics;
                var yTicks:Vector.<Number>  = data.yTicks;
                var gridThickness:Number    = StyleUtil.getNumberStyle(canvasView, 'gridThickness');
                var gridColor:uint          = StyleUtil.getColorStyle(canvasView, 'gridColor');
                var gridAlpha:Number        = StyleUtil.getNumberStyle(canvasView, 'gridAlpha', 1);
                
                var color:uint              = StyleUtil.getColorStyle(canvasView, 'priLineColor');
                var alpha:Number            = StyleUtil.getNumberStyle(canvasView, 'priLineAlpha', gridAlpha);
                var thickness:Number        = Number(canvasView.getStyle('priLineThickness')) || gridThickness;
                var horizontal:Boolean      = canvasView.getStyle('mode') === 'horizontal';
                var drawBorder:Boolean      = StyleUtil.getNumberStyle(canvasView, 'borderThickness') > 0;
                var w:Number                = chart.chartWidth;
                var h:Number                = chart.chartHeight;
                var pt:Point, x:Number, y:Number, dashed:Boolean;
                
                /**
                * 横线
                */
                priLinesContainer = new Sprite();
                priLinesContainer.name = "hline";
                var line:Shape;
                var g:Graphics;
                dashed = canvasView.getStyle('priLineStyle') === 'dashed';
                for each (var tick:Number in yTicks) {
                    pt = chart.chartToViewXY(0, tick);
                    x = pt.x;
                    y = pt.y;
                    line = new Shape();
                    g = line.graphics;
                    g.lineStyle(thickness, color, alpha, true, 'normal', CapsStyle.NONE, JointStyle.BEVEL);
                    if (horizontal) {
                        LineUtil.drawLine(g, 0, 0, 0, -h, color, alpha, dashed ? LineUtil.DASHED : LineUtil.SOLID);
                    } else {
                        LineUtil.drawLine(g, 0, 0, w, 0, color, alpha, dashed ? LineUtil.DASHED : LineUtil.SOLID);
                    }
                    line.name = tick.toString();
                    if (horizontal) { 
                        line.x = pt.x;
                    }else {
                        line.y = pt.y;
                    }
                    priLinesContainer.addChild(line);
                }
                context.addChild(priLinesContainer);

                /**
                * 竖线
                */
                var secLineFat:Number = StyleUtil.getNumberStyle(canvasView, 'secLineThickness') || gridThickness;
                if (secLineFat)
                {
                    var secLinesContainer:Shape = new Shape();
                    grph = secLinesContainer.graphics;
                    var secLineColor:uint       = canvasView.hasStyle('secLineColor') ? StyleUtil.getColorStyle(canvasView, 'secLineColor') : gridColor;
                    var secLineAlpha:Number     = StyleUtil.getNumberStyle(canvasView, 'secLineAlpha', gridAlpha);
                    var secLineStyle:String     = canvasView.getStyle('secLineStyle');
                    //var gap:uint                = StyleUtil.getNumberStyle(canvasView, 'secLineGap', 0);
                    dashed                      = secLineStyle === 'dashed';
                    var secLinePoses:Vector.<Point> = (canvasView.host as ChartCanvas).secLinePoses;
                    grph.lineStyle(secLineFat, secLineColor, secLineAlpha);
                    for each (pt in secLinePoses) 
                    {
                        x = pt.x;
                        y = pt.y;
                        if (horizontal) {
                            LineUtil.drawLine(grph, 0, y, w, y, secLineColor, secLineAlpha, dashed ? LineUtil.DASHED : LineUtil.SOLID);
                        } else {
                            LineUtil.drawLine(grph, x, 0, x, -h, secLineColor, secLineAlpha, dashed ? LineUtil.DASHED : LineUtil.SOLID);
                        }
                    }
                    context.addChild(secLinesContainer);
                }
                context.addChildAt(sp, 0);
                
                var border:DisplayObject = context.getChildByName(ChartCanvasView.BORDER_SHAPE_NAME);
                if (border) {
                    context.addChild(border);
                }
            }
            
            canvasView = null;
        }
        
        private function getBackgroundShape(context:DisplayObjectContainer):Shape
        {
            var sp:Shape = context.getChildByName(ChartCanvasView.BG_SHAPE_NAME) as Shape;
            if (!sp) {
                sp = new Shape();
                sp.name = ChartCanvasView.BG_SHAPE_NAME;
            }
            return sp;
        }
        
    }

}