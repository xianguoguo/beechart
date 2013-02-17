package bee.chart.elements.axis
{
    import cn.alibaba.core.mvcapp.CModel;
	import bee.chart.elements.timeline.labelmaker.LabelInfo;
    /**
    * ...
    * @author hua.qiuh
    */
    public class AxisData extends CModel
    {
        public var highlightValue:Number = -1;
        
        private var _name:String;
        private var _labels:Vector.<String> = new Vector.<String>();
        private var _direction:uint = AxisDirection.RIGHT;
        private var _length:Number = 200;
        private var _isValueAxis:Boolean = false;
		private var _labelInfos:Vector.<LabelInfo>;
		//用于标识Y轴是否属于事件类型
		protected var _valueType:String = '';
		
        public function AxisData()
        {

        }

        /**
        * 获取或设置标签数组
        */
        public function get labels():Vector.<String> { return _labels; }
        public function set labels(value:Vector.<String>):void
        {
            _labels = value;
            notifyChange();
        }
        
        public function get direction():uint { return _direction; }
        public function set direction(value:uint):void 
        {
            if(value != _direction){
                _direction = value;
                notifyChange();
            }
        }
        
        public function get length():Number { return _length; }
        public function set length(value:Number):void 
        {
            if(value != _length){
                _length = value;
                notifyChange();
            }
        }
        
        public function get name():String { return _name; }
        public function set name(value:String):void 
        {
            if(value != _name){
                _name = value;
                notifyChange();
            }
        }
        
        public function get isValueAxis():Boolean { return _isValueAxis; }
        public function set isValueAxis(value:Boolean):void 
        {
            if(_isValueAxis != value){
                _isValueAxis = value;
                notifyChange();
            }
        }
		
		public function get labelInfos():Vector.<LabelInfo> 
		{
			return _labelInfos ? _labelInfos.concat() : null;
		}
		
		public function set labelInfos(value:Vector.<LabelInfo>):void 
		{
			_labelInfos = value;
			notifyChange();
		}

		
		public function get valueType():String {return _valueType;}
		
		public function set valueType(value:String):void 
		{
            if(_valueType != value){
				_valueType = value;
				notifyChange();
			}
		}
    }

}