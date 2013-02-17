package bee.button
{
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	
	
	public class FileSkinnedButton extends Button
	{
		private var _url:String;
		private var _stateCount:uint;
		private var _withScale9:Boolean;

		public function FileSkinnedButton(url:String, stateCount:uint = 4, withScale9:Boolean=false)
		{
			this._stateCount = stateCount;
			this._withScale9 = withScale9;

			if(url){
				load(url);
			}
		}

		public function load(url:String):void
		{
			this._url = url;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);

			loader.load(new URLRequest(url), new LoaderContext(true));
		}

		private function onLoaded(evt:Event):void
		{
			evt.target.removeEventListener(evt.type, onLoaded);
			var loader:Loader = evt.target.loader as Loader;
			setBackground((loader.content as Bitmap).bitmapData, _stateCount, _withScale9)
		}
		
		
	}


}
