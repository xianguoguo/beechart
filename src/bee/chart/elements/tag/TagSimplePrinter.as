package bee.chart.elements.tag 
{
    import cn.alibaba.util.DisplayUtil;
    import bee.controls.label.Label;
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
    import bee.printers.IStatePrinter;
    import flash.geom.Point;
	/**
    * ...
    * @author hua.qiuh
    */
    public class TagSimplePrinter implements IStatePrinter
    {
        
        public function TagSimplePrinter() 
        {
            
        }
        
        /* INTERFACE cn.alibaba.yid.printers.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            var tag:TagView = host as TagView;
            if (tag && tag.chart) {
                
                DisplayUtil.clearSprite(context);
                
                var model:TagModel  = tag.dataModel as TagModel;
                var label:Label     = new Label(model.text);
                var pt:Point = tag.chart.chartViewer.chartToViewXY(model.locationX, model.locationY);
                label.x = pt.x - (label.width >> 1);
                label.y = pt.y - label.height;
                label.setStyle('backgroundColor', '#FF0000');
                //label.y = label.height >> 1;
                context.addChild(label);
            }
        }
        
    }

}