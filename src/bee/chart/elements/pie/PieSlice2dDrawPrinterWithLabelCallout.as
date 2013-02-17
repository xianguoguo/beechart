package bee.chart.elements.pie
{
    import bee.abstract.IStatesHost;
    import bee.chart.elements.pie.PieSliceView;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;

    /**
     * 在pie图表默认绘制的基础上，label水平放置，label竖直排列
     * @author jianping.shenjp
     */
    public class PieSlice2dDrawPrinterWithLabelCallout extends PieSlice2dDrawPrinterWithLabel
    {
        public function PieSlice2dDrawPrinterWithLabelCallout(printer:IStatePrinter)
        {
            super(printer);
        }
        
        override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            super.renderState(host, state, context);
            
        }
        
        override public function updateLabelAndLinePos(view:PieSliceView):void 
        {
            var data:PieSliceData   = view.dataModel as PieSliceData;
            var label:Label         = view.label;
            var radius:Number = data.radius + PieSliceView.TICK_SIZE + 30;
            const originY:Number = 0;
            if (data.isRightSide)
            {
                label.x = data.pieSliceCanvasX + radius;
            }else {
                label.x = data.pieSliceCanvasX - radius - view.labelWidth;
            }
            var _y:Number = getYPos(originY, view.labelHeight, view.serialNum, view);
            label.y = _y;
            drawLine(view, view.content);
        }
        
        private function getYPos(originY:Number,labelHeight:Number, index:int, view:PieSliceView):Number 
        {
            return originY + labelHeight * index + view.offset;
        }
        
        /**
         * 绘制与pieLabel的连接线.(文字水平放置状态时使用)
         * 该方法设置为public，便于label调整位置后，重绘line.
         * @param	view
         * @param	context
         */
        override public function drawLine(view:PieSliceView, context:DisplayObjectContainer):void 
        {
            var data:PieSliceData = view.dataModel as PieSliceData;
            
            // 标签的半径=圆的半径+标签刻度线长度
            //TODO: 加上碰撞测试修正
            var line:PieLine = getPieLine(context);
			line.name = "line";
            var g:Graphics = line.graphics;
            var ticLblX:Number;
            var ticLblY:Number;
            var ticArcX:Number;
            var ticArcY:Number;
            var label:Label = view.label;
            var positionRadian:Number = data.getPositionRadian();
            if (view.isRecodeWorkable())
            {
                positionRadian = view.getPositionRadian();
            }
            /**label水平放置*/
            if (data.isRightSide) {
                ticLblX = label.x - PieSliceView.LABEL_MARGIN;
            } else {
                //if legend stands to the left side of the pie
                ticLblX = label.x + view.labelWidth + PieSliceView.LABEL_MARGIN + 4;
            }
            ticLblY = label.y + (view.labelHeight >> 1);
            
            ticArcX = data.pieSliceCanvasX + data.radius * Math.cos(positionRadian);
            ticArcY = data.pieSliceCanvasY + data.radius * Math.sin(positionRadian);
            
            // Draw the line from the slice to the label
            g.clear();
            view.setLineStyle(g);
            g.moveTo(ticLblX, ticLblY);
            if (data.isRightSide)
            {
                g.lineTo(ticLblX - PieSliceView.TICK_EXTENSION_SIZE, ticLblY);
            }
            else
            {
                g.lineTo(ticLblX + PieSliceView.TICK_EXTENSION_SIZE, ticLblY);
            }
            if (data.isRightSide)
            {
                g.lineTo(data.pieSliceCanvasX+data.radius, ticArcY);
            }
            else
            {
                g.lineTo(data.pieSliceCanvasX-data.radius, ticArcY);
            }
            g.lineTo(ticArcX,ticArcY);
            g.endFill();

            context.addChild(line);
        }
    }
}