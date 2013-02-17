package bee.chart.abstract
{
    import flash.geom.Point;

    /**
     * 记录索引(index)与数值(value)对应的结构
     * @author jianping.shenjp
     */
    public class I2VPoint
    {
        public var index:uint;
        public var value:Number;

        public function I2VPoint(index:uint = 0, value:Number = 0.0)
        {
            this.index = index;
            this.value = value;
        }

        public function get x():uint { return index; }
        public function get y():Number { return value; }

        public function equals(toCompare:I2VPoint):Boolean
        {
            return toCompare && index == toCompare.index && value == toCompare.value;
        }

        public function clone():I2VPoint {
            return new I2VPoint(index, value);
        }
        
        public function toPoint():Point
        {
            return new Point(index, value);
        }
        
        static public function fromPoint(pt:Point):I2VPoint
        {
            return new I2VPoint(pt.x, pt.y);
        }
        
        public function toString():String
        {
            return '[' + index + ', ' + value + ']';
        }
    }

}