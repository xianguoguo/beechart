package bee.chart.elements.line 
{
    import cn.alibaba.core.mvcapp.IModel;
	import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartElement;
    import bee.chart.abstract.I2VPoint;
	import bee.chart.elements.dot.Dot;
    import bee.controls.label.Label;
    import flash.geom.Point;
	/**
    * ...
    * @author hua.qiuh
    */
    public class Line extends ChartElement
    {
        private var _hlIndex:int = -1;
		private var _dots:Vector.<Dot> = new Vector.<Dot>();
        
        public function Line() 
        {
            setView( new LineView(this) );
            mouseChildren = false;
        }
		
		public function addDotAt(dot:Dot, index:uint):void
		{
			_dots[index] = dot;
		}
		
		public function removeDot(dot:Dot):Boolean {
			var idx:int = _dots.indexOf(dot);
			if (idx != -1) {
				_dots.splice(idx, 1);
				return true;
			}
			return false;
		}
		
		public function removeDotAt(index:uint):Boolean {
			if (_dots.splice(index, 1)) {
				return true;
			}
			return false;
		}
		
		public function clearDots():void {
			while (_dots.length) {
				var dot:Dot = _dots.shift();
				//dot.dispose();
			}
			_dots.length = 0;
		}
        
        public function canHighlightDotAt(idx:uint, value:Number):Boolean
        {
            return __data.hasPoint(idx,value);
        }
        
        public function canHighlightDotAtPoint(pt:I2VPoint):Boolean
        {
            return pt && __data.hasPoint(pt.index, pt.value);
        }
        
		public function highlightDotAt(idx:uint, value:Number):void
		{
            if (canHighlightDotAt(idx,value))
            {
                highlightIndex = idx;
            }
		}
		
        /**
        * 清除线上处于高亮状态的点
        * @return 这条线上是否真的存在该位置高亮的点
        */
		public function clearHighlightDot():Boolean 
		{
			if (_hlIndex >= 0 && _hlIndex<_dots.length) {
				var dot:Dot = _dots[_hlIndex];
                if (dot.state === 'hl') {
                    if (!isLonelyDot(_hlIndex)) {
                        dot.state = state;
                    }
                    _hlIndex = -1;
                    return true;
                }
			}
            return false;
		}
        
        public function isLonelyDot(index:int):Boolean 
        {
            return __data.isLonelyDot(index);
        }
		
		override public function dispose():void 
		{
			clearDots();
			super.dispose();    
		}
        
        public function getValueAt(xIndex:int):Number 
        {
            return __data.getValueAt(xIndex);
        }
		
		public function get highlightIndex():int 
		{
			return _hlIndex;
		}
		
		public function set highlightIndex(value:int):void 
		{
			if (_hlIndex != value) {
				clearHighlightDot();
				_hlIndex = value;
			}
			if(value >= 0 && value < _dots.length){
				var dot:Dot = _dots[value];
				dot.state = 'hl';
			}
		}
        
        public function get dots():Vector.<Dot> { return _dots; }
        
        public function get lineVisible():Boolean 
        {
            return __data.visible;
        }
        
        public function get dataName():String
        {
            return __data.name;
        }
        
        public function get lineIndex():int {
            return __data.index;
        }
        
        private function get __data():LineData
        {
            return model as LineData;
        }
    }

}