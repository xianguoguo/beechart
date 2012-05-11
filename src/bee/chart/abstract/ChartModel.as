package bee.chart.abstract 
{
    import cn.alibaba.core.mvcapp.CModel;
    import cn.alibaba.core.mvcapp.IModel;
    import cn.alibaba.util.ColorUtil;
    import flash.events.Event;
    import flash.events.EventDispatcher;
	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartModel extends CModel
    {
        public var customMsg:String;
        
        private var _data:ChartData = new ChartData();
        private var _chartWidth:Number = 500;
        private var _chartHeight:Number = 300;
        private var _enableMouseTrack:Boolean   = true;
        private var _enableTooltip:Boolean      = true;
        private var _customElements:Vector.<ChartElement>;
        
        public function ChartModel() 
        {
            _data = new ChartData();
            _data.addEventListener(Event.CHANGE, onDataChange);
            
            //默认用json作为数据格式
            _customElements = new Vector.<ChartElement>();
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Public Functions
        
        override public function dispose():void
        {
            _customElements = null;
            _data.dispose();
			super.dispose();
        }
        
        /**
        * 替换数据模块
        * @param	value
        */
        internal function setData(value:ChartData):void
        {
            if (_data) {
                _data.removeEventListener(Event.CHANGE, onDataChange);
            }
            _data = value;
            value.addEventListener(Event.CHANGE, onDataChange);
            notifyChange();
        }
        
        /**
        * 获取图表数据
        */
        public function get data():ChartData { return _data; }
        
        /**
        * 添加自定义的图表元素，
        * 该元素可以一直显示在图表上
        * @param	el
        */
        public function addCustomElement(el:ChartElement):void
        {
            if (_customElements.indexOf(el) == -1) {
                el.reusable = true;
                _customElements.push(el);
                notifyChange();
            }
        }
        
        /**
        * 删除自定义的图表元素
        * @param	el
        */
        public function removeCustomElement(el:ChartElement):void
        {
            var idx:int = _customElements.indexOf(el);
            if (idx != -1) {
                el.reusable = false;
                _customElements.splice(idx, 1);
            }
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        /**
        * 图表宽度
        */
        public function get chartWidth():Number { return _chartWidth; }
        public function set chartWidth(value:Number):void 
        {
            _chartWidth = value;
            notifyChange();
        }
        
        /**
        * 图表高度
        */
        public function get chartHeight():Number { return _chartHeight; }
        public function set chartHeight(value:Number):void 
        {
            _chartHeight = value;
            notifyChange();
        }
        
        /**
        * 是否允许鼠标交互
        */
        public function get enableMouseTrack():Boolean { return _enableMouseTrack; }
        public function set enableMouseTrack(value:Boolean):void 
        {
            _enableMouseTrack = value;
        }
        
        /**
        * 是否出现tooltip提示
        */
        public function get enableTooltip():Boolean { return _enableTooltip; }
        public function set enableTooltip(value:Boolean):void 
        {
            if(_enableTooltip != value){
                _enableTooltip = value;
                notifyChange();
            }
        }
        
        public function get customElements():Vector.<ChartElement> { return _customElements; }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Event Handlers
        
        private function onDataChange(e:Event):void 
        {
            _changed = true;
            notifyChange();
        }
        
    }

}