package bee.chart.assemble.pie
{
    import bee.chart.abstract.Chart;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.pie.PieSliceView;
    import bee.chart.util.HitTest;
    import bee.controls.label.Label;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class GetoutJam implements IGetoutJam
    {

        /**
         * 处理label拥挤的方法，使得文字排列稀疏，均能看见
         */
        public function arrangeSliceLabels(chart:Chart, pieSlices:Vector.<PieSlice>):void
        {
            //取得类型为PieSlice的全部对象
            var slices:Vector.<PieSlice> = pieSlices;

            var slice:PieSlice;
            var dataLength:int = slices.length;

            var currentLabel:Label;
            var prevLabel:Label;
            var nextLabel:Label;

            if (dataLength > 3)
            {
                for (var i:int = 0; i < dataLength; i += 2)
                {
                    slice = slices[i] as PieSlice;
                    currentLabel = slice.label;

                    //第一次，相邻label间进行
                    if (i == 0)
                    {
                        prevLabel = slices[dataLength - 1].label;
                        nextLabel = slices[1].label;
                    }
                    else if (i == dataLength - 1)
                    {
                        prevLabel = slices[i - 1].label;
                        nextLabel = slices[0].label;
                    }
                    else
                    {
                        prevLabel = slices[i - 1].label;
                        nextLabel = slices[i + 1].label;
                    }
                    if (currentLabel && prevLabel && nextLabel)
                    {
                        changePosition(slice, currentLabel, prevLabel, nextLabel);
                    }
                }
            }
        }

        /**
         * 修改对应pieLabel的位置.
         * 采用pieLabel与pieLabel1、pieLabel2碰撞测试的方式，如果碰触，就使pieLabel的位置更加远离圆心
         * @param	data
         * @param	pieLabel
         * @param	pieLabel1
         * @param	pieLabel2
         */
        private function changePosition(slice:PieSlice, pieLabel:Label, pieLabel1:Label, pieLabel2:Label):void
        {
            var data:PieSliceData = slice.model as PieSliceData;

            if (HitTest.isHit(pieLabel, pieLabel1, pieLabel.stage) || HitTest.isHit(pieLabel, pieLabel2, pieLabel.stage))
            {
                slice.modifyLabelRadiusBy(PieSliceView.TICK_SIZE);
            }
            if (HitTest.isHit(pieLabel, pieLabel1, pieLabel.stage) || HitTest.isHit(pieLabel, pieLabel2, pieLabel.stage))
            {
                changePosition(slice, pieLabel, pieLabel1, pieLabel2);
            }

        }

    }

}