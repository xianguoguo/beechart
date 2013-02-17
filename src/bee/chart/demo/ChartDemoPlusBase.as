package bee.chart.demo
{
    import bee.abstract.CComponent;
    import bee.chart.PieChart;
    import bee.chart.data.DataCenter;
    import bee.util.YIDStyleSheet;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.StyleSheet;
    
    /**
     * 图表Demo的基类
     * @author jianping.shenjp
     *
     */
    public class ChartDemoPlusBase extends Sprite
    {
        
        protected var chart:*;
        protected var dataCenter:DataCenter;
        
        public function ChartDemoPlusBase()
        {
            if (stage)
            {
                init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
        }
        
        /**
         * 设置图表某项样式
         * @param styleName
         * @param styleObject
         *
         */
        public function setStyleByName(styleName:String, styleObject:Object):void
        {
            dataCenter.setStyleByName(styleName, styleObject);
        }
        
        /**
         * 设置图表的style
         * @param cssString
         *
         */
        public function setStyle(cssString:String):void
        {
            dataCenter.setStyle(cssString);
            var styleSheet:YIDStyleSheet = new YIDStyleSheet();
            styleSheet.parseCSS(cssString);
            dataCenter.redrawChart(styleSheet);
        }
        
        /**
         * 清除数据的接口
         * */
        public function dispose():void
        {
            (chart.view as CComponent).clearContent();
            chart.dispose();
        }
        
        /**
         * 返回图表相关的StyleSheet
         * @return
         *
         */
        public function getStyleSheet():StyleSheet
        {
            return chart.styleSheet;
        }
        
		/**
		 * 初始函数 ，子类根据需要重写
		 * @param e
		 * 
		 */        
        protected function init(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
        }
		
		/**
		 * 返回XML数据，子类根据需要重写
		 * @return 
		 * 
		 */        
        protected function getDataXML():XML
        {
            return new XML();
        }
    }
}