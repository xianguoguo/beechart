package bee.chart.release 
{
    import bee.chart.abstract.CartesianChart;
    import bee.chart.abstract.Chart;
    import bee.chart.assemble.pie.PieChartViewer;
    import bee.chart.elements.tooltip.TooltipForAliPrinter;
    import bee.chart.elements.tooltip.TooltipView;
    import bee.plugins.pie.performer.ClockwisePerformerPlugin;
	
	/**
     * ...
     * @author hua.qiuh
     */
    public class BeePieChart extends CartesianChart 
    {
        
        public function BeePieChart() 
        {
            TooltipView.defaultStatePrinter = new TooltipForAliPrinter;
            
            var pluginClz:Vector.<Class> = (new <Class>[ClockwisePerformerPlugin]);
            
            super(PieChartViewer, null, pluginClz);
        }
        
        override protected function initChart():void 
        {
            var presetCSS:String = <![CDATA[
                chart {
                    colors          : #FA6222, #FEC53F, #DBEE27, #87C822, #49AFB1;
                    //smooth          : true;不能为smooth，否则初始动画会失效；代码后续会将smooth传递给PieSlice，现已经去除；
                    animate         : clockwise;
                    order           : none;
                    startAngle      : 0;
                    enableTooltip   : true;
                }

                tooltip {
                    tip : <b>#label#</b><br>#percent#<br>#value# / #total#;
                    backgroundAlpha   : 0.95;
                    backgroundType    : slash;
                    backgroundColor   : #FFFFFF;
                    backgroundAlpha   : 0.8;
                    borderColor       : #666666;
                    borderAlpha       : 1;
                    borderThickness   : 2;
                }

                slice {
                    labelPosition         : normal;
                    pieSliceAlpha         : 1;
                    frameThickness        : 2;
                    frameColor            : #FFFFFF;
                    pieLineThickness      : 1;
                    pieLineAlpha          : 1;
                    offsetRadius          : 0;
                    donutThickness        : 0;
                    donutMaskColor        : #FFFFFF;
                    donutMaskAlpha         :0.85
                    pieSliceAlpha.blur    : 0.5;
                    pieSliceAlpha.hl      : 1;
                    frameThickness.hl     : 2;
                    frameColor.hl         : #FFFFFF;
                    pieLineThickness.hl   : 1;
                    pieLineAlpha.hl       : 1;
                    offsetRadius.hl       : 20;
                    donutThickness.hl     : 0;
                    donutMaskColor.hl     : #FFFFFF;
                    donutMaskAlpha.hl     : 0.85;
                }

                legend {
                    position        : bottom;
                    align           : center;
                    paddingRight    : 0;
                    itemEachColumn  : 4;
                    interactive     : true;
                }

                legend item label {
                    color           : inherit;
                }
            ]]>;
            
            parseCSS(presetCSS);
            
            super.initChart();
        }
        
    }

}