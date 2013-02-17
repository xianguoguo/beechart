package cn.alibaba.common.image 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author qhwa, http://china.alibaba.com
	 */
	public class LocalImageLoader extends Loader
	{
		private var _width:Number;
		private var _height:Number;
		private var _file:FileReference;
		
		static public const CONTENT_READY:String = "content_ready";
		static public const FILE_SELECTED:String = "file_selected";
		
		public function LocalImageLoader(width:Number=0, height:Number=0) 
		{
			_width 	= width;
			_height = height;
			init();
		}
		
		/*
		*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		* Public Functions
		*/
		
		public function browse(file:FileReference = null, fileFilters:Array = null):void
		{
			if (!file) file = new FileReference();
			
			_file = file;
			_file.addEventListener(Event.SELECT, selectHandler);
			_file.browse( fileFilters );
		}
		
		public function loadFile(file:FileReference = null):void
		{
			if (!file) file = new FileReference();
			
			_file = file;
			_file.addEventListener(Event.COMPLETE, loadComplete);
			_file.load();
			
		}
		
		public function resizeTo(width:Number, height:Number):void
		{
			var scale:Number = Math.min(
				Math.min(width / contentLoaderInfo.width, height / contentLoaderInfo.height), 
				1
			);
			content.scaleX = content.scaleY = scale;
			content.x = (_width - content.width) / 2;
			content.y = (_height - content.height) / 2;
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Getters & Setters
		
		public function get file():FileReference
		{
			return _file;
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Private Functions
		
		private function init():void
		{
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, readComplete);
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Event Handler
		
		private function selectHandler(evt:Event):void
		{
			evt.target.removeEventListener(evt.type, arguments.callee );
			dispatchEvent( new Event(FILE_SELECTED) );
			loadFile( evt.target as FileReference );
		}
		
		private function loadComplete(evt:Event):void 
		{
			evt.target.removeEventListener(evt.type, arguments.callee );
			
			this.loadBytes(_file.data);
		}
		
		/**
		 * 
         * @eventType cn.alibaba.common.image.LocalImageLoader.CONTENT_READY
		 */
		[Event( name="content_ready", type="cn.alibaba.common.image.LocalImageLoader" )]
		private function readComplete(evt:Event):void
		{
			if (_width && _height) resizeTo(_width, _height);
			dispatchEvent( new Event(CONTENT_READY));
		}
		
	}

}