package bee.chart.abstract 
{
    import flash.utils.Dictionary;
	/**
    * ...
    * @author hua.qiuh
    */
    public class Group 
    {
        private var _name:String = "";
        private var _items:Vector.<Object> = new Vector.<Object>();
        
        public var itemType:String;
        
        public function Group(enforcer:Enforcer, name:String) 
        {
            _name = name;
        }
        
        /**
        * 添加一个元素到群组内
        * 
        * @param	item    将要添加的元素
        * @return   添加是否成功。
        */
        public function addItem(item:*):Boolean
        {
            if(item != null){
                if (!contains(item)) {
                    _items.push(item);
                    return true;
                }
            }
            return false;
        }
        
        /**
        * 
        * @param	item
        * @param	loc
        * @return
        */
        public function addItemAt(item:*, loc:uint):Boolean
        {
            if(item != null){
                if (!contains(item)) {
                    _items.splice(loc, 0, item);
                    return true;
                }
            }
            return false;
        }
        
        /**
        * 
        * @param	item
        * @return
        */
        public function removeItem(item:*):*
        {
            var idx:int = _items.indexOf(item);
            if (idx != -1) {
                return _items.splice(idx, 1)[0];
            }
            return null;
        }
        
        /**
        * 
        */
        public function clear():void
        {
            _items.length = 0;
        }
        
        /**
        * 
        * @param	item
        * @return
        */
        public function contains(item:*):Boolean
        {
            return _items.indexOf(item) != -1;
        }
        
        /**
        * 
        * @param	index
        * @return
        */
        public function getItemAt(index:uint):*
        {
            if (index > _items.length -1) return null;
            return _items[index];
        }
        
        public function dispose():void
        {
            disposeGroup(name);
        }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Getters & Setters
        
        /**
        * 
        */
        public function get count():uint
        {
            return _items.length;
        }
        
        /**
        * 
        */
        public function get items():Vector.<Object>
        {
            return _items;
        }
        
        public function get name():String { return _name; }
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // Static Methods
        
        static private var _groups:Vector.<Group> = new Vector.<Group>();
        static public function get all():Vector.<Group>
        {
            return _groups;
        }
        
        /**
        * 获取某种类型的所有Group
        * @param	itemType
        * @return
        */
        static public function filter(itemType:String):Vector.<Group>
        {
            return _groups.filter(function(grp:Group, ...args):Boolean {
                return grp.itemType === itemType;
            });
        }
        
        static public function create(name:String, itemType:String=null):Group
        {
            if (dict[name]) {
                return dict[name];
            }
            var grp:Group = new Group(new Enforcer(), name);
            if (itemType) {
                grp.itemType = itemType;
            }
            dict[name] = grp;
            _groups.push(grp);
            return grp;
        }
        
        static public function disposeGroup(name:String):void
        {
            var group:Group = getGroup(name);
            if (group) {
                group.clear();
                delete dict[name];
                var idx:int = _groups.indexOf(group);
                if (idx != -1) {
                    _groups.splice(idx, 1);
                }
            }
        }
        
        static public function addItemIntoGroup(item:*, groupName:String):Boolean
        {
            var group:Group = create(groupName);
            return group.addItem(item);
        }
        
        static public function removeItemFromGroup(item:*, groupName:String):*
        {
            var group:Group = getGroup(groupName);
            if (group) {
                return group.removeItem(item);
            }
            return false;
        }
        
        static public function isItemInGroup(item:*, groupName:String):Boolean 
        {
            return getGroup(groupName).contains(item);
        }
        
        static private var dict:Dictionary = new Dictionary(true);
        static public function getGroup(groupName:String):Group
        {
            return dict[groupName];
        }
        
        static public function disposeAll():void
        {
            for (var each:String in dict) {
                disposeGroup(each);
            }
            _groups.length = 0;
        }
        
        
        
        
    }

}

class Enforcer {}