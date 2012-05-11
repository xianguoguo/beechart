package bee.chart.util
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 读取css文件的方法
	 * @author jianping.shenjp
	 *
	 */
	public class StyleLoader
	{
		//读取完毕的分发事件，无论成功或失败，都分发该事件
		static public const LOADED:String="loaded";

		//css的存放路径
		private var _url:String;

		//css加载成功或失败的回调函数
		private var _callback:Function;

		private var _loader:URLLoader;

		public function StyleLoader(url:String="", callback:Function=null)
		{
			if (url)
			{
				_url=url;
			}
			if (callback != null)
			{
				_callback=callback;
			}
		}

		public function set url(value:String):void
		{
			_url=value;
		}

		public function set callback(value:Function):void
		{
			_callback=value;
		}

		public function start():void
		{
			if (!_url || _callback == null)
			{
				throw new Error("error");
			}
			//读取css文件
			_loader=new URLLoader();
			_loader.load(new URLRequest(_url));
			configureListeners(_loader);
		}

		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}

		private function removeListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}

		private function loaderCompleteHandler(event:Event):void
		{
			var cssString:String=_loader.data;
			_callback.call(null, cssString);
			removeListeners(_loader);
			_loader=null;
		}

		private function loaderIOErrorHandler(event:IOErrorEvent):void
		{
			trace("loaderIOErrorHandler...");
			_callback.call(null, "");
			removeListeners(_loader);
			_loader=null;
		}
	}
}