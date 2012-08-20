package bee.chart.elements.timeline.labelmaker
{
	import bee.chart.abstract.Chart;
	import bee.chart.abstract.ChartData;
    
    /**
     * 生成时间显示的类
     * @author jianping.shenjp
     */
    public class TimeLabelMaker
    {
        
		/**
		 * 生成主、副时间的数据集
		 * @param	data
		 * @param	dateTimeInterval
		 * @param	displayMajorMilSecLabels
		 * @param	displayMinorMilSecLabels
		 */
        static public function generate(data:ChartData, dateTimeInterval:DateTimeInterval, displayMajorMilSecLabels:Vector.<Number> = null, displayMinorMilSecLabels:Vector.<Number> = null):void
        {
            var allLabels:Vector.<String> = data.allLabels;
            var labelsInCurrentRange:Vector.<String> = data.labels;
            var min:Number = TimeLabelMaker.dateLabel2miliseconds(allLabels[0]);
            var max:Number = TimeLabelMaker.dateLabel2miliseconds(allLabels[allLabels.length - 1]);
            if (isNaN(min) || isNaN(max)) {
                return;
            }
            var startDateLabel:String = labelsInCurrentRange[0];
            var endDateLabel:String = labelsInCurrentRange[labelsInCurrentRange.length - 1];
            
            var startDateMiliseconds:Number = dateLabel2miliseconds(startDateLabel);
            var endDateMiliseconds:Number = dateLabel2miliseconds(endDateLabel);
            //trace( startDateLabel, endDateLabel, numLabelInRange);
            
            dateTimeInterval.initializeMinMax(min, max);
            dateTimeInterval.initVisibleOnScale(startDateMiliseconds, endDateMiliseconds);
            //trace(dateTimeInterval);
            var minorIntervalValue:Number = NaN;
            var preMajorIntervalValue:Number = NaN;
            var nextMajorIntervalValue:Number = NaN;
            var numloop:int = 1;
            var majorIntervalIndex:int = 0;
            var majorIntervalValue:Number = dateTimeInterval.getMajorIntervalValue(majorIntervalIndex);
			//所计算出来的主时间 > 初始时间
            if (majorIntervalValue > startDateMiliseconds)
            {
                preMajorIntervalValue = dateTimeInterval.getMajorIntervalValue((majorIntervalIndex - 1));
                minorIntervalValue = dateTimeInterval.getMinorIntervalValue(preMajorIntervalValue, numloop);
                while (minorIntervalValue < startDateMiliseconds)
                {
                    //trace("while 1");
                    numloop++;
                    minorIntervalValue = dateTimeInterval.getMinorIntervalValue(preMajorIntervalValue, numloop);
                }
                
                //加入初始主单位时间
                if (minorIntervalValue < majorIntervalValue)
                {
                    if (displayMajorMilSecLabels)
                    {
                        displayMajorMilSecLabels.push(preMajorIntervalValue);
                    }
                }
                
                //加入符合条件的副单位时间
                while (minorIntervalValue < majorIntervalValue)
                {
                    //trace("while 2~~~",showFormatDate(minorIntervalValue));
                    if (displayMinorMilSecLabels)
                    {
                        displayMinorMilSecLabels.push(minorIntervalValue);
                    }
                    numloop++;
                    minorIntervalValue = dateTimeInterval.getMinorIntervalValue(preMajorIntervalValue, numloop);
                }
            }
			//所计算出来的主时间 < 结束时间
            while (majorIntervalValue < endDateMiliseconds)
            {
                //trace("while 3~~~",showFormatDate(majorIntervalValue));
                //加入主单位时间
                if (displayMajorMilSecLabels)
                {
                    displayMajorMilSecLabels.push(majorIntervalValue);
                }
                nextMajorIntervalValue = dateTimeInterval.getMajorIntervalValue((majorIntervalIndex + 1));
                numloop = 1;
                minorIntervalValue = dateTimeInterval.getMinorIntervalValue(majorIntervalValue, numloop);
                //加入副单位时间
                while (minorIntervalValue < nextMajorIntervalValue && minorIntervalValue < endDateMiliseconds)
                {
                    //trace("while 4~~~",showFormatDate(minorIntervalValue));
                    if (displayMinorMilSecLabels)
                    {
                        displayMinorMilSecLabels.push(minorIntervalValue);
                    }
                    numloop++;
                    minorIntervalValue = dateTimeInterval.getMinorIntervalValue(majorIntervalValue, numloop);
                }
                majorIntervalIndex++;
                majorIntervalValue = dateTimeInterval.getMajorIntervalValue(majorIntervalIndex);
            }
        }

        /**
         * 将时间字符数据转换成毫秒数
         * @param	dateLabel
         * @return
         */
        static public function dateLabel2miliseconds(dateLabel:String):Number
        {
            var dateReg:RegExp = /(\d+)-(\d+)-(\d+)/;
            var m:Array = dateLabel.match(dateReg);
            if (m)
            {
                return Date.UTC(string2Number(m[1]), string2Number(m[2]) - 1, string2Number(m[3]));
            }
            return Number.NaN;
            
            function string2Number(str:String):Number
            {
                return Number(str);
            }
        }
    
    }

}