package bee.chart.elements.timeline.labelmaker
{
	import cn.alibaba.core.IDisposable;
	import bee.chart.abstract.Chart;
	import bee.chart.abstract.ChartData;
	import bee.chart.elements.timeline.labelmaker.DateTimeInterval;
	import bee.chart.elements.timeline.labelmaker.TimeLabelMaker;
	import bee.chart.elements.timeline.TimeLineView;
	import bee.chart.util.ChartUtil;
	import bee.controls.label.Label;
	import bee.controls.label.LabelSimplePrinter;
	import bee.util.StyleUtil;
	import flash.geom.Point;
	
	/**
	 * 时间轴label信息生成类
	 * 主时间显示文字，副时间只花刻度线
	 * @author jianping.shenjp
	 */
	public class TimeLineLabelInfoMaker extends LabelInfosMaker implements IDisposable
	{
		public var cacheLabelsPosXs:Vector.<Number>;
		private var _chart:Chart = null;
		
		public function initParamter(view:TimeLineView, chart:Chart):void
		{
			if (!view || !chart)
			{
				return;
			}
			createTempFormatTF(view);
			_chart = chart;
		}
		
		public function getLabelInfos():Vector.<LabelInfo>
		{
			if (!_chart)
			{
				return null;
			}
			var labelInfos:Vector.<LabelInfo> = new Vector.<LabelInfo>();
			var data:ChartData = _chart.data;
			var allLabels:Vector.<String> = data.allLabels;
			var milSecDateLabels:Vector.<Number> = transDateStr2Num(allLabels);
			
			var dateTimeInterval:DateTimeInterval = new DateTimeInterval();
			var displayMajorMilSecLabels:Vector.<Number> = new Vector.<Number>();
			var displayMinorMilSecLabels:Vector.<Number> = new Vector.<Number>();
			TimeLabelMaker.generate(data, dateTimeInterval, displayMajorMilSecLabels, displayMinorMilSecLabels);
			var displayMajorLabelInfos:Vector.<LabelInfo> = newLabelInfosForNum(displayMajorMilSecLabels, true);
			var displayMinLabelInfos:Vector.<LabelInfo> = newLabelInfosForNum(displayMinorMilSecLabels, false);
			labelInfos = displayMajorLabelInfos.concat(displayMinLabelInfos);
			setLabelInfosIndex(labelInfos, milSecDateLabels);
			doLabelInfos(labelInfos, milSecDateLabels, dateTimeInterval, displayMajorMilSecLabels, displayMinorMilSecLabels);
			dispose();
			return labelInfos;
		}
		
		/**
		 * 根据TimeLineModel labelsPosXs中的信息，设定labelInfo中的pos信息，只需要知道x坐标。
		 * @param	labelInfo
		 * @return
		 */
		override protected function getLabelPosition(labelInfo:LabelInfo):Point
		{
			var pt:Point = new Point();
			pt.x = cacheLabelsPosXs[labelInfo.index];
			return pt;
		}
		
		/**
		 * 该类中，labelInfos的数量与milSecDateLabels的数量不相同，故不能直接根据索引获取对应的LabelInfo，需要循环判断,index相同，则返回结果.
		 * @param	labelInfos
		 * @param	labelIndex
		 * @return
		 */
		override protected function getLabelInfo(labelInfos:Vector.<LabelInfo>, labelIndex:int):LabelInfo
		{
			var result:LabelInfo = null;
			for each (var labelInfo:LabelInfo in labelInfos)
			{
				if (labelInfo.index == labelIndex)
				{
					result = labelInfo;
					break;
				}
			}
			return result;
		}
		
		private function newLabelInfosForNum(majorMilSecLabels:Vector.<Number>, labelVisible:Boolean = false):Vector.<LabelInfo>
		{
			var reslut:Vector.<LabelInfo> = new Vector.<LabelInfo>();
			var labelInfo:LabelInfo;
			for each (var num:Number in majorMilSecLabels)
			{
				labelInfo = new LabelInfo(num + "", labelVisible);
				reslut.push(labelInfo);
			}
			return reslut;
		}
		
		/**
		 * 设置可见的时间值在所有时间点上的索引
		 * @param	labelInfos
		 * @param	milSecDateLabels
		 */
		private function setLabelInfosIndex(labelInfos:Vector.<LabelInfo>, milSecDateLabels:Vector.<Number>):void
		{
			var value:Number;
			var index:int;
			for each (var labelInfo:LabelInfo in labelInfos)
			{
				value = getNumber(labelInfo.text);
				index = ChartUtil.getIndex(value, milSecDateLabels);
				if (index != -1)
				{
					labelInfo.index = index;
				}
			}
		}
		
		private function doLabelInfos(labelInfos:Vector.<LabelInfo>, milSecDateLabels:Vector.<Number>, dateTimeInterval:DateTimeInterval, displayMajorMilSecLabels:Vector.<Number>, displayMinorMilSecLabels:Vector.<Number>):void
		{
			/**
			 * 记录副单位时间在全部时间上的位置，然后修改对应位置的显示数据；主单位时间也同样处理。
			 */
			
			//TODO: 副时间单位未处理
			var displayMajorMilSecLabelIndexs:Vector.<int> = getLabelIndexs(displayMajorMilSecLabels, milSecDateLabels);
			takeLabelShow(labelInfos, displayMajorMilSecLabelIndexs, milSecDateLabels, dateTimeInterval.majorIntervalUnit, true);
			doLabelInfosSize(labelInfos);
			doLabelInfosPos(labelInfos);
		}
		
		private function createTempFormatTF(view:TimeLineView):void
		{
			var labelStyle:Object = StyleUtil.inheritStyle(view.styleSheet.getStyle('label'), view);
			var tempLabel:Label = new Label();
			tempLabel.setStyles(labelStyle);
			tempFormatTF = LabelSimplePrinter.getFormatTextField(tempLabel);
		}
		
		public function dispose():void
		{
			tempFormatTF = null;
			cacheLabelsPosXs = null;
			_chart = null;
		}
	}

}