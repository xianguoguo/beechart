package cn.alibaba.core 
{
    
    /**
    * 可以进行垃圾回收的对象
    * @author hua.qiuh
    */
    public interface IDisposable 
    {
        function dispose():void;
    }
    
}