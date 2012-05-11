package bee.chart.assemble.line 
{
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.log;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.util.AutoColorUtil;
    import bee.chart.util.StringFormater;
    import bee.util.StyleUtil;
    import bee.chart.util.ChartUtil;
    import bee.chart.elements.tooltip.Tooltip;
	/**
    * ...
    * @author hua.qiuh
    */
        
    public function LineChartTipTextGen(chart:Chart, xIndex:Number, value:Number):String
    {
        var titles:Vector.<String> = new Vector.<String>();
        var descs:Vector.<String> = new Vector.<String>();
        var tip:String = "";
        var data:ChartData = chart.data;
        var dSet:ChartDataSet;
        var color:uint;
        var maxchar:Number = StyleUtil.getNumberStyle(Tooltip.instance, "maxchar");
        var name :String = ""; 
        for each(dSet in data.visibleSets) {
            if (dSet.hasPoint(xIndex, value)) {
                color = ChartUtil.getColor(dSet);
                name = ChartUtil.getRestrictTxt(dSet.name, maxchar);
				var colorStr:String = ColorUtil.int2str(color);
				if(dSet.name){
               	 	titles.push(
                        "<b>" + 
                            "<font color='" + colorStr + "'>" + 
                                dSet.name + 
                            "</font>" + 
                        "</b> " + 
                        data.labelUnit
                    );
				}
            }
        }
        
        var label:String = xIndex > data.labels.length -1 ? "--":data.labels[xIndex];
        
        var labelDesc:String = data.labelDesc;
        if (labelDesc) labelDesc = labelDesc.concat(': ');
        var valueDesc:String = data.valueDesc;
        if (valueDesc) valueDesc = valueDesc.concat(': ');
        var titleStr:String = "";
		if(titles.length){
			titleStr = titles.join(', ').concat('<br/>\n');
		}
        
        tip = titleStr
            + labelDesc + "<b>" + label +"</b> " + data.labelUnit
            + "\n" + valueDesc + "<b>" 
            + StringFormater.format(value, null, 'number')
            +"</b> " + data.valueUnit;
            
        return tip;
    }

}