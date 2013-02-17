package bee.chart.elements.legend 
{
    import cn.alibaba.core.mvcapp.CModel;
    import bee.chart.abstract.ChartDataSet;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LegendData extends CModel
    {
        
        private var _dataSets:Vector.<ChartDataSet>;
        
        public function LegendData() 
        {
            
        }
        
        /**
        * 设置
        */
        public function get dataSets():Vector.<ChartDataSet> { return _dataSets; }
        public function set dataSets(value:Vector.<ChartDataSet>):void 
        {
            _dataSets = value ? value.concat() : null;
            notifyChange();
        }
        
        public function getDataSetAt(index:uint):ChartDataSet
        {
            if ( _dataSets && _dataSets.length > index ) {
                return _dataSets[index];
            } 
            return null;
        }
        
    }

}