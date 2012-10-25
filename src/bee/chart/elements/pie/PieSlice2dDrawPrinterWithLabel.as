package bee.chart.elements.pie
{
    import bee.abstract.IStatesHost;
    import bee.chart.assemble.pie.IPieSlicePrinter;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.pie.PieSliceView;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import bee.printers.PrinterDecorator;
    import bee.util.StyleUtil;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
	

	/**
	 * 在pie图表默认绘制的基础上，label水平放置，自动判断是否放置在圆饼内外侧
	 * @author jianping.shenjp
	 */                                                
	public class PieSlice2dDrawPrinterWithLabel extends PrinterDecorator implements IPieSlicePrinter
	{

		public function PieSlice2dDrawPrinterWithLabel(basePrinter:IStatePrinter)
		{
			super(basePrinter);
		}
        
        override public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            super.renderState(host, state, context);
            var view:PieSliceView = host as PieSliceView;
            if (view) {
                var data:PieSliceData = view.dataModel as PieSliceData;
                if (data && data.radius) {
                    drawLabelProcedure(view,context);
                }
            }
        }
        
        private function drawLabelProcedure(view:PieSliceView, context:DisplayObjectContainer):void 
        {
            drawPieLabel(view, context);
            updateLabelAndLinePos(view);
            changeLabelStyle(view);
        }
        
        /**
         * 绘制pieslice的Label
         * @param	data
         * @param	context
         */
        protected function drawPieLabel(view:PieSliceView, context:DisplayObjectContainer):void 
        {
			var data:PieSliceData = view.dataModel as PieSliceData;
            var radius:Number;
            var pieLabel:Label = new Label();
			pieLabel.setStyles(StyleUtil.mergeStyle(
                view.styleSheet.getStyle('label'), {
                    'paddingLeft'   : '0',
                    'paddingRight'  : '0'
                })
            );
			context.addChild(pieLabel);
			//将label的状态设置为与view相同。
			pieLabel.state = view.state;
            pieLabel.name = 'label';
            pieLabel.text = view.getLabelText();
        }
        
        /* INTERFACE cn.alibaba.yid.chart.assemble.pie.IPieSlicePrinter */
        
        public function updateLabelAndLinePos(view:PieSliceView):void
        {
			var data:PieSliceData = view.dataModel as PieSliceData;
			var setX:Number     = 0;
			var setY:Number     = 0;
			var label:Label     = view.label;
            
            var labelW:Number = view.labelWidth;
            var labelH:Number = view.labelHeight;
            
            var center:Point = view.getContentCenter();
            setX = center.x - (labelW >> 1);
            setY = center.y - (labelH >> 1);
            if (label) {
                label.x = setX;
                label.y = setY;
            }
            
            checkLabelSpace(view, label);
        }
        
        protected function makeLabelOutside(view:PieSliceView, label:Label):void
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
        }
        
        /**
         * 绘制与pieLabel的连接线.(文字水平放置状态时使用)
         * 该方法设置为public，便于label调整位置后，重绘line.
         * @param	view
         * @param	context
         */
        public function drawLine(view:PieSliceView, context:DisplayObjectContainer):void 
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
            g.lineTo(ticArcX,ticArcY);
            g.endFill();

            context.addChild(line);
        }
        
        /**
        * 检查扇形上是否有足够的空间放标签，
        * 如果没有，则将标签移到扇形外部显
        * 示，并加上线条
        * 
        * @param	target
        * @param	context
        */
        public function checkLabelSpace(view:PieSliceView, label:Label):void
        {
            var data:PieSliceData = view.dataModel as PieSliceData;
            const needMakeOutside:Boolean = data.labelRadiusAdj > 0;
			if (needMakeOutside || !canCanvasHoldLabel(view))
			{
                //如果label在内部时，有字被遮挡，就将字放到圆饼外，并加上连线。
                makeLabelOutside(view, label);
                drawLine(view, view.content);
			}
        }
        
        /**
        * 检查扇形上是否有足够的空间放标签，
        * 如果没有，则将标签移到扇形外部显
        * 示，并加上线条
        * @param	view
        * @return
        */
        protected function canCanvasHoldLabel(view:PieSliceView):Boolean
		{
            /**
            * 采用BitmapData draw的方式判断label是否超出canvas的范围。先将label绘制出来，并转换为红色；再绘制canvas，转换为白色；绘制结果获得红色的区域，如果区域的width==0，表示label没有超出canvas的范围，否则就超出了。
            */
            //TODO:需要考虑使用该方式的效率问题.
            //1.可以先判断canvas所占的角度， > 90直接略过;
            //2.减小datamapdata的所占大小
            var result:Boolean = false;
            var canvas:PieSliceCanvas = view.canvas;
            var label:Label = view.label;
            if (!label) {
                return false;
            }
            var data:PieSliceData = view.dataModel as PieSliceData;
            var r:Number = data.radius * 2 + view.labelWidth;
            var bmpd:BitmapData = new BitmapData(r, r, true);
            bmpd.draw(label, label.transform.matrix , new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255));
            bmpd.draw(canvas,canvas.transform.matrix , new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ));
            var intersection:Rectangle = bmpd.getColorBoundsRect( 0xFFFFFFFF, 0xFFFF0000 );
            bmpd.dispose();
            bmpd = null;
            result = (intersection.width == 0);
            num++;
            return result;
		}
        static public var num:int = 1;
        /**
         * 获得容器上指定的组件类型，若无，就新建一个
         * @param	context
         * @param	clz
         */
        protected function getPieLine(context:DisplayObjectContainer):PieLine
        {
            var childNum:int = context.numChildren;
            var tempObj:DisplayObject = context.getChildByName("line");
            if (tempObj)
            {
                return tempObj as PieLine;
            }
            return new PieLine();
        }
		
		/**
		 * 根据情况给label设置背景色.
		 * 若PieSliceView带line，active时，label带背景色显示，否则不带背景色.
		 * @param view
		 * 
		 */		
		protected function changeLabelStyle(view:PieSliceView):void{
			var pieLabel:Label = view.label;
            if (pieLabel)
            {
				var sliceStyle:Object = view.chart.styleSheet.getStyle("slice");
				if(view.line){
					sliceStyle = StyleUtil.mergeStyle(
						sliceStyle,
						{
							'paddingLeft'   : '0',
							'paddingRight'  : '0',
							'backgroundColor.hl' : '#29A5F7',
							'color.hl' : '#FFFFFF'
						}
					);
				}else{
					sliceStyle = StyleUtil.mergeStyle(
						sliceStyle,
						{
							'paddingLeft'   : '0',
							'paddingRight'  : '0'
						}
					);
				}
				pieLabel.setStyles(sliceStyle);
			}
		}
    }
}