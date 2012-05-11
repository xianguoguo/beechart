package bee.chart.util
{
	import cn.alibaba.util.ColorUtil;
    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Matrix;

	/**
	 * 颜色生成器
	 * @author jianping.shenjp
	 */
	public class AutoColorUtil
	{
		//提供的颜色配置
		static private var _baseColors:Vector.<uint>=new Vector.<uint>();
		//生成的颜色排列数据是否需要重新生成
		static private var _needRegenerate:Boolean=true;
		//生成的颜色排列数据
		static private var _generatedColors:Vector.<uint>;
		//需要生成颜色的总数
		static private var _generatedColorNum:int=0;

		static public function addColor(color:uint):void
		{
			_baseColors.push(color);
			_needRegenerate=true;
		}

        /**
        * 添加多种颜色
        * @param	colors
        */
		static public function addColors(colors:*):void
		{
			if (colors is Vector || colors is Array)
			{
				for each (var each:String in colors)
				{
					_baseColors.push(ColorUtil.str2int(each));
				}
				_needRegenerate = true;
			}
		}

		static public function set generaterColorNum(value:int):void
		{
			_generatedColorNum=value;
			_needRegenerate=true;
		}

        /**
        * 设置或获取基础色
        */
		static public function get baseColors():Vector.<uint>
		{
			return _baseColors.concat();
		}

		static public function set baseColors(vec:Vector.<uint>):void
		{
			_baseColors=vec.concat();
			_needRegenerate=true;
		}

		/**
		 * 重置颜色数组
		 */
		static public function reset():void
		{
			_baseColors.length=0;
			_needRegenerate=true;
		}

        /**
        * 基础颜色的数量
        */
		static public function get length():int
		{
			return _baseColors.length;
		}

		/**
		 * 获取制定索引的颜色数据
		 * @param	index
		 * @return
		 */
		static public function getColor(index:int):uint
		{
			var returnColor:uint=0;
			if (length == 0)
			{
				return 0;
			}
			if (_needRegenerate)
			{
				//给与的配置颜色数>需要生成的颜色数，就按给与的配置颜色数生成，否则按照需要生成的颜色数
                generateColors(length > _generatedColorNum ? length : _generatedColorNum);
			}
			returnColor = _generatedColors[index];
			return returnColor;
		}

		/**
		 * 生成颜色排列数据.
		 * 先将颜色数据平均分配到生成的颜色排列数据中，然后未分配的数据值为0，
		 * 根据前后不为0的颜色数据，使得中间颜色为前后颜色的渐变色。
		 * @param	totalNum
		 */
		static private function generateColors(totalNum:int):void
		{
			if (length == 0)
			{
				return;
			}
        
            _generatedColors = new Vector.<uint>();
            
            var sp:Shape = new Shape();
            var g:Graphics = sp.graphics;
            var colors:Array = [];
            var radios:Array = [];
            var alphas:Array = [];
            var len:uint = _baseColors.length;
            var step:Number = 0xFF / len;
            var color:uint;
            for (var i:uint = 0; i < len; i++) {
                color = _baseColors[i];
                colors.push(color);
                radios.push(step * i);
                alphas.push(1);
            }
            colors.push(_baseColors[0]);
            radios.push(255);
            alphas.push(1);
            
            var mtx:Matrix = new Matrix();
            mtx.createGradientBox(totalNum, 1);
            g.beginGradientFill(GradientType.LINEAR, colors, alphas, radios, mtx);
            g.drawRect(0, 0, totalNum, 1);
            g.endFill();
            var bmpd:BitmapData = new BitmapData(totalNum, 1, false);
            bmpd.draw(sp);
            
            var genColors:Vector.<uint> = bmpd.getVector(bmpd.rect);
			for each (color in genColors) 
			{
				_generatedColors.push(color & 0xFFFFFF);
			}
			_needRegenerate = false;
            
            g.clear();
            g = null;
            sp = null;
            bmpd.dispose();
		}
        
    }

}