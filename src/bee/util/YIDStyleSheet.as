package bee.util 
{
    import cn.alibaba.util.log;
    import flash.text.StyleSheet;
	/**
    * YID组件的组件样式表
    * 继承自flash.text.StyleSheet，并对解析CSS做了优化。
    * 支持类似 
    * <code>'line dot { color: blue with a litter red; }' </code>
    * 这样的样式设置
    * @author hua.qiuh
    */
    public class YIDStyleSheet extends StyleSheet
    {
        /**
        * 空的样式项目会造成原生StyleSheet的解析错误，故去掉 
        */
        static private const EMPTY_ITEM_PATTERN:RegExp = /\w+\s*{\s*}/;
        
        /**
        * 查找样式名称中带有空格(space/tab/newline)的块
        */
        static private const SPACE_ITEM_PATTERN:RegExp = /(\w+(?:\s+\w+)+)\s*{([^}]*\s*[^}]*)}/mg;
        
        /**
        * 查找这样的设置: 
        * styleName : styleValue
        */
        static private const PARIR_PATTERN:RegExp = /([\w.]+)\s*:\s*([^;\n]+)/g;
        
        /**
        * YIDStyleSheet 继承自 flash.text.StyleSheet
        */
        public function YIDStyleSheet() 
        {
        }
        
        
        /**
        * 在原有的StyleSheet的基础上扩展
        * 支持名称中带空格的功能
        * @param	CSSText
        */
        override public function parseCSS(CSSText:String):void 
        {
            var src:String = CSSText;
            
            if (src) {
                
                src = src.replace(/\/\*[^*\/]*\*\//mg, '') //去掉注释
                        .replace(/(?<=\w)\s+(?=:)|(?<=:)\s+(?=\w|;)/g, ''); //去掉多余空格
                
                var mtc:Array;
                var name:String;
                var values:String;
                var style:Object;
                var mtcValue:Array;
                var styleValue:String;
                while (mtc = SPACE_ITEM_PATTERN.exec(src)) {
                    name = mtc[1];
                    values = mtc[2];
                    style = getStyle(name);
                    while (mtcValue = PARIR_PATTERN.exec(values)) {
                        styleValue = mtcValue[2];
                        styleValue = styleValue.replace(/\s+$/g, '');
                        style[mtcValue[1]] = styleValue;
                    }
                    this.setStyle(name, style);
                }
                
                src = src.replace(SPACE_ITEM_PATTERN, '')
                         .replace(EMPTY_ITEM_PATTERN, '');
                
                super.parseCSS(src);
            }
        }
        
        /**
        * 将样式对象转成CSS格式的字符串
        * @return
        */
        public function toCSSText():String
        {
            var names:Array = styleNames;
            var out:Vector.<String> = new Vector.<String>();
            var objOut:Vector.<String>;
            var name:String, objName:String;
            var obj:Object;
            for each(name in names) {
                objOut = new Vector.<String>();
                objOut.push(name.concat(' {'));
                obj = getStyle(name);
                for(objName in obj) {
                    objOut.push(['\t', objName, '\t: ', obj[objName], ';'].join(''));
                }
                objOut.push('}');
                out.push(objOut.join('\n'));
            }
            return out.join('\n');
        }
        
    }

}