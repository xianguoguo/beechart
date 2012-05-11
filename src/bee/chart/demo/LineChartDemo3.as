package bee.chart.demo
{
    import bee.chart.abstract.ChartData;
    import bee.chart.abstract.ChartDataSet;
    import bee.chart.abstract.ChartStates;
    import bee.chart.elements.tag.Tag;
    import bee.chart.elements.tag.TagWithGuidePrinter;
    import bee.chart.LineChart;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import net.hires.debug.Stats;

    /**
    * ...
    * @author hua.qiuh
    */
    public class LineChartDemo3 extends Sprite 
    {
        
        public function LineChartDemo3():void 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            
            //所有类型图表的CController都是同一个：Chart
            var chart:LineChart = new LineChart();
            var data:ChartData = chart.data;
            
            //添加数据
            //1. 以dataProvider的方式提供数据
            //chart.dataProvider = ...
            //2. 直接修改数据
            data.defineLabel('日期');
            data.defineValue('站内主数据区CTR', '%');
            data.labels = new <String>[
                "2010-11-26", "2010-11-28", "2010-12-4", "2010-12-6", "2010-12-10", "2010-12-12", "2010-12-14", "2010-12-16" ];
			///*
            data.addSet(
                new ChartDataSet(
                    "CTR", 
                    new <Number>[2.25, 2.3, 2.33, 2.2, 2.22, 2.31, 2.35, 2.38, 2.4],
                    {
                        style: {
                            'thickness'         : 5,
                            'thickness.active'  : 6,
                            'color'             : '#6DB526'
                        }
                    }
                )
            );
			//*/
			
			/**
			 * 性能压力测试
			 */
			/*
			for (var i:uint = 0; i < 100; i++) {
				var values:Vector.<Number> = new Vector.<Number>();
				for (var j:uint = 0; j < 10; j++) {
					values[j] = Math.floor(Math.random() * 500);
				}
				chart.data.addSet(
					new ChartDataSet(
						"数据"+i,
						values,
                        {
                            style: {
                                color: ColorUtil.int2str(ColorUtil.getHighSaturationColor())
                            }
                        }
					)
				);
			}
			//*/

            //设置展示方式为折线图
            var style:StyleSheet = chart.styleSheet;
            style.setStyle('canvas', {
                'gridColor'         : '#29A5F7',
                'gridThickness'     : null,
                'gridAlpha'         : .5,
                'xgap'              : 0
            });
            
            style.setStyle('line', {
                'thickness'         : 3,
                'alpha'	            : 1,
                'thickness.active'  : 5,
                'lineMethod'        : 'curve',
                'fillAlpha'         : 0.5
            });
            
            style.setStyle('line dot', {
                'radius'            : 0,
                'radius.active'     : 5,
                'radius.hl'         : 10,
                'color'             : '#FFFFFF',
                'color.hl'          : '#FFFFFF',
                'borderColor'       : 'inherit#color',
                'borderThickness'   : 3,
                'alpha'             : 'inherit#alpha'
            });
            
            style.setStyle('yAxis', {
                'tickColor'     : '#666666',
                'lineThickness' : null,
                'tickThickness' : null,
                'labelDataType' : 'number',
                'labelFormat'   : '*.#2'
            });
            
            style.setStyle('xAxis', {
                'lineThickness' : 2,
                'tickThickness' : null,
                'labelDataType' : 'date',
                'labelFormat'   : '%d %B',
                'labelRotation' : 0,
                'labelGap'      : 1
            });
            
            style.setStyle('legend', {
                'position'      : 'top',
                'align'         : 'right',
                'paddingRight'  : 0
            });
            
            chart.setStyles( {
                'leftAxisVisibility'    : 'visible',
                'paddingBottom'         : 24,
                'paddingLeft'           : 0,
                'paddingRight'          : 0,
                'paddingTop'            : 24
            });

            var tag:Tag = new Tag();
            tag.text = "非常高";
            tag.skin.statePrinter = new TagWithGuidePrinter();
            tag.locationY = 2.5;
            chart.addKeyValue(2.5);
            tag.setStyle('direction', 'right');
            tag.setStyle('color', '#94DA4F');
            chart.addCustomElement( tag );
            
            tag = new Tag();
            tag.text = "高";
            tag.skin.statePrinter = new TagWithGuidePrinter();
            tag.locationY = 2.40;
            chart.addKeyValue(2.40);
            tag.setStyle('direction', 'right');
            tag.setStyle('color', '#FF7300');
            chart.addCustomElement( tag );
            
            tag = new Tag();
            tag.text = "普通";
            tag.skin.statePrinter = new TagWithGuidePrinter();
            tag.locationY = 2.30;
            chart.addKeyValue(2.30);
            tag.setStyle('direction', 'right');
            tag.setStyle('color', '#43B0F8');
            chart.addCustomElement( tag );
            
            tag = new Tag();
            tag.text = "低";
            tag.skin.statePrinter = new TagWithGuidePrinter();
            tag.locationY = 2.10;
            chart.addKeyValue(2.10);
            tag.setStyle('direction', 'right');
            tag.setStyle('color', '#FF9999');
            chart.addCustomElement( tag );
            
            tag = new Tag();
            tag.text = "项目发布";
            tag.skin.statePrinter = new TagWithGuidePrinter();
            tag.locationX = 3;
            tag.setStyle('direction', 'up');
            tag.setStyle('color', '#FF0000');
            chart.addCustomElement( tag );
            
            //设置图表的尺寸，图表的主体将会显示在这个范围内
            chart.chartWidth = 500;
            chart.chartHeight = 250;
            
            addChild(chart);
            chart.state = ChartStates.NORMAL;
			
            stage.addChild( new Stats() );
            
        }
        
        
        
    }

}