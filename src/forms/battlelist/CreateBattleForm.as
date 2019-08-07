package forms.battlelist
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.icons.BattleInfoIcons;
   import assets.icons.InputCheckIcon;
   import controls.NumStepper;
   import controls.RedButton;
   import controls.TankCheckBox;
   import controls.TankCombo;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TypeBattleButton;
   import controls.slider.SelectRank;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import forms.TankWindowWithHeader;
   import forms.events.BattleListEvent;
   import forms.events.LoginFormEvent;
   import forms.events.SliderEvent;
   
   public class CreateBattleForm extends Sprite
   {
      
      public static const NAMEGAME_STATE_OFF:int = 0;
      
      public static const NAMEGAME_STATE_PROGRESS:int = 1;
      
      public static const NAMEGAME_STATE_VALID:int = 2;
      
      public static const NAMEGAME_STATE_INVALID:int = 3;
       
      
      private var mainBackground:TankWindowWithHeader;
      
      public var mapsCombo:TankCombo;
      
      public var nameGame:TankInput;
      
      public var nameGameCheckIcon:InputCheckIcon;
      
      public var themeCombo:TankCombo;
      
      private var dmCheck:TypeBattleButton;
      
      private var tdmCheck:TypeBattleButton;
      
      private var ctfCheck:TypeBattleButton;
      
      private var ab:TankCheckBox;
      
      private var ff:TankCheckBox;
      
      private var privateCheck:TankCheckBox;
      
      private var payCheck:TankCheckBox;
      
      private var inventoryCheck:TankCheckBox;
      
      private var players:NumStepper;
      
      private var minutes:NumStepper;
      
      private var kills:NumStepper;
      
      private var flags:NumStepper;
      
      public var info:BattleInfo;
      
      private var selectRang:SelectRank;
      
      private var _currentRang:int = 1;
      
      private var delayTimer:Timer;
      
      private var autoname:Boolean = true;
      
      private var startButton:RedButton;
      
      private var MAP_NAME_LABEL:String = "";
      
      private var MAP_TYPE_LABEL:String = "";
      
      private var MAP_THEME_LABEL:String = "";
      
      private var BUTTON_DEATHMATCH:String = "";
      
      private var BUTTON_TEAM_DEATHMATCH:String = "";
      
      private var BUTTON_CAPTURE_THE_FLAG:String = "";
      
      private var BUTTON_START:String = "";
      
      private var STEPPER_MAX_PLAYERS:String = "";
      
      private var STEPPER_MAX_TEAM_SIZE:String = "";
      
      private var STEPPER_TIME_LIMIT:String = "";
      
      private var STEPPER_KILLS_LIMIT:String = "";
      
      private var STEPPER_FLAG_LIMIT:String = "";
      
      private var CHECKBOX_AUTOBALANCE:String = "";
      
      private var CHECKBOX_FRIENDLY_FIRE:String = "";
      
      private var CHECKBOX_PRIVATE_BATTLE:String = "";
      
      private var CHECKBOX_PAY_BATTLE:String = "";
      
      private var CHECKBOX_BONUS:String = "";
      
      private var COST_LABEL:String = "";
      
      private var costLabel:TankInput;
      
      private var _haveSubscribe:Boolean;
      
      private var noSubscribeAlert:NoSubScribeAlert;
      
      private var searchTimer:Timer;
      
      private var mapsarr:Array;
      
      private var mapsThemes:Dictionary;
      
      private var _nameGameState:int = 0;
      
      private var maxP:int = 0;
      
      private var ctfEnable:Boolean = false;
      
      private var tdmEnable:Boolean = false;
      
      private var typeGame:String = "DM";
	  
	  private var cn:Sprite = new Sprite();
      
      public function CreateBattleForm(haveSubscribe:Boolean)
      {
         this.mapsCombo = new TankCombo();
         this.themeCombo = new TankCombo();
         this.dmCheck = new TypeBattleButton();
         this.tdmCheck = new TypeBattleButton();
         this.ctfCheck = new TypeBattleButton();
         this.ab = new TankCheckBox();
         this.ff = new TankCheckBox();
         this.privateCheck = new TankCheckBox();
         this.payCheck = new TankCheckBox();
         this.inventoryCheck = new TankCheckBox();
         this.players = new NumStepper();
         this.minutes = new NumStepper();
         this.kills = new NumStepper();
         this.flags = new NumStepper();
         this.info = new BattleInfo();
         this.selectRang = new SelectRank();
         this.startButton = new RedButton();
         this.costLabel = new TankInput();
         this.noSubscribeAlert = new NoSubScribeAlert();
         this.searchTimer = new Timer(500);
         this.mapsarr = new Array();
         this.mapsThemes = new Dictionary();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         addEventListener(Event.ADDED_TO_STAGE,this.addResizeListener);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeResizeListener);
         this._haveSubscribe = haveSubscribe;
      }
      
      public function get gameName() : String
      {
         return this.nameGame.value;
      }
      
      public function set gameName(value:String) : void
      {
         removeEventListener(LoginFormEvent.TEXT_CHANGED,this.checkName);
         this.nameGame.value = value;
         addEventListener(LoginFormEvent.TEXT_CHANGED,this.checkName);
         this.nameGameState = NAMEGAME_STATE_OFF;
         this.calculatePayment();
      }
      
      public function set maps(array:Array) : void
      {
         var item:BattleMap = null;
         this.mapsarr = array;
         this.mapsCombo.clear();
         this.mapsThemes = new Dictionary();
         for(var i:int = 0; i < array.length; i++)
         {
            item = array[i] as BattleMap;
            if(this._currentRang <= item.maxRank)
            {
               if(this.mapsThemes[item.gameName] == null)
               {
				  //throw new Error("");
                  this.mapsThemes[item.gameName] = new Dictionary();
                  this.mapsCombo.addItem({
                     "gameName":item.gameName,
                     "id":item.id,
                     "preview":item.preview,
                     "minRank":item.minRank,
                     "maxRank":item.maxRank,
                     "rang":(this._currentRang >= item.minRank?0:item.minRank),
                     "maxP":item.maxPeople,
                     "ctf":item.ctf,
                     "tdm":item.tdm
                  });
               }
               this.mapsThemes[item.gameName][item.themeName] = item.id;
            }
         }
         this.mapsCombo.sortOn(["rang","gameName"],[Array.NUMERIC,null]);
         var itemm:Object = this.mapsCombo.selectedItem;
         var min:int = itemm.minRank < 1?int(1):int(itemm.minRank);
         var max:int = itemm.maxRank > 30?int(30):int(itemm.maxRank);
         //this.info.setUp("",0,0,0,0,0);
         this.selectRang.maxValue = max;
         this.selectRang.minValue = min;
         if(this.selectRang.minRang < this.selectRang.minValue)
         {
            this.selectRang.minRang = this.selectRang.minValue;
         }
         if(this.selectRang.maxRang > this.selectRang.maxValue)
         {
            this.selectRang.maxRang = this.selectRang.maxValue;
         }
         this.players.maxValue = this.players.value = !this.dmCheck.enable?int(itemm.maxP):int(int(itemm.maxP / 2));
         this.maxP = itemm.maxP;
         this.ctfEnable = itemm.ctf;
         this.tdmEnable = itemm.tdm;
         this.ctfCheck.visible = this.ctfEnable;
         this.tdmCheck.visible = this.tdmEnable;
         if(!this.ctfEnable && !this.deathMatch)
         {
            this.dmCheck.enable = true;
            this.tdmCheck.enable = false;
            this.ctfCheck.enable = true;
            this.ff.visible = true;
            this.ab.visible = true;
            this.players.maxValue = int(this.maxP / 2);
            this.players.minValue = 1;
            this.players.value = int(this.maxP / 2);
            this.players.label = this.STEPPER_MAX_TEAM_SIZE;
            this.flags.visible = false;
            this.kills.visible = true;
         }
         else
         {
            this.flags.visible = this.ctfEnable && !this.ctfCheck.enable;
            this.kills.visible = !this.flags.visible;
         }
         if(stage != null)
         {
            this.onResize(null);
         }
         this.updateThemesCombo(this.mapsCombo.selectedItem);
         this.mapsCombo.dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set currentRang(value:int) : void
      {
         this._currentRang = this.selectRang.currentRang = value;
         this.selectRang.minRang = this._currentRang;
         this.selectRang.maxRang = this._currentRang;
         this.maps = this.mapsarr;
         this.onChange(null);
      }
      
      public function get mapName() : String
      {
         return this.mapsCombo.selectedItem.gameName;
      }
      
      public function get mapID() : Object
      {
         return this.themeCombo.selectedItem.id;
      }
      
      public function get deathMatch() : Boolean
      {
         return !this.dmCheck.enable;
      }
      
      public function get autoBalance() : Boolean
      {
         return this.ab.checked;
      }
      
      public function get friendlyFire() : Boolean
      {
         return this.ff.checked;
      }
      
      public function get PrivateBattle() : Boolean
      {
         return this.privateCheck.checked;
      }
      
      public function get PayBattle() : Boolean
      {
         return this.payCheck.checked;
      }
      
      public function get inventoryBattle() : Boolean
      {
         return this.payCheck.checked && this.inventoryCheck.checked;
      }
      
      public function get CaptureTheFlag() : Boolean
      {
         return !this.ctfCheck.enable;
      }
      
      public function get time() : int
      {
         return this.minutes.value * 60;
      }
      
      public function get numPlayers() : int
      {
         return this.players.value;
      }
      
      public function get numKills() : int
      {
         return this.kills.value;
      }
      
      public function get numFlags() : int
      {
         return this.flags.value;
      }
      
      public function get haveSubscribe() : Boolean
      {
         return this._haveSubscribe;
      }
      
      public function set haveSubscribe(value:Boolean) : void
      {
         this._haveSubscribe = value;
         this.onPayCheckClick();
      }
      
      private function addResizeListener(e:Event) : void
      {
         this.autoname = true;
         this.startButton.enable = false;
         this.nameGame.textField.addEventListener(FocusEvent.FOCUS_IN,this.checkAutoName);
         this.nameGame.textField.addEventListener(FocusEvent.FOCUS_OUT,this.checkAutoName);
         addEventListener(LoginFormEvent.TEXT_CHANGED,this.checkName);
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize(null);
      }
      
      private function removeResizeListener(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
         removeEventListener(LoginFormEvent.TEXT_CHANGED,this.checkName);
         this.nameGame.textField.removeEventListener(FocusEvent.FOCUS_IN,this.checkAutoName);
         this.nameGame.textField.removeEventListener(FocusEvent.FOCUS_OUT,this.checkAutoName);
      }
      
      public function get minRang() : int
      {
         return this.selectRang.minRang;
      }
      
      public function get maxRang() : int
      {
         return this.selectRang.maxRang;
      }
      
      private function ConfigUI(e:Event) : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.MAP_NAME_LABEL = localeService.getText(TextConst.BATTLE_CREATE_PANEL_MAP_NAME_LABEL);
         this.MAP_TYPE_LABEL = localeService.getText(TextConst.BATTLE_CREATE_PANEL_MAP_TYPE_LABEL);
         this.MAP_THEME_LABEL = localeService.getText(TextConst.BATTLE_CREATE_PANEL_MAP_THEME_LABEL);
         this.BUTTON_DEATHMATCH = localeService.getText(TextConst.BATTLE_CREATE_PANEL_BUTTON_DEATHMATCH);
         this.BUTTON_TEAM_DEATHMATCH = localeService.getText(TextConst.BATTLE_CREATE_PANEL_BUTTON_TEAM_DEATHMATCH);
         this.BUTTON_CAPTURE_THE_FLAG = localeService.getText(TextConst.BATTLE_CREATE_PANEL_BUTTON_CAPTURE_THE_FLAG);
         this.BUTTON_START = localeService.getText(TextConst.BATTLE_CREATE_PANEL_BUTTON_START);
         this.STEPPER_MAX_PLAYERS = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_MAX_PLAYERS);
         this.STEPPER_MAX_TEAM_SIZE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_MAX_TEAM_SIZE);
         this.STEPPER_TIME_LIMIT = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_TIME_LIMIT);
         this.STEPPER_KILLS_LIMIT = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_KILLS_LIMIT);
         this.STEPPER_FLAG_LIMIT = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_FLAG_LIMIT);
         this.CHECKBOX_AUTOBALANCE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_AUTOBALANCE);
         this.CHECKBOX_FRIENDLY_FIRE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_FRIENDLY_FIRE);
         this.CHECKBOX_PRIVATE_BATTLE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_PRIVATE_BATTLE);
         this.CHECKBOX_PAY_BATTLE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_PAY_BATTLE);
         this.CHECKBOX_BONUS = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_BONUS_BATTLE);
         this.COST_LABEL = localeService.getText(TextConst.BATTLE_CREATE_PANEL_LABEL_COST_BATTLE) + ": ";
         removeEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         this.mainBackground = TankWindowWithHeader.createWindow("СОЗДАНИЕ БИТВЫ");
         addChild(this.mainBackground);
         this.nameGame = new TankInput();
         this.nameGameCheckIcon = new InputCheckIcon();
         this.searchTimer.addEventListener(TimerEvent.TIMER,this.updateByTime);
         this.nameGame.label = this.MAP_NAME_LABEL;
         this.nameGame.x = this.nameGame.width - this.nameGame.textField.width + 10;
         this.nameGame.y = 11;
         this.nameGameCheckIcon.y = 18;
         this.nameGame.maxChars = 25;
         addChild(this.nameGame);
         addChild(this.nameGameCheckIcon);
         this.nameGameState = NAMEGAME_STATE_OFF;
		 addChild(cn);
         cn.addChild(this.ab);
         cn.addChild(this.ff);
         cn.addChild(this.privateCheck);
         cn.addChild(this.payCheck);
         this.payCheck.type = TankCheckBox.PAY;
         this.payCheck.label = this.CHECKBOX_PAY_BATTLE;
         this.payCheck.addEventListener(MouseEvent.CLICK,this.onPayCheckClick);
         this.payCheck.visible = true;
         cn.addChild(this.inventoryCheck);
         this.inventoryCheck.type = TankCheckBox.INVENTORY;
         this.inventoryCheck.label = this.CHECKBOX_BONUS;
         this.inventoryCheck.visible = false;
         addChild(this.players);
         this.players.icon = BattleInfoIcons.PLAYERS;
         this.players.addEventListener(Event.CHANGE,this.calculatePayment);
         addChild(this.minutes);
         this.minutes.label = this.STEPPER_TIME_LIMIT;
         this.minutes.icon = BattleInfoIcons.TIME_LIMIT;
         this.minutes.addEventListener(Event.CHANGE,this.calculatePayment);
         addChild(this.kills);
         this.kills.label = this.STEPPER_KILLS_LIMIT;
         this.kills.icon = BattleInfoIcons.KILL_LIMIT;
         this.kills.addEventListener(Event.CHANGE,this.calculatePayment);
         addChild(this.flags);
         this.flags.label = this.STEPPER_FLAG_LIMIT;
         this.flags.icon = BattleInfoIcons.CTF;
         this.flags.visible = false;
         this.flags.addEventListener(Event.CHANGE,this.calculatePayment);
         this.minutes.minValue = 0;
         this.minutes.maxValue = 999;
         this.minutes.value = 15;
         this.kills.minValue = 0;
         this.kills.maxValue = 999;
         this.flags.minValue = 0;
         this.flags.maxValue = 999;
         this.players.label = this.STEPPER_MAX_PLAYERS;
         this.startButton.x = 320;
         addChild(this.startButton);
         addChild(this.info);
         this.info.x = 11;
         this.info.y = 81;
         addChild(this.selectRang);
         this.selectRang.x = 11;
         this.selectRang.minValue = 1;
         this.selectRang.maxValue = 30;
         this.selectRang.tickInterval = 1;
         this.selectRang.addEventListener(SliderEvent.CHANGE_VALUE,this.onSliderChangeValue);
         this.dmCheck.label = this.BUTTON_DEATHMATCH;
         this.tdmCheck.label = this.BUTTON_TEAM_DEATHMATCH;
         this.tdmCheck.enable = true;
         this.ctfCheck.label = this.BUTTON_CAPTURE_THE_FLAG;
         this.ctfCheck.enable = true;
         addChild(this.dmCheck);
         addChild(this.tdmCheck);
         addChild(this.ctfCheck);
         this.dmCheck.enable = false;
         this.ab.checked = true;
         this.ff.checked = false;
         this.ff.visible = false;
         this.ab.visible = false;
         this.dmCheck.addEventListener(MouseEvent.CLICK,this.triggerTypeGame);
         this.tdmCheck.addEventListener(MouseEvent.CLICK,this.triggerTypeGame);
         this.ctfCheck.addEventListener(MouseEvent.CLICK,this.triggerTypeGame);
         this.ab.type = TankCheckBox.AUTO_BALANCE;
         this.ab.label = this.CHECKBOX_AUTOBALANCE;
         this.ff.type = TankCheckBox.FRIENDLY_FIRE;
         this.ff.label = this.CHECKBOX_FRIENDLY_FIRE;
         this.privateCheck.type = TankCheckBox.INVITE_ONLY;
         this.privateCheck.label = this.CHECKBOX_PRIVATE_BATTLE;
         this.startButton.label = this.BUTTON_START;
         this.startButton.addEventListener(MouseEvent.CLICK,this.startGame);
         this.mapsCombo.label = this.MAP_TYPE_LABEL;
         this.mapsCombo.y = 46;
         this.mapsCombo.x = this.nameGame.width - this.nameGame.textField.width + 10;
         addChild(this.mapsCombo);
         this.themeCombo.y = 46;
         this.themeCombo.label = this.MAP_THEME_LABEL;
         addChild(this.themeCombo);
         cn.addChild(this.noSubscribeAlert);
         this.noSubscribeAlert.visible = false;
		 noSubscribeAlert.ret(localeService.getText(TextConst.BATTLE_CREATE_PANEL_LABEL_NO_SUBSCRIBE_BATTLE_С));
         visible = true;
         this.calculatePayment();
         this.mapsCombo.addEventListener(Event.CHANGE,this.onChange);
         this.onChange(null);
		 onPayCheckClick();
      }
      
      public function set nameGameState(value:int) : void
      {
         this._nameGameState = value;
         if(value == NAMEGAME_STATE_OFF)
         {
            this.nameGameCheckIcon.visible = false;
            Main.writeVarsToConsoleChannel("BATTLE SELECT","NameChechIcon OFF");
         }
         else
         {
            Main.writeVarsToConsoleChannel("BATTLE SELECT","NameChechIcon ON");
            this.nameGameCheckIcon.visible = true;
            this.nameGameCheckIcon.gotoAndStop(value);
         }
      }
      
      public function get nameGameState() : int
      {
         return this._nameGameState;
      }
      
      private function onPayCheckClick(e:MouseEvent = null) : void
      {
         if(!this._haveSubscribe)
         {
            this.payCheck.checked = false;
         }
         this.inventoryCheck.visible = this.payCheck.checked && this._haveSubscribe;
         this.noSubscribeAlert.visible = !this._haveSubscribe;
         this.payCheck.visible = this._haveSubscribe;
         this.inventoryCheck.checked = !this.payCheck.checked;
         this.calculatePayment();
      }
      
      private function calculatePayment(e:Event = null) : void
      {
         if(this.payCheck.checked)
         {
            this.startButton.enable = this._haveSubscribe && this.nameGame.validValue && this.nameGameState == NAMEGAME_STATE_OFF;
         }
         else
         {
            this.startButton.enable = ((!this.dmCheck.enable || !this.tdmCheck.enable) && (this.time > 0 || this.numKills > 0) || !this.ctfCheck.enable && (this.time > 0 || this.numFlags > 0)) && this.nameGame.validValue && this.nameGameState == NAMEGAME_STATE_OFF;
         }
         this.costLabel.value = Boolean(this.COST_LABEL + this._haveSubscribe)?"yes":"no";
         this.onResize(null);
      }
      
      private function checkName(e:LoginFormEvent) : void
      {
         this.nameGame.validValue = this.nameGame.textField.length > 0;
         this.startButton.enable = false;
         if(e != null)
         {
            this.searchTimer.stop();
            this.searchTimer.start();
         }
      }
      
      private function setAutoName() : void
      {
         var item:Object = this.mapsCombo.selectedItem;
         var aname:String = item.gameName + " " + this.typeGame;
         if(this.autoname)
         {
            this.gameName = aname;
            this.nameGame.validValue = true;
            this.calculatePayment();
         }
         else
         {
            this.checkName(null);
         }
      }
      
      private function checkAutoName(e:FocusEvent = null) : void
      {
         if(e.type == FocusEvent.FOCUS_IN)
         {
            this.nameGameState = NAMEGAME_STATE_OFF;
            this.startButton.enable = this.nameGame.textField.length > 0;
            if(this.autoname)
            {
               this.gameName = "";
               this.autoname = false;
               this.checkName(null);
            }
            this.nameGameState = NAMEGAME_STATE_OFF;
         }
         if(e.type == FocusEvent.FOCUS_OUT)
         {
            if(this.nameGame.textField.length == 0)
            {
               this.autoname = true;
               this.setAutoName();
            }
         }
      }
      
      private function updateThemesCombo(selectedMap:Object) : void
      {
         var length:int = 0;
         var themeName:* = null;
         var themes:Dictionary = this.mapsThemes[selectedMap.gameName];
         if(themes != null)
         {
            length = 0;
            this.themeCombo.clear();
            for(themeName in themes)
            {
               length++;
               this.themeCombo.addItem({
                  "gameName":themeName,
                  "id":themes[themeName],
                  "rang":0
               });
            }
            this.themeCombo.visible = length > 1;
         }
         this.themeCombo.dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onChange(e:Event) : void
      {
         var item:Object = this.mapsCombo.selectedItem;
         var min:int = item.minRank < 1?int(1):int(item.minRank);
         var max:int = item.maxRank > 30?int(30):int(item.maxRank);
         //this.info.setUp("",0,0,0,0,0);
         this.selectRang.maxValue = max;
         this.selectRang.minValue = min;
         if(this.selectRang.minRang < this.selectRang.minValue)
         {
            this.selectRang.minRang = this.selectRang.minValue;
         }
         if(this.selectRang.maxRang > this.selectRang.maxValue)
         {
            this.selectRang.maxRang = this.selectRang.maxValue;
         }
         this.players.maxValue = this.players.value = !this.dmCheck.enable?int(item.maxP):int(int(item.maxP / 2));
         this.maxP = item.maxP;
         this.ctfEnable = item.ctf;
         this.ctfCheck.visible = this.ctfEnable;
         this.tdmEnable = item.tdm;
         this.ctfCheck.visible = this.ctfEnable;
         this.tdmCheck.visible = this.tdmEnable;
         if(!this.tdmEnable)
         {
            this.triggerTypeGame();
         }
         if(!this.ctfEnable && !this.deathMatch)
         {
            this.dmCheck.enable = true;
            this.tdmCheck.enable = false;
            this.ctfCheck.enable = true;
            this.ff.visible = true;
            this.ab.visible = true;
            this.players.maxValue = int(this.maxP / 2);
            this.players.minValue = 1;
            this.players.value = int(this.maxP / 2);
            this.players.label = this.STEPPER_MAX_TEAM_SIZE;
            this.flags.visible = false;
            this.kills.visible = true;
         }
         else
         {
            this.flags.visible = this.ctfEnable && !this.ctfCheck.enable;
            this.kills.visible = !this.flags.visible;
         }
         this.updateThemesCombo(item);
         this.onResize(null);
         this.setAutoName();
         this.calculatePayment();
      }
      
      private function startGame(e:MouseEvent) : void
      {
         dispatchEvent(new BattleListEvent(BattleListEvent.START_CREATED_GAME));
      }
      
      private function triggerTypeGame(e:MouseEvent = null) : void
      {
         var trgt:TypeBattleButton = null;
         if(e != null)
         {
            trgt = e.currentTarget as TypeBattleButton;
         }
         Main.writeVarsToConsoleChannel("BATTLE SELECT","Create Battle type %1",e);
         if(trgt == this.dmCheck || e == null)
         {
            this.dmCheck.enable = false;
            this.tdmCheck.enable = true;
            this.ctfCheck.enable = true;
            this.ff.visible = false;
            this.ab.visible = false;
            this.players.maxValue = this.maxP;
            this.players.minValue = 2;
            this.players.value = this.maxP;
            this.typeGame = "DM";
            this.players.label = this.STEPPER_MAX_PLAYERS;
            this.flags.visible = false;
            this.kills.visible = true;
         }
         else if(trgt == this.tdmCheck)
         {
            this.dmCheck.enable = true;
            this.tdmCheck.enable = false;
            this.ctfCheck.enable = true;
            this.ff.visible = true;
            this.ab.visible = true;
            this.players.maxValue = int(this.maxP / 2);
            this.players.minValue = 1;
            this.players.value = int(this.maxP / 2);
            this.players.label = this.STEPPER_MAX_TEAM_SIZE;
            this.typeGame = "TDM";
            this.flags.visible = false;
            this.kills.visible = true;
         }
         else
         {
            this.dmCheck.enable = true;
            this.ctfCheck.enable = false;
            this.tdmCheck.enable = true;
            this.ff.visible = true;
            this.ab.visible = true;
            this.players.maxValue = int(this.maxP / 2);
            this.players.minValue = 1;
            this.players.value = int(this.maxP / 2);
            this.players.label = this.STEPPER_MAX_TEAM_SIZE;
            this.flags.visible = true;
            this.kills.visible = false;
            this.typeGame = "CTF";
         }
         this.onResize(null);
         this.setAutoName();
         stage.focus = null;
         this.calculatePayment();
      }
      
      private function onResize(e:Event) : void
      {
         var numSpace:int = 0;
         if(stage == null)
         {
            return;
         }
         var minWidth:int = int(Math.max(100,stage.stageWidth));
         this.mainBackground.width = minWidth / 3;
         this.mainBackground.height = Math.max(stage.stageHeight - 60,530);
         this.x = this.mainBackground.width * 2;
         this.y = 60;
         this.nameGame.width = this.mainBackground.width - this.nameGame._label.textWidth - 35;
         this.nameGameCheckIcon.x = this.mainBackground.width - this.nameGameCheckIcon.width - 11;
         if(this.amountOfThemesForMap(this.mapsCombo.selectedItem.gameName) > 1)
         {
            this.mapsCombo.width = int(this.mainBackground.width / 2 - this.mapsCombo.x - 11);
            this.themeCombo.x = this.mainBackground.width / 2 + this.mapsCombo.x;
            this.themeCombo.width = int(this.mainBackground.width / 2 - this.mapsCombo.x - 11);
         }
         else
         {
            this.mapsCombo.width = this.mainBackground.width - this.nameGame._label.textWidth - 35;
         }
         this.info.width = this.mainBackground.width - 22;
         this.info.height = int(this.mainBackground.height - 415);
         this.selectRang.y = this.info.height + 86;
         this.selectRang.width = this.info.width;
         this.dmCheck.x = 11;
         this.dmCheck.y = this.selectRang.y + 35;
         this.dmCheck.width = int(this.info.width / (this.ctfEnable?3:this.tdmEnable?2:1) - 2.5);
         this.tdmCheck.x = this.dmCheck.width + 16;
         this.tdmCheck.y = this.dmCheck.y;
         this.tdmCheck.width = this.dmCheck.width;
         this.ctfCheck.x = this.dmCheck.width * 2 + 21;
         this.ctfCheck.y = this.dmCheck.y;
         this.ctfCheck.width = this.dmCheck.width;
         this.flags.y = this.kills.y = this.minutes.y = this.players.y = this.dmCheck.y + 80;
         numSpace = int((this.mainBackground.width - this.players.width - this.minutes.width - this.kills.width) / 4);
         this.players.x = numSpace;
         this.minutes.x = this.players.width + numSpace * 2;
         this.kills.x = this.players.width + this.minutes.width + numSpace * 3;
         this.flags.x = this.players.width + this.minutes.width + numSpace * 3;
		 cn.x = 11;
		 cn.y = this.kills.y + this.kills.height;//privateCheck
         this.payCheck.y = this.privateCheck.height + 11;
		 this.inventoryCheck.y = this.payCheck.y + this.payCheck.height + 11;
		 this.ab.x = this.ctfCheck.x;
		 this.ff.x = this.ctfCheck.x;
         this.ff.y = this.ab.y + this.ab.height + 11;
         this.noSubscribeAlert.width = this.mainBackground.width - numSpace * 4;
		 this.noSubscribeAlert.y = this.inventoryCheck.y + 7;
         numSpace = int((this.mainBackground.width - this.ab.width - this.ff.width) / 3);
         this.startButton.x = this.mainBackground.width - this.startButton.width - 11;
         this.startButton.y = this.mainBackground.height - 42;
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
         var numSpace:int = 0;
         var minWidth:int = stage != null?int(int(Math.max(100,stage.stageWidth))):int(100);
         this.mainBackground.width = minWidth / 3;
         this.mainBackground.height = stage != null?Number(Math.max(stage.stageHeight - 60,530)):Number(530);
         this.x = this.mainBackground.width * 2;
         this.y = 60;
         this.nameGame.width = this.mainBackground.width - this.nameGame._label.textWidth - 35;
         if(this.amountOfThemesForMap(this.mapsCombo.selectedItem.gameName) > 1)
         {
            this.mapsCombo.width = int(this.mainBackground.width / 2 - this.mapsCombo.x - 11);
            this.themeCombo.x = this.mainBackground.width / 2 + this.mapsCombo.x;
            this.themeCombo.width = int(this.mainBackground.width / 2 - this.mapsCombo.x - 11);
         }
         else
         {
            this.mapsCombo.width = this.mainBackground.width - this.nameGame._label.textWidth - 35;
         }
         this.info.width = this.mainBackground.width - 22;
         this.info.height = int(this.mainBackground.height - 415);
         this.selectRang.y = this.info.height + 86;
         this.selectRang.width = this.info.width;
         this.dmCheck.x = 11;
         this.dmCheck.y = this.selectRang.y + 35;
         this.dmCheck.width = int(this.info.width / (!!this.ctfEnable?3:!!this.tdmEnable?2:1) - 2.5);
         this.tdmCheck.x = this.dmCheck.width + 16;
         this.tdmCheck.y = this.dmCheck.y;
         this.tdmCheck.width = this.dmCheck.width;
         this.ctfCheck.x = this.dmCheck.width * 2 + 21;
         this.ctfCheck.y = this.dmCheck.y;
         this.ctfCheck.width = this.dmCheck.width;
         this.flags.y = this.kills.y = this.minutes.y = this.players.y = this.dmCheck.y + 80;
         numSpace = int((this.mainBackground.width - this.players.width - this.minutes.width - this.kills.width) / 4);
         this.players.x = numSpace;
         this.minutes.x = this.players.width + numSpace * 2;
         this.kills.x = this.players.width + this.minutes.width + numSpace * 3;
         this.flags.x = this.players.width + this.minutes.width + numSpace * 3;
         //this.ff.y = this.ab.y = this.players.y + 45;
         //this.noSubscribeAlert.x = numSpace;
         //this.noSubscribeAlert.width = this.mainBackground.width - numSpace * 2;
         numSpace = int((this.mainBackground.width - this.ab.width - this.ff.width) / 3);
         //this.ab.x = numSpace;
         //this.ff.x = numSpace * 2 + this.ab.width;
         //this.privateCheck.x = 11;
         //this.privateCheck.y = this.mainBackground.height - 42;
         //this.payCheck.x = this.ab.x;
         //this.payCheck.y = this.ab.y + 40;
         //this.inventoryCheck.x = this.ff.x;
         //this.inventoryCheck.y = this.ff.y + 40;
         //this.noSubscribeAlert.y = this.payCheck.y;
         this.startButton.x = this.mainBackground.width - this.startButton.width - 11;
         this.startButton.y = this.mainBackground.height - 42;
      }
      
      public function hide() : void
      {
         this.dmCheck.removeEventListener(MouseEvent.CLICK,this.triggerTypeGame);
         this.tdmCheck.removeEventListener(MouseEvent.CLICK,this.triggerTypeGame);
         this.ctfCheck.removeEventListener(MouseEvent.CLICK,this.triggerTypeGame);
         this.startButton.removeEventListener(MouseEvent.CLICK,this.startGame);
         this.delayTimer.removeEventListener(TimerEvent.TIMER,this.resizeList);
      }
      
      private function onSliderChangeValue(e:SliderEvent) : void
      {
      }
      
      private function amountOfThemesForMap(mapName:String) : int
      {
         var themeName:* = null;
         if(this.mapsThemes[mapName] == null)
         {
            trace("mapsThemes " + mapName + " null");
            return 0;
         }
         var amount:int = 0;
         for(themeName in this.mapsThemes[mapName])
         {
            trace("mapName themeName: " + themeName);
            amount++;
         }
         return amount;
      }
      
      private function updateByTime(e:TimerEvent) : void
      {
         this.nameGameState = NAMEGAME_STATE_PROGRESS;
         this.startButton.enable = false;
         dispatchEvent(new BattleListEvent(BattleListEvent.NEW_BATTLE_NAME_ADDED));
         this.searchTimer.stop();
      }
   }
}
