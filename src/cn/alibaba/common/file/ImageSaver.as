package cn.alibaba.common.file 
{
    import cn.alibaba.common.image.jpeg.JPGEncoderIMP;
    import com.adobe.images.PNGEncoder;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
	
	/**
	 * 将图片保存成本地文件
	 * @author hua.qiuh
	 */
	public class ImageSaver extends EventDispatcher
	{
		static public const TYPE_JPEG:String = 'jpeg';
		static public const TYPE_PNG:String = 'png';
		//private var _fr:FileReference = new FileReference();
		private var _image:BitmapData;
		private var _bytes:ByteArray;
		private var _fileName:String;
		private var _fileType:String;
		private var _quality:uint;
		
		public function ImageSaver(fileName:String, fileType:String='jpeg', saveQuality:uint=90) 
		{
			_fileName = fileName;
			_fileType = fileType;
			_quality = saveQuality;
		}
		
		/**
		 * 开始保存
		 */
		public function save():void
		{
			if (!_bytes) {
				throw new Error("Not prepaired yet, please set image data before saving it");
			}
			
			var fr:FileReference = new FileReference();
			fr.addEventListener(Event.COMPLETE, onSaved);
			fr.addEventListener(IOErrorEvent.IO_ERROR, onSaveFail);
			fr.save(_bytes, _fileName);
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			if (_image) {
				_image.dispose();
			}
			_image = null;
			_bytes = null;
		}
		
		/**
		 * 设置图片数据
		 */
		public function get image():BitmapData { return _image.clone(); }		
		public function set image(value:BitmapData):void 
		{
			_image = value.clone();
            if (_fileType === TYPE_PNG) {
                _bytes = PNGEncoder.encode(_image);
            } else {
                _bytes = JPGEncoderIMP.encode(_image, _quality);
            }
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Event Handlers
		
		private function onSaveFail(e:IOErrorEvent):void 
		{
			e.target.removeEventListener(e.type, arguments.callee);
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		private function onSaved(e:Event):void 
		{
			e.target.removeEventListener(e.type, arguments.callee);
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}

}