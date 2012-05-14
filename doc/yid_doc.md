# BeeChart文档

## 开始使用

BeeChart秉承简单，好看，好用的理念，进行设计与开发。使用起来简单，易上手。

只需简单5步就能使用起来。

* 下载BeeChart swf文件
点击[BeeChart](https://github.com/downloads/sjpsega/beechart/beechart%20swf.rar)，下载最新版本的swf文件。

* 新建一文件夹，如命名为BeeChart，将下载的swf文件拷贝进该目录下。

* 在BeeChart文件夹下，新建data.xml，输入如下内容：

~~~
<chart>
    <data>
        <indexAxis name="月份">
	        <labels>
	            Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
	        </labels>
        </indexAxis>
        <valueAxis name="温度" unit="度"></valueAxis>
        <dataSets>
	        <set name="Tokyo">
	            <values>
	            7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6
	            </values>
	        </set>
	        <set name="London">
	            <values>
	            3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8
	            </values>
	        </set>
        </dataSets>
    </data>
</chart>
~~~

* 在BeeChart文件夹下，新建index.html，输入如下代码：

~~~
<!DOCTYPE html>
<html>
<head>
    <title>BeeChart Demo</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="http://style.china.alibaba.com/js/lib/fdev-v4/core/fdev-min.js"></script>
</head>
<body>
    <div id="chart-container"></div>
    <script>
       jQuery(function($){
           $.use('ui-flash-chart', function(){    
              var chart = $('#chart-container').flash({ 
                 module     : 'chart', 
                 swf 		    : 'beechart-line.swf',
                 width      : 840, 
                 height     : 400, 
                 flashvars  : { 
                    dataUrl : 'data.xml'
                 } 
              }); 
           });
       });
    </script>
</body>
</html>
~~~

* 大功告成，双击index.html就能在浏览器中看到效果啦！

效果如下所示：

![阿里巴巴logo](http://china.alibaba.com/logo.png)

## BeeChart如何工作

图表的核心功能有两种，一种是数据，另一种是展现。
BeeChart针对这两个核心功能，分别由两个参数决定，分别是data和css。
BeeChart接受的data数据可以是json数据或XML数据；css样式决定图表的展现，如颜色，动画等，这个css与html的css写法大致相同，但是属性有差异。
BeeChart中已经包含了一套漂亮的样式，所以通常情况下，用户只需给图表传入数据，便能有漂亮的图表展现效果了。
当然需求各异，用户可以根据自己的需要设定适合自身的css样式。

若用户需要修改css样式，则可以这样传递给图表：

* 新建一名为style.css的文件，然后输入：

~~~
chart {
    colors          : #E34F1E,#84BC0D,#00ABD9,#FF00A8;
    paddingRight    : 2;
    paddingLeft     : 2;
}

line {
    thickness.active : 3;
}

line dot {
    radius          : 4;
    color           : inherit;
    borderThickness : null;
    borderThickness.hl : 8;
    borderAlpha     : .5;
    borderColor     : inherit#color;
}

xAxis {
    labelGap        : auto;
    tickLength      : 0;
    lineThickness   : 0;
}

yAxis {
    tickLength      : 0;
    lineThickness   : 0;
}

canvas {
    backgroundColor : #2B2929;
    priLineThickness: 1;
    priLineColor    : #303030;
    priLineAlpha    : 1;
    secLineThickness: 1;
    secLineColor    : #303030;
}

tooltip {
    backgroundType  : simple;
    color           : #FFFFFF;
    backgroundColor : #000000;
    borderThickness : null;
    backgroundAlpha : .8;
}

legend {
    position        : bottom;
    align           : center
}
~~~

* 将给css传递给图表：

~~~
 $.use('ui-flash-chart', function(){    
    var chart = $('#chart-container').flash({ 
       module     : 'chart', 
       swf        : 'beechart-line.swf',
       width      : 840, 
       height     : 400, 
       flashvars  : { 
          dataUrl : 'data.xml',
          cssUrl  : 'style.css'
       } 
    }); 
 });  
~~~

这样就完成啦！

## API

### flashvars 
参数都经过flashvar从HTML传递到flash
有用的参数：

| 参数名称      | 参数含义    |
|---------------|-------------|
|w 或 chartWidth| 图表内容宽度|
|h 或 chartHeight| 图表内容高度|
|data| 数据内容|
|dataUrl| 数据文件路径|
|charset| 数据文件的编码|
|css| 样式设置|
|cssUrl| 样式文件路径|
|cssCharset| 样式文件的编码|

### 方法
|接口名称| 说明| 示例|
|--------|-----|-----|
|parse| 解析数据，数据可以是XML或JSON | parse(xmlString)|
|parseCSS| 解析样式 | parseCSS(cssString) |
|load| 加载数据，数据可以是XML或JSON | load('../data.xml')|
|loadCSS| 加载样式| loadCSS('../chart-style.css')|
|setDatasetActivity| 设置某条数据是否处于激活状态，激活状态的数据会突出显示，进入active状态 | setDatasetActivity(1, true)|
|getDatasetActivity| 获取某条数据是否处于激活状态| getDatasetActivity(0)|
|setDatasetVisibility| 设置某条数据是否在界面上可见| setDatasetVisibility(1, false)|
|getDatasetVisibility| 获取某条数据是否在界面上可见| getDatasetVisibility(0)|

{info} 调用内部方法，都必须在监听到swfReady事件后，才能正常调用。

### 调用flash方法示例
调用setDatasetVisibility方法：

~~~
 $.use('ui-flash-chart', function(){    
     //配置flash图表
    var chart = $('#chart-container').flash({ 
       module     : 'chart', 
       type       : 'line', 
       width      : 840, 
       height     : 400, 
       flashvars  : { 
          cssUrl  : 'http://style.china.alibaba.com/css/app/cbu/cms/page/kpi/line.css',
          dataUrl : 'http://wd.alibaba-inc.com/yid-chart/data/mon-av-temp.xml'
       } 
    }); 
    //需要设置数据是否可见，通常需要在数据处理完毕后调用接口
    chart.on('data_parsed.flash',function(){
      chart.flash('setDatasetVisibility',0,false);
    });
 });
~~~

### 事件列表
|事件名称|说明|
|--------|----|
|swfReady| 图表初始化完毕|
|click_item|用户点击一个图表上的元素|
|data_visible_change|数据隐藏\显示切换事件(点击Legend等情况下分发)|
|load_start|开始加载数据或样式|
|load_fail|数据或样式加载失败|
|load_finish|数据或样式加载完成|
|parse_fail|数据或样式解析错误|
|css_parsed|css数据处理完毕|
|data_parsed|数据信息处理完毕|

### 监听事件实例
监听事件与jQuery的监听事件方法相同

~~~
chart.on('swfReady.flash',function(){
});
~~~

## 如何扩展

### 下载源代码
BeeChart使用流行的GitHub来管理源代码，你只要安装了Git，只需要一条命令便能把代码down下来

~~~
git clone git@github.com:sjpsega/beechart.git
~~~

### 使用Ant编译代码

源码中有一名为bulid的目录，其中的bulid.xml便是ant的编译文件，基本的代码已经写好，用户只需配置下Ant环境，然后打开该文件，根据自己的环境，编辑下FLEX_HOME参数，运行下，就能将as3代码编译成swf文件了。
Ant做了两件事情，一是在bin目录下，编译生成图表的swf文件；二是在doc目录下，生成BeeChart的开发文档。

### 修改源代码
源码包括两部分：

* src:BeeChart的源码
* lib:第三方类库或资源文件

src下的源码就是BeeChart的一切！

### 核心思想
在扩展BeeChart的代码前，需要了解下BeeChart的核心架构。
之前说过，图表的核心是数据和展现；数据没什么好说的，各个图表的实现方法都是大同小异。
BeeChart使用流行的MVC架构模式。
Model、Control与基本的MVC的Model、Control无异。
最大的不同在于View。View中有个skin对象，这个skin对象决定了展现。
skin又分为Printer和Performer两部分。
Printer:将数据展现绘制出来；
Performer:处理状态变化，控制数据展现的状态，如start,hover,active等状态。

BeeChart的各个部分都是使用这种机制来实现功能的。

如图：
![阿里巴巴logo](http://china.alibaba.com/logo.png)

### 贡献自己的代码
只需要在GitHub中fork BeeChart，然后将自己的分支clone到本地，修改代码，提交。使用Pull Requests，我们验收通过，便能merge到主干。

## FAQ

Q:使用BeeChart在商业产品中，需要付费吗？
A:BeeChart是免费、开源的图表组件，不收取任何费用。

