package bee.chart.elements.dot 
{
	import cn.alibaba.core.mvcapp.IModel;
	import bee.abstract.CComponent;
	
	/**
	 * ...
	 * @author jianping.shenjp
	 */
	public class Dot extends CComponent 
	{
		
		public function Dot(data:IModel=null) 
		{
			super(data);
			skin.statePrinter = DotSimplePrinter.instance;
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		override protected function get defaultStyles():Object { 
            return {
                'shape'         : 'circle',
                'color'         : '#FF7300',
                'borderColor'   : '#FFFFFF',
                'borderThickness'   : 2,
                'radius'        : 0,
				'alpha'			: 1
            }; 
        }
        
	}

}