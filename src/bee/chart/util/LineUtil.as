package bee.chart.util
{
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    /**
     * 画线的一些常用方法
     * 包括虚线、曲线(spline)
     * @author hua.qiuh
     */
    public class LineUtil
    {
        static public const SOLID:uint = 0;
        static public const DASHED:uint = 1;
        static public const DOTTED:uint = 2;
        
        /**
         *
         * 画虚线，适用于直线
         * @param	g   要绘制的Graphics对象
         * @param	fromX   起点x坐标
         * @param	fromY   起点y坐标
         * @param	toX     终点x坐标
         * @param	toY     终点y坐标
         * @param	color   实线部分的颜色
         * @param	alpha   透明度
         * @param	style   直线笔触类型，虚线、点划线还是实线
         * @param	smooth  是否开启平滑
         */
        static public function drawLine(g:Graphics, fromX:Number, fromY:Number, toX:Number, toY:Number, color:uint = 0, alpha:Number = 1, style:uint = 0, smooth:Boolean = false):void
        {
            var bmpd:BitmapData;
            switch (style)
            {
                case DASHED: 
                    bmpd = new BitmapData(7, 1, true, color | ((alpha * 255) << 24));
                    bmpd.setPixel32(4, 0, 0);
                    bmpd.setPixel32(3, 0, 0);
                    //bmpd.setPixel32(2, 0, 0);
                    break;
                case DOTTED: 
                    bmpd = new BitmapData(4, 1, true, color | ((alpha * 255) << 24));
                    bmpd.setPixel32(3, 0, 0);
                    bmpd.setPixel32(2, 0, 0);
                    break;
                case SOLID: 
                    break;
            }
            var mtx:Matrix = new Matrix();
            mtx.rotate(Math.atan2(toY - fromY, toX - fromX));
            if (bmpd)
            {
                g.lineBitmapStyle(bmpd, mtx, true, false);
            }
            g.moveTo(fromX, fromY);
            g.lineTo(toX, toY);
        }
        
       /**
         * 绘制直线的路径
         * @param	g
         * @param	dots
         */
        static public function beelineThrough(g:Graphics, dots:Vector.<Point>):void
        {
            var needMove:Boolean = true;//为第非空的第一个点时，需要进行move操作
            var numloop:int = dots.length;
            var pt:Point;
            for each (pt in dots) 
            {
                if (pt)
                {
                    if (needMove)
                    {
                        g.moveTo(pt.x, pt.y);
                    }
                    else 
                    {
                        g.lineTo(pt.x, pt.y);
                    }
                    needMove = false;    
                }
                else 
                {
                    needMove = true;
                }
            }
            g.endFill();
        }
        
         /**
          * 绘制曲线的路径.
          * 当count为1时，为绘制直线的情况；否则为曲线.
          * @param	g
          * @param	dots
          * @param	count
          */
        static public function curveThrough(g:Graphics, dots:Vector.<Point>, count:uint = 10):void
        {
            if (count == 1)
            {
                beelineThrough(g, dots);
            }
            else 
            {
                 // draw spline
                var len:uint = dots.length;
                dots.some(function(p1:Point, i:uint, ... args):Boolean
                {
                    if (i > len - 2)
                        return true;
                    
                    var p0:Point, p2:Point, p3:Point;
                    var numloop:int = count + 1;
                    if (i == 0)
                    {
                        if (!p1)
                            return false;
                    }
                    else
                    {
                        p0 = dots[i - 1]
                    }
                    if (!p1)
                    {
                        return false;
                    }
                    if (!p0)
                    {
                        g.moveTo(p1.x, p1.y);
                        p0 = p1;
                    }
                    p2 = dots[i + 1];
                    if (!p2)
                    {
                        return false;
                    }
                    if (i == len - 2)
                    {
                        p3 = p2;
                    }
                    else
                    {
                        p3 = dots[i + 2];
                    }
                    if (!p3)
                    {
                        p3 = p2;
                    }
                    for (var j:int = 1; j < numloop; j++)
                    {
                        var q:Point = spline(p0, p1, p2, p3, 1 / count * j);
                        g.lineTo(q.x, q.y);
                    }
                    return false;
                
                }, null);
            }
        }
        
        /**
         * 获得绘制线条的点的坐标.
         * 当count为1时，为绘制直线的情况，直接返回dots；否则为曲线.
         * @param	dots
         * @param	count
         * @return
         */
        static public function getCurvePtsThrough(dots:Vector.<Point>, count:uint = 10):Vector.<Point>
        {
            if (count == 1)
            {
                return dots;
            }
            else 
            {
                 // draw spline
                var pts:Vector.<Point> = new Vector.<Point>();
                var len:uint = dots.length;
                dots.some(function(p1:Point, i:uint, ... args):Boolean
                    {
                        pts.push(p1 ? p1.clone() : null);
                        
                        if (i > len - 2)
                        {
                            return true;
                        }
                        
                        var p0:Point, p2:Point, p3:Point;
                        if (!p1)
                        {
                            return false;
                        }
                        if (i == 0)
                        {
                            if (!p0)
                            {
                                p0 = p1;
                            }
                        }
                        else
                        {
                            p0 = dots[i - 1]
                        }
                        if (!p0)
                        {
                            p0 = p1;
                        }
                        p2 = dots[i + 1];
                        if (!p2)
                        {
                            return false;
                        }
                        if (i == len - 2)
                        {
                            p3 = p2;
                        }
                        else
                        {
                            p3 = dots[i + 2];
                        }
                        if (!p3)
                        {
                            p3 = p2;
                        }
                        for (var j:int = 2; j < count + 1; j++)
                        {
                            var q:Point = spline(p0, p1, p2, p3, 1 / count * j);
                            pts.push(q);
                        }
                        return false;
                    
                    }, null);
                return pts;
            }
        }
        
        /**
         *
         * Calculates 2D cubic Catmull-Rom spline.
         * @see http://www.mvps.org/directx/articles/catmull/
         * @param	p0
         * @param	p1
         * @param	p2
         * @param	p3
         * @param	t
         * @return
         */
        static public function spline(p0:Point, p1:Point, p2:Point, p3:Point, t:Number):Point
        {
            var x:Number = getSplinePos(p0.x, p1.x, p2.x, p3.x, t);
            var y:Number = getSplinePos(p0.y, p1.y, p2.y, p3.y, t);
            return new Point(x, y);
        }
        
        static private function getSplinePos(pos0:Number, pos1:Number, pos2:Number, pos3:Number, t:Number):Number
        {
            return .5 * ((2 * pos1) + t * (( -pos0 + pos2) + t * ((2 * pos0 - 5 * pos1 + 4 * pos2 - pos3) + t * ( -pos0 + 3 * pos1 - 3 * pos2 + pos3))));
        }
        
        /**
         * 绘制竖直形态的填充
         * @param	context
         * @param	grph
         * @param	pts
         * @param	color
         * @param	fillAlpha
         * @param	startX
         * @param	startY
         * @param	offset
         * @param	curved
         * @param	isFillGradient
         */
        static public function drawVerticalArea(context:DisplayObjectContainer, pts:Vector.<Point>, color:uint, fillAlpha:Number, startX:Number,startY:Number, gradientHeight:Number, gradientTy:Number,count:int, isFillGradient:Boolean = false):void
        {
            var lastGoodPt:Point;
            // 将填充Shape
            var bg:Shape = new Shape();
            var bgGrph:Graphics = bg.graphics;
            bgGrph.clear();
            context.addChild(bg);
            
            bgGrph.lineStyle();
            bgGrph.moveTo(0, 0);
            
            var curvedPts:Vector.<Point> = LineUtil.getCurvePtsThrough(pts, count);
            var first:Boolean = true;
            var len:uint = curvedPts.length;
            var x0:Number = startX;
            var y0:Number = startY; //p0.y;
            var pt:Point;
            for (var i:int = 0; i < len; i++)
            {
                if (curvedPts[i] === null)
                {
                    continue;
                }
                pt = curvedPts[i];
                if (pt)
                {
                    lastGoodPt = pt;
                }
                if (first)
                {
                    //前一个点为空
                    first = false;
                    //因为绘制的区域可能有断点，断点时已经endFill了，故需要在这里多次重新设置beginFill
                    if (isFillGradient)
                    {
                        LineUtil.setGraphicsForVerticalGradient(bgGrph, color, fillAlpha, gradientHeight, gradientTy);
                    }
                    else
                    {
                        bgGrph.beginFill(color, fillAlpha);
                    }
                    bgGrph.moveTo(pt.x, y0);
                    bgGrph.lineTo(pt.x, pt.y);
                    
                }
                else
                {
                    bgGrph.lineTo(pt.x, pt.y);
                }
                if (i < len - 1)
                {
                    if (!curvedPts[i + 1])
                    {
                        //下一个点为空
                        bgGrph.lineTo(pt.x, y0);
                        bgGrph.lineTo(x0, y0);
                        bgGrph.endFill();
                        first = true;
                    }
                }
            }
            if (lastGoodPt)
            {
                bgGrph.lineTo(lastGoodPt.x, y0);
                bgGrph.lineTo(x0, y0);
                bgGrph.endFill();
            }
        }
        
        /**
         * 设置竖直形态填充的Graphics
         * @param	g
         * @param	color
         * @param	alpha
         * @param	offset
         */
        static private function setGraphicsForVerticalGradient(g:Graphics, color:uint, alpha:Number, gradientHeight:Number, gradientTy:Number):void
        {
            var fillType:String = GradientType.LINEAR;
            var colors:Array = [color, color];
            var alphas:Array = [alpha, 0];
            var ratios:Array = [0, 0xFF];
            var matr:Matrix = new Matrix();
            //matr.createGradientBox(offset, -offset, Math.PI / 2, 0, 0);
            //matr.createGradientBox(width, height, rotation, tx, ty);
            matr.createGradientBox(1, gradientHeight, Math.PI/2, 0, gradientTy);
            g.beginGradientFill(fillType, colors, alphas, ratios, matr);
        }
        
        /**
         * 返回flash的位置坐标，对百分位进行四舍五入，
         * 因为在flash中，位置坐标只精确到0.05.
         * @param	value
         * @return
         */
        static public function handleNumberForFlashPos(value:Number):Number
        {
            var correction:Number = 0.0;
            if (value > 0)
            {
                correction = 0.5;
            }
            else
            {
                correction = -0.5;
            }
            return ((value * 10 + correction) >> 0) / 10;
        }
    
    }

}