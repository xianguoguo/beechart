package cn.alibaba.core.mvcapp 
{
    import cn.alibaba.core.IDisposable;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author qhwa, http://china.alibaba.com
	 */
	public class CController extends Sprite implements IDisposable
	{
		
		protected var _model:IModel;
		protected var _view:CView;
		
		public function CController() 
		{
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
        
        /**
        * 设置数据模型
        * @param	value
        */
        public function setModel(value:IModel):void
        {
			_model = value;
            if (_view) {
                _view.setModel(value);
            }
        }
        
        /**
        * 设置显示功能模块
        * @param	value
        */
        public function setView(value:CView):void
        {
			_view = value;
        }
        
        /**
        * 在下一帧渲染时更新视图
        */
        public function updateView():void
        {
            if (_view) {
                _view.update();
            }
        }
        
        /**
        * 立刻更新视图
        */
        public function updateViewNow():void
        {
            if (_view) {
                _view.updateNow();
            }
        }
		
		/**
		 * 初始化应用程序
		 * @private
		 * @param	e
		 */
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initController();
		}
		
		protected function initController():void
		{
			
		}
		
		public function get model():IModel { return _model; }		
		public function set model(value:IModel):void 
		{
            setModel(value);
		}
		
		public function get view():CView { return _view; }		
		public function set view(value:CView):void 
		{
            setView(value);
		}
		
		public function dispose():void
		{
			if (_view) {
                _view.dispose();
                _view = null;
            }
            if (_model){
                _model.dispose();
                _model = null;
            }
		}
		
		
		
	}

}