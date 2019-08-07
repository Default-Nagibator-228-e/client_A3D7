package forms.battlelist
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.cellrenderer.battlelist.Abris;
   import assets.cellrenderer.battlelist.PaydIcon;
   import assets.icons.BattleInfoIcons;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import fl.controls.List;
   import fl.controls.ScrollBar;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import forms.TankWindowWithHeader;
   import forms.events.BattleListEvent;
   
   public class ViewBattleList extends Sprite
   {
       
      
      private var mainBackground:TankWindowWithHeader;
      
      private var inner:TankWindowInner;
      
      private var format:TextFormat;
      
      private var battleList:List;
      
      private var dp:DataProvider;
	  
	  private var dp1:DataProvider = new DataProvider();
      
      private var _selectedBattleID:Object;
      
      private var delayTimer:Timer;
      
      private var iconWidth:int = 100;
      
      private var onStage:Boolean = false;
      
      public var createButton:DefaultButton;
      
      private var oldIconWidth:int = 0;
	  
	  private var ut:DefaultButton = new DefaultButton();
	  
	  private var ut1:DefaultButton = new DefaultButton();
	  
	  private var ut2:DefaultButton = new DefaultButton();
	  
	  private var ut3:DefaultButton = new DefaultButton();
	  
	  private var ut4:DefaultButton = new DefaultButton();
	  
	  [Embed(source="2.png")]
      private static const dm:Class;
	  
	  private var ffe:Bitmap = new dm();
	  
	  [Embed(source="3.png")]
      private static const tdm:Class;
	  
	  private var ffe1:Bitmap = new tdm();
	  
	  [Embed(source="4.png")]
      private static const ctf:Class;
	  
	  private var ffe2:Bitmap = new ctf();
	  
	  [Embed(source="6.png")]
      private static const cp:Class;
	  
	  private var ffe3:Bitmap = new cp();
	  
	  [Embed(source="5.png")]
      private static const ddm:Class;
	  
	  private var ffe4:Bitmap = new ddm();
	  
	  public static var bup:Sprite = new Sprite();
      
      public function ViewBattleList()
      {
         this.mainBackground = TankWindowWithHeader.createWindow("СПИСОК БИТВ");
         this.inner = new TankWindowInner(100,100,TankWindowInner.GREEN);
         this.format = new TextFormat("MyriadPro",13);
         this.battleList = new List();
         this.dp = new DataProvider();
         this.createButton = new DefaultButton();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addResizeListener);
         addEventListener(Event.REMOVED_FROM_STAGE, this.removeResizeListener);
		 bup.addEventListener("П",j);
      }
      
      public function get selectedBattleID() : Object
      {
         return this._selectedBattleID;
      }
      
      private function addResizeListener(e:Event) : void
      {
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onStage = true;
		 configUI();
      }
      
      private function removeResizeListener(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
         this.onStage = false;
      }
      
      private function configUI() : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         addChild(this.mainBackground);
         addChild(this.inner);
         this.inner.showBlink = true;
         this.battleList.rowHeight = 20;
         this.battleList.setStyle("cellRenderer",BattleListRenderer);
         this.battleList.dataProvider = this.dp1;
         this.battleList.addEventListener(ListEvent.ITEM_CLICK,this.selectItem);
         this.battleList.focusEnabled = true;
         this.confScroll();
         addChild(this.battleList);
         this.battleList.move(15,15);
         addChild(this.createButton);
         this.createButton.addEventListener(MouseEvent.CLICK,this.createGame);
         this.createButton.label = localeService.getText(TextConst.BATTLELIST_PANEL_BUTTON_CREATE);
         addChild(this.ut);
		 addChild(this.ut1);
		 addChild(this.ut2);
		 addChild(this.ut3);
		 addChild(this.ut4);
		 ut.addChild(ffe);
		 ut1.addChild(ffe1);
		 ut2.addChild(ffe2);
		 ut3.addChild(ffe3);
		 ut4.addChild(ffe4);
		 ut.width = ut.height;
		 ut1.width = ut.height;
		 ut2.width = ut.height;
		 ut3.width = ut.height;
		 ut4.width = ut.height;
		 //eg();
		 ffe.x = ((ut.width - ffe.width) * 0.5);
         ffe.y = (ut.height - ffe.height) * 0.5;
		 ffe1.x = ((ut1.width - ffe1.width) * 0.5)-1;
         ffe1.y = (ut1.height - ffe1.height) * 0.5;
		 ffe2.x = (ut2.width - ffe2.width) * 0.5;
         ffe2.y = (ut2.height - ffe2.height) * 0.5;
		 ffe3.x = ((ut3.width - ffe3.width) * 0.5)-1;
         ffe3.y = (ut3.height - ffe3.height) * 0.5;
		 ffe4.x = ((ut4.width - ffe4.width) * 0.5);
         ffe4.y = ((ut4.height - ffe4.height) * 0.5) + 1;
		 ut3.enable = false;
		 ut4.enable = false;
         this.inner.x = this.inner.y = 11;
		 ut.addEventListener(MouseEvent.CLICK, eg);
		 ut1.addEventListener(MouseEvent.CLICK, eg1);
		 ut2.addEventListener(MouseEvent.CLICK, eg2);
		 onResize();
      }
	  
	  private function j(param1:Event=null) : void
      {
		 this.dp1.removeAll();
		 //this.battleList.dataProvider = this.dp1;
		 //this.dp1.sortOn(["accessible", "id"], [Array.DESCENDING, Array.DESCENDING]);
		 //onResize();
		 for (var ge:int = 0; ge < dp.length; ge++)
		 {
			 if ((!ut.en1 && dp.getItemAt(ge).dat.type == "DM") || (!ut1.en1 && dp.getItemAt(ge).dat.type == "TDM") || (!ut2.en1 && dp.getItemAt(ge).dat.type == "CTF") || (ut.en1 && ut1.en1 && ut2.en1 && (dp.getItemAt(ge).dat.type == "DM"||dp.getItemAt(ge).dat.type == "TDM"||dp.getItemAt(ge).dat.type == "CTF")))
			 {
				this.dp1.addItem(dp.getItemAt(ge));
			 }
		 }
		 this.dp1.sortOn(["accessible", "id"], [Array.DESCENDING, Array.DESCENDING]);
		 this.battleList.dataProvider = this.dp1;
		 //onResize();
		 this.select(this._selectedBattleID);
	  }
	  
	  private function eg(e:MouseEvent = null) : void
      {
		 if (!ut.en1)
		 {
			//ut.enable = false;
			ut.enable = true;
		 }else{
			ut.en();
		 }
		 dp1.removeAll();
		 for (var ge:int = 0; ge < dp.length; ge++)
		 {
			 if ((!ut.en1 && dp.getItemAt(ge).dat.type == "DM") || (!ut1.en1 && dp.getItemAt(ge).dat.type == "TDM") || (!ut2.en1 && dp.getItemAt(ge).dat.type == "CTF") || (ut.en1 && ut1.en1 && ut2.en1 && (dp.getItemAt(ge).dat.type == "DM"||dp.getItemAt(ge).dat.type == "TDM"||dp.getItemAt(ge).dat.type == "CTF")))
			 {
				this.dp1.addItem(dp.getItemAt(ge));
			 }
		 }
		 this.dp1.sortOn(["accessible","id"],[Array.DESCENDING,Array.DESCENDING]);
      }
	  
	  private function eg1(e:MouseEvent = null) : void
      {
		 if (!ut1.en1)
		 {
			//ut1.enable = false;
			ut1.enable = true;
		 }else{
			ut1.en();
		 }
		 dp1.removeAll();
		 for (var ge:int = 0; ge < dp.length; ge++)
		 {
			 if ((!ut.en1 && dp.getItemAt(ge).dat.type == "DM") || (!ut1.en1 && dp.getItemAt(ge).dat.type == "TDM") || (!ut2.en1 && dp.getItemAt(ge).dat.type == "CTF") || (ut.en1 && ut1.en1 && ut2.en1 && (dp.getItemAt(ge).dat.type == "DM"||dp.getItemAt(ge).dat.type == "TDM"||dp.getItemAt(ge).dat.type == "CTF")))
			 {
				this.dp1.addItem(dp.getItemAt(ge));
			 }
		 }
		 this.dp1.sortOn(["accessible","id"],[Array.DESCENDING,Array.DESCENDING]);
      }
	  
	  private function eg2(e:MouseEvent = null) : void
      {
		 if (!ut2.en1)
		 {
			//ut2.enable = false;
			ut2.enable = true;
		 }else{
			ut2.en();
		 }
		 dp1.removeAll();
		 for (var ge:int = 0; ge < dp.length; ge++)
		 {
			 if ((!ut.en1 && dp.getItemAt(ge).dat.type == "DM") || (!ut1.en1 && dp.getItemAt(ge).dat.type == "TDM") || (!ut2.en1 && dp.getItemAt(ge).dat.type == "CTF") || (ut.en1 && ut1.en1 && ut2.en1 && (dp.getItemAt(ge).dat.type == "DM"||dp.getItemAt(ge).dat.type == "TDM"||dp.getItemAt(ge).dat.type == "CTF")))
			 {
				this.dp1.addItem(dp.getItemAt(ge));
			 }
		 }
		 this.dp1.sortOn(["accessible","id"],[Array.DESCENDING,Array.DESCENDING]);
      }
	  
	  public function addType(id:Object, type:String) : void
      {
         for (var ge:int = 0; ge < dp.length; ge++)
		 {
			 if (dp.getItemAt(ge).id == id)
			 {
				dp.getItemAt(ge).dat.type = type;
			 }
		 }
		 j()
      }
      
      private function confScroll() : void
      {
         var bar:ScrollBar = this.battleList.verticalScrollBar;
         this.battleList.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.battleList.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.battleList.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.battleList.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.battleList.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.battleList.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.battleList.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.battleList.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.battleList.setStyle("trackUpSkin",ScrollTrackGreen);
         this.battleList.setStyle("trackDownSkin",ScrollTrackGreen);
         this.battleList.setStyle("trackOverSkin",ScrollTrackGreen);
         this.battleList.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.battleList.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.battleList.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.battleList.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.battleList.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
      }
      
      private function createGame(e:MouseEvent) : void
      {
         this.battleList.selectedItem = null;
         dispatchEvent(new BattleListEvent(BattleListEvent.CREATE_GAME));
      }
      
      private function selectItem(e:ListEvent) : void
      {
         this._selectedBattleID = e.item.id;
         dispatchEvent(new BattleListEvent(BattleListEvent.SELECT_BATTLE));
      }
      
      private function getItem(id:Object, name:String, deathMatch:Boolean = true, reds:int = 0, blues:int = 0, all:int = 0, map:String = "", totalfull:Boolean = false, redful:Boolean = false, bluefull:Boolean = false, accessible:Boolean = true, closed:Boolean = false, type:String = "") : Object
      {
         var data:Object = new Object();
         var item:Object = new Object();
         data.gamename = name;
         data.id = id;
         data.dmatch = deathMatch;
         data.reds = reds;
         data.blues = blues;
         data.all = all;
         data.nmap = map;
         data.allfull = totalfull;
         data.redfull = redful;
         data.bluefull = bluefull;
         data.accessible = accessible;
         data.closed = closed;
		 data.type = type;
         item.id = id;
         item.accessible = accessible;
         item.iconNormal = this.myIcon(false,data);
         item.iconSelected = this.myIcon(true,data);
         item.dat = data;
         return item;
      }
      
      public function addItem(id:Object, name:String, deathMatch:Boolean = true, reds:int = 0, blues:int = 0, all:int = 0, map:String = "", totalfull:Boolean = false, redful:Boolean = false, bluefull:Boolean = false, accessible:Boolean = true, closed:Boolean = false, type:String = "") : void
      {
         var data:Object = new Object();
         var item:Object = new Object();
         var index:int = this.indexById(id);
         data.gamename = name;
         data.id = id;
         data.dmatch = deathMatch;
         data.reds = reds;
         data.blues = blues;
         data.all = all;
         data.nmap = map;
         data.allfull = totalfull;
         data.redfull = redful;
         data.bluefull = bluefull;
         data.accessible = accessible;
         data.closed = closed;
		 data.type = type;
         item.id = id;
         item.accessible = accessible;
         item.iconNormal = this.myIcon(false,data);
         item.iconSelected = this.myIcon(true,data);
         item.dat = data;
         if(index < 0)
         {
            this.dp.addItem(item);
            this.dp.sortOn(["accessible","id"],[Array.DESCENDING,Array.DESCENDING]);
         }
		 if(this.onStage)
         {
            this.onResize();
         }
		 j();
      }
      
      public function setBattleAccessibility(id:Object, accessible:Boolean) : void
      {
         var d:Object = null;
         var newItem:Object = null;
         var i:Object = new Object();
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            i = this.dp.getItemAt(index);
            d = i.dat;
            newItem = this.getItem(i.id,d.gamename,d.dmatch,d.reds,d.blues,d.all,d.nmap,d.allfull,d.redfull,d.bluefull,accessible,d.closed,d.type);
            this.dp.replaceItemAt(newItem,index);
            this.dp.invalidateItemAt(index);
         }
		 j();
      }
      
      public function updatePlayersTotal(id:Object, num:int, full:Boolean) : void
      {
         var d:Object = null;
         var newItem:Object = null;
         var i:Object = new Object();
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            i = this.dp.getItemAt(index);
            d = i.dat;
            newItem = this.getItem(i.id,d.gamename,d.dmatch,d.reds,d.blues,num,d.nmap,full,d.redfull,d.bluefull,d.accessible,d.closed,d.type);
            this.dp.replaceItemAt(newItem,index);
            this.dp.invalidateItemAt(index);
         }
		 j();
      }
      
      public function updatePlayersRed(id:Object, num:int, full:Boolean) : void
      {
         var d:Object = null;
         var newItem:Object = null;
         var i:Object = new Object();
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            i = this.dp.getItemAt(index);
            d = i.dat;
            newItem = this.getItem(i.id,d.gamename,d.dmatch,num,d.blues,d.all,d.nmap,d.allfull,full,d.bluefull,d.accessible,d.closed,d.type);
            this.dp.replaceItemAt(newItem,index);
            this.dp.invalidateItemAt(index);
         }
		 j();
      }
      
      public function updatePlayersBlue(id:Object, num:int, full:Boolean) : void
      {
         var d:Object = null;
         var newItem:Object = null;
         var i:Object = new Object();
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            i = this.dp.getItemAt(index);
            d = i.dat;
            newItem = this.getItem(i.id,d.gamename,d.dmatch,d.reds,num,d.all,d.nmap,d.allfull,d.redfull,full,d.accessible,d.closed,d.type);
            this.dp.replaceItemAt(newItem,index);
            this.dp.invalidateItemAt(index);
         }
		 j();
      }
      
      public function select(id:Object) : void
      {
         var index:int = this.indexById(id);
         if(index > -1)
         {
            this.battleList.selectedIndex = index;
            this.battleList.scrollToSelected();
            this._selectedBattleID = id;
         }
      }
      
      public function removeItem(id:Object) : void
      {
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            this.dp.removeItemAt(index);
         }
		 j();
      }
      
      private function indexById(id:Object) : int
      {
         var obj:Object = null;
         for(var i:int = 0; i < this.dp.length; i++)
         {
            obj = this.dp.getItemAt(i);
            if(obj.id == id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function myIcon(select:Boolean, data:Object) : Sprite
      {
         var icon:Bitmap = null;
         var tf:Label = null;
         var abris:Abris = null;
         var cont:Sprite = new Sprite();
         var shape:Shape = new Shape();
         var access:Boolean = data.accessible;
         var closed_icon:PaydIcon = new PaydIcon();
         var _width:int = this.iconWidth;
         var bmp:BitmapData = new BitmapData(_width,20,true,0);
         var abrisX:int = int(_width * 0.55);
         if(data.closed)
         {
            closed_icon.y = 3;
            closed_icon.x = -2;
            cont.addChild(closed_icon);
            closed_icon.gotoAndStop(select?access?2:4:access?1:3);
         }
         tf = new Label();
         tf.size = 12;
         tf.color = select?access?uint(TankWindowInner.GREEN):uint(5789784):access?uint(5898034):uint(11645361);
         tf.text = data.gamename;
         tf.autoSize = TextFieldAutoSize.NONE;
         tf.width = abrisX - 6;
         tf.height = 18;
         tf.x = 8;
         tf.y = -1;
         cont.addChild(tf);
         tf = new Label();
         tf.size = 12;
         tf.color = select?access?uint(TankWindowInner.GREEN):uint(5789784):access?uint(5898034):uint(11645361);
         tf.autoSize = TextFieldAutoSize.RIGHT;
         tf.align = TextFormatAlign.RIGHT;
         tf.text = String(data.nmap);
         tf.x = _width - tf.textWidth + 2;
         tf.y = -1;
         cont.addChild(tf);
         if(data.dmatch)
         {
            abris = new Abris();
            abris.gotoAndStop(!data.allfull?2:1);
            abris.x = abrisX;
            abris.y = 1;
            cont.addChild(abris);
            tf = new Label();
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.size = 12;
            tf.color = !data.allfull?uint(16777215):uint(8816262);
            tf.align = TextFormatAlign.CENTER;
            tf.text = String(data.all);
            tf.x = abrisX - 0.5;
            tf.y = -1;
            tf.width = 52;
            cont.addChild(tf);
         }
         else
         {
            abris = new Abris();
            abris.gotoAndStop(!data.redfull?5:3);
            abris.x = abrisX;
            abris.y = 1;
            cont.addChild(abris);
            abris = new Abris();
            abris.gotoAndStop(!data.bluefull?6:4);
            abris.x = abrisX + 27;
            abris.y = 1;
            cont.addChild(abris);
            tf = new Label();
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.size = 12;
            tf.align = TextFormatAlign.CENTER;
            tf.color = !data.redfull?uint(16777215):uint(8816262);
            tf.text = String(data.reds);
            tf.x = abrisX - 0.5;
            tf.y = -1;
            tf.width = 27;
            cont.addChild(tf);
            tf = new Label();
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.align = TextFormatAlign.CENTER;
            tf.color = !data.bluefull?uint(16777215):uint(8816262);
            tf.text = String(data.blues);
            tf.x = abrisX + 26.5;
            tf.y = -1;
            tf.width = 25;
            cont.addChild(tf);
         }
         bmp.draw(cont, null, null, null, null, true);
         icon = new Bitmap(bmp);
         return cont;
      }
      
      private function resizeAll(___width:int) : void
      {
         var i:Object = null;
         var d:Object = null;
         this.iconWidth = ___width - (this.battleList.maxVerticalScrollPosition > 0?32:20);
         if(this.iconWidth == this.oldIconWidth)
         {
            return;
         }
         this.oldIconWidth = this.iconWidth;
         for(var j1:int = 0; j1 < this.dp.length; j1++)
         {
            i = this.dp.getItemAt(j1);
            d = i.dat;
            i.iconNormal = this.myIcon(false, d);
            i.iconSelected = this.myIcon(true, d);
            this.dp.replaceItemAt(i,j1);
            this.dp.invalidateItemAt(j1);
         }
		 j();
      }
      
      private function onResize(e:Event = null) : void
      {
			 var listWidth:int = 0;
			 var minWidth:int = int(Math.max(100, Main.stage.stageWidth));
			 var index:int = this.battleList.selectedIndex;
			 this.mainBackground.width = minWidth / 3;
			 this.mainBackground.height = Math.max(Main.stage.stageHeight - 60, 530);
			 this.x = this.mainBackground.width;
			 this.y = 60;
			 this.inner.width = this.mainBackground.width - 22;
			 this.inner.height = this.mainBackground.height - 58;
			 this.createButton.x = this.mainBackground.width - this.createButton.width - 11;
			 this.createButton.y = this.mainBackground.height - 42;
			 this.ut.x = inner.x;
			 this.ut.y = this.mainBackground.height - 42;
			 this.ut1.x = this.ut.x + (11/2) + this.ut.width;
			 this.ut1.y = this.mainBackground.height - 42;
			 this.ut2.x = this.ut1.x + (11/2) + this.ut1.width;
			 this.ut2.y = this.mainBackground.height - 42;
			 this.ut3.x = this.ut2.x + (11/2) + this.ut2.width;
			 this.ut3.y = this.mainBackground.height - 42;
			 this.ut4.x = this.ut3.x + (11/2) + this.ut3.width;
			 this.ut4.y = this.mainBackground.height - 42;
			 resizeList();
      }
      
      private function resizeList() : void
      {
         var index:int = this.battleList.selectedIndex;
         var listWidth:int = this.inner.width - (this.battleList.maxVerticalScrollPosition > 0?0:4);
         this.battleList.setSize(listWidth,this.inner.height - 8);
         this.resizeAll(listWidth);
         this.battleList.selectedIndex = index;
         this.battleList.scrollToSelected();
      }
   }
}
