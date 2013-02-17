package bee.chart.elements.ctxmenu 
{
    import cn.alibaba.common.file.ImageSaver;
    import bee.chart.abstract.Chart;
	import bee.util.StyleUtil;
    import bee.chart.VERSION;
    import flash.display.BitmapData;
    import flash.display.Stage;
    import flash.events.ContextMenuEvent;
    import flash.events.KeyboardEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
	/**
    * ...
    * @author hua.qiuh
    */
    public class DefaultChartCtxMenu implements IChartCtxMenu 
    {
        
        private var _chart:Chart;
        private var _ctrlKeyIsDown:Boolean = false;
        private var _altKeyIsDown:Boolean = false;
        private var _shiftKeyIsDown:Boolean = false;
        
        public function DefaultChartCtxMenu() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.chart.elements.ctxmenu.IChartCtxtMenu */
        
        public function initChartCtxMenu(chart:Chart):void
        {
            _chart = chart;
            
            var menu:ContextMenu = new ContextMenu();
            menu.hideBuiltInItems();
            
            var save:ContextMenuItem = new ContextMenuItem("保存为图片...", true);
            save.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSave);
            menu.customItems.push(save);
            
            var about:ContextMenuItem = new ContextMenuItem("BEE-Chart "+ VERSION, true);
            about.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onAbout);
            menu.customItems.push(about);
            
            chart.stage.showDefaultContextMenu = false;
            chart.contextMenu = menu;
            
            var stage:Stage = _chart.stage;
            if (stage)
            {
                stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            }
        }
        
        public function dispose():void
        {
            if (_chart)
            {
                var stage:Stage = _chart.stage;
                if (stage)
                {
                    stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                    stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
                }
                _chart = null;
            }
        }
        
        private function onSave(e:ContextMenuEvent):void 
        {
            var stage:Stage = _chart.stage;
            var w:uint = _chart.width;
            var h:uint = _chart.height;
            if (w && h) {
                
                const PADDING:uint = 8;
            
                var saver:ImageSaver = new ImageSaver("chart.png", "png");
                var bgColor:uint = StyleUtil.getColorStyle(_chart, 'backgroundColor');
                var bmpd:BitmapData = new BitmapData(w+PADDING*2, h+PADDING*2, false, bgColor);
                var mtx:Matrix = new Matrix();
                var bounds:Rectangle = _chart.getBounds(_chart);
                mtx.tx = -bounds.left + PADDING;
                mtx.ty = -bounds.top + PADDING;
                bmpd.draw(_chart, mtx);
                saver.image = bmpd;
                saver.save();
            }
        }
        
        private function onAbout(e:ContextMenuEvent):void 
        {
            if(_ctrlKeyIsDown) {
                YOYO.toggleFromStage(_chart.stage);
            }
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Event Handlers
        
        private function onKeyUp(e:KeyboardEvent):void 
        {
            _altKeyIsDown = e.altKey;
            _ctrlKeyIsDown = e.ctrlKey;
            _shiftKeyIsDown = e.shiftKey;
        }
        
        private function onKeyDown(e:KeyboardEvent):void 
        {
            _altKeyIsDown = e.altKey;
            _ctrlKeyIsDown = e.ctrlKey;
            _shiftKeyIsDown = e.shiftKey;
        }
        
    }

}