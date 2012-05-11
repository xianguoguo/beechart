/**
 * ...
 * @author hua.qiuh
 */

(function($) {

    $.fn.extend({

        demo: function(opt){
            opt = $.extend(true, {
                module  : 'chart',
                type    : 'line',
                allowScriptAccess : 'always',
                swf     : opt.swf || $.util.substitute('swf/yid-chart-{0}.swf', [opt.type]),
                flashvars : {
                    dataUrl : getFirstEntry(opt.dataUrl),
                    cssUrl  : getFirstEntry(opt.cssUrl),
                    data    : opt.data,
                    css     : opt.css,
                    debug   : true
                }
            }, opt);
            
            $('<h2/>').text(opt.title || 'DEMO').appendTo(this);
            buildDataAndCSSSwitcher(this, opt);
            $('<div class="yid-chart"></div>').flash(opt).appendTo(this);
            
            return this;
        },
        
        demos: function(){
            var self = this;
            $.each(arguments, function(idx, opt){
                $('<li class="demo"></li>').demo(opt).appendTo(self);
            });
            return this;
        }
    });

    function buildDataAndCSSSwitcher(el, opt){
        var links = $('<div class="links"></div>')
            .appendTo(el)
            .delegate('.data-links a, .css-links a', 'click', function(e){
                var swf = $(this).parents('.demo').children('.yid-chart').flash('getFlash');
                if($(this).hasClass('data')){
                    swf.load($(this).attr('href'));
                } else {
                    swf.loadCSS($(this).attr('href'));
                }
                $(this).siblings('a.cur').removeClass('cur');
                $(this).addClass('cur');
                return false;
            });

        if(hasMultiple(opt.dataUrl)){
            var dataLinks = $('<span class="data-links" />').text('请选择数据:');
            buildLinks(dataLinks, opt.dataUrl, 'data').appendTo(links);
        }
        if(hasMultiple(opt.cssUrl)){
            var cssLinks = $('<span class="css-links" />').text('请选择样式:')
            buildLinks(cssLinks, opt.cssUrl, 'css').appendTo(links);
        }
    }

    function buildLinks(el, links, type){
        if(typeof links === 'string'){
            links = [links]
        }
        $.each(links, function(index, link){
            var a = $('<a target="_blank" />')
                .attr('href', link)
                .text(index+1)
                .addClass(type)
                .appendTo(el);
            if(index===0){
                a.addClass('cur');
            }
        })
        return el;
    }

    function getFirstEntry(src){
        if(!!src)
        {
            if(typeof(src) === 'string'){
            return src;
            } else {
                return src[0];
            }
        }else
        {
            return null;
        }
    }

    function hasMultiple(src){
        return typeof(src)==='object' && src.length > 1;
    }

    
    
})(jQuery);
