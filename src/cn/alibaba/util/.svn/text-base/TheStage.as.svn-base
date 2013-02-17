package cn.alibaba.util 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	/**
	 * 全局的stage对象，方便不是从Sprite类继承的子类也能访问stage
	 * @author hua.qiuh
	 */
	public class TheStage
	{
		/**
		 * 获取或设置全局stage对象
		 */
		static private var _stage:Stage;
		static public function set stage(value:Stage):void
		{
			if (_stage is NullStage) {
				while (_stage.numChildren) {
					value.addChild(_stage.getChildAt(0));
				}
			}
			_stage = value;
			
		}
		static public function get stage():Stage
		{
			return _stage || new NullStage();
		}
	}

}

import flash.display.Stage;
/**
 * 空舞台
 */
class NullStage extends Stage
{
	
}