package bee.chart.assemble.bar 
{
    import bee.chart.abstract.CartesianChartViewer;
    import bee.chart.elements.legend.Legend;
    import cn.alibaba.util.ColorUtil;
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartStates;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.assemble.bar.BarChartViewer;
    import bee.chart.assemble.CartesianChartPrinter;
    import bee.chart.elements.axis.Axis;
    import bee.chart.elements.bar.Bar;
    import bee.chart.elements.bar.StackedBar;
    import bee.chart.elements.canvas.ChartCanvas;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.ChartUtil;
    import bee.printers.IStatePrinterWithUpdate;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import com.greensock.easing.Sine;
    import com.greensock.TweenLite;
    
    
    /**
    * ...
    * @author hua.qiuh
    */
    public class BarChartPrinter extends CartesianChartPrinter implements IStatePrinterWithUpdate
    {
        override protected function renderNormalState(host:ChartViewer, context:DisplayObjectContainer):void 
        {
            super.renderNormalState(host, context);
            var viewer:BarChartViewer = host as BarChartViewer;
            drawBars(viewer, context);
            
            var axis:Axis = viewer.indexAxis;
            if (axis) {
                axis.parent.addChild(axis);
            }
            
            Tooltip.instance.textGen = null;
            viewer.makeSelfCenter();
        }
        
        /**
        * 绘制柱状条
        * @param	viewer
        * @param	context
        * */
        protected function drawBars(viewer:BarChartViewer, context:DisplayObjectContainer):void 
        {
            viewer.clearBars();
            var data:BarChartData = viewer.chartModel.data as BarChartData;
            var sets:Vector.<ChartDataSet> = data.allSets;
            var count:uint = data.stackedColumnsCount;
            var p0:Point = viewer.chartToViewXY(0, 0);
            var barThick:Number = caculateBarThickness(viewer, count);
            
            var stackedBars:Dictionary = new Dictionary(true);
            var barsCache:Vector.<Bar> = new Vector.<Bar>();
            var y0:Number = p0.y;
            if(sets){
                var len:uint = sets.length;
                var bars:Sprite = new Sprite();
                if (len)
                {
                    //生成需要的stackedBars
                    generateStacks(sets, stackedBars);
                    var dfltStyle:Object = viewer.styleSheet.getStyle('bar');
                    generateBars(sets, barsCache, viewer);
                    setBarStyleAndValue(sets, barsCache, viewer, dfltStyle, barThick, false);
                    generateBarsPosition(barsCache, viewer, count, barThick, y0);
                   
                    bars.y = -2;
                    bars.name = 'bars';
                   
                    assignBars(barsCache, stackedBars, viewer, bars);
                    viewer.bars = barsCache;
                }
                context.addChild(bars);
            }
        }
        
        protected function caculateBarThickness(viewer:BarChartViewer, count:Number):Number 
        {
            if (count <= 0) {
                count = 1;
            }
            return Number(viewer.styleSheet.getStyle('bar')['thickness']) ||
                (viewer.chartToViewXY(1, 0).x - viewer.chartToViewXY(0, 0).x) / (count + Number(viewer.getStyle('spacing')))
                || Bar.DEFAULT_THICKNESS;
                
        
        }
        
        /**
        * 生成需要的stack
        * @param	sets
        * @param	stackedBars
        */
        protected function generateStacks(sets:Vector.<ChartDataSet>, stackedBars:Dictionary):void 
        {
            var len:int = sets.length;
            var i:int = -1;
            var dSet:ChartDataSet;
            var group:String = "";
            var key:String = "";
            var stack:StackedBar;
            while (++i < len) 
            {
                dSet = sets[i];
                if (!dSet.visible) 
                {
                    continue;
                }
                
                group = dSet.config['stackGroup'];
                if (group)
                {
                    var idx:int = 0;
                    for each (var value:Number in dSet.values) 
                    {
                        key = generateGroupKey(group, idx);
                        if (stackedBars[key] == null)
                        {
                            stack = new StackedBar();
                            stack.name = key;
                            stack.stackName = group;
                            stack.index = i;
                            stack.xIndex = idx;
                            stackedBars[key] = stack;
                        }
                        idx++;
                    }
                }
            }
        }

        /**
        * 生成所有的bar
        * @param	sets
        * @param	barsCache
        */
        protected function generateBars(sets:Vector.<ChartDataSet>, barsCache:Vector.<Bar>,viewer:BarChartViewer):void 
        {
            var len:int = sets.length;
            var i:int = -1;
            var dSet:ChartDataSet;
            var group:String = "";
            var key:String = "";
            while (++i < len) 
            {
                dSet = sets[i];
                if (!dSet.visible) 
                {
                    continue;
                }
                group = dSet.config['stackGroup'];
                var idx:int = 0;
                for each (var value:Number in dSet.values) 
                {
                    var bar:Bar = new Bar();
                    if (group)
                    {
                        key = generateGroupKey(group, idx);
                        bar.groupKey=key;
                        bar.group=group;
                    }
                    bar.index = i;
                    bar.xIndex = idx;
                    barsCache.push(bar);
                    idx++;
                }
            }
        }
        
        /**
        * 设置bar的style和数值
        * @param	sets
        * @param	barsCache
        * @param	viewer
        * @param	dfltStyle
        * @param	dfltThick
        */
        protected function setBarStyleAndValue(sets:Vector.<ChartDataSet>, barsCache:Vector.<Bar>, viewer:BarChartViewer, dfltStyle:Object, dfltThick:Number,isHorizontal:Boolean):void
        {
            var len:int = sets.length;
            var i:int = -1;
            var dSet:ChartDataSet;
            var key:String = "";
            var bar:Bar;
            while (++i < len) 
            {
                dSet = sets[i];
                var barStyle:Object = StyleUtil.mergeStyle(dSet.config.style, dfltStyle);
                //若无指定颜色，就采用自动配置颜色
                if(!barStyle.color && (!dSet.config.style || !dSet.config.style.color)){
                    barStyle["color"] = ColorUtil.int2str(ChartUtil.getColor(dSet, i));
                }
                var idx:int = 0;
                for each (var value:Number in dSet.values) 
                {
                    for each (bar in barsCache) 
                    {
                        if (bar.index==i && bar.xIndex == idx)
                        {
                            bar.value = value;
                            bar.barName = dSet.name;
                            bar.horizontal = isHorizontal;
                            barStyle['thickness']   = barStyle['thickness'] || dfltThick;
                            bar.styleSheet.setStyle('label', viewer.styleSheet.getStyle('bar label'));
                            bar.setStyles( barStyle );
                            
                            bar.barVisible = dSet.visible;
                            break;
                        }
                    }
                    idx++;
                }
            }
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
        protected function generateBarsPosition(barsCache:Vector.<Bar>, viewer:BarChartViewer, count:uint, dfltThick:Number, y0:Number, smooth:Boolean=false):void 
        {
            var indexCache:Dictionary = new Dictionary(true);//根据组名记录组的index变量
            var yCatche:Dictionary = new Dictionary(true);//根据组id记录组的y轴变量
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
                height = y0 - pt.y;
                bar.setStyle("length",height+"");
                if (group)
                {
                    if (indexCache[group]!=null)
                    {
                        index = indexCache[group];
                    }
                    indexCache[group] = index;
                }
                else 
                {
                    if (indexCache[bar.index]!=null)
                    {
                        index = indexCache[bar.index];
                    }
                    indexCache[bar.index] = index;
                }
                
                if (groupKey)
                {
                    if (yCatche[groupKey]!=null)
                    {
                        posPt.y = yCatche[groupKey];
                    }else
                    {
                        posPt.y = y0;
                    }
                    yCatche[groupKey] = posPt.y - height;
                }else
                {
                    posPt.y = y0;
                }
                posPt.x = pt.x +(index - 1 - count * 0.5) * dfltThick;
                if (smooth) {
                    TweenLite.to(bar, .5, { 
                        x       : posPt.x,
                        ease    : Sine.easeOut,
                        delay   : .5
                    });
                    /**
                     * y坐标不可以缓动变化
                     * 原因是当多个Bar竖向堆叠在一起的时候
                     * 如果y坐标不是立即变化到位，会产生bar
                     * 之间的空隙。
                     */
                    bar.y = posPt.y;
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
        
        protected function assignBars(barsCache:Vector.<Bar>, stackedBars:Dictionary,viewer:BarChartViewer,bars:Sprite):void 
        {
            var stack:StackedBar;
            var groupKey:String;
            for each (var bar:Bar in barsCache ) 
            {
                groupKey = bar.groupKey;
                if (groupKey)
                {
                    stack = stackedBars[groupKey] as StackedBar;
                    if (stack)
                    {
                        stack.addBar(bar);
                        viewer.addElement(stack);
                        stack.state = 'normal';
                        bars.addChild(stack);
                    }
                }else
                {
                    viewer.addElement(bar);
                    bar.state = 'normal';
                    bars.addChildAt(bar, 0);
                }
            }
        }
        
        protected function generateGroupKey(group:String, idx:int):String
        {
            return group + idx;
        }
        
        public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            if (state === ChartStates.NORMAL) 
            {
                trace(!shouldSmoothUpdate(host as CartesianChartViewer, context));
                if (!shouldSmoothUpdate(host as CartesianChartViewer, context))
                {
                    renderState(host, state, context);
                    return;
                }
                initParamter(host, context);
                smoothUpdateBars(host as BarChartViewer, context);
                for each (var el:ChartElement in _viewer.elements) 
                {
                    smoothUpdateElement(el);
                }
                clearParamter();
            }
        }
        
        private function shouldSmoothUpdate(cartesianChartViewer:CartesianChartViewer, context:DisplayObjectContainer):Boolean 
        {
            var bars:Sprite = context.getChildByName('bars') as Sprite;
            var data_num:uint = 0;
            var isGroupBar:Boolean;
            var allSets:Vector.<ChartDataSet> = cartesianChartViewer.chart.allSets;
            for each(var dataset:ChartDataSet in allSets) {
                data_num += dataset.length;
                if (!isGroupBar) {
                    isGroupBar = (!!dataset.config['stackGroup']);
                }
            }
            return isGroupBar ? (bars && bars.numChildren == allSets.length) : (bars && bars.numChildren == data_num);
        }
        
        private function smoothUpdateElement(el:ChartElement):void 
        {
            if (el is Axis)
            {
                updateAxisLabels(el as Axis);
            }
            if (el is ChartCanvas)
            {
                updateCanvas(el as ChartCanvas);
            }else if (el is Legend) {
                //Bugfix:数据条数未改变，但数据内容改变，需要重绘数据显示
                var tempLegend:Legend = el as Legend;
                tempLegend.dataSets = this._viewer.chartModel.data.allSets;
                tempLegend = null;
            }
            el.smoothUpdate();
        }
        
        protected function smoothUpdateBars(viewer: BarChartViewer,context:DisplayObjectContainer):void 
        {
            var bars:Vector.<Bar> = (viewer as BarChartViewer).bars;
            var data:BarChartData = viewer.chartModel.data as BarChartData;
            var sets:Vector.<ChartDataSet> = data.allSets;
            if (sets)
            {
                var len:uint = sets.length;
                var count:uint = Math.max(data.stackedColumnsCount, 1);
                var p0:Point = viewer.chartToViewXY(0, 0);
                var barThick:Number = caculateBarThickness(viewer, count);
                
                if (len)
                {
                    var dfltStyle:Object = viewer.styleSheet.getStyle('bar');
                    var dfltThick:Number = Number(dfltStyle && dfltStyle['thickness']) || barThick;
                    var y0:Number = p0.y;
                    setBarStyleAndValue(sets, bars, (viewer as BarChartViewer), dfltStyle, dfltThick,false);
                    generateBarsPosition(bars, (viewer as BarChartViewer), count, dfltThick, y0, true);
                }
            }
        }
    }
}