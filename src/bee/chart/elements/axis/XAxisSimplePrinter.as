package bee.chart.elements.axis
{
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.DisplayUtil;
    import bee.chart.abstract.Chart;
    import bee.chart.elements.axis.AxisData;
    import bee.chart.elements.timeline.labelmaker.LabelInfo;
    import bee.chart.util.CartesianUtil;
    import bee.chart.util.StringFormater;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinterWithUpdate;
    import bee.util.StyleUtil;
    import flash.display.CapsStyle;
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
    import bee.chart.elements.axis.AxisView;
    import bee.printers.IStatePrinter;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.geom.Point;
    

    /**
     * ...
     * @author jianping.shenjp
     */
    public class XAxisSimplePrinter implements IStatePrinter, IAxisWithLabelPrinter, IStatePrinterWithUpdate
    {
        
        private var ax:AxisView;
        private var data:AxisData;
        private var sp:Sprite;
        private var grph:Graphics;
        private var _labelStyle:Object;
        protected var labelContainer:Sprite;
        private var ticksAvailable:Boolean;
        private var tickLength:Number;
        private var labelsAvailable:Boolean;
        private var _needFixForAxis:Boolean;
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            if (host is AxisView && AxisView(host).chart ) 
            {
                reset( context );
                printState( host, state, context );
            }
        }
        
        protected function printState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            ax = host as AxisView;
            data = ax.dataModel as AxisData;
            
            initObj();
            drawMainLine();
            drawTicksAndLabels();
            clean();
        }
        
        private function initObj():void 
        {
            _labelStyle = StyleUtil.inheritStyle(
                ax.styleSheet.getStyle('label'),
                ax);
        }
        
        protected function reset(context:DisplayObjectContainer):void 
        {
            resetContext( context );
        }
        
        protected function resetContext( context:DisplayObjectContainer ):void 
        {
            DisplayUtil.clearSprite(context);
            
            sp = new Sprite();
            sp.mouseEnabled = false;
            grph = sp.graphics;
            context.addChild(sp);
            
            labelContainer = new Sprite();
            labelContainer.name = 'labels';
            context.addChild(labelContainer);
        }
        
        protected function clean():void 
        {
            ax     		= null;
            data   		= null;
            sp     		= null;
            grph   		= null;
            _labelStyle = null;
        }
        
        protected function drawMainLine():void
        {
            var len:Number = data.length;
            var fat:Number = Number(ax.getStyle('lineThickness'));
            if(fat){
                var lineColor:uint = ColorUtil.str2int(ax.getStyle('lineColor'));
                grph.lineStyle(fat, lineColor, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.BEVEL);
                switch(data.direction) {
                    case AxisDirection.UP:
                        grph.lineTo( 0, -len );
                        break;
                    case AxisDirection.LEFT:
                        grph.lineTo( -len, 0 );
                        break;
                    case AxisDirection.DOWN:
                        grph.lineTo( 0, len );
                        break;
                    case AxisDirection.RIGHT:
                    default:
                        grph.lineTo( len, 0 );
                }
            }
        }
        
        private function drawTicksAndLabels():void 
        {
            var tickThickness:Number;
            tickLength      = StyleUtil.getNumberStyle(ax, 'tickLength');
            tickThickness   = StyleUtil.getNumberStyle(ax, 'tickThickness');
            ticksAvailable  = tickThickness && tickLength;
            labelsAvailable = ax.styleSheet.getStyle('label')['visibility'] !== 'hidden';
            _needFixForAxis = CartesianUtil.needFixForAxis(ax.chart, ax);
            if (ticksAvailable) 
            {
                grph.lineStyle( tickThickness, ColorUtil.str2int(ax.getStyle('tickColor')));
            }
            if (data.labelInfos)
            {
                var idx:int = 0;
                for each (var labelInfo:LabelInfo in data.labelInfos) 
                {
                    drawEachTickAndLabel(labelInfo, idx);
                    idx++;
                }
            }
            //else
            //{
                //throw new Error("XAxisSimplePrinter: data.labelInfos is null!");
            //}
        }
        
        /**
        * 画刻度和标签
        * @param	label
        * @param	idx
        * @param	labels
        */
        protected function drawEachTickAndLabel(labelInfo:LabelInfo, idx:uint):void
        {
            if (labelInfo.textVisible)
            {
                if(ticksAvailable){
                    drawTickAt(idx);
                }
                if(labelsAvailable){
                    drawLabelAt(idx);
                }
            }
        }
        
        protected function drawTickAt(idx:uint):void
        {
            var labelInfo:LabelInfo = data.labelInfos[idx];
            if (!labelInfo.textVisible)
            {
                return;
            }
            var centerX:Number = labelInfo.getLabelHorCenter();
            grph.moveTo( centerX, 0);
            grph.lineTo( centerX, tickLength);
        }
        
        protected function drawLabelAt(idx:uint, hlLabel:Boolean = false):Label
        {
            var labelInfo:LabelInfo = data.labelInfos[idx];
            var text:String;
            if (!hlLabel && labelInfo.textVisible == false)
            {
                return null;
            }
            text = labelInfo.text;
            
            var lbl:Label = new Label(text);
            lbl.setStyles(_labelStyle);
            lbl.name = 'label' + idx;
            labelContainer.addChildAt(lbl, 0);
            
            lbl.setStyles(StyleUtil.mergeStyle(
                ax.styleSheet.getStyle('label'),
                {
                    'backgroundColor.hl' : '#29A5F7',
                    'color.hl' : '#FFFFFF'
                }
            ));
            lbl.updateNow();
            var rot:Number = StyleUtil.getNumberStyle(ax, 'labelRotation');
            if (rot)
            {
                lbl.rotation = -rot;
            }
            var pos:Point = labelInfo.pos;
            lbl.x = pos.x;
            lbl.y = pos.y;

            if (_needFixForAxis || ax.getStyle('labelGap') === 'auto')
            {
                fixLabelPos(lbl, idx);
            }
            return lbl;
        }
        
        private function fixLabelPos(label:Label,idx:int):void
        {
            var chart:Chart = ax.chart;
            var chartW:Number = chart.chartWidth;
            if (idx == 0 && label.x < 0)
            {
                label.x = 0;
            }else if (idx == data.labelInfos.length - 1 && (label.x +label.contentWidth) > chartW)
            {
                label.x = chartW - label.contentWidth;
            }
        }
        
        public function highlightLabelAt(host:AxisView, index:int):void
        {
            if(labelsAvailable){
                ax = host;
                data = ax.dataModel as AxisData;
                
                var label:Label = getLabelAt(index, host) || drawLabelAt(index, true);
                highlightLabel(label);
                
                ax = null;
                data = null;
            }
        }
        
        public function clearHighlightLabel(host:AxisView):void
        {
            if(labelsAvailable){
                var data:AxisData = host.dataModel as AxisData;
                var idx:int = data.highlightValue;
                if (idx >= 0) {
                    var label:Label = getLabelAt(idx, host);
                    if(label){
                        if (!isLabelTextVisible(data,idx)) {
                            label.parent.removeChild(label);
                        } else {
                            label.state = 'normal';
                        }
                    }
                }
            }
            
        }
        
        private function isLabelTextVisible(data:AxisData, idx:int):Boolean 
        {
            var labelInfos:Vector.<LabelInfo> = data.labelInfos;
            if (idx >= 0 && idx < labelInfos.length)
            {
                return labelInfos[idx].textVisible;
            }
            return false;
        }

        public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            renderState(host, state, context);
        }

        protected function highlightLabel(lbl:Label):void
        {
            if(lbl){
                lbl.state = 'hl';
                labelContainer.addChild(lbl);
            }
        }
        
        private function getLabelAt(index:int, host:AxisView):Label
        {
            labelContainer = host.content.getChildByName('labels') as Sprite;
            if (labelContainer) {
                return labelContainer.getChildByName('label' + index) as Label;
            }
            return null;
        }
    
    }

}
