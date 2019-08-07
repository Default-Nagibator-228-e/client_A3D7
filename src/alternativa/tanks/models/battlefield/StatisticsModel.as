package alternativa.tanks.models.battlefield
{
   import alternativa.init.Main;
   import flash.filters.GlowFilter;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.focus.IFocusListener;
   import alternativa.osgi.service.focus.IFocusService;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.IPanelListener;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.models.battlefield.event.ExitEvent;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.gui.PauseIndicator;
   import alternativa.tanks.models.battlefield.gui.help.ControlsHelper;
   import alternativa.tanks.models.battlefield.gui.statistics.field.FieldStatistics;
   import alternativa.tanks.models.battlefield.gui.statistics.field.WinkManager;
   import alternativa.tanks.models.battlefield.gui.statistics.fps.FPSText;
   import alternativa.tanks.models.battlefield.gui.statistics.messages.BattleMessages;
   import alternativa.tanks.models.battlefield.gui.statistics.table.TableStatistics;
   import alternativa.tanks.models.ctf.CTFMessages;
   import alternativa.tanks.models.ctf.CTFModel;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankModel;
   import utils.client.models.ctf.ICaptureTheFlagModelBase;
   import controls.Label;
   import controls.lifeindicator.LifeIndicator;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.filters.DropShadowFilter;
   import flash.ui.Keyboard;
   import forms.FocusWarningWindow;
   import utils.client.battlefield.gui.models.statistics.BattleStatInfo;
   import utils.client.battlefield.gui.models.statistics.IStatisticsModelBase;
   import utils.client.battlefield.gui.models.statistics.StatisticsModelBase;
   import utils.client.battlefield.gui.models.statistics.UserStat;
   import utils.client.battleservice.model.team.BattleTeamType;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import utils.FontParamsUtil;
   
   public class StatisticsModel extends StatisticsModelBase implements IStatisticsModelBase, IObjectLoadListener, IFocusListener, IBattlefieldGUI, IUserStat, IChatListener, IPanelListener
   {
      
      public static const LOG_CHANNEL:String = "STAT";
      
      public static const LOG_PREFIX:String = "[StatisticsModel]";
       
      
      private var battleClientObject:ClientObject;
      
      private var contentLayer:DisplayObjectContainer;
      
      private var modelService:IModelService;
      
      private var teamPlay:Boolean;
      
      private var tableStatistics:TableStatistics;
      
      private var fieldStatistics:FieldStatistics;
      
      private var battleMessages:BattleMessages;
      
      private var userStats:Vector.<UserStat>;
      
      private var battleFinished:Boolean = false;
      
      private var loaderWindow:ILoaderWindowService;
      
      private var fpsIndicator:FPSText;
      
      private var controlsHelper:ControlsHelper;
	  
	  public var ctfMessages:CTFMessages = new CTFMessages(3,18,18);
      
      private var localUserId:String;
      
      private var userStatListeners:Vector.<IUserStatListener>;
      
      private var battleName:String;
      
      private var joinMessage:String;
      
      private var leaveMessage:String;
      
      private var lifeIndicator:LifeIndicator;
      
      private var focusWarningIndicator:FocusWarningWindow;
      
      private var pauseIndicator:PauseIndicator;
      
      private var paused:Boolean;
      
      public function StatisticsModel()
      {
         this.userStatListeners = new Vector.<IUserStatListener>();
         super();
         _interfaces.push(IModel,IStatisticsModelBase,IObjectLoadListener,IFocusListener,IBattlefieldGUI,IUserStat,IChatListener,IPanelListener);
         this.contentLayer = Main.contentUILayer;
         this.fpsIndicator = new FPSText();
         WinkManager.init(500);
         Main.osgi.registerService(IBattlefieldGUI,this);
         this.localUserId = PanelModel(Main.osgi.getService(IPanel)).userName;
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.paused = false;
         this.loaderWindow = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
         this.loaderWindow.hideLoaderWindow();
         this.loaderWindow.lockLoaderWindow();
         Main.stage.addEventListener(Event.RESIZE,this.onResize);
         var focusService:IFocusService = IFocusService(Main.osgi.getService(IFocusService));
         focusService.addFocusListener(this);
         var locale:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.pauseIndicator = new PauseIndicator(locale.getText(TextConst.BATTLE_PAUSE_ENABLED),locale.getText(TextConst.BATTLE_PAUSE_PRESS_ANY_KEY),locale.getText(TextConst.BATTLE_PAUSE_BATTLE_LEAVE));
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         this.showFocusWarning(false);
         this.showPauseIndicator(false);
		 var bf:BattleController = BattleController(Main.osgi.getService(IBattleController));
         this.pauseIndicator = null;
         var focusService:IFocusService = IFocusService(Main.osgi.getService(IFocusService));
         focusService.removeFocusListener(this);
         Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         Main.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         Main.stage.removeEventListener(Event.RESIZE, this.onResize);
		 Main.stage.removeEventListener(Event.ENTER_FRAME, this.tik);
		 this.removeDisplayObject(this.contentLayer,this.tableStatistics);
		 this.removeDisplayObject(Main.contentUILayer,this.ctfMessages);
		 this.ctfMessages = null;
         this.removeDisplayObject(this.contentLayer,this.fieldStatistics);
         this.removeDisplayObject(this.contentLayer,this.battleMessages);
         this.removeDisplayObject(this.contentLayer, this.fpsIndicator);
		 this.removeDisplayObject(this.contentLayer, bf.de);
		 this.removeDisplayObject(this.contentLayer, bf.testLabelPing);
         this.removeDisplayObject(this.contentLayer,this.lifeIndicator);
         this.lifeIndicator = null;
         this.unregisterControlsHelpScreen();
         this.loaderWindow.unlockLoaderWindow();
         this.battleClientObject = null;
         this.userStats = null;
         this.battleMessages = null;
      }
      
      public function deactivate() : void
      {
         if(this.battleClientObject == null)
         {
            return;
         }
         if(!this.battleFinished)
         {
            this.tableStatistics.hide();
         }
         this.doShowPauseIndicator(false);
         this.showFocusWarning(true);
      }
      
      public function activate() : void
      {
         if(this.battleClientObject == null)
         {
            return;
         }
         this.showFocusWarning(false);
         if(this.paused)
         {
            this.doShowPauseIndicator(true);
         }
      }
      
      public function focusOut(exfocusedObject:Object) : void
      {
      }
      
      public function focusIn(focusedObject:Object) : void
      {
      }
      
      public function initObject(clientObject:ClientObject, battleName:String) : void
      {
         this.battleName = battleName;
         var locale:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.joinMessage = locale.getText(TextConst.BATTLE_PLAYER_JOINED);
         this.leaveMessage = locale.getText(TextConst.BATTLE_PLAYER_LEFT);
         this.userStatListeners.push(TankModel(Main.osgi.getService(ITank)));
      }
      
      public function init(clientObject:ClientObject, initData:BattleStatInfo, userStats:Array) : void
      {
         var battleType:BattleType = null;
         var userStat:UserStat = null;
         var ctfModel:CTFModel = null;
		 var bf:BattleController = BattleController(Main.osgi.getService(IBattleController));
         this.battleClientObject = clientObject;
         this.teamPlay = initData.teamPlay;
         this.userStats = Vector.<UserStat>(userStats);
         this.battleFinished = false;
         this.tableStatistics = new TableStatistics(this.battleName,this.teamPlay);
         this.contentLayer.addChild(this.tableStatistics);
         if(this.teamPlay)
         {
            ctfModel = CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase));
            battleType = ctfModel == null?BattleType.TDM:BattleType.CTF;
         }
         else
         {
            battleType = BattleType.DM;
         }
         this.fieldStatistics = new FieldStatistics(this.localUserId,initData,this.userStats,battleType);
         this.contentLayer.addChild(this.fieldStatistics);
         this.fieldStatistics.adjustFields();
         this.battleMessages = new BattleMessages();
         this.contentLayer.addChild(this.battleMessages);
         this.registerControlsHelpScreen();
		 this.ctfMessages = new CTFMessages(3,18,18);
		 if(bf.testLabelPing == null)
         {
            bf.testLabelPing = new Label();
            bf.testLabelPing.selectable = true;
			bf.testLabelPing.filters = [new GlowFilter(0,0.8,4,4,3)];
			bf.testLabelPing.bold = true;
			bf.testLabelPing.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
			bf.testLabelPing.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
         }
		 if(bf.de == null)
         {
            bf.de = new Label();
			bf.de.text = "PING: ";
			bf.de.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
			bf.de.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
         }
		 //Main.contentLayer.addChild(bf.testLabelPing);
		 //Main.contentLayer.addChild(bf.de);
		 //Network(Main.osgi.getService(INetworker)).send("battle;ping");
		 
         var settings:IBattleSettings = IBattleSettings(Main.osgi.getService(IBattleSettings));
         if(settings.showFPS)
         {
            this.contentLayer.addChild(this.fpsIndicator);
			this.contentLayer.addChild(bf.testLabelPing);
			this.contentLayer.addChild(bf.de);
         }
		 Main.contentUILayer.addChild(ctfMessages);
         Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         Main.stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
		 Main.stage.addEventListener(Event.ENTER_FRAME,this.tik);
         for each(userStat in this.userStats)
         {
            this.dispatchStatChange(userStat);
         }
         this.objectLoaded(clientObject);
		 onResize(null);
      }
	  
	  public function tik(r:Event) : void
      {
         this.ctfMessages.update(25);
      }
      
      public function setBattleState(clientObject:ClientObject) : void
      {
      }
      
      public function changeUserTeam(clientObject:ClientObject, userId:String, teamType:BattleTeamType) : void
      {
         var userStat:UserStat = this.getUserStatByID(userId);
         if(userStat != null)
         {
            this.tableStatistics.removePlayer(userId,userStat.teamType);
            userStat.teamType = teamType;
            this.tableStatistics.updatePlayer(userStat);
         }
      }
      
      public function userConnect(clientObject:ClientObject, userId:String, teamType:BattleTeamType, name:String, rank:int) : void
      {
         var userStat:UserStat = new UserStat(0,0,name,rank,0,0,teamType,name,0);
         this.userStats.push(userStat);
		 this.battleMessages.addMessage(userStat,this.joinMessage);
         this.tableStatistics.updatePlayer(userStat);
         this.dispatchStatChange(userStat);
      }
      
      public function userDisconnect(clientObject:ClientObject, userId:String) : void
      {
         var idx:int = this.getUserIndexByID(userId);
         if(idx < 0)
         {
            return;
         }
         var userStat:UserStat = this.userStats[idx];
         if(!this.battleFinished)
         {
            this.tableStatistics.removePlayer(userId,userStat.teamType);
         }
		 this.battleMessages.addMessage(userStat,this.leaveMessage);
         this.userStats.splice(idx,1);
      }
      
      public function fundChange(clientObject:ClientObject, fund:int) : void
      {
         if(this.fieldStatistics == null)
         {
            return;
         }
         this.fieldStatistics.updateFund(fund);
      }
      
      public function finish(clientObject:ClientObject, users:Array, timeToRestart:int) : void
      {
         if(this.tableStatistics != null)
         {
            this.tableStatistics.hide();
            this.tableStatistics.addEventListener(ExitEvent.EXIT,this.onExit);
            this.tableStatistics.show(this.localUserId,Vector.<UserStat>(users),true,timeToRestart);
         }
         this.battleFinished = true;
         if(this.fieldStatistics != null)
         {
            this.fieldStatistics.finish();
         }
      }
      
      public function restart(clientObject:ClientObject, newTimeLimit:int) : void
      {
         var userStat:UserStat = null;
         this.tableStatistics.hide();
         this.tableStatistics.removeEventListener(ExitEvent.EXIT,this.onExit);
         this.fieldStatistics.timeLimit = newTimeLimit;
         this.fieldStatistics.resetFields();
         this.battleFinished = false;
         var len:int = this.userStats.length;
         for(var i:int = 0; i < len; i++)
         {
            userStat = this.userStats[i];
            userStat.deaths = 0;
            userStat.kills = 0;
            userStat.score = 0;
         }
      }
      
      public function changeTeamScore(clientObject:ClientObject, teamType:BattleTeamType, score:int) : void
      {
         if(this.battleClientObject == null)
         {
            return;
         }
         this.fieldStatistics.setTeamScore(teamType,score);
      }
      
      public function changeUsersStat(clientObject:ClientObject, userStats:Array) : void
      {
         var userStat:UserStat = null;
         var localUserStat:UserStat = null;
         if(userStats == null)
         {
            return;
         }
         var len:int = userStats.length;
         for(var i:int = 0; i < len; i++)
         {
            userStat = userStats[i];
            localUserStat = this.getUserStatByID(userStat.userId);
            if(localUserStat != null)
            {
               localUserStat.score = userStat.score;
               localUserStat.kills = userStat.kills;
               localUserStat.deaths = userStat.deaths;
               localUserStat.rank = userStat.rank;
               if(!this.battleFinished)
               {
                  this.tableStatistics.updatePlayer(localUserStat);
               }
               this.fieldStatistics.updateUserKills(userStat);
               this.dispatchStatChange(userStat);
            }
         }
      }
      
      public function logUserAction(userId:String, actionText:String, targetUserId:String = null) : void
      {
         var userStat:UserStat = this.getUserStatByID(userId);
         if(userStat == null)
         {
            userStat = new UserStat(0,0,userStat.name,userStat.rank,0,0,BattleTeamType.RED,null,0);
         }
         var targetUserStat:UserStat = targetUserId == null?null:this.getUserStatByID(targetUserId);
         this.battleMessages.addMessage(userStat,actionText,targetUserStat);
      }
      
      public function ctfShowFlagAtBase(teamType:BattleTeamType) : void
      {
         if(this.fieldStatistics != null)
         {
            this.fieldStatistics.ctfShowFlagAtBase(teamType);
         }
      }
      
      public function ctfShowFlagCarried(teamType:BattleTeamType) : void
      {
         if(this.fieldStatistics != null)
         {
            this.fieldStatistics.ctfShowFlagCarried(teamType);
         }
      }
      
      public function ctfShowFlagDropped(teamType:BattleTeamType) : void
      {
         if(this.fieldStatistics != null)
         {
            this.fieldStatistics.ctfShowFlagDropped(teamType);
         }
      }
      
      public function updateHealthIndicator(health:Number) : void
      {
         if(this.lifeIndicator != null)
         {
            this.lifeIndicator.life = health;
         }
      }
      
      public function updateWeaponIndicator(weaponStatus:Number) : void
      {
         if(this.lifeIndicator != null)
         {
            this.lifeIndicator.charge = weaponStatus;
         }
      }
      
      public function showPauseIndicator(show:Boolean) : void
      {
         if(this.paused == show)
         {
            return;
         }
         this.paused = show;
         this.doShowPauseIndicator(show);
      }
      
      public function setPauseTimeout(seconds:int) : void
      {
         if(this.pauseIndicator != null)
         {
            this.pauseIndicator.seconds = seconds;
         }
      }
      
      public function getUserName(userId:String) : String
      {
         var userStat:UserStat = this.getUserStatByID(userId);
         return userStat == null?"Unknown " + userId.toString():userStat.name;
      }
      
      public function getUserRank(userId:String) : int
      {
         var userStat:UserStat = this.getUserStatByID(userId);
         return userStat == null?int(-1):int(userStat.rank);
      }
      
      public function addUserStatListener(listener:IUserStatListener) : void
      {
         var idx:int = this.userStatListeners.indexOf(listener);
         if(idx > -1)
         {
            return;
         }
         this.userStatListeners.push(listener);
      }
      
      public function removeUserStatListener(listener:IUserStatListener) : void
      {
         var idx:int = this.userStatListeners.indexOf(listener);
         if(idx < 0)
         {
            return;
         }
         this.userStatListeners.splice(idx,1);
      }
      
      public function chatOpened() : void
      {
         this.hideScores();
      }
      
      public function chatClosed() : void
      {
      }
      
      public function bugReportOpened() : void
      {
      }
      
      public function bugReportClosed() : void
      {
      }
      
      public function settingsAccepted() : void
      {
         var settings:IBattleSettings = IBattleSettings(Main.osgi.getService(IBattleSettings));
         if(settings.showFPS)
         {
            this.contentLayer.addChild(this.fpsIndicator);
         }
         else
         {
            this.removeDisplayObject(this.contentLayer,this.fpsIndicator);
         }
      }
      
      public function settingsCanceled() : void
      {
      }
      
      public function settingsOpened() : void
      {
      }
      
      public function setMuteSound(mute:Boolean) : void
      {
      }
      
      private function onExit(e:ExitEvent) : void
      {
         this.exit(this.battleClientObject);
         var panel:PanelModel = Main.osgi.getService(IPanel) as PanelModel;
         panel.lock();
         panel.onExitFromBattle(false);
         panel.isBattleSelect = true;
         (Main.osgi.getService(ILoader) as CheckLoader).setProgress(459);
      }
      
      private function exit(battle:ClientObject) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;exit_from_statistic");
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.TAB && !this.battleFinished)
         {
            this.showScores();
         }
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.TAB && !this.battleFinished)
         {
            this.hideScores();
         }
      }
      
      private function showScores() : void
      {
         if(this.battleFinished)
         {
            return;
         }
         this.tableStatistics.show(this.localUserId,this.userStats,false,0);
      }
      
      private function hideScores() : void
      {
         if(this.battleFinished && this.tableStatistics == null)
         {
            return;
         }
         if(this.battleFinished)
         {
            return;
         }
         if(this.tableStatistics != null)
         {
            this.tableStatistics.hide();
         }
      }
      
      private function getUserIndexByID(userId:String) : int
      {
         var i:int = 0;
         if(this.userStats != null)
         {
            for(i = this.userStats.length - 1; i >= 0; i--)
            {
               if(UserStat(this.userStats[i]).userId == userId)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      private function getUserStatByID(userId:String) : UserStat
      {
         var i:int = 0;
         var userStat:UserStat = null;
         if(this.userStats != null)
         {
            for(i = this.userStats.length - 1; i >= 0; i--)
            {
               userStat = this.userStats[i];
               if(userStat.userId == userId)
               {
                  return userStat;
               }
            }
         }
         return null;
      }
      
      private function registerControlsHelpScreen() : void
      {
         if(this.controlsHelper == null)
         {
            this.controlsHelper = new ControlsHelper();
         }
         var helpService:IHelpService = Main.osgi.getService(IHelpService) as IHelpService;
         helpService.registerHelper(ControlsHelper.GROUP_ID,ControlsHelper.HELPER_ID,this.controlsHelper,true);
      }
      
      private function unregisterControlsHelpScreen() : void
      {
         var helpService:IHelpService = Main.osgi.getService(IHelpService) as IHelpService;
         helpService.unregisterHelper(ControlsHelper.GROUP_ID,ControlsHelper.HELPER_ID);
      }
      
      private function dispatchStatChange(userStat:UserStat) : void
      {
         for(var i:int = this.userStatListeners.length - 1; i >= 0; i--)
         {
            IUserStatListener(this.userStatListeners[i]).userStatChanged(userStat.userId,userStat.name,userStat.rank);
         }
      }
      
      private function removeDisplayObject(container:DisplayObjectContainer, object:DisplayObject) : void
      {
         if(object != null && container.contains(object))
         {
            container.removeChild(object);
         }
      }
      
      private function onResize(e:Event) : void
      {
         var sw:int = Main.stage.stageWidth;
         var sh:int = Main.stage.stageHeight;
		 var bf:BattleController = BattleController(Main.osgi.getService(IBattleController));
         if(this.lifeIndicator != null)
         {
            this.lifeIndicator.x = 260;
            this.lifeIndicator.y = Main.stage.stageHeight - 50;
         }
         if(this.focusWarningIndicator != null)
         {
            this.focusWarningIndicator.x = sw >> 1;
            this.focusWarningIndicator.y = sh >> 1;
         }
         if(this.pauseIndicator != null && this.pauseIndicator.parent != null)
         {
            this.pauseIndicator.x = sw - this.pauseIndicator.width >> 1;
            this.pauseIndicator.y = sh - this.pauseIndicator.height >> 1;
         }
		 if (bf.de != null && bf.testLabelPing != null)
		 {
			bf.de.x = Main.contentLayer.stage.stageWidth - 46 - bf.testLabelPing.width;
			bf.de.y = Main.contentLayer.stage.stageHeight - 75;
		 }
		 if (bf.de != null && bf.testLabelPing != null)
		 {
			bf.testLabelPing.x = Main.contentLayer.stage.stageWidth - 46 + bf.de.width - bf.testLabelPing.width;
			bf.testLabelPing.y = Main.contentLayer.stage.stageHeight - 75;
		 }
		 if(this.ctfMessages != null)
         {
            this.ctfMessages.x = 0.5 * Main.stage.stageWidth;
            this.ctfMessages.y = 40;
         }
      }
      
      private function showFocusWarning(show:Boolean) : void
      {
         if(show)
         {
            if(this.focusWarningIndicator == null)
            {
               this.focusWarningIndicator = new FocusWarningWindow();
               this.focusWarningIndicator.mouseEnabled = false;
               this.focusWarningIndicator.mouseChildren = false;
            }
            Main.stage.addChild(this.focusWarningIndicator);
            this.onResize(null);
         }
         else if(this.focusWarningIndicator != null && this.focusWarningIndicator.parent != null)
         {
            this.focusWarningIndicator.parent.removeChild(this.focusWarningIndicator);
         }
      }
      
      private function doShowPauseIndicator(show:Boolean) : void
      {
         if(show)
         {
            if(this.focusWarningIndicator == null || this.focusWarningIndicator.parent == null && this.pauseIndicator != null)
            {
               Main.stage.addChild(this.pauseIndicator);
               this.onResize(null);
            }
         }
         else if(this.pauseIndicator != null && this.pauseIndicator.parent != null)
         {
            this.pauseIndicator.parent.removeChild(this.pauseIndicator);
         }
      }
   }
}
