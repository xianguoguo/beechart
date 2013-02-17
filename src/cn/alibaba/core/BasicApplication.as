/**
 * (c) Alibaba.com All Right Reserved
 */
package cn.alibaba.core 
{
	import cn.alibaba.util.log;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.utils.Timer;
	
	/**
	 * 基本的flash应用程序，集成了阿里巴巴中国站的一些常用功能
	 * 包含的功能：
	 * 1. flashvars 获取和默认值
	 * 2. eventHandler 用于与JS进行通信
	 * @author qhwa, http://china.alibaba.com
	 */
	
	//为啥用 MovieClip 而不是Sprite 继承?
	//答: 设计师制作的Flash动画也可以将DocumentClass设为BasicApplication
	public class BasicApplication extends MovieClip
	{
		public function BasicApplication() 
		{
			if (stage){
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		public function callFlash(fn:String, ...args):*
		{
			ex("console.log", fn);
			return this[fn].apply(this, args);
		}
		
		
		/**
		 * 初始化应用程序
		 * @private
		 * @param	e
		 */
		private function init(e:Event=null):void
		{
			if(e) e.target.removeEventListener(e.type, init);
			
			//在IE6中，无法在程序一开始就得到舞台的尺寸
			//所以延时初始化，直到获取到舞台尺寸
			
			if (!stage.stageWidth)
			{
				//RESIZE事件并不能在所有IE6浏览器中触发，所以不能用
				//stage.addEventListener(Event.RESIZE, init);
				var tmr:Timer = new Timer(100, 1);
				tmr.addEventListener(TimerEvent.TIMER, init);
				tmr.start();
				return;
			}
			
			//大部分情况下我们动态计算元素的位置，保持舞台 1:1 的比例
			stage.scaleMode 	= StageScaleMode.NO_SCALE;
			//保持舞台坐标系的原点位于窗口左上角
			stage.align 		= StageAlign.TOP_LEFT;
			
			//注意在AIR程序中，不需要调用Security.allowDomain
			if(Capabilities.playerType != 'Desktop'){
				//一般来说，我们会暴露给js一些接口调用
				//阿里巴巴的swf和html是分开域名部署的
				//所以这里允许所有域名访问as的公开接口
				Security.allowDomain( "*" );
			}
			
			//不过在用https的时候，还是应该保守点
			//如果要允许非https网站也能访问https协议下的flash程序，请在子类中设置
			//所以下面这句注释不要去掉
			/* Security.allowInsecureDomain( "*" ); */
			
			
			//设置默认的配置
			//应用程序可以通过重写这个函数，给自己的程序设置默认配置
			setDefaultSettings();
			
			AppSetting.initParams(stage.loaderInfo.parameters);
			
			//如果指定了 startDelay 参数，则延时启动应用程序
			// 这个功能可以解决在傲游、TT等基于IE的多标签浏览器中
			// Flash无法和JS进行通信的bug
			if (AppSetting.Get('startDelay')) {
				var timer:Timer = new Timer(Number(AppSetting.Get('startDelay')), 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, start);
				timer.start();
			} else {
				start();
			}
		}
		
		/**
		 * 程序启动
		 * @param	evt
		 * @eventType swfReady
		 */
		private function start(evt:TimerEvent=null):void
		{
			if (evt) {
				evt.target.removeEventListener(TimerEvent.TIMER_COMPLETE, start);
			}
			this.initApplication();
			//告诉javascript：我们准备好啦！开始吧！！
			this.dispatchEventToJavascript( { type:"swfReady" } );			
		}
		
		/*
		*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		* Public Functions
		*/
		
		/**
		 * 广播到JS事件
		 * @param	evt
		 */
		public function dispatchEventToJavascript(evt:Object):void
		{
			var jsHandler:String =  getSetting("eventHandler");
			if (jsHandler)
			{
				evt['swfid'] = getSetting("swfid");
				ex(jsHandler, evt);
			}
		}
		
		/**
		 * 获得设置数据
		 * @param	dataName	数据名称
		 * @return	数据值
		 */
		public function getSetting(dataName:String):*
		{
			return AppSetting.Get(dataName);
		}
		
		/**
		 * 设置数据
		 * @param	dataName	数据明朝
		 * @param	value	值
		 */
		public function setSetting(dataName:String, value:*):void
		{
			AppSetting.Set(dataName, value);
		}
		
		public function setDebug(b:Boolean):void
		{
			setSetting("debug", b) ;
		}
		
		public function setSWFElementSize(w:int, h:int):void
		{
			ex('function(swfid, w, h){ \
				var el = document.getElementById(swfid);\
				if (el) { \
					el.width = w; \
					el.height = h; \
				} \
			}', 
			getSetting('swfid'));
		}
		
		public function getSWFElementWidth():int {
			return Math.floor(ex('function(swfid){ var el=document.getElementById(swfid);return el?el.width:0}', getSetting('swfid')));
		}
		
		public function getSWFElementHeight():int {
			return Math.floor(ex('function(swfid){ var el=document.getElementById(swfid);return el?el.height:0}', getSetting('swfid')));
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Getters & Setters
		
		/**
		 * 取得swf文件所在的目录
		 * 例如flash的URL为: "http://img.china.alibaba.com/swfapp/test.swf"
		 * 则返回 "http://img.china.alibaba.com/swfapp/"
		 * @return 
		 */
		public function get swfPath():String
		{
			var url:String = loaderInfo.url;
			return url.substr(0, Math.max(url.lastIndexOf("/"), url.lastIndexOf("\\")) + 1);
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Private Functions		
		
		/**
		 * 设置默认的配置值
		 */
		protected function setDefaultSettings():void
		{
			
		}
		
		/**
		 * 重载这个方法，写入应用程序启动的逻辑
		 */
		protected function initApplication():void
		{
			
		}
		
		/**
		 * 封装的 ExternalInterface 方法
		 * 加入 try...catch 处理，防止在非浏览器环境中影响后续逻辑
		 * @param	...args
		 * @return
		 */
		protected function ex(...args):*
		{
			var result:*;
			try
			{
				result = ExternalInterface.call.apply(null, args);				
			} 
			catch (e:Error)	{ }
			return result;
		}
		
		/**
		 * 添加外部API
		 * 仅当Flash以插件方式运行时，才起作用
		 * 用法1:
		 *  addExternalInterface( "theApiName", theExposedFunction );
		 * 用法2，传入一个对象:
		 *  addExternalInterface( {
		 *	theApiName1: 	theApiFunction1,
		 * 	apiName2:		theApiFunction2,
		 * 	...
		 * 	anotherApi:	some_function
		 *  });
		 * @param	...args
		 */
		protected function addExternalInterface(...args):void
		{
			if (Capabilities.playerType == "StandAlone" || !ExternalInterface.available) {
				return;
			}
			if (args[0] is String) {
				trace("add callback", args);
				ExternalInterface.addCallback.apply(null, args);
			} else if (args.length == 1) {
				var obj:Object = args[0];
				for (var each:String in obj) {
					ExternalInterface.addCallback( each, obj[each] );
				}
			}
		}
		
		/**
		 * 调试
		 * @param	msg
		 */
		protected function log(...args):void
		{
			cn.alibaba.util.log.apply(null, args);
		}
	
		
	}
	
}
