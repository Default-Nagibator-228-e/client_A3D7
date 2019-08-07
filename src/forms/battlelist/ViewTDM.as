package forms.battlelist
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.icons.play_icons_BLUE;
   import assets.icons.play_icons_RED;
   import assets.scroller.color.ScrollThumbSkinBlue;
   import assets.scroller.color.ScrollThumbSkinRed;
   import assets.scroller.color.ScrollTrackBlue;
   import assets.scroller.color.ScrollTrackRed;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import controls.rangicons.RangIconSmall;
   import fl.controls.List;
   import fl.data.DataProvider;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import forms.TankWindowWithHeader;
   import forms.events.BattleListEvent;
   
   public class ViewTDM extends Sprite
   {
      
      public static const RED_TEAM:Boolean = true;
      
      public static const BLUE_TEAM:Boolean = false;
       
      
      private var _gameName:String;
      
      private var _sizeTeam:int;
      
      private var _minRang:int;
      
      private var _maxRang:int;
      
      private var _img:BitmapData;
      
      private var _inviteOnly:Boolean;
      
      private var _lifeTime:Number;
      
      private var _currentTime:Number;
      
      private var _killsLimit:int;
      
      private var _autoBalance:Boolean;
      
      private var _friendlyFire:Boolean;
      
      private var _available:Boolean;
      
      private var _ctf:Boolean;
      
      private var mainBackground:TankWindowWithHeader;
      
      private var listInnerRed:TankWindowInner;
      
      private var listInnerBlue:TankWindowInner;
      
      private var format:TextFormat;
      
      private var fightButtonRed:BattleBigButton;
      
      private var fightButtonBlue:BattleBigButton;
      
      private var fightRed:play_icons_RED;
      
      private var fightBlue:play_icons_BLUE;
      
      private var countRed:int = 0;
      
      private var countBlue:int = 0;
      
      public var info:BattleInfo;
      
      public var listRed:List;
      
      public var listBlue:List;
      
      private var dpRed:DataProvider;
      
      private var dpBlue:DataProvider;
      
      private var redScore:Label;
      
      private var blueScore:Label;
      
      private var score:MovieClip;
      
      private var firstStart:Boolean = true;
      
      private var delayTimer:Timer;
      
      private var noNameText:String;
      
      private var _redScore:int;
      
      private var _blueScore:int;
      
      private var _haveSubscribe:Boolean;
      
      private var noSubscribeAlert:NoSubScribeAlert;
      
      private var _payBattle:Boolean = false;
      
      private var _fullCash:Boolean = false;
      
      private var _userAlreadyPaid:Boolean = false;
      
      public function ViewTDM(haveSubscribe:Boolean)
      {
         this.mainBackground = TankWindowWithHeader.createWindow("ИНФОРМАЦИЯ О БИТВЕ");
         this.listInnerRed = new TankWindowInner(100,100,TankWindowInner.RED);
         this.listInnerBlue = new TankWindowInner(100,100,TankWindowInner.BLUE);
         this.format = new TextFormat("MyriadPro",13);
         this.fightButtonRed = new BattleBigButton();
         this.fightButtonBlue = new BattleBigButton();
         this.fightRed = new play_icons_RED(0,0);
         this.fightBlue = new play_icons_BLUE(0,0);
         this.info = new BattleInfo();
         this.listRed = new List();
         this.listBlue = new List();
         this.dpRed = new DataProvider();
         this.dpBlue = new DataProvider();
         this.redScore = new Label();
         this.blueScore = new Label();
         this.score = new MovieClip();
         this.noSubscribeAlert = new NoSubScribeAlert();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         addEventListener(Event.ADDED_TO_STAGE,this.addResizeListener);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeResizeListener);
         this._haveSubscribe = haveSubscribe;
         var w:Label = new Label();
         this.redScore.size = 22;
         this.redScore.color = TankWindowInner.RED;
         this.redScore.x = -6;
         this.redScore.autoSize = TextFieldAutoSize.RIGHT;
         this.blueScore.size = 22;
         this.blueScore.color = TankWindowInner.BLUE;
         this.blueScore.x = 5;
		 blueScore.text = "0";
		 redScore.text = "0";
         w.size = 22;
         w.text = ":";
         w.x = -3;
         w.y = -2;
         this.score.addChild(this.redScore);
         this.score.addChild(this.blueScore);
         this.score.addChild(w);
         this.score.filters = [new GlowFilter(13434828,0.5)];
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
      
      private function ConfigUI(e:Event) : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         removeEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         this.confScroll();
         addChild(this.mainBackground);
         addChild(this.listInnerRed);
         addChild(this.listInnerBlue);
         addChild(this.fightButtonBlue);
         addChild(this.fightButtonRed);
         addChild(this.noSubscribeAlert);
         this.listInnerBlue.showBlink = this.listInnerRed.showBlink = true;
         this.fightButtonBlue.x = 322;
         this.fightButtonRed.x = 25;
         addChild(this.info);
         addChild(this.listRed);
         addChild(this.listBlue);
         this.listRed.rowHeight = 20;
         this.listRed.setStyle("cellRenderer",TeamListRenderer);
         this.listRed.dataProvider = this.dpRed;
         this.listBlue.rowHeight = 20;
         this.listBlue.setStyle("cellRenderer",TeamListRenderer);
         this.listBlue.dataProvider = this.dpBlue;
         this.fightButtonBlue.label = localeService.getText(TextConst.BATTLEINFO_PANEL_BUTTON_PLAY);
         this.fightButtonBlue.icon = this.fightBlue;
         this.fightButtonRed.label = localeService.getText(TextConst.BATTLEINFO_PANEL_BUTTON_PLAY);
         this.fightButtonRed.icon = this.fightRed;
         this.fightButtonBlue.width = this.fightButtonRed.width = 130;
         this.fightButtonBlue.addEventListener(MouseEvent.CLICK,this.goFight);
         this.fightButtonRed.addEventListener(MouseEvent.CLICK,this.goFight);
         this.noSubscribeAlert.visible = false;
         addChild(this.score);
         this.fillTeam();
      }
      
      public function Init(gameName:String, sizeTeam:int, minRang:int, maxRang:int, scoreRed:int, scoreBlue:int, img:BitmapData = null, lifeTime:Number = 0, currentTime:int = 0, killsLimit:int = 0, inviteOnly:Boolean = false, autoBalance:Boolean = false, friendlyFire:Boolean = false, url:String = "", available:Boolean = true, ctf:Boolean = false, payBattle:Boolean = false, inventoryOn:Boolean = false, userAlreadyPaid:Boolean = false, fullCash:Boolean = false) : void
      {
         this.dpRed = new DataProvider();
         this.dpBlue = new DataProvider();
         this._payBattle = payBattle;
         this._fullCash = fullCash;
         this._userAlreadyPaid = userAlreadyPaid;
         this.listRed.dataProvider = this.dpRed;
         this.listBlue.dataProvider = this.dpBlue;
         this._gameName = gameName;
         this._sizeTeam = sizeTeam;
         this._minRang = minRang;
         this._maxRang = maxRang;
         this._img = img;
         this._ctf = ctf;
         this._lifeTime = lifeTime;
         this._currentTime = currentTime;
         this._killsLimit = killsLimit;
         this._inviteOnly = inviteOnly;
         this._autoBalance = autoBalance;
         this._friendlyFire = friendlyFire;
         this.countRed = this.countBlue = 0;
         this.info.setUp(this._gameName,this._minRang,this._maxRang,this._killsLimit,this._lifeTime,this._currentTime,this._img,this._inviteOnly,this._autoBalance,this._friendlyFire,url,this._ctf,payBattle,inventoryOn);
         this.info.setPreview(this._img);
         this._available = available;
         this.fightButtonBlue.enable = this.fightButtonRed.enable = this._available && (this._fullCash && ((this._haveSubscribe && _payBattle) || (!this._haveSubscribe && !_payBattle) || (this._haveSubscribe && !_payBattle)) && this._userAlreadyPaid);
         this.updateScore(BLUE_TEAM, scoreBlue);
		 this.updateScore(RED_TEAM,scoreRed);
         this.fightButtonBlue.cost = this._haveSubscribe || !payBattle || this._userAlreadyPaid?int(0):int(50);
         this.fightButtonRed.cost = this._haveSubscribe || !payBattle || this._userAlreadyPaid?int(0):int(50);
         this.noSubscribeAlert.visible = !this._haveSubscribe && payBattle;
         this.fillTeam();
         this.onResize(null);
      }
      
      public function updateScore(team:Boolean, score:int) : void
      {
         if(team && this.redScore != null && this.blueScore != null)
         {
            this.redScore.text = String(score);
            this._redScore = score;
         }
         else
         {
            this.blueScore.text = String(score);
            this._blueScore = score;
         }
      }
      
      public function dropKills() : void
      {
         var item:Object = null;
         var i:int = 0;
         for(i = 0; i < this.dpRed.length; i++)
         {
            item = this.dpRed.getItemAt(i);
            item.kills = 0;
            this.dpRed.replaceItemAt(item,i);
            item = this.dpBlue.getItemAt(i);
            item.kills = 0;
            this.dpBlue.replaceItemAt(item,i);
         }
         this.dpRed.sortOn(["kills","rang"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
         this.dpRed.invalidate();
         this.dpBlue.sortOn(["kills","rang"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
         this.dpBlue.invalidate();
         this.updateScore(RED_TEAM,0);
         this.updateScore(BLUE_TEAM,0);
      }
      
      public function updatePlayer(team:Boolean = true, id:Object = null, name:String = "", rang:int = 0, kills:int = 0) : void
      {
         var index:int = 0;
         var i:int = 0;
         var item:Object = new Object();
         var data:Object = new Object();
         var dp:DataProvider = team == RED_TEAM?this.dpRed:this.dpBlue;
         var currentScore:int = 0;
         item.playerName = name;
         item.style = team == RED_TEAM?"red":"blue";
         data.rang = rang;
         item.kills = kills;
         item.id = id;
         item.rang = rang;
         index = id == null?int(-1):int(this.indexById(team,id));
         if(index < 0)
         {
            dp.addItem(item);
         }
         else
         {
            dp.replaceItemAt(item,index);
         }
         this.countBlue = this.countRed = 0;
         for(i = 0; i < this.dpRed.length; i++)
         {
            this.countRed = this.countRed + (this.dpRed.getItemAt(i).id != null?1:0);
         }
         for(i = 0; i < this.dpBlue.length; i++)
         {
            this.countBlue = this.countBlue + (this.dpBlue.getItemAt(i).id != null?1:0);
         }
         this.dpRed.sortOn(["kills","rang"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
         this.dpBlue.sortOn(["kills","rang"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
         if(dp.length > this._sizeTeam && dp.getItemAt(dp.length - 1).id == null)
         {
            dp.removeItemAt(dp.length - 1);
         }
         this.fightButtonRed.enable = (!!this._available?Boolean(this.countRed <= this.countBlue || !this._autoBalance):Boolean(false)) && this.countRed < this._sizeTeam && (this._fullCash && ((this._haveSubscribe && _payBattle) || (!this._haveSubscribe && !_payBattle) || (this._haveSubscribe && !_payBattle)) && this._userAlreadyPaid);
         this.fightButtonBlue.enable = (!!this._available?Boolean(this.countBlue <= this.countRed || !this._autoBalance):Boolean(false)) && this.countBlue < this._sizeTeam && (this._fullCash && ((this._haveSubscribe && _payBattle) || (!this._haveSubscribe && !_payBattle) || (this._haveSubscribe && !_payBattle)) && this._userAlreadyPaid);
         if(this.delayTimer == null)
         {
            this.delayTimer = new Timer(500,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.resizeList);
         }
         this.delayTimer.stop();
         this.delayTimer.start();
      }
      
      public function removePlayer(id:Object) : void
      {
         var index:int = 0;
         var i:int = 0;
         index = this.indexById(RED_TEAM,id);
         if(index >= 0)
         {
            this.dpRed.removeItemAt(index);
            this.updatePlayer(RED_TEAM);
         }
         index = this.indexById(BLUE_TEAM,id);
         if(index >= 0)
         {
            this.dpBlue.removeItemAt(index);
            this.updatePlayer(BLUE_TEAM);
         }
         this.countBlue = this.countRed = 0;
         for(i = 0; i < this.dpRed.length; i++)
         {
            this.countRed = this.countRed + (this.dpRed.getItemAt(i).id != null?1:0);
         }
         for(i = 0; i < this.dpBlue.length; i++)
         {
            this.countBlue = this.countBlue + (this.dpBlue.getItemAt(i).id != null?1:0);
         }
         this.fightButtonRed.enable = (!!this._available?Boolean(this.countRed - this.countBlue < 2):Boolean(false)) && this.countRed < this._sizeTeam;
         this.fightButtonBlue.enable = (!!this._available?Boolean(this.countBlue - this.countRed < 2):Boolean(false)) && this.countBlue < this._sizeTeam;
         if(this.delayTimer == null)
         {
            this.delayTimer = new Timer(500,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.resizeList);
         }
         this.delayTimer.stop();
         this.delayTimer.start();
      }
      
      private function indexById(team:Boolean, id:Object) : int
      {
         var obj:Object = null;
         var dp:DataProvider = team == RED_TEAM?this.dpRed:this.dpBlue;
         for(var i:int = 0; i < dp.length; i++)
         {
            obj = dp.getItemAt(i);
            if(obj.id == id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function goFight(e:MouseEvent) : void
      {
         var trgt:BattleBigButton = e.currentTarget as BattleBigButton;
         if(trgt == this.fightButtonBlue)
         {
            dispatchEvent(new BattleListEvent(BattleListEvent.START_TDM_BLUE));
         }
         else
         {
            dispatchEvent(new BattleListEvent(BattleListEvent.START_TDM_RED));
         }
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
         this.listInnerRed.x = 11;
         this.listInnerRed.y = this.info.height + 14;
         this.listInnerRed.width = int(this.mainBackground.width - 25) / 2;
         this.listInnerRed.height = this.mainBackground.height - this.info.height - (this._haveSubscribe || !this._payBattle?80:164);
         this.listInnerBlue.x = 14 + this.listInnerRed.width;
         this.listInnerBlue.y = this.info.height + 14;
         this.listInnerBlue.width = this.mainBackground.width - this.listInnerRed.width - 22;
         this.listInnerBlue.height = this.mainBackground.height - this.info.height - (this._haveSubscribe || !this._payBattle?80:164);
         this.listRed.x = this.listInnerRed.x + 4;
         this.listRed.y = this.listInnerRed.y + 4;
         this.listRed.setSize(this.listInnerRed.width - (this.listRed.maxVerticalScrollPosition > 0?1:4),this.listInnerRed.height - 8);
         this.listBlue.x = this.listInnerBlue.x + 4;
         this.listBlue.y = this.listInnerBlue.y + 4;
         this.listBlue.setSize(this.listInnerBlue.width - (this.listBlue.maxVerticalScrollPosition > 0?1:4),this.listInnerBlue.height - 8);
         this.fightButtonBlue.width = this.fightButtonRed.width = Math.min(130,int((this.mainBackground.width - 110) / 2));
         this.fightButtonRed.x = 11;
         this.fightButtonRed.y = this.mainBackground.height - 61;
         this.fightButtonBlue.x = this.mainBackground.width - this.fightButtonBlue.width - 11;
         this.fightButtonBlue.y = this.mainBackground.height - 61;
         this.score.x = this.listInnerBlue.x - 3;
         this.score.y = this.mainBackground.height - 51;
         this.noSubscribeAlert.x = 15;
         this.noSubscribeAlert.y = this.mainBackground.height - 85 - 55;
         this.noSubscribeAlert.width = this.mainBackground.width - 30;
         if(this.delayTimer == null)
         {
            this.delayTimer = new Timer(200,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.resizeList);
         }
         this.delayTimer.reset();
         this.delayTimer.start();
      }
      
      private function resizeList(e:TimerEvent) : void
      {
         this.info.width = this.mainBackground.width - 22;
         this.info.height = int(this.mainBackground.height * 0.4);
         this.listInnerRed.y = this.info.height + 14;
         this.listInnerRed.width = int(this.mainBackground.width - 25) / 2;
         this.listInnerRed.height = this.mainBackground.height - this.info.height - (this._haveSubscribe || !this._payBattle?80:164);
         this.listInnerBlue.x = 14 + this.listInnerRed.width;
         this.listInnerBlue.y = this.info.height + 14;
         this.listInnerBlue.width = this.mainBackground.width - this.listInnerRed.width - 22;
         this.listInnerBlue.height = this.mainBackground.height - this.info.height - (this._haveSubscribe || !this._payBattle?80:164);
         this.listRed.x = this.listInnerRed.x + 4;
         this.listRed.y = this.listInnerRed.y + 4;
         this.listRed.setSize(this.listInnerRed.width - (this.listRed.maxVerticalScrollPosition > 0?1:4),this.listInnerRed.height - 8);
         this.dpRed.invalidate();
         this.listBlue.x = this.listInnerBlue.x + 4;
         this.listBlue.y = this.listInnerBlue.y + 4;
         this.listBlue.setSize(this.listInnerBlue.width - (this.listBlue.maxVerticalScrollPosition > 0?1:4),this.listInnerBlue.height - 8);
         this.dpBlue.invalidate();
         this.fightButtonBlue.width = this.fightButtonRed.width = Math.min(130,int((this.mainBackground.width - 110) / 2));
         this.fightButtonRed.y = this.mainBackground.height - 61;
         this.fightButtonBlue.x = this.mainBackground.width - this.fightButtonBlue.width - 11;
         this.fightButtonBlue.y = this.mainBackground.height - 61;
         this.score.x = this.listInnerBlue.x - 3;
         this.score.y = this.mainBackground.height - 51;
         this.noSubscribeAlert.x = 15;
         this.noSubscribeAlert.y = this.mainBackground.height - 85 - 55;
         this.noSubscribeAlert.width = this.mainBackground.width - 30;
         this.delayTimer.removeEventListener(TimerEvent.TIMER,this.resizeList);
         this.delayTimer = null;
      }
      
      public function fillTeam() : void
      {
         var i:int = 0;
         this.dpRed.removeAll();
         this.dpBlue.removeAll();
         for(i = 0; i < this._sizeTeam; i++)
         {
            this.updatePlayer(RED_TEAM);
            this.updatePlayer(BLUE_TEAM);
         }
         this.countRed = this.countBlue = 0;
      }
      
      public function hide() : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
         this.fightButtonBlue.removeEventListener(MouseEvent.CLICK,this.goFight);
         this.fightButtonRed.removeEventListener(MouseEvent.CLICK,this.goFight);
      }
      
      private function myIcon(data:Object) : Bitmap
      {
         var icon:Bitmap = null;
         var name:TextField = null;
         var kills:TextField = null;
         var rangIcon:RangIconSmall = null;
         var bmp:BitmapData = new BitmapData(360,20,true,0);
         var cont:Sprite = new Sprite();
         this.format.color = 16777215;
         name = new TextField();
         name.embedFonts = true;
         name.antiAliasType = AntiAliasType.ADVANCED;
         name.sharpness = -200;
         name.defaultTextFormat = this.format;
         name.text = data.playerName == ""?"none":data.playerName;
         name.autoSize = TextFieldAutoSize.LEFT;
         name.height = 20;
         name.x = 26;
         name.y = 0;
         kills = new TextField();
         kills.embedFonts = true;
         kills.antiAliasType = AntiAliasType.ADVANCED;
         kills.sharpness = -200;
         kills.defaultTextFormat = this.format;
         kills.text = data.kills == 0?"-":String(data.kills);
         kills.autoSize = TextFieldAutoSize.CENTER;
         kills.height = 20;
         kills.width = 20;
         kills.x = 160;
         kills.y = 0;
         if(data.rang > 0)
         {
            rangIcon = new RangIconSmall(data.rang);
            rangIcon.x = 13;
            rangIcon.y = 4;
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
         this.listRed.setStyle("downArrowUpSkin",ScrollArrowDownRed);
         this.listRed.setStyle("downArrowDownSkin",ScrollArrowDownRed);
         this.listRed.setStyle("downArrowOverSkin",ScrollArrowDownRed);
         this.listRed.setStyle("downArrowDisabledSkin",ScrollArrowDownRed);
         this.listRed.setStyle("upArrowUpSkin",ScrollArrowUpRed);
         this.listRed.setStyle("upArrowDownSkin",ScrollArrowUpRed);
         this.listRed.setStyle("upArrowOverSkin",ScrollArrowUpRed);
         this.listRed.setStyle("upArrowDisabledSkin",ScrollArrowUpRed);
         this.listRed.setStyle("trackUpSkin",ScrollTrackRed);
         this.listRed.setStyle("trackDownSkin",ScrollTrackRed);
         this.listRed.setStyle("trackOverSkin",ScrollTrackRed);
         this.listRed.setStyle("trackDisabledSkin",ScrollTrackRed);
         this.listRed.setStyle("thumbUpSkin",ScrollThumbSkinRed);
         this.listRed.setStyle("thumbDownSkin",ScrollThumbSkinRed);
         this.listRed.setStyle("thumbOverSkin",ScrollThumbSkinRed);
         this.listRed.setStyle("thumbDisabledSkin",ScrollThumbSkinRed);
         this.listBlue.setStyle("downArrowUpSkin",ScrollArrowDownBlue);
         this.listBlue.setStyle("downArrowDownSkin",ScrollArrowDownBlue);
         this.listBlue.setStyle("downArrowOverSkin",ScrollArrowDownBlue);
         this.listBlue.setStyle("downArrowDisabledSkin",ScrollArrowDownBlue);
         this.listBlue.setStyle("upArrowUpSkin",ScrollArrowUpBlue);
         this.listBlue.setStyle("upArrowDownSkin",ScrollArrowUpBlue);
         this.listBlue.setStyle("upArrowOverSkin",ScrollArrowUpBlue);
         this.listBlue.setStyle("upArrowDisabledSkin",ScrollArrowUpBlue);
         this.listBlue.setStyle("trackUpSkin",ScrollTrackBlue);
         this.listBlue.setStyle("trackDownSkin",ScrollTrackBlue);
         this.listBlue.setStyle("trackOverSkin",ScrollTrackBlue);
         this.listBlue.setStyle("trackDisabledSkin",ScrollTrackBlue);
         this.listBlue.setStyle("thumbUpSkin",ScrollThumbSkinBlue);
         this.listBlue.setStyle("thumbDownSkin",ScrollThumbSkinBlue);
         this.listBlue.setStyle("thumbOverSkin",ScrollThumbSkinBlue);
         this.listBlue.setStyle("thumbDisabledSkin",ScrollThumbSkinBlue);
      }
   }
}
