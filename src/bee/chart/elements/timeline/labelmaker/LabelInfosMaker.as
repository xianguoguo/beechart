package bee.chart.elements.timeline.labelmaker
{
    import bee.chart.elements.timeline.labelmaker.DateTimeUnit;
    import bee.chart.elements.timeline.labelmaker.TimeLabelMaker;
    import bee.chart.util.ChartUtil;
    import flash.geom.Point;
    import flash.text.TextField;
    
    /**
     * 生成时间数据信息的基类
     * @author ...
     */
    public class LabelInfosMaker
    {
        protected var tempFormatTF:TextField;
        protected function transDateStr2Num(dataLabels:Vector.<String>):Vector.<Number>
        {
            var result:Vector.<Number> = new Vector.<Number>();
            for each (var dateStr:String in dataLabels)
            {
                result.push(TimeLabelMaker.dateLabel2miliseconds(dateStr));
            }
            return result;
        }
        
        protected function getLabelIndexs(minOrMajMilSecLabels:Vector.<Number>, milSecDateLabels:Vector.<Number>):Vector.<int>
        {
            var indexs:Vector.<int> = new Vector.<int>();
            var milSecDateLabel:Number;
            var labelIndex:int;
            for each (milSecDateLabel in minOrMajMilSecLabels)
            {
                labelIndex = ChartUtil.getIndex(milSecDateLabel, milSecDateLabels);
                indexs.push(labelIndex);
            }
            return indexs;
        }
        
        protected function takeLabelShow(labelInfos:Vector.<LabelInfo>, minOrMajMilSecLabelIndexs:Vector.<int>, milSecDateLabels:Vector.<Number>, intervalUnit:String, isMajor:Boolean = false):void
        {
            var milSecDateLabel:Number = 0.0;
            var labelIndex:int = -1;
            var labelInfo:LabelInfo;
            for each (labelIndex in minOrMajMilSecLabelIndexs)
            {
                labelInfo = getLabelInfo(labelInfos, labelIndex);
                if (labelInfo)
                {
                    labelInfo.textVisible = true;
					labelInfo.lineVisible = true;
                    labelInfo.text = getFormatLabel(milSecDateLabels[labelIndex], intervalUnit, isMajor);
					//需要显示的标签，因文字修改，故需要重新计算Size
                    setLabelInfoSize(labelInfo);
                }
            }
        }
        
        protected function getFormatLabel(milSecDateLabel:Number, intervalUnit:String, isMajor:Boolean = false):String
        {
            var result:String = "";
            var date:Date = new Date(milSecDateLabel);
            if (isNaN(milSecDateLabel))
            {
                return "NaN";
            }
            switch (intervalUnit)
            {
                case DateTimeUnit.YEAR: 
                    result = date.getUTCFullYear() + "年";
                    break;
                case DateTimeUnit.MONTH: 
                    result = (date.getUTCMonth() + 1) + "月";
                    break;
                case DateTimeUnit.DAY: 
                    result = date.getUTCDate() + "";
                    break;
            }'<font face="SimSun">你好啊abc</font>'
            if (isMajor)
            {
                result = "<font color='#666666'>" + result + "</font>";
            }
            return result;
        }
        
        protected function doLabelInfosSize(labelInfos:Vector.<LabelInfo>):void
        {
            for each (var labelInfo:LabelInfo in labelInfos)
            {
                setLabelInfoSize(labelInfo);
            }
        }
        
        protected function setLabelInfoSize(labelInfo:LabelInfo):void
        {
            tempFormatTF.htmlText = labelInfo.text;
            labelInfo.width = tempFormatTF.width;
            labelInfo.height = tempFormatTF.height;
        }
        
        protected function doLabelInfosPos(labelInfos:Vector.<LabelInfo>):void
        {
            for each (var labelInfo:LabelInfo in labelInfos)
            {
                labelInfo.pos = getLabelPosition(labelInfo);
            }
        }
        
        protected function getLabelInfo(labelInfos:Vector.<LabelInfo>, labelIndex:int):LabelInfo
        {
            return null;
        }
        
        protected function getLabelPosition(labelInfo:LabelInfo):Point
        {
            return new Point();
        }
        
        protected function getNumber(label:String):Number
        {
            return Number(label.replace(/[^-.0-9e]/g, ''));
        }
    }

}