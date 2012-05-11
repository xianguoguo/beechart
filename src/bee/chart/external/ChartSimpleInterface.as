package bee.chart.external 
{
    import cn.alibaba.core.getSetting;
    import bee.chart.abstract.Chart;
    import bee.chart.events.ChartEvent;
    import bee.chart.events.ChartUIEvent;
    import bee.chart.events.ParserEvent;
    import flash.external.ExternalInterface;
    import flash.system.Security;
	/**
    * 图表的外部接口模块
    * 负责提供外部接口和广播图表的事件
    * @author hua.qiuh
    */
    public class ChartSimpleInterface implements IChartInterface
    {
        /** exposed API **/
        static public const APIS:Vector.<String> = new <String>[
            'parse', 
            'parseCSS',
            'load',
            'loadCSS',
            'setDatasetActivity',
            'getDatasetActivity',
            'setDatasetVisibility',
            'getDatasetVisibility',
            'getState'
        ];
        
        /** exposed Events **/
        static public const EVENTS:Vector.<String> = new <String>[
            ChartEvent.SWF_READY,
            ParserEvent.LOAD_START,
            ParserEvent.LOAD_FAIL,
            ParserEvent.LOAD_FINISH,
            ParserEvent.PARSE_FAIL,
            ParserEvent.CSS_PARSED,
            ParserEvent.DATA_PARSED,
            ChartUIEvent.CLICK_ITEM,
            ChartUIEvent.FOCUS_ITEM,
            ChartUIEvent.BLUR_ITEM,
            ChartUIEvent.MOUSE_UP_ITEM,
            ChartUIEvent.MOUSE_DOWN_ITEM,
            ChartUIEvent.SMOOTHING_START,
            ChartUIEvent.SMOOTHING_END,
			ChartUIEvent.DATA_VISIBLE_CHANGE
        ];
        
        /**
        * Constructor
        */
        public function ChartSimpleInterface() 
        {
        }
        
        /* INTERFACE cn.alibaba.yid.chart.external.IChartInterface */
        
        /**
        * 初始化图表的对外接口
        * @param	chart
        */
        public function initChartExternal(chart:Chart):void
        {
            Security.allowDomain('*');
            Security.allowInsecureDomain('*');
            
            //AppSetting.Set('debug', true);
            
            var name:String;
            if (ExternalInterface.available) {
                for each(name in APIS) {
                    ExternalInterface.addCallback(name, chart[name]);
                }
            }
            
            for each(name in EVENTS) {
                chart.addEventListener(name, dispatchEventToExternal, false, 0, true);
            }
            
            var presetWidth:Number  = Number(getSetting('chartWidth')) || Number(getSetting('w'));
            var presetHeight:Number = Number(getSetting('chartHeight')) || Number(getSetting('h'));
            var presetData:String   = getSetting('data');
            var presetCSS:String    = getSetting('css');
            var presetCharset:String = getSetting('charset');
            var presetDataUrl:String = getSetting('dataUrl');
            var presetCSSCharset:String = getSetting('cssCharset');
            var presetCSSUrl:String = getSetting('cssUrl');
            if (presetWidth) chart.chartWidth   = presetWidth;
            if (presetHeight) chart.chartHeight = presetHeight;
            if (presetCSS) chart.parseCSS(presetCSS);
            if (presetData) chart.parse(presetData);
            if (presetCSSUrl) chart.loadCSS(presetCSSUrl, presetCSSCharset);
            if (presetDataUrl) chart.load(presetDataUrl, presetCharset);
        }
        
        /**
        * 将chart中的事件广播到外部
        * @param	e
        */
        protected function dispatchEventToExternal(e:ChartEvent):void
        {
            var evt:Object = {
                type    : e.type,
                data    : e.data
            }
            var str:String = '-- dispatching "' + e.type + '" event to external:\n';
            for (var each:String in e.data) {
                str = str.concat(['   ', each, '\t:', e.data[each], '\n'].join(''));
            }
            //for debug
            //trace(str);
            
			var jsHandler:String =  getSetting("eventHandler");
			if (jsHandler && ExternalInterface.available)
			{
				evt['swfid'] = getSetting("swfid");
				ExternalInterface.call(jsHandler, evt);
			}
        }
        
        /**
        * 垃圾回收
        */
        public function dispose():void
        {
        }
        
    }

}