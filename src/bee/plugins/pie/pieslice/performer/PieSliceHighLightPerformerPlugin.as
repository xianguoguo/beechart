package bee.plugins.pie.pieslice.performer
{
    import bee.chart.abstract.Chart;
    import bee.chart.events.ChartEvent;
    import bee.plugins.PluginBasic;

    /**
     * PieSlice高亮插件（未完成）
     * @author jianping.shenjp
     */
    public class PieSliceHighLightPerformerPlugin extends PluginBasic
    {

        public function PieSliceHighLightPerformerPlugin()
        {

        }

        override public function initPlugin(chart:Chart):void
        {
            super.initPlugin(chart);
            chart.addEventListener(ChartEvent.AFTER_ADD_VIEW_ELEMENT, afterAddViewElement);
        }

        protected function afterAddViewElement(e:ChartEvent):void
        {
            var pieSlice:PieSlice = e.data as PieSlice;
            if (pieSlice)
            {
            }
        }

        override public function dispose():void
        {
            chart.removeEventListener(ChartEvent.AFTER_ADD_VIEW_ELEMENT, afterAddViewElement);
            super.dispose();
        }
    }

}