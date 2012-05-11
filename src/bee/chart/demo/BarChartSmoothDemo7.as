package bee.chart.demo
{
    import bee.abstract.CComponent;
    import bee.abstract.IStatesHost;
    import bee.chart.elements.bar.Bar;
    import bee.performers.IPerformer;
    import bee.printers.IStatePrinterWithUpdate;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    /**
     * 组件控制消失、显示途径研究
     * @author jianping.shenjp
     */
    public class BarChartSmoothDemo7 extends Sprite
    {
        private var data:Data;
        private var bar:Bar;
        
        public function BarChartSmoothDemo7() 
        {
            setup();
            test_animate_on_show();
            tearDown();
            
            setup();
            test_animate_on_update();
            tearDown();
            
            setup();
            test_animate_on_hide();
            //tearDown();
        }
        
        private function setup():void 
        {
            data = new Data();
            data.value = 5;
            bar = new Bar(data);
            bar.state = 'invisible';
            bar.setStyle('smooth', 'true');
            addChild(bar);
        }
        
        private function tearDown():void
        {
            removeChild(bar);
            bar = null;
            data = null;
        }
        
        private function test_animate_on_show():void 
        {
            //bar.visible = true;
            bar.state = 'normal';
            //assert(has_animation())
        }
        
        private function test_animate_on_update():void
        {
            data.value = 10;
            //assert(has_animation())
        }
        
        private function test_animate_on_hide():void
        {
            removeChild(bar);
            trace('test animation on hide');
            bar = new Bar(data);
            bar.setStyle('smooth', 'true');
            addChild(bar);
            
            trace(bar);
            bar.state = 'invisible';
            //assert(has_animation())
        }
        
        public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
        {
            
        }
    }
}
import cn.alibaba.core.mvcapp.CModel;
import cn.alibaba.core.mvcapp.IModel;
import bee.abstract.CComponent;
import bee.abstract.IStatesHost;
import bee.performers.IPerformer;
import bee.plugins.pie.performer.PerformerPlugin;
import bee.printers.IStatePrinter;
import bee.printers.IStatePrinterWithUpdate;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;
import com.greensock.TweenLite;
class Data extends CModel
{
    private var _value:Number = 0;
    
    public function get value():Number { return _value; }
    public function set value(value:Number):void 
    {
        _value = value;
        notifyChange();
    }
}

class Bar extends CComponent
{
    public function Bar(data:IModel)
    {
        super(data);
        
        skin.statePrinter = new Printer();
        skin.performer = new Performer();
    }
    
    override public function toString():String 
    {
        return name;
    }
}

class Printer implements IStatePrinter, IStatePrinterWithUpdate
{
    public function renderState(host:IStatesHost, state:String, context:DisplayObjectContainer):void
    {
        trace("renderState...");
        var bar:Bar = host as Bar;
        bar.clearContent();
        
        var sp:Shape = new Shape();
        var g:Graphics = sp.graphics;
        var h:Number = Data(bar.dataModel).value * 10;
        g.beginFill(0xFF0000);
        g.drawRect(0, 0, 50, h);
        g.endFill();
        
        context.addChild(sp);
    }
        
    public function smoothUpdate(host:IStatesHost, state:String, context:DisplayObjectContainer):void 
    {
        trace("smoothUpdate smoothUpdate...");
        if (!context.numChildren) {
            renderState(host, state, context);
            return;
        }
        var bar:Bar = host as Bar;
        var h:Number = bar.height;
        renderState(host, state, context);
        TweenLite.from( bar, 1, {
            height: h
        });
    }
}

class VisibleToggler
{
    /* INTERFACE cn.alibaba.yid.performers.IPerformer */
    static public function toggleVisibleState(host:IStatesHost, fromState:String, toState:String):void 
    {
        if (fromState === 'invisible' && toState !== fromState) {
            TweenLite.from(host, 1, {
                alpha: 0
            });
        } else if(toState === 'invisible' && toState !== fromState) {
            TweenLite.to(host, 1, {
                alpha: 0
            });
        }
    }
    
}

class Performer implements IPerformer
{
    /* INTERFACE cn.alibaba.yid.performers.IPerformer */
    public function performTransition(host:IStatesHost, fromState:String, toState:String):void 
    {
        host.printState(toState);
        //super.performTransition(host, fromState, toState);
        VisibleToggler.toggleVisibleState(host, fromState,  toState);
    }
}