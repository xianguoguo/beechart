("chart" in jQuery.ui.flash)||(function(b,d){var c=b.util,a=function(){if(c.flash.hasVersion(10)){var g=this,f=g.element[0].id,h=g.options,e=h.swf||c.substitute("http://img.china.alibaba.com/swfapp/chart/yid-chart-{0}.swf",[h.type]);h=g.options=b.extend(true,{width:700,height:400,swf:e,allowScriptAccess:"always",flashvars:{startDelay:500,eventHandler:"jQuery.util.flash.triggerHandler"}},h);b.extend(g,{_getFlashConfigs:function(){var i=this,j;j=b.ui.flash.prototype._getFlashConfigs.call(i);delete j.type;j.flashvars.swfid=f;return j},load:function(i,j){j=j||"utf-8";return this.obj.load(i,j)},loadCSS:function(i,j){j=j||"utf-8";return this.obj.loadCSS(i,j)},parse:function(i){return this.obj.parse(i)},parseCSS:function(i){return this.obj.parseCSS(i)},setDatasetVisibility:function(i,j){return this.obj.setDatasetVisibility(i,j)},getDatasetVisibility:function(i){return this.obj.getDatasetVisibility(i)},setDatasetActivity:function(i,j){return this.obj.setDatasetActivity(i,j)},getDatasetActivity:function(i){return this.obj.getDatasetActivity(i)}});return true}return false};c.flash.regist("chart",a);b.add("ui-flash-chart")})(jQuery);
