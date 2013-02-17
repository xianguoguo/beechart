package bee.chart.test
{
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.getTimer;
	/**
    * Point作为Vector的元素类型，效率也不错
    * @author hua.qiuh
    */
    public class VectorVSPoint extends Sprite
    {
        
        private var _vect1:Vector.<Point>;
        private var _vect2:Vector.<Number>;
        private var _vect3:Vector.<Pt>;
        
        public function VectorVSPoint() 
        {
            var len:uint = 100000;
            _vect1 = new Vector.<Point>(len, true);
            _vect2 = new Vector.<Number>(len * 2, true);
            _vect3 = new Vector.<Pt>(len, true);
            for (var i:uint = 0; i < len; i ++) {
                _vect1[i] = new Point(i*2, i*2 + 1);
                _vect2[i] = i;
                _vect2[i +len] = i + len;
                _vect3[i] = new Pt(i * 2, i * 2 + 1);
            }
            
            testNumber();
            testPoint();
            testPt();
        }
        
        private function testNumber():void
        {
            var t:uint = getTimer();
            var total:Number = 0;
            for (var i:uint = 0, len:uint = _vect2.length; i < len; i += 2) {
                total += _vect2[i] * _vect2[i + 1];
            }
            trace(total);
            trace('number method, time used:', getTimer() - t);
        }
        
        private function testPoint():void
        {
            var t:uint = getTimer();
            var total:Number = 0;
            for each(var pt:Point in _vect1) {
                total += pt.x *pt.y;
            }
            trace(total);
            trace('point method, time used:', getTimer() - t);
            
        }
        
        private function testPt():void
        {
            var t:uint = getTimer();
            var total:Number = 0;
            for each(var pt:Pt in _vect3) {
                total += pt.x * pt.y;
            }
            trace(total);
            trace('pt method, time used:', getTimer() - t);
            
        }
        
    }

}

class Pt {
    public var x:Number;
    public var y:Number;
    public function Pt(x:Number = 0, y:Number = 0) {
        this.x = x;
        this.y = y;
    }
}