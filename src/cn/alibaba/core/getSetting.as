package cn.alibaba.core 
{
	/**
    * ...
    * @author hua.qiuh
    */
    public function getSetting(name:String):*
    {
        return AppSetting.Get(name);
    }

}