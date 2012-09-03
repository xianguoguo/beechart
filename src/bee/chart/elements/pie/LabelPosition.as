package bee.chart.elements.pie
{
    
    /**
     * PieLabel的位置配置
     * @author jianping.shenjp
     */
    public class LabelPosition
    {
        /*
                     *      none:只有小圆饼；
                     *      normal:label水平外置
                     *      inside:label水平放置，自动判断是否放置在圆饼内外侧;
                     *      inside!:label水平放置，并且只在出现在圆饼内部；
                     *      outside:label倾斜放置，且出现在外部；
                     *      callout:label水平放置，纵向排列，且出现在外部；
                     * */
        static public const NONE:String = "none";
        static public const NORMAL:String = "normal";
        static public const INSIDE:String = "inside";
        static public const INSIDE_ONLY:String = "inside!";
        static public const OUTSIDE:String = "outside";
        static public const CALLOUT:String = "callout";
    }

}