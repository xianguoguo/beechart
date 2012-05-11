package bee.chart.demo 
{
    import cn.alibaba.util.DisplayUtil;
    import bee.chart.elements.axis.Axis;
    import bee.chart.elements.axis.AxisWithSmoothPrinter;
    import bee.controls.label.Label;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import com.greensock.TweenLite;
	/**
    * ...
    * @author jianping.shenjp
    */
    public class LabelAnimationTest extends Sprite
    {
        private var currentNumbers:Vector.<Number>;
        private var targetNumbers:Vector.<Number>;
        private var axis:Axis;
        
        public function LabelAnimationTest() 
        {
            init();
        }
        
        public function animateTo( newNumbers:Vector.<Number> ):void 
        {
            this.targetNumbers = newNumbers;
            var label:Label;
            var oldLabels:Vector.<Label> = getCurrentLabels();
            var incoming:Vector.<Label> = makeIncomingLabels( newNumbers );
            for each(label in oldLabels){
                fadeOut(label);
            }
            for each(label in incoming) {
                fadeIn( label );
            }
        }
        
        private function getCurrentLabels():Vector.<Label> 
        {
            var labels:Vector.<Label> = new Vector.<Label>();
            for (var i:uint = 0; i < numChildren ; i++) {
                var sp:DisplayObject = getChildAt(i);
                if (sp is Label) {
                    labels.push( sp as Label );
                }
            }
            return labels;
        }
        
        private function makeIncomingLabels(numbers:Vector.<Number>):Vector.<Label>
        {
            var labels:Vector.<Label> = new Vector.<Label>();
            for each(var number:Number in numbers) {
                var label:Label = new Label(number.toString());
                labels.push( label );
            }
            return labels;
        }
        
        private function fadeOut(label:Label):void 
        {
            TweenLite.to( label, 0.5, {
                alpha: 0,
                y: getPosition( Number(label.text), targetNumbers ),
                onComplete: function():void {
                    label.parent.removeChild( label );
                }
            });
        }
        
        private function fadeIn(label:Label):void
        {
            addChild(label);
            
            label.x = 100;
            label.y = getPosition( Number(label.text), targetNumbers );
            TweenLite.from(label, 0.5, {
                alpha: 0,
                y : getPosition( Number(label.text), currentNumbers ),
                onComplete: onFadeComplete
            });
        }
        
        private function onFadeComplete():void 
        {
            this.currentNumbers = this.targetNumbers;
        }
        
        private function getPosition(value:Number, numbers:Vector.<Number>):Number 
        {
            var min:Number = getMinValue( numbers );
            var max:Number = getMaxValue( numbers );
            return 100+(value-min)/(max-min)*200;
        }
        
        private function getMaxValue(numbers:Vector.<Number>):Number 
        {
            var max:Number = -9999999999999;
            for each( var n:Number in numbers) {
                if (n > max) {
                    max = n
                }
            }
            return max;
        }
        
        private function getMinValue(numbers:Vector.<Number>):Number 
        {
            var min:Number = 9999999999999;
            for each( var n:Number in numbers) {
                if (n < min) {
                    min = n
                }
            }
            return min;
        }
        
        private function clear():void 
        {
            DisplayUtil.clearSprite(this);
        }
        
        private function init():void 
        {
            
            //axis = new Axis();
            //axis.skin.statePrinter = new AxisWithSmoothPrinter();
            //var numbers:Vector.<Number> = makeRandomLabels();
            //var texts:Vector.<String> = new Vector.<String>();
            //for each(var n:Number in numbers) {
                //texts.push( n.toString() );
            //}
            //axis.labels = texts;
            //
            //addChild(axis);
            
            
            this.currentNumbers = makeRandomLabels();
            printLabels( currentNumbers );
            
            var t:Timer = new Timer(1000);
            t.addEventListener(TimerEvent.TIMER, onTimer);
            t.start();
        }
        
        private function printLabels(labels:Vector.<Number>):void 
        {
            clear();
            for each (var n:Number in labels) {
                addLabel(n);
            }
        }
        
        private function addLabel(n:Number):void
        {
            var label:Label = new Label(n.toString());
            label.x = 100;
            label.y = getPosition( n, currentNumbers );
            addChild(label);
        }
        
        private function makeRandomLabels():Vector.<Number> 
        {
            var numbers:Vector.<Number> = new Vector.<Number>();
            for (var i:uint = 0; i < 5; i++) {
                numbers.push( Math.floor(Math.random() * 100 ));
            }
            return numbers;
        }
        
        private function onTimer(e:TimerEvent):void 
        {
            animateTo( makeRandomLabels() )
        }
        
    }

}