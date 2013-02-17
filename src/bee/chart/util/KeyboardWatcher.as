package bee.chart.util 
{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;
	/**
    * ...
    * @author hua.qiuh
    */
    public class KeyboardWatcher
    {
        static private const WATCH_LIST:Dictionary = new Dictionary(true);
        static public function isAlreadyWatched(macro:Array):Boolean
        {
            return WATCH_LIST[macro.join(',')];
        }
        
        static public function watch(stage:Stage, macro:Array, callback:Function):KeyboardWatcher
        {
            if (!isAlreadyWatched(macro)) {
                WATCH_LIST[macro.join(',')] = true;
                return new KeyboardWatcher(new Enforcer(), stage, macro, callback);
            }
            return null;
        }
        
        private var _phraseIndex:uint = 0;
        private var _macro:Vector.<uint>;
        private var _callback:Function;
        
        public function KeyboardWatcher(enf:Enforcer, stage:Stage, macro:Array, callback:Function) 
        {
            _macro = Vector.<uint>(macro);
            _callback = callback;
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
        
        protected function success():void
        {
            if(_callback != null){
                _callback.call();
            }
            _phraseIndex = 0;
        }
        
        private function onKeyUp(e:KeyboardEvent):void 
        {
            joinKey(e.keyCode);
        }
        
        private function joinKey(keyCode:uint):void
        {
            if (keyCode === _macro[_phraseIndex]) {
                _phraseIndex ++;
                if (_phraseIndex >= _macro.length) {
                    success();
                }
            } else {
                _phraseIndex = 0;
            }
        }
        
    }

}

class Enforcer {}