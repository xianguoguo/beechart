package bee.abstract 
{
    import cn.alibaba.core.mvcapp.CController;
    import cn.alibaba.core.mvcapp.CView;
    import flash.display.DisplayObjectContainer;
    import flash.text.StyleSheet;
	/**
    * view 为 CComponent类型的Control
    * @author hua.qiuh
    */
    public class CComponentController extends CController implements IStyleSheet, IStatesHost, ISmoothUpdateHost
    {
        
        public function CComponentController() 
        {
            
        }
        
        override public function setView(value:CView):void 
        {
            if (value && !(value is IStylable && value is IStatesHost)) {
                throw new Error("The view of 'CComponentControl' must be an instance of 'CComponent'");
            }
            super.setView(value);
        }
        
        public function updateViewStyleNow():void
        {
            __view.applyStyleNow();
        }
        
        /**
        * 输出状态
        * @param	state
        * @param	context
        */
        public function printState(state:String = null, context:DisplayObjectContainer = null):void
        {
            __view.printState(state, context);
        }
        
        /* INTERFACE cn.alibaba.yid.abstract.ISmoothUpdatHost */
        /**
        * 数据更新平滑变化
        * @param	state
        * @param	context
        */
        public function smoothUpdate(state:String = null, context:DisplayObjectContainer = null):void 
        {
            __view.smoothUpdate(state, context);
        }
        
        /* INTERFACE cn.alibaba.yid.abstract.IStylable */
        
        /**
        * 设置样式
        * @param	name
        * @param	value
        */
        public function setStyle(name:String, value:String):void
        {
            __view.setStyle(name, value);
        }
        
        /**
        * 设置多个样式
        * @param	styles
        */
        public function setStyles(styles:Object):void
        {
            __view.setStyles(styles);
        }
        
        /**
         * 清除所有样式
         */
        public function clearStyles():void
        {
            __view.clearStyles();
        }
        
        /**
         * 重设所有样式，使用默认样式
         */
        public function resetStyles():void
        {
            __view.resetStyles();
        }
        
        /**
        * 获取样式
        * @param	name
        * @return
        */
        public function getStyle(name:String):String
        {
            return __view.getStyle(name);
        }
        
        /**
        * 移出样式
        * @param	name
        */
        public function unsetStyle(name:String):void
        {
            __view.unsetStyle(name);
        }
        
        /**
        * 检查是否已经设置了样式
        * @param	name
        * @return
        */
        public function hasStyle(name:String):Boolean
        {
            return __view.hasStyle(name);
        }
        
        /* INTERFACE cn.alibaba.yid.abstract.IStatesHost */
        
        /**
        * 获取或设置组件的状态
        */
        public function get state():String
        {
            return __view.state;
        }
        
        public function set state(value:String):void
        {
            __view.state = value;
        }
        
        /**
        * 获取样式清单
        */
        public function get styleSheet():StyleSheet
        {
            if(!__view){
                return null;
            }
            return __view.styleSheet;
        }
        
        public function get skin():Skin
        {
            return __view.skin;
        }
        
        private function get __view():CComponent
        {
            return view as CComponent;
        }
        
    }

}