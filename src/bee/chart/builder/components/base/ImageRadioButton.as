package bee.chart.builder.components.base
{
    import spark.components.RadioButton;
    import spark.primitives.BitmapImage;
    
    /**
     * 显示图片数据的RadioButton
     * @author jianping.shenjp
     *
     */
    public class ImageRadioButton extends RadioButton
    {
        private var _icon:Class;
        [SkinPart(required="true")]
        /**图片容器，需要在皮肤中定义*/
        public var iconImage:BitmapImage;
        
        public function ImageRadioButton()
        {
            super();
        }
        
        public function get icon():Class
        {
            return _icon;
        }
        
        public function set icon(value:Class):void
        {
            _icon = value;
            if (iconImage)
            {
                iconImage.source = icon;
            }
        }
        
        override protected function createChildren():void
        {
			setStyle("skinClass",ImageRadioButtonSkin);
			super.createChildren();
        }
        
        /**
         * 当SkinPart实例创建完成并被添加到组件(外观)时调用
         * */
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == iconImage)
            {
                iconImage.source = icon;
            }
        }
    }
}