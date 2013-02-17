package cn.alibaba.common.image 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	/**
	 * 图片压缩类
	 * @author qiuhua, http://china.alibaba.com
	 */
	public class BitmapCompress
	{		
		
		/**
		 * 将一个bitmapData缩小，并返回新的BitmapData对象
		 * @param	src_data
		 * @param	nail_width
		 * @param	nail_height
		 * @return
		 */
		static public function minish( src_data:BitmapData, nail_width:int = 0, nail_height:int = 0 ):BitmapData {
			
			var blur_range:Number	= 2/3;
			
			var src:Bitmap		= new Bitmap( src_data, "never", true);
			var sw:int			= src_data.width
			var sh:int			= src_data.height
			var sf:Array		= src.filters;
			var nw:int			= nail_width;
			var nh:int			= Math.round(sh*nw/sw);
			var m:Matrix		= new Matrix();
			m.scale( nw/sw, nh/sh );
			
			
			sf.push( new BlurFilter( (sw*blur_range/nw)-1, (sh*blur_range/nh)-1, BitmapFilterQuality.HIGH) );
			src.filters	= sf;
			var temp_data:BitmapData	= new BitmapData( sw, sh );
			temp_data.draw(src);

			var nail_data:BitmapData	= new BitmapData(nw,nh);
			var temp:Bitmap	= new Bitmap( temp_data, "never", true);
			nail_data.draw(temp, m, null, null, null, true );
			temp_data.dispose();
			
			return nail_data;

		}
		
	}
	
}