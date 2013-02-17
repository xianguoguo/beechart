package bee.chart.assemble.bar 
{
    import bee.chart.abstract.CartesianChartData;
    import bee.chart.abstract.CartesianChartViewer;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.assemble.bar.BarChartViewer;
    import bee.chart.elements.axis.Axis;
    import bee.chart.elements.axis.AxisDirection;
    import bee.chart.elements.bar.Bar;
    import bee.chart.util.StringFormater;
    import bee.printers.IStatePrinterWithUpdate;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import com.greensock.easing.Back;
    import com.greensock.TweenLite;
    
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class BarChartHorizontalPrinter extends BarChartPrinter implements IStatePrinterWithUpdate
    {
        override protected function drawXAxis(host:CartesianChartViewer, context:DisplayObjectContainer, rect:Rectangle):void 
        {
			var data:CartesianChartData = host.chartModel.data as CartesianChartData;
            var ticks:Vector.<Number> = data.yTicks;
            var labels:Vector.<String> = new <String>[];
            if (ticks) {
				for each (var tick:Number in ticks) 
				{
					labels.push(StringFormater.format(tick, '')); 
				}
            }
            
            var xAxis:Axis = host.requestElement(Axis) as Axis;
            reSetAxisPrinter(xAxis, host.getStyle('smooth'));
            xAxis.mouseEnabled = false;
            xAxis.direction = AxisDirection.RIGHT;
            xAxis.length = host.chartModel.chartWidth;
            xAxis.isValueAxis = true;
			StyleUtil.inheritStyleSheet(xAxis, 'xAxis', host);
            xAxis.labels = labels;
            host.addElement( xAxis );
            context.addChild( xAxis );
            xAxis.updateViewNow();
            rect.bottom += xAxis.height;
        }
        
        override protected function drawYAxis(host:CartesianChartViewer, context:DisplayObjectContainer, rect:Rectangle):void 
        {
			var toDrawLYAxis:Boolean = host.getStyle('leftAxisVisibility') === 'visible';
			if (toDrawLYAxis) 
			{
				var data:CartesianChartData = host.chartModel.data as CartesianChartData;
				var style:Object;
				
				var yAxis:Axis           = createYAxis(host, data.labels, false, AxisDirection.DOWN);
				style                   = host.styleSheet.getStyle('yAxis');

				context.addChild( yAxis );
				yAxis.updateViewNow();
				host.indexAxis = yAxis;
				if (style['position'] == 'zero' && data.minTickValue < 0) {
					var y:Number = host.chartToViewXY(0, 0).y;
					yAxis.y = y;
					if (y > -yAxis.height) {
						rect.bottom += yAxis.height + y;
					}
				}else {
					yAxis.y = -yAxis.length;
					yAxis.x = rect.left;
					rect.left -= yAxis.width;
				}
			}
        }
        
        /**
        * 绘制柱状条
        * @param	viewer
        * @param	context
        */
        override protected function drawBars(viewer:BarChartViewer, context:DisplayObjectContainer):void 
        {
            viewer.clearBars();
            var data:BarChartData = viewer.chartModel.data as BarChartData;
            var sets:Vector.<ChartDataSet> = data.allSets;
            var count:uint = data.stackedColumnsCount;
            var p0:Point = viewer.chartToViewXY(0, 0);
            var barThick:Number = caculateBarThickness(viewer, count);
            
            var stackedBars:Dictionary = new Dictionary(true);
            var barsCache:Vector.<Bar> = new Vector.<Bar>();
            var x0:Number = p0.x;
            if(sets){
                var len:uint = sets.length;
                if (len)
                {
                    //生成需要的stackedBars
                    generateStacks(sets, stackedBars);
                    var dfltStyle:Object = viewer.styleSheet.getStyle('bar');
                    generateBars(sets, barsCache, viewer);
                    setBarStyleAndValue(sets, barsCache, viewer, dfltStyle, barThick,true);
                    generateBarsPosition(barsCache, viewer, count, barThick, x0);
                   
                    var bars:Sprite = new Sprite();
                    bars.name = 'bars';
                    
                    assignBars(barsCache, stackedBars, viewer, bars);
                    viewer.bars = barsCache;
                }
                context.addChild(bars);
            }
        }
        
        override protected function caculateBarThickness(viewer:BarChartViewer, count:Number):Number 
        {
            if (count <= 0) {
                count = 1;
            }
            return Number(viewer.styleSheet.getStyle('bar')['thickness']) ||
                (viewer.chartToViewXY(1, 1).y - viewer.chartToViewXY(0, 0).y) / (count + Number(viewer.getStyle('spacing')));
        }
        
        /**
        * 生成bar的位置
        * @param	barPositions
        * @param	barsCache
        * @param	viewer
        * @param	count
        * @param	dfltThick
        * @param	y0
        */
        override protected function generateBarsPosition(barsCache:Vector.<Bar>, viewer:BarChartViewer, count:uint, dfltThick:Number, x0:Number, smooth:Boolean=false):void 
        {
            var indexCache:Dictionary = new Dictionary(true);//根据组名记录组的index变量
            var xCatche:Dictionary = new Dictionary(true);//根据组id记录组的x轴变量
            var group:String = "";
            var groupKey:String = "";
            var pt:Point;
            var posPt:Point;
            var index:int = 1;//索引，x轴的位置索引.没有组的情况下，index递增，同一dataset数据使用同一index;有组的情况下相同的组使用同一index
            var max_index:int = 1;//记录最大的索引
            var height:Number;
            for each (var bar:Bar in barsCache) 
            {
                if (!bar.barVisible)
                {
                    continue;
                }
                pt = viewer.chartToViewXY(bar.xIndex + .5, bar.value);
                if (!pt) {
                    continue;
                }
                posPt = new Point();
                index = max_index;
                group = bar.group;
                groupKey = bar.groupKey;
                height = pt.x - x0;
                bar.setStyle("length",height+"");
                if (group)
                {
                    if (indexCache[group]!=null)
                    {
                        index = indexCache[group];
                    }
                    indexCache[group] = index;
                }else 
                {
                    if (indexCache[bar.index]!=null)
                    {
                        index = indexCache[bar.index];
                    }
                    indexCache[bar.index] = index;
                }
                
                if (groupKey)
                {
                    if (xCatche[groupKey]!=null)
                    {
                        posPt.x = xCatche[groupKey];
                    }else
                    {
                        posPt.x = x0;
                    }
                    xCatche[groupKey] = posPt.x - height;
                }else
                {
                    posPt.x = x0;
                }
                posPt.y = pt.y +(index - 1 - count * 0.5) * dfltThick;
                if (smooth) {
                    TweenLite.to(bar, .5, { 
                        y       : posPt.y,
                        ease    : Back.easeInOut 
                    });
                    /**
                     * x坐标不可以缓动变化
                     * 原因是当多个Bar横向堆叠在一起的时候
                     * 如果x坐标不是立即变化到位，会产生bar
                     * 之间的空隙。
                     */
                    bar.x = posPt.x;
                } else {
                    bar.x = posPt.x;
                    bar.y = posPt.y;
                }
                index++;
                if (index > max_index)
                {
                    max_index = index;
                }
            }
        }

        override protected function smoothUpdateBars(viewer: BarChartViewer,context:DisplayObjectContainer):void 
        {
            var bars:Vector.<Bar> = viewer.bars;
            var data:BarChartData = viewer.chartModel.data as BarChartData;
            var sets:Vector.<ChartDataSet> = data.allSets;
            if(sets){
                var len:uint = sets.length;
                var count:uint = data.stackedColumnsCount;
                var p0:Point = viewer.chartToViewXY(0, 0);
                var barThick:Number = caculateBarThickness(viewer, count);
                
                if(len){
                    var dfltStyle:Object = viewer.styleSheet.getStyle('bar');
                    var x0:Number = p0.x;
                    setBarStyleAndValue(sets, bars, viewer, dfltStyle, barThick,true);
                    generateBarsPosition(bars, viewer, count, barThick, x0, true);
                }
            }
        }
    }

}