package bee.chart.assemble.pie
{
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartModel;
    import bee.chart.abstract.ChartStates;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.assemble.ChartBasicPrinter;
    import bee.chart.assemble.pie.PieChartViewer;
    import bee.chart.elements.legend.Legend;
    import bee.chart.elements.legend.LegendAlign;
    import bee.chart.elements.legend.LegendPosition;
    import bee.chart.elements.pie.LabelPosition;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSlice2dDrawPrinterForNormal;
    import bee.chart.elements.pie.PieSlice2dDrawPrinterOutside;
    import bee.chart.elements.pie.PieSlice2dDrawPrinterWithInsideLabel;
    import bee.chart.elements.pie.PieSlice2dDrawPrinterWithLabel;
    import bee.chart.elements.pie.PieSlice2dDrawPrinterWithLabelCallout;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.pie.PieSlicePerformer;
    import bee.chart.elements.pie.PieSliceStates;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.printers.IStatePrinter;
    import bee.printers.IStatePrinterWithUpdate;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    /**
     * PieChartViewer的绘制类
     * @author jianping.shenjp
     */
    public class PieChartPrinter extends ChartBasicPrinter implements IStatePrinterWithUpdate
    {
        private var orderType:String = "";
        
        override protected function renderNormalState(host:ChartViewer, context:DisplayObjectContainer):void 
        {
            super.renderNormalState(host, context);
            clearContent(context);
            var viewer:PieChartViewer = host as PieChartViewer;
            var chartModel:ChartModel = viewer.chartModel;
            var w:Number = chartModel.chartWidth;
            var h:Number = chartModel.chartHeight;
            
            drawPieSlices(viewer, w, h, context);
            setGetoutJam(viewer);
            var rect:Rectangle = new Rectangle().union(viewer.getRect(viewer));
            var legendStyle:Object      = viewer.styleSheet.getStyle('legend');
            var legendPosition:String   = legendStyle["position"];
            if (legendPosition && legendPosition != LegendPosition.NONE)
            {
                drawLegend(viewer, w, h, context, rect);
            }
            
            if (chartModel.enableTooltip)
            {
                drawTooltip(viewer, w, h, context);
            }
            
            viewer.arrangeSliceLabels(viewer.chart, viewer.pieSlices);
            viewer.makeSelfCenter();
            
            viewer = null;
        }
        
        /**
         * 绘制圆饼
         * @param	pieChartViewer
         * @param	width
         * @param	height
         */
        private function drawPieSlices(viewer:PieChartViewer, width:Number, height:Number, context:DisplayObjectContainer):void
        {
            viewer.clearPieSlices();
            var pieslices:Vector.<PieSlice>;
            var sliceStyle:Object     = viewer.styleSheet.getStyle("slice");
            //这里不不能讲smooth赋给pieSlice，为true情况下，初始动画会失效
            //sliceStyle["smooth"] = viewer.getStyle("smooth");
            const chartModel:ChartModel = viewer.chartModel;
            const radius:Number         = Math.min(width, height) >> 1;
            orderType = viewer.getStyle("order");
            var datas:Vector.<PieSliceData> = (new PieChartDataHandle()).handleData(chartModel, orderType);
            setStartRadian(datas,StyleUtil.getNumberStyle(viewer,"startAngle",0));
            var pieSlices:Vector.<PieSlice> = createPieSlice(datas, viewer, sliceStyle);
            addPieSlices(pieSlices, viewer);
            
            pieslices = viewer.pieSlices;
            
            if (isCalloutPos(viewer))
            {
                (new SerialNumAction ()).assignSerialNumProcedure(pieslices, viewer.chart);
            }
            
            for each (var pieSlice:PieSlice in pieslices) 
            {
                reSetPieSlicePrinter(pieSlice);
                pieSlice.state = PieSliceStates.NORMAL;
            }
            pieslices = null;
            
            addBg(viewer, radius);
        }

        private function setStartRadian(datas:Vector.<PieSliceData>, startAngle:Number):void 
        {
            var tempStartRadian:Number = startAngle * PieSliceData.TO_RADIANS;
            for each (var pieSliceData:PieSliceData in datas) 
            {
                pieSliceData.startRadian = tempStartRadian;
                tempStartRadian += pieSliceData.radian;
            }
        }
        
        private function createPieSlice(datas:Vector.<PieSliceData>, viewer:PieChartViewer, sliceStyle:Object):Vector.<PieSlice> 
        {
            var result:Vector.<PieSlice> = new Vector.<PieSlice>();
            
            for each (var data:PieSliceData in datas) 
            {
                var pieSlice:PieSlice = data.createPieSlice(viewer);
                pieSlice.name = PieChartViewer.SLICE + data.index;
                setPieSliceDataAndStyle(pieSlice, data, sliceStyle, viewer);
                result.push(pieSlice);
            }
            return result;
        }
        
        private function addPieSlices(pieSlices:Vector.<PieSlice>, viewer:PieChartViewer):void 
        {
            var pieSlicesContainer:Sprite = viewer.pieSlicesContainer;
            makePieSlicesContainerCenter(viewer);
            for each (var pieSlice:PieSlice in pieSlices) 
            {
                viewer.addElement(pieSlice);
                pieSlicesContainer.addChild(pieSlice);
            }
            viewer.content.addChild(pieSlicesContainer);
        }
         
        private function isCalloutPos(viewer:PieChartViewer):Boolean 
        {
            var result:Boolean = false;
            var sliceStyle:Object = viewer.styleSheet.getStyle("slice");
            var labelPosition:String = sliceStyle["labelPosition"];
            if (labelPosition == LabelPosition.NORMAL || labelPosition == LabelPosition.CALLOUT)
            {
                result = true;
            }
            return result;
        }
        
        private function setGetoutJam(viewer:PieChartViewer):void 
        {
            if (isCalloutPos(viewer))
            {
                viewer.setGetoutjam(new GetoutJamForCallout());
            }else {
                viewer.setGetoutjam(new GetoutJam());
            }
        }
        
        /**
        * 添加一个隐藏的背景
        * 防止不经意间触发mouseOut事件
        * 改善用户体验
        * @param	context
        * @param	centerX
        * @param	centerY
        * @param	radius
        */
        private function addBg(viewer:PieChartViewer, radius:Number):void 
        {
            const centerX:Number = 0;
            const centerY:Number = 0;
            var pieSlicesContainer:Sprite = viewer.pieSlicesContainer;
            var bg:Shape = new Shape();
            var g:Graphics = bg.graphics;
            g.beginFill(0, 0);
            g.drawCircle(centerX, centerY, radius);
            g.endFill();
            pieSlicesContainer.addChildAt(bg, 0);
        }
        
        private function setPieSliceDataAndStyle(pieSlice:PieSlice, pieSliceData:PieSliceData, sliceStyle:Object, viewer:PieChartViewer):void 
        {
            pieSlice.setModel(pieSliceData);
            pieSlice.setStyles(sliceStyle);
            pieSlice.styleSheet.setStyle('label', StyleUtil.inheritStyle(
                viewer.styleSheet.getStyle('slice label'),
                pieSlice
            ));
        }
        
        /**
         * 根据配置，重新设置PieSlice的Printer
         * @param	pieSlice
         */
        private function reSetPieSlicePrinter(pieSlice:PieSlice):void
        {
            /**
             * 根据设定配置performer.
             * mouseAnimate:true 鼠标经过有弹出效果.
             * 				false 鼠标经过无弹出效果.
             * */
            var isMouseAnimateStr:String = pieSlice.chart.getStyle("mouseAnimate");
            var performer:IPerformer;
            if (isMouseAnimateStr == "false") {
                performer = SimplePerformer.instance;
            }else{
                performer = new PieSlicePerformer();
            }
            pieSlice.skin.performer = performer;
            
            var labelPosition:String = pieSlice.getStyle("labelPosition") || "";
            var printer:IStatePrinter;
            printer = pieSlice.skin.statePrinter;
            var printerMap:Object = {
                "":PieSlice2dDrawPrinterWithLabel,
                "normal":PieSlice2dDrawPrinterForNormal,
                "inside":PieSlice2dDrawPrinterWithLabel,
                "inside!":PieSlice2dDrawPrinterWithInsideLabel,
                "outside":PieSlice2dDrawPrinterOutside,
                "callout":PieSlice2dDrawPrinterWithLabelCallout
            }
            for(var str:String in printerMap) {
                if (str == labelPosition) {
                    printer = new printerMap[str](printer);
                    break;
                }
            }
            pieSlice.skin.statePrinter = printer;
        }
        
        /**
         * 添加鼠标提示
         */
        override protected function drawTooltip(host:ChartViewer, width:Number, height:Number, context:DisplayObjectContainer):void
        {
            super.drawTooltip(host, width, height, context);
            var tooltip:Tooltip = Tooltip.instance;
            tooltip.bounds = new Rectangle(0, 0, width, height);
        }
        
        /**
         * 绘制Legend
         * @param	host
         * @param	width
         * @param	height
         * @param	context
         */
        protected function drawLegend(host:ChartViewer, width:Number, height:Number, context:DisplayObjectContainer, rect:Rectangle):void
        {
            var viewer:PieChartViewer = host as PieChartViewer;
            var chartModel:ChartModel = viewer.chartModel;
            var datas:Vector.<PieSliceData> = (new PieChartDataHandle()).handleData(chartModel, orderType, false);
            var dataSets:Vector.<ChartDataSet> = pieSliceData2ChartDataSet(datas);
            
            var style:Object  = StyleUtil.mergeStyle( 
                { }, 
                host.styleSheet.getStyle('legend')
            );
            if (!style['position'] || style['position']=='none') {
                return;
            }
            
            var legend:Legend   = new Legend();
            legend.name = "legend";
            var pos:String      = style['position'];
            switch(pos) {
                case LegendPosition.OUT_BOTTOM:
                    style['maxWidth'] = width;
                    break;
                case LegendPosition.OUT_TOP:
                    style['maxWidth'] = width;
                    break;
                case LegendPosition.OUT_LEFT:
                    style['maxHeight'] = height;
                    break;
                case LegendPosition.OUT_RIGHT:
                    style['maxHeight'] = height;
                    break;
            }
            legend.dataSets = dataSets;
            legend.setStyles(style);
            
            StyleUtil.inheritStyleSheet( legend, 'legend', viewer );
            
            legend.behavior = new PieLegendBehavior();
            host.addElement(legend);
            context.addChild(legend);
            legend.updateViewNow();
            
            var align:String  = style['align'] || LegendAlign.CENTER;
            var valign:String = style['valign'] || LegendAlign.MIDDLE;
            var x:Number = 0,   y:Number = 0;
            var checkH:Boolean  = false;
            var checkV:Boolean  = false;
            const PADDING:uint    = 0;
            
            var bound:Rectangle = legend.getBounds(legend);
            var w:Number    = bound.width;
            var h:Number    = bound.height;
            
            switch(pos) {
                case LegendPosition.INNER:
                    checkH  = checkV = true;
                    break;
                case LegendPosition.OUT_BOTTOM:
                    checkH  = true;
                    checkV  = false;
                    y       = rect.bottom + PADDING;
                    rect.bottom += h + PADDING;
                    break;
                case LegendPosition.OUT_TOP:
                    checkH  = true;
                    checkV  = false;
                    y       = rect.top - h - PADDING;
                    rect.top -= h + 1;
                    break;
                case LegendPosition.OUT_LEFT:
                    checkH  = false;
                    checkV  = true;
                    x       = rect.left - w - PADDING;
                    rect.left -= w+1;
                    break;
                case LegendPosition.OUT_RIGHT:
                    checkH  = false;
                    checkV  = true;
                    x       = rect.right + PADDING;
                    rect.right += w+1;
                    break;
            }
            
            if(checkH){
                switch(align) {
                    case LegendAlign.LEFT:
                        x = pos == LegendPosition.INNER ? PADDING : 0;
                        break;
                    case LegendAlign.RIGHT:
                        x = width - w;
                        break;
                    case LegendAlign.CENTER:
                    default:
                        x = (width - w) >> 1;
                        break;
                }
            }
            //该处的数值与折线图、柱状图中的数值计算有所差异.
            if(checkV){
                switch(valign) {
                    case LegendAlign.TOP:
                        y = h;
                        break;
                    case LegendAlign.BOTTOM:
                        y =  height;
                        break;
                    case LegendAlign.MIDDLE:
                    default:
                        y = ((height - h) >> 1);
                        break;
                }
            }
            legend.x = x - bound.left;
            legend.y = y - bound.top;
        }
        
        private function pieSliceData2ChartDataSet(datas:Vector.<PieSliceData>):Vector.<ChartDataSet> 
        {
            var result:Vector.<ChartDataSet> = new Vector.<ChartDataSet>();
            for each (var pieSliceData:PieSliceData in datas) 
            {
                result.push(pieSliceData);
            }
            return result;
        }
        
        public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            var viewer:PieChartViewer = host as PieChartViewer;
            _viewer = viewer;
            if (viewer.state != ChartStates.NORMAL) {
                return;
            }
            makePieSlicesContainerCenter(viewer);
            
            var pieSlices:Vector.<PieSlice> = viewer.pieSlices;
            var chartModel:ChartModel = viewer.chartModel;
            var datas:Vector.<PieSliceData> = (new PieChartDataHandle()).handleData(chartModel, orderType);
            setStartRadian(datas,StyleUtil.getNumberStyle(viewer,"startAngle",0));
            //如果之前的圆饼数量与目前的不一样，就重绘；
            if (pieSlices.length != datas.length)
            {
                renderState(host, state, context);
                return;
            }
            
            var sliceStyle:Object = viewer.styleSheet.getStyle("slice");
            //sliceStyle["smooth"] = viewer.getStyle("smooth");
            var pieSlice:PieSlice;
            for each (pieSlice in pieSlices) 
            {
                pieSlice.visible = false;
            }
            for each (pieSlice in pieSlices) 
            {
                for each (var pieSliceData:PieSliceData in datas) 
                {
                    if (pieSlice.index == pieSliceData.index)
                    {
                        pieSlice.visible = true;
                        setPieSliceDataAndStyle(pieSlice, pieSliceData, sliceStyle, viewer);
                        break;
                    }
                }
            }
            if (isCalloutPos(viewer))
            {
                (new SerialNumAction ()).assignSerialNumProcedure(pieSlices,viewer.chart);
            }
            viewer.arrangeSliceLabels(viewer.chart, viewer.pieSlices);
            for each (pieSlice in pieSlices) 
            {
                pieSlice.updateViewNow();
            }
            _viewer = null;
        }
        
        private function makePieSlicesContainerCenter(viewer:PieChartViewer):void 
        {
            viewer.pieSlicesContainer.x = viewer.chartModel.chartWidth >> 1;
            viewer.pieSlicesContainer.y = viewer.chartModel.chartHeight >> 1;
        }
    }
}