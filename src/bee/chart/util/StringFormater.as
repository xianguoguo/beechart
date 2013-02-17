package bee.chart.util 
{
	import bee.chart.elements.timeline.labelmaker.DateUtils;
	/**
    * ...
    * @author hua.qiuh
    */
    public class StringFormater 
    {
        
        static private const WEEKDAY_NAMES:Vector.<String> = new <String>[
			"星期日",
            "星期一",
            "星期二",
            "星期三",
            "星期四",
            "星期五",
            "星期六"
        ];
        
        static private const MONTH_NAMES:Vector.<String> = new <String>[
            "一月", "二月", "三月", "四月", "五月", "六月",
            "七月", "八月", "九月", "十月", "十一月", "十二月"
        ];
        
        static private const COMMA_REG:RegExp = /(?<=\d)(?=(?:\d{3})+(?!\d))/g;
        
        
        /**
        * 将一个对象以一定的格式打印出字符串  
        * 
        * @param	src 目标对象，可以是数字、字符串等任意对象
        * @param	fmt 格式描述
        * @return   格式化后的字符串%H 　小时(以00-23来表示)。
        */
        static public function format( src:Object, fmt:String, type:String="" ):String
        {
            if (src == null) {
                return "";
            } else if (type == 'time') {
				return DateUtils.formatDate(new Date(src), "H:i");
			} else if (type == 'date' && !(src is Date)) {
                return format(str2date(src), fmt, 'date');
            } else if (src is Number || type=='number') {
                return formatNumber(Number(String(src).replace(/,/g, '')), fmt);
            } else if (src is Date) {
                return formatDate(src as Date, fmt);
            } else {            
                return src.toString();
            }
        }
        
        static private function str2date(src:Object):Date
        {
            
            function N(x:*):Number
            {
                return Number(x);
            }
            
            var date:Date = new Date(null, null, null, 0,0,0,0);
            var m:Array;
            m = src.match(/(\d+)-(\d+)-(\d+)/);
            if (m) {
                date.setFullYear(N(m[1]), N(m[2]) - 1, N(m[3]));
            }
            m = src.match(/(\d+):(\d+):(\d+)/);
            if (m) {
                date.setHours(N(m[1]), N(m[2]), N(m[3]));
            }
            return date;
        }
        
        /**
        * 格式化时间
        * 
        * 支持的格式列表：
        * %A   本地时间的星期名称全称 (e.g., Sunday, 星期天)
        * %B   本地时间的月份全称 (e.g., January, 一月)
        * %d   day of month (e.g, 01)
        * %D   date; same as %m/%d/%y
        * %F   full date; same as %Y-%m-%d
        * %H   hour (00..23)
        * %I   hour (01..12)
        * %k   hour ( 0..23)
        * %l   hour ( 1..12)
        * %m   month (01..12)
        * %M   minute (00..59)
        * %P   locale's equivalent of either AM or PM; blank if not known
        * %p   like %p, but lower case
        * %r   locale's 12-hour clock time (e.g., 11:11:04 PM)
        * %R   24-hour hour and minute; same as %H:%M
        * %S   second (00..60)
        * %T   time; same as %H:%M:%S
        * %U   week number of year, with Sunday as first day of week (00..53)
        * %W   week number of year, with Monday as first day of week (00..53)
        * %y   last two digits of year (00..99)
        * %Y   year
        * 
        * @param	date
        * @param	fmt
        * @return
        */
        static private function formatDate(date:Date, fmt:String):String
        {
            if (!fmt) {
                return date.toDateString();
            }
            var year:uint       = date.fullYear;
            var month:uint      = date.month;
            var dt:uint         = date.date;
            var hour:uint       = date.hours;
            var minute:uint     = date.minutes;
            var seconds:uint    = date.seconds;
            var ms:uint         = date.milliseconds;
			
            function to2len(n:uint):String
            {
                if (n > 99) return String(n - Math.floor(n / 100) * 100);
                return n < 10 ? '0' + n : n.toString();
            }
            
            return fmt
            .replace(/%A/, WEEKDAY_NAMES[date.getDay()])    //星期的中文名称
            .replace(/%B/, MONTH_NAMES[date.getMonth()])    //月份的中文名称
            .replace(/%y/, to2len(year))                    //年份的后两位 10
            .replace(/%Y/, year)                            //年, 2010
            .replace(/%m/, to2len(month+1))                 //月份, 01-12
            .replace(/%d/, to2len(dt))                      //日期, 01-31
            .replace(/%D/, to2len(month+1)+'/'+to2len(dt)+'/'+to2len(year))      //日期, %m/%d/%y
            .replace(/%F/, year+'-'+to2len(month+1)+'-'+to2len(dt))           //等同于%Y-%m-%d
            .replace(/%f/, year+'年'+to2len(month+1)+'月'+to2len(dt)+'日')    //等同于%Y年%m月%d日
            .replace(/%H/, to2len(hour))                    //小时, 00-23
            .replace(/%I/, hour==12 ? 12 : hour%12)         //小时, 00-12
            .replace(/%k/, hour)                            //小时, 0-23
            .replace(/%l/, hour == 0 ? 12 : (hour % 12))    //小时, 1-12
            .replace(/%M/, to2len(minute))                  //分钟, 00-59
            .replace(/%p/, hour>11 ? 'pm' : 'am')           //上午/下午,  am/pm
            .replace(/%P/, hour>11 ? 'PM' : 'AM')           //上午/下午, AM/PM
            .replace(/%S/, to2len(seconds))                 //秒钟, 00-59
            .replace(/%T/, to2len(hour)+':'+to2len(minute)+':'+to2len(seconds)) //等同于 %H:%M:%S
            ;
        }
        
        /**
        * 格式化数字
        * @param	n
        * @param	fmt
        * @return
        */
        static private function formatNumber(n:Number, fmt:String):String
        {
            var str:String = n.toString();
            fmt = fmt || '';
            var subStrs:Array = str.split('.');
            var intStr:String = subStrs[0];
            var decStr:String = subStrs.length > 1 ? subStrs[1] : '';
            if (/\d*99999|\d*000000/.test(decStr)) {
                return formatNumber(Math.round(n * 10000) / 10000, fmt);
            }
            var subFmts:Array = fmt.split('.');
            var intFmt:String = subFmts[0];
            var decFmt:String = subFmts.length > 1 ? subFmts[1] : '';
            var tmp:Array, len:uint;
            
            if (!fmt.length || /^\s+$/.test(fmt)) 
            {
                return intStr.replace(COMMA_REG, ',')
                             .replace(/,,/g, ",")
                             + (decStr ? ('.' + decStr) : '');
            }
            
            if (intFmt.indexOf('*') === -1) {
                tmp = intFmt.match(/(?<=#)\d+/);
                if (tmp) {
                    len = Number(tmp[0]);
                    while (intStr.length < len) {
                        intStr = '0' + intStr;
                    }
                }
                intFmt = intFmt.replace(/#\d+/, intStr);
            } else {
                intFmt = intFmt.replace(/\*/, intStr);
            }
            intFmt = intFmt.replace(COMMA_REG, ',');
            
            if (decFmt.indexOf('*') === -1) {
                tmp = decFmt.match(/(?<=#)\d+/);
                if (tmp) {
                    len = Number(tmp[0]);
                    //若数字没有小数位,就不保留指定位数
                    if (decStr){
                        if (decStr.length > len) {
                            decStr = decStr.substr(0, len);
                        } else {
                            while (decStr.length < len) {
                                decStr += '0';
                            }
                        }
                    }
                }
                decFmt = decFmt.replace(/#\d+/, decStr);
            } else {
                decFmt = decFmt.replace(/\*/, decStr);
            }
            
            return intFmt + (decFmt?'.' + decFmt:'');
        }
        
    }

}