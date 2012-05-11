package bee.abstract
{
    
    /**
     * 可设置样式的类
     * @author hua.qiuh
     */
    public interface IStylable 
    {
        /**
         * 设置样式
         * @param	name 样式名称。如 color 或 color.up
         * @param	value 样式值，统一以字符串存储
         */
        function setStyle(name:String, value:String):void;
        
        /**
         * 设置多个样式
         * @param	styles 样式对象。例如 { "color": "#00FFFF", "color.up" : "#FF0000" }
         */
        function setStyles( styles:Object ):void;
        
        /**
         * 清除所有样式
         */
        function clearStyles():void;
        
        /**
         * 重设所有样式，恢复到默认样式
         */
        function resetStyles():void;
        
        /**
         * 获取样式
         * @param	name 样式名称
         * @return 该样式设置的值
         */
        function getStyle(name:String):String;
        
        /**
         * 删除样式
         * @param	name 样式名称
         */
        function unsetStyle(name:String):void;
        
        /**
        * 检查是否已经设置了某种样式
        * @param	name 样式名称
        * @return
        */
        function hasStyle(name:String):Boolean;
    }
    
}