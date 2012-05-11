package bee.printers 
{
	import bee.abstract.CComponent;
	import bee.abstract.IStatesHost;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class NullPrinter implements IStatePrinter
	{
        static private var _instance:NullPrinter;
        static public function get instance():NullPrinter
        {
            if (!_instance) {
                _instance = new NullPrinter(new Enforcer());
            }
            return _instance;
        }
        
        public function NullPrinter(enf:Enforcer)
        {
            
        }
        
		/**
		 * 渲染状态
		 * @param	host
		 * @param	state
		 * @param	context
		 * @return
		 */
		public function renderState(
			host:IStatesHost, 
			state:String, 
			context:DisplayObjectContainer
		):void {
		}
	}

}

class Enforcer { };