package cn.alibaba.util 
{
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.system.Capabilities;
	/**
    * ...
    * @author hua.qiuh
    */
    public class BitmapDataUtil 
    {
        
        static public function isImageSizeValidInFlash(width:uint, height:uint, playerType:String=null, playerVersion:Number=0):Boolean
        {
            playerType = playerType || Capabilities.playerType;
            playerVersion = playerVersion || getCurrentPlayerVersion();
            
            var maxWidth:Number = Number.MAX_VALUE;
            var maxHeight:Number = Number.MAX_VALUE;
            var maxPixels:Number = Number.MAX_VALUE;
            
            if (/AIR/i.test(playerType)) {
                if (playerVersion > 1.1) {
                    maxWidth = maxHeight = 8192;
                } else {
                    maxWidth = maxHeight = 2880;
                    maxPixels = 16777216;
                }
            } else {
                if (playerVersion >= 10) {
                    maxWidth = maxHeight = 8192;
                } else {
                    maxWidth = maxHeight = 2880;
                    maxPixels = 16777216;
                }
            }
            return width && height && width <= maxWidth && height <= maxHeight && width * height <= maxPixels;
        }
        
        static private function getCurrentPlayerVersion():Number
        {
            return Number(/\d+,\d+/.exec(Capabilities.version)[0].replace(/,/, '.'));
        }
        
        static public function fastSmoothShrink(source:BitmapData, w:uint, h:uint):BitmapData
        {
            if (!isImageSizeValidInFlash(source.width, source.height)) {
                throw new Error('Image size too large for flash');
            }
            
            const WIDTH:uint = source.width;
            const HEIGHT:uint = source.height;
			var scale:Number 		= Math.min(1, Math.min( w / WIDTH, h / HEIGHT));
            w = WIDTH * scale;
            h = HEIGHT * scale;
			var newbmpd:BitmapData 	= new BitmapData(w, h, source.transparent, 0x00FFFFFF);
			var mtx:Matrix 			= new Matrix();
			mtx.scale(scale, scale);
			newbmpd.draw( source, mtx, null, null, null, true );
			return newbmpd;
        }
        
        static public function verySmoothShrink(source:BitmapData, w:uint, h:uint):BitmapData
        {
            if (!isImageSizeValidInFlash(source.width, source.height)) {
                throw new Error('Image size too large for flash');
            }
            
            const WIDTH:uint = source.width;
            const HEIGHT:uint = source.height;
            const TRANSPARENT:Boolean = source.transparent;
            const BG_COLOR:uint = 0x00FFFFFF;
            const IDEAL_RESIZE_PERCENT:Number = .5;
            
			var output:BitmapData;
			var scale:Number = Math.min(1, Math.min( w / WIDTH, h / HEIGHT));
			
			// scale it by the IDEAL for best quality
			var nextScale:Number = scale;
			while (nextScale < 1) {
                nextScale /= IDEAL_RESIZE_PERCENT;
            }
			if (scale < IDEAL_RESIZE_PERCENT) {
                nextScale *= IDEAL_RESIZE_PERCENT;
            }
			
            var nextWidth:Number = Math.round(WIDTH * nextScale);
            var nextHeight:Number = Math.round(HEIGHT * nextScale);
            if (isImageSizeValidInFlash(nextWidth, nextHeight)) {
                output = new BitmapData(nextWidth, nextHeight, TRANSPARENT, BG_COLOR);
                output.draw(source, new Matrix(nextScale, 0, 0, nextScale, 0, 0), null, null, null, true);
            } else {
                nextScale *= IDEAL_RESIZE_PERCENT;
                nextWidth *= IDEAL_RESIZE_PERCENT;
                nextHeight *= IDEAL_RESIZE_PERCENT;
                output = new BitmapData(nextWidth, nextHeight, TRANSPARENT, BG_COLOR);
                output.draw(source, new Matrix(nextScale, 0, 0, nextScale, 0, 0), null, null, null, true);
            }
            nextScale *= IDEAL_RESIZE_PERCENT;
			
			while (nextScale >= scale) {
                nextWidth = Math.round(output.width * IDEAL_RESIZE_PERCENT);
                nextHeight = Math.round(output.height * IDEAL_RESIZE_PERCENT);
				var temp:BitmapData = new BitmapData(nextWidth, nextHeight, TRANSPARENT, BG_COLOR);
				temp.draw(output, new Matrix(IDEAL_RESIZE_PERCENT, 0, 0, IDEAL_RESIZE_PERCENT), null, null, null, true);
                output.dispose();
				nextScale *= IDEAL_RESIZE_PERCENT;
				output = temp;
			}
			
			return output;
        }
        
    }

}