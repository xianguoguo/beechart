package bee.chart.elements.pie
{
	import bee.abstract.IStatesHost;
	import bee.chart.abstract.ChartElementView;
	import bee.chart.assemble.pie.IPieSlicePrinter;
	import bee.util.StyleUtil;
	import bee.chart.util.TO_RADIANS;
	import bee.controls.label.Label;
	import bee.printers.IStatePrinter;
	import bee.printers.PrinterDecorator;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;

	/**
	 * 在pie图表默认绘制的基础上，加上label水平放置，并且只在出现在圆饼内部.
	 * @author jianping.shenjp
	 */
	public class PieSlice2dDrawPrinterWithInsideLabel extends PieSlice2dDrawPrinterWithLabel implements IPieSlicePrinter
	{

		public function PieSlice2dDrawPrinterWithInsideLabel(basePrinter:IStatePrinter)
		{
			super(basePrinter);
		}
        
        override public function checkLabelSpace(view:PieSliceView, label:Label):void
        {
            trace("checkLabelSpace~~~~~~~~~~~~~~~~~~~~~~");
            var data:PieSliceData = view.dataModel as PieSliceData;
            const needMakeOutside:Boolean = data.labelRadiusAdj > 0;
			if (needMakeOutside || !canCanvasHoldLabel(view))
			{
                view.removeLabel();
			}
        }
	}

}