package bee.chart.assemble.bar
{
    import bee.chart.elements.bar.BarSimplePerformer;
    import bee.chart.util.StringFormater;
    import cn.alibaba.util.ColorUtil;
    import bee.chart.abstract.CartesianChartViewer;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartElement;
    import bee.chart.assemble.bar.BarChartPrinter;
    import bee.chart.elements.bar.Bar;
    import bee.chart.elements.bar.BarEnterAnimator;
    import bee.chart.elements.bar.BarView;
    import bee.chart.elements.bar.StackedBar;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.events.ChartUIEvent;
    import bee.chart.util.ChartUtil;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.util.StyleUtil;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    
    
    /**
    * ...
    * @author hua.qiuh
    */
    public class BarChartViewer extends CartesianChartViewer 
    {
        //保存BarChartViewer上的所有bar
        private var _bars:Vector.<Bar>;
        
        public function BarChartViewer(chart:Chart = null) 
        {
            super(chart);
            
            skin.statePrinter = new BarChartPrinter();
            _bars = new Vector.<Bar>();
        }
        
        override protected function initView():void 
        {
            super.initView();
            
            if (chartModel.enableMouseTrack) {
                addEventListeners();
            }
        }
        
        override public function dispose():void 
        {
            removeEventListeners();
            clearBars();
            _bars = null;
            super.dispose();
        }
        
        override public function setStyle(name:String, value:String):void 
        {
            super.setStyle(name, value);
            if (name === 'animate') {
                setBarPerformer(value);
            }
        }
        
        override public function updateDataCache():void 
        {
            super.updateDataCache();
            
            var data:ChartData  = chartModel.data;
            var dataLen:uint    = data.maxSetLength;
            var valueLen:Number = horizontal ? _cacheHeight : _cacheWidth;
            _cacheXStep         = dataLen > 1 ? valueLen / dataLen : 0;
        }
        
        //清除记录的所有PieSlice
        public function clearBars():void {
            for each (var bar:Bar in _bars) 
            {
                bar.dispose();
                bar = null;
            }
            _bars.length = 0;
        }
        
        protected function hightLight(el:ChartElement):void
        {
            el.state = 'hl';
        }
        
        protected function clearHightLight(el:ChartElement):void
        {
            el.state = 'normal';
        }
        
        override protected function addEventListeners():void 
        {
            super.addEventListeners();
            addEventListener(MouseEvent.CLICK, onMouseClick);
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }
        
        override protected function removeEventListeners():void 
        {
            super.removeEventListeners();
            removeEventListener(MouseEvent.CLICK, onMouseClick);
            removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }
        
        override protected function get defaultStyles():Object { 
            return StyleUtil.mergeStyle({
                'spacing'   : 1
            }, super.defaultStyles);
        }
        
        public function get bars():Vector.<Bar> { return _bars; }
        
        public function set bars(value:Vector.<Bar>):void 
        {
            _bars = value;
        }
        
        /**
        * 根据配置设置BarView的Performer.
        * 原先这里设置BarChart的Performer已遭废弃.
        */
        //TODO: 堆叠柱形图暂无初始动画（现有实现方式，初始动画展现有问题）
        protected function setBarPerformer(animate:String):void 
        {
            switch (animate)
            {
                case "true":
                    BarView.defaultPerformer = new BarEnterAnimator();
                    break;
                default:
                    BarView.defaultPerformer = new BarSimplePerformer();
                    break;
            }
        }
        
        protected function getStackTip(stack:StackedBar):String
        {
            var data:ChartData = chartModel.data;
            var total:Number = stack.value;
            const _B:String = '<b>', B_:String = '</b>';
            var str:String = _B + stack.stackName + B_ + '\n' 
                            + data.labelDesc + ': <b>' + data.labels[stack.xIndex]+'</b>\n'
                            + data.valueDesc + ': <b>' + total + '</b>\n';
            
            var color:uint;
            var index:uint;
            var name:String = "";
            var maxchar:Number = StyleUtil.getNumberStyle(Tooltip.instance, "maxchar");
            for each(var bar:Bar in stack.bars) {
                if (bar.barVisible)
                {
                    index = bar.index;
                    var dSet:ChartDataSet = data.allSets[index];
                    color = ChartUtil.getColor(dSet, index);
                    name = dSet.name;
                    name = ChartUtil.getRestrictTxt(name, maxchar);
                    str += '\n<b><font color="' + ColorUtil.int2str(color) + '">' + name + '</font></b>'
                        + ' (' + data.valueDesc+': '+bar.value + ')';
                }
            }
            return str;
        }
        
        protected function getBarTip(bar:Bar):String
        {
            const _B:String = '<b>', B_:String = '</b>';  
            var index:uint = bar.index;
            var x:uint = bar.xIndex;
            var valueLabelFormat:String = chart.getStyle("valueLabelFormat");
            var value:Number = bar.value;
            var data:ChartData = chartModel.data;
            var dSet:ChartDataSet = data.allSets[index];
            var label:String = x > data.labels.length - 1 ? "--" : data.labels[x];
            var color:uint = ChartUtil.getColor(dSet,index);
            var colorStr:String = ColorUtil.int2str(color);
            var maxchar:Number = StyleUtil.getNumberStyle(Tooltip.instance, "maxchar");
            var name:String = dSet.name;
            name = ChartUtil.getRestrictTxt(name, maxchar);
            
            return  [
                    '<b><font color="', colorStr, '">', name , '</font></b>',
                    '\n', 
                    data.labelDesc ? data.labelDesc + ":": "", '<b>' , label , '</b> ', data.labelUnit,
                    '\n',
                    data.valueDesc ? data.valueDesc + ":": "", '<b>' , StringFormater.format( value, valueLabelFormat, dSet.valueType || "number") , '</b> ', data.valueUnit,
                ].join('');
            ;
        }
        
        override public function chartToViewXY(idx:Number, value:Number):Point 
        {
            var pt:Point = super.chartToViewXY(idx, value);
            if (chart.data.maxSetLength === 1) {
                makeTheOnlyColumnCenter(pt);
            }
            return pt;
        }
        
        private function makeTheOnlyColumnCenter(pt:Point):void 
        {
            pt.x = _cachePaddingLeft + _cacheWidth >> 1;
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Event Handlers
        
        private function onMouseOver(e:MouseEvent):void 
        {
            if (chartModel.enableTooltip) {
                var bar:Bar;
                var pt:Point;
                var xIndex:int = -1;
                var tip:Tooltip;
                if (e.target is Bar) {
                    bar = e.target as Bar;
                    xIndex = bar.xIndex;
                    pt = chartToViewXY(xIndex + 0.5, bar.value);
                    tip = Tooltip.instance;
                    tip.text = getBarTip(bar);
                    tip.state = 'normal';
                    tip.goto(pt.x, pt.y);
                    hightLight(bar);
                } else if (e.target is StackedBar) {
                    var stack:StackedBar = e.target as StackedBar;
                    xIndex = stack.xIndex;
                    pt = chartToViewXY(xIndex, stack.value);
                    tip = Tooltip.instance;
                    tip.state = 'normal';
                    tip.text = getStackTip(stack);
                    tip.goto(pt.x, pt.y);
                    hightLight(stack);
                }
                if (xIndex >= 0 && _indexAxis) {
                    _indexAxis.highlightAt(xIndex);
                }
            }
            dispatchChartUIEventForBarChart(e,ChartUIEvent.FOCUS_ITEM);
        }
        
        private function onMouseOut(e:MouseEvent):void 
        {
            if(chartModel.enableTooltip){
                if (e.target is Bar || e.target is StackedBar) {
                    Tooltip.instance.state = 'hidden';
                    clearHightLight(e.target as ChartElement);
                }
                if (_indexAxis) {
                    _indexAxis.clearHighlight();
                }
            }
            dispatchChartUIEventForBarChart(e,ChartUIEvent.BLUR_ITEM);
        }
        
        private function onMouseClick(e:MouseEvent):void 
        {
            dispatchChartUIEventForBarChart(e,ChartUIEvent.CLICK_ITEM);
        }
        
        private function onMouseDown(e:MouseEvent):void 
        {
            dispatchChartUIEventForBarChart(e,ChartUIEvent.MOUSE_DOWN_ITEM);
        }
        
        private function onMouseUp(e:MouseEvent):void 
        {
            dispatchChartUIEventForBarChart(e,ChartUIEvent.MOUSE_UP_ITEM);
        }
        
        private function dispatchChartUIEventForBarChart(e:MouseEvent, type:String):void 
        {
            var bar:Bar;
            var info:Object;
            if(e.target is Bar){
                bar = e.target as Bar;
                e.stopPropagation();
                info = getChartUIEventData(true,bar);
                dispatchChartUIEvent(type,info);
            } else if (e.target is StackedBar) {
                var stack:StackedBar = e.target as StackedBar;
                e.stopPropagation();
                bar = stack.getBarAt(stack.mouseX, stack.mouseY);
                info = getChartUIEventData(false,bar,stack);
                dispatchChartUIEvent(type,info);
            }
        }
        
        private function getChartUIEventData(isBar:Boolean,bar:Bar = null,stack:StackedBar = null):Object
        {
            var result:Object = { };
            if (isBar && bar)
            {
                result = {
                        name    : bar.barName, 
                        index   : bar.index, 
                        xIndex  : bar.xIndex,
                        value   : bar.value
                    };
            }else if (!isBar && stack)
            {
                result = {
                        stackName   : stack.stackName, 
                        stackValue  : stack.value,
                        xIndex      : stack.xIndex
                    };
                if (bar)
                {
                    result['barName'] = bar.barName;
                    result['barIndex'] = bar.index;
                    result['barValue'] = bar.value;
                }
            }
            return result;
        }
    }
}