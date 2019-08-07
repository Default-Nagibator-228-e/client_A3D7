package forms.garage
{
   import assets.Diamond;
   import assets.icons.GarageItemBackground;
   import assets.icons.IconGarageMod;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.InventoryIcon;
   import controls.Label;
   import controls.rangicons.RangIconNormal;
   import fl.controls.ScrollBarDirection;
   import fl.controls.TileList;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import forms.events.PartsListEvent;
   
   public class PartsList extends Sprite
   {
      
      public static const NOT_TANK_PART:int = 4;
      
      public static const WEAPON:int = 1;
      
      public static const ARMOR:int = 2;
      
      public static const COLOR:int = 3;
      
      public static const PLUGIN:int = 5;
	  
      private static const MIN_POSIBLE_SPEED:Number = 20;
      
      private static const MAX_DELTA_FOR_SELECT:Number = 7;
      
      private static const ADDITIONAL_SCROLL_AREA_HEIGHT:Number = 3; 
      
      private var list:TileList;
      
      private var dp:DataProvider;
      
      private var typeSort:Array;
      
      private var _selectedItemID:Object = null;
	  
	  private var previousPositionX:Number;
      
      private var currrentPositionX:Number;
      
      private var sumDragWay:Number;
      
      private var lastItemIndex:int;
      
      private var previousTime:int;
      
      private var currentTime:int;
      
      private var scrollSpeed:Number = 0;
      
      private var _width:int;
      
      private var _height:int;
      
      public function PartsList()
      {
         this.typeSort = [1,2,3,4,0];
         super();
         this.dp = new DataProvider();
         this.list = new TileList();
         this.list.dataProvider = this.dp;
         this.list.addEventListener(ListEvent.ITEM_CLICK,this.selectItem);
         this.list.rowCount = 1;
         this.list.rowHeight = 130;
         this.list.columnWidth = 203;
         this.list.setStyle("cellRenderer",PartsListRenderer);
         this.list.direction = ScrollBarDirection.HORIZONTAL;
         this.list.focusEnabled = false;
         this.list.horizontalScrollBar.focusEnabled = false;
         addChild(this.list);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         this.confScroll();
		 addEventListener(Event.ADDED_TO_STAGE,this.addListeners);
         addEventListener(Event.REMOVED_FROM_STAGE,this.killLists);
      }
	  
	  private function onMouseDown1(param1:MouseEvent) : void
      {
         this.scrollSpeed = 0;
         var _loc2_:Rectangle = this.list.horizontalScrollBar.getBounds(stage);
         _loc2_.top = _loc2_.top - ADDITIONAL_SCROLL_AREA_HEIGHT;
         if(!_loc2_.contains(param1.stageX,param1.stageY))
         {
            this.sumDragWay = 0;
            this.previousPositionX = this.currrentPositionX = param1.stageX;
            this.currentTime = this.previousTime = getTimer();
            this.lastItemIndex = this.list.selectedIndex;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp1);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove1);
         }
      }
      
      private function onMouseMove1(param1:MouseEvent) : void
      {
         this.previousPositionX = this.currrentPositionX;
         this.currrentPositionX = param1.stageX;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var _loc2_:Number = this.currrentPositionX - this.previousPositionX;
         this.sumDragWay = this.sumDragWay + Math.abs(_loc2_);
         if(this.sumDragWay > MAX_DELTA_FOR_SELECT)
         {
            this.list.horizontalScrollPosition = this.list.horizontalScrollPosition - _loc2_;
         }
         //param1.updateAfterEvent();
		 //addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
      }
      
      private function onMouseUp1(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove1);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp1);
         var _loc2_:Number = (getTimer() - this.previousTime) / 1000;
         if(_loc2_ == 0)
         {
            _loc2_ = 0.1;
         }
         var _loc3_:Number = param1.stageX - this.previousPositionX;
         this.scrollSpeed = _loc3_ / _loc2_;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
      }
	  
	  private function onEnterFrame1(param1:Event) : void
      {
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var _loc2_:Number = (this.currentTime - this.previousTime) / 1000;
         this.list.horizontalScrollPosition = this.list.horizontalScrollPosition - this.scrollSpeed * _loc2_;
         var _loc3_:Number = this.list.horizontalScrollPosition;
         var _loc4_:Number = this.list.maxHorizontalScrollPosition;
         if(Math.abs(this.scrollSpeed) > MIN_POSIBLE_SPEED && 0 < _loc3_ && _loc3_ < _loc4_)
         {
            this.scrollSpeed = this.scrollSpeed * Math.exp(-1.5 * _loc2_);
         }
         else
         {
            this.scrollSpeed = 0;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         }
      }
      
      public function get selectedItemID() : Object
      {
         return this._selectedItemID;
      }
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         this.list.width = this._width;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(value:Number) : void
      {
         this._height = int(value);
         this.list.height = this._height;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
	  
	  private function addListeners(param1:Event) : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown1);
      }
      
      private function killLists(e:Event) : void
      {
		 removeEventListener(Event.ENTER_FRAME,this.onEnterFrame1);
         this.list.removeEventListener(ListEvent.ITEM_CLICK,this.selectItem);
         removeEventListener(MouseEvent.MOUSE_WHEEL, this.scrollList);
		 removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown1);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp1);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove1);
      }
      
      public function addItem(id:Object, name:String, type:int, sort:int, crystalPrice:int, rang:int, installed:Boolean, garageElement:Boolean, count:int, preview:BitmapData, sto:Boolean, modification:int = 0) : void
      {
         var iNormal:DisplayObject = null;
         var iSelected:DisplayObject = null;
         var data:Object = {};
         var access:Boolean = rang < 1 && !garageElement;
         data.id = id;
         data.name = name;
         data.type = type;
         data.typeSort = this.typeSort[type];
         data.mod = modification;
         data.crystalPrice = crystalPrice;
         data.rang = garageElement?-1:rang;
         data.installed = installed;
         data.garageElement = garageElement;
         data.count = count;
         data.preview = preview;
         data.sort = sort;
		 data.sto = sto;
         iNormal = this.myIcon(data,false,sto);
         iSelected = this.myIcon(data, true, sto);
         this.dp.addItem({
            "iconNormal":iNormal,
            "iconSelected":iSelected,
            "dat":data,
            "accessable":access,
            "rang":data.rang,
            "type":type,
			"sto":sto,
            "typesort":data.typeSort,
            "sort":sort
         });
         this.dp.sortOn(["sto","accessable","rang","typesort","sort"],[Array.DESCENDING,Array.DESCENDING,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
      }
      
      public function update(id:Object, param:String, value:* = null) : void
      {
         var iNormal:DisplayObject = null;
         var iSelected:DisplayObject = null;
         var index:int = this.indexById(id);
		 if (index == -1)
		 {
			 return;
		 }
         var obj:Object = this.dp.getItemAt(index);
         var data:Object = obj.dat;
         data[param] = value;
         iNormal = this.myIcon(data,false,data.sto);
         iSelected = this.myIcon(data,true,data.sto);
         obj.dat = data;
         obj.iconNormal = iNormal;
         obj.iconSelected = iSelected;
         this.dp.replaceItemAt(obj,index);
         this.dp.sortOn(["sto","accessable","rang","typesort","sort"],[Array.DESCENDING,Array.DESCENDING,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
         this.dp.invalidateItemAt(index);
      }
	  
	  public function update1(id:Object) : void
      {
         var iNormal:DisplayObject = null;
         var iSelected:DisplayObject = null;
         var index:int = this.indexById(id);
		 if (index == -1)
		 {
			 return;
		 }
         var obj:Object = this.dp.getItemAt(index);
         var data:Object = obj.dat;
         data.sto = true;
		 data.garageElement = true;
         iNormal = this.myIcon(data,false,data.sto);
         iSelected = this.myIcon(data,true,data.sto);
         obj.dat = data;
         obj.iconNormal = iNormal;
         obj.iconSelected = iSelected;
         //this.dp.replaceItemAt(obj,index);
		 deleteItem(id);
		 this.dp.addItem({
            "iconNormal":iNormal,
            "iconSelected":iSelected,
            "dat":data,
            "accessable":data.rang < 1 && !data.garageElement,
            "rang":data.rang,
            "type":data.type,
			"sto":data.sto,
            "typesort":data.typeSort,
            "sort":data.sort
         });
         this.dp.sortOn(["sto","accessable","rang","typesort","sort"],[Array.DESCENDING,Array.DESCENDING,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
         //this.dp.invalidateItemAt(index);
      }
      
      public function lock(id:Object) : void
      {
         this.update(id,"accessable",true);
      }
      
      public function unlock(id:Object) : void
      {
         this.update(id,"accessable",false);
      }
      
      public function mount(id:Object) : void
      {
         this.update(id,"installed",true);
      }
      
      public function unmount(id:Object) : void
      {
         this.update(id,"installed",false);
      }
      
      public function updateCondition(id:Object, value:int) : void
      {
         this.update(id,"condition",value);
      }
      
      public function updateCount(id:Object, value:int) : void
      {
         this.update(id,"count",value);
      }
      
      public function updateModification(id:Object, value:int) : void
      {
         this.update(id,"mod",value);
      }
	  
	  public function deleteaItem() : void
      {
		  dp = new DataProvider();
		  /*
         for (var index:int = 0; index < this.dp.length; index++)
		 {
			 var obj:Object = this.dp.getItemAt(index);
			 if(this.list.selectedIndex == index)
			 {
				this._selectedItemID = null;
				this.list.selectedItem = null;
			 }
			 this.dp.removeItem(obj);
		 }*/
      }
      
      public function deleteItem(id:Object) : void
      {
         var index:int = this.indexById(id);
		 if (index < 0)
		 {
			return;
		 }
         var obj:Object = this.dp.getItemAt(index);
         if(this.list.selectedIndex == index)
         {
            this._selectedItemID = null;
            this.list.selectedItem = null;
         }
         this.dp.removeItem(obj);
      }
      
      public function select(id:Object) : void
      {
         var index:int = this.indexById(id);
         this.list.selectedIndex = index;
         this._selectedItemID = id;
         dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
      }
      
      public function selectByIndex(index:uint) : void
      {
         var obj:Object = (this.dp.getItemAt(index) as Object).dat;
         this.list.selectedIndex = index;
         this._selectedItemID = obj.id;
         dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
      }
      
      public function scrollTo(id:Object) : void
      {
         var index:int = this.indexById(id);
         this.list.scrollToIndex(index);
      }
      
      public function unselect() : void
      {
         this._selectedItemID = null;
         this.list.selectedItem = null;
      }
      
      private function myIcon(data:Object, select:Boolean, h:Boolean) : DisplayObject
      {
         var bmp:BitmapData = null;
         var bg:GarageItemBackground = null;
         var itemName:String = null;
         var prv:Bitmap = null;
         var rangIcon:RangIconNormal = null;
         var icon:Sprite = new Sprite();
         var cont:Sprite = new Sprite();
         var name:Label = new Label();
         var c_price:Label = new Label();
         var count:Label = new Label();
         var diamond:Diamond = new Diamond();
         var iconMod:IconGarageMod = new IconGarageMod(data.mod);
         var iconInventory:InventoryIcon = new InventoryIcon(data.sort,true);
         if(data.preview != null)
         {
            prv = new Bitmap(data.preview);
            prv.x = 19;
            prv.y = 18;
            cont.addChild(prv);
         }
         if(data.rang > 0 && !data.garageElement || data.accessable)
         {
            rangIcon = new RangIconNormal(data.rang);
            itemName = "OFF";
            data.installed = false;
            rangIcon.x = 135;
            rangIcon.y = 60;
            if(data.type != PLUGIN)
            {
               cont.addChild(rangIcon);
            }
            count.color = c_price.color = name.color = 12632256;
			bg = new GarageItemBackground(select ? 2:0);
         }
         else
         {
			if(data.garageElement)
            {
				count.color = c_price.color = name.color = 0xaad18e;
				bg = new GarageItemBackground(data.installed ? (select ? 6:5):(select ? 10:9));
            }else{
				count.color = c_price.color = name.color = 5898034;
				bg = new GarageItemBackground(select ? 8:7);
			}
            switch(data.type)
            {
               case WEAPON:
                  if(data.garageElement)
                  {
                     cont.addChild(iconMod);
                     iconMod.x = 159;
                     iconMod.y = 7;
                  }
                  itemName = "GUN";
                  break;
               case ARMOR:
                  if(data.garageElement)
                  {
                     cont.addChild(iconMod);
                     iconMod.x = 159;
                     iconMod.y = 7;
                  }
                  itemName = "SHIELD";
                  break;
               case COLOR:
                  itemName = "COLOR";
                  break;
               case NOT_TANK_PART:
                  itemName = "ENGINE";
                  data.installed = false;
                  cont.addChild(count);
                  count.x = 90;
                  count.y = 100;
                  iconInventory.x = 6;
                  iconInventory.y = 84;
                  count.autoSize = TextFieldAutoSize.NONE;
                  count.size = 16;
                  count.align = TextFormatAlign.RIGHT;
                  count.width = 100;
                  count.height = 25;
                  count.text = data.count == 0?" ":"×" + String(data.count);
                  break;
               case PLUGIN:
                  itemName = "PLUGIN";
            }
         }
         itemName = itemName + ((Boolean(data.installed)?"_INSTALLED":"_NORMAL") + (select?"_SELECTED":""));
         name.text = data.name;
         if(!data.garageElement || data.type == NOT_TANK_PART)
         {
            if(data.crystalPrice > 0)
            {
               c_price.text = String(data.crystalPrice);
               c_price.x = 181 - c_price.textWidth;
               c_price.y = 2;
               cont.addChild(diamond);
               cont.addChild(c_price);
               diamond.x = 186;
               diamond.y = 6;
            }
         }
         name.y = 2;
         name.x = 3;
         cont.addChildAt(bg,0);
         cont.addChild(name);
         bmp = new BitmapData(cont.width,cont.height,true,0);
         bmp.draw(cont);
         icon.addChildAt(new Bitmap(bmp),0);
         return icon;
      }
      
      private function confScroll() : void
      {
         this.list.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.list.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.list.setStyle("trackUpSkin",ScrollTrackGreen);
         this.list.setStyle("trackDownSkin",ScrollTrackGreen);
         this.list.setStyle("trackOverSkin",ScrollTrackGreen);
         this.list.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.list.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
      }
      
      private function indexById(id:Object) : int
      {
         var obj:Object = null;
         for(var i:int = 0; i < this.dp.length; i++)
         {
            obj = this.dp.getItemAt(i);
            if(obj.dat.id == id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function selectItem(e:ListEvent) : void
      {
         var obj:Object = null;
         obj = e.item;
         this._selectedItemID = obj.dat.id;
         this.list.selectedItem = obj;
         this.list.scrollToSelected();
         dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
      }
      
      private function scrollList(e:MouseEvent) : void
      {
         this.list.horizontalScrollPosition = this.list.horizontalScrollPosition - e.delta * (Boolean(Capabilities.os.search("Linux") != -1)?50:10);
      }
   }
}
