package bee.chart.abstract 
{
    import adobe.utils.CustomActions;
    import bee.chart.elements.legend.item.icon.LegendItemIcon;
    import bee.chart.elements.legend.Legend;
	import bee.util.YIDStyleSheet;
	import cn.alibaba.core.AppSetting;
	import bee.abstract.CComponentController;
	import bee.chart.data.ChartLoadAndParser;
	import bee.chart.data.ILoadAndParser;
	import bee.chart.elements.ctxmenu.DefaultChartCtxMenu;
	import bee.chart.elements.ctxmenu.IChartCtxMenu;
	import bee.chart.events.ChartEvent;
	import bee.chart.events.ChartUIEvent;
	import bee.chart.external.ChartSimpleInterface;
	import bee.chart.external.IChartInterface;
	import bee.chart.util.Constants;
	import bee.plugins.IPlugin;
	import flash.geom.Point;
	import flash.utils.setTimeout;
    
	/**
    * 图表的抽象类
    * @author hua.qiuh
    */
    public class Chart extends CComponentController
    {
        
        private var _ctxMenuGener:IChartCtxMenu;
        private var _parser:ILoadAndParser;
        private var _interface:IChartInterface;
		private var _pluginClz:Vector.<Class> = new Vector.<Class>(); /**保存插件的变量*/
        private var _plugins:Vector.<IPlugin> = new Vector.<IPlugin>(); /**保存插件实例的变量*/
        
        public function Chart(viewerClass:Class=null, dataClass:Class=null, pluginClz:Vector.<Class> = null)
        {
            setModel(new ChartModel());
            
            viewerClass     = viewerClass || ChartViewer;
            if (dataClass) {
                chartModel.setData(new dataClass());
            }
            setViewer(new viewerClass(this));
            
            _ctxMenuGener   = new DefaultChartCtxMenu();
            _interface      = new ChartSimpleInterface();
            _parser         = new ChartLoadAndParser(this);

            if (pluginClz) {
                _pluginClz = _pluginClz.concat(pluginClz);
            }
            
            super();
        }
        
        protected function initPlugins():void 
        {
            var plugin:IPlugin;
            for each (var obj:Class in plugins) 
            {
                plugin = new obj() as IPlugin;
                plugin.initPlugin(this);
                _plugins.push(plugin);
            }
        }
        
        override protected function initController():void 
        {
            AppSetting.initParams(stage.loaderInfo.parameters);
            
            var delay:Number = AppSetting.Get('startDelay');
            if (delay) {
                setTimeout(initChart, delay);
            } else {
                initChart();
            }
        }
        
        /**
        * 添加自定义的图表元素，
        * 该元素可以一直显示在图表上
        * @param	el
        */
        public function addCustomElement(el:ChartElement):void
        {
            chartModel.addCustomElement(el);
        }
        
        /**
        * 删除自定义的图表元素
        * @param	el
        */
        public function removeCustomElement(el:ChartElement):void
        {
            chartModel.removeCustomElement(el);
        }
        
        /**
        * 添加部件
        * @param	el
        */
        public function addViewElement(el:ChartElement):void
        {
            chartViewer.addElement(el);
        }
        
        /**
        * 删除部件
        * @param	el
        */
        public function removeViewElement(el:ChartElement):void
        {
            chartViewer.removeElement(el);
        }
        
        /**
        * 获取某数据点所在的坐标
        * @param	index
        * @param	value
        * @return
        */
        public function chartToViewXY(x:Number, value:Number):Point
        {
            return chartViewer.chartToViewXY(x, value);
        }
        
        /**
        * 设置视图模块
        * @param	viewer
        */
        public function setViewer(viewer:ChartViewer):void
        {
            if (chartViewer) {
                chartViewer.chart = null;
            }
            view = viewer;
        }
        
        /**
        * 设置某一条数据是否显示出来
        * @param	index
        * @param	active
        */
        public function setDatasetVisibility(index:uint, active:Boolean):void 
        {
            data.setDatasetVisibility(index, active);
            chartViewer.setDatasetVisibility(index, active);
            dispatchLegendClickEvent(index, active);
        }
        
		private function dispatchLegendClickEvent(index:int,isVisible:Boolean):void
		{
			var chartdata:ChartDataSet = getChartSetAt(index);
			if (!chartdata) {
				return
			}
			var data:Object = 
			{ 
				"name"		: chartdata.name,
				"index"		: chartdata.index,
				"visible"   : isVisible
			};
			dispatchEvent(new ChartUIEvent(ChartUIEvent.DATA_VISIBLE_CHANGE, data, true));
		}
		
        /**
        * 获取某一条数据是否显示出来
        * @param	index
        * @param	active
        */
        public function getDatasetVisibility(index:uint):Boolean 
        {
            return data.getDatasetVisibility(index);
        }
        
        
        /**
        * 设置某一条数据是否处于激活状态
        * @param	index
        * @param	active
        */
        public function setDatasetActivity(index:uint, active:Boolean):void
        {
            data.setDatasetActivity(index, active);
            chartViewer.setDatasetActivity(index, active);
        }
        
        /**
        * 获取某一条数据是否正在显示中
        * @param	index
        * @return
        */
        public function getDatasetActivity(index:uint):Boolean
        {
            return data.getDatasetActivity(index);
        }
        
        /**
        * 解析内容，包括数据和样式
        * @param	src 字符串，可以是XML或JSON格式
        */
        public function parse(src:String):void
        {
            _parser.parse(src);
        }
        
        /**
        * 解析样式
        * @param	src 字符串
        */
        public function parseCSS(src:String, toAppend:Boolean = false ):void
        {
            _parser.parseCSS(src, toAppend);
        }

        /**
        * 加载外部的内容，包括数据和样式
        * @param	url 数据源URL
        */
        public function load(url:String, charset:String=null):void
        {
            _parser.load(url, charset);
        }
        
        /**
        * 加载外部的样式
        * @param	url 数据源URL
        */
        public function loadCSS(url:String, charset:String = null, toAppend:Boolean = false ):void
        {
            _parser.loadCSS(url, charset, toAppend);
        }
        
        /**
        * 取得图表当前的状态
        * @return
        */
        public function getState():String
        {
            return state;
        }
        
        override public function set state(value:String):void 
        {
            dispatchEvent(new ChartEvent(ChartEvent.BEFORE_PRINT_STATE));
            super.state = value;
            dispatchEvent(new ChartEvent(ChartEvent.AFTER_PRINT_STATE));
        }
        
        override public function dispose():void 
        {
            _parser.dispose();
            _parser = null;
            
            _ctxMenuGener.dispose();
            _ctxMenuGener = null;
            
            _interface.dispose();
            _interface = null;
            
            for each (var plugin:IPlugin in _plugins ) 
            {
                plugin.dispose();
            }
            
            super.dispose();
        }
        
        /**
        * 从给定的序号取得数据序列
        * 序号从0开始计数
        * @param	index
        * @return
        */
        public function getChartSetAt(index:uint):ChartDataSet 
        {
            return sets[index];
        }
		
		public function dataIndexRangeOffset(value:int):void 
		{
			data.dataIndexRangeOffset(value);
		}
        
        /**
        * 获取所有当前可见的数据序列
        */
        public function get visibleSets():Vector.<ChartDataSet> 
        {
            return data.visibleSets;
        }
        
        /**
        * 获取当前可见的数据序列的数量
        */
        public function get visibleSetCount():uint
        {
            return data.visibleSetCount;
        }
        
        /**
        * 获取所有数据序列，包括不可见的
        */
        public function get allSets():Vector.<ChartDataSet>
        {
            return data.allSets;
        }
        
		/**
		 * 获取在可视范围内的所有数据序列
		 */
		public function get sets():Vector.<ChartDataSet>
        {
            return data.sets;
        }
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Private Functions
        
        /**
        * 初始化图表
        */
        protected function initChart():void
        {
            stage.align = 'TL';
            stage.scaleMode = 'noScale';
            
            //TEST JSON DATA
            //AppSetting.Set('data', decodeURIComponent("%7B%22data%22%3A%7B%22indexAxis%22%3A%7B%22name%22%3A%22%E6%9C%88%E4%BB%BD%22%2C%22labels%22%3A%5B%221%E6%9C%88%22%2C%222%E6%9C%88%22%2C%223%E6%9C%88%22%2C%224%E6%9C%88%22%2C%225%E6%9C%88%22%2C%226%E6%9C%88%22%2C%227%E6%9C%88%22%2C%228%E6%9C%88%22%2C%229%E6%9C%88%22%5D%2C%22labelType%22%3A%22String%22%7D%2C%22valueAxis%22%3A%7B%22name%22%3A%22%E8%90%A5%E4%B8%9A%E9%A2%9D%22%2C%22unit%22%3A%22%E4%BA%BF%E5%85%83%22%7D%2C%22dataSets%22%3A%5B%7B%22name%22%3A%22A%E5%85%AC%E5%8F%B8%22%2C%22desc%22%3A%22%22%2C%22values%22%3A%5B343%2C350%2C424%2C413%2C415%2C408%2C437%2C458%2C452%5D%2C%22styles%22%3A%7B%7D%7D%2C%7B%22name%22%3A%22B%E5%85%AC%E5%8F%B8%22%2C%22desc%22%3A%22%22%2C%22values%22%3A%5B59%2C39%2C64%2C65%2C66%2C66%2C69%2C69%2C71%5D%2C%22styles%22%3A%7B%7D%7D%2C%7B%22name%22%3A%22C%E5%85%AC%E5%8F%B8%22%2C%22desc%22%3A%22%22%2C%22values%22%3A%5B39%2C39%2C43%2C44%2C45%2C45%2C44%2C43%2C43%5D%2C%22styles%22%3A%7B%7D%7D%2C%7B%22name%22%3A%22D%E5%85%AC%E5%8F%B8%22%2C%22desc%22%3A%22%22%2C%22values%22%3A%5B59%2C39%2C43%2C42%2C45%2C15%2C14%2C43%2C83%5D%2C%22styles%22%3A%7B%7D%7D%2C%7B%22name%22%3A%22E%E5%85%AC%E5%8F%B8%22%2C%22desc%22%3A%22%22%2C%22values%22%3A%5B89%2C39%2C43%2C34%2C45%2C45%2C44%2C43%2C33%5D%2C%22styles%22%3A%7B%7D%7D%2C%7B%22name%22%3A%22F%E5%85%AC%E5%8F%B8%22%2C%22desc%22%3A%22%22%2C%22values%22%3A%5B19%2C29%2C43%2C44%2C35%2C45%2C44%2C43%2C73%5D%2C%22styles%22%3A%7B%7D%7D%5D%7D%2C%22css%22%3A%7B%22xAxis%22%3A%7B%22tickTickness%22%3A2%2C%22tickLength%22%3A5%2C%22tickPosition%22%3A%22left%22%2C%22labelPosition%22%3A%22center%22%7D%2C%22canvas%22%3A%7B%22gridThickness%22%3A1%2C%22gridColor%22%3A%22%23CCCCCC%22%2C%22backgroundColor%22%3A%22%23FFFFFF%22%7D%2C%22bar%22%3A%7B%22borderThickness%22%3A1%2C%22dropShadow%22%3A%22none%22%2C%22color%22%3A%22%23ff7300%22%2C%22thickness%22%3A2%7D%2C%22barlabel%22%3A%7B%22color%22%3A%22inherit%22%2C%22fontSize%22%3A15%7D%2C%22chart%22%3A%7B%22paddingLeft%22%3A20%2C%22paddingRight%22%3A20%2C%22leftAxisVisibility%22%3A%22visible%22%7D%7D%7D"));
            
            _ctxMenuGener.initChartCtxMenu(this);
            _interface.initChartExternal(this);
            initPlugins();
            dispatchEvent(new ChartEvent(ChartEvent.SWF_READY));
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        /**
        * 获取图表纯粹的数据
        */
        public function get data():ChartData
        {
            return chartModel.data;
        }
        
        
        /**
        * 图表的视图模块
        */
        public function get chartViewer():ChartViewer
        {
            return view as ChartViewer;
        }
        
        /**
        * 图表的模型对象
        */
        public function get chartModel():ChartModel
        {
            return model as ChartModel;
        }
        
        /**
        * 图表的宽度
        */
        public function get chartWidth():Number { return chartModel.chartWidth; }
        public function set chartWidth(value:Number):void 
        {
            chartModel.chartWidth = value;
        }
        
        /**
        * 图表的高度
        */
        public function get chartHeight():Number { return chartModel.chartHeight; }
        public function set chartHeight(value:Number):void 
        {
            chartModel.chartHeight = value;
        }
        
        public function get contextMenuGen():IChartCtxMenu { return _ctxMenuGener; }
        public function set contextMenuGen(value:IChartCtxMenu):void 
        {
            _ctxMenuGener = value;
            _ctxMenuGener.initChartCtxMenu(this);
        }
        
        public function get parser():ILoadAndParser { return _parser; }
        public function set parser(value:ILoadAndParser):void 
        {
            _parser = value;
        }
        
        public function get externalManager():IChartInterface { return _interface; }
        public function set externalManager(value:IChartInterface):void 
        {
            _interface = value;
        }
        
        public function get enableMouseTrack():Boolean { return chartModel.enableMouseTrack; }
        public function set enableMouseTrack(value:Boolean):void 
        {
            chartModel.enableMouseTrack = value;
        }
        
        public function get enableTooltip():Boolean { return chartModel.enableTooltip; }
        public function set enableTooltip(value:Boolean):void 
        {
            chartModel.enableTooltip = value;
        }
        
        public function get customMsg():String { return chartModel.customMsg; }
        public function set customMsg(value:String):void 
        {
            chartModel.customMsg = value;
        }
        
        public function get plugins():Vector.<Class> { return _pluginClz; }
        
		public function isTimeline():Boolean
		{
			return this.getStyle("chartType") === Constants.TIMELINE;
		}
		
		/**开放私有API*/
        public function _updateViewNow():void
        {
			super.updateViewNow();
        }
		
		public function _returnChartCSS():String
        {
			return YIDStyleSheet(styleSheet).toCSSText();
        }
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Event Handlers
    }

}