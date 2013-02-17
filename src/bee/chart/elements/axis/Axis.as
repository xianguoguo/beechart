package bee.chart.elements.axis 
{
    import bee.chart.abstract.ChartElement;
    /**
    * ...
    * @author hua.qiuh
    */
    public class Axis extends ChartElement
    {
        public function Axis() 
        {
            setModel( new AxisData() );
            setView( new AxisView(this));
        }
        
        override protected function initController():void 
        {
            mouseChildren = false;
            mouseEnabled = false;
        }
        
        public function get axisView():AxisView
        {
            return view as AxisView;
        }
        
        /**
        * 坐标轴的数据模型
        */
        public function get axisData():AxisData
        {
            return model as AxisData;
        }
        
        /**
        * 获取或设置坐标轴的方向
        */
        public function get direction():uint { return axisData.direction; }
        public function set direction(value:uint):void 
        {
            axisData.direction = value;
        }
        
        /**
        * 获取或设置坐标轴的长度
        */
        public function get length():Number { return axisData.length; }
        public function set length(value:Number):void 
        {
            axisData.length = value;
        }
        
        /**
        * 获取或设置坐标轴的标签列表
        */
        public function get labels():Vector.<String> { return axisData.labels; }
        public function set labels(value:Vector.<String>):void 
        {
            axisData.labels = value;
        }
        
        public function get isValueAxis():Boolean { return axisData.isValueAxis; }
        public function set isValueAxis(value:Boolean):void 
        {
            axisData.isValueAxis = value;
        }
        
        /**
        * 突出显示坐标轴的某个标签
        * @param	value
        */
        public function highlightAt(value:Number):void 
        {
            if ( value >= 0 && value < axisData.labels.length) {
                if(value != axisData.highlightValue){
                    axisView.clearHighlight();
                    axisData.highlightValue = value;
                    axisView.highlightAt(value);
                }
            } else {
                clearHighlight();
            }
        }
        
        /**
        * 清除当前的效果
        */
        public function clearHighlight():void 
        {
            axisView.clearHighlight();
            axisData.highlightValue = -1;
        }
        
        
        
        
        
    }

}