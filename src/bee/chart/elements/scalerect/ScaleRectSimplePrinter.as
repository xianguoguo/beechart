package bee.chart.elements.scalerect 
{
    import bee.abstract.IStatesHost;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.scalerect.ColorRect;
    import bee.chart.elements.scalerect.ColorRectData;
    import bee.chart.elements.scalerect.ScaleRectData;
    import bee.printers.IStatePrinter;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
	
	/**
    * ...
    * @author jianping.shenjp
    */
    public class ScaleRectSimplePrinter implements IStatePrinter 
    {
        private var scaleRectData:ScaleRectData;
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            const viewer:ScaleRectView = host as ScaleRectView;
            scaleRectData = viewer.dataModel as ScaleRectData;
            const colorRectDatas:Vector.<ColorRectData> = createColorRectDatas(scaleRectData);
            const colorRects:Vector.<ColorRect>  = createColorRects(colorRectDatas);
            var container:Sprite = new Sprite();
            container.y =  - scaleRectData.height >> 1; 
            addColorRects(colorRects, container);
            
            viewer.clearColorRects();
            viewer.colorRects = colorRects;
            
            context.addChild(container);
            
            scaleRectData = null;
        }
        
        private function createColorRectDatas(saleRectData:ScaleRectData):Vector.<ColorRectData> 
        {
            var result:Vector.<ColorRectData> = new Vector.<ColorRectData>();
            const sliceDatas:Vector.<PieSliceData> = saleRectData.sliceDatas;
            const total:Number = saleRectData.total;
            const width:Number = saleRectData.width;
            const height:Number = saleRectData.height;
            const heightEach:Number = height / total;
            
            for each (var sliceData:PieSliceData in sliceDatas) 
            {
                var data:ColorRectData = ColorRectData.create(sliceData);
                data.width = width;
                data.height = heightEach * sliceData.value;
                result.push(data);
            }
            return result;
        }
        
        private function createColorRects(colorRectDatas:Vector.<ColorRectData>):Vector.<ColorRect> 
        {
            var result:Vector.<ColorRect> = new Vector.<ColorRect>();
            for each (var colorRectData:ColorRectData in colorRectDatas) 
            {
                var colorRect:ColorRect = new ColorRect();
                colorRect.setModel(colorRectData);
                result.push(colorRect);
            }
            return result;
        }
        
        private function addColorRects(colorRects:Vector.<ColorRect>, container:DisplayObjectContainer):void 
        {
            var y:Number = 0.0;
            var labelOffset:Number = 0;
            
            for each (var colorRect:ColorRect in colorRects) 
            {
                container.addChild(colorRect);
                
                colorRect.y = y;
                colorRect.setStyle('labelOffset', labelOffset.toString());
                colorRect.updateViewNow();
                
                y += colorRect.viewRectHeight;
                labelOffset = colorRect.getLabelOffsetForBelow();
            }
            
            var stackHeight:Number = scaleRectData.height;
            container.y -= (y - stackHeight) >> 1;
            
        }
        
    }

}