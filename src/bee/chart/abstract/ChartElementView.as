package bee.chart.abstract 
{
    import cn.alibaba.core.mvcapp.IModel;
    import bee.abstract.CComponent;
	/**
    * ...
    * @author hua.qiuh
    */
    public class ChartElementView extends CComponent
    {
        private var _host:ChartElement;
        
        public function ChartElementView(host:ChartElement) 
        {
            _host = host;
            super(host.model);
        }
        
        override public function dispose():void 
        {
            _host = null;
            super.dispose();
        }
        
        public function get chart():Chart { return host ? host.chart : null; }
        public function get host():ChartElement { return _host; }
        
    }

}