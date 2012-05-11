package bee.chart.elements.scalerect
{
    import cn.alibaba.core.mvcapp.CModel;
    import bee.chart.elements.pie.PieSliceData;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class ScaleRectData extends CModel
    {
        private var _sliceDatas:Vector.<PieSliceData>;
        private var _width:Number = 0.0;
        private var _height:Number = 0.0;
        private var _frameColor:uint = 0;
        private var _total:Number = 0.0;

        public function ScaleRectData()
        {
            super();

        }

        public function get sliceDatas():Vector.<PieSliceData>
        {
            return _sliceDatas.concat();
        }

        public function set sliceDatas(value:Vector.<PieSliceData>):void
        {
            _sliceDatas = value ? value.concat() : null;
            updateState();
            notifyChange();
        }

        public function get width():Number
        {
            return _width;
        }

        public function set width(value:Number):void
        {
            _width = value;
        }

        public function get height():Number
        {
            return _height;
        }

        public function set height(value:Number):void
        {
            _height = value;
        }

        public function get frameColor():uint
        {
            return _frameColor;
        }

        public function set frameColor(value:uint):void
        {
            _frameColor = value;
        }

        public function get total():Number
        {
            return _total;
        }

        private function updateState():void
        {
            var total:Number = 0.0;
            if (_sliceDatas)
            {
                for each (var sliceData:PieSliceData in _sliceDatas)
                {
                    total += sliceData.value;
                }
            }
            _total = total;
        }

    }

}