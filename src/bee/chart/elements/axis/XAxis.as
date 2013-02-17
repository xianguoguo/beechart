package bee.chart.elements.axis 
{
	import bee.chart.elements.timeline.labelmaker.LabelInfo;
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class XAxis extends Axis
	{
		
		public function XAxis() 
		{
			super();
		}
		
		override protected function initController():void 
		{
			super.initController();
			skin.statePrinter = new XAxisSimplePrinter();
		}
		
        public function get labelInfos():Vector.<LabelInfo> { return axisData.labelInfos; }
        public function set labelInfos(value:Vector.<LabelInfo>):void 
        {
            axisData.labelInfos = value;
        }
	}

}