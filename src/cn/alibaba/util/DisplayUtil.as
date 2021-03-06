package cn.alibaba.util 
{
	import cn.alibaba.core.IDisposable;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * DisplayUtil 类加入了一些显示有关的常见方法
	 * @author qhwa, http://china.alibaba.com
	 */
	public class DisplayUtil
	{
		
		/**
		 * 颜色叠加效果
		 * @param	target
		 * @param	color
		 * @param	alpha
		 */
		static public function setDisplayColor(target:DisplayObject, color:int, alpha:Number = 1):void
		{
			if (!target) return;
			var op:Number = 1 - alpha;
			var trans:ColorTransform = new ColorTransform(op, op, op, 1, 
				alpha * (color >> 16),  //red
				alpha * (color >> 8 & 0xFF), //green 
				alpha * (color & 0xFF) //blue
			);
			target.transform.colorTransform = trans;
		}
		
		 /**
		  * 生成一个位图的倒影
		  * @author qhwa, http://china.alibaba.com
		  * @param	bmp	原始的BitmapData对象
		  * @return	添加了倒影的BitmapData对象
		  */
		static public function makeReflection(bmp:BitmapData):BitmapData
		{		
			// create reflection		
			var bmpWithReflection:BitmapData = new BitmapData(bmp.width, bmp.height*2, true, 0);
			
			// draw a copy of the image
			bmpWithReflection.draw(bmp);
			//bmpWithReflection.copyPixels(bmp, new Rectangle(0,0,bmp.width, bmp.height), new Point(0,0));
			
			// draw the reflection, flipped
			var alpha:Number = 0.3;
			var flipMatrix:Matrix = new Matrix(1, 0, 0, -1, 0, bmp.height*2 + 4);
			bmpWithReflection.draw( bmp, flipMatrix, new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0) );    
			
			// Fade				
			var holder:Shape = new Shape();
			var gradientMatrix:Matrix = new Matrix();
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0, 0];
			var alphas:Array = [.5, 0];
			var ratios:Array = [0, 0x80];
			gradientMatrix.createGradientBox( bmp.width, bmp.height, Math.PI/2 );
			
			holder.graphics.beginGradientFill( fillType, colors, alphas, ratios, gradientMatrix);
			holder.graphics.drawRect(0, 0, bmp.width, bmp.height);
			holder.graphics.endFill();
			 
			var m:Matrix  = new Matrix();
			m.translate(0, bmp.height);
			var alphaTrans:ColorTransform = new ColorTransform(0, 0, 0, 1, 0, 0, 0, 0);
			bmpWithReflection.draw( holder, m, alphaTrans, BlendMode.ALPHA);
			
			return bmpWithReflection;
		}
		
		/**
		 * 将一个位图对象按9宫格模式重新设置尺寸
		 * resize bitmap
		 * @param source Bitmapdata 源图片
		 * @param w Number	新宽度
		 * @param h Number 新高度
		 * @param scale9Grid Rectange 9宫模型
		 * @param smoothing 是否在绘制时进行平滑处理
		 */
		static public function resizeBitmap(source:BitmapData, w : Number, h : Number, scale9Grid:Rectangle = null, smoothing:Boolean = false):BitmapData {
			
			var bmpData:BitmapData 	= new BitmapData(w, h, true, 0x00000000);
			var mat:Matrix = new Matrix();
			
			if( scale9Grid){
				var rows:Array 			= [0, scale9Grid.top, scale9Grid.bottom, source.height];
				var cols:Array 			= [0, scale9Grid.left, scale9Grid.right, source.width];			
				var dRows:Array 		= [0, scale9Grid.top, h - (source.height - scale9Grid.bottom), h];
				var dCols:Array 		= [0, scale9Grid.left, w - (source.width - scale9Grid.right), w];
				var origin:Rectangle;
				var draw:Rectangle;
				
				for (var cx:int = 0; cx < 3; cx++) {
					for (var cy:int = 0; cy < 3; cy++) {
						origin 	= new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
						draw 	= new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
						mat.identity();
						mat.a 	= draw.width / origin.width;
						mat.d 	= draw.height / origin.height;
						mat.tx 	= draw.x - origin.x * mat.a;
						mat.ty 	= draw.y - origin.y * mat.d;
						bmpData.draw(source, mat, null, null, draw, smoothing);
					}
				}
			} else {
				mat.scale( w / source.width, h / source.height);
				bmpData.draw( source, mat, null, null, null, smoothing);
			}
			return bmpData;
		}
		
		/**
		 * 从给定的位图对象创建该图片的缩略图
		 * @param	source 源位图对象
		 * @param	w	缩略图宽度
		 * @param	h	缩略图高度
		 * @param	clip	是否对原图进行裁剪，以使缩略图中没有空白像素
		 * @param	transparent	缩略图是否是透明背景
		 * @param	backgroundColor	缩略图默认的背景色
		 * @return	缩略图位图对象
		 */
		static public function getBitmapThumb( source:BitmapData, w:Number, h:Number, clip:Boolean = false, transparent:Boolean = false, backgroundColor:int = 0xFFFFFF):BitmapData {
			var fn:Function 		= clip ? Math.max : Math.min;			
			var scale:Number 		= Math.min(1, fn( w / source.width, h / source.height));
			var newbmpd:BitmapData 	= new BitmapData(w, h, transparent, backgroundColor);
			var mtx:Matrix 			= new Matrix();
			mtx.scale(scale, scale);
			mtx.translate( w - source.width*scale >> 1, h - source.height*scale >> 1);
			newbmpd.draw( source, mtx, null, null, null, true );
			return newbmpd;
		}
		
		/**
		 * 将嵌入到AS的图片资源转化成位图对象
		 * @param	assetClass
		 * @return
		 */
		static public function assets2bmpd( assetClass:Class ):BitmapData {
			var bmp:Bitmap 		= new assetClass() as Bitmap;
			var bmpd:BitmapData = bmp.bitmapData.clone();
			bmp.bitmapData.dispose();
			return bmpd;
		}
        
        /**
        * 清除一个显示对象的子元素、图形和滤镜
        * @param	sp
        */
        static public function clearSprite( sp:DisplayObjectContainer ):void
        {
            var dis:DisplayObject;
            while (sp && sp.numChildren) {
                dis = sp.getChildAt(0);
                if (dis is DisplayObjectContainer)
                {
                    if(dis is Sprite){
                        Sprite(dis).graphics.clear();
                        Sprite(dis).filters = [];
                    }
					disposeElement(dis);
                    clearSprite(dis as DisplayObjectContainer);
                }else
                {
                    disposeElement(dis);
                }
                dis = null;
                sp.removeChildAt(0);
            }
        }
		
        static private function disposeElement(dis:DisplayObject):void
        {
            if (dis is IDisposable)
            {
                try {
                    IDisposable(dis).dispose();
                }
                catch (e:Error) {
                    
                }
            }
            if (dis.hasOwnProperty("graphics"))
            {
                if (dis is Shape)
                {
                    (dis as Shape).graphics.clear();
                }
                if (dis is Sprite)
                {
                    (dis as Sprite).graphics.clear();
                }
            }
            dis.filters = [];
            dis = null;
        }
		
	}

}