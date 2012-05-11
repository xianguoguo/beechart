package cn.alibaba.util 
{
	import cn.alibaba.core.AppSetting;
	/**
	 * 在网页环境下调试，调用Firebug等console
	 * @author hua.qiuh
	 */
	
	
	 /**
	  * 调试, trace+console.log
	  * @param	args  参数，可以用符合firebug风格的配置
	  * @example 	
	  * log("something", "is", "happenning"); //=> "something is happening"
	  * log("The %s jumped over %d tall buildings", "fox", 5); //=> "The fox jumped over 5 tall buildings"
	  */
	public function log(...args):void
	{
		trace.apply(null, args);			
		//如果允许调试
		if(AppSetting.Get("debug")){	
			try {
				//调用网页Console
				ExternalCall.externalCall("console.log", args.concat(new Date().valueOf()));
			} catch (e:Error) {				
			}			
		}
	}
	

}