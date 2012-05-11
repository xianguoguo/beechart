package bee.performers
{
	import bee.abstract.CComponent;
	import bee.abstract.IStatesHost;
	import bee.button.ButtonStates;
    import com.greensock.easing.Sine;
    import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * 带有渐变效果的按钮状态切换
	 * @author hua.qiuh
	 */
	public class TransitionPerformer implements IPerformer
	{
		private var _tween:TweenLite;
		private var _duration:Number = 1;
		private var _progress:Number = 0;
		private var _updater:ITransitionProgressUpdater;
		private var _easing:Function = Sine.easeOut;
		
		protected var _host:CComponent;
		protected var _fromView:DisplayObject;
		protected var _toView:DisplayObject;
		
		public function TransitionPerformer(updater:ITransitionProgressUpdater=null) 
		{
			if (!updater) {
				updater = new FadeTransitionProgressUpdater();
			}
			this.updater = updater;
		}
		
		/**
		 * 状态变化开始
		 * @param	fromState 	起始状态
		 * @param	toState	目标状态
		 */
		public function performTransition(host:IStatesHost, fromState:String, toState:String):void 
		{
			var comp:CComponent = host as CComponent;
			clearTween();
            
			if ( shouldAnimate(comp, fromState, toState) ) {
				
				prepairForAnimation(comp, fromState, toState);
                
				var ease:Object = { 
					progress: 1,
					ease: easing,
					onComplete: completeHandler
				};
                
				_tween = TweenLite.to(this, Number(comp.getStyle("transDuration")) || _duration, ease);
				
			} else {
                host.printState(toState);
			}
		}
		
		/**
		 * 状态变化视觉上的进度 (0-1)
		 */
		public function get progress():Number { return _progress; }		
		public function set progress(value:Number):void 
		{
			_progress = value;
			updater.updateProgress(value, _host, _fromView, _toView);
		}
		
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void 
		{
			_duration = value;
		}
		
		public function get updater():ITransitionProgressUpdater { return _updater; }
		public function set updater(value:ITransitionProgressUpdater):void 
		{
			_updater = value;
		}
		
		public function get easing():Function { return _easing; }
		public function set easing(value:Function):void 
		{
			_easing = value;
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Private Functions
		
		/**
		 * 只有在鼠标移入和移出时才播放动画
		 */
		protected function shouldAnimate(host:CComponent, fromState:String, toState:String):Boolean
		{
			return fromState != toState &&
				fromState 	!= ButtonStates.DISABLED &&
				toState 	!= ButtonStates.DISABLED && 
				(
				fromState 	== ButtonStates.UP || 
				toState 	== ButtonStates.UP || 
				fromState 	== ButtonStates.SELECTED_UP ||
				toState 	== ButtonStates.SELECTED_UP 
				);
		}
		
		protected function prepairForAnimation(host:CComponent, fromState:String, toState:String):void
		{
			host.clearContent();
			
			var placeSp:Shape = new Shape();
			placeSp.graphics.beginFill(0, 0);
			placeSp.graphics.drawRect(0, 0, host.width, host.height);
			placeSp.graphics.endFill();
			host.content.addChild(placeSp);
			
			var fromSp:Sprite = new Sprite();
			fromSp.name = 'fromSp';
			host.printState(fromState, fromSp);
			host.content.addChildAt(fromSp, 0);
			_fromView = fromSp;
			
			var toSp:Sprite = new Sprite();
			toSp.name = 'toSp';
			host.printState(toState, toSp);
			host.content.addChildAt(toSp, 1);
			_toView = toSp;
			
			_host = host;
			_progress 	= 0;
			
			updater.prepare(host, fromSp, toSp);
		}
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		// Event Handlers
		
		private function completeHandler():void
		{
			_host.clearContent();
			_host.updateNow();
			_host = null;
			_toView = null;
			_fromView = null;
			clearTween();
			updater.dispose();
		}
		
		private function clearTween():void
		{
			if (_tween && _tween.active) {
				_tween.complete();
			}
			TweenLite.killTweensOf(this);
			_tween = null;
		}
		
	}

}