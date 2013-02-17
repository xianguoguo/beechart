package bee.performers 
{
    import bee.abstract.IStatesHost;
    
    /**
     * 最简单的状态变化处理逻辑：让render渲染新的状态即可
     * @author hua.qiuh
     */
    public class SimplePerformer implements IPerformer
    {
        static private var _instance:SimplePerformer;
        static public function get instance():SimplePerformer
        {
            if (!_instance) {
                _instance = new SimplePerformer(new Enforcer());
            }
            return _instance;
        }
        
        public function SimplePerformer(enf:Enforcer)
        {
            
        }
        
        /**
         * 
         * @param	host
         * @param	fromState
         * @param	toState
         */
        public function performTransition(host:IStatesHost, fromState:String, toState:String):void
        {
            host.printState(toState);
        }
        
    }

}

class Enforcer { };