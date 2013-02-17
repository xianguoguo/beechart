package bee.abstract 
{
    import bee.performers.IPerformer;
    import bee.performers.SimplePerformer;
    import bee.printers.IStatePrinter;
    import bee.printers.IStatePrinterWithUpdate;
    import bee.printers.NullPrinter;
    import flash.display.DisplayObjectContainer;
    /**
     * Skin 负责组件的外在表现
     * @author hua.qiuh
     */
    public class Skin 
    {
        
        private var _host:CComponent;

        private var _performer:IPerformer = SimplePerformer.instance;
        private var _statePrinter:IStatePrinter = NullPrinter.instance;

        public function Skin(host:CComponent) 
        {
            _host = host;
        }

        /**
         *  当状态变化时，调用状态切换处理
         * @param	host
         * @param	fromState
         * @param	toState
         */
        public function performStateChange(
                host:IStatesHost, 
                fromState:String, 
                toState:String):void
        {
            performer.performTransition(host, fromState, toState);
        }

        /**
         * 渲染指定的状态
         * @param	host
         * @param	state
         * @param	context
         */
        public function renderState(
                host:IStatesHost, 
                state:String,
                context:DisplayObjectContainer
                ):void
        {
            statePrinter.renderState(host, state, context);
        }
        
        /**
         * 数据更新平滑变化
         * @param	host
         * @param	state
         * @param	context
         */
        public function smoohUpdate(
                host:IStatesHost, 
                state:String,
                context:DisplayObjectContainer
                ):void
        {
            if (statePrinter is IStatePrinterWithUpdate) 
            {
                IStatePrinterWithUpdate(statePrinter).smoothUpdate(host, state, context);
            }
        }
        
        /**
        * 垃圾回收
        */
        public function dispose():void
        {
            _host = null;
            _performer = null;
            _statePrinter = null;
        }

        /**
         * 获取或设置状态切换处理模块
         */
        public function get performer():IPerformer { return _performer; }
        public function set performer(value:IPerformer):void 
        {
            _performer = value;
            _host.updateNow();
        }

        /**
         * 设置或处理状态输出模块
         */
        public function get statePrinter():IStatePrinter { return _statePrinter; }
        public function set statePrinter(value:IStatePrinter):void 
        {
            _statePrinter = value;
            _host.updateNow();
        }

    }

}
