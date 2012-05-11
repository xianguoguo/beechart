package cn.alibaba.core.mvcapp 
{
    import cn.alibaba.core.IDisposable;
    import flash.display.Sprite;
    import flash.events.Event;

    /**
     * ...
     * @author qhwa, http://china.alibaba.com
     */
    public class CView extends Sprite implements IDisposable
    {
        private var _data:IModel;
        private var _needRedraw:Boolean = false;
        protected var _isOnStage:Boolean = false;//是否被添加到舞台上，只有添加到舞台上才渲染
		
        public function CView(data:IModel = null) 
        {
            this.dataModel = data;
            
            if (stage) {
                onActive();
            } else {
                addEventListener( Event.ADDED_TO_STAGE, onActive);
            }
        }
        
        /**
         * 更新视图，将会在下一次渲染的时候更新
         */
        public function update():void
        {
            needRedraw = true;
        }
        
        /**
         * 立即重绘
         */
        public function updateNow():void
        {
			if (_isOnStage)
			{
				needRedraw = false;
				redraw();
			}
        }
        
        /**
         * 垃圾回收
         */
        public function dispose():void
        {
            if (dataModel) {
                dataModel.removeEventListener(Event.CHANGE, onDataChange);
                _data = null;
            }
            needRedraw = false;
        }
        
        public function setModel(value:IModel):void
        {
            if (_data) {
                _data.removeEventListener( Event.CHANGE, onDataChange);
            }
            if (value) {
                _data = value;
                value.addEventListener( Event.CHANGE, onDataChange);
            }
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Private Functions
        
        /**
         * 当被添加到舞台时，开始执行界面初始化，此时可以访问stage属性
         */
        protected function initView():void
        {
            update();
        }
        
        /**
         * 彻底重新绘制视图
         */
        protected function redraw():void
        {
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        /**
         * 数据原型，当数据发生变化时，视图可以捕获改变事件
         */
        public function set dataModel(value:IModel):void
        {
            setModel(value);
        }
        
        public function get dataModel():IModel
        {
            return _data;
        }
        
        /**
         * 是否需要更新视图。如果为true，则视图会在下一次onEnterFrame时彻底更新
         */
        public function get needRedraw():Boolean { return _needRedraw; }
        public function set needRedraw(value:Boolean):void 
        {
            if (_needRedraw == value) return;
            _needRedraw = value;
            
            if (value) {
                addEventListener(Event.ENTER_FRAME, onRedrawPending);
            } else {
                removeEventListener(Event.ENTER_FRAME, onRedrawPending);
            }
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Event Handlers
        
        private function onDataChange(evt:Event):void
        {
            update();
            //updateNow();
        }
        
        private function onActive(e:Event=null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, onActive);
			_isOnStage = true;
            initView();
        }
        
        private function onRedrawPending(e:Event):void 
        {
            needRedraw = false;
            redraw();
        }
        
    }

}