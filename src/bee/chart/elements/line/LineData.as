package bee.chart.elements.line 
{
    import bee.chart.abstract.ChartDataSet;
    import flash.geom.Point;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LineData extends ChartDataSet
    {
        /**
        * 从一个ChartDataSet生成一个LineData
        * @param	dataSet
        * @return
        */
        static public function fromDataSet(dataSet:ChartDataSet):LineData
        {
            var data:LineData = new LineData(dataSet.name, dataSet.values, dataSet.config);
            data.visible = dataSet.visible;
            data.index = dataSet.index;
            data.valueType = dataSet.valueType;
            return data;
        }
        
        private var _dotPositions:Vector.<Point> = new Vector.<Point>();
        
        public function LineData(
            name:String = "", values:Vector.<Number>=null, config:Object=null):void
        {
            super(name, values, config);
        }
        
        public function get dotPositions():Vector.<Point> { return _dotPositions ? _dotPositions.concat() : null; }
        public function set dotPositions(value:Vector.<Point>):void 
        {
            _dotPositions = value ? value.concat() : null;
            notifyChange();
        }
        
        public function isLonelyDot(index:uint):Boolean
        {
            function hasPoint(idx:uint):Boolean
            {
                return !isNaN(values[idx]);
            }
            
            return !(index > 1 && hasPoint(index - 1) || index < length - 1 && hasPoint(index + 1));
        }
    }

}