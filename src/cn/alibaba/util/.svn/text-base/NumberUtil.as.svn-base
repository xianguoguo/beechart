package cn.alibaba.util 
{
	/**
    * ...
    * @author hua.qiuh
    */
    public class NumberUtil 
    {
        static public function bytes2string( bytes:Number ):String
        {
            if (bytes >= 0x10000000000 ) {
                return Math.round(bytes / 0x10000000000 * 100) / 100 + "TB";
            }
            if (bytes >= 0x40000000) {
                return Math.round(bytes / 0x40000000 * 100) / 100 + "GB";
            }
            if (bytes >= 0x100000) {
                return Math.round(bytes / 0x100000 * 100) / 100 + "MB";
            }
            if (bytes >= 1024) {
                return Math.round(bytes / 1024 * 100) / 100 + "KB";
            }
            return bytes + "B";
        }
        
    }

}