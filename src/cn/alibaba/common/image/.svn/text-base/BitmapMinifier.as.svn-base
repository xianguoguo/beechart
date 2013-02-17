package cn.alibaba.common.image
{
	import cn.alibaba.product.uploader.events.*;
	import cn.alibaba.common.image.jpeg.JPEGQualityReader;
    import cn.alibaba.common.image.jpeg.JPGEncoderIMP;
    import cn.alibaba.util.BitmapDataUtil;
    import com.voidelement.images.BMPDecoder;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.ByteArray;
	
	/**
	 * Bitmap Minifier
	 * -> decoding byteArray 
	 * -> shrink bimap into small size
	 * -> encoding shrinked bitmap into JPEG byteArray
	 * @author hua.qiuh
	 */
	public class BitmapMinifier extends EventDispatcher
	{		
		static public const DECODE:String = 'Decode';
		static public const SHRINK:String = 'Shrink';
		static public const ENCODE:String = 'Encode';
		static public const ENCODE_ASYNC:String = 'EncodeAsync';

		private var _inputBmpd:BitmapData;
		private var _outputBmpd:BitmapData;
		private var _maxWidth:int;
		private var _maxHeight:int;
		private var _input:ByteArray = new ByteArray;
		private var _output:ByteArray = new ByteArray;
		private var _tasks:Vector.<Array> = new Vector.<Array>;
		private var _srcQuality:int;

		static public var quality:int = 80;
		
		/**
		 * 
		 */
		public function BitmapMinifier() 
		{	
		}

		public function get input():ByteArray { return _input; }
		public function get inputBitmapData():BitmapData { return _inputBmpd; }
		public function set inputBitmapData(value:BitmapData):void { _inputBmpd = value.clone(); }
		public function get output():ByteArray { return _output; }
		public function get outputBitmapData():BitmapData { return _outputBmpd.clone(); }
		public function set maxWidth(value:uint):void { _maxWidth = value; }
		public function set maxHeight(value:uint):void { _maxHeight = value; }

		private function addTask(task:String, ...params):void
		{
			_tasks.push([task, params]);
		}
		
		private function nextTask():void
		{
			if(_tasks.length){
				var info:Array = _tasks.shift();
				this["do"+info[0]].apply(this, info[1]);
			}
		}

		private function dispatchThenNextTask(evtType:String):Boolean
		{
			var evt:Event = new MinifyEvent(evtType);
			dispatchEvent(evt);

			if(evt.isDefaultPrevented()){
				return false;
			} else {
				nextTask();
				return true;
			}
		}
		
		//-------------------------------------------
		//----------- DECODE ------------------------
		//-------------------------------------------

		public function decode(bytes:ByteArray):BitmapMinifier
		{
			_input.clear();
			_input.writeBytes(bytes);

			if(isBMP(bytes)){
				return decodeBMP(bytes);
			}
            
            
			if (JPEGQualityReader.isJPEG(bytes)) {
                try
                {
                    bytes.position = 0;
                    _srcQuality = JPEGQualityReader.read(bytes);
                } catch (e:Error) {
                    _srcQuality = 100;
                }
			}

			var loader:Loader = new Loader;
			listen(loader);
			loader.loadBytes(bytes);
			return this;
		}

		public function isBMP(bytes:ByteArray):Boolean
		{
			bytes.position = 0;
			var header:String = String.fromCharCode(bytes.readUnsignedByte());
			header += String.fromCharCode(bytes.readUnsignedByte());
			bytes.position = 0;
			return ['BM', 'BA', 'CI', 'IC', 'PT', 'CP'].indexOf(header) > -1;
		}
		

		private function decodeBMP(bytes:ByteArray):BitmapMinifier
		{
			var dec:BMPDecoder = new BMPDecoder();
			try {
				bytes.position = 0;
				_inputBmpd = dec.decode(bytes);
			} catch (e:Error) {
				onDecodeError();
			}
			return this;
		}
		
		private function listen(loader:Loader):void
		{
			var info:LoaderInfo = loader.contentLoaderInfo;
			info.addEventListener(Event.COMPLETE, onDecoded);
			info.addEventListener(IOErrorEvent.IO_ERROR, onDecodeError);
		}
		
		private function onDecoded(evt:Event):void
		{
			_inputBmpd = (evt.target.loader.content).bitmapData;
			if(isImageSizeAvailableInFlash(_inputBmpd)){
				dispatchThenNextTask(MinifyEvent.DECODED);
			} else {
				var e:MinifyEvent = new MinifyEvent(MinifyEvent.DECODE_ERROR);
				e.data = "Image is too large for flash";
				dispatchEvent(e);
			}
		}

		static public function isImageSizeAvailableInFlash(image:BitmapData):Boolean
		{
			var w:uint = image.width, h:uint = image.height;
			return w < 8191 && h < 8191 && w * h < 16777215;
		}
		
		
		private function onDecodeError(evt:Event=null):void
		{
			dispatchEvent(new MinifyEvent(MinifyEvent.DECODE_ERROR));
		}
		
		//-------------------------------------------
		//---------- shrink/minify ------------------
		//-------------------------------------------
		public function shrink(maxWidth:int, maxHeight:int):BitmapMinifier
		{
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			if(_inputBmpd) { 
				doShrink(); 
			} else {
				addTask(SHRINK);
			}
			return this;
		}

		protected function doShrink():void
		{
			try {
				_outputBmpd = BitmapDataUtil.verySmoothShrink(_inputBmpd, _maxWidth, _maxHeight);
				dispatchThenNextTask(MinifyEvent.SHRINKED);
			} catch (e:Error) {
				dispatchEvent(new MinifyEvent(MinifyEvent.SHRINK_ERROR));
			}
		}
		
		//-------------------------------------------
		//----------------- encode ------------------
		//-------------------------------------------
		
		public function encode(maxQuality:int=93):BitmapMinifier
		{
			var quality:int = Math.min(maxQuality, _srcQuality||100);
			if(_outputBmpd){
				doEncode(quality);
			} else {
				addTask(ENCODE, quality);
			}
			return this;
		}

		public function encodeAsync(maxQuality:int=93):BitmapMinifier
		{
			var quality:int = Math.min(maxQuality, _srcQuality||100);
			if(_outputBmpd){
				doEncodeAsync(quality);
			} else {
				addTask(ENCODE_ASYNC, quality);
			}
			return this;
		}
		
		protected function doEncode(quality:int=93):void
		{
			var bytes:ByteArray = JPGEncoderIMP.encode(_outputBmpd, quality);
			encodeComplete(bytes);
		}
		
		protected function doEncodeAsync(quality:int=93):void
		{
			initEncoder(quality).encodeAsync(_outputBmpd);
		}

		private function encodeComplete(result:ByteArray):void
		{
			writeResult(result);
			var evt:MinifyEvent = new MinifyEvent(MinifyEvent.ENCODED);
			evt.data = result;
			dispatchEvent(evt);
		}
		
		private function initEncoder(quality:int):JPGEncoderIMP
		{
			var encoder:JPGEncoderIMP = new JPGEncoderIMP(quality);
			encoder.addEventListener( "progressing", onJPEGEncodeProgress);
			encoder.addEventListener( Event.COMPLETE, onJPEGEncodeComplete);
			return encoder;
		}
		
		private function onJPEGEncodeProgress(e:ProgressEvent = null):void 
		{
			var evt:MinifyEvent = new MinifyEvent(MinifyEvent.ENCODE_PROGRESS);
			evt.data = e.bytesLoaded/e.bytesTotal;
			dispatchEvent(evt);
		}
		
		private function onJPEGEncodeComplete(e:Event = null):void 
		{
			var encoder:JPGEncoderIMP = e.target as JPGEncoderIMP;
			encoder.removeEventListener("progressing", onJPEGEncodeProgress);
			encoder.removeEventListener(Event.COMPLETE, onJPEGEncodeComplete);

			encodeComplete(encoder.ba);
		}
		
		private function gc():void
		{
			_inputBmpd.dispose();
			_outputBmpd.dispose();			
		}
		
		private function writeResult(bytes:ByteArray):void
		{
			output.clear();
			output.writeBytes(bytes, 0, bytes.length);
		}

	}
	
	
}
