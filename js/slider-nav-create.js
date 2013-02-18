jQuery(function($){
    var init = {
        headings : [],
        init:function(){
            this.navStart();
            this.demoNavStart();
        },
        navStart:function(){
            //侧边栏列表，高亮逻辑
            var nav = $("#slider-nav");
            if(!nav.length){
                return;
            }
            self = this;
            nav.tableOfContents('.content-container',{startLevel:2, depth:1}).show();
            var lis = $("li",nav),li_first;
            li_first = lis.eq(0);
            li_first.addClass("current");
            self.arrowPosSet();
            lis.on("click",function(e){
                lis.removeClass("current");
                $(this).addClass("current");
                self.arrowPosSet();
            });

            //代码参考自GitHub Pages TimeMachine模版代码
            var headings = self.headings;
            var collectHeaders = function(index,item){
              headings.push({"top":$(this).offset().top - 15,"index":index});
            }
            $(".content-container h2").each(collectHeaders);
            self.bindScrollEvent();
        },
        bindScrollEvent:function(){
            var self = this;
            var jq_win = $(window);
            jq_win.scroll(function(){
                var headings = self.headings;
                if(headings.length==0) 
                {
                    return true;
                }
                var scrolltop = jq_win.scrollTop() || 0;
                var lis = $(".nav-container li");
                lis.removeClass("current");
                lis.eq(0).addClass("current");
                for(var i in headings) {
                  if(scrolltop >= headings[i].top) {
                    lis.removeClass("current");
                    lis.eq(headings[i].index).addClass("current");
                    self.arrowPosSet();
                  }
                }
            });
        },
        demoNavStart:function(){
            var self = this;
            self.arrowPosSet();
            $("#demo-nav-container .nav li").on("click",function(e){
                e.preventDefault();
                $(this).parent().find("li").removeClass("current");
                $(this).addClass("current");
                var url = $(this).find("a").eq(0).attr("href");
                $("#chart-iframe").attr("src",url);
                self.arrowPosSet();
            });
        },
        arrowPosSet:function(){
            var self = this;
            var arrow = $(".nav-container .arrow");
            if(!arrow.length){
                return;
            }
            var lis = $(".nav-container li");
            var currentLi = lis.filter(".current");
            animateArrow(returnCurrentLiTop(currentLi));
            $(window).off("scroll");
            function animateArrow(top){
                arrow.stop(true).animate(
                    {
                        top:top
                    },function(){
                        self.bindScrollEvent();
                    }
                );
            }
            function returnCurrentLiTop(jq_li){
                return getGoodTopPos(jq_li.position().top);
            }
            function getGoodTopPos(top){
                return top+15;
            }
        }
    }
    init.init();
});