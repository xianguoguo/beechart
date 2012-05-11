package bee.chart.elements.pie 
{
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.ChartElementView;
    import bee.chart.assemble.pie.IPieSlicePrinter;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import bee.printers.PrinterDecorator;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;

	/**
     * 在pie图表默认绘制的基础上，在圆饼外部，label水平放置，加上连线
     * @author jianping.shenjp
     */
    public class PieSlice2dDrawPrinterForNormal extends PieSlice2dDrawPrinterWithLabel implements IPieSlicePrinter
    {
        
        public function PieSlice2dDrawPrinterForNormal(basePrinter:IStatePrinter) 
        {
            super(basePrinter);
        }
        
        /* INTERFACE cn.alibaba.yid.chart.assemble.pie.IPieSlicePrinter */
        
        override public function updateLabelAndLinePos(view:PieSliceView):void
        {
			var data:PieSliceData = view.dataModel as PieSliceData;
            var setX:Number = 0;
            var setY:Number = 0;
            var radius:Number;
            var label:Label = view.label;
            var positionRadian:Number = data.getPositionRadian();
            if (view.isRecodeWorkable())
            {
                positionRadian = view.getPositionRadian();
            }
            radius = data.radius + data.labelRadiusAdj + PieSliceView.TICK_SIZE;
			//拥挤处理，label向上或向下移动的逻辑.暂时不用，数据多的时候，效果不理想
			//目前拥挤处理使用label向外拉伸的逻辑.
						//radius = data.radius  + PieSliceView.TICK_SIZE;
                        //setX = data.pieSliceCanvasX + radius * Math.cos(positionRadian);
                        //setY = data.pieSliceCanvasY + radius * Math.sin(positionRadian);
                        //trace(data.labelRadiusAdj);
						//var angle:Number=data.getPositionAngle();
						//if (angle > 0 && angle <= 180)
						//{
							//setY += data.labelRadiusAdj;
						//}
						//else if (angle > 180 && angle < 360)
						//{
							//setY -= data.labelRadiusAdj;
						//}
            //label水平放置
            setX = data.pieSliceCanvasX + radius * Math.cos(positionRadian);
            setY = data.pieSliceCanvasY + radius * Math.sin(positionRadian);
            //pieLabel放置在右边
            if (data.isRightSide)
            {
                setX += PieSliceView.TICK_EXTENSION_SIZE + PieSliceView.LABEL_MARGIN;
            }
            else
            {
                setX -= view.labelWidth + PieSliceView.TICK_EXTENSION_SIZE + PieSliceView.LABEL_MARGIN + 4;
            }
            setY -= view.labelHeight / 2;
			
            label.x = setX;
            label.y = setY;
            
            drawLine(view, view.content);
        }
    }

}