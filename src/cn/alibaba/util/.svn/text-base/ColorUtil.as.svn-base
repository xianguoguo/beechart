package cn.alibaba.util 
{
	/**
	 * ...
	 * @author hua.qiuh
	 */
	public class ColorUtil
	{
		/**
		 * 将颜色字符串("#0000000") 转换成数字 
		 * @param	str HTML格式的颜色字符串
		 * @return 色值数字
		 */
		static public function str2int( value:String ):int {
			return parseInt(value ? value.replace(/^[^0-9A-Fa-f]*/, '') : '', 16);
		}
		
		/**
		 * 将颜色值数字转换成Html格式
		 * @param	value 数字
		 * @return 字符串
		 */
		static public function int2str( value:int ):String {
			return '#' + value.toString(16);
		}
        
		/**
		 * 将颜色值数字转换成标准的RGB格式.
		 * 如 #ff00,标准格式为#00ff00
		 * @param	value 数字
		 * @return 字符串
		 */
		static public function int2strStandard( value:int ):String {
			var str:String = value.toString(16);
			return '#' + "000000".substr(0, 6 - str.length) + str;
		}
		
        /**
        * RGB转换成HSL颜色表达
        * @param	rgbColor   RGB颜色值（0-255）
        * @param	G   绿色值（0-255）
        * @param	B   蓝色值（0-255）
        * @return HSL的三个数值组成的矢量
        */
        static public function RGB2HSL(rgbColor:uint):Vector.<Number>
        {
            var Max:Number, Min:Number;
            var del_R:Number, del_G:Number, del_B:Number, del_Max:Number;
            var H:Number, S:Number, L:Number;
            var R:Number = ((rgbColor & 0xFF0000) >> 16) / 255.0;
            var G:Number = ((rgbColor & 0xFF00) >> 8) / 255.0;
            var B:Number = (rgbColor & 0xFF) / 255.0;

            Min = Math.min(R, Math.min(G, B));    //Min. value of RGB
            Max = Math.max(R, Math.max(G, B));    //Max. value of RGB
            del_Max = Max - Min;        //Delta RGB value

            L = (Max + Min) / 2.0;

            if (del_Max == 0)           //This is a gray, no chroma...
            {
                //H = 2.0/3.0;          //Windows下S值为0时，H值始终为160（2/3*240）
                H = 0;                  //HSL results = 0 ÷ 1
                S = 0;
            }
            else                        //Chromatic data...
            {
                if (L < 0.5) S = del_Max / (Max + Min);
                else         S = del_Max / (2 - Max - Min);

                del_R = (((Max - R) / 6.0) + (del_Max / 2.0)) / del_Max;
                del_G = (((Max - G) / 6.0) + (del_Max / 2.0)) / del_Max;
                del_B = (((Max - B) / 6.0) + (del_Max / 2.0)) / del_Max;

                if      (R == Max) H = del_B - del_G;
                else if (G == Max) H = (1.0 / 3.0) + del_R - del_B;
                else if (B == Max) H = (2.0 / 3.0) + del_G - del_R;

                if (H < 0)  H += 1;
                if (H > 1)  H -= 1;
            }
            return new <Number>[H, S, L];
        }
        
        /**
        * 将HSL色系的颜色转换为一个RGB数值
        * @param	H   hue 色相(0-1)
        * @param	S   saturation 饱和度(0纯黑-1纯色)
        * @param	L   luminance 亮度(0纯黑-1纯白, 0.5:原色)
        * @return   RGB颜色值
        */
        static public function HSL2RGB(H:Number, S:Number, L:Number):uint
        {
            var R:Number,G:Number,B:Number;
            var var_1:Number, var_2:Number;
            if (S == 0) {               
                //HSL values = 0 ÷ 1
                //RGB results = 0 ÷ 255  
                R = L * 255.0;
                G = L * 255.0;
                B = L * 255.0;
            }
            else
            {
                if (L < 0.5) {
                    var_2 = L * (1 + S);
                } else {
                    var_2 = (L + S) - (S * L);
                }

                var_1 = 2.0 * L - var_2;

                R = 255.0 * hue2RGB(var_1, var_2, H + (1.0 / 3.0));
                G = 255.0 * hue2RGB(var_1, var_2, H);
                B = 255.0 * hue2RGB(var_1, var_2, H - (1.0 / 3.0));
            }
            return R << 16 | G << 8 | B;
        }
        
        static public function hue2RGB(v1:Number, v2:Number, vH:Number):Number
        {
            if (vH < 0) vH += 1;
            if (vH > 1) vH -= 1;
            if (6.0 * vH < 1) return v1 + (v2 - v1) * 6.0 * vH;
            if (2.0 * vH < 1) return v2;
            if (3.0 * vH < 2) return v1 + (v2 - v1) * ((2.0 / 3.0) - vH) * 6.0;
            return v1;
        }
        
        /**
        * 获得高饱和度的鲜艳颜色
        * @return
        */
        static public function getHighSaturationColor():Number
        {
            return HSL2RGB(Math.random(), 1, .5);
        }
        
        /**
        * 取两种颜色的过渡色
        * @param	beginColor  起点颜色
        * @param	endColor    终点颜色
        * @param	amount      变换的程度(0-1)，0为最接近起始颜色，1为最接近终点颜色
        * @param    withAlpha   是否是ARGB(32位颜色)
        * @return
        */
        static public function transRGBColor(beginColor:uint, endColor:uint, amount:Number = 0, withAlpha:Boolean = false):uint
        {
            const RR:uint = 0xFF0000;
            const GG:uint = 0x00FF00;
            const BB:uint = 0x0000FF;
            
            var amt2:Number = 1 - amount;
            var r:uint = ((beginColor & RR) >> 16) * amt2 + ((endColor & RR) >> 16) * amount;
            var g:uint = ((beginColor & GG) >> 8) * amt2 + ((endColor & GG) >> 8) * amount;
            var b:uint = (beginColor & BB) * amt2 + (endColor & BB) * amount;
            
            var color:uint = (r << 16) | (g << 8) | b;
            if (withAlpha) {
                var a:uint = (beginColor >> 24) * amt2 + (endColor >> 24) * amount;
                color = (a << 24) | color;
            }
            return color;
        }
        
        static public function adjstRGBBrightness(RGB:uint, brightnessAdjustment:Number):uint 
        {
            if (!brightnessAdjustment) {
                return RGB;
            }
            var R:Number = ((RGB & 0xFF0000) >> 16);
            var G:Number = ((RGB & 0xFF00) >> 8);
            var B:Number = (RGB & 0xFF);
            R = Math.max(0, Math.min(255, R + brightnessAdjustment * 255));
            G = Math.max(0, Math.min(255, G + brightnessAdjustment * 255));
            B = Math.max(0, Math.min(255, B + brightnessAdjustment * 255));
            RGB = R << 16 | G << 8 | B;
            return RGB;
        }
		
	}

}