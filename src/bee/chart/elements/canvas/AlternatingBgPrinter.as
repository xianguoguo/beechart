package bee.chart.elements.canvas 
{
    import cn.alibaba.util.ColorUtil;
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.util.LineUtil;
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
	import bee.printers.IStatePrinter;
	import bee.printers.PrinterDecorator;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Point;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class AlternatingBgPrinter extends PrinterDecorator 
    {
        
        public function AlternatingBgPrinter(basePrinter:IStatePrinter = null) 
        {
            super(basePrinter);
        }
        
        override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            super.renderState(host, state, context);
            
            var canvas:ChartCanvasView = host as ChartCanvasView;
            if (canvas && canvas.chart) {
                
                var chart:Chart = canvas.chart;
                var sp:Shape                = getAlterBgShape(context);
                var grph:Graphics           = sp.graphics;
                var yTicks:Vector.<Number>  = CartesianChartData(chart.data).yTicks;
                var w:Number                = Number(canvas.getStyle('width'));
                var h:Number                = Number(canvas.getStyle('height'));
                var pdBottom:Number         = Number(canvas.getStyle('paddingBottom'));
                var bgColor1:uint           = ColorUtil.str2int(canvas.getStyle('backgroundColor'));
                var bgColor2:uint           = ColorUtil.str2int(canvas.getStyle('backgroundColor2'));
                var bgAlpha:Number          = Number(canvas.getStyle('backgroundAlpha'));
                var pdTop:Number            = Number(canvas.getStyle('paddingTop'));
                var i:int = pdBottom ? -1 : 0;
                var len:uint = pdTop || !yTicks.length ? yTicks.length : yTicks.length - 1
                var pt:Point, next:Point;
                
                context.addChildAt(sp, 1);
                
                grph.clear();
                
                for (; i < len; i++) {
                    if (i === -1) {
                        pt = new Point(0, 0);
                    } else {
                        pt = chart.chartToViewXY(0, yTicks[i]);
                    }
                    if ( i === len - 1) {
                        next = new Point(0, -chart.chartHeight);
                    } else {
                        next = chart.chartToViewXY(0, yTicks[i + 1]);
                    }
                    grph.beginFill(i % 2 ? bgColor2 : bgColor1, bgAlpha)
                    grph.moveTo(0, pt.y);
                    grph.drawRect(0, pt.y, w, next.y- pt.y);
                    grph.endFill();
                }
                context.addChildAt(sp, 0);
            }
            
        }
        
        private function getAlterBgShape(context:DisplayObjectContainer):Shape 
        {
            var sp:Shape = context.getChildByName(ChartCanvasView.ALTER_BG_SHAPE_NAME) as Shape;
            if(!sp){
                sp = new Shape();
                sp.name = ChartCanvasView.ALTER_BG_SHAPE_NAME;
            }
            return sp;
        }
        
    }

}