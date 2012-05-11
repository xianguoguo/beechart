package bee.chart.assemble.pie
{
    import bee.button.LabelButton;
    import bee.chart.abstract.Chart;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.pie.PieSliceView;
    import bee.controls.label.Label;
    import bee.util.StyleUtil;

    /**
     * 给PieSliceView设置serialNum
     * serialNum设置规则：
     *     -2*
     *   -1*   *-1
     *  0*       *0
     *    1*   *1
     *       *2
     * @author jianping.shenjp
     */
    public class SerialNumAction
    {
        private var _labelMaxCount:int = 0;
        public function assignSerialNumProcedure(pieslices:Vector.<PieSlice>,chart:Chart):void
        {
            _labelMaxCount = countLabelMaxCount(chart);
            var sePieslices:Vector.<PieSlice> = new Vector.<PieSlice>; //东南
            var swPieslices:Vector.<PieSlice> = new Vector.<PieSlice>; //西南
            var nwPieslices:Vector.<PieSlice> = new Vector.<PieSlice>; //西北
            var nePieslices:Vector.<PieSlice> = new Vector.<PieSlice>; //东北
            grouping(pieslices, sePieslices, swPieslices, nwPieslices, nePieslices);
            assignSerialNum(sePieslices, swPieslices, nwPieslices, nePieslices);
        }
        
        private function countLabelMaxCount(chart:Chart):int 
        {
            var sliceStyle:Object = chart.styleSheet.getStyle('slice label');
            var label:Label = new Label();
            var fontSize:Number = 0.0;
            if (sliceStyle)
            {
                fontSize = Number(sliceStyle['fontSize']);
            }
            if (!fontSize)
            {
                fontSize = StyleUtil.getNumberStyle(label, 'fontSize', 12);
            }
            return (chart.chartWidth >> 1) / fontSize;
        }

        private function grouping(pieslices:Vector.<PieSlice>, sePieslices:Vector.<PieSlice>, swPieslices:Vector.<PieSlice>, nwPieslices:Vector.<PieSlice>, nePieslices:Vector.<PieSlice>):void
        {
            var data:PieSliceData;
            var pieslice:PieSlice;
            for each (pieslice in pieslices)
            {
                data = pieslice.model as PieSliceData;
                if (data.isRightSide && data.isUpSide)
                {
                    nePieslices.push(pieslice);
                }
                else if (data.isRightSide && !data.isUpSide)
                {
                    sePieslices.push(pieslice);
                }
                else if (!data.isRightSide && data.isUpSide)
                {
                    nwPieslices.push(pieslice);
                }
                else if (!data.isRightSide && !data.isUpSide)
                {
                    swPieslices.push(pieslice);
                }
            }
        }

        private function assignSerialNum(sePieslices:Vector.<PieSlice>, swPieslices:Vector.<PieSlice>, nwPieslices:Vector.<PieSlice>, nePieslices:Vector.<PieSlice>):void
        {
            var pieslice:PieSlice;
            var view:PieSliceView;
            var numloop:int;
            var i:int;
            var data:PieSliceData;
            //东南
            numloop = sePieslices.length;
            sePieslices.sort(ascSort);
            for (i = 0; i < numloop; i++)
            {
                pieslice = sePieslices[i];
                data = pieslice.model as PieSliceData;
                //pieslice
                view = pieslice.view as PieSliceView;
                view.recordSerialNum(data.displayIndex);
            }
            //东北
            numloop = nePieslices.length;
            nePieslices.sort(descSort);
            for (i = 0; i < numloop; i++)
            {
                pieslice = nePieslices[i];
                view = pieslice.view as PieSliceView;
                view.recordSerialNum(-(i + 1));
            }
            //西南
            numloop = swPieslices.length;
            swPieslices.sort(descSort);
            for (i = 0; i < numloop; i++)
            {
                pieslice = swPieslices[i];
                view = pieslice.view as PieSliceView;
                view.recordSerialNum(i);
            }
            //西北
            numloop = nwPieslices.length;
            nwPieslices.sort(ascSort);
            for (i = 0; i < numloop; i++)
            {
                pieslice = nwPieslices[i];
                view = pieslice.view as PieSliceView;
                view.recordSerialNum(-(i + 1));
            }
        }

        private function ascSort(a:PieSlice, b:PieSlice):int
        {
            return sortAB(a.displayIndex, b.displayIndex) || sortAB(a.index, b.index);
        }

        private function descSort(a:PieSlice, b:PieSlice):int
        {
            return -sortAB(a.displayIndex, b.displayIndex) || -sortAB(a.index, b.index);
        }
        
        private function sortAB(a:Number, b:Number):int
        {
            if (a > b) {
                return 1;
            } else if (a < b) {
                return -1;
            }
            return 0;
        }
    }

}