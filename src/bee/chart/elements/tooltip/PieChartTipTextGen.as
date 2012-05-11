package bee.chart.elements.tooltip 
{
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartData;
    import bee.util.StyleUtil;
    import bee.chart.util.ChartUtil;
    import bee.chart.elements.tooltip.Tooltip;
    /**
     * 显示pie图表tooltip信息的函数
     * @author jianping.shenjp
     * @param	chart
     * @param	index 图表中数据的序列号
     * @param	value
     * @return
     */
    public function PieChartTipTextGen(chart:Chart, index:Number, value:Number):String
    {
		if(!chart || !chart.styleSheet){
			return "";
		}
        var tooltipStyleObj:Object = chart.styleSheet.getStyle("tooltip");
		var color:String = tooltipStyleObj["color"];
        //若viewr有指定的tip就按指定的tip显示tooltip，否则就显示默认
        var tip:String = tooltipStyleObj["tip"];
        var chartData:ChartData = chart.data;
        var data:ChartDataSet = chartData.allSets[index];
        
        var value:Number = data.values[0];
        var total:Number = chartData.total;
        var percentStr:String = ChartUtil.getPercentStr(value / total);
		var brReg:RegExp = /<br(?: *\/)?>/g;
        var maxchar:Number = StyleUtil.getNumberStyle(Tooltip.instance, "maxchar");
        var name:String = data.name;
        name = ChartUtil.getRestrictTxt(name, maxchar);
        if (tip) {
            tip = tip.replace("#label#", name)
				.replace("#value#", value)
                .replace("#total#", total)
                .replace("#percent#", percentStr)
                .replace(brReg,"\n");
            tip = "<b><font color='" + color + "'>" + tip + "</font></b>";
        } else {
            tip = "<b><font color='" + color + "'>" + name + "</font></b>";
        }
        return tip;
    }
}
