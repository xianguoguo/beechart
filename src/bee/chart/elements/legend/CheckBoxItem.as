package bee.chart.elements.legend
{
    import assets.Check;
    import assets.CheckBox;
    import cn.alibaba.core.IDisposable;
    import cn.alibaba.util.ColorUtil;
    import flash.display.CapsStyle;
    import flash.display.DisplayObject;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class CheckBoxItem extends Sprite implements IDisposable
    {
        private var _color:uint = 0;
        private var _isChecked:Boolean = false;
        private const W:Number = 13.65;
        private const H:Number = 14.25;

        public function CheckBoxItem(color:uint=0, checked:Boolean=false)
        {
            _color = color;
            _isChecked = checked;
            draw();
        }

        public function setColorAndChecked(color:uint, checked:Boolean):void
        {
            if ((_color != color) || (_isChecked != checked))
            {
                _color = color;
                _isChecked = checked;
                clearAndDraw();
            }
        }

        public function dispose():void 
        {
            var disObj:DisplayObject;
            while (this.numChildren)
            {
                disObj = getChildAt(0);
                disObj.filters = [];
                removeChild(disObj);
                disObj = null;
            }
        }
        
        private function clearAndDraw():void
        {
            dispose();
            draw();
        }

        private function draw():void
        {
            if (_isChecked)
            {
                var sp:Shape = new Shape();
                var g:Graphics = sp.graphics;
                drawColorLayer(g);
                drawBorder(g);
                drawHighlight(g);
                drawShadow(g);
                addChild(sp);
                drawTick();
            }
            else
            {
                addChild(new CheckBox());
            }
        }
        
        private function drawColorLayer(g:Graphics):void
        {
            setGraphicsForGradient(g, _color, W, H);
            g.drawRect(1, 1, W - 1, H - 1);
            g.endFill();
        }
        
        private function drawBorder(g:Graphics):void
        {
            g.lineStyle(1, _color, 1, true, 'normal', CapsStyle.SQUARE, JointStyle.MITER);
            g.drawRect(0.5, 0.5, W-1, H-1);
        }
        
        private function drawHighlight(g:Graphics):void
        {
            g.lineStyle(1, 0xFFFFFF, 0.3, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
            g.moveTo(1.5, 1.5);
            g.lineTo(W-1.5, 1.5);
        }
        
        private function drawShadow(g:Graphics):void
        {
            g.lineStyle(1, 0xE1E1E1, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
            g.moveTo(0.5, H + .5);
            g.lineTo(W - 0.5, H + .5);
        }
        
        private function drawTick():void
        {
            var check:Check = new Check();
            var glowFilter:GlowFilter = new GlowFilter(_color, 1, 2, 2, 2, 1);
            check.filters = [glowFilter];
            check.x = 3;
            addChild(check);
        }

        private function setGraphicsForGradient(g:Graphics, color:uint, w:Number, h:Number):void
        {
            var fillType:String = GradientType.LINEAR;
            var colors:Array = [color, ColorUtil.adjstRGBBrightness(color, 0.2)];
            var alphas:Array = [0.7, 0.7];
            var ratios:Array = [0x00, 0xFF];
            var matr:Matrix = new Matrix();
            matr.createGradientBox(w, h, -Math.PI / 2, 0, 0);
            g.beginGradientFill(fillType, colors, alphas, ratios, matr);
        }
    }
}