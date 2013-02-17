package bee.chart.elements.pie
{
    import cn.alibaba.util.ColorUtil;
    import bee.chart.abstract.Group;
    import bee.chart.assemble.pie.PieChartViewer;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSliceData;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class GroupPieSliceData extends PieSliceData
    {
        private var _sliceDatas:Vector.<PieSliceData>;
        
        static public function groupingPieSliceData(pieSliceDatas:Vector.<PieSliceData>):Vector.<PieSliceData> 
        {
            Group.disposeAll();
            var result:Vector.<PieSliceData> = new Vector.<PieSliceData>();
            var noGroupedPieSliceDatas:Vector.<PieSliceData> = new Vector.<PieSliceData>();
            var stackGroup:String = "";
            var group:Group;
            var pieSliceData:PieSliceData;
            for each (pieSliceData in pieSliceDatas) 
            {
                stackGroup = pieSliceData.config['stackGroup'];
                if (stackGroup)
                {
                    group = Group.create(stackGroup, "GroupPieSliceData");
                    group.addItem(pieSliceData);
                }else
                {
                    noGroupedPieSliceDatas.push(pieSliceData);
                }
            }
            for each (pieSliceData in noGroupedPieSliceDatas) 
            {
                result.push(pieSliceData);
            }
            var groups:Vector.<Group> = Group.all;
            var items:Vector.<Object>;
            var groupPieSliceData:GroupPieSliceData;
            for each (group in groups) 
            {
                items = group.items;
                groupPieSliceData = new GroupPieSliceData();
                groupPieSliceData.name = group.name;
                for each (var item:Object in items) 
                {
                    groupPieSliceData.addItem(item as PieSliceData);
                }
                result.push(groupPieSliceData);
            }
            return result;
        }
        
        public function GroupPieSliceData(name:String="", values:Vector.<Number>=null, config:Object=null)
        {
            super(name, values, config);
            _sliceDatas = new Vector.<PieSliceData>();
        }

        public function addItem(data:PieSliceData):void
        {
            if (_sliceDatas.indexOf(data) == -1)
            {
                _sliceDatas.push(data);
                updateStat();
            }
        }
        
        public function removeItem(data:PieSliceData):void
        {
            var index:int = _sliceDatas.indexOf(data);
            if (index != -1)
            {
                _sliceDatas.splice(index, 1);
                updateStat();
            }
        }
        
        public function get sliceDatas():Vector.<PieSliceData> { return _sliceDatas.concat(); }
        
        public function sortSliceDatas(sortFunction:Function):void
        {
            if (sortFunction != null)
            {
                _sliceDatas.sort(sortFunction);
                updateStat();
            }
        }
        
        override public function dispose():void 
        {
            _sliceDatas.length = 0;
            _sliceDatas = null;
            super.dispose();
        }
        
        override protected function updateStat():void
        {
            var total:Number = 0.0;
            var index:Number = Number.MAX_VALUE;
            var randian:Number = 0.0;
            var percent:Number = 0.0;
            var radius:Number = 0.0;
            var color:uint = 0;
            var pieSliceCanvasX:Number = 0.0;
            var pieSliceCanvasY:Number = 0.0;
            
			if(_sliceDatas.length>0)
			{
				color = _sliceDatas[0].color;
			}
            
            for each (var sliceData:PieSliceData in _sliceDatas) 
            {
                total += sliceData.value;
                randian += sliceData.radian;
                percent += sliceData.percent;
                radius = sliceData.radius;
                pieSliceCanvasX = sliceData.pieSliceCanvasX;
                pieSliceCanvasY = sliceData.pieSliceCanvasY;
                if (sliceData.index < index)
                {
                    index = sliceData.index;
                }
            }
            _value = total;
            _index = index;
            _radian = randian;
            _percent = percent;
            _radius = radius;
            _color = color;
            setConfigColor(color);
            
            _pieSliceCanvasX = pieSliceCanvasX;
            _pieSliceCanvasY = pieSliceCanvasY;
            super.updateStat();
        }
        
        override public function isGroup():Boolean
        {
            return true;
        }
        
        override public function createPieSlice(viewer:PieChartViewer):PieSlice 
        {
            var groupPieSlice:GroupPieSlice = viewer.requestElement(GroupPieSlice) as GroupPieSlice;
            return groupPieSlice;
        }
        
        private function setConfigColor(color:uint):void 
        {
            var colorStr:String = ColorUtil.int2str(color);
            if (config.style==null)
            {
                var style:Object = { 'color': colorStr};
                config.style = style;
            }else
            {
                config.style['color'] = colorStr;
            }
        }
        
    }

}