jQuery(function($){
    var init = {
        init:function(){
            this.headerCurrentSet();
        },
        headerCurrentSet:function(){
            var header = $("#header");
            var current = header.data("current");
            var lis = $(".nav li",header);
            var templi;
            $.each(lis,function(idx,item){
                templi = $(item);
                if(templi.hasClass(current)){
                    templi.addClass("hover");
                }
            });
        }
    }
    init.init();
});