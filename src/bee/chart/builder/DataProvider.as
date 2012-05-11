package bee.chart.builder
{
    import assets.FileAssests;
    
    import bee.chart.assemble.pie.PiePerformers;
    
    import mx.collections.ArrayCollection;
    import mx.utils.ObjectProxy;

    public class DataProvider
    {
        /**
         * 返回饼图动画相关的图片元素
         * @return
         */
        static public function getPieAnimImgArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_clockwise_anim_Img, 
				label: "扇形顺时针", 
				animate: PiePerformers.CLOCKWISE
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_counter_clockwise_anim_Img, 
				label: "扇形逆时针", 
				animate: PiePerformers.COUNTER_CLOCKWISE
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_composite_anim_Img, 
				label: "组合", 
				animate: PiePerformers.COMPOSITE
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_expand_anim_Img, 
				label: "中心展开", 
				animate: PiePerformers.EXPAND
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.none_Img,
				label: "无", 
				animate: ""
			}));
            return array;
        }
        
        /**
         * 返回折线图动画相关的图片元素
         * @return
         */
        static public function getLineAnimImgArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.line_vibration_anim_Img, 
				label: "皮筋振动", 
				animate: "true"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.none_Img,
				label: "无", 
				animate: ""
			}));
            return array;
        }
        
        /**
         * 返回柱状图动画相关的图片元素
         * @return
         */
        static public function getBarAnimImgArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.bar_bounce_anim_Img, 
				label: "弹跳式", 
				animate: "true"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.none_Img,
				label: "无", 
				animate: ""
			}));
            return array;
        }
        
        /**
         * 返回饼图鼠标经过动画的图片元素
         * @return
         */
        static public function getPieMouseAnimImgArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_apart_mouseAnimate_Img,
				label: "分离", 
				mouseAnimate: true
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.none_Img,
				label: "无", 
				mouseAnimate: false
			}));
            return array;
        }
        
        /**
         * 返回饼图legend的图片元素
         * @return
         */
        static public function getPieLegendArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_legend_left_Img, 
				label: "左侧", 
				type: "left",
				tooltip: "在左侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_legend_right_Img, 
				label: "右侧", 
				type: "right", 
				tooltip: "在右侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_legend_top_Img,
				label: "上侧", 
				type: "top", 
				tooltip: "在上侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_legend_bottom_Img, 
				label: "下侧", 
				type: "bottom", 
				tooltip: "在下侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.pie_legend_none_Img,
				label: "无",
				type: "none", 
				tooltip: "不显示图例"
			}));
            return array;
        }
        
        /**
         * 返回折线图legend的图片元素
         * @return
         */
        static public function getLineLegendArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.line_legend_left_Img,
				label: "左侧", 
				type: "left",
				tooltip: "在左侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.line_legend_right_Img, 
				label: "右侧", 
				type: "right", 
				tooltip: "在右侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.line_legend_top_Img, 
				label: "上侧",
				type: "top",
				tooltip: "在上侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.line_legend_bottom_Img,
				label: "下侧", 
				type: "bottom", 
				tooltip: "在下侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.line_legend_none_Img,
				label: "无",
				type: "none", 
				tooltip: "不显示图例"
			}));
            return array;
        }
        
        /**
         * 返回柱状图legend的图片元素
         * @return
         */
        static public function getBarLegendArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.bar_legend_left_Img, 
				label: "左侧",
				type: "left",
				tooltip: "在左侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.bar_legend_right_Img,
				label: "右侧",
				type: "right", 
				tooltip: "在右侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.bar_legend_top_Img,
				label: "上侧", 
				type: "top", 
				tooltip: "在上侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.bar_legend_bottom_Img, 
				label: "下侧", 
				type: "bottom", 
				tooltip: "在下侧显示图例"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.bar_legend_none_Img,
				label: "无", 
				type: "none", 
				tooltip: "不显示图例"
			}));
            return array;
        }
        
        
        /**
         * 返回折线图节点的图片元素
         * @return
         */
        static public function getLineDotArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.dot_Line_Img,
				label: "有节点", 
				type: true, 
				tooltip: "有节点"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.noDot_Line_Img, 
				label: "无节点", 
				type: false, 
				tooltip: "无节点"
			}));
            return array;
        }
        
        /**
         * 返回折线图节点的图片元素
         * @return
         */
        static public function getxAxisLabelArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.xAxis_label_default_Img,
				label: "默认", 
				tooltip: "默认"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.xAxis_label_interval_Img, 
				label: "文字间隔式",
				tooltip: "文字间隔式"
			}));
            array.addItem(new ObjectProxy({
				image: FileAssests.xAxis_label_slant_Img,
				label: "文字倾斜式", 
				tooltip: "文字倾斜式"
			}));
            return array;
        }
        
        /**
         * 返回配色方案的图片元素
         * @return
         */
        static public function getColorConfigArray():ArrayCollection
        {
            var array:ArrayCollection = new ArrayCollection();
            array.addItem(new ObjectProxy({
				image: FileAssests.colorConfig_1_Img,
				tooltip: "配色方案1", 
				data: {"colors": ["#A8CE55", "#E9930F", "#4D99DA", "#CE5555", "#DCBB29", "#55BECE", "#AF80DE"]}
			}));
            return array;
        }
		
    }
}