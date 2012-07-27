/**
 * 对jquery.flash.js进行扩展
 * @author jianping.shenjp
 * @version 1.0.20120726
*/
jQuery(function($){
   var flashPlugin = $.fn.flash;






   /**
    * 由Flash调用此方法，引发事件
    * @param {Object} o
    */
    flashPlugin.triggerHandler = function(o){
        $('#' + o.swfid).triggerHandler(o.type, o);
    }
   //扩展replace函数
   var _replace = flashPlugin.replace;
   var self;
   $.extend(flashPlugin,{
        replace: function(htmlOptions){
           //hack
           // self = this;
           // console.log(this);
           var swfid = this.id;
           var htmlOptions = $.extend(true,
                {
                    allowScriptAccess: 'always',
                    flashvars: {
                        //事件钩子
                        eventHandler: 'jQuery.fn.flash.triggerHandler',
                        swfid :swfid
                    }
                },htmlOptions);
           console.log(swfid,htmlOptions);
           _replace.call(this,htmlOptions);
        }
    })
})