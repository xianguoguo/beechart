package bee.chart.util
{
    import cn.alibaba.util.ColorUtil;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.elements.tooltip.Tooltip;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class ChartUtil
    {

        static public function getColor(dataset:ChartDataSet, ...args):uint
        {
            var result:uint = 0;
            var index:uint = 0;
            if (dataset.styleConfig["color"])
            {
                result = ColorUtil.str2int(dataset.styleConfig["color"]);
            }
            else
            {
				index = args.length === 1 ? Number(args[0]) : dataset.index;
                result = AutoColorUtil.getColor(index);
            }
            return result;
        }

        /**
        * 返回限定长度的文本
        * @param	host
        * @param	text
        * @return
        */
        static public function getRestrictTxt(text:String, maxchar:Number):String 
        {
            var result:String = text;
            var textLength:int = text.length;
            if (maxchar && (textLength > maxchar))
            {
                result = text.substr(0, maxchar)+"...";
            }
            return result;
        }

        static public function hideTooltip():void 
        {
            var tip:Tooltip = Tooltip.instance;
            tip.state = 'hidden';
        }
        
        static public function getPercentStr(percent:Number):String 
        {
            return int(percent * 10000) / 100 + "%";
        }

        /**
         * 返回当前value在数组中的最接近的索引
         * 数组为升序排列的数组.
         * @param	value
         * @param	values
         * @return
         */
        static public function getIndex(value:Number, values:Vector.<Number>):int
        {
            var result:int = -1;
            var temp:int = -1;
            var index:int;
            var tempValue:Number = 0.0;
            var numloop:int = values.length;
            for (index = 0; index < numloop; index++)
            {
                tempValue = values[index];
                if (tempValue == value)
                {
                    result = index;
                    break;
                }
                if (tempValue > value)
                {
                    temp = index - 1;
                    result = ((temp < 0) ? 0 : temp);
                    break;
                }
            }
            return result;
        }
    }

}