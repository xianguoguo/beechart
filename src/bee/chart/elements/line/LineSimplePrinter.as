package bee.chart.elements.line
{
	import cn.alibaba.util.DisplayUtil;
	import bee.abstract.IStatesHost;
	import bee.chart.abstract.Chart;
	import bee.chart.abstract.ChartViewer;
	import bee.chart.elements.dot.Dot;
	import bee.chart.elements.dot.NullDot;
	import bee.chart.elements.line.LineData;
	import bee.chart.elements.line.LineView;
	import bee.chart.util.LineUtil;
	import bee.printers.IStatePrinter;
	import bee.util.StyleUtil;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.geom.Point;
    
    /**
     * ...
     * @author hua.qiuh
     */
    public class LineSimplePrinter implements IStatePrinter
    {
        
        static public const CURVE_SEGMENT_AMOUNT:uint = 50;
        
        private var chart:Chart;
        private var line:Line;
        private var data:LineData;
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            if (state != 'normal' && state != 'active')
            {
                return;
            }
            var lnv:LineView = host as LineView;
            if (lnv && lnv.chart)
            {
                const isTimeline:Boolean = lnv.chart.isTimeline();
                DisplayUtil.clearSprite(context);
                chart = lnv.chart;
                data = lnv.dataModel as LineData;
                if (isTimeline && !data.visible)
                {
                    return;
                }
                line = lnv.host as Line;
                var values:Vector.<Number> = data.values;
                var lineSp:Sprite = new Sprite();
                lineSp.mouseChildren = false;
                var lineGrph:Graphics = lineSp.graphics;
                var thickness:Number = Number(lnv.getStyle("thickness")); //粗细
                var color:uint = StyleUtil.getColorStyle(lnv); //颜色
                var alpha:Number = StyleUtil.getNumberStyle(lnv, "alpha", 1); //透明度
                var fillAlpha:Number = Number(lnv.getStyle("fillAlpha"));
                //使用曲线还是直线描绘
                var curved:Boolean = lnv.getStyle('lineMethod') == 'curve';
                const isFillGradient:Boolean = (lnv.getStyle("fillType") == "gradient");
                lineSp.blendMode = BlendMode.NORMAL;
                
                var pts:Vector.<Point> = lnv.dotPositions || data.dotPositions;
                lineGrph.lineStyle(thickness, color, alpha, false, 'normal', CapsStyle.ROUND, JointStyle.ROUND);
                var count:int = curved ? CURVE_SEGMENT_AMOUNT : 1;
                if (isTimeline)
                {
                    count = 1;
                }
                if (fillAlpha && !lnv.chart.isTimeline())
                {
                    var startX:Number = chart.chartToViewXY(0, 0).x;
                    var startY:Number = 0;
                    var gradientHeight:Number = -chart.chartToViewXY(0, data.max).y;
                    var gradientTy:Number = -gradientHeight;
                    LineUtil.drawVerticalArea(context, pts, color, fillAlpha, startX, startY, gradientHeight, gradientTy, count, isFillGradient);
                    LineUtil.curveThrough(lineGrph, pts, count);
                }
                else
                {
                    LineUtil.curveThrough(lineGrph, pts, count);
                }
                lineGrph.endFill();
                
                line.clearDots();
                //当图表在拖动状态，不添加Dot、添加滤镜，否则效率下降太厉害
                if (!isDragging() && !lnv.chart.isTimeline())
                {
                    lineSp.filters = StyleUtil.getFilterStyle(lnv);
                    addDots(pts, lineSp, state);
                }
                //需要放置在addDots函数后，否则可能出现dots被清除，highLight状态dot的skin为空的情况
                line.highlightIndex = line.highlightIndex;
                context.addChild(lineSp);
            }
            clear();
        }
        
        private function isDragging():Boolean
        {
            var result:Boolean = false;
            if (chart && chart.view)
            {
                return (chart.view as ChartViewer).isDragging;
            }
            return result;
        }
        
        private function addDots(pts:Vector.<Point>, sp:Sprite, state:String):void
        {
            var i:uint = 0;
            var pt:Point;
            var dotStyle:Object = StyleUtil.inheritStyle(line.styleSheet.getStyle('dot'), line);
            var dot:Dot;
            for each (pt in pts)
            {
                if (pt)
                {
                    
                    //add dot at this point
                    //dot = DotPool.getDot();
                    dot = new Dot();
                    
                    dot.setStyles(dotStyle);
                    //dot.updateNow();
                    
                    dot.x = pt.x;
                    dot.y = pt.y;
                    //孤点数据永远处于高亮状态
                    //防止点不显示时看不见
                    if (data.isLonelyDot(i))
                    {
                        dot.state = 'hl';
                    }
                    else
                    {
                        dot.state = state;
                    }
                    sp.addChild(dot);
                    line.addDotAt(dot, i);
                }
                else
                {
                    line.addDotAt(new NullDot(), i);
                }
                i++;
            }
        }
        
        private function clear():void
        {
            chart = null;
            line = null;
            data = null;
        }
    }

}