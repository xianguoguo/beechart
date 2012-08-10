jQuery(function($){
    //侧边栏列表，高亮逻辑
    $("#nav").tableOfContents('.content-container',{startLevel:2, depth:1}).show();
    var lis = $("#nav li");
    lis.eq(0).addClass("current");
    lis.on("click",function(e){
        lis.removeClass("current");
        $(this).addClass("current");
    });
    //代码参考自GitHub Pages TimeMachine模版代码
    var headings = [];
    var collectHeaders = function(index,item){
      headings.push({"top":$(this).offset().top - 15,"index":index});
    }
    $(".content-container h2").each(collectHeaders);
    $(window).scroll(function(){
        if(headings.length==0) 
        {
            return true;
        }
        var scrolltop = $(window).scrollTop() || 0;
        lis.removeClass("current");
        lis.eq(0).addClass("current");
        for(var i in headings) {
          if(scrolltop >= headings[i].top) {
            lis.removeClass("current");
            lis.eq(headings[i].index).addClass("current");;
          }
        }
    });
});