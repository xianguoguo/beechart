package bee.chart.assemble 
{
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.ChartStates;
    import bee.chart.abstract.ChartViewer;
    import bee.chart.elements.tooltip.Tooltip;
    import bee.chart.util.AutoColorUtil;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.geom.Rectangle;

	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartBasicPrinter implements IStatePrinter 
    {
        protected var _context:DisplayObjectContainer;
        protected var _viewer:ChartViewer;
        
        public function ChartBasicPrinter() 
        {
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
			this._context = context;
            this._viewer = host as ChartViewer;
            if (_viewer && _viewer.chart) {
                
                
                setAutoColorUtil();
                
                var stage:Stage = _viewer.stage;
                if (stage) {
                    stage.scaleMode = StageScaleMode.NO_SCALE;
                    stage.align = StageAlign.TOP_LEFT;
                }
                
                switch(state) {
                    case ChartStates.NORMAL:
						initParamter(host, context);
                        renderNormalState(_viewer, context);
                        break;
                    case ChartStates.LOAD_FAIL:
                        renderLoadFailState(_viewer, context);
                        break;
                    case ChartStates.PARSE_FAIL:
                        renderParseFailState(_viewer, context);
                        break;
                    case ChartStates.CUSTOM_FAIL:
                        renderCustomFailState(_viewer, context);
                        break;
                }
				clearParamter();
            }
        }
        
		protected function initParamter(host:IStatesHost, context:DisplayObjectContainer):void 
		{
		}
        
		protected function clearParamter():void 
		{
			this._viewer = null;
			this._context = null;
		}
		
        /**
        * 清除一个元件的子元素、画布和滤镜
        * @param	context
        */
        protected function clearContent(context:DisplayObjectContainer):void 
        {
            if (_viewer && context === _viewer.content) {
                _viewer.clearContent();
            } else {
                DisplayUtil.clearSprite(context);
            }
        }
        
        /**
        * 渲染Normal状态
        * @param	viewer
        * @param	context
        */
        protected function renderNormalState(viewer:ChartViewer, context:DisplayObjectContainer):void
        {
        }
		
		
		/**
		 * 添加鼠标提示
		 */
		protected function drawTooltip(host:ChartViewer, width:Number, height:Number, context:DisplayObjectContainer):void
		{
			var tooltip:Tooltip = Tooltip.instance;
			tooltip.resetStyles();
			tooltip.bounds      = new Rectangle(0, -height, width, height);
			host.addElement(tooltip);
            StyleUtil.inheritStyleSheet( tooltip, 'tooltip', host );
			
			if (context == host.content) {
				host.addChild(tooltip);
			} else {
				context.addChild(tooltip);
			}
			
		}
		
        /**
        * 渲染加载失败的状态
        * @param	viewer
        * @param	context
        */
        protected function renderLoadFailState(viewer:ChartViewer, context:DisplayObjectContainer):void
        {
            var label:Label = new Label("加载数据失败");
            if(viewer.stage){
                label.x = (viewer.stage.stageWidth-label.width) >> 1;
                label.y = (viewer.stage.stageHeight - label.height) >> 1;
            }
            context.addChild(label);
        }

        /**
         * 数据解析失败的状态
         * @param	viewer
         * @param	context
         */
        private function renderParseFailState(viewer:ChartViewer, context:DisplayObjectContainer):void 
        {
            var label:Label = new Label("解析数据错误!");
            if(viewer.stage){
                label.x = (viewer.stage.stageWidth-label.width) >> 1;
                label.y = (viewer.stage.stageHeight - label.height) >> 1;
            }
            context.addChild(label);
        }
        
        protected function renderCustomFailState(viewer:ChartViewer, context:DisplayObjectContainer):void
        {
            clearContent(context);
            var label:Label = new Label(viewer.chartModel.customMsg);
            if(viewer.stage){
                label.x = (viewer.stage.stageWidth-label.width) >> 1;
                label.y = (viewer.stage.stageHeight - label.height) >> 1;
            }
            context.addChild(label);
        }
        
        /**设置颜色生成器*/
        private function setAutoColorUtil():void
        {
            //设置颜色 
            var colorsString:String = _viewer.getStyle("colors");
            var colors:Array = [];
            if (colorsString)
            {
                colors = colorsString.split(",");
            }
			AutoColorUtil.generaterColorNum = _viewer.chart.data.dataSetCount;
            AutoColorUtil.reset();
            AutoColorUtil.addColors(colors);
        }
        
    }

}