package bee.chart.util 
{
    
	/**
    * 将FusionChart的配置转换成YID的配置
    * @author hua.qiuh
    */
    public class FusionConverter 
    {
        /**
        * 转换FusionChart的数据
        * @param	config
        * @return
        * 
        * -------------------------------------------------------------
        * ---- 单条数据 ---
        * -------------------------------------------------------------
        * <graph    yAxisName='Sales Figure' 
        *           caption='Top 5 Sales Person' 
        *           numberPrefix='$' 
        *           decimalPrecision='1' 
        *           divlinedecimalPrecision='0' 
        *           limitsdecimalPrecision='0'>
        * 
        *           <set name='Alex' value='25000' color='AFD8F8'/> 
        *           <set name='Mark' value='35000' color='F6BD0F'/> 
        *           <set name='David' value='42300' color='8BBA00'/> 
        *           <set name='Graham' value='35300' color='FF8E46'/> 
        *           <set name='John' value='31300' color='008E8E'/> 
        * </graph>
        * -------------------------------------------------------------
        * 
        * -------------------------------------------------------------
        * --- 多条数据 ---
        * 
        * <graph  caption="Product Sales" 
        *       xAxisName="Month" 
        *       yAxisName="Sales" 
        *       numberPrefix="$" 
        *       canvasBaseColor="F3D6D0" 
        *       canvasBgColor="E8D9D3" 
        *       divlinecolor="D49B8B" 
        *       limitsDecimalPrecision='0' 
        *       divLineDecimalPrecision='1'>
        * 
        *   <categories>
        *       <category name="January"/>
        *       <category name="February"/>
        *       <category name="March"/>
        *       <category name="April"/>
        *       <category name="May"/>
        *       <category name="June"/>
        *   </categories>
        * 
        *   <dataset seriesname="Product A" color="F0807F" showValues="1">
        *       <set value="8343"/>
        *       <set value="6983"/>
        *       <set value="7658"/>
        *       <set value="8345"/>
        *       <set value="8195"/>
        *       <set value="7684"/>
        *   </dataset>
        * 
        *   <dataset seriesname="Product B" color="F1C7D2" showValues="1">
        *       <set value="2446"/>
        *       <set value="3935"/>
        *       <set value="3452"/>
        *       <set value="4424"/>
        *       <set value="4925"/>
        *       <set value="4328"/>
        *   </dataset>
        * 
        * </graph>
        * -------------------------------------------------------------
        * 
        */
        static public function convertXML(config:XML):XML
        {
            if(config.dataset.length()){
                return convertMultiSet(config);
            }
            return convertSingleSet(config);
        }
    
        /**
        * 转换配置格式
        * @param	config FusionChart配置
        * @return   YID配置
        */
        static private function convertMultiSet(config:XML):XML
        {
            var output:XML = 
                <chart>
                    <data>
                        <indexAxis />
                        <valueAxis />
                        
                        <dataSets>
                        <!--
                            <set>
                                <name></name>
                                <desc></desc>
                                <values></values>
                                <style></style>
                            </set>
                        -->
                        </dataSets>
                    </data>
                    <css></css>
                </chart>;
                
            var labels:XMLList = config.categories.category.@name;
            var labelStrs:Vector.<String> = new Vector.<String>();
            for each(var label:String in labels) {
                labelStrs.push(label);
            }
            output.data.indexAxis.@name = config.@xAxisName;
            output.data.indexAxis.labels = labelStrs.join(',');
            output.data.valueAxis.@name = config.@yAxisName;
            
            var dSet:XML;
            var values:Vector.<Number>;
            var item:XML;
            var style:XML;
            var outSets:XML = output.data.dataSets[0];
            
            if(config.dataset.length()){
                for each(var dataset:XML in config.dataset) {
                    values = new Vector.<Number>();
                    for each(var value:XML in dataset.set) {
                        values.push(parseFloat(value.@value));
                    }
                    dSet = 
                        <set name={dataset.@seriesName + dataset.@seriesname}>
                            <values>{values.join(',')}</values>
                            <style></style>
                        </set>;
                    style = dSet.style[0];
                    style.appendChild(<item name="color" value={'#'+dataset.@color} />);
                    outSets.appendChild(dSet);
                }
            }
            
            return output;
        }
        
        static private function convertSingleSet(config:XML):XML
        {
            var output:XML = 
                <chart>
                    <data>
                        <indexAxis />
                        <valueAxis />
                        
                        <dataSets>
                        <!--
                            <set>
                                <name></name>
                                <desc></desc>
                                <values></values>
                                <style></style>
                            </set>
                        -->
                        </dataSets>
                    </data>
                    <css></css>
                </chart>;
                
            var labels:XMLList = config..set.@name;
            var labelStrs:Vector.<String> = new Vector.<String>();
            for each(var label:String in labels) {
                labelStrs.push(label);
            }
            output.data.indexAxis.@name = config.@xAxisName;
            output.data.indexAxis.labels = labelStrs.join(',');
            output.data.valueAxis.@name = config.@yAxisName;
            
            var dSet:XML;
            var values:Vector.<Number> = new Vector.<Number>();
            var item:XML;
            var style:XML;
            var outSets:XML = output.data.dataSets[0];
            
            if(config.@xAxisName.length()){
                for each(var valueSet:XML in config..set) {
                    values.push(Number(valueSet.@value));
                }
                dSet = <set>
                        <values>{values.join(',')}</values>
                        <style></style>
                    </set>;
                outSets.appendChild(dSet);
                return output;
            }
            
            for each(var dataset:XML in config..set) {
                dSet = 
                    <set name={dataset.@name}>
                        <values>{dataset.@value}</values>
                        <style></style>
                    </set>;
                style = dSet.style[0];
                style.appendChild(<item name="color" value={'#'+dataset.@color} />);
                outSets.appendChild(dSet);
            }
            
            return output;
        }
        
    }

}