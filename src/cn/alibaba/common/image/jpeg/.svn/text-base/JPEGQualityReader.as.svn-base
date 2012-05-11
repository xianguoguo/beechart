package cn.alibaba.common.image.jpeg
{
	import flash.utils.ByteArray;

	public class JPEGQualityReader
	{
		static public function read(bytes:ByteArray):uint
		{
			var qTables:Vector.<QuantizationTable> = decodeQuantizationTable(bytes);
			var qvalue:uint, 
				i:uint = 0,
				j:uint = 0,
				sum:uint = 0, 
				quality:uint = 0, 
				tempQ:Vector.<uint> = new Vector.<uint>;

			for (; i < qTables.length; i++) {
				if (qTables[i]) {
					tempQ = qTables[i].Q;
					for (j = 0; j < 64; j++) {
						sum += tempQ[j];
					}
				}
			}

			if (qTables.length > 1) {

				qvalue = qTables[0].Q[2] + qTables[0].Q[53] + qTables[1].Q[0] + qTables[1].Q[63];

				for (i = 0; i < 100; i++) {
					if ((qvalue < DOUBLE_QUANT_HASH[i]) && (sum < DOUBLE_QUANT_SUMS[i])) {
						continue;
					}

					if (((qvalue <= DOUBLE_QUANT_HASH[i]) && (sum <= DOUBLE_QUANT_SUMS[i])) || (i >= 50)) {
						quality = i + 1;
					}

					break;
				}
			} else if (qTables.length == 1) {

				qvalue = (qTables[0].Q[2] + qTables[0].Q[53]);

				for (i = 0; i < 100; i++) {
					if ((qvalue < SINGLE_QUANT_HASH[i]) && (sum < SINGLE_QUANT_SUMS[i])) {
						continue;
					}

					if (((qvalue <= SINGLE_QUANT_HASH[i]) && (sum <= SINGLE_QUANT_SUMS[i])) || (i >= 50)) {
						quality = i + 1;
					}

					break;
				}
			}

			return quality;
		}

		static private function decodeQuantizationTable(bytes:ByteArray):Vector.<QuantizationTable> 
		{
			bytes.position = 0;
			seekDQT(bytes);
			var length:uint=0, count:uint = 0, i:uint = 0;
			var Q:Vector.<uint>
			var qTables:Vector.<QuantizationTable> = new Vector.<QuantizationTable>;


			length = bytes.readUnsignedShort() - 2;

			while (length > 0) {
				var prec:uint = 0, n:uint = 0;

				n = bytes.readUnsignedByte();
				length--;

				prec = n >> 4; // Pq
				n &= 0x0F; // Tq

				if (n >= 4) {
					throw new Error("Unsupport quantization table more than 4 ");
				}

				Q = new Vector.<uint>(64);

				if (prec > 0) {
					if (length < 64 * 2) {
						/* Initialize full table for safety. */
						for (i = 0; i < 64; i++) {
							Q[i] = 1;
						}
						count = length >> 1;
					} else count = 64;
				} else {
					if (length < 64) {
						/* Initialize full table for safety. */
						for (i = 0; i < 64; i++) {
							Q[i] = 1;
						}
						count = length;
					} else count = 64;
				}

				for (i = 0; i < count; i++) {
					if (prec > 0) {
						Q[BLOCK_NATURAL_ORDER[i]] = bytes.readUnsignedShort();
					} else {
						Q[BLOCK_NATURAL_ORDER[i]] = bytes.readUnsignedByte();
					}
				}

				var qTable:QuantizationTable = new QuantizationTable(Q);
				qTables[n] = qTable;

				length -= count;
				if (prec > 0) length -= count;
			}

			if (length != 0) {
				throw new Error("Bogus marker length");
			}

			return qTables;
		}
		
		static private function seekDQT(bytes:ByteArray):void {
			if(!isJPEG(bytes)){
				throw new Error("Not JPEG file");
			}

			var marker:uint = nextMarker(bytes);

			while (!isSOFnMarker(marker)) {
				marker = nextMarker(bytes);
				if (marker == -1) {
					throw new Error("Unexpected end of file");
				} else if (marker == Marker.DQT) {
					return;
				}
			}
			throw new Error("Decode JPEG fail, DQT not found");

		}

		static public function isJPEG(bytes:ByteArray):Boolean
		{
			bytes.position = 0;
			var prefix:uint = bytes.readUnsignedByte();
			var magic:uint = bytes.readUnsignedByte();

			return prefix === 0xFF && magic === Marker.SOI;
			
		}

		static private function nextMarker(bytes:ByteArray):uint {
			var c:uint;
			while (c != 0xFF && c != -1) {
				c = bytes.readUnsignedByte();
			}

			do {
				c = bytes.readUnsignedByte();
			} while (c == 0xFF);

			return c;
		}

		static private function isSOFnMarker(marker:int):Boolean  {
			if (marker <= 0xC3 && marker >= 0xC0) {
				return true;
			}

			if (marker <= 0xCB && marker >= 0xC5) {
				return true;
			}

			if (marker <= 0xCF && marker >= 0xCD) {
				return true;
			}

			return false;
		}

		public static const DOUBLE_QUANT_HASH:Vector.<uint>      = new <uint>[ 1020, 1015, 932, 848, 780, 735, 702, 679, 660, 645, 632,
				623, 613, 607, 600, 594, 589, 585, 581, 571, 555, 542, 529, 514, 494, 474, 457, 439, 424, 410, 397, 386,
				373, 364, 351, 341, 334, 324, 317, 309, 299, 294, 287, 279, 274, 267, 262, 257, 251, 247, 243, 237, 232,
				227, 222, 217, 213, 207, 202, 198, 192, 188, 183, 177, 173, 168, 163, 157, 153, 148, 143, 139, 132, 128,
				125, 119, 115, 108, 104, 99, 94, 90, 84, 79, 74, 70, 64, 59, 55, 49, 45, 40, 34, 30, 25, 20, 15, 11, 6, 4,
				0];

		public static const DOUBLE_QUANT_SUMS:Vector.<uint>      = new <uint>[ 32640, 32635, 32266, 31495, 30665, 29804, 29146, 28599,
				28104, 27670, 27225, 26725, 26210, 25716, 25240, 24789, 24373, 23946, 23572, 22846, 21801, 20842, 19949,
				19121, 18386, 17651, 16998, 16349, 15800, 15247, 14783, 14321, 13859, 13535, 13081, 12702, 12423, 12056,
				11779, 11513, 11135, 10955, 10676, 10392, 10208, 9928, 9747, 9564, 9369, 9193, 9017, 8822, 8639, 8458,
				8270, 8084, 7896, 7710, 7527, 7347, 7156, 6977, 6788, 6607, 6422, 6236, 6054, 5867, 5684, 5495, 5305, 5128,
				4945, 4751, 4638, 4442, 4248, 4065, 3888, 3698, 3509, 3326, 3139, 2957, 2775, 2586, 2405, 2216, 2037, 1846,
				1666, 1483, 1297, 1109, 927, 735, 554, 375, 201, 128, 0 ];

		public static const SINGLE_QUANT_HASH:Vector.<uint>      = new <uint>[ 510, 505, 422, 380, 355, 338, 326, 318, 311, 305, 300, 297,
				293, 291, 288, 286, 284, 283, 281, 280, 279, 278, 277, 273, 262, 251, 243, 233, 225, 218, 211, 205, 198,
				193, 186, 181, 177, 172, 168, 164, 158, 156, 152, 148, 145, 142, 139, 136, 133, 131, 129, 126, 123, 120,
				118, 115, 113, 110, 107, 105, 102, 100, 97, 94, 92, 89, 87, 83, 81, 79, 76, 74, 70, 68, 66, 63, 61, 57, 55,
				52, 50, 48, 44, 42, 39, 37, 34, 31, 29, 26, 24, 21, 18, 16, 13, 11, 8, 6, 3, 2, 0 ];

		public static const SINGLE_QUANT_SUMS:Vector.<uint>      = new <uint>[ 16320, 16315, 15946, 15277, 14655, 14073, 13623, 13230,
				12859, 12560, 12240, 11861, 11456, 11081, 10714, 10360, 10027, 9679, 9368, 9056, 8680, 8331, 7995, 7668,
				7376, 7084, 6823, 6562, 6345, 6125, 5939, 5756, 5571, 5421, 5240, 5086, 4976, 4829, 4719, 4616, 4463, 4393,
				4280, 4166, 4092, 3980, 3909, 3835, 3755, 3688, 3621, 3541, 3467, 3396, 3323, 3247, 3170, 3096, 3021, 2952,
				2874, 2804, 2727, 2657, 2583, 2509, 2437, 2362, 2290, 2211, 2136, 2068, 1996, 1915, 1858, 1773, 1692, 1620,
				1552, 1477, 1398, 1326, 1251, 1179, 1109, 1031, 961, 884, 814, 736, 667, 592, 518, 441, 369, 292, 221, 151,
				86, 64, 0];

		/* extra entries for safety in decoder */
		public static const BLOCK_NATURAL_ORDER:Vector.<uint>  = new <uint>[ 0, 1, 8, 16, 9, 2, 3, 10, 17, 24, 32, 25, 18, 11, 4, 5, 12,
				19, 26, 33, 40, 48, 41, 34, 27, 20, 13, 6, 7, 14, 21, 28, 35, 42, 49, 56, 57, 50, 43, 36, 29, 22, 15, 23,
				30, 37, 44, 51, 58, 59, 52, 45, 38, 31, 39, 46, 53, 60, 61, 54, 47, 55, 62, 63, 63, 63, 63, 63, 63, 63, 63,
				63, 63, 63, 63, 63, 63, 63, 63, 63        ];


	}

}


/**
 * Project: simpleimage-1.1 File Created at 2010-8-17 $Id$ Copyright 2008 Alibaba.com Croporation Limited. All rights
 * reserved. This software is the confidential and proprietary information of Alibaba Company.
 * ("Confidential Information"). You shall not disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into with Alibaba.com.
 */

/**
 * @author wendell
 */
class QuantizationTable {

    public var Lq:uint; // Quantization table definition length
    public var Pq:uint; // Quantization table element precision
    public var Tq:uint; // Quantization table destination identifier
    public var Q:Vector.<uint>; // Quantization table elements (in natural order)

	public function QuantizationTable(q:Vector.<uint>){
		this.Q = q;
    }

}
