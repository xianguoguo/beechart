package cn.alibaba.common.image.jpeg
{

    public final class Marker {

        /** For temporary use in arithmetic coding */
        public static const TEM:uint                       = 0x01;

        // Codes 0x02 - 0xBF are reserved

        // SOF markers for Nondifferential Huffman coding
        /** Baseline DCT */
        public static const SOF0:uint                      = 0xC0;
        /** Extended Sequential DCT */
        public static const SOF1:uint                      = 0xC1;
        /** Progressive DCT */
        public static const SOF2:uint                      = 0xC2;
        /** Lossless Sequential */
        public static const SOF3:uint                      = 0xC3;

        /** Define Huffman Tables */
        public static const DHT:uint                       = 0xC4;

        // SOF markers for Differential Huffman coding
        /** Differential Sequential DCT */
        public static const SOF5:uint                      = 0xC5;
        /** Differential Progressive DCT */
        public static const SOF6:uint                      = 0xC6;
        /** Differential Lossless */
        public static const SOF7:uint                      = 0xC7;

        /** Reserved for JPEG extensions */
        public static const JPG:uint                       = 0xC8;

        // SOF markers for Nondifferential arithmetic coding
        /** Extended Sequential DCT, Arithmetic coding */
        public static const SOF9:uint                      = 0xC9;
        /** Progressive DCT, Arithmetic coding */
        public static const SOF10:uint                     = 0xCA;
        /** Lossless Sequential, Arithmetic coding */
        public static const SOF11:uint                     = 0xCB;

        /** Define Arithmetic conditioning tables */
        public static const DAC:uint                       = 0xCC;

        // SOF markers for Differential arithmetic coding
        /** Differential Sequential DCT, Arithmetic coding */
        public static const SOF13:uint                     = 0xCD;
        /** Differential Progressive DCT, Arithmetic coding */
        public static const SOF14:uint                     = 0xCE;
        /** Differential Lossless, Arithmetic coding */
        public static const SOF15:uint                     = 0xCF;

        // Restart Markers
        public static const RST0:uint                      = 0xD0;
        public static const RST1:uint                      = 0xD1;
        public static const RST2:uint                      = 0xD2;
        public static const RST3:uint                      = 0xD3;
        public static const RST4:uint                      = 0xD4;
        public static const RST5:uint                      = 0xD5;
        public static const RST6:uint                      = 0xD6;
        public static const RST7:uint                      = 0xD7;
        /** Number of restart markers */
        public static const RESTART_RANGE:uint             = 8;

        /** Start of Image */
        public static const SOI:uint                       = 0xD8;
        /** End of Image */
        public static const EOI:uint                       = 0xD9;
        /** Start of Scan */
        public static const SOS:uint                       = 0xDA;

        /** Define Quantisation Tables */
        public static const DQT:uint                       = 0xDB;

        /** Define Number of lines */
        public static const DNL:uint                       = 0xDC;

        /** Define Restart Interval */
        public static const DRI:uint                       = 0xDD;

        /** Define Heirarchical progression */
        public static const DHP:uint                       = 0xDE;

        /** Expand reference image(s) */
        public static const EXP:uint                       = 0xDF;

        // Application markers
        /** APP0 used by JFIF */
        public static const APP0:uint                      = 0xE0;
        public static const APP1:uint                      = 0xE1;
        /** APP2 used by ICC Profile */
        public static const APP2:uint                      = 0xE2;
        public static const APP3:uint                      = 0xE3;
        public static const APP4:uint                      = 0xE4;
        public static const APP5:uint                      = 0xE5;
        public static const APP6:uint                      = 0xE6;
        public static const APP7:uint                      = 0xE7;
        public static const APP8:uint                      = 0xE8;
        public static const APP9:uint                      = 0xE9;
        public static const APP10:uint                     = 0xEA;
        public static const APP11:uint                     = 0xEB;
        public static const APP12:uint                     = 0xEC;
        public static const APP13:uint                     = 0xED;
        /** APP14 used by Adobe */
        public static const APP14:uint                     = 0xEE;
        public static const APP15:uint                     = 0xEF;

        // codes 0xF0 to 0xFD are reserved

        /** Comment marker */
        public static const COM:uint                       = 0xFE;

        // JFIF Resolution units
        /** The X and Y units simply indicate the aspect ratio of the pixels. */
        public static const DENSITY_UNIT_ASPECT_RATIO:uint = 0;
        /** Pixel density is in pixels per inch. */
        public static const DENSITY_UNIT_DOTS_INCH:uint    = 1;
        /** Pixel density is in pixels per centemeter. */
        public static const DENSITY_UNIT_DOTS_CM:uint      = 2;
        /** The max known value for DENSITY_UNIT */
        public static const NUM_DENSITY_UNIT:uint          = 3;

        // Adobe transform values
        public static const ADOBE_IMPOSSIBLE:int          = -1;
        public static const ADOBE_UNKNOWN:uint             = 0;
        public static const ADOBE_YCC:uint                 = 1;
        public static const ADOBE_YCCK:uint                = 2;
    }
}
