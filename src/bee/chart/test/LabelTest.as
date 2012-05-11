package bee.chart.test 
{
    import cn.alibaba.product.uploader.UploaderEvent;
    import cn.alibaba.util.ColorUtil;
    import bee.controls.label.Label;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.SecurityErrorEvent;
    //import cn.alibaba.yid.controls.label.LabelWithBgPrinter;
    import flash.display.Sprite;
	/**
    * ...
    * @author hua.qiuh
    */
    public class LabelTest extends Sprite
    {
        
        public function LabelTest() 
        {
            var event:Event = new Event("test", false, false);
            
            stage.scaleMode = 'noScale';
            stage.align = 'TL';
            
            var labels:Vector.<String> = new <String>[
                "Hello", "alibaba", "test", "stage.stageWidth",
                "你好", "阿里巴巴", "测试", "舞台\n舞台\n舞台"
            ];
            
            for (var i:uint = 0; i < 100; i++)
            {
                var label:Label = new Label();
                label.text = getLabel(labels);
                label.x = Math.random() * stage.stageWidth;
                label.y = Math.random() * stage.stageHeight;
                label.rotation = Math.random() * 360;
                label.setStyle('backgroundColor', ColorUtil.int2str(ColorUtil.getHighSaturationColor()));
                label.setStyle('backgroundAlpha', '.5');
                label.setStyle('fontSize', (12+Math.floor(Math.random() * 10)).toString());
                addChild(label);
            }
            
        }
        
        private function getLabel(labels:Vector.<String>):String
        {
            return labels[Math.floor(Math.random() * labels.length)];
        }
        
    }

}