window.PR_SHOULD_USE_CONTINUATION=!0;var prettyPrintOne,prettyPrint;(function(){function e(e){function t(e){var t=e.charCodeAt(0);if(92!==t)return t;var n=e.charAt(1);return t=d[n],t?t:n>="0"&&"7">=n?parseInt(e.substring(1),8):"u"===n||"x"===n?parseInt(e.substring(2),16):e.charCodeAt(1)}function n(e){if(32>e)return(16>e?"\\x0":"\\x")+e.toString(16);var t=String.fromCharCode(e);return"\\"===t||"-"===t||"]"===t||"^"===t?"\\"+t:t}function r(e){var r=e.substring(1,e.length-1).match(RegExp("\\\\u[0-9A-Fa-f]{4}|\\\\x[0-9A-Fa-f]{2}|\\\\[0-3][0-7]{0,2}|\\\\[0-7]{1,2}|\\\\[\\s\\S]|-|[^-\\\\]","g")),i=[],a="^"===r[0],o=["["];a&&o.push("^");for(var s=a?1:0,l=r.length;l>s;++s){var u=r[s];if(/\\[bdsw]/i.test(u))o.push(u);else{var c,d=t(u);l>s+2&&"-"===r[s+1]?(c=t(r[s+2]),s+=2):c=d,i.push([d,c]),65>c||d>122||(65>c||d>90||i.push([32|Math.max(65,d),32|Math.min(c,90)]),97>c||d>122||i.push([-33&Math.max(97,d),-33&Math.min(c,122)]))}}i.sort(function(e,t){return e[0]-t[0]||t[1]-e[1]});for(var f=[],p=[],s=0;i.length>s;++s){var h=i[s];h[0]<=p[1]+1?p[1]=Math.max(p[1],h[1]):f.push(p=h)}for(var s=0;f.length>s;++s){var h=f[s];o.push(n(h[0])),h[1]>h[0]&&(h[1]+1>h[0]&&o.push("-"),o.push(n(h[1])))}return o.push("]"),o.join("")}function i(e){for(var t=e.source.match(RegExp("(?:\\[(?:[^\\x5C\\x5D]|\\\\[\\s\\S])*\\]|\\\\u[A-Fa-f0-9]{4}|\\\\x[A-Fa-f0-9]{2}|\\\\[0-9]+|\\\\[^ux0-9]|\\(\\?[:!=]|[\\(\\)\\^]|[^\\x5B\\x5C\\(\\)\\^]+)","g")),i=t.length,s=[],l=0,u=0;i>l;++l){var c=t[l];if("("===c)++u;else if("\\"===c.charAt(0)){var d=+c.substring(1);d&&(u>=d?s[d]=-1:t[l]=n(d))}}for(var l=1;s.length>l;++l)-1===s[l]&&(s[l]=++a);for(var l=0,u=0;i>l;++l){var c=t[l];if("("===c)++u,s[u]||(t[l]="(?:");else if("\\"===c.charAt(0)){var d=+c.substring(1);d&&u>=d&&(t[l]="\\"+s[d])}}for(var l=0;i>l;++l)"^"===t[l]&&"^"!==t[l+1]&&(t[l]="");if(e.ignoreCase&&o)for(var l=0;i>l;++l){var c=t[l],f=c.charAt(0);c.length>=2&&"["===f?t[l]=r(c):"\\"!==f&&(t[l]=c.replace(/[a-zA-Z]/g,function(e){var t=e.charCodeAt(0);return"["+String.fromCharCode(-33&t,32|t)+"]"}))}return t.join("")}for(var a=0,o=!1,s=!1,l=0,u=e.length;u>l;++l){var c=e[l];if(c.ignoreCase)s=!0;else if(/[a-z]/i.test(c.source.replace(/\\u[0-9a-f]{4}|\\x[0-9a-f]{2}|\\[^ux]/gi,""))){o=!0,s=!1;break}}for(var d={b:8,t:9,n:10,v:11,f:12,r:13},f=[],l=0,u=e.length;u>l;++l){var c=e[l];if(c.global||c.multiline)throw Error(""+c);f.push("(?:"+i(c)+")")}return RegExp(f.join("|"),s?"gi":"g")}function t(e,t){function n(e){switch(e.nodeType){case 1:if(r.test(e.className))return;for(var l=e.firstChild;l;l=l.nextSibling)n(l);var u=e.nodeName.toLowerCase();("br"===u||"li"===u)&&(i[s]="\n",o[s<<1]=a++,o[1|s++<<1]=e);break;case 3:case 4:var c=e.nodeValue;c.length&&(c=t?c.replace(/\r\n?/g,"\n"):c.replace(/[ \t\r\n]+/g," "),i[s]=c,o[s<<1]=a,a+=c.length,o[1|s++<<1]=e)}}var r=/(?:^|\s)nocode(?:\s|$)/,i=[],a=0,o=[],s=0;return n(e),{sourceCode:i.join("").replace(/\n$/,""),spans:o}}function n(e,t,n,r){if(t){var i={sourceCode:t,basePos:e};n(i),r.push.apply(r,i.decorations)}}function r(e){for(var t=void 0,n=e.firstChild;n;n=n.nextSibling){var r=n.nodeType;t=1===r?t?e:n:3===r?R.test(n.nodeValue)?e:t:t}return t===e?void 0:t}function i(t,r){var i,a={};(function(){for(var n=t.concat(r),o=[],s={},l=0,u=n.length;u>l;++l){var c=n[l],d=c[3];if(d)for(var f=d.length;--f>=0;)a[d.charAt(f)]=c;var p=c[1],h=""+p;s.hasOwnProperty(h)||(o.push(p),s[h]=null)}o.push(/[\0-\uffff]/),i=e(o)})();var o=r.length,s=function(e){for(var t=e.sourceCode,l=e.basePos,c=[l,M],d=0,f=t.match(i)||[],p={},h=0,g=f.length;g>h;++h){var m,v=f[h],y=p[v],b=void 0;if("string"==typeof y)m=!1;else{var x=a[v.charAt(0)];if(x)b=v.match(x[1]),y=x[0];else{for(var w=0;o>w;++w)if(x=r[w],b=v.match(x[1])){y=x[0];break}b||(y=M)}m=y.length>=5&&"lang-"===y.substring(0,5),!m||b&&"string"==typeof b[1]||(m=!1,y=$),m||(p[v]=y)}var T=d;if(d+=v.length,m){var C=b[1],N=v.indexOf(C),S=N+C.length;b[2]&&(S=v.length-b[2].length,N=S-C.length);var k=y.substring(5);n(l+T,v.substring(0,N),s,c),n(l+T+N,C,u(k,C),c),n(l+T+S,v.substring(S),s,c)}else c.push(l+T,y)}e.decorations=c};return s}function a(e){var t=[],n=[];e.tripleQuotedStrings?t.push([E,/^(?:\'\'\'(?:[^\'\\]|\\[\s\S]|\'{1,2}(?=[^\']))*(?:\'\'\'|$)|\"\"\"(?:[^\"\\]|\\[\s\S]|\"{1,2}(?=[^\"]))*(?:\"\"\"|$)|\'(?:[^\\\']|\\[\s\S])*(?:\'|$)|\"(?:[^\\\"]|\\[\s\S])*(?:\"|$))/,null,"'\""]):e.multiLineStrings?t.push([E,/^(?:\'(?:[^\\\']|\\[\s\S])*(?:\'|$)|\"(?:[^\\\"]|\\[\s\S])*(?:\"|$)|\`(?:[^\\\`]|\\[\s\S])*(?:\`|$))/,null,"'\"`"]):t.push([E,/^(?:\'(?:[^\\\'\r\n]|\\.)*(?:\'|$)|\"(?:[^\\\"\r\n]|\\.)*(?:\"|$))/,null,"\"'"]),e.verbatimStrings&&n.push([E,/^@\"(?:[^\"]|\"\")*(?:\"|$)/,null]);var r=e.hashComments;if(r&&(e.cStyleComments?(r>1?t.push([L,/^#(?:##(?:[^#]|#(?!##))*(?:###|$)|.*)/,null,"#"]):t.push([L,/^#(?:(?:define|e(?:l|nd)if|else|error|ifn?def|include|line|pragma|undef|warning)\b|[^\r\n]*)/,null,"#"]),n.push([E,/^<(?:(?:(?:\.\.\/)*|\/?)(?:[\w-]+(?:\/[\w-]+)+)?[\w-]+\.h(?:h|pp|\+\+)?|[a-z]\w*)>/,null])):t.push([L,/^#[^\r\n]*/,null,"#"])),e.cStyleComments&&(n.push([L,/^\/\/[^\r\n]*/,null]),n.push([L,/^\/\*[\s\S]*?(?:\*\/|$)/,null])),e.regexLiterals){var a="/(?=[^/*])(?:[^/\\x5B\\x5C]|\\x5C[\\s\\S]|\\x5B(?:[^\\x5C\\x5D]|\\x5C[\\s\\S])*(?:\\x5D|$))+/";n.push(["lang-regex",RegExp("^"+H+"("+a+")")])}var o=e.types;o&&n.push([_,o]);var s=(""+e.keywords).replace(/^ | $/g,"");s.length&&n.push([A,RegExp("^(?:"+s.replace(/[\s,]+/g,"|")+")\\b"),null]),t.push([M,/^\s+/,null," \r\n	 "]);var l=/^.[^\s\w\.$@\'\"\`\/\\]*/;return n.push([D,/^@[a-z_$][a-z_$@0-9]*/i,null],[_,/^(?:[@_]?[A-Z]+[a-z][A-Za-z_$@0-9]*|\w+_t\b)/,null],[M,/^[a-z_$][a-z_$@0-9]*/i,null],[D,RegExp("^(?:0x[a-f0-9]+|(?:\\d(?:_\\d+)*\\d*(?:\\.\\d*)?|\\.\\d\\+)(?:e[+\\-]?\\d+)?)[a-z]*","i"),null,"0123456789"],[M,/^\\[\s\S]?/,null],[F,l,null]),i(t,n)}function o(e,t,n){function r(e){switch(e.nodeType){case 1:if(a.test(e.className))break;if("br"===e.nodeName)i(e),e.parentNode&&e.parentNode.removeChild(e);else for(var t=e.firstChild;t;t=t.nextSibling)r(t);break;case 3:case 4:if(n){var l=e.nodeValue,u=l.match(o);if(u){var c=l.substring(0,u.index);e.nodeValue=c;var d=l.substring(u.index+u[0].length);if(d){var f=e.parentNode;f.insertBefore(s.createTextNode(d),e.nextSibling)}i(e),c||e.parentNode.removeChild(e)}}}}function i(e){function t(e,n){var r=n?e.cloneNode(!1):e,i=e.parentNode;if(i){var a=t(i,1),o=e.nextSibling;a.appendChild(r);for(var s=o;s;s=o)o=s.nextSibling,a.appendChild(s)}return r}for(;!e.nextSibling;)if(e=e.parentNode,!e)return;for(var n,r=t(e.nextSibling,0);(n=r.parentNode)&&1===n.nodeType;)r=n;u.push(r)}for(var a=/(?:^|\s)nocode(?:\s|$)/,o=/\r\n?|\n/,s=e.ownerDocument,l=s.createElement("li");e.firstChild;)l.appendChild(e.firstChild);for(var u=[l],c=0;u.length>c;++c)r(u[c]);t===(0|t)&&u[0].setAttribute("value",t);var d=s.createElement("ol");d.className="linenums";for(var f=Math.max(0,0|t-1)||0,c=0,p=u.length;p>c;++c)l=u[c],l.className="L"+(c+f)%10,l.firstChild||l.appendChild(s.createTextNode(" ")),d.appendChild(l);e.appendChild(d)}function s(e){var t=/\bMSIE\s(\d+)/.exec(navigator.userAgent);t=t&&8>=+t[1];var n=/\n/g,r=e.sourceCode,i=r.length,a=0,o=e.spans,s=o.length,l=0,u=e.decorations,c=u.length,d=0;u[c]=i;var f,p;for(p=f=0;c>p;)u[p]!==u[p+2]?(u[f++]=u[p++],u[f++]=u[p++]):p+=2;for(c=f,p=f=0;c>p;){for(var h=u[p],g=u[p+1],m=p+2;c>=m+2&&u[m+1]===g;)m+=2;u[f++]=h,u[f++]=g,p=m}c=u.length=f;var v,y=e.sourceNode;y&&(v=y.style.display,y.style.display="none");try{for(;s>l;){o[l];var b,x=o[l+2]||i,w=u[d+2]||i,m=Math.min(x,w),T=o[l+1];if(1!==T.nodeType&&(b=r.substring(a,m))){t&&(b=b.replace(n,"\r")),T.nodeValue=b;var C=T.ownerDocument,N=C.createElement("span");N.className=u[d+1];var S=T.parentNode;S.replaceChild(N,T),N.appendChild(T),x>a&&(o[l+1]=T=C.createTextNode(r.substring(m,x)),S.insertBefore(T,N.nextSibling))}a=m,a>=x&&(l+=2),a>=w&&(d+=2)}}finally{y&&(y.style.display=v)}}function l(e,t){for(var n=t.length;--n>=0;){var r=t[n];z.hasOwnProperty(r)?p.console&&console.warn("cannot override language handler %s",r):z[r]=e}}function u(e,t){return e&&z.hasOwnProperty(e)||(e=/^\s*</.test(t)?"default-markup":"default-code"),z[e]}function c(e){var n=e.langExtension;try{var r=t(e.sourceNode,e.pre),i=r.sourceCode;e.sourceCode=i,e.spans=r.spans,e.basePos=0,u(n,i)(e),s(e)}catch(a){p.console&&console.log(a&&a.stack?a.stack:a)}}function d(e,t,n){var r=document.createElement("pre");r.innerHTML=e,n&&o(r,n,!0);var i={langExtension:t,numberLines:n,sourceNode:r,pre:1};return c(i),r.innerHTML}function f(e){function t(e){return document.getElementsByTagName(e)}function n(){for(var t=p.PR_SHOULD_USE_CONTINUATION?d.now()+250:1/0;a.length>h&&t>d.now();h++){var i=a[h],s=i.className;if(m.test(s)&&!v.test(s)){for(var l=!1,u=i.parentNode;u;u=u.parentNode){var w=u.tagName;if(x.test(w)&&u.className&&m.test(u.className)){l=!0;break}}if(!l){i.className+=" prettyprinted";var T,C=s.match(g);!C&&(T=r(i))&&b.test(T.tagName)&&(C=T.className.match(g)),C&&(C=C[1]);var N;if(y.test(i.tagName))N=1;else{var S=i.currentStyle,k=S?S.whiteSpace:document.defaultView&&document.defaultView.getComputedStyle?document.defaultView.getComputedStyle(i,null).getPropertyValue("white-space"):0;N=k&&"pre"===k.substring(0,3)}var j=i.className.match(/\blinenums\b(?::(\d+))?/);j=j?j[1]&&j[1].length?+j[1]:!0:!1,j&&o(i,j,N),f={langExtension:C,sourceNode:i,numberLines:j,pre:N},c(f)}}}a.length>h?setTimeout(n,250):e&&e()}for(var i=[t("pre"),t("code"),t("xmp")],a=[],s=0;i.length>s;++s)for(var l=0,u=i[s].length;u>l;++l)a.push(i[s][l]);i=null;var d=Date;d.now||(d={now:function(){return+new Date}});var f,h=0,g=/\blang(?:uage)?-([\w.]+)(?!\S)/,m=/\bprettyprint\b/,v=/\bprettyprinted\b/,y=/pre|xmp/i,b=/^code$/i,x=/^(?:pre|code|xmp)$/i;n()}var p=window,h=["break,continue,do,else,for,if,return,while"],g=[h,"auto,case,char,const,default,double,enum,extern,float,goto,int,long,register,short,signed,sizeof,static,struct,switch,typedef,union,unsigned,void,volatile"],m=[g,"catch,class,delete,false,import,new,operator,private,protected,public,this,throw,true,try,typeof"],v=[m,"alignof,align_union,asm,axiom,bool,concept,concept_map,const_cast,constexpr,decltype,dynamic_cast,explicit,export,friend,inline,late_check,mutable,namespace,nullptr,reinterpret_cast,static_assert,static_cast,template,typeid,typename,using,virtual,where"],y=[m,"abstract,boolean,byte,extends,final,finally,implements,import,instanceof,null,native,package,strictfp,super,synchronized,throws,transient"],b=[y,"as,base,by,checked,decimal,delegate,descending,dynamic,event,fixed,foreach,from,group,implicit,in,interface,internal,into,is,let,lock,object,out,override,orderby,params,partial,readonly,ref,sbyte,sealed,stackalloc,string,select,uint,ulong,unchecked,unsafe,ushort,var,virtual,where"],x="all,and,by,catch,class,else,extends,false,finally,for,if,in,is,isnt,loop,new,no,not,null,of,off,on,or,return,super,then,throw,true,try,unless,until,when,while,yes",w=[m,"debugger,eval,export,function,get,null,set,undefined,var,with,Infinity,NaN"],T="caller,delete,die,do,dump,elsif,eval,exit,foreach,for,goto,if,import,last,local,my,next,no,our,print,package,redo,require,sub,undef,unless,until,use,wantarray,while,BEGIN,END",C=[h,"and,as,assert,class,def,del,elif,except,exec,finally,from,global,import,in,is,lambda,nonlocal,not,or,pass,print,raise,try,with,yield,False,True,None"],N=[h,"alias,and,begin,case,class,def,defined,elsif,end,ensure,false,in,module,next,nil,not,or,redo,rescue,retry,self,super,then,true,undef,unless,until,when,yield,BEGIN,END"],S=[h,"case,done,elif,esac,eval,fi,function,in,local,set,then,until"],k=[v,b,w,T+C,N,S],j=/^(DIR|FILE|vector|(de|priority_)?queue|list|stack|(const_)?iterator|(multi)?(set|map)|bitset|u?(int|float)\d*)\b/,E="str",A="kwd",L="com",_="typ",D="lit",F="pun",M="pln",P="tag",O="dec",$="src",I="atn",q="atv",B="nocode",H="(?:^^\\.?|[+-]|[!=]=?=?|\\#|%=?|&&?=?|\\(|\\*=?|[+\\-]=|->|\\/=?|::?|<<?=?|>>?>?=?|,|;|\\?|@|\\[|~|{|\\^\\^?=?|\\|\\|?=?|break|case|continue|delete|do|else|finally|instanceof|return|throw|try|typeof)\\s*",R=/\S/,W=a({keywords:k,hashComments:!0,cStyleComments:!0,multiLineStrings:!0,regexLiterals:!0}),z={};l(W,["default-code"]),l(i([],[[M,/^[^<?]+/],[O,/^<!\w[^>]*(?:>|$)/],[L,/^<\!--[\s\S]*?(?:-\->|$)/],["lang-",/^<\?([\s\S]+?)(?:\?>|$)/],["lang-",/^<%([\s\S]+?)(?:%>|$)/],[F,/^(?:<[%?]|[%?]>)/],["lang-",/^<xmp\b[^>]*>([\s\S]+?)<\/xmp\b[^>]*>/i],["lang-js",/^<script\b[^>]*>([\s\S]*?)(<\/script\b[^>]*>)/i],["lang-css",/^<style\b[^>]*>([\s\S]*?)(<\/style\b[^>]*>)/i],["lang-in.tag",/^(<\/?[a-z][^<>]*>)/i]]),["default-markup","htm","html","mxml","xhtml","xml","xsl"]),l(i([[M,/^[\s]+/,null," 	\r\n"],[q,/^(?:\"[^\"]*\"?|\'[^\']*\'?)/,null,"\"'"]],[[P,/^^<\/?[a-z](?:[\w.:-]*\w)?|\/?>$/i],[I,/^(?!style[\s=]|on)[a-z](?:[\w:-]*\w)?/i],["lang-uq.val",/^=\s*([^>\'\"\s]*(?:[^>\'\"\s\/]|\/(?=\s)))/],[F,/^[=<>\/]+/],["lang-js",/^on\w+\s*=\s*\"([^\"]+)\"/i],["lang-js",/^on\w+\s*=\s*\'([^\']+)\'/i],["lang-js",/^on\w+\s*=\s*([^\"\'>\s]+)/i],["lang-css",/^style\s*=\s*\"([^\"]+)\"/i],["lang-css",/^style\s*=\s*\'([^\']+)\'/i],["lang-css",/^style\s*=\s*([^\"\'>\s]+)/i]]),["in.tag"]),l(i([],[[q,/^[\s\S]+/]]),["uq.val"]),l(a({keywords:v,hashComments:!0,cStyleComments:!0,types:j}),["c","cc","cpp","cxx","cyc","m"]),l(a({keywords:"null,true,false"}),["json"]),l(a({keywords:b,hashComments:!0,cStyleComments:!0,verbatimStrings:!0,types:j}),["cs"]),l(a({keywords:y,cStyleComments:!0}),["java"]),l(a({keywords:S,hashComments:!0,multiLineStrings:!0}),["bsh","csh","sh"]),l(a({keywords:C,hashComments:!0,multiLineStrings:!0,tripleQuotedStrings:!0}),["cv","py"]),l(a({keywords:T,hashComments:!0,multiLineStrings:!0,regexLiterals:!0}),["perl","pl","pm"]),l(a({keywords:N,hashComments:!0,multiLineStrings:!0,regexLiterals:!0}),["rb"]),l(a({keywords:w,cStyleComments:!0,regexLiterals:!0}),["js"]),l(a({keywords:x,hashComments:3,cStyleComments:!0,multilineStrings:!0,tripleQuotedStrings:!0,regexLiterals:!0}),["coffee"]),l(i([],[[E,/^[\s\S]+/]]),["regex"]);var X=p.PR={createSimpleLexer:i,registerLangHandler:l,sourceDecorator:a,PR_ATTRIB_NAME:I,PR_ATTRIB_VALUE:q,PR_COMMENT:L,PR_DECLARATION:O,PR_KEYWORD:A,PR_LITERAL:D,PR_NOCODE:B,PR_PLAIN:M,PR_PUNCTUATION:F,PR_SOURCE:$,PR_STRING:E,PR_TAG:P,PR_TYPE:_,prettyPrintOne:p.prettyPrintOne=d,prettyPrint:p.prettyPrint=f};"function"==typeof define&&define.amd&&define("google-code-prettify",[],function(){return X})})(),PR.registerLangHandler(PR.createSimpleLexer([[PR.PR_PLAIN,/^[ \t\r\n\f]+/,null," 	\r\n\f"]],[[PR.PR_STRING,/^\"(?:[^\n\r\f\\\"]|\\(?:\r\n?|\n|\f)|\\[\s\S])*\"/,null],[PR.PR_STRING,/^\'(?:[^\n\r\f\\\']|\\(?:\r\n?|\n|\f)|\\[\s\S])*\'/,null],["lang-css-str",/^url\(([^\)\"\']+)\)/i],[PR.PR_KEYWORD,/^(?:url|rgb|\!important|@import|@page|@media|@charset|inherit)(?=[^\-\w]|$)/i,null],["lang-css-kw",/^(-?(?:[_a-z]|(?:\\[0-9a-f]+ ?))(?:[_a-z0-9\-]|\\(?:\\[0-9a-f]+ ?))*)\s*:/i],[PR.PR_COMMENT,/^\/\*[^*]*\*+(?:[^\/*][^*]*\*+)*\//],[PR.PR_COMMENT,/^(?:<!--|-->)/],[PR.PR_LITERAL,/^(?:\d+|\d*\.\d+)(?:%|[a-z]+)?/i],[PR.PR_LITERAL,/^#(?:[0-9a-f]{3}){1,2}/i],[PR.PR_PLAIN,/^-?(?:[_a-z]|(?:\\[\da-f]+ ?))(?:[_a-z\d\-]|\\(?:\\[\da-f]+ ?))*/i],[PR.PR_PUNCTUATION,/^[^\s\w\'\"]+/]]),["css"]),PR.registerLangHandler(PR.createSimpleLexer([],[[PR.PR_KEYWORD,/^-?(?:[_a-z]|(?:\\[\da-f]+ ?))(?:[_a-z\d\-]|\\(?:\\[\da-f]+ ?))*/i]]),["css-kw"]),PR.registerLangHandler(PR.createSimpleLexer([],[[PR.PR_STRING,/^[^\)\"\']+/]]),["css-str"]),function(e,t,n){function r(e,t){var n=(e[0]||0)-(t[0]||0);return n>0||!n&&e.length>0&&r(e.slice(1),t.slice(1))}function i(e){if(typeof e!==d)return e;var t=[],n="";for(var r in e)n=typeof e[r]===d?i(e[r]):[r,u?encodeURI(e[r]):e[r]].join("="),t.push(n);return t.join("&")}function a(e){var t=[];for(var n in e)e[n]&&t.push([n,'="',e[n],'"'].join(""));return t.join(" ")}function o(e){var t=[];for(var n in e)t.push(['<param name="',n,'" value="',i(e[n]),'" />'].join(""));return t.join("")}function s(e){var t=/string|number/.test(typeof e)?(""+e).split("."):/object/.test(typeof e)?[e.major,e.minor]:e||[0,0];return r(g,t)}function l(t,n){if(!n.swf||x||!m&&!n.hasVersionFail)return!1;if(!s(n.hasVersion||1)){if(x=!0,typeof n.hasVersionFail===f&&!n.hasVersionFail.apply(n))return!1;n={swf:n.expressInstall||b,height:137,width:214,flashvars:{MMredirectURL:location.href,MMplayerType:v?"ActiveX":"PlugIn",MMdoctitle:document.title.slice(0,47)+" - Flash Player Installation"}}}attrs={id:"ui-flash-object"+e.guid++,width:n.width||320,height:n.height||180,style:n.style||""},p?(attrs.classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",n.movie=n.swf):(attrs.data=n.swf,attrs.type="application/x-shockwave-flash"),u=n.useEncode!==void 0?n.useEncode:y,n.wmode=n.wmode||"opaque",delete n.hasVersion,delete n.hasVersionFail,delete n.height,delete n.swf,delete n.useEncode,delete n.width;var r=["<object ",a(attrs),">",o(n),"</object>"].join("");if(p){var i=document.createElement("div");t.html(i),i.outerHTML=r}else t.html(r);return t.children().get(0)}var u,c,d="object",f="function",p=e.browser.msie;try{c=n.description||function(){return new n("ShockwaveFlash.ShockwaveFlash").GetVariable("$version")}()}catch(h){c="Unavailable"}var g=c.match(/\d+/g)||[0],m=g[0]>0,v=n&&!n.name;({original:c,array:g,string:g.join("."),major:parseInt(g[0],10)||0,minor:parseInt(g[1],10)||0,release:parseInt(g[2],10)||0});var y=!0,b="expressInstall.swf",x=!1;e.fn.flash=function(t){function n(){s=!0,a.attr("id","ui-flash"+e.guid)}function r(t){var n=e.extend(!0,{flashvars:{swfid:a.attr("id"),eventHandler:"jQuery.fn.flash.triggerHandler"}},t);return delete n.disabled,delete n.module,n}function i(e){a.attr("id")||n(),a.addClass("ui-flash"),o=l(a,r(e))}var a,o,s=!1;return this.getFlash=function(){return o},"object"==typeof t&&(a=this,i.call(this,t)),this},e.fn.flash.triggerHandler=function(t){e("#"+t.swfid).triggerHandler(t.type,t)}}(jQuery,jQuery.util,navigator.plugins["Shockwave Flash"]||window.ActiveXObject);