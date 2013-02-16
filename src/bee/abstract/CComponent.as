package bee.abstract
{
    import cn.alibaba.core.IDisposable;
    import cn.alibaba.core.mvcapp.CView;
    import cn.alibaba.core.mvcapp.IModel;
    import cn.alibaba.util.DisplayUtil;
    import bee.util.StyleUtil;
    import bee.util.YIDStyleSheet;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import flash.utils.Dictionary;
    
    /**
     * YID 组件原型基类
     * YID 是以样式控制的AS3组件
     * @author hua.qiuh
     */
    public class CComponent extends CView implements IStyleSheet, IStatesHost
    {
        private var _style:Dictionary = new Dictionary(true);
        private var _skin:Skin;
        private var _state:String;
        private var _enabled:Boolean = true;
        private var _content:Sprite = new Sprite();
        private var _styleSheet:StyleSheet = new YIDStyleSheet();

        public function CComponent(data:IModel=null) 
        {
            _skin = new Skin(this);
            addChild(_content);
            setDefaultStyles();
            
            super(data);
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Public Functions
        
        /**
         * 设置单种样式
         * @param	name
         * @param	value
         */
        public function setStyle( name:String, value:String ):void
        {
            if(name){
                _style[name.toLowerCase()] = value;
                needRedraw = true;
            }
        }
        
        /**
         * 获取样式
         * @param	name 样式名称，
         * 如果该样式在不同状态有不同的取值，则返回当前状态的取值；
         * 如果样式名称中带有. 则取指定的状态的取值
         * @return 样式取值
         */
        public function getStyle( name:String ):String
        {
            if (!name || !_style) return null;
            name = name.toLowerCase();
            if (!/.\../.test(name)) {
                return _style[name + '.' + state] || _style[name];
            } else {
                return _style[name];
            }
        }
        
        /**
         * 设置多种样式
         * @param	styles
         */
        public function setStyles( styles:Object ):void
        {
            for (var each:String in styles) {
                setStyle( each, styles[each] );
            }
        }
        
        /**
         * 清除所有样式
         */
        public function clearStyles():void
        {
            _style = new Dictionary(true);
        }
        
        /**
         * 重设样式为默认样式
         */
        public function resetStyles():void
        {
            clearStyles();
            setStyles( defaultStyles );
        }
        
        /**
         * 去除样式
         * @param	name
         * @param clearInAllStates
         */
        public function unsetStyle( name:String ):void
        {
            if (name) {
                delete _style[name.toLowerCase()];
                needRedraw = true;
            }
        }
        
        /**
         * 清除所有状态的相关样式
         * @param	name
         */
        public function unsetStyleInAllStates( name:String ):void
        {
            if (name) {
                name = name.toLowerCase();
                for (var each:String in _style) {
                    if(new RegExp(name+'(\\..+)?').test(each)){
                        delete _style[each];
                    }
                }
                needRedraw = true;
            }
        }
        
        /**
         * 检查组件是否设置了某项样式
         * @param	name 样式名称
         * @return
         */
        public function hasStyle( name:String):Boolean 
        {
            if(name && _style){
                name = name.toLowerCase();
               if ( _style[name] == null) 
               {
                    if (name.indexOf('.') != -1) {
                        return false;
                    } else {
                        return _style[name + '.' + _state] != null;
                    }
                }
                return true; 
            }
            return false;
        }
        
        /**
         * 输出状态
         * @param	state
         * @param	context
         */
        public function printState(state:String=null, context:DisplayObjectContainer=null):void
        {
            if (!state) state = _state;
            if (!context) context = content;
            if (!_skin)
            {
                return;
            }
            _skin.renderState(this, state, context);
        }
        
        /* INTERFACE cn.alibaba.yid.abstract.ISmoothUpdateHost */
        /**
        * 数据更新平滑变化
        * @param	state
        * @param	context
        */
        public function smoothUpdate(state:String = null, context:DisplayObjectContainer = null):void 
        {
            needRedraw = false;
            _skin.smoohUpdate(this, state, context || content);
        }
        /**
         * 回收
         */
        override public function dispose():void
        {
            _style = null;
            if (_skin)
            {
                _skin.dispose();
            }
            _skin = null;
            if (_styleSheet)
            {
                _styleSheet.clear();
            }
            _styleSheet = null;
            DisplayUtil.clearSprite(content);
            DisplayUtil.clearSprite(this);
            super.dispose();
        }
        
        /**
         * 清除内容
         */
        public function clearContent():void
        {
            content.graphics.clear();
            content.filters = [];
            var dis:DisplayObject;
            while (content.numChildren) {
                dis = content.getChildAt(0);
                if (dis is IDisposable)
                {
                    IDisposable(dis).dispose();
                }
                dis = null;
                content.removeChildAt(0);
            }
        }
        
        /**
         * 添加内容
         * @param	content
         * @param	align
         */
        public function addContent(content:DisplayObject, align:String=null):void
        {
            if (content.parent == this.content) {
                this.content.removeChild(content);
            }
            switch (align) {
                case 'left':
                    //TODO:get bounds
                    break;
                case 'right':
                    content.x = this.content.width;
                    break;
                default:
            }
            this.content.addChild(content);
        }
        
        public function applyStyleNow():void
        {
            redrawDirectly();
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        /**
         * 组件的状态
         */
        public function get state():String { return _state; }	
        public function set state(value:String):void 
        {
            if (!value) return;
            if (value != _state && _skin) {
                var from:String = _state;
                _state = value;
                needRedraw = false;
                _skin.performStateChange(this, from, value);
                dispatchEvent( new Event(Event.CHANGE) );
            }
        }
        
        /**
         * 获取或设置是否可用
         */
        public function get enabled():Boolean { return _enabled; }		
        public function set enabled(value:Boolean):void 
        {
            if(_enabled != value){
                _enabled = value;
                mouseEnabled = value;
                redraw();
                //tell others
                var evt:Event = new Event( value ? Event.ACTIVATE : Event.DEACTIVATE );
                dispatchEvent(evt);
            }
        }
        
        /**
         * 默认样式
         */
        protected function get defaultStyles():Object
        {
            return { };
        }
        
        /** 放置组件内容的容器 **/
        public function get content():Sprite { return _content; }
        
        /** 皮肤模块 **/
        public function get skin():Skin { return _skin; }
        
        /** 子元素的样式 **/
        public function get styleSheet():StyleSheet { return _styleSheet; }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Private Functions
        
        /**
         * 重新绘制，包括处理样式
         */
        override protected function redraw():void 
        {
            if ( shouldSmoothUpdate() ) 
            {
                smoothUpdate( state );
            } else 
            {
                redrawDirectly();
            }
        }
        
        protected function redrawDirectly():void
        {
            needRedraw = false;
            if (_skin) 
            {
                _skin.renderState(this, state, content);
            }
            super.redraw();
        }
        
        protected function shouldSmoothUpdate():Boolean
        {
            return StyleUtil.getBoolStyle(this, 'smooth', false);
        }
        
        private function setDefaultStyles():void
        {
            setStyles( defaultStyles );
        }
    }

}