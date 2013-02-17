package bee.chart.elements.timeline
{
	import cn.alibaba.util.DisplayUtil;
	import bee.abstract.IStatesHost;
	import bee.chart.elements.timeline.labelmaker.LabelInfo;
	import bee.chart.elements.timeline.labelmaker.TimeLineLabelInfoMaker;
	import bee.chart.elements.timeline.TimeLineModel;
	import bee.chart.util.LineUtil;
	import bee.controls.label.Label;
	import bee.printers.IStatePrinter;
	import bee.printers.IStatePrinterWithUpdate;
	import bee.util.StyleUtil;
	import flash.display.CapsStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class TimeLinePrinter implements IStatePrinter, IStatePrinterWithUpdate
	{
		private var count:int = 1;
		private var _selectedRangeMask:Shape;
		
		public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
		{
			DisplayUtil.clearSprite(context);
			var viewer:TimeLineView = host as TimeLineView;
			var model:TimeLineModel = viewer.timeLineModel;
			//drawGuidLine(context, model);
			drawPreviews(context, viewer, model);
			drawSelectedRange(context, viewer, model);
			drawTimeLabelsAndLines(context, viewer, model);
			drawBoard(context, viewer, model);
		}
		
		public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void
		{
			if (!context.numChildren)
			{
				renderState(host, state, context);
				return;
			}
			redrawSelectedRange(host, context);
		}
		
		private function redrawSelectedRange(host:IStatesHost, context:DisplayObjectContainer):void
		{
			var viewer:TimeLineView = host as TimeLineView;
			var model:TimeLineModel = viewer.timeLineModel;
			var btnPos:Point = model.btnPos;
			if (btnPos)
			{
				_selectedRangeMask.x = btnPos.x;
				_selectedRangeMask.width = btnPos.y - btnPos.x;
			}
		}
		
		/**
		 * 绘制测试线条
		 * @param	context
		 * @param	model
		 */
		private function drawGuidLine(context:DisplayObjectContainer, model:TimeLineModel):void
		{
			var width:Number = model.width;
			var height:Number = model.height;
			var sp:Shape = new Shape();
			var g:Graphics = sp.graphics;
			g.beginFill(0xFF7300, 0.3);
			g.drawRect(0, 0, width, height);
			g.lineStyle(0, 0xFF7300);
			var labelsPosXs:Vector.<Number> = model.cacheLabelsPosXs;
			for each (var num:Number in labelsPosXs)
			{
				g.moveTo(num, 0);
				g.lineTo(num, height);
			}
			labelsPosXs = null;
			g.endFill();
			context.addChild(sp);
		}
		
		private function drawTimeLabelsAndLines(context:DisplayObjectContainer, viewer:TimeLineView, model:TimeLineModel):void
		{
			var labelInfoMaker:TimeLineLabelInfoMaker = new TimeLineLabelInfoMaker();
			labelInfoMaker.cacheLabelsPosXs = model.cacheLabelsPosXs;
			labelInfoMaker.initParamter(viewer, viewer.chart);
			var labelInfos:Vector.<LabelInfo> = labelInfoMaker.getLabelInfos();
			model.labelInfos = labelInfos;
			drawTimeLines(context, labelInfos, model);
			drawTimeLabels(context, labelInfos, model);
		}
		
		private function drawTimeLines(context:DisplayObjectContainer, labelInfos:Vector.<LabelInfo>, model:TimeLineModel):void
		{
			const height:Number = model.height;
			var lineSp:Shape = new Shape();
			var g:Graphics = lineSp.graphics;
			var tempX:Number;
			g.lineStyle(1, 0xCCCCCC);
			for each (var labelInfo:LabelInfo in labelInfos)
			{
				tempX = labelInfo.pos.x;
				g.moveTo(tempX, height);
				if (labelInfo.textVisible)
				{
					g.lineTo(tempX, 0);
				}
				else
				{
					g.lineTo(tempX, height * 0.8);
				}
			}
			g.endFill();
			context.addChild(lineSp);
		}
		
		private function drawTimeLabels(context:DisplayObjectContainer, labelInfos:Vector.<LabelInfo>, model:TimeLineModel):void
		{
			const height:Number = model.height;
			var labelsSp:Sprite = new Sprite();
			var label:Label;
			for each (var labelInfo:LabelInfo in labelInfos)
			{
				if (labelInfo.textVisible)
				{
					label = new Label(labelInfo.text)
					label.x = labelInfo.pos.x;
					label.y = height - labelInfo.height;
					labelsSp.addChild(label);
				}
			}
			context.addChild(labelsSp);
		}
		
		private function drawPreviews(context:DisplayObjectContainer, viewer:TimeLineView, model:TimeLineModel):void
		{
			const fillAlpha:Number = 1;
			const fillColor:uint = StyleUtil.getColorStyle(viewer, "previewFillColor");
			const lineColor:uint = StyleUtil.getColorStyle(viewer, "previewLineColor");
			var previewSp:Sprite = new Sprite();
			previewSp.mouseEnabled = false;
			var startX:Number = model.startX;
			var startY:Number = 0;
			var gradientHeight:Number = model.height;
			var gradientTy:Number = model.offset;
			var lineSp:Shape = new Shape();
			var lineGrph:Graphics = lineSp.graphics;
			var pts:Vector.<Point> = model.timeLineDots;
			lineGrph.lineStyle(1, lineColor, 1, false, 'normal', CapsStyle.ROUND, JointStyle.ROUND);
			var isFillGradient:Boolean = false;
			LineUtil.curveThrough(lineGrph, pts, count);
			LineUtil.drawVerticalArea(previewSp, pts, fillColor, fillAlpha, startX, startY, gradientHeight, gradientTy, count, isFillGradient);
			lineSp.y = model.height;
			previewSp.y = model.height;
			context.addChild(lineSp);
			context.addChild(previewSp);
		}
		
		private function drawSelectedRange(context:DisplayObjectContainer, viewer:TimeLineView, model:TimeLineModel):void
		{
			const selectFillColor:uint = StyleUtil.getColorStyle(viewer, "selectedFillColor");
			const selectLineColor:uint = StyleUtil.getColorStyle(viewer, "selectedLineColor");
			const fillAlpha:Number = 1;
			var _selectedRange:Sprite = new Sprite();
			_selectedRange.mouseEnabled = false;
			var startX:Number = model.startX;
			var startY:Number = 0;
			var gradientHeight:Number = model.height;
			var gradientTy:Number = model.offset;
			var lineSp:Sprite = new Sprite();
			var lineGrph:Graphics = lineSp.graphics;
			var pts:Vector.<Point> = model.timeLineDots;
			lineGrph.lineStyle(1, selectLineColor, 1, false, 'normal', CapsStyle.ROUND, JointStyle.ROUND);
			var isFillGradient:Boolean = false;
			LineUtil.curveThrough(lineGrph, pts, count);
			LineUtil.drawVerticalArea(_selectedRange, pts, selectFillColor, fillAlpha, startX, startY, gradientHeight, gradientTy, count, isFillGradient);
			_selectedRange.y = model.height;
			_selectedRange.addChild(lineSp);
			context.addChild(_selectedRange);
			
			_selectedRangeMask = new Shape();
			var g:Graphics = _selectedRangeMask.graphics;
			g.beginFill(0xFF7300);
			g.drawRect(0, 0, model.width, model.height);
			g.endFill();
			_selectedRange.mask = _selectedRangeMask;
			context.addChild(_selectedRangeMask);
		}
		
		private function drawBoard(context:DisplayObjectContainer, viewer:TimeLineView, model:TimeLineModel):void
		{
			const lineColor:uint = StyleUtil.getColorStyle(viewer, "boardColor");
			var board:Shape = new Shape();
			var g:Graphics = board.graphics;
			g.lineStyle(1, lineColor);
			g.drawRect(0, 0, model.width, model.height);
			g.endFill();
			context.addChild(board);
		}
	}
}