package forms.battlelist
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.icons.play_icons_ALL;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import controls.rangicons.RangIconSmall;
   import fl.controls.List;
   import fl.data.DataProvider;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import forms.TankWindowWithHeader;
   import forms.events.BattleListEvent;
   
   public class ViewDM extends Sprite
   {
       
      
      private var _gameName:String;
      
      private var _sizeTeam:int;
      
      private var _minRang:int;
      
      private var _maxRang:int;
      
      private var _img:BitmapData;
      
      private var _inviteOnly:Boolean;
      
      private var _lifeTime:Number;
      
      private var _currentTime:Number;
      
      private var _killsLimit:int;
	  
	  private var fgr:int;
      
      private var _available:Boolean;
      
      private var mainBackground:TankWindowWithHeader;
      
      private var listInner:TankWindowInner;
      
      private var format:TextFormat;
      
      private var fightButton:BattleBigButton;
      
      private var fightButtonIcon:BitmapData;
      
      public var info:BattleInfo;
      
      private var list:List;
      
      private var dp:DataProvider;
      
      private var firstStart:Boolean = true;
      
      private var delayTimer:Timer;
      
      private var noNameText:String;
      
      private var _haveSubscribe:Boolean;
      
      private var noSubscribeAlert:NoSubScribeAlert;
      
      private var _payBattle:Boolean = false;
      
      private var _fullCash:Boolean = false;
      
      private var _userAlreadyPaid:Boolean = false;
      
      public function ViewDM(haveSubscribe:Boolean)
      {
         this.mainBackground = TankWindowWithHeader.createWindow("ИНФОРМАЦИЯ О БИТВЕ");
         this.listInner = new TankWindowInner(100,100,TankWindowInner.GREEN);
         this.format = new TextFormat("MyriadPro",13);
         this.fightButton = new BattleBigButton();
         this.fightButtonIcon = new play_icons_ALL(0,0);
         this.info = new BattleInfo();
         this.dp = new DataProvider();
         this.noSubscribeAlert = new NoSubScribeAlert();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         addEventListener(Event.ADDED_TO_STAGE,this.addResizeListener);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeResizeListener);
         this._haveSubscribe = haveSubscribe;
      }
      
      public function get haveSubscribe() : Boolean
      {
         return this._haveSubscribe;
      }
      
      public function set haveSubscribe(value:Boolean) : void
      {
         this._haveSubscribe = value;
      }
      
      private function addResizeListener(e:Event) : void
      {
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize(null);
      }
      
      private function removeResizeListener(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      public function Init(gameName:String, sizeTeam:int, minRang:int, maxRang:int, img:BitmapData = null, lifeTime:Number = 0, currentTime:int = 0, killsLimit:int = 0, inviteOnly:Boolean = false, url:String = "", available:Boolean = true, payBattle:Boolean = false, inventoryOn:Boolean = false, userAlreadyPaid:Boolean = false, fullCash:Boolean = false) : void
      {
         this.dp = new DataProvider();
         this._payBattle = payBattle;
         this._fullCash = fullCash;
         this.list.dataProvider = this.dp;
         this._gameName = gameName;
         this._sizeTeam = sizeTeam;
         this._minRang = minRang;
         this._maxRang = maxRang;
         this._img = img;
         this._inviteOnly = inviteOnly;
         this._lifeTime = lifeTime;
         this._currentTime = currentTime;
         this._userAlreadyPaid = userAlreadyPaid;
         this._killsLimit = killsLimit;
         this.info.setUp(this._gameName,this._minRang,this._maxRang,killsLimit,this._lifeTime,this._currentTime,this._img,this._inviteOnly,false,false,url,false,payBattle,inventoryOn);
         this.info.setPreview(this._img);
         this._available = available;
         this.fightButton.width = 130;
         Main.writeVarsToConsoleChannel("BATTLE SELECT","  _payBattle: %1 _userAlreadyPaid: %2 _haveSubscribe: %3",this._payBattle,this._userAlreadyPaid,this._haveSubscribe);
         this.fightButton.enable = available && (this._fullCash || !this._payBattle || this._userAlreadyPaid || this._haveSubscribe);
		 this.fightButton.enable = this._haveSubscribe;
         this.fightButton.icon = this.fightButtonIcon;
         this.noSubscribeAlert.visible = !this._haveSubscribe && payBattle;
         this.fightButton.cost = this._haveSubscribe || !payBattle || this._userAlreadyPaid?int(0):int(500);
         this.fillTeam();
         this.onResize(null);
      }
      
      private function ConfigUI(e:Event) : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         removeEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
		 var gh:TeamListRenderer = new TeamListRenderer();
         this.list = new List();
         this.confScroll();
         this.fightButton.x = 320;
         addChild(this.mainBackground);
         addChild(this.listInner);
         addChild(this.list);
         addChild(this.fightButton);
         addChild(this.noSubscribeAlert);
		 //list.addEventListener(MouseEvent.CLICK, r);
         this.listInner.showBlink = true;
         addChild(this.info);
         this.list.rowHeight = 20;
         this.list.setStyle("cellRenderer", TeamListRenderer);
		 //this.list.addChild(gh.sfr);
         this.fightButton.label = localeService.getText(TextConst.BATTLEINFO_PANEL_BUTTON_PLAY);
         this.fightButton.addEventListener(MouseEvent.CLICK,this.goFight);
         //this.noSubscribeAlert.visible = false;
      }
      
      private function goFight(e:MouseEvent) : void
      {
         dispatchEvent(new BattleListEvent(BattleListEvent.START_DM_GAME));
      }
      
      public function dropKills() : void
      {
         var item:Object = null;
         for(var i:int = 0; i < this.dp.length; i++)
         {
            item = this.dp.getItemAt(i);
            item.kills = 0;
            this.dp.replaceItemAt(item,i);
         }
         this.dp.sortOn(["kills","rang"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
         this.dp.invalidate();
      }
      
      public function updatePlayer(id:Object = null, name:String = "", rang:int = 0, kills:int = 0) : void
      {
         var index:int = 0;
         var item:Object = new Object();
         var data:Object = new Object();
         item.id = id;
         item.rang = rang;
         item.playerName = name;
         item.style = "green";
         data.rang = rang;
         item.kills = kills;
         index = id == null?int( -1):int(this.indexById(id));
         if(index < 0)
         {
            this.dp.addItem(item);
         }
         else
         {
            this.dp.replaceItemAt(item,index);
         }
         this.dp.sortOn(["kills","rang"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
         if(this.dp.length > this._sizeTeam)
         {
            this.dp.removeItemAt(this.dp.length - 1);
         }
         if(this.dp.length > 1)
         {
            item = this.dp.getItemAt(this.dp.length - 1);
         }
         this.fightButton.enable = this._available && (this._fullCash && ((this._haveSubscribe && _payBattle) || (!this._haveSubscribe && !_payBattle) || (this._haveSubscribe && !_payBattle)) && this._userAlreadyPaid);
         if(item.id != null)
         {
            this.fightButton.enable = false;
         }
         if(this.delayTimer == null)
         {
            this.delayTimer = new Timer(500,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.resizeList);
         }
         this.delayTimer.reset();
      }
      
      public function removePlayer(id:Object) : void
      {
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            this.dp.removeItemAt(index);
            this.updatePlayer();
         }
         if(this.delayTimer == null)
         {
            this.delayTimer = new Timer(500,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.resizeList);
         }
         this.delayTimer.stop();
         this.delayTimer.start();
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
      
      private function onResize(e:Event) : void
      {
         var minWidth:int = int(Math.max(100,stage.stageWidth));
         this.mainBackground.width = minWidth / 3;
         this.mainBackground.height = Math.max(stage.stageHeight - 60,530);
         this.x = this.mainBackground.width * 2;
         this.y = 60;
         this.info.x = this.info.y = 11;
         this.info.width = this.mainBackground.width - 22;
         this.info.height = int(this.mainBackground.height * 0.4);
         this.listInner.x = 11;
         this.listInner.y = this.info.height + 14;
         this.listInner.width = this.mainBackground.width - 22;
         this.listInner.height = this.mainBackground.height - this.info.height - (this._haveSubscribe || !this._payBattle?80:164);
         this.list.x = this.listInner.x + 4;
         this.list.y = this.listInner.y + 4;
         this.list.setSize(this.listInner.width - (this.list.maxVerticalScrollPosition > 0?1:4),this.listInner.height - 8);
         this.fightButton.x = this.mainBackground.width - this.fightButton.width - 11;
         this.fightButton.y = this.mainBackground.height - 61;
         this.noSubscribeAlert.x = 15;
         this.noSubscribeAlert.y = this.mainBackground.height - 85 - 55;
         this.noSubscribeAlert.width = this.mainBackground.width - 30;
         if(this.delayTimer == null)
         {
            this.delayTimer = new Timer(200,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.resizeList);
         }
         this.delayTimer.stop();
         this.delayTimer.start();
      }
      
      private function resizeList(e:TimerEvent) : void
      {
         this.info.width = this.mainBackground.width - 22;
         this.info.height = int(this.mainBackground.height * 0.4);
         this.listInner.x = 11;
         this.listInner.y = this.info.height + 14;
         this.listInner.width = this.mainBackground.width - 22;
         this.listInner.height = this.mainBackground.height - this.info.height - (this._haveSubscribe || !this._payBattle?80:164);
         this.list.x = this.listInner.x + 4;
         this.list.y = this.listInner.y + 4;
         this.list.setSize(this.listInner.width - (this.list.maxVerticalScrollPosition > 0?1:4),this.listInner.height - 8);
         this.dp.invalidate();
         this.fightButton.x = this.mainBackground.width - this.fightButton.width - 11;
         this.fightButton.y = this.mainBackground.height - 61;
         this.noSubscribeAlert.x = 15;
         this.noSubscribeAlert.y = this.mainBackground.height - 85 - 55;
         this.noSubscribeAlert.width = this.mainBackground.width - 30;
         this.delayTimer.removeEventListener(TimerEvent.TIMER,this.resizeList);
         this.delayTimer = null;
      }
      
      public function fillTeam() : void
      {
         this.dp.removeAll();
         for(var i:int = 0; i < this._sizeTeam; i++)
         {
            this.updatePlayer();
         }
      }
      
      public function hide() : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
         this.fightButton.removeEventListener(MouseEvent.CLICK,this.goFight);
      }
      
      private function myIcon(data:Object) : Bitmap
      {
         var icon:Bitmap = null;
         var cont:Sprite = null;
         var name:Label = null;
         var kills:Label = null;
         var rangIcon:RangIconSmall = null;
         var bmp:BitmapData = new BitmapData(360,20,true,0);
         cont = new Sprite();
         this.format.color = 16777215;
         name = new Label();
         name.text = data.playerName == ""?"none":data.playerName;
         name.height = 20;
         name.x = 28;
         name.y = 0;
         kills = new Label();
         kills.text = data.kills == 0?"-":String(data.kills);
         kills.autoSize = TextFieldAutoSize.CENTER;
         kills.height = 20;
         kills.width = 20;
         kills.x = 160;
         kills.y = 0;
         if(data.rang > 0)
         {
            rangIcon = new RangIconSmall(data.rang);
			fgr = data.rang;
            rangIcon.x = 13;
            rangIcon.y = 5;
            cont.addChild(rangIcon);
         }
         cont.addChild(name);
         cont.addChild(kills);
         bmp.draw(cont,null,null,null,null,true);
         icon = new Bitmap(bmp);
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
   }
}
