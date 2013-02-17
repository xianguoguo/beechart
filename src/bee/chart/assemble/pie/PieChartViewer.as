package bee.chart.assemble.pie
{
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.DisplayUtil;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.elements.legend.Legend;
    import bee.chart.elements.pie.GroupPieSlice;
    import bee.chart.elements.pie.GroupPieSliceData;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.pie.PieSliceStates;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.events.ChartUIEvent;
    import bee.chart.util.ChartUtil;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.util.StyleUtil;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    import com.greensock.TweenLite;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieChartViewer extends ChartViewer implements IGetoutJam
    {
        static public const SLICE:String = "slice";

        static public const ROTATION_SHOW_TIME:Number = 1.0;
        
        private var _trigger:uint;
        //保存PieChartViewer上的PieSlice
        private var _pieSlices:Vector.<PieSlice>;
        private var _getoutjam:IGetoutJam = new GetoutJam();
        private var _pieSlicesContainer:Sprite = new Sprite();
        private var _showingDetail:Boolean = false;
        
        public function PieChartViewer(chart:Chart) 
        {
            super(chart);
            this.state = PieStates.READY;
            _pieSlices = new Vector.<PieSlice>();
        }
        
        public function arrangeSliceLabels(chart:Chart, pieSlices:Vector.<PieSlice>):void 
        {
            if (_getoutjam)
            {
                _getoutjam.arrangeSliceLabels(chart,pieSlices);
            }
        }
        
        override public function setDatasetActivity(index:uint, active:Boolean):void
        {
            var slice:PieSlice = getPieSlice(index);
            if (slice && !_showingDetail) {
                resetPies();
                slice.state = active ? PieSliceStates.HIGH_LIGHT : PieSliceStates.NORMAL;
				//将该slice放置到最前端显示
				_pieSlicesContainer.addChild(slice);
            }
        }
        
        public function clearPieSlices():void {
            for each (var pieSlice:PieSlice in _pieSlices) 
            {
                pieSlice.dispose();
                pieSlice = null;
            }
            _pieSlices.length = 0;
            DisplayUtil.clearSprite(_pieSlicesContainer);
        }
        
        override public function addElement(el:ChartElement):void 
        {
            super.addElement(el);
            if (el is PieSlice) {
                _pieSlices.push(el);
            }
        }
        
        override public function removeElement(el:ChartElement):void 
        {
            super.removeElement(el);
            if (el is PieSlice) {
                var idx:int = _pieSlices.indexOf(el);
                if (idx != -1) {
                    _pieSlices.splice(idx, 1);
                }
            }
        }
        
        override protected function addEventListeners():void {
            if (_pieSlicesContainer)
            {
                _pieSlicesContainer.addEventListener(MouseEvent.CLICK, mouseClickHandler);
                _pieSlicesContainer.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
                _pieSlicesContainer.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
                _pieSlicesContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                _pieSlicesContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            }
            addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
        }
        
        override protected function removeEventListeners():void {
            if (_pieSlicesContainer)
            {
                _pieSlicesContainer.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
                _pieSlicesContainer.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
                _pieSlicesContainer.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
                _pieSlicesContainer.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                _pieSlicesContainer.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            }
            removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
        }
        
        override protected function initView():void 
        {
            super.initView();
            if (chartModel.enableMouseTrack)
            {
                addEventListeners();
            }
            skin.statePrinter   = new PieChartPrinter();
        }
        
        public function get pieSlices():Vector.<PieSlice> { return _pieSlices; }
        
        public function get pieSlicesContainer():Sprite { return _pieSlicesContainer; }
        
        public function setGetoutjam(value:IGetoutJam):void 
        {
            _getoutjam = value;
        }
        
        public function toggleSlice(slice:PieSlice):void
        {
            if (slice is GroupPieSlice && !_showingDetail) 
            {
                showDetailOf(slice as GroupPieSlice);
            }else if (_showingDetail)
            {
                showNormal();
            }
        }
        
        public function toggleSliceIndex(index:uint):void
        {
            toggleSlice(getPieSlice(index));
        }
        
        private function showDetailOf( slice:GroupPieSlice ):void
        {
            hideTooltip();
            rotateToSlice(slice);
            setBlurState(slice);
			slice.state = PieSliceStates.DETAIL;
            _showingDetail = true;
            isSmoothing = true;
            TweenLite.to(_pieSlicesContainer, ROTATION_SHOW_TIME,
                {
                    x: -x,
                    delay:ROTATION_SHOW_TIME,
                    overwrite:0,
                    onComplete:function():void
                    {
                        changeLegendItemBlur();
                        isSmoothing = false;
                    }
                }
            );
        }
        
        public function showNormal():void 
        {
            if (_showingDetail)
            {
                hideTooltip();
                _showingDetail = false;
                isSmoothing = true;
                resetPies();
                TweenLite.killTweensOf(_pieSlicesContainer, true);
                TweenLite.to(_pieSlicesContainer, ROTATION_SHOW_TIME,
                    {
                        x:chartModel.chartWidth >> 1
                    }
                );
                TweenLite.to(_pieSlicesContainer, ROTATION_SHOW_TIME,
                    {
                        rotation:0,
                        delay:ROTATION_SHOW_TIME,
                        overwrite:0,
                        onComplete:function():void
                        {
                            changeLegendItemBlur();
                            isSmoothing = false;
                        }
                    }
                );
            }
        }

        private function changeLegendItemBlur():void
        {
            var legend:Legend = content.getChildByName("legend") as Legend;
            if (legend)
            {
                for each (var slice:PieSlice in _pieSlices) 
                {
                    if (slice.state == PieSliceStates.BLUR)
                    {
                        legend.setLegendItemBlur(slice.index, true);
                    }else
                    {
                        legend.setLegendItemBlur(slice.index, false);
                    }
                }
            }
        }
        
        private function rotateToSlice(slice:PieSlice):void
        {
            var data:PieSliceData = slice.model as PieSliceData;
            var positionAngle:Number = data.getPositionAngle();
            var rotation:Number = positionAngle > 180 ? (360 - positionAngle) : - positionAngle;
            TweenLite.killTweensOf(_pieSlicesContainer, true);
            TweenLite.to(_pieSlicesContainer, ROTATION_SHOW_TIME,
                {
                    rotation:rotation
                }
            );
            
        }
        
        private function getPieSlice(index:uint):PieSlice
        {
            var result:PieSlice = _pieSlicesContainer.getChildByName(PieChartViewer.SLICE + index) as PieSlice;
            return result;
        }
        
        override public function dispose():void 
        {
            removeEventListeners();
            clearPieSlices();
            _pieSlicesContainer = null;
			clearContent();
            super.dispose();
        }
        
        override public function setStyle(name:String, value:String):void 
        {
            super.setStyle(name, value);
            
            if (name === 'animate') {
                setPiePerformer(value);
            }
        }
        
        private function setBlurState(exceptPie:ChartElement = null):void 
        {
            setPiesState(PieSliceStates.BLUR, exceptPie);
        }
        
        /**
         * 监听PieSliceEvent.RESET_PIE事件的回调函数。
         * 复原除PieSlice的name为currentViewName外的ChartElementView的状态。
         * @param	event 为PieSliceEvent类型,target为PieSlice类型
         */
        private function resetPies(exceptPie:ChartElement = null):void 
        {
            setPiesState(PieSliceStates.NORMAL, exceptPie);
        }
        
        private function setPiesState(state:String, exceptPie:ChartElement = null):void
        {
            for each(var each:PieSlice in _pieSlices) {
                if (each != exceptPie) {
                    each.state = state;
                }
            }
        }
        
        /**
         * 根据配置设置pie的Performer.
         */
        private function setPiePerformer(animate:String):void
        {
            var performerFunction:Function = PiePerformerFunctions.getPerformerFunction(animate);
			var performer:IPerformer;
            if (performerFunction != null)
            {
				performer = new PiePerformer(performerFunction);
            }
            else
            {
                performer = SimplePerformer.instance;
            }
            skin.performer = performer;
        }
        
        private function mouseOutHandler(e:MouseEvent):void 
        {
            _trigger = setTimeout(checkMouseAbove, 500);
            dispatchChartUIEventForPieChart(e,ChartUIEvent.BLUR_ITEM);
        }
        
        private function mouseClickHandler(e:MouseEvent):void 
        {
            dispatchChartUIEventForPieChart(e,ChartUIEvent.CLICK_ITEM);
        }
        
        private function mouseOverHandler(e:MouseEvent):void 
        {
            var slice:PieSlice = e.target as PieSlice;
            if (slice && slice.index >= 0) 
            {
                if (!_showingDetail)
                {
                    clearTrigger();
                    resetPies();
                    
                    if (slice is GroupPieSlice)
                    {
                        var data:GroupPieSliceData = slice.model as GroupPieSliceData;
                        var sliceDatas:Vector.<PieSliceData> = data.sliceDatas;
                        for each (var sliceData:PieSliceData in sliceDatas) 
                        {
                            chart.data.setDatasetActivity(sliceData.index, true);
                        }
                        setDatasetActivity(slice.index, true);
                    }else if (slice is PieSlice)
                    {
                        chart.setDatasetActivity(slice.index, true);
                    }
                }
                
                if (chartModel.enableTooltip) {
                    var tip:Tooltip = Tooltip.instance;
                    tip.text = getTip(slice);
                    tip.state = 'normal';
                    var center:Point = slice.getContentCenter(this);
                    tip.goto(center.x, center.y);
                }
            }
            dispatchChartUIEventForPieChart(e,ChartUIEvent.FOCUS_ITEM);
        }
        
        private function getTip(slice:PieSlice):String 
        {
            var tooltipStyleObj:Object = chart.styleSheet.getStyle("tooltip");
            var color:String = tooltipStyleObj["color"];
            //若viewr有指定的tip就按指定的tip显示tooltip，否则就显示默认
            var result:String = tooltipStyleObj["tip"];
            var data:PieSliceData = slice.model as PieSliceData;
            var value:Number = data.value;
            var total:Number = chartModel.data.total;
            var percentStr:String = ChartUtil.getPercentStr(data.percent);
            var brReg:RegExp = /<br(?: *\/)?>/g;
            var maxchar:Number = StyleUtil.getNumberStyle(Tooltip.instance, "maxchar");
            var name:String = data.name;
            var titleColor:String = ColorUtil.int2str(ChartUtil.getColor(data, data.index));
            var coloredName:String = '<font color="' + titleColor + '">' + name + '</font>';
            var detailInfo:String = "";
            name = ChartUtil.getRestrictTxt(name, maxchar);
            if (result) {
                result = result.replace("#label#", coloredName)
                    .replace("#name#", name)
                    .replace("#title#", name)
                    .replace("#value#", value)
                    .replace("#total#", total)
                    .replace("#percent#", percentStr)
                    .replace(brReg,"\n");
                result = "<font color='" + color + "'>" + result + "</font>";
            } else {
                result = "<font color='" + color + "'>" + name + "</font>";
            }
            if (slice is GroupPieSlice)
            {
                //TODO: 默认文案不能使用中文（开源需要），这里应做成配置项
                // 进行 l18n 
                if (!_showingDetail)
                {
                    detailInfo = "\n<b><font color='" + color + "'>点击图表查看详细</font></b>";
                }else 
                {
                    detailInfo = "\n<b><font color='" + color + "'>点击回到整个图表</font></b>";
                }
                
                result += detailInfo;
            }
            return result;
        }
        
        private function mouseUpHandler(e:MouseEvent):void 
        {
            dispatchChartUIEventForPieChart(e,ChartUIEvent.MOUSE_UP_ITEM);
        }
        
        private function mouseDownHandler(e:MouseEvent):void 
        {
            dispatchChartUIEventForPieChart(e, ChartUIEvent.MOUSE_DOWN_ITEM);
            
            var slice:PieSlice = e.target as PieSlice;
            toggleSlice(slice);
        }
        
        private function rollOutHandler(e:MouseEvent):void 
        {
            hideTooltip();
        }
        
        private function hideTooltip():void 
        {
            if(chartModel && chartModel.enableTooltip){
                ChartUtil.hideTooltip();
            }
        }
        
        private function checkMouseAbove():Boolean
        {
            if (stage && !hitTestPoint(stage.mouseX, stage.mouseY, true)) {
                if (!_showingDetail)
                {
                    resetPies();
                }
                hideTooltip();
				return false;
            }
			return true;
        }
        
        private function clearTrigger():void
        {
            if (_trigger) {
                clearTimeout(_trigger);
                _trigger = 0;
            }
        }
        
        private function dispatchChartUIEventForPieChart(e:MouseEvent, type:String):void 
        {
            var slice:PieSlice = e.target as PieSlice;
            if (slice) {
                var data:Object = getChartUIEventData(slice);
                dispatchChartUIEvent(type,data);
            }
        }
        
        private function getChartUIEventData(slice:PieSlice):Object
        {
            var result:Object = { };
            if (slice)
            {
                var data:PieSliceData = slice.model as PieSliceData;
                result = {
                    name: data.name,
                    index: data.index,
                    value: data.value,
                    percent: data.value / chartModel.data.total
                }; 
            }
            return result;
        }
    }

}