package bee.chart.builder 
{
    import assets.FileAssests;
    import cn.alibaba.yid.chart.builder.components.*;
    import mx.collections.ArrayCollection;
    /**
    * ...
    * @author hua.qiuh
    */
    public const CHART_SETTING:ArrayCollection = new ArrayCollection([
    
        /** Line **/
        {
            type        : ChartTypes.LINE,
            image       : FileAssests.lineChartImg,
            tooltip     : "折线图",
            klass       : LineEditorMain
        },
        
        /** Bar **/
        {
            type        : ChartTypes.BAR,
            image       : FileAssests.barChartImg,
            tooltip     : "柱状图",
            klass       : BarEditorMain
        },
        
        /** Pie **/
        {
            type        : ChartTypes.PIE,
            image       : FileAssests.pieChartImg,
            tooltip     : "饼图",
            klass       : PieEditorMain
        }
    ]);

}