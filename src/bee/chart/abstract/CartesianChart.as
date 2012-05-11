package bee.chart.abstract 
{
	/**
    * ...
    * @author hua.qiuh
    */
    public class CartesianChart extends Chart 
    {
        
        public function CartesianChart(viewerClass:Class=null, dataClass:Class=null, pluginClz:Vector.<Class> = null) 
        {
            viewerClass     = viewerClass || CartesianChartViewer;
            dataClass       = dataClass || CartesianChartData;
            super(viewerClass, dataClass, pluginClz);
        }
        
        
        public function get horizontal():Boolean { return __viewer.horizontal; }
        public function set horizontal(value:Boolean):void 
        {
            __viewer.horizontal = value;
        }
        
        /**
        * 增加一个关键值，程序会确保这个值出现在y轴的范围内
        * @param	value
        */
        public function addKeyValue(value:Number):void
        {
            __data.addKeyValue(value);
        }
        
        /**
        * 删除一个关键值
        * @param	value
        */
        public function removeKeyValue(value:Number):void
        {
            __data.removeKeyValue(value);
        }
        
        private function get __data():CartesianChartData
        {
            return chartModel.data as CartesianChartData;
        }
        
        private function get __viewer():CartesianChartViewer
        {
            return _view as CartesianChartViewer;
        }
    }

}