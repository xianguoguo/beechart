package bee.chart.assemble.pie
{
    import bee.chart.abstract.Chart;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSliceData;
    import bee.chart.elements.pie.PieSliceView;
    import bee.controls.label.Label;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class GetoutJamForCallout implements IGetoutJam
    {

        /* INTERFACE cn.alibaba.yid.chart.assemble.pie.IGetoutJam */

        private var chartHeight:Number = 0.0;

        public function arrangeSliceLabels(chart:Chart, pieSlices:Vector.<PieSlice>):void
        {
            chartHeight = chart.chartHeight;
            var leftPieslices:Vector.<PieSlice> = new Vector.<PieSlice>();
            var rightPieslices:Vector.<PieSlice> = new Vector.<PieSlice>();
            var leftLabels:Vector.<Label> = new Vector.<Label>();
            var rightLabels:Vector.<Label> = new Vector.<Label>();
            var data:PieSliceData;
            var pieslice:PieSlice;
            var view:PieSliceView;
            var label:Label;
            resetOffset(pieSlices);
            for each (pieslice in pieSlices)
            {
                data = pieslice.model as PieSliceData;
                if (data.isRightSide)
                {
                    rightPieslices.push(pieslice);
                }
                else
                {
                    leftPieslices.push(pieslice);
                }
            }

            getlabels(leftPieslices, leftLabels);
            getlabels(rightPieslices, rightLabels);

            adjustLabelPos(leftPieslices, leftLabels);
            adjustLabelPos(rightPieslices, rightLabels);
        }

        private function resetOffset(pieSlices:Vector.<PieSlice>):void
        {
            setOffsetAndUpdate(pieSlices, 0);
        }

        private function adjustLabelPos(pieslices:Vector.<PieSlice>, labels:Vector.<Label>):void
        {
            var offset:Number;
            if (needAdjustForBottom(labels, chartHeight/2))
            {
                offset = getOffset(labels);
                setOffsetAndUpdate(pieslices, offset);
            }
            if (needAdjustForTop(labels, -chartHeight/2))
            {
                offset = getOffset(labels);
                setOffsetAndUpdate(pieslices, offset);
            }
        }

        private function getOffset(labels:Vector.<Label>):Number
        {
            return getNegative(calOffsetForTop(labels) + chartHeight / 2);
        }
        
        private function getNegative(value:Number):Number
        {
            return -value;
        }

        private function setOffsetAndUpdate(pieslices:Vector.<PieSlice>, offset:Number):void
        {
            var pieslice:PieSlice;
            var view:PieSliceView;
            for each (pieslice in pieslices)
            {
                view = PieSliceView(pieslice.view);
                view.setOffset(offset);
            }
        }

        private function getlabels(pieslices:Vector.<PieSlice>, labels:Vector.<Label>):void
        {
            var pieslice:PieSlice;
            var label:Label;
            for each (pieslice in pieslices)
            {
                label = PieSliceView(pieslice.view).label;
                labels.push(label);
            }
        }
        
        private function calOffsetForTop(labels:Vector.<Label>):Number
        {
            var result:Number = 0.0;
            var min:Number = Number.POSITIVE_INFINITY;
            var label:Label;
            var y:Number;
            for each (label in labels)
            {
                y = label.y;
                if (y < min)
                {
                    min = y;
                }
            }
            result = min;
            return result;
        }

        private function needAdjustForBottom(labels:Vector.<Label>, max:Number):Boolean
        {
            var result:Boolean = false;
            var label:Label;
            for each (label in labels)
            {
                if (label.y > max)
                {
                    result = true;
                    break;
                }
            }
            return result;
        }

        private function needAdjustForTop(labels:Vector.<Label>, min:Number):Boolean
        {
            var result:Boolean = false;
            var label:Label;
            for each (label in labels)
            {
                if (label.y < min)
                {
                    result = true;
                    break;
                }
            }
            return result;
        }
    }

}