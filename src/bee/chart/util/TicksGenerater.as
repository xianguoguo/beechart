package bee.chart.util 
{
	/**
    * 智能刻度生成器
    * @author hua.qiuh
    */
    public class TicksGenerater 
    {
		protected static const HOUR_SECONDS:Number = 60*60;
		protected static const DAY_HOUR:Number = 24;
		protected static const MIL_SECCONDS:Number = 1000;
        
        static public function make(
            max:Number, 
            min:Number      = 0, 
            count:int      = 5, 
            type:String    = ''
        ):Vector.<Number>
        {
            var range:Number = max - min;
            if (range === 0) {
				if (type == "time") {
					range = DAY_HOUR * HOUR_SECONDS * MIL_SECCONDS;
					min = max - range / DAY_HOUR;
				}else{
					range = Math.floor(Math.abs(max)*.5) || 1;
					min = max - range;
				}
            }
			
            var step:Number;
            if (range < 10 && range != Math.floor(range)) {
                step = Math.ceil(range / (count - 1) * 100000) / 100000;
            } else {
                step = Math.ceil(range / (count - 1));
            }
			
            step = fommatStep(type,step);
			
            var top:Number = step * count + Math.floor(min / step) * step;
            var result:Vector.<Number> = new Vector.<Number>();
            while (count >= 0) {
				var tick:Number = top - step * count;
                result.push(tick);
                count --;
				if (tick > max) {
					break;
				}
            }
            return result;
        }
		
		static private function fommatStep(flag:String, step:Number):Number {
			var resNum:Number = step;
            
			if (flag == "time") {
				step = Math.ceil(step / MIL_SECCONDS);
				//此处以秒为单位计 格式化后的step为小时的1、2、4、8倍数
				if(step > 12000){
					resNum = 8*HOUR_SECONDS;
				}else if(step > 8000){
					resNum = 4*HOUR_SECONDS
				}else if(step > 4000){
					resNum = 2*HOUR_SECONDS;
				}else{
					resNum = HOUR_SECONDS;
				}
				resNum = resNum * MIL_SECCONDS;
			}else {
				if (step > 1000) {
					resNum = Math.ceil(step / 100) * 100;
				} else if (step > 100) {
					resNum = Math.ceil(step / 50) * 50;
				} else if (step > 10) {
					resNum = Math.ceil(step / 10) * 10;
				} else if (step > 2) {
					resNum = Math.ceil(step / 5) * 5;
				}
			}
			
			return resNum;
		}
        
    }

}