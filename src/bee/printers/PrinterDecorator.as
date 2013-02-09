package bee.printers 
{
    import flash.display.DisplayObjectContainer;
    import bee.abstract.IStatesHost;
    /**
     * 可包含其他printer的printer
     * @author hua.qiuh
     */
    public class PrinterDecorator implements IStatePrinter
    {
        private var _basePrinter:IStatePrinter = NullPrinter.instance;
        
        public function PrinterDecorator(basePrinter:IStatePrinter = null)
        {
            if (basePrinter) {
                _basePrinter = basePrinter;
            }
        }
        
        /* INTERFACE cn.alibaba.yid.abstract.IStatePrinter */
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
        {
            _basePrinter.renderState(host, state, context);
        }
        
        public function get basePrinter():IStatePrinter
        {
            return _basePrinter;
        }
        
        
    }

}