package bee.chart.elements.pie
{
    import bee.chart.elements.scalerect.ScaleRect;
    import bee.chart.elements.scalerect.ScaleRectData;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieSliceDetail
    {
        //TODO: 这些应该从样式中指定，以适应不同大小的图表
        private const DETAIL_WIDTH:Number = 37;
        private const EXTRA_DIS:Number = 114;
        
        public function showDetail(viewer:GroupPieSliceView):void
        {
            var data:GroupPieSliceData = viewer.dataModel as GroupPieSliceData;
            const detailHeight:Number = viewer.chart.chartHeight;
            const detailDis:Number = data.radius + EXTRA_DIS;
            var scaleRectdata:ScaleRectData = new ScaleRectData();
            scaleRectdata.sliceDatas = data.sliceDatas;
            scaleRectdata.width = DETAIL_WIDTH;
            scaleRectdata.height = detailHeight;
            scaleRectdata.frameColor = data.color;
            var detail:ScaleRect = new ScaleRect();
            detail.enableMouseTrack = viewer.chart.chartModel.enableMouseTrack;
            detail.enableTooltip = viewer.chart.chartModel.enableTooltip;
            detail.setModel(scaleRectdata);
            detail.state = "nromal";
            
            detail.x = Math.cos(data.getPositionRadian()) * detailDis;
            detail.y = Math.sin(data.getPositionRadian()) * detailDis;
            detail.rotation = data.getPositionAngle();
            
            var lineSp:Sprite = createLineLinkDetail(data, detailDis, detailHeight);
            lineSp.rotation = data.getPositionAngle();
            
            var deatilSp:Sprite = new Sprite();
            deatilSp.name = PieSliceStates.DETAIL;
            
            deatilSp.addChild(detail);
            deatilSp.addChild(lineSp);
            viewer.content.addChild(deatilSp);
        }
        
        private function createLineLinkDetail(data:GroupPieSliceData, detailDis:Number, detailHeight:Number):Sprite
        {
            var result:Sprite = new Sprite();
            var radian:Number = data.radian / 2;
            if (radian > Math.PI / 2)
            {
                radian = Math.PI / 2;
            }
            const radius:Number = data.radius;
            var line1:Shape = new Shape();
            var moveX:Number = Math.cos(radian) * radius;
            var moveY:Number = Math.sin(radian) * radius;
            var lineToX:Number = detailDis;
            var lineToY:Number = detailHeight / 2;
            
            drawLine(line1.graphics, moveX, moveY, lineToX, lineToY);
            result.addChild(line1);
            
            var line2:Shape = new Shape();
            moveY = -moveY;
            lineToY = -lineToY;
            drawLine(line2.graphics, moveX, moveY, lineToX, lineToY);
            result.addChild(line2);
            
            return result;
        }
        
        private function drawLine(g:Graphics, moveX:Number, moveY:Number, lineToX:Number, lineToY:Number, color:uint = 0x9F9F9F, alpha:Number = 1):void
        {
            g.lineStyle(0, color, alpha);
            g.moveTo(moveX, moveY);
            g.lineTo(lineToX - 20, lineToY);
            g.lineTo(lineToX - 5, lineToY);
            
            g.lineStyle();
            g.beginFill(color, alpha);
            g.drawRect(lineToX - 10, lineToY-2.5, 5, 5);
            g.endFill();
        }
    
    }

}