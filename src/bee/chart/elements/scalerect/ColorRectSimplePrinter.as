package bee.chart.elements.scalerect
{
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.DisplayUtil;
    import bee.abstract.IStatesHost;
    import bee.chart.elements.scalerect.ColorRectData;
    import bee.chart.util.ChartUtil;
    import bee.controls.label.Label;
    import bee.printers.IStatePrinter;
    import bee.util.StyleUtil;
    import flash.display.DisplayObjectContainer;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Matrix;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class ColorRectSimplePrinter implements IStatePrinter
    {
        private var view:ColorRectView;
        private var data:ColorRectData;
        private var context:DisplayObjectContainer;
        private var _labelPosition:Number = 0;
        
        static public const MIN_WIDTH:Number = 10;

        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            view = host as ColorRectView;
            if (view) {
                
                data = view.dataModel as ColorRectData;
                this.context = context;
                
                DisplayUtil.clearSprite(context);
                
                drawColorRect();
                drawLabel();
                drawLine();
            }
            
            view = null;
            data = null;
            this.context = null;
        }
        
        private function drawLabel():void 
        {
            var label:Label = new Label();
            label.text = getTxt(data);
            label.x = view.rectWidth + Number(view.getStyle('lineWidth')) + Number(view.getStyle('linePadding')) * 2;
            label.y = _labelPosition = getLabelPosition(label);
            label.y -= (label.height >> 1);
            context.addChild(label);
        }
        
        private function getLabelPosition(label:Label):Number 
        {
            var offset:Number = Number(view.getStyle('labelOffset'));
            var preArrangeSpace:Number = (data.height - label.height) >> 1;
            if (offset > 0) {
                offset = Math.max(0, offset - preArrangeSpace);
            } else if (offset < 0) {
                offset = Math.min(0, offset + preArrangeSpace);
            }
            return ((view.rectHeight) >> 1) + offset;
        }

        private function drawColorRect():void
        {
            var colorShape:Shape        = new Shape();
            var color:uint;
            if (view.hasStyle('color')) {
                color = StyleUtil.getColorStyle(view);
            } else {
                color = data.color;
            }
            var width:Number = view.rectWidth;
            var height:Number = view.rectHeight;
            
            var bdColor:uint = StyleUtil.getColorStyle(view, 'borderColor', false);
            var bdFat:Number = StyleUtil.getNumberStyle(view, 'borderThickness');
            var bdAlpha:Number = StyleUtil.getNumberStyle(view, 'borderAlpha', 1);
            var g:Graphics = colorShape.graphics;
            if(bdFat){
                g.lineStyle(bdFat, bdColor, bdAlpha);
            }
            
            //TODO:根据样式决定使用纯色还是渐变色
            //g.beginFill(color);
            var bottomColor:uint = ColorUtil.adjstRGBBrightness(color, -0.15);
            var mtx:Matrix = new Matrix();
            mtx.createGradientBox(width, height, Math.PI / 2);
            g.beginGradientFill(GradientType.LINEAR, [color, bottomColor], [1, 1], [0, 255], mtx);
            g.drawRect(0, 0, width, height);
            g.endFill();
            
            context.addChild(colorShape);
        }

        private function drawLine():void
        {
            var line:Shape = new Shape();
            var length:Number = Number(view.getStyle('lineWidth'));
            var padding:Number = Number(view.getStyle('linePadding'));
            var color:uint;
            if(view.hasStyle('lineColor')){
                color = StyleUtil.getColorStyle(view, 'lineColor', false);
            } else {
                color = data.color;
            }
            var x:Number = view.rectWidth + padding;
            var y:Number = view.rectHeight >> 1;
            
            var g:Graphics = line.graphics;
            g.lineStyle(0, color);
            g.moveTo(x, y);
            g.lineTo(x + 5, y);
            g.lineTo(x + padding + length - 5, _labelPosition);
            g.lineTo(x + padding + length, _labelPosition);
            context.addChild(line);
        }

        private function getTxt(data:ColorRectData):String
        {
            var reslut:String = "";
            reslut = "<b>" + data.name + "</b>" + "\n" + ChartUtil.getPercentStr(data.percent);
            return reslut;
        }

    }

}