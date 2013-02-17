package bee.plugins.pie.pieslice.printer
{
    import bee.chart.elements.pie.LabelSetType;
    import bee.chart.elements.pie.PieSlice;
    import bee.chart.elements.pie.PieSlice2dDrawPrinterForNormal;
    import bee.chart.events.ChartEvent;
    import bee.printers.IStatePrinter;

    /**
     * ...
     * @author jianping.shenjp
     */
    public class PieSlice2dDrawPrinterForNormalPlugin extends PieSlice2dDrawPrinterPlugin
    {

        public function PieSlice2dDrawPrinterForNormalPlugin()
        {
            super();
        }

        override protected function afterAddViewElement(e:ChartEvent):void
        {
            super.afterAddViewElement(e);
            var pieSlice:PieSlice = e.data as PieSlice;
            if (pieSlice)
            {
                if (needChangeStatePrinter(pieSlice))
                {
                    var printer:IStatePrinter = pieSlice.skin.statePrinter;
                    pieSlice.skin.statePrinter = new PieSlice2dDrawPrinterForNormal(printer);
                }
            }
        }

        private function needChangeStatePrinter(pieSlice:PieSlice):Boolean
        {
            return !(pieSlice.skin.statePrinter is PieSlice2dDrawPrinterForNormal) && (_labelSetType == LabelSetType.NORMAL);
        }
    }
}