package cn.alibaba.core 
{
	/**
	 * ...
	 * @author qhwa, http://china.alibaba.com
	 */
	public class AppSetting
	{
		static private var _data:Object = {
			eventHandler : "FD.widget.flash.eventHandler",
			debug: false
		};
		
		/**
		 * 
		 * @param	name
		 * @return
		 */
		static public function Get(name:String):*
		{
			return _data[name];
		}
		
		/**
		 * 
		 * @param	name
		 * @param	value
		 */
		static public function Set(name:String, value:*):void
		{
			_data[name] = value;
		}
		
		
		
		/**
		 * 初始化flashvars数据
		 * @param	vars	flashvars对象
		 */
		static public function initParams(vars:Object):void
		{
			
			for(var every:String in vars)
			{
				parseParam(vars, every);
			}
		}
		
		/**
		 * 解析一个flashvars变量
		 * @param	stageParams	flashvars对象
		 * @param	name 变量名
		 */
		static public function parseParam(stageParams:Object, name:String ):void
		{
			
			var type:String = typeof(AppSetting.Get(name));
			var value:String = stageParams[name];
		
			if ( stageParams[name] == null ) return;
			switch(type.toLowerCase())
			{
				case "number":
					var num:Number = Number(value);
					if (!isNaN(num)) AppSetting.Set(name, num);
					break;
				case "string":
					var str:String = value;
					if (str != "") AppSetting.Set(name, str);
					break;
				case "boolean":
					var boolStr:String = value;
					AppSetting.Set(name, boolStr.toLowerCase() == "true" || boolStr == "1");
					break;
				default:
					AppSetting.Set(name, stageParams[name]);			
				
			}
			trace('got param', name, value, type, '=>', AppSetting.Get(name));
		}
	}

}