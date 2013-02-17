package bee.chart.elements.pie
{

    /**
     * ...
     * @author jianping.shenjp
     */
    public class GroupPieSlice extends PieSlice
    {

        public function GroupPieSlice()
        {
            setModel(new GroupPieSliceData());
            setView(new GroupPieSliceView(this));
        }
        
    }

}