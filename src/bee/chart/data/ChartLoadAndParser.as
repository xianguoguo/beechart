package bee.chart.data 
{
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartStates;
    import bee.chart.events.ParserEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartLoadAndParser extends ChartParser implements ILoadAndParser
    {
        private var _baseParser:ChartParser;
        private var _loader:URLLoader;
        private var _cssLoader:URLLoader;
        private var _charset:String = 'utf-8';
        private var _cssCharset:String = 'utf-8';
        private var _toAppendCSS:Boolean;
            
        /**
         * 当加载开始时，会触发该事件
         */	
        [Event(name = "load_start", type = "bee.chart.events.ParserEvent")]
            
        /**
         * 当加载失败时，会触发LOAD_FAIL事件
         */	
        [Event(name = "load_fail", type = "bee.chart.events.ParserEvent")]
        
        /**
        * 加载完成时，触发该事件
        */
        [Event(name="load_finish", type = "bee.chart.events.ParserEvent")]
        
        /**
        * 
        * @param	chart
        */
        public function ChartLoadAndParser(chart:Chart) 
        {
            super(chart);
            
            _baseParser = new ChartParser(chart);
            _loader = new URLLoader();
            _loader.dataFormat = URLLoaderDataFormat.BINARY;
            _cssLoader = new URLLoader();
            _cssLoader.dataFormat = URLLoaderDataFormat.BINARY;
            addListeners();
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Public Functions
        
        /**
        * 加载数据和样式
        * @param	url 目标地址
        * @eventType cn.alibaba.yid.chart.events.ParserEvent.LOAD_START
        */
        public function load(url:String, charset:String=null):void
        {
            if (charset) {
                _charset = charset;
            }
            _loader.load(new URLRequest(url));
        }
        
        /**
        * 加载样式
        * @param	url 目标地址
        * @eventType cn.alibaba.yid.chart.events.ParserEvent.LOAD_START
        */
        public function loadCSS(url:String, charset:String = null, toAppend:Boolean = false ):void
        {
            if (charset) {
                _cssCharset = charset;
            }
            _toAppendCSS = toAppend;
            _cssLoader.load(new URLRequest(url));
        }
        
        override public function parse(src:String):void 
        {
            _baseParser.parse(src);
        }
        
        override public function parseCSS(src:String, toAppend:Boolean=false):void 
        {
            _baseParser.parseCSS(src,toAppend);
        }
        
        override public function dispose():void 
        {
            _baseParser.dispose();
            _baseParser = null;
            removeListeners();
            _loader = null;
            _cssLoader = null;
            super.dispose();
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Private Functions
        
        private function addListeners():void
        {
            _loader.addEventListener(Event.COMPLETE, onLoadComplete);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
            _loader.addEventListener(Event.OPEN, onLoadStart);
            
            _cssLoader.addEventListener(Event.COMPLETE, onCSSLoadComplete);
        }
        
        private function removeListeners():void
        {
            _loader.removeEventListener(Event.COMPLETE, onLoadComplete);
            _loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
            _loader.removeEventListener(Event.OPEN, onLoadStart);
            
            _cssLoader.removeEventListener(Event.COMPLETE, onCSSLoadComplete);
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Event Handlers
        
        /**
        * @eventType    cn.alibaba.yid.chart.events.ParserEvent.LOAD_FINISH
        * @param	e
        */
        private function onLoadComplete(e:Event):void 
        {
            var evt:ParserEvent = new ParserEvent(ParserEvent.LOAD_FINISH)
            _chart.dispatchEvent(evt);
            
            var bytes:ByteArray = e.target.data as ByteArray;
            var str:String = bytes.readMultiByte(bytes.length, _charset);
            parse(str);
        }
        
        private function onCSSLoadComplete(e:Event):void
        {
            var bytes:ByteArray = e.target.data as ByteArray;
            var str:String = bytes.readMultiByte(bytes.length, _cssCharset);
            parseCSS(str, _toAppendCSS);
        }
        
        /**
        * 
        * @eventType    cn.alibaba.yid.chart.events.ParserEvent.LOAD_START
        * @param	e
        */
        private function onLoadStart(e:Event):void 
        {
            var evt:ParserEvent = new ParserEvent(ParserEvent.LOAD_START)
            _chart.dispatchEvent(evt);
            
            if (!evt.isDefaultPrevented()) {
                _chart.state = ChartStates.LOADING;
            }
        }
        
        /**
        * @eventType    cn.alibaba.yid.chart.events.ParserEvent.LOAD_FAIL
        * @param	e
        */
        private function onLoadFail(e:Event):void 
        {
            var evt:ParserEvent = new ParserEvent(
                ParserEvent.LOAD_FAIL, 
                'error while loading external data. details: '.concat(e.toString())
            );
            _chart.dispatchEvent(evt);

			trace(e.toString());
            
            if (!evt.isDefaultPrevented()) {
                _chart.state = ChartStates.LOAD_FAIL;
            }
        }
        
        
    }

}
