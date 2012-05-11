package bee.chart.elements.timeline.labelmaker
{
	import cn.alibaba.core.IDisposable;
	import bee.chart.abstract.Chart;
	import bee.chart.abstract.ChartData;
	import bee.chart.abstract.DataIndexRange;
	import bee.chart.elements.axis.AxisData;
	import bee.chart.elements.axis.AxisDirection;
	import bee.chart.elements.axis.AxisView;
	import bee.chart.elements.timeline.labelmaker.DateTimeInterval;
	import bee.chart.elements.timeline.labelmaker.TimeLabelMaker;
	import bee.chart.util.StringFormater;
	import bee.controls.label.Label;
	import bee.controls.label.LabelSimplePrinter;
	import bee.util.StyleUtil;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * X轴label信息生成类
	 * @author jianping.shenjp
	 */
	public class XAxisLabelInfosMaker extends LabelInfosMaker implements IDisposable
	{
		private var _chart:Chart = null;
		private var _adjust:Number = 0.0;
		private var _tckPosNormal:Boolean = false;
		private var _tickLength:Number = 0.0;
		private var _rot:Number = 0.0;
		private var _axisView:AxisView;
		private var _allLabelInfos:Vector.<LabelInfo>;
		private var _allMilSecDateLabels:Vector.<Number>;
		
		public function initParamter(ax:AxisView, chart:Chart):void
		{
			this._axisView = ax;
			this._chart = chart;
			_adjust = ax.getStyle('labelPosition') === 'center' ? 0.5 : 0;
			_tckPosNormal = ax.getStyle('tickPosition') != 'reverse';
			_tickLength = StyleUtil.getNumberStyle(ax, 'tickLength');
			_rot = StyleUtil.getNumberStyle(ax, 'labelRotation');
			tempFormatTF = returnTempFormatTF();
			makeAllLabelInfosAndAllMilSecDateLabels();
			//测试,提前设置位置
			//doLabelInfosPos(_allLabelInfos);
		}
		
		public function getLabelInfos():Vector.<LabelInfo>
		{		
			var labelInfos:Vector.<LabelInfo>;
			var data:ChartData = _chart.data;
			var labelsInCurrentRange:Vector.<String> = data.labels;
			if (_chart.isTimeline())
			{
				var dataIndexRange:DataIndexRange = data.dataIndexRange;
				labelInfos = copyLabelInfos(_allLabelInfos.slice(dataIndexRange.rangeStart, dataIndexRange.rangeEnd));
				var milSecDateLabels:Vector.<Number> = _allMilSecDateLabels.slice(dataIndexRange.rangeStart, dataIndexRange.rangeEnd);
				resetLabelInfos(labelInfos);
				var dateTimeInterval:DateTimeInterval = new DateTimeInterval();
				var dispalyMajorMilSecLabels:Vector.<Number> = new Vector.<Number>();
				var dispalyMinorMilSecLabels:Vector.<Number> = new Vector.<Number>();
				TimeLabelMaker.generate(data, dateTimeInterval, dispalyMajorMilSecLabels, dispalyMinorMilSecLabels);
				improveShowTime(milSecDateLabels, dispalyMajorMilSecLabels, dispalyMinorMilSecLabels);
				doLabelInfosForTimeLine(labelInfos, milSecDateLabels, dateTimeInterval, dispalyMajorMilSecLabels, dispalyMinorMilSecLabels);
			}
			else
			{
				labelInfos = newLabelInfos(labelsInCurrentRange, true, true);
				doLabelInfosForOther(labelInfos);
			}
			
			//for each (var num:Number in minorMilSecLabels) 
			//{
			//trace(showFormatDate(num), num);
			//}
			//trace("....................");
			
			return labelInfos;
		}
		
		/**
		 * 优化时间显示.
		 * 若显示的时间范围，从最初到最终，为同年相邻月份的情况，则初始的月份不显示，只显示天；
		 * @param	data
		 * @param	dispalyMajorMilSecLabels
		 * @param	dispalyMinorMilSecLabels
		 */
		private function improveShowTime(milSecDateLabels:Vector.<Number>, dispalyMajorMilSecLabels:Vector.<Number>, dispalyMinorMilSecLabels:Vector.<Number>):void 
		{

			var startDateMiliseconds:Number = milSecDateLabels[0];
            var endDateMiliseconds:Number = milSecDateLabels[milSecDateLabels.length - 1];
			var startDate:Date = new Date(startDateMiliseconds);
			var endDate:Date = new Date(endDateMiliseconds);
			if (startDate.getUTCFullYear() == endDate.getUTCFullYear() &&  (endDate.getUTCMonth() - startDate.getUTCMonth() == 1 ))
			{
				dispalyMinorMilSecLabels.push(dispalyMajorMilSecLabels.shift());
			}
		}
		
		protected function newLabelInfos(dateLabels:Vector.<String>, textVisible:Boolean = false, lineVisible:Boolean = false, isTimeLine:Boolean = false):Vector.<LabelInfo>
		{
			var result:Vector.<LabelInfo> = new Vector.<LabelInfo>();
			var label:String = "";
			var labelInfo:LabelInfo;
			var index:int = 0;
			for each (label in dateLabels)
			{
				if (!isTimeLine)
				{
					label = StringFormater.format(
                    label, 
                    _axisView.getStyle('labelFormat'),
                    _axisView.getStyle('labelDataType'));
				}
				labelInfo = new LabelInfo(label, textVisible, lineVisible);
				labelInfo.index = index;
				result.push(labelInfo);
				index++;
			}
			return result;
		}
		
		private function copyLabelInfos(labelInfos:Vector.<LabelInfo>):Vector.<LabelInfo>
		{
			var result:Vector.<LabelInfo> = new Vector.<LabelInfo>();
			for each (var labelInfo:LabelInfo in labelInfos)
			{
				result.push(labelInfo.clone());
			}
			return result
		}
		
		private function makeAllLabelInfosAndAllMilSecDateLabels():void
		{
			var data:ChartData = _chart.data;
			var allLabels:Vector.<String> = data.allLabels;
			_allLabelInfos = newLabelInfos(allLabels, false, false, true);
			doLabelInfosSize(_allLabelInfos);
			_allMilSecDateLabels = transDateStr2Num(allLabels);
		}
		
		private function resetLabelInfos(labelInfos:Vector.<LabelInfo>):void
		{
			var index:int = 0;
			for each (var labelInfo:LabelInfo in labelInfos)
			{
				labelInfo.index = index;
				labelInfo.textVisible = false;
				index++;
			}
		}
		
		/**
		 * 该类中，labelInfos的数量与milSecDateLabels的数量相同，故直接根据索引获取对应的LabelInfo
		 * @param	labelInfos
		 * @param	labelIndex
		 * @return
		 */
		override protected function getLabelInfo(labelInfos:Vector.<LabelInfo>, labelIndex:int):LabelInfo
		{
			if (labelIndex < 0 || labelIndex >= labelInfos.length)
			{
				return null;
			}
			return labelInfos[labelIndex];
		}
		
		/**
		 * XAxis的label位置为Y轴位于图表主区域的最下部，X轴水平依次排列，数据居中显示。
		 * @param	labelInfo
		 * @return
		 */
		override protected function getLabelPosition(labelInfo:LabelInfo):Point
		{
			var pt:Point = new Point();
			//var chart:Chart = ax.chart;
			//var chart:Chart = _viewer.chart;
			var value:Number = getNumber(labelInfo.text);
			var idx:uint = labelInfo.index;
			//var adjust:Number = ax.getStyle('labelPosition') === 'center' ? 0.5 : 0;
			//var tckPosNormal:Boolean = ax.getStyle('tickPosition') != 'reverse';
			//var tickLength:Number = StyleUtil.getNumberStyle(ax, 'tickLength');
			var data:AxisData = _axisView.dataModel as AxisData;
			//var lbl:Label = tempLabel;
			//lbl.text = labelInfo.text;
			//tempFormatTF.htmlText = labelInfo.text;
			//var lbl:Label = new Label(labelInfo.text);
			var labelWidth:Number = labelInfo.width;
			var labelHeight:Number = labelInfo.height;
			switch (data.direction)
			{
				//case AxisDirection.UP:
				//case AxisDirection.DOWN:
				//if (data.isValueAxis) {
				//pt = chart.chartToViewXY(0, value);
				//} else {
				//pt = chart.chartToViewXY(idx + adjust, 0);
				//pt.y += chart.chartHeight;
				//}
				//pt.x = tckPosNormal ? -tickLength - lbl.width : tickLength;
				//pt.y -= (lbl.contentHeight >> 1);
				//break;
				
				case AxisDirection.RIGHT: 
				case AxisDirection.LEFT: 
					if (data.isValueAxis)
					{
						pt = _chart.chartToViewXY(0, value);
					}
					else
					{
						pt = _chart.chartToViewXY(idx + _adjust, 0);
					}
					//var rot:Number = StyleUtil.getNumberStyle(ax, 'labelRotation');
					if (_rot)
					{
						//lbl.rotation = -rot;
						//var h:Number = rot == 90? lbl.contentHeight >> 1 : lbl.contentHeight;
						//pt.x = pt.x - lbl.width + h * Math.sin(rot / 180 * Math.PI);
						//pt.y = lbl.height;
						var lbl:TextField = returnTempFormatTF();
						lbl.htmlText = labelInfo.text;
						lbl.rotation = -_rot;
						var h:Number = _rot == 90 ? lbl.height >> 1 : lbl.height;
						pt.x = pt.x - lbl.width + h * Math.sin(_rot / 180 * Math.PI);
						pt.y = lbl.height;
					}
					else
					{
						pt.x -= labelWidth >> 1;
						pt.y = _tckPosNormal ? _tickLength : -_tickLength - labelHeight;
							//pt.x -= lbl.width >> 1;
							//pt.y = tckPosNormal ? tickLength : -tickLength - lbl.height;
					}
					break;
			}
			//if (_needFixForAxis)
			//{
			//pt = fixLabelPos(lbl, pt, ax, data);
			//}
			return pt;
		}
		
		public function dispose():void
		{
			_axisView = null;
			_chart = null;
			_adjust = 0.0;
			_tckPosNormal = false;
			_tickLength = 0.0;
			_rot = 0.0;
			tempFormatTF = null;
			_allLabelInfos = null;
		}
		
		private function doLabelInfosForOther(labelInfos:Vector.<LabelInfo>):void
		{
			doLabelInfosSize(labelInfos);
			doLabelInfosPos(labelInfos);
			doOverlapForOther(labelInfos);
		}
		
		/**
		 * 保证label相互不重叠的算法，从索引为0的label开始向后计算，重叠的label默认不显示。
		 * @param	labelInfos
		 */
		private function doOverlapForOther(labelInfos:Vector.<LabelInfo>):void
		{
			var numloop:int = labelInfos.length;
			var currentLabelInfo:LabelInfo;
			var nextLabelInfo:LabelInfo;
			var i:int = 0;
			var next:int = 0;
			while (i < numloop)
			{
				currentLabelInfo = labelInfos[i];
				next = i + 1;
				while (next < numloop)
				{
					nextLabelInfo = labelInfos[next];
					if (isOverlap(currentLabelInfo, nextLabelInfo))
					{
						nextLabelInfo.textVisible = false;
					}
					else
					{
						i = next;
						break;
					}
					next++;
				}
				if (next >= numloop)
				{
					break;
				}
			}
			
			function isOverlap(currentLabelInfo:LabelInfo, nextLabelInfo:LabelInfo):Boolean
			{
				if ((currentLabelInfo.pos.x + currentLabelInfo.width) > nextLabelInfo.pos.x)
				{
					return true;
				}
				return false;
			}
		}
		
		private function doLabelInfosForTimeLine(labelInfos:Vector.<LabelInfo>, milSecDateLabels:Vector.<Number>, dateTimeInterval:DateTimeInterval, dispalyMajorMilSecLabels:Vector.<Number>, dispalyMinorMilSecLabels:Vector.<Number>):void
		{
			/**
			 * 记录副单位时间在全部时间上的位置，然后修改对应位置的显示数据；主单位时间也同样处理。
			 */
			var displayMinorMilSecLabelIndexs:Vector.<int> = getLabelIndexs(dispalyMinorMilSecLabels, milSecDateLabels);
			var displayMajorMilSecLabelIndexs:Vector.<int> = getLabelIndexs(dispalyMajorMilSecLabels, milSecDateLabels);
			takeLabelShow(labelInfos, displayMinorMilSecLabelIndexs, milSecDateLabels, dateTimeInterval.minorIntervalUnit);
			takeLabelShow(labelInfos, displayMajorMilSecLabelIndexs, milSecDateLabels, dateTimeInterval.majorIntervalUnit, true);
			//需要设置全部标签位置，因为鼠标经过时，隐藏的标签会高亮
			doLabelInfosPos(labelInfos);
			doOverlapForTimeLine(labelInfos, displayMajorMilSecLabelIndexs, displayMinorMilSecLabelIndexs);
		}
		
		/**
		 * 保证主时间单位字段一定显示，如副时间单位与主时间单位的位置发生碰撞，就将该副时间单位隐去。
		 * @param	labelInfos
		 * @param	majorMilSecLabelIndexs
		 * @param	minorMilSecLabelIndexs
		 */
		private function doOverlapForTimeLine(labelInfos:Vector.<LabelInfo>, majorMilSecLabelIndexs:Vector.<int>, minorMilSecLabelIndexs:Vector.<int>):void
		{
			var majLabelIndex:int = -1;
			var minLabelIndex:int = -1;
			var majorLabelInfo:LabelInfo;
			var minorLabelInfo:LabelInfo;
			doMajOverlapMin();
			doMinOverlapMaj();
			
			function doMajOverlapMin():void
			{
				for each (majLabelIndex in majorMilSecLabelIndexs)
				{
					majorLabelInfo = getLabelInfo(labelInfos, majLabelIndex);
					if (majorLabelInfo)
					{
						for each (minLabelIndex in minorMilSecLabelIndexs)
						{
							if (minLabelIndex > majLabelIndex)
							{
								minorLabelInfo = getLabelInfo(labelInfos, minLabelIndex);
								if (isMajOverlapMin(majorLabelInfo, minorLabelInfo))
								{
									minorLabelInfo.textVisible = false;
								}
							}
						}
					}
				}
			}
			
			function doMinOverlapMaj():void
			{
				for each (minLabelIndex in minorMilSecLabelIndexs)
				{
					minorLabelInfo = getLabelInfo(labelInfos, minLabelIndex);
					if (minorLabelInfo)
					{
						for each (majLabelIndex in majorMilSecLabelIndexs)
						{
							if (majLabelIndex > minLabelIndex)
							{
								majorLabelInfo = getLabelInfo(labelInfos, majLabelIndex);
								if (isMinOverlapMaj(majorLabelInfo, minorLabelInfo))
								{
									minorLabelInfo.textVisible = false;
								}
							}
						}
					}
				}
			}
			
			function isMajOverlapMin(majorLabelInfo:LabelInfo, minorLabelInfo:LabelInfo):Boolean
			{
				if ((majorLabelInfo.pos.x + majorLabelInfo.width) > minorLabelInfo.pos.x)
				{
					return true;
				}
				return false;
			}
			
			function isMinOverlapMaj(majorLabelInfo:LabelInfo, minorLabelInfo:LabelInfo):Boolean
			{
				if ((minorLabelInfo.pos.x + minorLabelInfo.width) > majorLabelInfo.pos.x)
				{
					return true;
				}
				return false;
			}
		}
		
		//private function showFormatDate(mil:Number):String
		//{
		//var formatDate:String = "";
		//var date:Date = new Date(mil);
		//formatDate = date.getUTCFullYear() + " " + (date.getUTCMonth() + 1) + " " + date.getUTCDate();
		//return formatDate;
		//}
		
		private function returnTempFormatTF():TextField
		{
			var labelStyle:Object = StyleUtil.inheritStyle(_axisView.styleSheet.getStyle('label'), _axisView);
			var tempLabel:Label = new Label();
			tempLabel.setStyles(labelStyle);
			return LabelSimplePrinter.getFormatTextField(tempLabel);
		}
	
	}

}