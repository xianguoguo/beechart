/**
 * (c) Alibaba.com All Right(s) Reserved
 */
package bee.chart.test 
{
    import bee.chart.util.LineUtil;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import com.greensock.easing.*;
    import com.greensock.TweenLite;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LineAnimationTest extends Sprite
    {
        private var _dots:Vector.<Point>;
        private var _tempDots:Vector.<Point>;
        private var _progress:Number;
        private var _tag:Shape;
        
        public function LineAnimationTest() 
        {
            prepair();
            animate();
            
            stage.addEventListener(MouseEvent.CLICK, onClick);
        }
        
        private function onClick(e:MouseEvent):void 
        {
            if(e.ctrlKey){
                prepair();
            }
            animate();
        }
        
        public function get progress():Number { return _progress; }
        public function set progress(value:Number):void 
        {
            _progress = value;
            updateProgress(value);
        }
        
        private function prepair():void
        {
            _dots = new Vector.<Point>();
            for (var i:uint = 0; i < 10; i++) {
                var y:Number = (stage.stageHeight >> 1) + Math.floor(Math.random() * 100) - 50;
                _dots.push(new Point(i * 50, y));
            }
            
            _tag = new Shape();
            var grph:Graphics = _tag.graphics;
            grph.beginFill(0);
            grph.drawCircle(0, 0, 5);
            addChild(_tag);
        }
        
        private function animate():void
        {
            _progress = 0;
            TweenLite.to(this, 1, { progress: 1, ease:Elastic.easeOut } );
        }
        
        private function updateProgress(value:Number):void
        {
            var tmpDots:Vector.<Point> = new Vector.<Point>();
            var pt:Point, i:uint = 0;
            var y0:Number = stage.stageHeight >> 1;
            
            graphics.clear();
            graphics.lineStyle(0, .5);
            
            for each(var dot:Point in _dots) {
                pt = dot.clone();
                if(i> 0 && i<_dots.length-1){
                    pt.y = y0+(value-1)*100 + value*(dot.y-y0);
                }
                tmpDots.push(pt);
                i++;
                continue;
                graphics.beginFill(0xFF7300, .5);
                graphics.drawCircle(pt.x, pt.y, 5);
                graphics.endFill();
                
                graphics.beginFill(0xFF0000, .5);
                graphics.drawCircle(dot.x, dot.y, 5);
                graphics.endFill();
            }
            LineUtil.curveThrough(graphics, tmpDots);
        }
        
    }

}