package bee.util 
{
    import cn.alibaba.util.ColorUtil;
    import bee.abstract.IStylable;
    import bee.abstract.IStyleSheet;
    import bee.util.YIDStyleSheet;
    import flash.text.StyleSheet;
    import flash.text.TextFormat;
	/**
    * ...
    * @author hua.qiuh
    */
    public class StyleUtil 
    {
        /**
        * 获取数字样式
        * @param	host
        * @param	style
        * @param	fallback
        * @return
        */
        static public function getNumberStyle(host:IStylable, style:String, fallback:Number=0):Number
        {
            if(host.hasStyle(style)){
                var n:Number = Number(host.getStyle(style));
                return isNaN(n) ? fallback : n;
            } else {
                return fallback;
            }
        }
        
        /**
        * 获取颜色样式
        * @param	host
        * @param	style
        * @return
        */
        static public function getColorStyle(host:IStylable, style:String='color', calculateWithBrightness:Boolean=true):uint
        {
            var color:uint = ColorUtil.str2int(host.getStyle(style));
            if(calculateWithBrightness){
                color = changeRGBBrightness(host, color);
            }
            return color;
        }
        
        /**
         * 根据brightness样式，对一个颜色进行亮度变化
         * @param	host 
         * @param	color   目标颜色   
         * @return  亮度变换后的颜色
         */
        static public function changeRGBBrightness(host:IStylable, color:uint):uint 
        {
            if(host.hasStyle('brightness')){
                var brightnessAdjustment:Number = Number(host.getStyle('brightness'));
                color = ColorUtil.adjstRGBBrightness( color, brightnessAdjustment );
            }
            return color;
        }
        
        /**
        * 获取布尔值的样式
        * @param	host
        * @param	style
        * @param	fallback
        * @return
        */
        static public function getBoolStyle(host:IStylable, style:String, fallback:Boolean=true):Boolean
        {
            if (host.hasStyle(style)) {
                return !/0|false/i.test(host.getStyle(style).replace(/^\s+|\s+$/g, ''));
            } else {
                return fallback;
            }
        }
        
        /**
        * 获取滤镜设置
        * @param	host
        * @param	style
        * @return
        */
        static public function getFilterStyle(host:IStylable):Array
        {
            var filters:Array = [];
            var shadow:String = host.getStyle('dropShadow')
            switch(shadow) {
                case 'light':
                    filters.push(Filter.LIGHT_DROP_SHADOW);
                    break;
                case 'none':
                default:
                    break;
            }
            return filters;
        }
        
        /**
        * 合并样式
        * @param	primaryStyles   优先级较高的配置
        * @param	secondaryStyles 优先级较低的配置
        */
        static public function mergeStyle(primaryStyles:Object, secondaryStyles:Object):Object
        {
            var out:Object = { };
            for (var each:String in secondaryStyles) {
                out[each] = secondaryStyles[each];
            }
            for (each in primaryStyles) {
                out[each] = primaryStyles[each];
            }
            return out;
        }
        
        /**
        * 处理CSS中的继承关系
        * @param	styles
        * @param	parent
        * @return
        */
        static public function inheritStyle(styles:Object, parent:IStylable):Object
        {
            var result:Object = { };
            var mtc:Array;
            for (var each:String in styles) {
                if (/^inherit$/i.test(styles[each])) {
                    result[each] = parent.getStyle(each);
                } else {
                    mtc = /inherit#(.+)/i.exec(styles[each]);
                    if (mtc) {
                        result[each] = parent.getStyle(mtc[1]);
                    } else {
                        result[each] = styles[each];
                    }
                }
            }
            return result;
            
        }
        
        /**
         * 将上层对象中以指定字符串开头的样式转存到下层中
         * 例如
         * 假设chartObj有这些样式设置：
         *   legend { color: red; }
         *   legend item { color: blue; }
         *   legend item icon { color: orange; }
         * 
         * 调用 inheritStyleSHeet(legendObj, 'legend', chartObj) 将会
         * 给legend赋以以下样式设置：
         *   { color: red } #legend本身
         *   item { color: blue; } #保存到legendObj.styleSheet中
         *   item icon { color: orange; }
         * 
         * @param	target
         * @param	prefix
         * @param	parent
         */
        static public function inheritStyleSheet(target:IStyleSheet, prefix:String, parent:IStyleSheet):void 
        {
            var parentStyleSheet:StyleSheet = parent.styleSheet;
            var mtc:Array, styles:Object, subName:String;
            prefix = prefix.toLowerCase();
            const reg:RegExp = new RegExp('^' + prefix + ' (.+)');
            
            function isAtNextLevel(sheetName:String):Boolean
            {
                return /^\w+$/.test(sheetName)
            }
            
            for each(var sheet:String in parentStyleSheet.styleNames)
            {
                if (sheet === prefix) 
                {
                    target.setStyles(inheritStyle(parentStyleSheet.getStyle(prefix), parent));
                } else {
                    mtc = sheet.match(reg);
                    if (mtc) {
                        subName = mtc[1];
                        styles = parentStyleSheet.getStyle(mtc[0]);
                        if (isAtNextLevel(mtc[0])) {
                            styles = inheritStyle(styles, parent);
                        }
                        styles = mergeStyle( styles, target.styleSheet.getStyle( subName ) );
                        target.styleSheet.setStyle( subName, styles );
                    }
                }
            }
            
        }
        
        /**
         * 将两个StyleSheet进行合并
         * @param	primary 主要样式表
         * @param	base 次要样式表, 将会修改这个样式表
         * @return 
         */
        static public function mergeStyleSheet(primary:StyleSheet, base:StyleSheet):void 
        {
            for each(var name:String in primary.styleNames) {
                base.setStyle(name, mergeStyle(primary.getStyle(name), base.getStyle(name)));
            }
        }
    
        /**
        * 由Style设置生成TextFormat对象
        * @param	host
        * @return
        */
        static public function getTextFormat(host:IStylable):TextFormat
        {
            return new TextFormat(
                host.getStyle("fontFamily"), 
                host.getStyle("fontSize"),
                getColorStyle(host),
                host.getStyle("fontWeight") == 'bold',
                host.getStyle("fontStyle"),
                host.getStyle("underline"),
                null,
                null,
                host.getStyle("textAlign"),
                host.getStyle("paddingLeft"),
                host.getStyle("paddingRight"),
                host.getStyle("indent"),    
                host.getStyle("leading")
            );
        }
        
    }

}

import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;
/**
* ...
* @author hua.qiuh
*/
class Filter 
{
    static public const LIGHT_DROP_SHADOW:BitmapFilter = new DropShadowFilter(2, 90, 0, 0.4);
}
    