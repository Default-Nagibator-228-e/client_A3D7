package forms.zad
{
   import alternativa.init.Main;
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
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import forms.events.PartsListEvent;
   
   public class PartsList extends Sprite
   {
      
	  [Embed(source="ch/pp.png")]
		private static const pp:Class;
		
	  [Embed(source="ch/mi.png")]
		private static const mi:Class;
		
		[Embed(source="ch/zz.png")]
		private static const zz:Class;
		
		[Embed(source="ch/zg.png")]
		private static const zg:Class;
		
		[Embed(source="ch/hz.png")]
		private static const hz:Class;
	   
      public static const NOT_TANK_PART:int = 4;
      
      public static const WEAPON:int = 1;
      
      public static const ARMOR:int = 2;
      
      public static const COLOR:int = 3;
      
      public static const PLUGIN:int = 5;
	  
      private static const MIN_POSIBLE_SPEED:Number = 20;
      
      private static const MAX_DELTA_FOR_SELECT:Number = 3;
      
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
	  
	  public var fds:int = 0;
	  
	  public var fds1:int = 0;
	  
	  public var part:int = 1;
	  
	  public var prem:Boolean = false;
	  
	  public var parts:int = 1;
	  
	  private var tim:Timer = new Timer(1000);
      
      public function PartsList()
      {
         this.typeSort = [1,2,3,4,0];
         super();
         this.dp = new DataProvider();
         this.list = new TileList();
         this.list.dataProvider = this.dp;
         this.list.rowCount = 1;
         this.list.rowHeight = 162;
         this.list.columnWidth = 196;
         this.list.setStyle("cellRenderer",PartsListRenderer);
         this.list.direction = ScrollBarDirection.HORIZONTAL;
         this.list.focusEnabled = false;
         this.list.horizontalScrollBar.focusEnabled = false;
         addChild(this.list);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         this.confScroll();
		 addEventListener(Event.ADDED_TO_STAGE,this.addListeners);
         addEventListener(Event.REMOVED_FROM_STAGE, this.killLists);
      }
	  
	  private function onMouseDown(param1:MouseEvent) : void
      {
         this.scrollSpeed = 0;
         var _loc2_:Rectangle = this.list.horizontalScrollBar.getBounds(stage);
         _loc2_.top = _loc2_.top - ADDITIONAL_SCROLL_AREA_HEIGHT;
         if(!_loc2_.contains(param1.stageX,param1.stageY))
         {
            this.sumDragWay = 0;
            this.previousPositionX = this.currrentPositionX = param1.stageX;
            this.currentTime = this.previousTime = getTimer();
            //this.lastItemIndex = this.list.selectedIndex;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
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
         param1.updateAfterEvent();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         var _loc2_:Number = (getTimer() - this.previousTime) / 1000;
         if(_loc2_ == 0)
         {
            _loc2_ = 0.1;
         }
         var _loc3_:Number = param1.stageX - this.previousPositionX;
         this.scrollSpeed = _loc3_ / _loc2_;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
	  
	  private function onEnterFrame(param1:Event) : void
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
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
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
         addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
		 try{
			 tim.start();
		 }catch (e:Error){
		 }
      }
      
      private function killLists(e:Event) : void
      {
		 removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         removeEventListener(MouseEvent.MOUSE_WHEEL, this.scrollList);
		 removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
		 try{
			 tim.stop();
		 }catch (e:Error){
		 }
      }
	  
	  public function addItem(id:Object, name:String, type:int, sort:int, count:int, preview:String, id1:Object, name1:String, type1:int, sort1:int, count1:int, preview1:String) : void
      {
			 var loader:Loader = new Loader();
			 var data:Object = {};
			 var data1:Object = {};
			 data.id = id;
			 data.name = name;
			 data.type = type;
			 data.typeSort = typeSort[type];
			 data.count = count;
			 data.sort = sort;
			 data1.id = id1;
			 data1.name = name1;
			 data1.type = type1;
			 data1.typeSort = typeSort[type1];
			 data1.count = count1;
			 data1.sort = sort1;
			 data.par = parts;
			 data1.par = parts;
			 ++parts;
			 loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void
			 {
				data.preview = (loader.content as Bitmap).bitmapData;
				var loader1:Loader = new Loader();
				 loader1.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event1:Event):void
				 {
					data1.preview = (loader1.content as Bitmap).bitmapData;
					addI(data,data1);
				 });
				 loader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e1:IOErrorEvent):void
				 {
					//Main.debug.showAlert("Coun\'t load resouce: " + preview1);
				 });
				 loader1.load(new URLRequest(preview1));
			 });
			 loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
			 {
				//Main.debug.showAlert("Coun\'t load resouce: " + preview);
			 });
			 loader.load(new URLRequest(preview));
      }
      
      private function addI(data:Object,data1:Object) : void
      {
         var iNormal:DisplayObject = null;
         var iSelected:DisplayObject = null;
         var access:Boolean = false;
		 var mia:Bitmap = new mi();
		 var typrl:Label = new Label();
		 var d:Sprite = new Sprite();
		 var d1:Sprite = new Sprite();
		 //d.addChild(mia);
		 if (data.par == part)
			 {
				d.addChild(mia);
				tim.addEventListener(TimerEvent.TIMER,function(e:Event) : void
				  {
						mia.visible = !mia.visible;
						d.alpha = mia.visible ? 1:0.75;
						tim.start();
				  });
				tim.start();
			 }
		 if (data.par<part)
		 {
			 d.addChild(mia);
		 }else{
			 d.graphics.clear();
			 d.graphics.lineStyle(1, 0x78b851,0.25);
			 d.graphics.drawRoundRect(1, 1, mia.width - 1, mia.height - 1, 6, 6);
			 d1.graphics.clear();
			 d1.graphics.beginFill(0x102e12);
			 d1.graphics.drawRoundRect(1, 1, mia.width - 1, mia.height - 1, 6, 6);
		 }
		 var ob:DisplayObject = this.myIcon(data, false);
		 var ob1:DisplayObject = this.pmyIcon(data1, false);
		 ob.x = 3.5;
		 ob.y = fds - 0.5;
		 d.addChild(ob);
		 ob1.x = 3.5;
		 ob1.y = ob.y + fds1 + 3;
		 d.addChild(ob1);
		 typrl.color = 0x12ff00;
		 typrl.text = data.par + " Уровень";
		 typrl.x = ob.width / 2 - typrl.textWidth / 1.25;
		 typrl.y = fds / 2 - typrl.height / 1.4;
		 typrl.size = 20;
		 d.addChild(typrl);
		 d.alpha = 0.75;
		 d1.addChild(d);
         iNormal = d1;
         iSelected = d1;
         this.dp.addItem({
            "iconNormal":iNormal,
            "iconSelected":iSelected,
            "dat":data,
            "accessable":access,
            "type":data.type,
            "typesort":data.typeSort,
            "par":data.par
         });
         this.dp.sort(sorting);
      }
	  
	  private function sorting(a:Object,b:Object) : int
      {
         return int(a.par) - int(b.par);
      }
      
      private function update(id:Object, param:String, value:* = null) : void
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
         iNormal = this.myIcon(data,false);
         iSelected = this.myIcon(data,true);
         obj.dat = data;
         obj.iconNormal = iNormal;
         obj.iconSelected = iSelected;
         this.dp.replaceItemAt(obj,index);
		 this.dp.sort(sorting);
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
         var obj:Object = this.dp.getItemAt(index);
         if(this.list.selectedIndex == index)
         {
            this._selectedItemID = null;
            this.list.selectedItem = null;
         }
         this.dp.removeItem(obj);
      }
      
      public function scrollTo(id:Object) : void
      {
         var index:int = this.indexById(id);
         this.list.scrollToIndex(index);
      }
	  
	  private function pmyIcon(data:Object, select:Boolean) : DisplayObject
      {
         var bmp:BitmapData = null;
		 var ppa:Bitmap = new pp();
         var prv:Bitmap = null;
		 var pi:Bitmap = null;
         var icon:Sprite = new Sprite();
         var cont:Sprite = new Sprite();
         var name:Label = new Label();
         var count:Label = new Label();
         var iconInventory:InventoryIcon = new InventoryIcon(data.sort,true);
         if(data.preview != null)
         {
            prv = new Bitmap(data.preview);
            prv.x = ppa.width/2 - prv.width/2;
            prv.y = ppa.height/2 - prv.height/2;
            cont.addChild(prv);
			prv.smoothing = true;
         }
         data.installed = false;
        cont.addChild(count);
        count.x = 6;
        iconInventory.x = 6;
        iconInventory.y = 84;
        count.autoSize = TextFieldAutoSize.NONE;
        count.size = 16;
        count.align = TextFormatAlign.LEFT;
        count.width = 100;
        count.height = 25;
        count.text = (data.count == 0 || data.count == 1)?" ":"×" + int(data.count);
		count.y = ppa.height - count.textHeight - 6;
		 count.color = name.color = 16777215;
         name.text = data.name;
         name.y = 2;
         name.x = 3;
		 pi = (parts <= part && prem) ? new zg() : new hz();
		 pi.x = ppa.width - pi.width - 6;
		 pi.y = 4;
		 cont.addChild(pi);
         cont.addChildAt(ppa,0);
         cont.addChild(name);
         bmp = new BitmapData(cont.width,cont.height,true,0);
         bmp.draw(cont);
         icon.addChildAt(new Bitmap(bmp),0);
         return icon;
      }
      
      private function myIcon(data:Object, select:Boolean) : DisplayObject
      {
         var bmp:BitmapData = null;
         var bg:GarageItemBackground = null;
		 var ppa:Bitmap = new pp();
		 var pi:Bitmap = null;
         var prv:Bitmap = null;
         var icon:Sprite = new Sprite();
         var cont:Sprite = new Sprite();
         var name:Label = new Label();
         var count:Label = new Label();
         var iconInventory:InventoryIcon = new InventoryIcon(data.sort,true);
         if(data.preview != null)
         {
            prv = new Bitmap(data.preview);
			prv.width *= 0.75;
			prv.height *= 0.75;
			prv.x = ppa.width/2 - prv.width/2;
            prv.y = fds1 / 2 - prv.height / 2;
            cont.addChild(prv);
			prv.smoothing = true;
         }
		data.installed = false;
        cont.addChild(count);
        count.x = 6;
        iconInventory.x = 6;
        iconInventory.y = 84;
        count.autoSize = TextFieldAutoSize.NONE;
        count.size = 16;
        count.align = TextFormatAlign.LEFT;
        count.width = 100;
        count.height = 25;
        count.text = (data.count == 0 || data.count == 1)?" ":"×" + int(data.count);
		count.y = fds1 - count.textHeight - 6;
         bg = new GarageItemBackground(9);
		 bg.width = ppa.width;
		 bg.height = fds1;
		 count.color = name.color = 0x7fa362;
         name.text = data.name;
         name.y = 2;
         name.x = 3;
		 pi = parts <= part ? new zg() : new zz();
		 pi.x = bg.width - pi.width - 6;
		 pi.y = 4;
		 cont.addChild(pi);
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
      
      private function scrollList(e:MouseEvent) : void
      {
         this.list.horizontalScrollPosition = this.list.horizontalScrollPosition - e.delta * (Boolean(Capabilities.os.search("Linux") != -1)?50:10);
      }
   }
}
