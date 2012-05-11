/**
 * (c) Alibaba.com All Right(s) Reserved
 */
package cn.alibaba.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	/**
	 * 本地图片加载器
           * 利用Flash10的本地文件读取功能，选择本地硬盘上的图片，读取其中的bitmapData
	 * @author hua.qiuh
	 */
	public class LocalImageLoader extends EventDispatcher
	{
		private var _fr:FileReference;
		private var _bmpd:BitmapData;
		
		public function LocalImageLoader() 
		{
			init();
		}
		
		public function load():void
		{
			_fr.browse( [new FileFilter('Images', '*.jpg; *.jpeg; *.gif; *.png;')] );
		}
		
		public function get bitmapData():BitmapData
		{
			return _bmpd.clone();
		}
		
		private function init():void
		{
			_fr = new FileReference();
			_fr.addEventListener(Event.COMPLETE, onFileLoaded);
			_fr.addEventListener(Event.SELECT, onFileSelect);
		}
		
		private function onFileSelect(e:Event):void 
		{
			_fr.load();
		}
		
		private function onFileLoaded(e:Event):void 
		{
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageRead);
			ldr.loadBytes( _fr.data );
		}
		
		private function onImageRead(e:Event):void 
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onImageRead);
			_bmpd = Bitmap(loaderInfo.loader.content).bitmapData.clone();
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		
	}

}