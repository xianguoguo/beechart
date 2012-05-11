package bee.chart.data
{
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.assemble.bar.BarChartHorizontalPrinter;
    import bee.chart.assemble.bar.BarChartPrinter;
    import bee.chart.assemble.bar.BarChartViewer;
    import bee.chart.assemble.pie.PieStates;
    import bee.chart.BarChart;
    import bee.chart.util.AutoColorUtil;
    import bee.chart.util.StyleLoader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.text.StyleSheet;
    
    
    
    /**
     * 设置图表data、style的操作类
     */
    public class DataCenter extends EventDispatcher
    {
        private var _chart:Chart;
        //style解析器
        //是否正在读取style样式
        private var _isLoadingStyle:Boolean = false;
        
        public function DataCenter(chart:Chart)
        {
            if (chart)
            {
                _chart = chart;
            }
        }
        
        public function get isLoadingStyle():Boolean
        {
            return _isLoadingStyle;
        }
        
        public function set chart(value:Chart):void
        {
            _chart = value;
        }
        
        /**
         * 添加数据
         * @param	data
         */
        public function setData(sets:Vector.<ChartDataSet>):void
        {
            _chart.data.setDataSets(sets);
            //设置生成颜色的数目
            AutoColorUtil.generaterColorNum = sets.length;
        }
        
        /**
         * 设置图表的某个样式
         * @param styleName
         * @param styleObject
         *
         */
        public function setStyleByName(styleName:String, styleObject:Object):void
        {
            var styleSheet:StyleSheet = _chart.styleSheet;
            var styleObj:Object = styleSheet.getStyle(styleName);
            if (styleObj)
            {
                for (var each:String in styleObject)
                {
                    styleObj[each] = styleObject[each];
                    trace("setStyleByName:", each, " _ " + styleObj[each]);
                }
                styleSheet.setStyle(styleName, styleObj);
                //关于chart的style需要重新设置一下
                var chartStyle:Object = styleSheet.getStyle('chart');
                _chart.setStyles(chartStyle);
                setStyleDefault();
                
                //redrawChart只对新添加的数据进行重绘的判断，防止重绘操作的数据
                var newStyleSheet:StyleSheet = new StyleSheet();
                newStyleSheet.setStyle(styleName, styleObject);
                redrawChart(newStyleSheet);
            }
        }
        
        /**
         *
         * @param	cssString
         */
        public function setStyle(cssString:String = ""):void
        {
            if (cssString)
            {
                _chart.parseCSS(cssString);
            }
            setStyleDefault();
            
            if (_isLoadingStyle)
            {
                dispatchLoadedEvent();
                _isLoadingStyle = false;
            }
        }
        
        /**
         * 分发style读取完毕的事件
         *
         */
        private function dispatchLoadedEvent():void
        {
            dispatchEvent(new Event(StyleLoader.LOADED, true));
        }
        
        /**
         * style样式共同会设置的数据
         * @param styleSheet
         *
         */
        private function setStyleDefault():void
        {
            var chartStyle:Object = _chart.styleSheet.getStyle("chart");
            //chart的高、宽
            var tempVal:Number = Number(chartStyle["chartWidth"]);
            _chart.chartWidth = tempVal ? tempVal : _chart.chartWidth;
            tempVal = Number(chartStyle["chartHeight"]);
            _chart.chartHeight = tempVal ? tempVal : _chart.chartHeight;
            //tooltip是否可用
            var tooltipStyle:Object = _chart.styleSheet.getStyle('tooltip');
            var tooltipEnabledStr:String = tooltipStyle["enabled"]
            if (tooltipEnabledStr == "false")
            {
                _chart.chartModel.enableTooltip = false;
            }
            else
            {
                _chart.chartModel.enableTooltip = true;
            }
            
            //设置颜色 
            var coloursString:String = chartStyle["colors"];
            var colours:Array = [];
            if (coloursString)
            {
                colours = coloursString.split(",");
				AutoColorUtil.reset();
				AutoColorUtil.addColors(colours);
            }
            
            //是否水平(柱状图)
            if (_chart is BarChart)
            {
                var isHorizontal:String = chartStyle["horizontal"];
                var viewer:BarChartViewer = (_chart as BarChart).view as BarChartViewer;
                if (isHorizontal == "true")
                {
                    viewer.horizontal = true;
                    viewer.skin.statePrinter = new BarChartHorizontalPrinter();
                }
                else
                {
                    viewer.horizontal = false;
                    viewer.skin.statePrinter = new BarChartPrinter();
                }
//				_chart.updateViewNow();
            }
        }
        
        /**
         * 重绘chart
         * @param styleSheet
         *
         */
        public function redrawChart(styleSheet:StyleSheet):void
        {
            var chartStyle:Object = styleSheet.getStyle("chart");
            var performerStr:String = chartStyle["animate"];
            if (performerStr)
            {
                _chart.state = PieStates.READY;
                _chart.state = PieStates.NORMAL;
            }
            else
            {
                _chart.updateViewNow();
            }
        }
    }
}