package bee.chart.elements.scalerect
{
    import cn.alibaba.core.mvcapp.CModel;
    import bee.chart.elements.pie.PieSliceData;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class ColorRectData extends CModel
    {
        private var _name:String = "";
        private var _color:uint = 0;
        private var _width:Number = 0.0;
        private var _height:Number = 0.0;
        private var _percent:Number = 0.0;

        static public function create(sliceData:PieSliceData):ColorRectData
        {
            var result:ColorRectData = new ColorRectData();
            result.name = sliceData.name;
            result.color = sliceData.color;
            result.percent = sliceData.percent;
            return result;
        }

        public function ColorRectData()
        {
            super();

        }

        public function get name():String
        {
            return _name;
        }

        public function set name(value:String):void
        {
            _name = value;
        }


        public function get width():Number
        {
            return _width;
        }

        public function set width(value:Number):void
        {
            _width = value;
        }

        public function get height():Number { return _height; }
        
        public function set height(value:Number):void 
        {
            _height = value;
        }
        
        public function get color():uint
        {
            return _color;
        }

        public function set color(value:uint):void
        {
            _color = value;
        }

        public function get percent():Number
        {
            return _percent;
        }

        public function set percent(value:Number):void
        {
            _percent = value;
        }
        

    }

}