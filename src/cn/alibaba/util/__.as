package cn.alibaba.util 
{
	/**
	 * 这个函数用来把字符串中的 {#name} 替换换成 name 值 
	 * @author qhwa, http://china.alibaba.com
	 */
		
	public function __(string:String, vars:Object, prefix:String = "{#", suffix:String = "}"):String 
	{
		for(var par:* in vars)
		{
			string = string.split(prefix + par + suffix).join(vars[par]);
		}
		return string;		
	}
	

}