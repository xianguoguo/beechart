package bee.chart.elements.canvas
{
    import cn.alibaba.core.mvcapp.CModel;
    import flash.geom.Point;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class CanvasData extends CModel
    {
        private var _secLinePoses:Vector.<Point>; //竖线的位置信息
        
        public function CanvasData()
        {
        
        }
        
        public function get secLinePoses():Vector.<Point>
        {
            return _secLinePoses != null ? _secLinePoses.concat() : null;
        }
        
        public function set secLinePoses(value:Vector.<Point>):void
        {
            if (value != null)
            {
                _secLinePoses = value;
                notifyChange();
            }
        }
    
    }

}