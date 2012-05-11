package bee.chart.elements.pie 
    {
    import cn.alibaba.core.mvcapp.CModel;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.assemble.pie.PieChartViewer;
    import flash.geom.Point;
    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieSliceData extends ChartDataSet 
    {
        static public const TO_RADIANS:Number = Math.PI / 180;
        //序列
        //protected var _index:int = -1;
        //数值
        protected var _value:Number = 0.0;
        //所占的弧度
        protected var _radian:Number = 0.0;
        //所对应的半径
        protected var _radius:Number = 0.0;
        //最终位置的起始弧度
        protected var _startRadian:Number = 0.0;
        //颜色
        protected var _color:uint = 0;
        //小圆饼的x坐标
        protected var _pieSliceCanvasX:Number = 0.0;
        //小圆饼的y坐标
        protected var _pieSliceCanvasY:Number = 0.0;
        //是否在圆饼的右半部分
        protected var _isRightSide:Boolean = false;
        //是否在圆饼的上半部分
        protected var _isUpSide:Boolean = false;
        
        protected var _labelRadiusAdj:Number = 0.0;
        
        protected var _percent:Number = 0.0;
        
        public function PieSliceData(name:String = "", values:Vector.<Number>=null, config:Object=null) 
        {
            super(name, values, config);
            if (values != null && values.length)
            {
                value = sum(values);
            }
        }

        /**
        * 从一个ChartDataSet生成一个PieSliceData
        * @param	dataSet
        * @return
        */
        static public function fromDataSet(dataSet:ChartDataSet):PieSliceData
        {
            var data:PieSliceData = new PieSliceData(dataSet.name, dataSet.values, dataSet.config);
            data.visible = dataSet.visible;
            data.active = dataSet.active;
            data.index = dataSet.index;
            return data;
        }
        
        public function get radian():Number { return _radian; }
            
        public function set radian(value:Number):void 
        {
            if(_radian != value){
                _radian = value;
                updateStat();
            }
        }
        
        //返回占据的角度
        public function get angle():Number {
            var _angle:Number = 0;
            if(_radian){
                _angle =  _radian / TO_RADIANS; 
            }
            return _angle;
        }
        
        public function get radius():Number { return _radius; }
        public function set radius(value:Number):void 
        {
            if(value!=_radius){
                _radius = value;
            }
        }
        
        public function get startRadian():Number { return _startRadian; }
        public function set startRadian(value:Number):void 
        {
            if(value!=_startRadian){
                _startRadian = value;
                updateStat();
            }
        }
        
        public function get color():uint { return _color; }
        public function set color(value:uint):void 
        {
            _color = value;
        }
        
        public function get pieSliceCanvasX():Number { return _pieSliceCanvasX; }
        public function set pieSliceCanvasX(value:Number):void 
        {
            _pieSliceCanvasX = value;
        }
        
        public function get pieSliceCanvasY():Number { return _pieSliceCanvasY; }
        public function set pieSliceCanvasY(value:Number):void 
        {
            _pieSliceCanvasY = value;
        }
        
        public function get value():Number { return _value; }
        public function set value(value:Number):void 
        {
            _value = value;
        }
        
        //返回数据所处位置的中间弧度
        public function getPositionRadian():Number {
            return startRadian + radian/ 2;
        }
        
        //返回数据所处位置的中间角度
        public function getPositionAngle():Number {
            return getPositionRadian() / TO_RADIANS;
        }
        
        //是否该数据对应的位置位于圆饼右半部分
        public function get isRightSide():Boolean {
            return _isRightSide;
        }
        
        //是否该数据对应的位置位于圆饼上半部分
        public function get isUpSide():Boolean {
            return _isUpSide;
        }
        
        public function get labelRadiusAdj():Number { return _labelRadiusAdj; }
        public function set labelRadiusAdj(value:Number):void 
        {
            _labelRadiusAdj = value;
        }
        
        override public function clone():ChartDataSet
		{
			return new PieSliceData(name, values, config);
		}
        
        protected function updateStat():void {
            var isRightSide:Boolean = false;
            var isUpSide:Boolean = false;
            var angle:Number = 0;
            angle = getPositionRadian() / TO_RADIANS;
            if (angle >= 270 || angle <= 90) {
                isRightSide = true;
            }
            if (angle>=180)
            {
                isUpSide = true;
            }
            _isRightSide = isRightSide;
            _isUpSide = isUpSide;
        }
        
        public function get percent():Number { return _percent; }
        
        public function set percent(value:Number):void 
        {
            _percent = value;
        }
        
        public function isGroup():Boolean
        {
            return false;
        }
        
        public function createPieSlice(viewer:PieChartViewer):PieSlice 
        {
            var pieSlice:PieSlice = viewer.requestElement(PieSlice) as PieSlice;
            return pieSlice;
        }
        
        private function sum(values:Vector.<Number>):Number 
        {
            var total:Number = 0;
			for each (var v:Number in values ) 
			{
				total += v;
			}
            return total;
        }
        
        override public function toString():String
        {
            return "[PieSliceData#" + index + " : " + name + "]";
        }
    }

}