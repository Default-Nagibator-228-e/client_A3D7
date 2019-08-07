package alternativa.tanks.model.panel
{
   import alternativa.init.Main;
   import alternativa.tanks.gui.AlertBugWindow;
   import forms.news.edit.ParseNewSob;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import alternativa.network.connecting.ServerConnectionService;
   import alternativa.network.connecting.ServerConnectionServiceImpl;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.service.IModelService;
   import alternativa.tanks.JPGencoder.JPGEncoder;
   import alternativa.tanks.gui.BugReportWindow;
   import utils.clips.Newes;
   import forms.cong.Cong;
   import alternativa.tanks.gui.ReferalWindowEvent;
   import forms.settings.SettingsWindow;
   import forms.settings.SettingsWindowEvent;
   import forms.friends.FriendsWindow;
   import forms.shop.windows.ShopWindow;
   import forms.shop.windows.ShopWindowParams;
   import alternativa.tanks.help.ButtonBarHelper;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.help.MainMenuHelper;
   import alternativa.tanks.help.MoneyHelper;
   import alternativa.tanks.help.RankBarHelper;
   import alternativa.tanks.help.RankHelper;
   import alternativa.tanks.help.RatingIndicatorHelper;
   import alternativa.tanks.help.ScoreHelper;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.BattleSelectModel;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IGarage;
   import alternativa.tanks.model.antiaddiction.IAntiAddictionAlert;
   import alternativa.tanks.model.payment.IPayment;
   import alternativa.tanks.model.payment.IPaymentListener;
   import alternativa.tanks.model.referals.IReferals;
   import alternativa.tanks.model.referals.IReferalsListener;
   import alternativa.tanks.model.top.TopModel;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.StatisticsModel;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.gui.chat.ChatModel;
   import alternativa.tanks.models.battlefield.inventory.InventoryModel;
   import alternativa.tanks.models.ctf.CTFModel;
   import alternativa.tanks.models.inventory.IInventory;
   import alternativa.tanks.service.money.IMoneyListener;
   import alternativa.tanks.service.money.IMoneyService;
   import alternativa.types.Long;
   import utils.client.models.ctf.ICaptureTheFlagModelBase;
   import controls.PlayerInfo;
   import controls.Rank;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import forms.Alert;
   import forms.AlertAnswer;
   import forms.MainPanel;
   import forms.ServerRedirectAlert;
   import forms.ServerStopAlert;
   import forms.events.AlertEvent;
   import forms.events.MainButtonBarEvents;
   import forms.zad.Zadan;
   import utils.client.battleselect.IBattleSelectModelBase;
   import utils.client.panel.model.IPanelModelBase;
   import utils.client.panel.model.ITopModelBase;
   import utils.client.panel.model.PanelModelBase;
   import utils.client.panel.model.referals.IReferalsModelBase;
   import utils.client.panel.model.referals.ReferalsModelBase;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.utils.WeaponsManager;
   import alternativa.tanks.models.battlefield.gui.UpdateRankLabel;
   
   public class PanelModel extends PanelModelBase implements IPanelModelBase, IObjectLoadListener, IPanel, IPaymentListener, IMoneyService, IBattleSettings, IReferalsListener
   {
      
      private static const PARAM_SHOW_SKY_BOX:String = "showSkyBox";
      
      private static const PARAM_SHOW_FPS:String = "showFPS";
      
      private static const PARAM_SHOW_BATTLE_CHAT:String = "showBattleChat";
      
      private static const PARAM_ADAPTIVE_FPS:String = "adaptiveFPS";
      
      private static const PARAM_INVERSE_BACK_DRIVING:String = "inverseBackDriving";
      
      private static const PARAM_BGSOUND:String = "bgSound";
      
      private static const PARAM_MUTE_SOUND:String = "muteSound";
      
      private static const PARAM_SOUND_VOLUME:String = "volume";
      
      private static const PARAM_MIPMAPPING:String = "mipMapping";
      
      private static const PARAM_FOG:String = "fog";
      
      private static const PARAM_DUST:String = "dust";
      
      private static const SHADOWS:String = "shadows";
	  
	  private static const SHADOWSB:String = "shadowsb";
	  
	  private static const SHADOWSM:String = "shadowsm";
	  
	  private static const S:String = "ssao";
      
      private static const DEFFERED_LIGHTING:String = "defferedLighting";
      
      private static const ANIMATE_TRACKS:String = "animateTracks";
      
      private static const HELPER_GROUP_KEY:String = "PanelModel";
      
      private static const DEFAULT_VOLUME:Number = 0.7;
       
      
      private var modelRegister:IModelService;
      
      private var storage:SharedObject;
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var loaderWindow:ILoaderWindowService;
      
      public var mainPanel:MainPanel;
      
      private var kills:int;
      
      private var deaths:int;
      
      private var screenShot:BitmapData;
      
      private var cropedScreenshot:BitmapData;
      
      private var screenPixelCurrentNum:int;
      
      private var reportWindow:BugReportWindow;
      
      private var settingsWindow:SettingsWindow;
            	  
	  private var friendsWindow:FriendsWindow;
      
      private var encoder:JPGEncoder;
      
      private var encodeInt:uint;
      
      private var encodeDelay:int = 5;
      
      private var _userName:String;
      
      private var userRank:int;
      
      private var startRating:Number;
      
      public var _crystal:int;
      
      private var emailConfirmed:Boolean;
      
      private const HELPER_RANK:int = 1;
      
      private const HELPER_RANK_BAR:int = 2;
      
      private const HELPER_RATING_INDICATOR:int = 3;
      
      private const HELPER_MAIN_MENU:int = 5;
      
      private const HELPER_BUTTON_BAR:int = 6;
      
      private const HELPER_MONEY:int = 7;
      
      private const HELPER_SCORE:int = 10;
      
      private var moneyListeners:Array;
      
      private var rankHelper:RankHelper;
      
      private var rankBarHelper:RankBarHelper;
      
      private var ratingHelper:RatingIndicatorHelper;
      
      private var mainMenuHelper:MainMenuHelper;
      
      private var buttonBarHelper:ButtonBarHelper;
      
      private var moneyHelper:MoneyHelper;
      
      private var scoreHelper:ScoreHelper;
      
      private var stopAlert:ServerStopAlert;
      
      private var score:int;
      
      private var nextScore:int;
      
      private var isTester:Boolean;
      
      private var email:String;
      
      private var showRedirectAlertTimer:Timer;
      
      private var redirectAlert:ServerRedirectAlert;
      
      private var serverToRedirectTo:String;
      
      public var isBattleSelect:Boolean = false;
      
      public var isGarageSelect:Boolean = false;
      
      public var isTopSelect:Boolean = false;
      
      public var isInBattle:Boolean = false;
	  
	  public var isP:Boolean = false;
	  
	  public var isF:Boolean = false;
      
      public var panelListeners:Vector.<IModel>;
      
      public var networker:Network;
	  
	  public var info:PlayerInfo;
	  
	  private var gy:Cong;
	  
	  private var fffr:ShopWindow;
	  
	  private var alert:Alert;
	  
	  public var zad:Zadan = new Zadan();
	  
	  public var sob:ParseNewSob = new ParseNewSob();
      
      public function PanelModel()
      {
         this.panelListeners = new Vector.<IModel>();
         super();
         _interfaces.push(IModel,IPanel,IPanelModelBase,IObjectLoadListener,IPaymentListener,IReferalsListener);
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
         this.layer = Main.contentUILayer;
         this.mainPanel = new MainPanel();
         this.loaderWindow = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
      }
      
      public function initObject(clientObject:ClientObject, crystal:int, email:String, isTester:Boolean, name:String, nextScore:int, place:int, rang:int, rating:Number, score:int) : void
      {
         this.isTester = isTester;
         this.email = email;
         this.showPanel();
         this.storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         if(this.storage == null)
         {
            throw new Error("storage is null");
         }
         this.storage.data.userRank = rang;
         this.storage.flush();
         this.nextScore = nextScore;
         this.userRank = rang;
         this.mainPanel.rang = rang;
         this.mainPanel.isTester = isTester;
         this._userName = name;
         info = this.mainPanel.playerInfo;
         info.playerName = name;
         this._crystal = crystal;
         info.crystals = crystal;
         info.position = place + 1;
         info.rating = rating;
         info.updateScore(score,nextScore);
         this.startRating = rating;
         this.lock();
         this.objectLoaded(clientObject);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.networker = Network(Main.osgi.getService(INetworker));
		 this.networker.send("lobby;get_friend");
         this.clientObject = object;
         this.moneyListeners = new Array();
         Main.osgi.registerService(IMoneyService,this);
         this.setSoundSettings();
         this.mainPanel.buttonBar.soundOn = !this.getSoundMute();
         var helpService:IHelpService = Main.osgi.getService(IHelpService) as IHelpService;
         this.rankHelper = new RankHelper();
         this.rankBarHelper = new RankBarHelper();
         this.ratingHelper = new RatingIndicatorHelper();
         this.mainMenuHelper = new MainMenuHelper();
         this.buttonBarHelper = new ButtonBarHelper();
         this.moneyHelper = new MoneyHelper();
         this.scoreHelper = new ScoreHelper();
         this.unlock();
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_RANK,this.rankHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_RANK_BAR,this.rankBarHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_RATING_INDICATOR,this.ratingHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_MAIN_MENU,this.mainMenuHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_BUTTON_BAR,this.buttonBarHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY, this.HELPER_SCORE, this.scoreHelper, true);
		 Main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPrMened);
      }
      
      private function setSoundSettings() : void
      {
         SoundMixer.soundTransform = new SoundTransform(this.getSoundMute()?Number(0):Number(this.getSoundVolume()));
      }
      
      private function getSoundMute() : Boolean
      {
         return this.getBoolean(PARAM_MUTE_SOUND,false);
      }
      
      private function getSoundVolume() : Number
      {
         return this.getNumber(PARAM_SOUND_VOLUME,DEFAULT_VOLUME);
      }
      
      private function removeDisplayObject(displayObect:DisplayObject) : void
      {
         if(displayObect != null && displayObect.parent != null)
         {
            displayObect.parent.removeChild(displayObect);
         }
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         Main.writeToConsole("PanelModel objectUnloaded");
         Main.unblur();
         this.mainPanel.hide();
         this.hidePanel();
         this.removeDisplayObject(this.settingsWindow);
         this.removeDisplayObject(this.reportWindow);
		 Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPrMened);
         var helpService:IHelpService = Main.osgi.getService(IHelpService) as IHelpService;
         helpService.hideHelp();
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_RANK);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_RANK_BAR);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_RATING_INDICATOR);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_MAIN_MENU);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_BUTTON_BAR);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_SCORE);
         this.rankHelper = null;
         this.rankBarHelper = null;
         this.ratingHelper = null;
         this.mainMenuHelper = null;
         this.buttonBarHelper = null;
         this.moneyHelper = null;
         this.scoreHelper = null;
         this.moneyListeners = null;
         Main.osgi.unregisterService(IMoneyService);
         this.clientObject = null;
      }
	  
	  private function onPrMened(e:KeyboardEvent) : void
      {
		 if(e.keyCode == Keyboard.ESCAPE)
         {
			 if (isInBattle)
			 {
				 if (isGarageSelect)
				 {
					 GarageModel(Main.osgi.getService(IGarage)).objectUnloaded(null);
					 GarageModel(Main.osgi.getService(IGarage)).kostil = false;
					 Main.osgi.unregisterService(IGarage);
					 Main.unblur();
					 PanelModel(Main.osgi.getService(IPanel)).partSelected(4);
					 Network(Main.osgi.getService(INetworker)).send("battle;suicide1");
					 //Network(Main.osgi.getService(INetworker)).send("battle;suicide");
					 PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.closeButton.visible = true;
					 PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.closeButton1.visible = false;
					 PanelModel(Main.osgi.getService(IPanel)).isGarageSelect = false;
					 //Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPrMened);
					 (BattleController(Main.osgi.getService(IBattleController))).addKeyboardListeners();
					 return;
				 }
				var alert:Alert = new Alert(Alert.ALERT_OPBAT);
				this.dialogsLayer.addChild(alert);
				alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED, this.onAlertButtonPressedBat);
			 }else{
				var alert:Alert = new Alert(Alert.ALERT_QUIT);
				this.dialogsLayer.addChild(alert);
				alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED, this.onAlertButtonPressed);
			 }
         }
      }
      
      public function goToGarage() : void
      {
      }
      
      public function showGarage(obj:Object) : void
      {
         var battle:BattleSelectModel = null;
         (Main.osgi.getService(ILoader) as CheckLoader).addProgress(99);
         //if(!this.isInBattle)
         //{
            Network(Main.osgi.getService(INetworker)).send("lobby;get_garage_data");
         //}
		 if(this.isInBattle)
         {
			Main.blur3();
         }
         if(this.isBattleSelect)
         {
            battle = BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase));
            battle.objectUnloaded(null);
            this.isBattleSelect = false;
            Main.osgi.unregisterService(IBattleSelectModelBase);
         }
		 if(this.isP)
         {
            this.closePaymentWindow();
            this.isP = false;
         }
		 if(this.isF)
         {
			if (friendsWindow == null)
			 {
				 this.isF = false;
			 }else{
				 friendsWindow.visible = false;
				 //this.dialogsLayer.removeChild(friendsWindow);
				 this.isF = false;
			 }
         }
      }
      
      public function onExitFromBattle(sendToServer:Boolean = true) : void
      {
         BattlefieldModel(Main.osgi.getService(IBattleField)).objectUnloaded(null);
         BattleController(Main.osgi.getService(IBattleController)).destroy();
         StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).objectUnloaded(null);
         Network(Main.osgi.getService(INetworker)).removeListener(Main.osgi.getService(IBattleController) as BattleController);
         ChatModel(Main.osgi.getService(IChatBattle)).objectUnloaded(null);
         WeaponsManager.destroy();
		 (Main.osgi.getService(ILobby)).chat.chatModel.chatPanel.chat.cleanMessages();
         var ctfModel:CTFModel = Main.osgi.getService(ICaptureTheFlagModelBase) as CTFModel;
         if(ctfModel != null)
         {
            ctfModel.objectUnloaded(null);
         }
         Main.osgi.unregisterService(ICaptureTheFlagModelBase);
         var modelsService:IModelService = IModelService(Main.osgi.getService(IModelService));
         this.isInBattle = false;
         if(sendToServer)
         {
            this.networker.send("battle;i_exit_from_battle");
         }
      }
      
      public function goToPayment() : void
      {
      }
      
      public function serverHalt(clientObject:ClientObject, timeBeforeRestart:int, delayBeforShowRedirectMessage:int, redirectMessageIdle:int, serverToRedirectTo:String) : void
      {
         if(serverToRedirectTo != null && serverToRedirectTo != "null")
         {
            this.serverToRedirectTo = serverToRedirectTo;
            this.redirectAlert = new ServerRedirectAlert(redirectMessageIdle);
            this.dialogsLayer.addChild(this.redirectAlert);
            this.showRedirectAlertTimer = new Timer(redirectMessageIdle * 1000,1);
            this.showRedirectAlertTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.hideRedirectAlert);
            this.showRedirectAlertTimer.start();
            this.alignRedirectAlert();
            Main.stage.addEventListener(Event.RESIZE,this.alignRedirectAlert);
         }
         else
         {
            this.stopAlert = new ServerStopAlert(timeBeforeRestart);
            this.dialogsLayer.addChild(this.stopAlert);
            this.alignStopAlert();
            Main.stage.addEventListener(Event.RESIZE,this.alignStopAlert);
         }
      }
      
      private function hideRedirectAlert(e:TimerEvent) : void
      {
         Main.stage.removeEventListener(Event.RESIZE,this.alignRedirectAlert);
         this.dialogsLayer.removeChild(this.redirectAlert);
         var lang:String = (Main.osgi.getService(ILocaleService) as ILocaleService).language;
         if(lang == null)
         {
            lang = "en";
         }
         navigateToURL(new URLRequest("http://tankionline.com/battle-" + lang + this.serverToRedirectTo.toString() + ".html"),"_self");
      }
      
      private function alignRedirectAlert(e:Event = null) : void
      {
         this.redirectAlert.x = Math.round((Main.stage.stageWidth - this.redirectAlert.width) * 0.5);
         this.redirectAlert.y = Math.round((Main.stage.stageHeight - this.redirectAlert.height) * 0.5);
      }
      
      private function alignStopAlert(e:Event = null) : void
      {
         this.stopAlert.x = Math.round((Main.stage.stageWidth - this.stopAlert.width) * 0.5);
         this.stopAlert.y = Math.round((Main.stage.stageHeight - this.stopAlert.height) * 0.5);
      }
      
      public function showMessage(clientObject:ClientObject, text:String) : void
      {
         this._showMessage(text);
      }
      
      public function _showMessage(text:String) : void
      {
			var alert:Alert = new Alert();
			alert.showAlert(text,[AlertAnswer.OK]);
			this.dialogsLayer.addChild(alert);
      }
      
      public function updateRating(clientObject:ClientObject, rating:Number) : void
      {
         var info:PlayerInfo = this.mainPanel.playerInfo;
         if(this.startRating < rating)
         {
            info.ratingChange = 1;
         }
         else if(this.startRating > rating)
         {
            info.ratingChange = -1;
         }
         else
         {
            info.ratingChange = 0;
         }
         info.rating = rating;
      }
      
      public function updatePlace(clientObject:ClientObject, place:int) : void
      {
         var info:PlayerInfo = this.mainPanel.playerInfo;
         info.position = place + 1;
      }
      
      public function updateRang(clientObject:ClientObject, rang:int, nextScore:int) : void
      {
         var prevRang:* = this.mainPanel.rang;
         this.mainPanel.rang = rang;
         this.userRank = rang;
         this.nextScore = nextScore;
         this.mainPanel.playerInfo.updateScore(this.score,nextScore);
         if(prevRang != rang)
         {
            Main.contentUILayer.addChild(new UpdateRankLabel(Rank.name(rang)));
         }
      }
      
      public function updateScore(clientObject:ClientObject, score:int) : void
      {
         this.score = score;
         this.mainPanel.playerInfo.updateScore(score,this.nextScore);
      }
      
      public function updateKills(clientObject:ClientObject, kills:int) : void
      {
         this.kills = kills;
      }
      
      public function updateDeaths(clientObject:ClientObject, deaths:int) : void
      {
         this.deaths = deaths;
      }
      
      public function updateCrystal(clientObject:ClientObject, crystal:int) : void
      {
         var listener:IMoneyListener = null;
         var info:PlayerInfo = this.mainPanel.playerInfo;
         info.crystals = crystal;
         this._crystal = crystal;
         for(var i:int = 0; i < this.moneyListeners.length; i++)
         {
            listener = this.moneyListeners[i] as IMoneyListener;
            listener.crystalsChanged(crystal);
         }
      }
      
      public function updateRankProgress(clientObject:ClientObject, position:int) : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","updateRankProgress: %1",position);
         var info:PlayerInfo = this.mainPanel.playerInfo;
         info.progress = position;
      }
      
      public function openProfile(clientObject:ClientObject, emailNotice:Boolean, isConfirmEmail:Boolean, antiAddictionEnabled:Boolean, realName:String, idNumber:String) : void
      {
         var listener:IPanelListener = null;
         this.emailConfirmed = isConfirmEmail;
         Main.blur();
         this.settingsWindow = new SettingsWindow(this.userEmail,this.emailConfirmed,antiAddictionEnabled,realName,idNumber);
         this.dialogsLayer.addChild(this.settingsWindow);
         this.settingsWindow.showSkyBox = this.showSkyBox;
         this.settingsWindow.showFPS = this.showFPS;
         this.settingsWindow.showBattleChat = this.showBattleChat;
         this.settingsWindow.adaptiveFPS = this.adaptiveFPS;
         this.settingsWindow.enableMipMapping = this.enableMipMapping;
         this.settingsWindow.volume = this.getSoundVolume();
         this.settingsWindow.inverseBackDriving = this.inverseBackDriving;
         this.settingsWindow.bgSound = this.bgSound;
         this.settingsWindow.useDust = this.useDust;
         this.settingsWindow.useShadows = this.shadows;
         this.settingsWindow.useDefferedLighting = this.defferedLighting;
         this.settingsWindow.useAnimTracks = this.useAnimTracks;
         if(this.settingsWindow.isPasswordChangeDisabled)
         {
            this.settingsWindow.addEventListener(SettingsWindowEvent.CHANGE_PASSWORD,this.onChangePassword);
         }
         this.settingsWindow.addEventListener(SettingsWindowEvent.CANCEL_SETTINGS,this.onSettingsCancel);
         this.settingsWindow.addEventListener(SettingsWindowEvent.ACCEPT_SETTINGS,this.onSettingsComplete);
         this.settingsWindow.addEventListener(SettingsWindowEvent.RESEND_CONFIRMATION,this.onConfirmEmail);
         this.settingsWindow.addEventListener(SettingsWindowEvent.CHANGE_VOLUME,this.onChangeVolume);
         Main.stage.addEventListener(Event.RESIZE,this.alignSettingsWindow);
         this.alignSettingsWindow();
         this.unlock();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.settingsOpened();
            }
         }
      }
      
      private function onChangePassword(event:SettingsWindowEvent) : void
      {
         var localeService:ILocaleService = null;
         var alert:Alert = null;
         if(this.settingsWindow.isPasswordChangeDisabled)
         {
            localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
			alert = new Alert();
			alert.showAlert(localeService.getText(TextConst.SETTINGS_CHANGE_PASSWORD_CONFIRMATION_SENT_TEXT),[AlertAnswer.OK]);
			this.dialogsLayer.addChild(alert);
         }
      }
      
      public function updatePasswordError(clientObject:ClientObject) : void
      {
         this.dialogsLayer.addChild(new Alert(Alert.ERROR_PASSWORD_CHANGE));
      }
      
      public function changeEmailError(clientObject:ClientObject) : void
      {
      }
	  
	  public function showSob() : void
      {
			 Main.blur();
			 Main.blured = true;
			 //this.sob.show();
			 Main.stage.addEventListener(Event.RESIZE, alignSo);
			 alignSo();
			 this.dialogsLayer.addChild(this.sob);
      }
	  
	  public function hideSob() : void
      {
			 //this.zad.hide();
			 this.dialogsLayer.removeChild(this.sob);
			 Main.unblur();
			 Main.stage.removeEventListener(Event.RESIZE,alignSo);
      }
	  
	  private function alignSo(p:Event = null) : void
      {
		 this.sob.x = Math.round((Main.stage.stageWidth - this.sob.width) * 0.5);
         this.sob.y = Math.round((Main.stage.stageHeight - this.sob.height) * 0.5);
      }
	  
	  public function showZadan() : void
      {
			 Main.blur();
			 Main.blured = true;
			 this.zad.show();
			 this.dialogsLayer.addChild(zad);
      }
	  
	  public function hideZadan() : void
      {
			 this.zad.hide();
			 this.dialogsLayer.removeChild(zad);
			 Main.unblur();
      }
      
      public function openPayment(clientObject:ClientObject) : void
      {
         //this.openPaymentWindow();
         //(Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService).hideLoaderWindow();
		 Main.blur();
		 fffr = new ShopWindow(new ShopWindowParams());
		 fffr.show();
		 this.dialogsLayer.addChild(fffr);
		 alignPaymentWindow();
		 this.isP = true;
		 Main.stage.addEventListener(Event.RESIZE,this.alignPaymentWindow);
         this.partSelected(3);
      }
      
      public function closePayment(clientObject:ClientObject) : void
      {
         this.closePaymentWindow();
      }
      
      public function openRefererPanel(clientObject:ClientObject, referalsCount:int, hashUser:String, banner:String, inviteMessageTemplate:String) : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","S -> C openRefererPanel");
         Main.blur();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var url:String = "http://" + localeService.getText(TextConst.GAME_BASE_URL) + "#friend=" + hashUser;
         var referalModel:IReferals = (this.modelRegister.getModelsByInterface(IReferals) as Vector.<IModel>)[0] as IReferals;
         referalModel.getReferalsData();
         this.unlock();
      }
      
      public function startBattle(clientObject:ClientObject) : void
      {
		 this.isBattleSelect = false;
         Main.writeVarsToConsoleChannel("PANEL MODEL","startBattle");
         this.mainPanel.buttonBar.battlesButton.enable = true;
         this.lock();
		 (Main.osgi.getService(ILoader) as CheckLoader).setProgress(0);
         (Main.osgi.getService(ILoader) as CheckLoader).setProgress(300);
      }
      
      public function setInviteSendResult(sentSuccessfuly:Boolean, errorMessage:String) : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         if(sentSuccessfuly)
         {
            this._showMessage(localeService.getText(TextConst.INVITATION_HAS_BEEN_SENT_ALERT_TEXT));
         }
         else
         {
            this._showMessage(errorMessage);
         }
      }
      
      public function partSelected(partIndex:int) : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","partSelected: " + partIndex);
         if(this.mainPanel != null)
         {
            switch(partIndex)
            {
               case 0:
                  this.mainPanel.buttonBar.battlesButton.enable = false;
                  this.mainPanel.buttonBar.garageButton.enable = true;
                  this.mainPanel.buttonBar.frButton.enable = true;
                  this.mainPanel.buttonBar.addButton.enable = true;
                  break;
               case 1:
                  this.mainPanel.buttonBar.battlesButton.enable = true;
                  this.mainPanel.buttonBar.garageButton.enable = false;
                  this.mainPanel.buttonBar.frButton.enable = true;
				  this.mainPanel.buttonBar.addButton.enable = true;
                  break;
               case 2:
                  this.mainPanel.buttonBar.battlesButton.enable = true;
                  this.mainPanel.buttonBar.garageButton.enable = true;
                  this.mainPanel.buttonBar.frButton.enable = false;
				  this.mainPanel.buttonBar.addButton.enable = true;
                  break;
               case 3:
                  this.mainPanel.buttonBar.battlesButton.enable = true;
                  this.mainPanel.buttonBar.garageButton.enable = true;
                  this.mainPanel.buttonBar.frButton.enable = true;
				  this.mainPanel.buttonBar.addButton.enable = false;
                  break;
               case 4:
                  this.mainPanel.buttonBar.battlesButton.enable = true;
                  this.mainPanel.buttonBar.garageButton.enable = true;
                  this.mainPanel.buttonBar.frButton.enable = true;
				  this.mainPanel.buttonBar.addButton.enable = true;
                  if(this.loaderWindow != null)
                  {
                     this.loaderWindow.unlockLoaderWindow();
                     this.loaderWindow.hideLoaderWindow();
                     this.loaderWindow.lockLoaderWindow();
                  }
            }
         }
         this.unlock();
      }
      
      public function setInitData(countries:Array, rates:Array, accountId:String, projectId:int, formId:String) : void
      {
         var alertService:IAlertService = null;
         this.unlock();
         if(!(accountId != null && accountId != "" && accountId != "null"))
         {
            alertService = Main.osgi.getService(IAlertService) as IAlertService;
            alertService.showAlert(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.PAYMENT_NOT_AVAILABLE_ALERT_TEXT));
         }
      }
      
      public function setOperators(countryId:String, operators:Array) : void
      {
      }
      
      public function setNumbers(operatorId:int, smsNumbers:Array) : void
      {
         
      }
      
      public function updateReferalsData(data:Array) : void
      {
         
      }
      
      public function lock() : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","lock");
         this.mainPanel.mouseEnabled = false;
         this.mainPanel.mouseChildren = false;
      }
      
      public function unlock() : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","unlock");
         this.mainPanel.mouseEnabled = true;
         this.mainPanel.mouseChildren = true;
      }
      
      public function addListener(listener:IMoneyListener) : void
      {
         this.moneyListeners.push(listener);
      }
      
      public function removeListener(listener:IMoneyListener) : void
      {
         var index:int = this.moneyListeners.indexOf(listener);
         if(index != -1)
         {
            this.moneyListeners.splice(index,1);
         }
      }
      
      public function get userName() : String
      {
         return this._userName;
      }
      
      public function get userEmail() : String
      {
         return this.email == "" || this.email == null || this.email == "null"?"":this.email;
      }
      
      public function get rank() : int
      {
         return this.userRank;
      }
      
      public function get crystal() : int
      {
         return this._crystal;
      }
      
      public function get showSkyBox() : Boolean
      {
         return this.getBoolean(PARAM_SHOW_SKY_BOX,true);
      }
      
      public function get showFPS() : Boolean
      {
         return this.getBoolean(PARAM_SHOW_FPS,true);
      }
      
      public function get showBattleChat() : Boolean
      {
         return this.getBoolean(PARAM_SHOW_BATTLE_CHAT,true);
      }
      
      public function get adaptiveFPS() : Boolean
      {
         return this.getBoolean(PARAM_ADAPTIVE_FPS,false);
      }
      
      public function get useDust() : Boolean
      {
         return this.getBoolean(PARAM_DUST,false);
      }
      
      public function get enableMipMapping() : Boolean
      {
         return this.getBoolean(PARAM_MIPMAPPING,true);
      }
      
      public function get inverseBackDriving() : Boolean
      {
         return this.getBoolean(PARAM_INVERSE_BACK_DRIVING,false);
      }
      
      public function get bgSound() : Boolean
      {
         return this.getBoolean(PARAM_BGSOUND,true);
      }
      
      public function get muteSound() : Boolean
      {
         return this.getBoolean(PARAM_MUTE_SOUND,false);
      }
      
      public function get fog() : Boolean
      {
         return this.getBoolean(PARAM_FOG,false);
      }
      
      public function get dust() : Boolean
      {
         return this.getBoolean(PARAM_DUST,false);
      }
      
      public function get shadows() : Boolean
      {
         return this.getBoolean(SHADOWS,false);
      }
	  
	  public function get shadowsB() : Boolean
      {
         return this.getBoolean(SHADOWSB,false);
      }
	  
	  public function get shadowsM() : Boolean
      {
         return this.getBoolean(SHADOWSM,false);
      }
	  
	  public function get SSAO() : Boolean
      {
         return this.getBoolean(S,false);
      }
      
      public function get defferedLighting() : Boolean
      {
         return this.getBoolean(DEFFERED_LIGHTING,false);
      }
      
      public function get useAnimTracks() : Boolean
      {
         return this.getBoolean(ANIMATE_TRACKS,true);
      }
      
      private function showPanel() : void
      {
         if(!this.layer.contains(this.mainPanel))
         {
            this.layer.addChild(this.mainPanel);
         }
		 this.mainPanel.show();
         this.mainPanel.buttonBar.addEventListener(MainButtonBarEvents.PANEL_BUTTON_PRESSED,this.onButtonBarButtonClick);
      }
      
      private function hidePanel() : void
      {
		 this.mainPanel.hide();
         if(this.layer.contains(this.mainPanel))
         {
            this.layer.removeChild(this.mainPanel);
         }
         this.mainPanel.buttonBar.removeEventListener(MainButtonBarEvents.PANEL_BUTTON_PRESSED,this.onButtonBarButtonClick);
      }
      
      private function onButtonBarButtonClick(e:MainButtonBarEvents) : void
      {
         this.lock();
         switch(e.typeButton)
         {
            case MainButtonBarEvents.BATTLE:
               this.showBattleSelect(this.clientObject);
               this.isBattleSelect = true;
               this.lock();
			   this.unlock();
               break;
            case MainButtonBarEvents.BUGS:
               this.showBugReportDialog();
               this.unlock();
               break;
            case MainButtonBarEvents.CLOSE:
               this.showQuitDialog();
               this.unlock();
               break;
            case MainButtonBarEvents.GARAGE:
               this.showGarage(this.clientObject);
               this.isGarageSelect = true;
			   this.unlock();
               //this.lock();
               break;
            case MainButtonBarEvents.HELP:
               this.showHelpers();
               this.unlock();
               break;
            case MainButtonBarEvents.SETTINGS:
               if(this.settingsWindow == null)
               {
                  this.openProfile(this.clientObject,true,true,false,Game.log,"Uniqie");
               }
               this.unlock();
               break;
            case MainButtonBarEvents.SOUND:
               this.togleSoundMute();
               this.unlock();
               break;
            case MainButtonBarEvents.STAT:
               this.unlock();
               break;
            case MainButtonBarEvents.ADDMONEY:
			   openPayment(this.clientObject);
               this.unlock();
               break;
            case MainButtonBarEvents.REFERAL:
               this.unlock();
               break;
            case MainButtonBarEvents.FRIEND:
			   showFriend();
               this.unlock();
			   break;
			case MainButtonBarEvents.QUESTS:
			   this.unlock();
			   showZadan();
			   break;
			case MainButtonBarEvents.FULLSCREEN:
			   this.unlock();
			   if (Game._stage.displayState == StageDisplayState.FULL_SCREEN || Game._stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
			   {
				   Game._stage.displayState = StageDisplayState.NORMAL;
			   }else{
				   Game._stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			   }
         }
      }
      
      public function showBattleSelect(c:ClientObject) : void
      {
         if(this.isInBattle)
         {
			 //throw new Error();
			 partSelected(4);
            showQuitBatDialog();
			return;
         }
		 if(this.isP)
         {
			 (Main.osgi.getService(ILoader) as CheckLoader).addProgress(99);
			this.networker.send("lobby;get_data_init_battle_select");
			this.isBattleSelect = true;
            this.closePaymentWindow();
            this.isP = false;
         }
         if(this.isGarageSelect)
         {
			 (Main.osgi.getService(ILoader) as CheckLoader).addProgress(99);
			this.networker.send("lobby;get_data_init_battle_select");
			this.isBattleSelect = true;
			Main.unblur();
			partSelected(4);
            GarageModel(Main.osgi.getService(IGarage)).objectUnloaded(null);
            GarageModel(Main.osgi.getService(IGarage)).kostil = false;
            Main.osgi.unregisterService(IGarage);
            this.isGarageSelect = false;
         }
		 if(this.isF)
         {
			(Main.osgi.getService(ILoader) as CheckLoader).addProgress(99);
			this.networker.send("lobby;get_data_init_battle_select");
			this.isBattleSelect = true;
			this.closeFriend();
			this.isF = false;
         }
      }
      
      public function showFriend() : void
      {
		 //this.blured = true;
		 if (friendsWindow == null)
		 {
			 this.isF = true;
			 Main.blur();
			 Main.blured = true;
			 friendsWindow = new FriendsWindow(this.networker);
			 this.dialogsLayer.addChild(friendsWindow);
			 //this.blur();
			 Main.stage.addEventListener(Event.RESIZE, alignFr);
			 alignFr(null);
		 }else{
			 //friendsWindow.visible = true;
			 //friendsWindow.show();
			 //this.blur();
			 this.isF = true;
			 this.dialogsLayer.removeChild(friendsWindow);
			 Main.stage.removeEventListener(Event.RESIZE, alignFr);
			 Main.blur();
			 Main.blured = true;
			 friendsWindow = new FriendsWindow(this.networker);
			 this.dialogsLayer.addChild(friendsWindow);
			 //this.blur();
			 Main.stage.addEventListener(Event.RESIZE, alignFr);
			 alignFr(null);
		 }
      }
	  
	  public function showCo(p:int) : void
      {
		 if (gy == null)
		 {
			 gy = new Cong(p);
			 Main.systemUILayer.addChild(gy);
			 alignCo();
			 Main.stage.addEventListener(Event.RESIZE, alignCo);
		 }else{
			 gy.sh();
		 }
      }
	  
	  public function closeFriend() : void
      {
		 if (friendsWindow == null)
		 {
			 this.isF = false;
		 }else{
			 friendsWindow.visible = false;
			 //this.dialogsLayer.removeChild(friendsWindow);
			 this.isF = false;
		 }
		 Main.unblur();
      }
      
      private function togleSoundMute() : void
      {
         var listener:IPanelListener = null;
         this.storeBoolean(PARAM_MUTE_SOUND,!this.getSoundMute());
         this.flushStorage();
         this.setSoundSettings();
         this.unlock();
         for each(listener in this.panelListeners)
         {
            listener.setMuteSound(this.getSoundMute());
         }
      }
	  
	  private function alignFr(p:Event = null) : void
      {
		 this.friendsWindow.x = Math.round((Main.stage.stageWidth - this.friendsWindow.width) * 0.5);
         this.friendsWindow.y = Math.round((Main.stage.stageHeight - this.friendsWindow.height) * 0.5);
      }
	  
	  private function alignCo(p:Event = null) : void
      {
		 this.gy.x = Math.round((Main.systemUILayer.stage.stageWidth - gy.width) * 0.5);
         this.gy.y = Math.round((Main.systemUILayer.stage.stageHeight - gy.height) * 0.5);
      }
      
      private function showHelpers() : void
      {
         this.alignHelpers();
         Main.stage.addEventListener(Event.RESIZE,this.alignHelpers);
         var helpService:IHelpService = Main.osgi.getService(IHelpService) as IHelpService;
         helpService.showHelp();
         this.unlock();
         Main.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.hideHelp);
      }
      
      private function showQuitDialog() : void
      {
		 if(this.isInBattle)
         {
			 if (this.isGarageSelect)
			 {
				 GarageModel(Main.osgi.getService(IGarage)).objectUnloaded(null);
				 GarageModel(Main.osgi.getService(IGarage)).kostil = false;
				 Main.osgi.unregisterService(IGarage);
				 Main.unblur();
				 PanelModel(Main.osgi.getService(IPanel)).partSelected(4);
				 Network(Main.osgi.getService(INetworker)).send("battle;suicide1");
				 //Network(Main.osgi.getService(INetworker)).send("battle;suicide");
				 this.mainPanel.buttonBar.closeButton.visible = true;
				 this.mainPanel.buttonBar.closeButton1.visible = false;
				 this.isGarageSelect = false;
				 (BattleController(Main.osgi.getService(IBattleController))).addKeyboardListeners();
				 return;
			 }
			 alert = new Alert(Alert.ALERT_OPBAT);
			 this.dialogsLayer.addChild(alert);
			 alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED, this.onAlertButtonPressedBat);
         }else{
			 alert = new Alert(Alert.ALERT_QUIT);
			 this.dialogsLayer.addChild(alert);
			 alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED, this.onAlertButtonPressed);
		 }
      }
	  
	  private function showQuitBatDialog() : void
      {
			alert = new Alert(Alert.ALERT_OPBAT);
			this.dialogsLayer.addChild(alert);
			alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED, this.onAlertButtonPressedBat);
      }
      
      private function showBugReportDialog() : void
      {
         var listeners:Vector.<IModel> = null;
         var listener:IPanelListener = null;
         var localeService:ILocaleService = null;
         var alert:Alert = null;
         var alertButtons:Array = null;
         if(this.isTester)
         {
            if(this.reportWindow == null)
            {
               this.screenShot = new BitmapData(Main.stage.stageWidth,Main.stage.stageHeight,true,0);
               this.screenShot.draw(Game._stage);
               this.reportWindow = new BugReportWindow(this.screenShot);
               Main.blur();
               this.dialogsLayer.addChild(this.reportWindow);
               this.alignReportWindow();
               this.reportWindow.addEventListener(Event.COMPLETE,this.onBugReportComplete);
               this.reportWindow.addEventListener(Event.CANCEL,this.onBugReportCancel);
               Main.stage.addEventListener(Event.RESIZE,this.alignReportWindow);
               listeners = this.modelRegister.getModelsByInterface(IPanelListener) as Vector.<IModel>;
               if(listeners != null)
               {
                  for each(listener in listeners)
                  {
                     listener.bugReportOpened();
                  }
               }
            }
         }
         else
         {
            localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
			alert = new Alert( -1, true);
			alertButtons = [localeService.getText(TextConst.BUG_REPORT_NOT_TESTER_ALERT_TO_FORUM_TEXT)];
			alertButtons.unshift(localeService.getText(TextConst.BUG_REPORT_NOT_TESTER_ALERT_BUTTON_TO_PAYMENT_TEXT));
			alert.showAlert(localeService.getText(TextConst.BUG_REPORT_NOT_TESTER_ALERT_TEXT),alertButtons);
			this.dialogsLayer.addChild(alert);
         }
      }
      
      private function hideHelp(e:MouseEvent) : void
      {
         Main.stage.removeEventListener(Event.RESIZE,this.alignHelpers);
         Main.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.hideHelp);
      }
      
      private function alignReferalWindow(e:Event = null) : void
      {
         
      }
      
      private function closeRefererPanel(e:MouseEvent = null) : void
      {
         Main.unblur();
      }
      
      private function openPaymentWindow() : void
      {
		  if(this.isGarageSelect)
         {
            GarageModel(Main.osgi.getService(IGarage)).objectUnloaded(null);
            GarageModel(Main.osgi.getService(IGarage)).kostil = false;
            Main.osgi.unregisterService(IGarage);
            this.isGarageSelect = false;
         }
		 else if(this.isBattleSelect)
         {
            BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase)).objectUnloaded(null);
            Main.osgi.unregisterService(IBattleSelectModelBase);
            this.isBattleSelect = false;
         }
         else if(this.isInBattle)
         {
            this.onExitFromBattle();
            this.isInBattle = false;
         }
      }
      
      private function alignPaymentWindow(e:Event = null) : void
      {
         Main.writeVarsToConsoleChannel("PAYMENT","PanelModel alignPaymentWindow");
         //var minWidth:int = int(Math.max(1000,Main.stage.stageWidth));
		 fffr.x = Math.round((Main.stage.stageWidth - fffr.window.width) * 0.5);
         fffr.y = Math.round((Main.stage.stageHeight - fffr.window.height) * 0.5);
		 fffr.render();
      }
      
      private function closePaymentWindow() : void
      {
         
      }
      
      private function onConfirmEmail(e:Event = null) : void
      {
         this.settingsWindow.removeEventListener(Event.ACTIVATE,this.onConfirmEmail);
      }
      
      private function onChangeVolume(e:Event = null) : void
      {
         if(!this.getSoundMute())
         {
            SoundMixer.soundTransform = new SoundTransform(this.settingsWindow.volume);
         }
      }
      
      private function hideSettingsDialog() : void
      {
         Main.stage.removeEventListener(Event.RESIZE, this.alignSettingsWindow);
		 if (this.settingsWindow != null)
		 {
			 this.settingsWindow.removeEventListener(SettingsWindowEvent.CANCEL_SETTINGS,this.onSettingsCancel);
			 this.settingsWindow.removeEventListener(SettingsWindowEvent.ACCEPT_SETTINGS,this.onSettingsComplete);
			 this.settingsWindow.removeEventListener(SettingsWindowEvent.RESEND_CONFIRMATION,this.onConfirmEmail);
			 this.settingsWindow.removeEventListener(SettingsWindowEvent.CHANGE_VOLUME,this.onChangeVolume);
			this.dialogsLayer.removeChild(this.settingsWindow);
		 }
         Main.unblur();
         this.settingsWindow = null;
         this.mainPanel.buttonBar.settingsButton.enable = true;
      }
      
      private function onSettingsCancel(e:Event = null) : void
      {
         var listener:IPanelListener = null;
         this.setSoundSettings();
         this.hideSettingsDialog();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.settingsCanceled();
            }
         }
      }
      
      private function onSettingsComplete(e:Event = null) : void
      {
         var modelRegister:IModelService = null;
         var aaModel:IAntiAddictionAlert = null;
         var listener:IPanelListener = null;
         if(!this.settingsWindow.isPasswordChangeDisabled)
         {
            if(this.settingsWindow.password != "")
            {
               Main.writeVarsToConsoleChannel("PANEL MODEL","onSettingsComplete password: %1",this.settingsWindow.password);
            }
         }
         if(this.settingsWindow.realName != "" && this.settingsWindow.idNumber != "")
         {
            modelRegister = Main.osgi.getService(IModelService) as IModelService;
            aaModel = modelRegister.getModelsByInterface(IAntiAddictionAlert)[0] as IAntiAddictionAlert;
            Main.writeVarsToConsoleChannel("PANEL MODEL","onSettingsComplete AA: %1 %2",this.settingsWindow.realName,this.settingsWindow.idNumber);
            Main.writeVarsToConsoleChannel("PANEL MODEL","onSettingsComplete AAModel: %1",aaModel);
            aaModel.setIdNumberAndRealName(this.settingsWindow.realName,this.settingsWindow.idNumber);
         }
         if(this.settingsWindow.useDust && !this.settingsWindow.useSoftParticle)
         {
            this.settingsWindow.visibleDustButton = false;
         }
         else
         {
            this.settingsWindow.visibleDustButton = true;
         }
         this.storeBoolean(PARAM_SHOW_SKY_BOX,this.settingsWindow.showSkyBox);
         this.storeBoolean(PARAM_SHOW_FPS,this.settingsWindow.showFPS);
         this.storeBoolean(PARAM_SHOW_BATTLE_CHAT,this.settingsWindow.showBattleChat);
         this.storeBoolean(PARAM_ADAPTIVE_FPS,this.settingsWindow.adaptiveFPS);
         this.storeBoolean(PARAM_MIPMAPPING,this.settingsWindow.enableMipMapping);
         this.storeBoolean(PARAM_INVERSE_BACK_DRIVING,this.settingsWindow.inverseBackDriving);
         this.storeBoolean(PARAM_BGSOUND,this.settingsWindow.bgSound);
         this.storeNumber(PARAM_SOUND_VOLUME,this.settingsWindow.volume);
         this.storeBoolean(PARAM_FOG,this.settingsWindow.useFog);
         this.storeBoolean(PARAM_DUST, this.settingsWindow.useDust);
		 this.storeBoolean(S,this.settingsWindow.showS);
         this.storeBoolean(SHADOWS, this.settingsWindow.useShadows);
		 this.storeBoolean(SHADOWSB, this.settingsWindow.useShadowsB);
		 this.storeBoolean(SHADOWSM, this.settingsWindow.useShadowsM);
         this.storeBoolean(DEFFERED_LIGHTING,this.settingsWindow.useDefferedLighting);
         this.storeBoolean(ANIMATE_TRACKS,true);
         this.flushStorage();
         this.setSoundSettings();
         this.hideSettingsDialog();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.settingsAccepted();
            }
         }
      }
      
      private function alignSettingsWindow(e:Event = null) : void
      {
         this.settingsWindow.x = Math.round((Main.stage.stageWidth - this.settingsWindow.width) * 0.5);
         this.settingsWindow.y = Math.round((Main.stage.stageHeight - this.settingsWindow.height) * 0.5);
      }
      
      private function alignReportWindow(e:Event = null) : void
      {
         this.reportWindow.x = Math.round((Main.stage.stageWidth - this.reportWindow.width) * 0.5);
         this.reportWindow.y = Math.round((Main.stage.stageHeight - this.reportWindow.height) * 0.5);
      }
      
      private function onBugReportCancel(e:Event = null) : void
      {
         var i:int = 0;
         this.reportWindow.removeEventListener(Event.CANCEL,this.onBugReportCancel);
         this.reportWindow.removeEventListener(Event.COMPLETE,this.onBugReportComplete);
         Main.stage.removeEventListener(Event.RESIZE,this.alignReportWindow);
         this.dialogsLayer.removeChild(this.reportWindow);
         this.reportWindow = null;
         Main.unblur();
         this.screenShot.dispose();
         this.mainPanel.buttonBar.bugsButton.enable = true;
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener) as Vector.<IModel>;
         if(listeners != null)
         {
            for(i = 0; i < listeners.length; i++)
            {
               (listeners[i] as IPanelListener).bugReportClosed();
            }
         }
      }
      
      private function onBugReportComplete(e:Event = null) : void
      {
         var bd1:BitmapData = new BitmapData(Main.stage.stageWidth,Main.stage.stageHeight,false,2829082);
         bd1.draw(Main.stage);
		 encodeJPG(bd1);
      }
      
      private function sendInvitation(e:ReferalWindowEvent) : void
      {
         var result:Object = null;
         var referalsModel:ReferalsModelBase = null;
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var a:Array = e.adresses.split(",");
         var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
         var notValid:Array = new Array();
         for(var i:int = 0; i < a.length; i++)
         {
            result = pattern.exec(a[i]);
            if(result == null)
            {
               notValid.push(a[i]);
            }
         }
         if(notValid.length > 0)
         {
            if(notValid.length == 1)
            {
               this._showMessage(localeService.getText(TextConst.REFERAL_WINDOW_ADDRESS_NOT_VALID_ALERT_TEXT,notValid[0]));
            }
            else
            {
               this._showMessage(localeService.getText(TextConst.REFERAL_WINDOW_ADDRESSES_NOT_VALID_ALERT_TEXT,notValid.join(", ")));
            }
         }
         else
         {
            this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
            referalsModel = (this.modelRegister.getModelsByInterface(IReferalsModelBase) as Vector.<IModel>)[0] as ReferalsModelBase;
         }
      }
      
      private function sendReport(jpgArray:String) : void
      {
         var packet:Array = null;
         var dumper:IDumper = null;
         var dump:String = "";
         var params:Vector.<String> = new Vector.<String>();
         var dumpers:Vector.<IDumper> = (Main.osgi.getService(IDumpService) as IDumpService).dumpersList as Vector.<IDumper>;
         for(var i:int = 0; i < dumpers.length; i++)
         {
            dumper = dumpers[i];
            dump = dump + ("\n\n             " + dumper.dumperName + "\n");
            dump = dump + dumper.dump(params);
            dump = dump + "\n\n";
         }
         i = 0;
         var n:int = 10000;
         var start:Boolean = true;
         Main.writeVarsToConsoleChannel("PANEL MODEL", "send jpgArray (%1 bytes)", jpgArray.length);
		 var bd1:BitmapData = new BitmapData(Main.stage.stageWidth,Main.stage.stageHeight,false,2829082);
         bd1.draw(Main.stage);
         this.storeBugScreenshot(this.clientObject,jpgArray,start);
         this.bugReport(this.clientObject,dump,this.reportWindow.summary,this.reportWindow.description);
         this.onBugReportCancel();
         this._showMessage(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.BUG_REPORT_HAS_BEEN_SENT_ALERT_TEXT));
      }
      
      private function storeBugScreenshot(obj:ClientObject, packet:String, start:Boolean) : void
      {
		 //throw new Error(packet);
         Network(Main.osgi.getService(INetworker)).send("lobby;screenshot;" + packet);
      }
      
      private function bugReport(obj:ClientObject, dump:String, summary:String, description:*) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;bug_report;" + summary + ";" + description);
      }
      
      public function sendBugReport(summary:String, description:String) : void
      {
         var dumper:IDumper = null;
         var dump:String = "";
         var params:Vector.<String> = new Vector.<String>();
         var dumpers:Vector.<IDumper> = (Main.osgi.getService(IDumpService) as IDumpService).dumpersList as Vector.<IDumper>;
         for(var i:int = 0; i < dumpers.length; i++)
         {
            dumper = dumpers[i];
            dump = dump + ("\n\n             " + dumper.dumperName + "\n");
            dump = dump + dumper.dump(params);
            dump = dump + "\n\n";
         }
         this.bugReport(this.clientObject,dump,summary,description);
      }
      
      private function encodeJPG(g:BitmapData) : void
      {
         var jpgimage:JPGEncoder = new JPGEncoder();
		 var ba:ByteArray = jpgimage.encode(g);
		 sendReport(String(ba));
      }
	  
	  public function destroy() : void
      {
		  var battle:BattleSelectModel = null;
			this.lock();
			this.closePayment(null);
			this.closePaymentWindow();
			this.hideHelp(null);
			this.hidePanel();
			this.hideSettingsDialog();
			 if(this.isP)
			 {
				this.closePaymentWindow();
				this.isP = false;
			 }
			 if(this.isGarageSelect)
			 {
				Main.unblur();
				GarageModel(Main.osgi.getService(IGarage)).objectUnloaded(null);
				GarageModel(Main.osgi.getService(IGarage)).kostil = false;
				Main.osgi.unregisterService(IGarage);
				this.isGarageSelect = false;
			 }
			 if(this.isF)
			 {
				this.closeFriend();
				this.isF = false;
			 }
			 if(this.isBattleSelect)
			 {
				battle = BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase));
				battle.objectUnloaded(null);
				this.isBattleSelect = false;
				Main.osgi.unregisterService(IBattleSelectModelBase);
			 }
			 if(!this.isInBattle)
			 {
				Network(Main.osgi.getService(INetworker)).destroy();
				 //var serverConnectionServie:ServerConnectionService = new ServerConnectionServiceImpl();
				 //serverConnectionServie.connect("socket.cfg?rand=" + Math.random());
			 }
      }
      
      private function bugReportAlertButtonPressed(e:AlertEvent) : void
      {
         this.unlock();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         if(e.typeButton == localeService.getText(TextConst.BUG_REPORT_NOT_TESTER_ALERT_BUTTON_TO_PAYMENT_TEXT))
         {
            this.goToPayment();
         }
         else
         {
            //navigateToURL(new URLRequest("http://forum.gtanksonline.com"),"_self");
         }
      }
      
      private function onAlertButtonPressed(e:AlertEvent) : void
      {
         var localeService:ILocaleService = null;
         this.unlock();
         if(e.typeButton == AlertAnswer.YES)
         {
            this.storage.data.userHash = null;
			this.storage.data.ky = null;
            this.storage.flush();
            localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
			Game.getInstance.destroy(true);
			//navigateToURL(new URLRequest('Javascript: window.close();'), '_self'); 
            //navigateToURL(new URLRequest("http://" + localeService.getText(TextConst.GAME_BASE_URL) + "/"),"_self");
         }
      }
	  
	  private function onAlertButtonPressedBat(e:AlertEvent) : void
      {
         var localeService:ILocaleService = null;
         this.unlock();
         if(e.typeButton == AlertAnswer.YES)
         {
			(Main.osgi.getService(ILoader) as CheckLoader).addProgress(99);
			if(this.isGarageSelect)
			 {
				 GarageModel(Main.osgi.getService(IGarage)).objectUnloaded(null);
				 GarageModel(Main.osgi.getService(IGarage)).kostil = false;
				 Main.osgi.unregisterService(IGarage);
				 Main.unblur();
				 Network(Main.osgi.getService(INetworker)).send("battle;suicide1");
				 this.mainPanel.buttonBar.closeButton.visible = true;
				 this.mainPanel.buttonBar.closeButton1.visible = false;
				 this.isGarageSelect = false;
			 }
			this.networker.send("lobby;get_data_init_battle_select");
			this.isBattleSelect = true;
            this.onExitFromBattle();
            this.isInBattle = false;
         }
		 if(e.typeButton == AlertAnswer.NO)
         {
			partSelected(4);
         }
      }
      
      private function alignHelpers(e:Event = null) : void
      {
         var stageWidth:int = Main.stage.stageWidth;
         var rankBarWidth:int = stageWidth - 465 - 13 * 2 - 110 - 60;
         this.rankBarHelper.targetPoint = new Point(60 + Math.round(rankBarWidth * 0.5),this.rankBarHelper.targetPoint.y);
         this.ratingHelper.targetPoint = new Point(rankBarWidth + 60,this.ratingHelper.targetPoint.y);
         this.mainMenuHelper.targetPoint = new Point(60 + rankBarWidth + 170,this.mainMenuHelper.targetPoint.y);
         this.buttonBarHelper.targetPoint = new Point(stageWidth - 140,this.buttonBarHelper.targetPoint.y);
         this.moneyHelper.targetPoint = new Point(185 + rankBarWidth + 5,this.moneyHelper.targetPoint.y);
      }
      
      public function showCloselessMessage(clientObject:ClientObject, message:String) : void
      {
			alert = new Alert();
			alert.showAlert(message,[]);
			this.dialogsLayer.addChild(alert);
      }
      
      public function setIdNumberCheckResult(result:Boolean) : void
      {
         if(!result)
         {
            this._showMessage("该身份证错误,请重新输入");
         }
         else
         {
            this._showMessage("您的身份证信息已通过验证");
         }
      }
      
      private function getBoolean(name:String, defaultValue:Boolean) : Boolean
      {
         if(this.storage == null)
         {
            this.storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         }
         var value:* = this.storage.data[name];
         return value == null?Boolean(defaultValue):Boolean(value);
      }
      
      private function storeBoolean(name:String, value:Boolean) : void
      {
         this.storage.data[name] = value;
      }
      
      private function getNumber(name:String, defauleValue:Number = 0) : Number
      {
         var value:Number = Number(this.storage.data[name]);
         return isNaN(value)?Number(defauleValue):Number(value);
      }
      
      private function storeNumber(name:String, value:Number) : void
      {
         this.storage.data[name] = value;
      }
      
      private function flushStorage() : void
      {
         this.storage.flush();
      }
	  
	  public function get Sssa() : Boolean
      {
         return this.settingsWindow.showS;
      }
      
      public function get showShadowsTank() : Boolean
      {
         return IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["show_shadows_tank"];
      }
      
      public function get useSoftParticle() : Boolean
      {
         return IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["soft_particle"];
      }
   }
}