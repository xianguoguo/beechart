package bee.chart.elements.pie
{
    import flash.display.Sprite;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieSliceCanvas extends Sprite
    {
        //所占的弧度
        private var _radian:Number;
        //所对应的半径
        private var _radius:Number;
        //最终位置的起始弧度
        private var _startRadian:Number;

        public function PieSliceCanvas(radius:Number, radian:Number, startRadian:Number=0)
        {
            _radius = radius;
            _radian = radian;
            _startRadian = startRadian;
        }

        public function get radius():Number
        {
            return _radius;
        }

        public function set radius(value:Number):void
        {
            _radius = value;
        }

        public function get radian():Number
        {
            return _radian;
        }

        public function set radian(value:Number):void
        {
            _radian = value;
        }

        public function get startRadian():Number
        {
            return _startRadian;
        }

        public function set startRadian(value:Number):void
        {
            _startRadian = value;
        }

    }

}