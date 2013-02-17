package bee.chart.elements.pie 
{
    import bee.abstract.IStatesHost;
    import bee.chart.assemble.pie.IPieSlicePrinter;
    import bee.chart.elements.pie.PieSliceView;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import bee.printers.PrinterDecorator;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.Sprite;
	/**
     * 在pie图表默认的基础上，使得label外置，并且进行连线
     * @author jianping.shenjp
     */
    public class PieSlice2dDrawPrinterOutside extends PieSlice2dDrawPrinterWithLabel
    {
        
        public function PieSlice2dDrawPrinterOutside(basePrinter:IStatePrinter) 
        {
            super(basePrinter);
        }
        
        override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            super.renderState(host, state, context);
            
        }
        
        override public function updateLabelAndLinePos(view:PieSliceView):void 
        {
            var data:PieSliceData   = view.dataModel as PieSliceData;
            var label:Label         = view.label;
			var rotationNum:Number = data.getPositionAngle();
			if (!data.isRightSide) {
				rotationNum -= 180;
			}
			label.rotation = rotationNum;
            makeLabelOutside(view, label);
            drawLine(view, view.content);
        }
       
        override protected function makeLabelOutside(view:PieSliceView, label:Label):void
        {
            var data:PieSliceData   = view.dataModel as PieSliceData;
            var positionRadian:Number = data.getPositionRadian();
            if (view.isRecodeWorkable())
            {
                positionRadian = view.getPositionRadian();
            }
            var cosValue:Number     = Math.cos(positionRadian);
            var sinValue:Number     = Math.sin(positionRadian);
            var radius:Number       = data.radius;
            var w2:Number           = view.labelWidth >> 1;
            var h2:Number           = view.labelHeight >> 1;
            var cvnsX:Number        = data.pieSliceCanvasX;
            var cvnsY:Number        = data.pieSliceCanvasY;
            var tmpR:Number;
            var setX:Number=0.0;
            var setY:Number=0.0;
            
            radius = data.radius + data.labelRadiusAdj + PieSliceView.TICK_SIZE;
            //pieLabel放置在右边
            if (data.isRightSide)
            {
                tmpR = radius + PieSliceView.TICK_EXTENSION_SIZE + PieSliceView.LABEL_MARGIN + 4;
                setX = cvnsX + tmpR * cosValue + h2 * sinValue;
                setY = cvnsY + tmpR * sinValue - h2 * cosValue;
            }
            else
            {
                tmpR = radius + view.labelWidth + PieSliceView.TICK_EXTENSION_SIZE + PieSliceView.LABEL_MARGIN + 4;
                setX = cvnsX + tmpR * cosValue - h2 * sinValue;
                setY = cvnsY + tmpR * sinValue + h2 * cosValue;
            }
            label.x = Math.floor(setX);
            label.y = Math.floor(setY);
        }
        
        /**
         * 绘制与pieLabel的连接线.(文字倾斜放置状态时使用)
         * 该方法设置为public，便于label调整位置后，重绘line.
         * @param	view
         * @param	context
         */
        override public function drawLine(view:PieSliceView, context:DisplayObjectContainer):void 
        {
            
            var data:PieSliceData = view.dataModel as PieSliceData;
            var label:Label = view.label;
            var line:PieLine = getPieLine(context);
			line.name = 'line';
            var g:Graphics = line.graphics;
            var ticLblX:Number;
            var ticLblY:Number;
            var ticArcX:Number ;
            var ticArcY:Number;
            var labelW:Number = view.labelWidth;
            var labelH:Number = view.labelHeight;
            
            /**label倾斜放置*/
            ticLblX = label.x;
            ticLblY = label.y ;
            var positionRadian:Number = data.getPositionRadian();
            if (view.isRecodeWorkable())
            {
                positionRadian = view.getPositionRadian();
            }
            var cosValue:Number = Math.cos(positionRadian);
            var sinValue:Number = Math.sin(positionRadian);

            //调整位置
            if(data.isRightSide){
                ticLblX -= (labelH >> 1) * sinValue;
                ticLblY += (labelH >> 1) * cosValue; 
            } else {
                ticLblX += (labelH >> 1) * sinValue;
                ticLblY -= (labelH >> 1) * cosValue; 
                //使得连线连接在label尾部
                ticLblX -= labelW * cosValue;
                ticLblY -= labelW * sinValue; 
            }
            ticArcX = data.pieSliceCanvasX + data.radius * cosValue;
            ticArcY = data.pieSliceCanvasY + data.radius * sinValue;
            
            g.clear();
            view.setLineStyle(g);

            // move to the end of the tic closest to the label
            g.moveTo(ticLblX, ticLblY);
            //draw a line the length of the tic extender
            
            //Draw a line from the end of the tic extender to the arc
            g.lineTo(ticArcX, ticArcY);
            g.endFill();
            context.addChild(line);
        }
    }
}