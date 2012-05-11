package bee.controls.label 
{
    import cn.alibaba.core.mvcapp.IModel;
    import bee.abstract.CComponent;
	/**
    * Label是可以旋转的、有背景显示功能的文本组件
    * @author hua.qiuh
    */
    public class Label extends CComponent
    {
        
        public function Label(text:String="") 
        {
            super(new LabelModel());
            this.text = text;
            skin.statePrinter = new LabelSimplePrinter();
        }
         
        override protected function get defaultStyles():Object { 
            return {
                'color'         : '#000000',
                'fontFamily'    : 'Arial',
                'fontSize'      : '12',
                'fontWeight'    : 'normal',
                'underline'     : '',
                'textAlign'     : 'left',
                'paddingLeft'   : '8',
                'paddingRight'  : '8',
                'indent'        : '0',
                'leading'       : '0',
                'backgroundAlpha' : '1',
                'cornerRadius'    : '10'
            };
        }
        
        public function get labelData():LabelModel
        {
            return dataModel as LabelModel;
        }
        
        public function get contentHeight():Number
        {
            return content.height;
        }
        
        public function get contentWidth():Number
        {
            return content.width;
        }
        
        public function get text():String { return labelData.text; }
        public function set text(value:String):void 
        {
			if (labelData.text != value)
			{
				labelData.text = value;
				updateNow();
			}
        }
		
        public function get dataValue():Number { return labelData.value; }
        public function set dataValue(num:Number):void 
        {
			labelData.value = num;
        }
        
        override public function set rotation(value:Number):void 
        {
			if (super.rotation != value)
			{
				super.rotation = value;
				updateNow();
			}
        }
        
    }

}