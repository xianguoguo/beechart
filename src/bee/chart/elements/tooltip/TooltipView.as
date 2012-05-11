package bee.chart.elements.tooltip 
{
    import bee.chart.abstract.ChartElementView;
    import bee.performers.IPerformer;
    import bee.printers.IStatePrinter;
    import com.greensock.easing.Back;
    import com.greensock.TweenLite;
    import flash.geom.Point;
	/**
    * ...
    * @author hua.qiuh
    */
    public class TooltipView extends ChartElementView
    {
        
        static public var defaultStatePrinter:IStatePrinter = new TooltipSimplePrinter;
        static public var defaultPerformer:IPerformer = new TooltipTransitionPerformer;
        
        public function TooltipView(host:Tooltip) 
        {
            super(host);
        }
        
        override protected function initView():void 
        {
            super.initView();
            
            skin.statePrinter = defaultStatePrinter;
            skin.performer = defaultPerformer;
        }
        
        /**
        * 由当前图表和位置获取应显示的文字
        */
        public function getTipText():String
        {
            if (!chart) return "";
            var data:TooltipData = dataModel as TooltipData;
            return data.getTipText(chart);
        }
        
        public function goto(x:Number, y:Number):void
        {
            //计算位置之前先更新一下视图
            //以使得位置一定位于可视范围内
            if (needRedraw) {
                updateNow();
            }
            
            var data:TooltipData = dataModel as TooltipData;
            var pt:Point = data.getFixedPosition(x, y, width, height, 20, 20, 20, 20);
            TweenLite.to(this, .5, { 
                x       : pt.x,
                y       : pt.y,
                ease    : Back.easeOut
            } );
        }
        
        override protected function get defaultStyles():Object { 
            return {
                'backgroundColor'   : '#FFFFFF',
                'backgroundAlpha'   : '.8',
                'borderColor'       : '#666666',
                'borderAlpha'       : '1',
                'borderThickness'   : '2',
                'padding'           : '8',
                'fontFamily'        : '微软雅黑',
                'maxchar'           : '10'
            };
        }
        
    }

}