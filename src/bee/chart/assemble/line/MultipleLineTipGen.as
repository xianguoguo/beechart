package bee.chart.assemble.line 
{
    import cn.alibaba.util.ColorUtil;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.util.ChartUtil;
	import bee.chart.util.StringFormater;
    import flash.utils.Dictionary;
    
	/**
     * 同时显示多个数据值的toolip文本生成
     * @author hua.qiuh
     */
    public class MultipleLineTipGen 
    {
        static public function getTipText(chart:Chart, xIndex:int, value:Number):String 
        {
            var data:ChartData = chart.data;
            var unit:String = data.valueUnit;
            var dsets:Vector.<ChartDataSet> = new Vector.<ChartDataSet>;
            var dSet:ChartDataSet, v:Number;
            var parts:Vector.<String> = new Vector.<String>;
			var valueLabelFormat:String = chart.getStyle("valueLabelFormat");
            for each(dSet in data.visibleSets) {
                if (xIndex < dSet.length && !isNaN(v = dSet.getValueAt(xIndex)) ) {
                    if (isNaN(value) || value === v) {
                        parts.push( getActiveTipForLine(dSet, v, unit, valueLabelFormat) );
                    } else {
                        parts.push( getDeactiveTipForLine(dSet, v, unit, valueLabelFormat) );
                    }
                }
            }
            var label:String = data.getLabelAt(xIndex);
			
            if (parts.length === 1 && label) {
                var labelTip:String = data.labelDesc ? data.labelDesc + ' : ' + label : label;
                parts.unshift(labelTip);
            }
            return parts.join('\n');
        }
        
        static private function getDeactiveTipForLine(dSet:ChartDataSet, value:Number, unit:String = "", valueLabelFormat:String = ""):String 
        {
            var index:int = dSet.index;
            var valueColor:String;
            var color:String = valueColor = '#999999';
            return '<font color="' + color + '">' + 
                        getMaxChar(dSet.name) + ' : ' +
                    '</font>' +
                    '<font color="' + valueColor + '">' +
                        getValueText(value, dSet.valueType, valueLabelFormat) + ' ' + unit +
                    '</font>';
        }
        
        static private function getActiveTipForLine(dSet:ChartDataSet, value:Number, unit:String = "", valueLabelFormat:String = ""):String 
        {
            var index:int = dSet.index;
            var color:String = ColorUtil.int2str(ChartUtil.getColor(dSet));
            return '<font color="' + color + '">' + 
                        '<b>' + getMaxChar(dSet.name) + '</b> : ' + 
                        getValueText(value, dSet.valueType, valueLabelFormat) + ' ' + unit +
                    '</font>'
        }
        
        static private function getMaxChar(name:String, max:uint=20):String 
        {
            if (name.length > max) {
                name = name.substr(0, max - 3) + '...';
            }
            return name;
        }
        
        static private function getValueText(value:Number, type:String, valueLabelFormat:String):String 
        {
			return isNaN(value) ? '--' : StringFormater.format( value, valueLabelFormat, type || "number");
		}
        
    }

}