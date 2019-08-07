package alternativa.tanks.model
{
   import alternativa.init.BattleSelectModelActivator;
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.IResourceLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.osgi.service.loaderParams.ILoaderParamsService;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.resource.IResource;
   import alternativa.service.IAddressService;
   import alternativa.service.IModelService;
   import alternativa.service.IResourceService;
   import alternativa.tanks.help.CreateMapHelper;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.help.LockedMapsHelper;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.types.Long;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import forms.Alert;
   import forms.AlertAnswer;
   import forms.battlelist.BattleMap;
   import forms.battlelist.CreateBattleForm;
   import forms.battlelist.ViewBattleList;
   import forms.battlelist.ViewDM;
   import forms.battlelist.ViewTDM;
   import forms.events.AlertEvent;
   import forms.events.BattleListEvent;
   import utils.client.battlefield.gui.models.chat.IChatModelBase;
   import utils.client.battleselect.BattleSelectModelBase;
   import utils.client.battleselect.IBattleSelectModelBase;
   import utils.client.battleselect.types.BattleClient;
   import utils.client.battleselect.types.MapClient;
   import utils.client.battleselect.types.UserInfoClient;
   import utils.client.battleservice.model.BattleType;
   import utils.client.battleservice.model.team.BattleTeamType;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   import utils.SWFAddressEvent;
   
   public class BattleSelectModel extends BattleSelectModelBase implements IBattleSelectModelBase, IObjectLoadListener, IResourceLoadListener, IDumper
   {
       
      
      private var modelRegister:IModelService;
      
      private var panelModel:IPanel;
      
      private var helpService:IHelpService;
      
      private var addressService:IAddressService;
      
      private var loaderParamsService:ILoaderParamsService;
      
      private var localeService:ILocaleService;
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var battleList:ViewBattleList = new ViewBattleList();
      
      private var createBattleForm:CreateBattleForm;
      
      private var viewDM:ViewDM;
      
      private var viewTDM:ViewTDM;
      
      private var battlesArray:Array;
      
      private var mapsArray:Array;
      
      private var battles:Dictionary;
      
      private var maps:Dictionary;
      
      private var usersInfo:Dictionary;
      
      private const maxBattlesNum:int = 2147483647;
      
      private const HELPER_NOT_AVAILABLE:int = 1;
      
      private const HELPER_CREATE_MAP:int = 5;
      
      private var lockedMapsHelper:LockedMapsHelper;
      
      private var createHelper:CreateMapHelper;
      
      private const HELPER_GROUP_KEY:String = "BattleSelectModel";
      
      private var hideHelperInt:uint;
      
      private var hideHelperDelay:int = 5000;
      
      private var clearURL:Boolean;
      
      private var recommendedBattle:String;
      
      private var paidBattleAlert:Alert;
      
      private var createBattleExpectedResourceId:Long;
      
      private var viewBattleExpectedResourceId:Long;
      
      public var selectedBattleId:String;
      
      public var test:BitmapData;
      
      private var gameNameBeforeCheck:String;
	  
	  private var need1:Boolean = false;
      
      public function BattleSelectModel()
      {
         this.test = new BitmapData(1,10);
         super();
         _interfaces.push(IModel);
         _interfaces.push(IBattleSelectModelBase);
         _interfaces.push(IObjectLoadListener);
         _interfaces.push(IResourceLoadListener);
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.panelModel = Main.osgi.getService(IPanel) as IPanel;
         this.helpService = Main.osgi.getService(IHelpService) as IHelpService;
         this.addressService = Main.osgi.getService(IAddressService) as IAddressService;
         this.loaderParamsService = Main.osgi.getService(ILoaderParamsService) as ILoaderParamsService;
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.layer = Main.contentUILayer;
         this.dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
      }
      
      public function initObject(clientObject:ClientObject, cost:int, haveSubscribe:Boolean, maps:Array) : void
      {
         var mapId:String = null;
         var m:MapClient = null;
         var previewBitmap:BitmapData = null;
         var mapParams:BattleMap = null;
         Main.writeVarsToConsoleChannel("BATTLE SELECT","initObject");
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   maps: %1",maps);
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   haveSubscribe: %1",haveSubscribe);
         this.clientObject = clientObject;
		 if(PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			 //var battle1:BattleSelectModel = BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase));
			 //battle1.objectUnloaded(null);
			 //PanelModel(Main.osgi.getService(IPanel)).isBattleSelect = false;
			 //Main.osgi.unregisterService(IBattleSelectModelBase);
			 return;
		 }
         this.battles = new Dictionary();
         this.battlesArray = new Array();
         this.maps = new Dictionary();
         this.createBattleForm = new CreateBattleForm(haveSubscribe);
         this.createBattleForm.mapsCombo.addEventListener(Event.CHANGE,this.onMapSelect);
         this.createBattleForm.themeCombo.addEventListener(Event.CHANGE,this.onMapSelect);
         this.createBattleForm.addEventListener(BattleListEvent.NEW_BATTLE_NAME_ADDED,this.checkBattleName);
         this.viewDM = new ViewDM(haveSubscribe);
         this.viewTDM = new ViewTDM(haveSubscribe);
         this.mapsArray = maps;
         for(var i:int = 0; i < maps.length; i++)
         {
            mapId = MapClient(maps[i]).id;
            this.maps[mapId] = maps[i];
         }
         var mapsParams:Array = new Array();
		 var mapsParams1:Array = new Array();
         for(i = 0; i < this.mapsArray.length; i++)
         {
            m = MapClient(this.mapsArray[i]);
			try
			{
				previewBitmap = ResourceUtil.getResource(ResourceType.IMAGE, m.previewId).bitmapData as BitmapData;
			}
            catch(e:Error)
            {
               previewBitmap = new BitmapData(500,500);
            }
            mapParams = new BattleMap();
            mapParams.id = m.id;
            mapParams.gameName = m.name;
            mapParams.maxPeople = m.maxPeople;
            mapParams.maxRank = m.maxRank;
            mapParams.minRank = m.minRank;
            mapParams.themeName = m.themeName;
            mapParams.preview = previewBitmap;
            mapParams.ctf = m.ctf;
            mapParams.tdm = m.tdm;
            mapsParams.push(mapParams);
			mapsParams1.push(mapParams);
         }
         this.createBattleForm.maps = mapsParams1;
         if(this.addressService != null)
         {
            this.addressService.addEventListener(SWFAddressEvent.CHANGE,this.onAddressChange);
         }
         this.clearURL = true;
         this.createHelper = new CreateMapHelper();
         this.lockedMapsHelper = new LockedMapsHelper();
         this.helpService.registerHelper(this.HELPER_GROUP_KEY,this.HELPER_CREATE_MAP,this.createHelper,true);
         this.helpService.registerHelper(this.HELPER_GROUP_KEY,this.HELPER_NOT_AVAILABLE,this.lockedMapsHelper,false);
         var minWidth:int = int(Math.max(100,Main.stage.stageWidth));
         var minHeight:int = int(Math.max(60,Main.stage.stageHeight));
         this.createHelper.targetPoint = new Point(Math.round(minWidth * (2 / 3)) - 47,minHeight - 34);
         Main.stage.addEventListener(Event.RESIZE,this.alignHelpers);
         this.alignHelpers();
         (BattleSelectModelActivator.osgi.getService(IDumpService) as IDumpService).registerDumper(this);
      }
	  
	  public function ff() : void
      {
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         (BattleSelectModelActivator.osgi.getService(IDumpService) as IDumpService).unregisterDumper(this.dumperName);
         if(this.addressService != null)
         {
            this.addressService.removeEventListener(SWFAddressEvent.CHANGE,this.onAddressChange);
            if(this.clearURL)
            {
               this.addressService.setValue("");
            }
         }
         this.hideList();
         this.hideInfo();
         this.hideCreateForm();
         Main.stage.removeEventListener(Event.RESIZE,this.alignHelpers);
         this.helpService.hideHelper(this.HELPER_GROUP_KEY,this.HELPER_NOT_AVAILABLE);
         this.helpService.unregisterHelper(this.HELPER_GROUP_KEY,this.HELPER_NOT_AVAILABLE);
         this.helpService.unregisterHelper(this.HELPER_GROUP_KEY,this.HELPER_CREATE_MAP);
         this.lockedMapsHelper = null;
         this.createHelper = null;
         this.battleList = null;
         this.createBattleForm = null;
         this.viewDM = null;
         this.viewTDM = null;
         this.battlesArray = null;
         this.mapsArray = null;
         this.battles = null;
         this.maps = null;
         this.usersInfo = null;
         this.paidBattleAlert = null;
         this.clientObject = null;
      }
      
      public function resourceLoaded(resource:IResource) : void
      {
         Main.writeVarsToConsoleChannel("BATTLE SELECT","resourceLoaded");
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   resourceId: " + resource.id);
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   viewExpectedResourceId: " + this.viewBattleExpectedResourceId);
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   createExpectedResourceId: " + this.createBattleExpectedResourceId);
         if(resource.id == this.viewBattleExpectedResourceId)
         {
            if(this.viewDM != null && this.layer.contains(this.viewDM))
            {
               this.viewDM.info.setPreview(this.test);
            }
            else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
            {
               this.viewTDM.info.setPreview(this.test);
            }
            this.viewBattleExpectedResourceId = null;
         }
         else if(resource.id == this.createBattleExpectedResourceId)
         {
            if(this.createBattleForm != null && this.layer.contains(this.createBattleForm))
            {
               this.createBattleForm.info.setPreview(this.test);
            }
            this.createBattleExpectedResourceId = null;
         }
      }
      
      public function resourceUnloaded(resourceId:Long) : void
      {
      }
      
      public function initBattleList(clientObject:ClientObject, battles:Array, recommendedBattle:String, onLink:Boolean) : void
      {
		 if (battleList == null)
		 {
			 hideList();
			 battleList = new ViewBattleList();
			 //showList();
		 }
         var i:int = 0;
         var selectedBattleId:String = null;
         var garageAvailableAlert:Alert = null;
         var dialogsLayer:DisplayObjectContainer = null;
         var timer:Timer = new Timer(2500,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
         {
            (Main.osgi.getService(ILoader) as CheckLoader).setFullAndClose(null);
            panelModel.partSelected(0);
            showList();
         });
         timer.start();
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         if(storage.data.garageAvailableAlertShown == null && (this.panelModel.rank == 2 || this.panelModel.rank == 3))
         {
            garageAvailableAlert = new Alert(Alert.GARAGE_AVAILABLE);
            garageAvailableAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onGarageAvailableAlertPressed);
            dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
            dialogsLayer.addChild(garageAvailableAlert);
            storage.data.garageAvailableAlertShown = true;
            storage.flush();
         }
		 if(battles != null)
         {
            for(i = 0; i < battles.length; i++)
            {
               this.addBattle(null,BattleClient(battles[i]));
            }
            selectedBattleId = this.checkSelectedBattle();
            if(selectedBattleId == null || onLink)
            {
               this.battleList.select(selectedBattleId);
            }
            else
            {
               this.battleList.select(selectedBattleId);
            }
         }
		 if(Lobby.firstInit)
         {
            Network(Main.osgi.getService(INetworker)).send("lobby;user_inited");
            Lobby.firstInit = false;
         }
      }
      
      private function onGarageAvailableAlertPressed(e:AlertEvent) : void
      {
         if(e.typeButton == AlertAnswer.GARAGE)
         {
            this.panelModel.goToGarage();
         }
      }
      
      public function addBattle(clientObject:ClientObject, battle:BattleClient) : void
      {
         this.battles[battle.battleId] = battle;
         this.battlesArray.push(battle);
		 //Network(Main.osgi.getService(INetworker)).send("lobby;get_show_battle_info;" + battle.battleId);
		 if (battleList == null)
		 {
			 hideList();
			 battleList = new ViewBattleList();
			 //showList();
		 }
         this.battleList.addItem(battle.battleId,battle.name,!battle.team,battle.countRedPeople,battle.countBluePeople,battle.countPeople,(this.maps[battle.mapId] as MapClient).name,battle.countPeople >= battle.maxPeople,battle.countRedPeople >= battle.maxPeople,battle.countBluePeople >= battle.maxPeople,battle.minRank <= this.panelModel.rank && battle.maxRank >= this.panelModel.rank,battle.paid,battle.type);
         if(this.battlesArray.length > this.maxBattlesNum)
         {
            this.battleList.createButton.enable = false;
         }
      }
      
      public function getBattleName(id:String) : String
      {
         return (this.battles[id] as BattleClient).name;
      }
      
      public function selectBattleFromChat(id:Long) : void
      {
      }
      
      public function removeBattle(clientObject:ClientObject, battleId:String) : void
      {
		 try {
			 var battle:BattleClient = this.battles[battleId];
			 this.battlesArray.splice(this.battlesArray.indexOf(battle),1);
			 if(this.battleList.selectedBattleID == battleId)
			 {
				this.hideInfo();
			 }
			 this.battleList.removeItem(battleId);
			 this.battles[battleId] = null;
			 if(this.battlesArray.length <= this.maxBattlesNum)
			 {
				this.battleList.createButton.enable = true;
			 }
		 } catch (e:Event)
		 {
			 
		 }
      }
      
      public function setHaveSubscribe(clientObject:ClientObject, haveSubscribe:Boolean) : void
      {
         this.viewDM.haveSubscribe = haveSubscribe;
         this.viewTDM.haveSubscribe = haveSubscribe;
         this.createBattleForm.haveSubscribe = haveSubscribe;
      }
      
      public function showBattleInfo(clientObject:ClientObject, name:String, maxPeople:int, battleType:BattleType, battleId:String, previewId:String, minRank:int, maxRank:int, timeLimit:int, timeCurrent:int, killsLimit:int, scoreRed:int, scoreBlue:int, autobalance:Boolean, friendlyFire:Boolean, users:Array, paidBattle:Boolean, withoutBonuses:Boolean, userAlreadyPaid:Boolean, fullCash:Boolean, spectator:Boolean = false) : void
      {
         var previewBitmap:BitmapData = null;
         var url:String = null;
         var team:Boolean = false;
		 try
         {
            this.createBattleForm.visible = false;
         }
         catch(e:Error)
         {
            
         }
         var i:int = 0;
         var userInfo:UserInfoClient = null;
         Main.writeVarsToConsoleChannel("BATTLE SELECT","showBattleInfo");
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   battleId: %1",battleId);
         Main.writeVarsToConsoleChannel("BATTLE SELECT","this.clientObject = %1",this.clientObject == clientObject);
         this.usersInfo = new Dictionary(false);
         var resourceRegister:IResourceService = BattleSelectModelActivator.osgi.getService(IResourceService) as IResourceService;
         try
         {
            previewBitmap = ResourceUtil.getResource(ResourceType.IMAGE,previewId).bitmapData;
         }
         catch(e:Error)
         {
            previewBitmap = new BitmapData(500,500);
         }
         if(this.battleList != null)
         {
            this.battleList.select(battleId);
            url = "";
            if(this.addressService != null)
            {
               if(this.loaderParamsService.params["partner"] != null && this.addressService.getValue().indexOf("registered") != -1)
               {
                  this.addressService.setValue("battle/" + battleId.toString() + "/partner=" + this.loaderParamsService.params["partner"]);
               }
               else
               {
                  this.addressService.setValue("battle/" + battleId.toString());
               }
            }
            url = "#battle" + battleId;
            team = battleType == BattleType.CTF || battleType == BattleType.TDM;
            this.showInfo(team);
            if(team)
            {
               this.viewTDM.Init(name,maxPeople,minRank,maxRank,scoreRed,scoreBlue,previewBitmap,timeLimit,timeCurrent,killsLimit,false,autobalance,friendlyFire,url,minRank <= this.panelModel.rank && maxRank >= this.panelModel.rank,battleType == BattleType.CTF,paidBattle,!withoutBonuses,userAlreadyPaid,fullCash);
               for(i = 0; i < users.length; i++)
               {
                  userInfo = users[i] as UserInfoClient;
                  this.usersInfo[userInfo.id] = userInfo;
                  this.viewTDM.updatePlayer(userInfo.type == BattleTeamType.RED?Boolean(ViewTDM.RED_TEAM):Boolean(ViewTDM.BLUE_TEAM),userInfo.id,userInfo.name,userInfo.rank,userInfo.kills);
               }
               if(paidBattle && !userAlreadyPaid)
               {
                  this.viewTDM.addEventListener(BattleListEvent.START_TDM_BLUE,this.onStartPaidBlueTeamBattle);
                  this.viewTDM.addEventListener(BattleListEvent.START_TDM_RED,this.onStartPaidRedTeamBattle);
                  this.viewTDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartTeamBattleForBlue);
                  this.viewTDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartTeamBattleForRed);
               }
               else
               {
                  this.viewTDM.addEventListener(BattleListEvent.START_TDM_BLUE,this.onStartTeamBattleForBlue);
                  this.viewTDM.addEventListener(BattleListEvent.START_TDM_RED,this.onStartTeamBattleForRed);
                  this.viewTDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartPaidBlueTeamBattle);
                  this.viewTDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartPaidRedTeamBattle);
               }
               if(spectator)
               {
                  this.viewTDM.info.showSpectatorButton();
               }
            }
            else
            {
               this.viewDM.Init(name,maxPeople,minRank,maxRank,previewBitmap,timeLimit,timeCurrent,killsLimit,false,url,minRank <= this.panelModel.rank && maxRank >= this.panelModel.rank,paidBattle,!withoutBonuses,userAlreadyPaid,fullCash);
               for(i = 0; i < users.length; i++)
               {
                  userInfo = users[i] as UserInfoClient;
                  this.usersInfo[userInfo.id] = userInfo;
                  this.viewDM.updatePlayer(userInfo.id,userInfo.name,userInfo.rank,userInfo.kills);
               }
               if(paidBattle && !userAlreadyPaid)
               {
                  this.viewDM.addEventListener(BattleListEvent.START_DM_GAME,this.onStartPaidDMBattle);
                  this.viewDM.removeEventListener(BattleListEvent.START_DM_GAME,this.onStartDMBattle);
               }
               else
               {
                  this.viewDM.removeEventListener(BattleListEvent.START_DM_GAME,this.onStartPaidDMBattle);
                  this.viewDM.addEventListener(BattleListEvent.START_DM_GAME,this.onStartDMBattle);
               }
               if(spectator)
               {
                  this.viewDM.info.showSpectatorButton();
               }
            }
         }
      }
      
      public function currentBattleAddUser(clientObject:ClientObject, userInfo:UserInfoClient) : void
      {
         if(this.usersInfo == null)
         {
            this.usersInfo = new Dictionary();
         }
         this.usersInfo[userInfo.id] = userInfo;
         if(this.viewDM != null && this.layer.contains(this.viewDM))
         {
            this.viewDM.updatePlayer(userInfo.id,userInfo.name,userInfo.rank,userInfo.kills);
         }
         else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
         {
            this.viewTDM.updatePlayer(userInfo.type == BattleTeamType.RED,userInfo.id,userInfo.name,userInfo.rank,userInfo.kills);
         }
      }
      
      public function currentBattleRemoveUser(clientObject:ClientObject, userId:String) : void
      {
         if(this.viewDM != null && this.layer.contains(this.viewDM))
         {
            this.viewDM.removePlayer(userId);
         }
         else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
         {
            this.viewTDM.removePlayer(userId);
         }
      }
      
      public function teamScoreUpdate(clientObject:ClientObject, redTeamScore:int, blueTeamScore:int) : void
      {
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            if(this.viewTDM != null)
            {
               this.viewTDM.updateScore(ViewTDM.RED_TEAM,redTeamScore);
               this.viewTDM.updateScore(ViewTDM.BLUE_TEAM,blueTeamScore);
            }
         }
      }
      
      public function updateUsersCountForTeam(clientObject:ClientObject, battleId:String, redPeople:int, bluePeople:int) : void
      {
         var b:BattleClient = null;
         if(this.battles != null)
         {
            b = this.battles[battleId] as BattleClient;
            if(b != null)
            {
               b.countRedPeople = redPeople;
               b.countBluePeople = bluePeople;
               if(this.battleList != null)
               {
                  this.battleList.updatePlayersBlue(battleId,bluePeople,bluePeople >= b.maxPeople);
                  this.battleList.updatePlayersRed(battleId,redPeople,redPeople >= b.maxPeople);
               }
            }
         }
      }
      
      public function updateUsersCountForDM(clientObject:ClientObject, battleId:String, peoples:int) : void
      {
         var b:BattleClient = null;
         if(this.battles != null)
         {
            b = this.battles[battleId] as BattleClient;
            if(b != null)
            {
               b.countPeople = peoples;
               if(this.battleList != null)
               {
                  this.battleList.updatePlayersTotal(battleId,peoples,peoples >= b.maxPeople);
               }
            }
         }
      }
      
      public function currentBattleRestart(clientObject:ClientObject) : void
      {
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            if(this.viewDM != null && this.layer.contains(this.viewDM))
            {
               this.viewDM.info.restartCountDown();
               this.viewDM.dropKills();
            }
            else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
            {
               this.viewTDM.info.restartCountDown();
               this.viewTDM.dropKills();
            }
         }
      }
      
      public function currentBattleUserScoreUpdate(clientObject:ClientObject, user:Long, kills:int) : void
      {
         var userInfo:UserInfoClient = null;
         var logger:ILogService = null;
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            userInfo = this.usersInfo[user] as UserInfoClient;
            if(userInfo != null)
            {
               userInfo.kills = kills;
               if(this.viewDM != null && this.layer.contains(this.viewDM))
               {
                  this.viewDM.updatePlayer(user,userInfo.name,userInfo.rank,kills);
               }
               else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
               {
                  this.viewTDM.updatePlayer(userInfo.type == BattleTeamType.RED,user,userInfo.name,userInfo.rank,kills);
               }
            }
            else
            {
               logger = Main.osgi.getService(ILogService) as ILogService;
               logger.log(LogLevel.LOG_ERROR,"[BattleSelectModel]:currentBattleUserKillsUpdate  ERROR: userInfo = null! (userId: " + user + ")");
            }
         }
      }
      
      public function currentBattleFinish(clientObject:ClientObject) : void
      {
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            if(this.layer.contains(this.viewDM))
            {
               this.viewDM.info.stopCountDown();
            }
            else if(this.layer.contains(this.viewTDM))
            {
               this.viewTDM.info.stopCountDown();
            }
         }
      }
      
      public function battleCreated(clientObject:ClientObject, battleId:Long) : void
      {
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            this.battleList.select(battleId);
         }
      }
      
      public function createBattleFlood(clientObject:ClientObject) : void
      {
		 var alert:Alert = new Alert(Alert.ALERT_PBAT);
         this.layer.addChild(alert);
         //var alertService:IAlertService = Main.osgi.getService(IAlertService) as IAlertService;
         //alertService.showAlert(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.BATTLE_CREATE_PANEL_FLOOD_ALERT_TEXT));
      }
      
      private function checkSelectedBattle() : String
      {
         var selectedBattleId:String = null;
         var s:String = null;
         var v:Array = null;
         if(this.addressService != null)
         {
            s = this.addressService.getValue();
            if(s.indexOf("battle/") != -1)
            {
               v = s.split("/");
               if(v[2] != null)
               {
                  selectedBattleId = v[2] as String;
               }
            }
         }
         return selectedBattleId;
      }
      
      private function onAddressChange(e:SWFAddressEvent) : void
      {
         var i:int = 0;
         var selectedBattleId:String = this.checkSelectedBattle();
         if(selectedBattleId != null)
         {
            for(i = 0; i < this.battlesArray.length; i++)
            {
               if((this.battlesArray[i] as BattleClient).battleId == selectedBattleId && selectedBattleId != this.battleList.selectedBattleID)
               {
                  Main.writeVarsToConsoleChannel("BATTLE SELECT","   select: %1",selectedBattleId);
                  this.battleList.select(selectedBattleId);
               }
            }
         }
      }
      
      public function showList() : void
      {
		 if (battleList == null)
		 {
			 hideList();
			 battleList = new ViewBattleList();
		 }
         if(!this.layer.contains(this.battleList))
         {
            this.layer.addChild(this.battleList);
            this.battleList.addEventListener(BattleListEvent.CREATE_GAME,this.onCreateGameClick);
            this.battleList.addEventListener(BattleListEvent.SELECT_BATTLE,this.onBattleSelect);
         }
      }
      
      public function hideList() : void
      {
         if(this.battleList != null)
         {
            if(this.layer.contains(this.battleList))
            {
               this.layer.removeChild(this.battleList);
               this.battleList.removeEventListener(BattleListEvent.CREATE_GAME,this.onCreateGameClick);
               this.battleList.removeEventListener(BattleListEvent.SELECT_BATTLE,this.onBattleSelect);
            }
         }
      }
      
      private function showCreateForm() : void
      {
         var panelModel:IPanel = null;
		 createBattleForm.visible = true;
         if(!this.layer.contains(this.createBattleForm))
         {
            if(this.createBattleForm != null)
            {
               this.layer.addChild(this.createBattleForm);
            }
            panelModel = IPanel(Main.osgi.getService(IPanel));
			panelModel.closeFriend();
            this.createBattleForm.currentRang = panelModel.rank;
            this.createBattleForm.addEventListener(BattleListEvent.START_CREATED_GAME,this.onStartCreatedGame);
         }
      }
      
      private function hideCreateForm() : void
      {
         if(this.createBattleForm != null)
         {
            if(this.layer.contains(this.createBattleForm))
            {
               this.layer.removeChild(this.createBattleForm);
               this.createBattleForm.removeEventListener(BattleListEvent.START_CREATED_GAME,this.onStartCreatedGame);
            }
         }
      }
      
      private function showInfo(team:Boolean) : void
      {
         if(team)
         {
            if(this.layer.contains(this.viewDM))
            {
               this.layer.removeChild(this.viewDM);
            }
            if(!this.layer.contains(this.viewTDM))
            {
               this.layer.addChild(this.viewTDM);
            }
         }
         else
         {
            if(this.layer.contains(this.viewTDM))
            {
               this.layer.removeChild(this.viewTDM);
            }
            if(!this.layer.contains(this.viewDM))
            {
               this.layer.addChild(this.viewDM);
            }
         }
      }
      
      private function hideInfo() : void
      {
         if(this.viewDM != null)
         {
            if(this.layer.contains(this.viewDM))
            {
               this.layer.removeChild(this.viewDM);
            }
         }
         if(this.viewTDM != null)
         {
            if(this.layer.contains(this.viewTDM))
            {
               this.layer.removeChild(this.viewTDM);
            }
         }
      }
      
      private function onMapSelect(e:Event) : void
      {
         var previewId:String = (this.maps[this.createBattleForm.mapID] as MapClient).previewId;
         Main.writeVarsToConsoleChannel("BATTLE SELECT","1   previewId: " + previewId);
         var imageResource:ImageResouce = ResourceUtil.getResource(ResourceType.IMAGE,previewId) as ImageResouce;
         var previewBitmap:BitmapData = null;
         if(imageResource == null)
         {
            previewBitmap = new BitmapData(1000,1000,false);
         }
         else
         {
            previewBitmap = imageResource.bitmapData as BitmapData;
         }
         Main.writeVarsToConsoleChannel("BATTLE SELECT","1   previewBitmap: " + previewBitmap);
         this.createBattleExpectedResourceId = null;
         this.createBattleForm.info.setPreview(previewBitmap);
      }
      
      private function onCreateGameClick(e:BattleListEvent) : void
      {
         this.hideInfo();
         this.showCreateForm();
         if(this.battlesArray.length > this.maxBattlesNum)
         {
            this.battleList.createButton.enable = false;
         }
      }
      
      private function onStartCreatedGame(e:BattleListEvent) : void
      {
         if(this.createBattleForm.deathMatch)
         {
            this.createBattle(this.clientObject,this.createBattleForm.gameName,this.createBattleForm.mapID as String,this.createBattleForm.time,this.createBattleForm.numKills,this.createBattleForm.numPlayers,this.createBattleForm.minRang,this.createBattleForm.maxRang,this.createBattleForm.PrivateBattle,this.createBattleForm.PayBattle,!!this.createBattleForm.PayBattle?Boolean(!this.createBattleForm.inventoryBattle):Boolean(false));
         }
         else if(this.createBattleForm.CaptureTheFlag)
         {
            this.createBattleCaptureFlag(this.clientObject,this.createBattleForm.gameName,this.createBattleForm.mapID as String,this.createBattleForm.time,this.createBattleForm.numFlags,this.createBattleForm.numPlayers,this.createBattleForm.minRang,this.createBattleForm.maxRang,this.createBattleForm.autoBalance,this.createBattleForm.friendlyFire,this.createBattleForm.PrivateBattle,this.createBattleForm.PayBattle,!!this.createBattleForm.PayBattle?Boolean(!this.createBattleForm.inventoryBattle):Boolean(false));
         }
         else
         {
            this.createBattleTeam(this.clientObject,this.createBattleForm.gameName,this.createBattleForm.mapID as String,this.createBattleForm.time,this.createBattleForm.numKills,this.createBattleForm.numPlayers,this.createBattleForm.minRang,this.createBattleForm.maxRang,this.createBattleForm.autoBalance,this.createBattleForm.friendlyFire,this.createBattleForm.PrivateBattle,this.createBattleForm.PayBattle,!!this.createBattleForm.PayBattle?Boolean(!this.createBattleForm.inventoryBattle):Boolean(false));
         }
         this.hideCreateForm();
      }
      
      private function createBattleCaptureFlag(clientObject:ClientObject, gameName:String, mapId:String, time:int, numFlags:int, numPlayers:int, minRang:int, maxRang:int, autoBalance:Boolean, friendlyFire:Boolean, privateBattle:Boolean, payBattle:Boolean, inventory:Boolean) : void
      {
         var json:Object = new Object();
         json.gameName = gameName;
         json.mapId = mapId;
         json.time = time;
         json.numFlags = numFlags;
         json.numPlayers = numPlayers;
         json.minRang = minRang;
         json.maxRang = maxRang;
         json.autoBalance = autoBalance;
         json.frielndyFire = friendlyFire;
         json.privateBattle = privateBattle;
         json.pay = payBattle;
         json.inventory = inventory;
         Network(Main.osgi.getService(INetworker)).send("lobby;try_create_battle_ctf;" + JSON.stringify(json));
      }
      
      private function createBattleTeam(cl:ClientObject, gameName:String, mapId:String, time:int, numKills:int, numPlayers:int, minRang:int, maxRang:int, autoBalance:Boolean, frielndyFire:Boolean, privateBattle:Boolean, pay:Boolean, inventory:Boolean) : void
      {
         var json:Object = new Object();
         json.gameName = gameName;
         json.mapId = mapId;
         json.time = time;
         json.numKills = numKills;
         json.numPlayers = numPlayers;
         json.minRang = minRang;
         json.maxRang = maxRang;
         json.autoBalance = autoBalance;
         json.frielndyFire = frielndyFire;
         json.privateBattle = privateBattle;
         json.pay = pay;
         json.inventory = inventory;
         Network(Main.osgi.getService(INetworker)).send("lobby;try_create_battle_tdm;" + JSON.stringify(json));
      }
      
      private function createBattle(cl:ClientObject, gameName:String, id:String, time:Number, numKills:Number, numPlayers:Number, minRang:int, maxRang:int, isPrivate:Boolean, isPay:Boolean, isX3:Boolean) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;try_create_battle_dm;" + gameName + ";" + id + ";" + time + ";" + numKills + ";" + numPlayers + ";" + minRang + ";" + maxRang + ";" + isPrivate + ";" + isPay + ";" + isX3);
      }
      
      private function onBattleSelect(e:BattleListEvent) : void
      {
         this.selectBattle(this.clientObject,this.battleList.selectedBattleID as String);
         var b:BattleClient = this.battles[this.battleList.selectedBattleID as String] as BattleClient;
         if(b.minRank > this.panelModel.rank || b.maxRank < this.panelModel.rank)
         {
            this.lockedMapsHelper.targetPoint = new Point(Main.stage.mouseX,Main.stage.mouseY);
         }
      }
      
      private function selectBattle(cl:ClientObject, id:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;get_show_battle_info;" + id);
      }
      
      private function onStartPaidDMBattle(e:BattleListEvent) : void
      {
         Main.blur();
         this.paidBattleAlert = new Alert();
         this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_TEXT),[this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER),this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_DONT_ENTER)]);
         this.dialogsLayer.addChild(this.paidBattleAlert);
         this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAcceptPaidDMBattle);
      }
      
      private function onStartPaidRedTeamBattle(e:BattleListEvent) : void
      {
         Main.blur();
         this.paidBattleAlert = new Alert();
         this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_TEXT),[this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER),this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_DONT_ENTER)]);
         this.dialogsLayer.addChild(this.paidBattleAlert);
         this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAcceptPaidRedTeamBattle);
      }
      
      private function onStartPaidBlueTeamBattle(e:BattleListEvent) : void
      {
         Main.blur();
         this.paidBattleAlert = new Alert();
         this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_TEXT),[this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER),this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_DONT_ENTER)]);
         this.dialogsLayer.addChild(this.paidBattleAlert);
         this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAcceptPaidBlueTeamBattle);
      }
      
      private function onAcceptPaidDMBattle(e:AlertEvent) : void
      {
         Main.unblur();
         if(e.typeButton == this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER))
         {
            this.clearURL = false;
            this.viewDM.removeEventListener(BattleListEvent.START_DM_GAME,this.onStartPaidDMBattle);
            this.fightBattle(this.clientObject,false,false);
         }
      }
      
      private function onAcceptPaidRedTeamBattle(e:AlertEvent) : void
      {
         Main.unblur();
         if(e.typeButton == this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER))
         {
            this.clearURL = false;
            this.viewTDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartPaidBlueTeamBattle);
            this.viewTDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartPaidRedTeamBattle);
            this.fightBattle(this.clientObject,true,true);
         }
      }
      
      private function onAcceptPaidBlueTeamBattle(e:AlertEvent) : void
      {
         Main.unblur();
         if(e.typeButton == this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER))
         {
            this.clearURL = false;
            this.viewTDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartPaidBlueTeamBattle);
            this.viewTDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartPaidRedTeamBattle);
            this.fightBattle(this.clientObject,true,false);
         }
      }
      
      private function onStartDMBattle(e:BattleListEvent) : void
      {
         this.clearURL = false;
         this.viewDM.removeEventListener(BattleListEvent.START_DM_GAME,this.onStartDMBattle);
         this.fightBattle(this.clientObject,false,false);
      }
      
      private function fightBattle(cl:ClientObject, team:Boolean, red:Boolean) : void
      {
         var temp:BattleController = null;
         this.objectUnloaded(null);
         PanelModel(Main.osgi.getService(IPanel)).startBattle(null);
         Main.osgi.getService(ILobby).chat.chatModel.objectUnloaded(null);
         Network(Main.osgi.getService(INetworker)).send("lobby;" + (!team?"enter_battle;":"enter_battle_team;") + this.selectedBattleId + ";" + red);
         if(BattleController(Main.osgi.getService(IBattleController)) == null)
         {
            temp = new BattleController();
            Main.osgi.registerService(IBattleController,temp);
         }
         Network(Main.osgi.getService(INetworker)).addEventListener(Main.osgi.getService(IBattleController) as BattleController);
      }
      
      private function onStartTeamBattleForRed(e:BattleListEvent) : void
      {
         this.clearURL = false;
         this.viewDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartTeamBattleForRed);
         this.viewDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartTeamBattleForBlue);
         this.fightBattle(this.clientObject,true,true);
      }
      
      private function onStartTeamBattleForBlue(e:BattleListEvent) : void
      {
         this.clearURL = false;
         this.viewDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartTeamBattleForRed);
         this.viewDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartTeamBattleForBlue);
         this.fightBattle(this.clientObject,true,false);
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var battle:BattleClient = null;
         var result:String = "\n";
         for(var i:int = 0; i < this.battlesArray.length; i++)
         {
            battle = this.battlesArray[i] as BattleClient;
            result = result + ("   battle id: " + battle.battleId + "   battle name: " + battle.name + "   map id: " + battle.mapId + "\n");
         }
         result = result + "\n";
         return result;
      }
      
      public function get dumperName() : String
      {
         return "battle";
      }
      
      private function alignHelpers(e:Event = null) : void
      {
         var minWidth:int = int(Math.max(100,Main.stage.stageWidth));
         var minHeight:int = int(Math.max(60,Main.stage.stageHeight));
         this.createHelper.targetPoint = new Point(Math.round(minWidth * (2 / 3)) - 47,minHeight - 34);
      }
      
      private function checkBattleName(event:BattleListEvent) : void
      {
         this.gameNameBeforeCheck = this.createBattleForm.gameName;
         this.checkBattleNameForForbiddenWords(this.clientObject,this.createBattleForm.gameName);
      }
      
      private function checkBattleNameForForbiddenWords(cl:ClientObject, forCheck:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;check_battleName_for_forbidden_words;" + forCheck);
      }
      
      public function setFilteredBattleName(clientObject:ClientObject, name:String) : void
      {
         if(this.createBattleForm.gameName == this.gameNameBeforeCheck && this.gameNameBeforeCheck != name)
         {
            this.createBattleForm.gameName = name;
         }
         else
         {
            this.createBattleForm.gameName = this.createBattleForm.gameName;
         }
      }
      
      public function serverIsRestarting(clientObject:ClientObject) : void
      {
         var serverIsRestartingAlert:Alert = new Alert();
         serverIsRestartingAlert.showAlert(this.localeService.getText(TextConst.SERVER_IS_RESTARTING_CREATE_BATTLE_TEXT),[AlertAnswer.OK]);
         this.dialogsLayer.addChild(serverIsRestartingAlert);
      }
      
      public function enterInBattleSpectator() : void
      {
         var temp:BattleController = null;
         this.objectUnloaded(null);
         PanelModel(Main.osgi.getService(IPanel)).startBattle(null);
         Main.osgi.getService(ILobby).chat.chatModel.objectUnloaded(null);
         if(BattleController(Main.osgi.getService(IBattleController)) == null)
         {
            temp = new BattleController();
            Main.osgi.registerService(IBattleController,temp);
         }
         Network(Main.osgi.getService(INetworker)).send("lobby;enter_battle_spectator;" + this.selectedBattleId);
         Network(Main.osgi.getService(INetworker)).addEventListener(Main.osgi.getService(IBattleController) as BattleController);
      }
   }
}
