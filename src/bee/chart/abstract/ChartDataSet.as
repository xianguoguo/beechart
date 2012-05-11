package bee.chart.abstract
{
    import cn.alibaba.core.mvcapp.CModel;
    import flash.utils.Dictionary;

	/**
	 * 单条数据序列
	 * @author hua.qiuh
	 */
	public class ChartDataSet extends CModel
	{
		private var _name:String = "";
		private var _visible:Boolean = true;
		private var _active:Boolean = false;
		private var _values:Vector.<Number> = new Vector.<Number>();
		private var _config:Dictionary = new Dictionary(true);
		private var _min:Number;
		private var _max:Number;
		private var _length:uint = 0;
        protected var _index:int = -1;
        protected var _displayIndex:int = -1;
		protected var _valueType:String = '';
        
		/**
		 *
		 * @param	name
		 * @param	values
		 * @param    configs
		 */
		public function ChartDataSet(name:String="", values:Vector.<Number>=null, config:Object=null)
		{
			this.name = name;

			if (values)
			{
				_values = values.concat();
			}

			if (config)
			{
				for (var each:String in config)
				{
					this.config[each] = config[each];
				}
			}

			updateRange();
		}

		public function clone():ChartDataSet
		{
			var clone:ChartDataSet = new ChartDataSet(name, values, config);
			clone.index = _index;
			clone.displayIndex = _index;
			clone.visible = _visible;
			clone.active = _active;
			clone.valueType = _valueType;
			return clone;
		}

		override public function dispose():void
		{
			_config = null;
			_values = null;
			super.dispose();
		}

		/**
		 * 获取该数据中是否包含这个点
		 * @param	xIndex
		 * @param	value
		 */
		public function hasPoint(xIndex:Number, value:Number):Boolean
		{
			return _values.length > xIndex && _values[xIndex] == value;
		}

		/**
		 * 获取第n个位置上的值
		 * @param	xIndex
		 * @return
		 */
		public function getValueAt(xIndex:uint):Number
		{
			if (xIndex < 0 || xIndex >= _values.length)
				return Number.NaN;
			return _values[xIndex];
		}

		/**
		 * 获取子样式
		 * @param	styleName
		 * @return
		 */
		public function getSheet(styleName:String):Object
		{
			if (config.sheet)
			{
				return config.sheet[styleName];
			}
			return {};
		}

		/**
		 * 数值
		 */
		public function get values():Vector.<Number>
		{
			return _values;
		}

		public function set values(newValues:Vector.<Number>):void
		{
			if (_values != newValues)
			{
				_values = newValues;
				_changed = true;
				updateRange();
				notifyChange();
			}
		}

		/**
		 * 该条数据序列的展示时的特殊配置（例如颜色）
		 */
		public function get config():Dictionary
		{
			return _config;
		}

		public function set config(value:Dictionary):void
		{
			_config = value;
		}

		/**
		 * 样式设置
		 */
		public function get styleConfig():Object
		{
			return _config && _config.style ? _config.style : {};
		}

		/**
		 * 名称
		 */
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
			notifyChange();
		}

		/**
		 * 是否处于激活状态
		 */
		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			if (_visible != value)
			{
				_visible = value;
				notifyChange();
			}
		}

		public function get total():Number
		{
			var n:Number = 0;
			for each (var value:Number in values) 
			{
				if (!isNaN(value))
				{
					n += value;
				}
			}
			return n;
		}

		public function get length():uint
		{
			return _length;
		}

		public function get min():Number
		{
			return _min;
		}

		public function get max():Number
		{
			return _max;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			if (_active != value)
			{
				_active = value;
				notifyChange();
			}
		}
        
        public function get index():int { return _index; }
        public function set index(value:int):void 
        {
            _index = value;
            _displayIndex = value;
        }
        
        public function get displayIndex():int 
        {
            return _displayIndex;
        }
        
        public function set displayIndex(value:int):void 
        {
            _displayIndex = value;
        }
		
		
		public function get valueType():String {return _valueType;}
		
		public function set valueType(value:String):void 
		{
			_valueType = value;
		}	
		

		private function updateRange():void
		{
			_max = 0;
			_min = Number.MAX_VALUE;
			_length = values.length;
			for each (var value:Number in values ) 
			{
				if (value > _max)
				{
					_max = value;
				}
				if (value < _min)
				{
					_min = value;
				}
			}
		}
        
        override public function toString():String 
        {
            return "[ChartDataSet#" + index + " : " + name + "]";
        }

	}

}