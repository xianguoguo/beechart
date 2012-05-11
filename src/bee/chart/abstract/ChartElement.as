package bee.chart.abstract 
{
    import cn.alibaba.core.mvcapp.CView;
    import cn.alibaba.core.mvcapp.IModel;
    import bee.abstract.CComponentController;
    import bee.abstract.Skin;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
	/**
    * 图表的组成部件细分
    * @author hua.qiuh
    */
    public class ChartElement extends CComponentController
    {
        /** 所服务的图表对象 **/
        public var chart:Chart;
        public var reusable:Boolean = false;
        
        /**
        * 
        */
        public function ChartElement() 
        {
        }
        
        /**
        * 复制自身
        * @return
        */
        public function clone():ChartElement
        {
            return new ChartElement();
        }
        
        /**
         * 
         */
        override public function dispose():void 
        {
            chart = null;
            super.dispose();
        }
        
        /**
        * 设置ChartElement的view属性
        * 注意view一定需要是有效的ChartElementView对象
        * 否则会抛出异常
        */
        override public function setView(value:CView):void 
        {
            super.setView(value);
            if (value) {
				addChild(value);
			}
        }
        
        
    }

}