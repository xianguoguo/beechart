package bee.chart.elements.legend.item 
{
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.IStatesHost;
    import bee.chart.elements.legend.item.icon.LegendItemIcon;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LegendItemSimplePrinter implements IStatePrinter
    {
		static private var _instance:IStatePrinter;
		static public function get instance():IStatePrinter
		{
			if (!_instance) {
				_instance = new LegendItemSimplePrinter();
			}
			return _instance;
		}
        
        protected var _context:DisplayObjectContainer;
        protected var _host:LegendItem;
        protected var _data:LegendItemData;
        protected var _state:String;
        
        public function LegendItemSimplePrinter() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            _host       = host as LegendItem;
            _context    = context;
            _state      = state;
            
            if (_host) {
                
                DisplayUtil.clearSprite(context);
                _data = _host.dataModel as LegendItemData;
                
                drawIcon();
                drawLabel();
            }
            _host = null;
            _context = null;
            _data = null;
        }
        
        protected function drawLabel():void 
        {
            var label:Label = new Label(_data.label);
            label.setStyle('paddingRight', '0');
            StyleUtil.inheritStyleSheet( label, 'label', _host );
            label.x = 15;
            _context.addChild( label );
            label.updateNow();
            label.y = -Math.round(label.height / 2);
            setAlpha(label, _data.active, _data.blur);
        }
        
        protected function drawIcon():void 
        {
            var icon:LegendItemIcon = new LegendItemIcon(_host);
            StyleUtil.inheritStyleSheet( icon, 'icon', _host );
            icon.setStyle('color', _host.getStyle('color'));
            icon.state = _state;
            _context.addChild( icon );
            icon.updateNow();
            setAlpha(icon, _data.active, _data.blur);
        }
        
        protected function setAlpha(target:DisplayObject, active:Boolean, isBlur:Boolean):void 
        {
            const activeAlpha:Number = 0.5;
            const blurAlpha:Number = 0.3;
            
            if (!active)
            {
                target.alpha = activeAlpha;
            }else if(isBlur)
            {
                target.alpha = blurAlpha;
            }
        }
    }
}