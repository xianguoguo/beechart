package bee.chart.elements.legend 
{
    import bee.printers.IStatePrinterWithUpdate;
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.IStatesHost;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.elements.legend.item.LegendItem;
    import bee.chart.elements.legend.item.LegendItemData;
    import bee.chart.elements.legend.LegendView;
    import bee.chart.util.ChartUtil;
    import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.Shape;
    

	/**
    * ...
    * @author hua.qiuh
    */
    public class LegendSimplePrinter implements IStatePrinterWithUpdate
    {
        static public const PADDING:Number = 4;

        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        /**
        * 渲染状态
        * @param	host
        * @param	state
        * @param	context
        */
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            var lgnd:LegendView = host as LegendView;
            if (lgnd && lgnd.chart) {
                
                DisplayUtil.clearSprite(context);
                
                addHiddenOrigin(context);
                
                var sets:Vector.<ChartDataSet> = LegendData(lgnd.dataModel).dataSets;
                var x:uint = 0, y:uint = 0;
                var pddLeft:Number       = StyleUtil.getNumberStyle(lgnd, 'paddingLeft');
                var pddRight:Number      = StyleUtil.getNumberStyle(lgnd, 'paddingRight');
                var pddTop:Number        = StyleUtil.getNumberStyle(lgnd, 'paddingTop');
                var pddBottom:Number     = StyleUtil.getNumberStyle(lgnd, 'paddingBottom');
                var boxWidth:Number      = StyleUtil.getNumberStyle(lgnd, 'maxWidth');
                var boxHeight:Number     = StyleUtil.getNumberStyle(lgnd, 'maxHeight');
                var itemEachColumn:int   = StyleUtil.getNumberStyle(lgnd, 'itemEachColumn', 4);
				var interactive:Boolean	 = StyleUtil.getBoolStyle(lgnd, 'interactive', true);
                var dataIndex:int = -1;//数据的索引
                var arrangeindex:int = 0;//排列的索引
				
                function isReachEdge():Boolean
                {
                    return (boxWidth && x > boxWidth)
                }
                function fullItemCoumn():Boolean
				{
					return (itemEachColumn && ((arrangeindex+1) % itemEachColumn == 0));
				}
				function needGetNewLine():Boolean
				{
					return isReachEdge() || fullItemCoumn();
				}
				
                for each(var dataSet:ChartDataSet in sets) {
                    dataIndex = dataSet.index;
                    var color:uint = ChartUtil.getColor(dataSet);
                    var itemData:LegendItemData = new LegendItemData(dataSet.name, 0, color);
                    itemData.active = dataSet.visible;
                    var item:LegendItem = new LegendItem(itemData);
					context.addChild(item);
                    item.index = dataIndex;
                    item.setStyle('color', ColorUtil.int2str(color));
                    StyleUtil.inheritStyleSheet( item, 'item', lgnd );
					item.buttonMode = interactive;
					item.mouseEnabled = interactive;

                    item.updateNow();
                    item.x = Math.round(x + pddLeft);
                    item.y = Math.round(y + pddTop);
                    
                    if (lgnd.getStyle('layout') == 'vertical') {
                        y += item.height + 16;
                    } else {
                        x += item.width + 16;
                    }
                    if (needGetNewLine()) {
                        x = 0;
                        y += item.height + PADDING;
                    }
                    if (boxHeight && y > boxHeight) {
                        y = 0;
                        x += item.width;
                    }
                    
                    item.name = "item" + item.index;
					
					arrangeindex++;
                }
            }
            
        }
        
        public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            renderState(host,state,context);
        }
        
        private function addHiddenOrigin(context:DisplayObjectContainer):void
        {
            var origin:Shape = new Shape();
            var g:Graphics = origin.graphics;
            g.beginFill(0, 0);
            g.drawRect(0, 0, 1, 1);
            g.endFill();
            context.addChild(origin);
        }
        
    }

}
