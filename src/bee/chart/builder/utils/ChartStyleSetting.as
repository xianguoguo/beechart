package bee.chart.builder.utils
{
    import bee.chart.builder.events.StyleChangeEvent;
    import bee.util.YIDStyleSheet;
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    /**
     * 编辑器图表样式操作类
     */
    /**style改变分发事件*/
    [Event(name="styleChange", type="bee.chart.builder.events.StyleChangeEvent")]
    public class ChartStyleSetting extends EventDispatcher
    {
        static private var _instance:ChartStyleSetting;
        
        private var _styleSheet:YIDStyleSheet;
        
        public function get styleSheet():YIDStyleSheet
        {
            return _styleSheet;
        }
        
        public function set styleSheet(value:YIDStyleSheet):void
        {
            _styleSheet = value as YIDStyleSheet;
        }
        
        public function ChartStyleSetting(clz:PrivateClass)
        {
            if (clz == null)
            {
                throw IllegalOperationError("error");
            }
            _styleSheet = new YIDStyleSheet();
        }
        
        static public function getInstance():ChartStyleSetting
        {
            if (!ChartStyleSetting._instance)
            {
                ChartStyleSetting._instance = new ChartStyleSetting(new PrivateClass());
            }
            return ChartStyleSetting._instance;
        }
        
        public function setStyle(styleName:String, styleObject:Object):void
        {
            if (styleName && styleObject)
            {
                styleName = styleName.toLowerCase();
                var styleObj:Object = styleSheet.getStyle(styleName);
                if (styleObj)
                {
                    for (var each:String in styleObject)
                    {
                        styleObj[each] = styleObject[each];
                        trace("ChartSetting:", each, " _ " + styleObj[each]);
                    }
                    styleSheet.setStyle(styleName, styleObj);
                }
            }
        }
        
        public function getStyle(styleName:String):Object
        {
            styleName = styleName.toLowerCase();
            return styleSheet.getStyle(styleName);
        }
        
        /**
         * 返回CSS格式的字符串
         * @return
         *
         */
        public function getStyleString():String
        {
            return YIDStyleSheet(styleSheet).toCSSText();
        }
        
        public function clearStyle():void
        {
            _styleSheet = null;
            _styleSheet = new YIDStyleSheet();
        }
        
        //解析css样式.
        public function parseCSS(cssString:String):void
        {
            _styleSheet.parseCSS(cssString);
        }
    }
}

class PrivateClass
{
    
    public function PrivateClass()
    {
    
    }
}