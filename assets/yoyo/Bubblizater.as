//Created by Action Script Viewer - http://www.buraks.com/asv
package
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
    
    public class Bubblizater extends Sprite
    {
        
        private static const BLUR_FILTER:BlurFilter = new BlurFilter();
        
        private const _bubbles:Vector.<DisplayObject> = new Vector.<DisplayObject>();
        
        public function Bubblizater()
        {
            super();
        }
        
        public function bubblizeBitmap(bmpd:BitmapData, bubbleSize:uint = 10, newWidth:Number = 0, newHeight:Number = 0, blurAmount:Number = 2):void
        {
            var j:uint;
            var color:uint;
            var samplingRate:Number;
            var bbl:Bubble;
            if (!(newWidth))
            {
                newWidth = bmpd.width;
            }
            if (!(newHeight))
            {
                newHeight = bmpd.height;
            }
            bmpd = bmpd.clone();
            if (blurAmount)
            {
                BLUR_FILTER.blurX = blurAmount;
                BLUR_FILTER.blurY = blurAmount;
                bmpd.applyFilter(bmpd, bmpd.rect, new Point(), BLUR_FILTER);
            }
            this._bubbles.length = 0;
            var w:uint = bmpd.width;
            var h:uint = bmpd.height;
            var i:uint;
            var colors:Vector.<uint> = bmpd.getVector(bmpd.rect);
            samplingRate = Math.ceil(((w / newWidth) * bubbleSize));
            var step:Number = (bubbleSize / samplingRate);
            while (i < w)
            {
                j = 0;
                while (j < h)
                {
                    color = colors[((j * w) + i)];
                    if (color == 0xFFFFFF)
                    {
                        j++;
                    }
                    else
                    {
                        bbl = new Bubble(color, bubbleSize);
                        bbl.x = (i * step);
                        bbl.y = (j * step);
                        this._bubbles.push(bbl);
                        addChild(bbl);
                        j = (j + samplingRate);
                    }
                }
                i = (i + samplingRate);
            }
        }
        
        public function getBubbles():Vector.<DisplayObject>
        {
            return (this._bubbles);
        }
    
    }
} //package 
import flash.display.Shape;

class Bubble extends Shape
{
    
    public function Bubble(color:uint = 0, dotSize:Number = 4)
    {
        super();
        graphics.clear();
        graphics.beginFill(color);
        graphics.drawCircle(0, 0, (dotSize / 2));
        graphics.endFill();
    }
}
