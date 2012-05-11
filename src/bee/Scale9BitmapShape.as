package bee 
{
	import cn.alibaba.util.DisplayUtil;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class Scale9BitmapShape extends Shape
	{
		
		private var _source:BitmapData;
		private var _scale9Grid:Rectangle;
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function Scale9BitmapShape() 
		{
			
		}
		
		public function setBackground(bitmapData:BitmapData, withScale9:Boolean = false):void
		{
			var w:int = bitmapData.width;
			var h:int = withScale9 ? bitmapData.height >> 1 : bitmapData.height;
			_source = new BitmapData(w, h);
			
			if (withScale9) {
				
				_source.setVector(_source.rect, bitmapData.getVector(new Rectangle(0, 0, w, h)));
				
				var resultGrid:Rectangle = new Rectangle();
				
				//中间一条线，用来检测 top 和 bottom
				var rect:Rectangle = new Rectangle(w >> 1, bitmapData.height - h, 1, h);
				var vctV:Vector.<uint> = bitmapData.getVector(rect);
				vctV.fixed = true;
				//横向一条线，用来检测left 和 right
				rect = new Rectangle(0, bitmapData.height -(h >> 1), w, 1);
				var vctH:Vector.<uint> = bitmapData.getVector(rect);
				vctH.fixed = true;
				
				var startColor:int = vctV[0];
				var checker:Function = function(color:uint, id:int, vct:Vector.<uint>):Boolean {
					if (id == 0) {
						return false;
					}
					var prev:uint = vct[id - 1];
					var done:Boolean = false;
					//与上一个不同
					var diff:Boolean =  id != 0 && color != prev;
					var prop:String;
					if (diff) {
						if (prev == startColor) {
							prop = vct == vctH ? 'left' : 'top';
							resultGrid[prop] = id;
						} else if(color==startColor) {
							prop = vct == vctH ? 'right' : 'bottom';
							resultGrid[prop] = id;
							done = true;
						}
					}
					return done;
				}
				
				vctV.some(checker, this);
				vctH.some(checker, this);
				
				if (resultGrid.width && resultGrid.height) {
					scale9Grid = resultGrid;
				}
				
			}  else {
				_source = bitmapData.clone();
			}
			
			redraw();
			
		}
		
		public function dispose():void
		{
			_source.dispose();
			_source = null;
			_scale9Grid = null;
		}
		
		override public function get scale9Grid():Rectangle { return _scale9Grid.clone(); }
		override public function set scale9Grid(value:Rectangle):void
		{
			_scale9Grid = value.clone();
			redraw();
		}
		
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void 
		{
			_width = value;
			redraw();
		}
		
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void 
		{
			_height = value;
			redraw();
		}
		
		private function redraw():void
		{
			if(_width && _height){
				var bmpd:BitmapData = DisplayUtil.resizeBitmap(_source, width, height, _scale9Grid );
				graphics.clear();
				graphics.beginBitmapFill(bmpd);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
		}
		
	}

}