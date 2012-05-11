package cn.alibaba.util 
{
	import asunit.framework.TestCase;
    import flash.display.BitmapData;
	
	/**
    * ...
    * @author hua.qiuh
    */
    public class BitmapDataUtilTest extends TestCase 
    {
        [Embed(source='../../../../../../../Projects/Product/AliUploader/as-source/assets/height.jpg')]
        private var veryLargeImage:Class;
        
        public function BitmapDataUtilTest(testMethod:String = null) 
        {
            super(testMethod);
        }
        
        public function test_normal_size_is_valid():void
        {
            assertTrue(BitmapDataUtil.isImageSizeValidInFlash(2880, 2880, 'flashplayer', 9));
            assertTrue(BitmapDataUtil.isImageSizeValidInFlash(8192, 8192, 'flashplayer', 10));
        }
        
        public function test_zero_size_is_invalid():void
        {
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(0, 0));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(5, 0));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(0, 5));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(Number.NaN, 5));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(5, Number.NaN));
        }
        
        public function test_too_large_size_is_invalid_in_flash9():void
        {
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(2881, 2881, 'flashplayer', 9));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(5, 2881, 'flashplayer', 9));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(2881, 5, 'flashplayer', 9));
        }
        
        public function test_too_large_size_is_invalid_in_flash10():void
        {
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(8193, 8193, 'flashplayer', 10));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(5, 8193, 'flashplayer', 10));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(8193, 5, 'flashplayer', 10));
            assertTrue(BitmapDataUtil.isImageSizeValidInFlash(8192, 2048, 'flashplayer', 10));
            assertFalse(BitmapDataUtil.isImageSizeValidInFlash(8193, 2048, 'flashplayer', 10));
        }
        
        public function test_fast_smooth_shrink_result_in_right_size():void
        {
            var bmpd:BitmapData = new BitmapData(500, 500, false, 0xFF0000);
            var output:BitmapData = BitmapDataUtil.fastSmoothShrink(bmpd, 200, 100);
            assertEquals(100, output.width);
            assertEquals(100, output.height);
            assertEquals(0xFF0000, output.getPixel(1, 1));
            assertEquals(0xFF0000, output.getPixel(99, 99));
        }
        
        public function test_too_large_image_is_not_delt_with_in_fast_smooth_shrink():void
        {
            var bmpd:BitmapData = DisplayUtil.assets2bmpd(veryLargeImage);
            assertThrows(Error, function():void{ BitmapDataUtil.fastSmoothShrink(bmpd, 200, 100)} );
        }
        
        public function test_very_smooth_shrink_result_in_right_size():void
        {
            var bmpd:BitmapData = new BitmapData(500, 500, false, 0xFF0000);
            var output:BitmapData = BitmapDataUtil.verySmoothShrink(bmpd, 200, 100);
            assertEquals(100, output.width);
            assertEquals(100, output.height);
            
        }
        
        public function test_too_large_image_is_not_delt_with_in_very_smooth_shrink():void
        {
            var bmpd:BitmapData = DisplayUtil.assets2bmpd(veryLargeImage);
            assertThrows(Error, function():void{ BitmapDataUtil.fastSmoothShrink(bmpd, 200, 100)} );
        }
        
        public function test_large_image_shrinked_smoothly():void
        {
            var bmpd:BitmapData = new BitmapData(8000, 2000, false, 0xFF0000);
            var output:BitmapData = BitmapDataUtil.verySmoothShrink(bmpd, 200, 100);
            assertEquals(200, output.width);
            assertEquals(50, output.height);
            assertEquals(0xFF0000, output.getPixel(1, 1));
            assertEquals(0xFF0000, output.getPixel(99, 49));
            
        }
        
        public function test_very_smooth_sample_image_1():void
        {
            var bmpd:BitmapData = new BitmapData(3379, 2534, false, 0xFF0000);
            var output:BitmapData = BitmapDataUtil.verySmoothShrink(bmpd, 1024, 768);
            assertEquals(1024, output.width);
            assertEquals(768, output.height);
        }
        
    }

}