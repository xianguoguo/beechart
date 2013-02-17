package bee.test 
{
    import bee.button.Button;
    import bee.button.IconButton;
    import bee.button.LabelButton;
    import bee.performers.ExplodingProgressUpdater;
    import bee.performers.FadeTransitionProgressUpdater;
    import bee.performers.RotateTransitionProgressUpdater;
    import bee.printers.OverGlowPrinter;
	/**
    * ...
    * @author hua.qiuh
    */
    public class YIDButtons 
    {
        public var yid_button:Button;
        public var yid_icon_button:IconButton;
        public var yid_label_button:LabelButton;
        public var yid_performers_explode:ExplodingProgressUpdater;
        public var yid_performers_fade:FadeTransitionProgressUpdater;
        public var yid_performers_rotate:RotateTransitionProgressUpdater;
        public var yid_printers_glow:OverGlowPrinter;
        
    }

}