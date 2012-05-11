package bee.chart.assemble.pie 
{
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartModel;
    import bee.chart.elements.pie.GroupPieSliceData;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.util.ChartUtil;
	/**
    * ...
    * @author jianping.shenjp
    */
    public class PieChartDataHandle 
    {
        
        public function handleData(chartModel:ChartModel, orderType:String = "", onlyIncludeVisibleData:Boolean = true):Vector.<PieSliceData>
        {
            var result:Vector.<PieSliceData> = createPieSliceDatas(chartModel, onlyIncludeVisibleData);
            result = GroupPieSliceData.groupingPieSliceData(result);
            sortData(result, orderType);
            return result;
        }
        
        private function createPieSliceDatas(chartModel:ChartModel, onlyIncludeVisibleData:Boolean = true):Vector.<PieSliceData> 
        {
            var result:Vector.<PieSliceData> = new Vector.<PieSliceData>();
            const chartData:ChartData   = chartModel.data;
            const datas:Vector.<ChartDataSet> = chartData.allSets;
			const length:int            = datas.length;
			const totalNum:Number       = chartData.total;
            const width:Number          = chartModel.chartWidth;
            const height:Number         = chartModel.chartHeight;
			const centerX:Number        = 0;
			const centerY:Number        = 0;
			const radEach:Number        = 2 * Math.PI / totalNum;
			const radius:Number         = Math.min(width, height) >> 1;
            var dataSet:ChartDataSet;
            var data:PieSliceData;
            for (var i:int = 0; i < length; i++)
			{
				dataSet = datas[i];
                data = PieSliceData.fromDataSet(dataSet);
                if (!isCreatePieSliceData(onlyIncludeVisibleData, data))
                {
                    continue;
                }
                setPieSliceData(data, i, radEach, radius, totalNum, centerX, centerY);
                result.push(data);
			}
            return result;
        }
        
        private function isCreatePieSliceData(onlyIncludeVisibleData:Boolean, data:PieSliceData):Boolean 
        {
            return isIncludeVisibleData(onlyIncludeVisibleData, data) && isAvailabilityForValue(data.value);
        }
        
        private function isIncludeVisibleData(onlyIncludeVisibleData:Boolean, data:PieSliceData):Boolean 
        {
            var result:Boolean = true;
            if (onlyIncludeVisibleData)
            {
                result = onlyIncludeVisibleData && data.visible;
            }
            return result;
        }
        
        private function isAvailabilityForValue(value:Number):Boolean 
        {
            return !isNaN(value) && value > 0 ;
        }
        
        private function setPieSliceData(data:PieSliceData, i:int, radEach:Number, radius:Number, totalNum:Number, centerX:Number, centerY:Number):void 
        {
            var value:Number = data.value;
            var color:uint = 0;
            color = ChartUtil.getColor(data,i);
            data.percent = value / totalNum;
            data.radian = radEach * value;
            data.radius = radius;
            data.color  = color;
            data.pieSliceCanvasX = centerX;
            data.pieSliceCanvasY = centerY;
        }
        
        private function sortData(datas:Vector.<PieSliceData>, orderType:String = ""):void 
        {
            var sortFunction:Function;
            if (orderType == "asc")
            {
                sortFunction = ascSort;
            }
            if (orderType == "desc")
            {
                sortFunction = descSort;
            }
            if (sortFunction != null)
            {
                datas.sort(sortFunction);
                var idx:uint = 0;
                for each (var sliceData:PieSliceData in datas) 
                {
                    //排序必须对索引也重新分配，否则会出现bug
                    sliceData.displayIndex = idx++;
                    if (sliceData is GroupPieSliceData)
                    {
                        (sliceData as GroupPieSliceData).sortSliceDatas(sortFunction);
                    }
                }
            }
        }
        
        private function ascSort(a:PieSliceData,b:PieSliceData):Number
        {
            var result:Number = 0;
            var aValue:uint = a.value;
            var bValue:uint = b.value;
            if (aValue > bValue)
            {
                result = 1;
            }
            else if (aValue < bValue)
            {
                result = -1;
            }
            else
            {
                result = 0;
            }
            return result;
        }

        private function descSort(a:PieSliceData,b:PieSliceData):Number
        {
            var result:Number = 0;
            var aValue:uint = a.value;
            var bValue:uint = b.value;
            if (aValue > bValue)
            {
                result = -1;
            }
            else if (aValue < bValue)
            {
                result = 1;
            }
            else
            {
                result = 0;
            }
            return result;
        }
    }

}