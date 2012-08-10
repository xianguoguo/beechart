package bee.chart.data 
{
	import cn.alibaba.util.log;
    import bee.chart.abstract.Chart;
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.data.IParser;
    import bee.chart.events.ParserEvent;
    import bee.chart.util.FusionConverter;
    import bee.util.StyleUtil;
    import bee.util.YIDStyleSheet;
    import com.adobe.serialization.json.JSON;
    import flash.events.EventDispatcher;
    import flash.text.StyleSheet;
    
    
    
    /**
    * 解析数据时失败
    */
    [Event(name="parse_fail", type="bee.chart.events.ParserEvent")]
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartParser extends EventDispatcher implements IParser
    {
        protected var _chart:Chart;
        
        public function ChartParser(chart:Chart) 
        {
            _chart = chart;
        }
        
        /* INTERFACE cn.alibaba.yid.chart.data.IParser */
        
        /**
        * 解析内容，包括数据和样式
        * @param	src 字符串，可以是XML或JSON格式
        * @eventType    cn.alibaba.yid.chart.events.ParserEvent.PARSE_FAIL
        */
        public function parse(src:String):void
        {
            try
            {
                log("parse... isXML:", isXML(src), " isJSON:", isJSON(src), src);
                if (isXML(src)) {
                    var xml:XML = XML(src);
                    if (isFusionChartXML(src)) {
                        xml = FusionConverter.convertXML(xml);
                    }
                    parseXML(xml);
                } else if (isJSON(src)) {
                    parseJSON(src);
                }
                var evt:ParserEvent = new ParserEvent(ParserEvent.DATA_PARSED);
                _chart.dispatchEvent(evt);
            }
			catch (e:Error) {
                _chart.dispatchEvent(new ParserEvent(ParserEvent.PARSE_FAIL));
                _chart.state = ChartStates.PARSE_FAIL;
				log(e.getStackTrace());
            }
        }
        
        /**
        * 解析样式
        * @param	src 字符串
        */
        public function parseCSS(src:String, toAppend:Boolean=false):void
        {
            if(!src){
                return;
            }
            log("parseCSS", src, toAppend);
            if(toAppend){
                var styleSheet:YIDStyleSheet = new YIDStyleSheet();
                styleSheet.parseCSS(src);
                StyleUtil.mergeStyleSheet( styleSheet, _chart.styleSheet );
            } else {
                _chart.resetStyles();
                _chart.styleSheet.clear();
                _chart.styleSheet.parseCSS( src );
            }
            
            _chart.setStyles(_chart.styleSheet.getStyle('chart'));
            
            parseStyleToProperty('width', 'chartWidth', Number);
            parseStyleToProperty('height', 'chartHeight', Number);
            parseStyleToProperty('enableMouseTrack', 'enableMouseTrack', Boolean);
            parseStyleToProperty('enableTooltip', 'enableTooltip', Boolean);
            
            if (_chart.state === ChartStates.NORMAL) {
                _chart.updateViewStyleNow();
            }
            
            var evt:ParserEvent = new ParserEvent(ParserEvent.CSS_PARSED);
            _chart.dispatchEvent(evt);
        }
        
        public function dispose():void
        {
            _chart = null;
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Private Functions
        
        protected function refreshChart():void
        {
            if (_chart.state === ChartStates.NORMAL) {
                _chart.updateViewNow();
            } else {
                _chart.state = ChartStates.NORMAL;
            }
        }
        
        protected function parseStyleToProperty(styleName:String, propertyName:String, type:Class):void
        {
            if (_chart.hasStyle(styleName)) {
                var value:*;
                switch(type) {
                    case Number:
                        value = Number(_chart.getStyle(styleName));
                        if (!isNaN(value)) {
                            _chart[propertyName] = value;
                        }
                        break;
                    case Boolean:
                        value = StyleUtil.getBoolStyle(_chart, styleName);
                        _chart[propertyName] = value;
                        break;
                }
            }
        }
        
        static private function isFusionChartXML(str:String):Boolean
        {
            return /^\s*(?:<\?xml .*\?>)?\s*<graph(\s|>)/mi.test(str);
        }
        
        static private function isXML(str:String):Boolean
        {
            return /^\s*</ms.test(str);
        }
        
        static private function isJSON(str:String):Boolean
        {
            return /^\s*{.+}\s*$/ms.test(str);
        }
        
        
        private function parseXML(content:XML):void
        {
            if (hasFailureFlag(content)) {
                renderAsFailure(content.@msg);
            } else {
                parseCSS(content.css.text());
                parseDataXML(content.data[0]);
                refreshChart();
            }
        }
        
        protected function hasFailureFlag(content:XML):Boolean
        {
            return content.@status == 'fail';
        }
        
        protected function renderAsFailure(msg:String=''):void
        {
            _chart.customMsg = msg || '';
            _chart.state = ChartStates.CUSTOM_FAIL;
        }
        
        private function parseJSON(src:String):void
        {
            var data:Object = JSON.decode(src);
            if (data['status'] == 'fail') {
                renderAsFailure(data['msg']);
            } else {
                parseCSSJSON(data['css']);
                parseDataJSON(data['data']);
                refreshChart();
            }
        }
        
        protected function parseDataXML(dataXML:XML):void
        {
            var data:ChartData = _chart.data;
            data.clear();
            if (dataXML.indexAxis.length()) {
                data.labels = Vector.<String>(dataXML.indexAxis.labels.text().toString().split(','));
                data.defineLabel(dataXML.indexAxis.@name);
            }
            if(dataXML.valueAxis.length()){
                data.defineValue(
                    dataXML.valueAxis.@name,
                    dataXML.valueAxis.@unit,
                    dataXML.valueAxis.@type
                );
            }
            
            var dSet:ChartDataSet;
            var config:Object;
            var styleConfig:Object;
            var styleXML:XML;
            var values:String;
            
            for each(var dSetXML:XML in dataXML.dataSets.set) {
                config = { };
                styleConfig = { };
                config.style = styleConfig;
                
                for each(styleXML in dSetXML.style.item) {
                    styleConfig[styleXML.@name] = styleXML.@value;
                }
                
                var customAtts:XMLList = dSetXML.attributes();
                var attName:String;
                var attValue:String;
                for each(var att:XML in customAtts) {
                    attName = att.name();
                    if (attName === 'name') continue;
                    attValue = dSetXML.attribute(attName);
                    config[attName] = attValue;
                }
                //TODO: parse styleSheet
                values = dSetXML.values[0];
                dSet = new ChartDataSet(
                    dSetXML.@name,
                    inputArrayToVector(values.split(",")),
                    config
                );
				dSet.valueType = dSetXML.@type.toString() || dataXML.valueAxis.@type.toString() || 'number';
                data.addSet(dSet);
            }

        }
        
        protected function parseDataJSON(obj:Object):void
        {
            obj = decodeJSONObj(obj);
            if (!obj) return;
            
            var data:ChartData = _chart.data;
            data.clear();
			if (obj.indexAxis)
			{
				data.labels = Vector.<String>(obj.indexAxis.labels);
				data.defineLabel(obj.indexAxis.name, obj.indexAxis.uint || '');
			}
			if (obj.valueAxis)
			{
				data.defineValue(
					obj.valueAxis.name,
					obj.valueAxis.unit,
					obj.valueAxis.type
				);
            }
			
            var dSet:ChartDataSet;
            var config:Object;
            var styleConfig:Object;
            
            for each(var dsetObj:Object in obj.dataSets) {
                config = { };
                styleConfig = dsetObj.style;
                config.style = styleConfig;
                parseCustomConfig(dsetObj, config);
                
                dSet = new ChartDataSet(
                    dsetObj.name,
                    inputArrayToVector(dsetObj.values),
                    config
                );
				
				dSet.valueType = dsetObj.type || obj.valueAxis.type || 'number';
				
                data.addSet(dSet);
            }
        }
        
        private function parseCustomConfig(source:Object, destConfig:Object):void
        {
            for ( var confName:String in source) {
                if (confName === 'name' 
                    || confName === 'values'
                    || confName === 'style'
                ) {
                    continue;
                }
                destConfig[confName] = source[confName];
            }
        }
        
        private function inputArrayToVector(values:Array):Vector.<Number>
        {
            var out:Vector.<Number> = new Vector.<Number>();
            for each(var value:* in values) {
                value = parseFloat(value);
                if (value === null) {
                    value = Number.NaN;
                }
                out.push(value);
            }
            return out;
        }
        
        protected function parseCSSJSON(obj:Object):void
        {
            obj = decodeJSONObj(obj);
            
            if (!obj) return;
            
            var cssTexts:Vector.<String> = new Vector.<String>();
            var styleSheet:StyleSheet = _chart.styleSheet;
            var targetName:String, styleName:String;
            var blockTexts:Vector.<String>;
            var blockStyle:Object;
            for (targetName in obj) 
            {
                cssTexts.push(targetName + ' {');
                blockStyle = obj[targetName];
                blockTexts = new Vector.<String>();
                for (styleName in blockStyle)
                {
                    blockTexts.push(styleName + ' : ' + blockStyle[styleName]);
                }
                cssTexts.push( blockTexts.join('\n') );
                cssTexts.push( '}' );
            }
            parseCSS( cssTexts.join('\n') );
        }
        
        private function decodeJSONObj(obj:Object):Object
        {
            if(obj is String){
                try{
                    obj = JSON.decode(String(obj));
                } catch (e:Error) {
                    _chart.dispatchEvent(new ParserEvent(ParserEvent.PARSE_FAIL));
                    _chart.state = ChartStates.PARSE_FAIL;
                    obj = null;
                }
            }
            return obj;
        }
        
    }

}
