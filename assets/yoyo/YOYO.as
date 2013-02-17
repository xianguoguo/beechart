//Created by Action Script Viewer - http://www.buraks.com/asv
package
{
    import assets.YOYOGif;
    import com.greensock.easing.Back;
    import com.greensock.TweenLite;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.setTimeout;
    
    public class YOYO extends Sprite
    {
        
        private var _bubblizater:Bubblizater;
        
        public function YOYO()
        {
            super();
            if (stage)
            {
                this.init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.init);
            }
        }
        
        public static function toggleFromStage(stage:Stage):void
        {
            var child:DisplayObject;
            var alreadyHasYOYO:Boolean;
            var i:uint;
            while (i < stage.numChildren)
            {
                child = stage.getChildAt(i);
                if ((child is YOYO))
                {
                    stage.removeChild(child);
                    alreadyHasYOYO = true;
                }
                i++;
            }
            if (!(alreadyHasYOYO))
            {
                stage.addChild(new (YOYO)());
            }
        }
        
        private function init(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            var bmpd:BitmapData = new YOYOGif(99, 113);
            this._bubblizater = new Bubblizater();
            this._bubblizater.bubblizeBitmap(bmpd, 5, 150, 150);
            addChild(this._bubblizater);
            x = ((stage.stageWidth - width) >> 1);
            y = ((stage.stageHeight - height) >> 1);
            this.tweenInBubbles();
            bmpd.dispose();
            setTimeout(this.tweenOutBubbles, 5000);
            setTimeout(this.dispose, 10000);
        }
        
        private function tweenInBubbles():void
        {
            var bb:DisplayObject;
            var bbls:Vector.<DisplayObject> = this._bubblizater.getBubbles();
            for each (bb in bbls)
            {
                TweenLite.from(bb, 2, {alpha: 0, scaleX: 0, scaleY: 0, delay: (Math.random() * 2), x: (Math.random() * 200), y: (Math.random() * 200), ease: Back.easeOut});
            }
        }
        
        private function tweenOutBubbles():void
        {
            var bb:DisplayObject;
            var bbls:Vector.<DisplayObject> = this._bubblizater.getBubbles();
            for each (bb in bbls)
            {
                TweenLite.to(bb, 2, {alpha: 0, scaleX: 0, scaleY: 0, delay: (Math.random() * 2), x: (Math.random() * 200), y: (Math.random() * 200), ease: Back.easeIn});
            }
        }
        
        private function dispose():void
        {
            if (parent)
            {
                parent.removeChild(this);
            }
        }
    
    }
} //package 
