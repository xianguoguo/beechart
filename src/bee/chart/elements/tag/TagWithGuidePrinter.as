package bee.chart.elements.tag 
{
    import cn.alibaba.util.ColorUtil;
    import cn.alibaba.util.DisplayUtil;
    import bee.chart.abstract.Chart;
    import bee.controls.label.Label;
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
    import bee.printers.IStatePrinter;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Point;
	/**
    * ...
    * @author hua.qiuh
    */
    public class TagWithGuidePrinter implements IStatePrinter
    {
        
        public function TagWithGuidePrinter() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            var tag:TagView = host as TagView;
            if (tag && tag.chart) {
                
                DisplayUtil.clearSprite(context);
                
                var chart:Chart = tag.chart;
                var model:TagModel  = tag.dataModel as TagModel;
                
                var pt:Point = chart.chartToViewXY(model.locationX, model.locationY);
                var padding:Number = 8;
                var isVertical:Boolean = tag.getStyle('direction') == 'up';
                
                var line:Shape = new Shape();
                var g:Graphics = line.graphics;
                var color:uint = ColorUtil.str2int(tag.getStyle('color'));
                g.lineStyle(2, color);
                if (isVertical) {
                    g.moveTo(pt.x, 0);
                    g.lineTo(pt.x, -chart.chartHeight-padding);
                } else {
                    g.moveTo(0, pt.y);
                    g.lineTo(chart.chartWidth+padding, pt.y);
                }
                context.addChild(line);
                
                var label:Label     = new Label(model.text);
                if (isVertical) {
                    label.x = pt.x - (label.width >> 1);
                    label.y = -chart.chartHeight - label.height-padding;
                } else {
                    label.x = chart.chartWidth+padding;
                    label.y = pt.y - (label.height >> 1);
                }
                label.setStyle('backgroundColor', tag.getStyle('color'));
                label.setStyle('color', '#FFFFFF');
                //label.y = label.height >> 1;
                context.addChild(label);
            }
        }
        
        
    }

}