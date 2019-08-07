package alternativa.tanks.models.tank
{
   import alternativa.init.Main;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.osgi.service.focus.IFocusListener;
   import alternativa.osgi.service.focus.IFocusService;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.network.INetworkListener;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.IBodyCollisionPredicate;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.register.ClientClass;
   import alternativa.register.ObjectRegister;
   import alternativa.resource.StubBitmapData;
   import alternativa.service.IModelService;
   import alternativa.service.Logger;
   import alternativa.tanks.display.usertitle.UserTitle;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.IPanelListener;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.IChatListener;
   import alternativa.tanks.models.battlefield.IUserStat;
   import alternativa.tanks.models.battlefield.IUserStatListener;
   import alternativa.tanks.models.battlefield.StatisticsModel;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.logic.BeforeKillTankTask;
   import alternativa.tanks.models.battlefield.logic.updaters.LocalHullTransformUpdater;
   import alternativa.tanks.models.battlefield.logic.updaters.RemoteHullTransformUpdater;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.effectsvisualization.ClientBattleEffect;
   import alternativa.tanks.models.effectsvisualization.IEffectsVisualizationModel;
   import alternativa.tanks.models.inventory.IInventory;
   import alternativa.tanks.models.inventory.InventoryItemType;
   import alternativa.tanks.models.inventory.InventoryLock;
   import alternativa.tanks.models.tank.explosion.ITankExplosionModel;
   import alternativa.tanks.models.tank.explosion.TankDeathGraphicEffect;
   import alternativa.tanks.models.tank.explosion.TankExplosionModel;
   import alternativa.tanks.models.tank.krit.ITankKritModel;
   import alternativa.tanks.models.tank.krit.TankKritGraphicEffect;
   import alternativa.tanks.models.tank.krit.TankKritModel;
   import alternativa.tanks.models.weapon.IWeapon;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.sfx.TankSounds;
   import alternativa.tanks.vehicles.tanks.Tank;
   import alternativa.tanks.vehicles.tanks.TankPhysicsData;
   import alternativa.tanks.vehicles.tanks.TankSkin;
   import alternativa.tanks.vehicles.tanks.TankSkinHull;
   import alternativa.tanks.vehicles.tanks.TankSkinTurret;
   import utils.client.commons.types.DeathReason;
   import utils.client.commons.types.TankParts;
   import utils.client.commons.types.TankSpecification;
   import utils.client.commons.types.TankState;
   import utils.client.commons.types.Vector3d;
   import utils.client.models.tank.ClientTank;
   import utils.client.models.tank.ITankModelBase;
   import utils.client.models.tank.TankModelBase;
   import utils.client.models.tank.TankResources;
   import utils.client.models.tank.TankSoundScheme;
   import utils.client.models.tank.TankSpawnState;
   import flash.display.BitmapData;
   import flash.events.KeyboardEvent;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import forms.ChangeTeamAlert;
   import utils.client.battleservice.model.team.BattleTeamType;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import alternativa.tanks.gui.resource.images.ImageResouce;
   import alternativa.tanks.utils.WeaponsManager;
   import alternativa.tanks.models.battlefield.gui.usertitles.DefaultUserTitlesRender;
   import alternativa.tanks.models.battlefield.gui.usertitles.SpectatorUserTitlesRender;
   import alternativa.tanks.models.battlefield.gui.usertitles.UserTitlesRender;
   
   use namespace altphysics;
   
   public class TankModel extends TankModelBase implements ITankModelBase, IObjectLoadListener, INetworkListener, IFocusListener, IPanelListener, ITank, IUserStatListener, IDumper, IChatListener
   {
      
      private static const CHANGE_TEAM_ALERT_DELAY:int = 5;
      
      private static const DEFAULT_TANK_MASS:Number = 1250;
      
      private static const DEFAULT_TANK_POWER:Number = 80000;
      
      private static var CORRECTION_INTERVAL:int = 500;
      
      private static const MIN_ALLOWED_Z:Number = -10000;
      
      private static const RESPAWN_DELAY:int = 3000;
      
      private static const SUICIDE_DELAY:int = 10000;
      
      private static const ALT_KEY_CODE:int = 18;
      
      private static const PAUSE_KEY_CODE_1:int = 80;
      
      private static const PAUSE_KEY_CODE_2:int = 19;
      
      private static const SUICIDE_KEY_CODE:int = 220;
      
      private static const FORWARD:int = 1;
      
      private static const BACK:int = 2;
      
      private static const LEFT:int = 4;
      
      private static const RIGHT:int = 8;
      
      private static const TURRET_LEFT:int = 16;
      
      private static const TURRET_RIGHT:int = 32;
      
      private static const CENTER_TURRET:int = 64;
      
      private static const REVERSE_TURN_BIT:int = 128;
      
      private static var materialRegistry:IMaterialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
       
      
      private var tankPartsRegistry:TankPartsRegistry;
      
      private var titleShowDistance:Number = 7000;
      
      private var titleHideDistance:Number = 7050;
      
      private var correctionEnabled:Boolean;
      
      private var nextCorrectionTime:int;
      
      private var _userControlsEnabled:Boolean;
      
      private var reverseBackTurn:Boolean;
      
      private var controlBits:int;
      
      private var keyTableDown:Dictionary;
      
      public var keyTableUp:Dictionary;
      
      private var modelService:IModelService;
      
      private var battlefield:BattlefieldModel;
      
      private var gui:IBattlefieldGUI;
      
      private var effectsModel:IEffectsVisualizationModel;
      
      private var inventoryModel:IInventory;
      
      private var tankDispatcher:ITankEventDispatcher;
      
      private var userStat:IUserStat;
      
      public var localUserData:TankData;
      
      private var tankDataById:Dictionary;
      
      private var numTanks:int;
      
      private var uiControlLockCount:int;
      
      private var readyToSpawnCommandSent:Boolean;
      
      private var suicideTime:int;
      
      private var awaitingKillCommand:Boolean;
      
      private var firstSpawn:Boolean;
      
      private var activationTime:int;
      
      private var idleTimerEnabled:Boolean;
      
      private var idleTime:int;
      
      private var idleKickPeriod:int;
      
      private var _pos3d:Vector3d;
      
      private var _orient3d:Vector3d;
      
      private var _linVel3d:Vector3d;
      
      private var _angVel3d:Vector3d;
      
      private const _orientation:Quaternion = new Quaternion();
      
      private const _orientation2:Quaternion = new Quaternion();
      
      private const _eulerAngles:Vector3 = new Vector3();
      
      private var suicideMessage:String;
      
      private var killMessage:String;
      
      private var paused:Boolean;
      
      private var controlsLocked:Boolean;
      
      private var point:Vector3;
      
      private var rayOrigin:Vector3;
      
      private var rayVector:Vector3;
      
      private var rayIntersection:RayIntersection;
      
      private var userTitlesRender:UserTitlesRender;
      
      public var isRespawned:Boolean = false;
      
      public var flagEndEffect:Boolean = false;
	  
	  public var iit:Boolean = false;
	  
	  public var iit1:TankData;
      
      public function TankModel()
      {
         this.tankPartsRegistry = new TankPartsRegistry();
         this.tankDataById = new Dictionary();
         this._pos3d = new Vector3d(0,0,0);
         this._orient3d = new Vector3d(0,0,0);
         this._linVel3d = new Vector3d(0,0,0);
         this._angVel3d = new Vector3d(0,0,0);
         this.point = new Vector3();
         this.rayOrigin = new Vector3();
         this.rayVector = new Vector3();
         this.rayIntersection = new RayIntersection();
         this.userTitlesRender = new DefaultUserTitlesRender();
         super();
         _interfaces.push(IModel,ITankModelBase,IPanelListener,IObjectLoadListener,ITank,IChatListener);
         Main.osgi.registerService(ITank, this);
		 CORRECTION_INTERVAL += Math.random() * 300;
      }
      
      public static function isFiniteVector3d(param1:Vector3d) : Boolean
      {
         return param1 != null && isFinite(param1.x) && isFinite(param1.y) && isFinite(param1.z);
      }
      
      public function lockControls(lock:Boolean) : void
      {
         this.controlsLocked = lock;
      }
      
      public function bugReportOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function bugReportClosed() : void
      {
         this.updateUILock(-1);
      }
      
      public function settingsOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function settingsCanceled() : void
      {
         this.updateUILock(-1);
      }
      
      public function settingsAccepted() : void
      {
         this.updateUILock(-1);
         if(this.localUserData != null)
         {
            this.setBackTurnMode();
         }
      }
      
      public function connect() : void
      {
      }
      
      public function disconnect() : void
      {
         if(this.localUserData != null)
         {
            this._userControlsEnabled = false;
            this.correctionEnabled = false;
            this.localUserData.weapon.ownerDisabled(this.localUserData.user);
         }
      }
      
      public function activate() : void
      {
         var bfData:BattlefieldData = null;
         if(this.battlefield != null)
         {
            bfData = this.battlefield.getBattlefieldData();
            if(bfData != null)
            {
               Main.stage.focus = bfData.viewport;
            }
         }
      }
      
      public function deactivate() : void
      {
         if(this.localUserData != null && this.localUserData.tank != null)
         {
            this.localUserData.weapon.stop();
            this.applyControlState(this.localUserData,this.controlBits = 0);
         }
      }
      
      public function focusIn(focusedObject:Object) : void
      {
      }
      
      public function focusOut(exfocusedObject:Object) : void
      {
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
         var dumpService:IDumpService = null;
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null)
         {
            return;
         }
         this.battlefield.removeTank(tankData);
         if(tankData.tank != null)
         {
            tankData.weapon.ownerUnloaded(clientObject);
            tankData.tank.skin.dispose();
         }
         if(tankData == this.localUserData)
         {
            TankData.localTankData = null;
            this.localUserData = null;
            this.userTitlesRender.setLocalData(null);
            this.battlefield.setLocalUser(null);
            Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
            Main.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
            this.resume();
            ILoaderWindowService(Main.osgi.getService(ILoaderWindowService)).unlockLoaderWindow();
         }
         this.tankDispatcher.dispatchEvent(TankEvent.UNLOADED,tankData);
         delete this.tankDataById[clientObject.id];
         this.numTanks--;
         if(this.numTanks == 0)
         {
            dumpService = IDumpService(Main.osgi.getService(IDumpService));
            if(dumpService != null)
            {
               dumpService.unregisterDumper(this.dumperName);
            }
         }
      }
      
      public function initClientObject(id:String, name:String) : ClientObject
      {
         var clientClass:ClientClass = new ClientClass(id,null,name);
         return new ClientObject(id,clientClass,name,null);
      }
      
      public function initObject(clientObject:ClientObject, battleId:String, mass:Number, power:Number, soundScheme:TankSoundScheme, tankParts:TankParts, tankResources:TankResources, impactForce:Number, kickback:Number, turretRotationAcceleration:Number, turretRotationSpeed:Number, nickname:String = null, rank:int = 0, turretId:String = null) : void
      {
         var errorMessage:String = null;
         var dumpService:IDumpService = null;
         if(this.modelService == null)
         {
            this.initModel();
         }
         var objectsRegister:ObjectRegister = clientObject.register;
         var battlefieldObject:ClientObject = Game.getInstance.classObject;
         if(battlefieldObject == null)
         {
            errorMessage = "TankModel::initObject() battle object not found";
            Logger.log(LogLevel.LOG_ERROR,errorMessage);
            throw new Error(errorMessage);
         }
         var tankData:TankData = new TankData();
		 iit1 = tankData;
         tankData.logEvent("Loaded");
         tankData.battlefield = battlefieldObject;
         tankData.user = clientObject;
         tankData.userName = nickname == null?PanelModel(Main.osgi.getService(IPanel)).userName:nickname;
         tankData.userRank = rank;
         tankData.mass = mass <= 0?Number(DEFAULT_TANK_MASS):Number(mass);
         tankData.power = power <= 0?Number(DEFAULT_TANK_POWER):Number(power);
         tankData.hull = this.initClientObject(nickname + "_hull",nickname + "_hull");
         tankData.turret = WeaponsManager.getObjectFor(turretId);
         tankData.weapon = WeaponsManager.getWeapon(clientObject,tankData.turret,impactForce,kickback,turretRotationAcceleration,turretRotationSpeed);
         this.initTankColoring(objectsRegister,tankData,tankParts);
         tankData.deadColoring = new BitmapData(100,100);
         tankData.sounds = this.createTankSounds(soundScheme);
         clientObject.putParams(TankModel,tankData);
         this.tankDataById[clientObject.id] = tankData;
         this.numTanks++;
         if(this.numTanks == 1)
         {
            dumpService = IDumpService(Main.osgi.getService(IDumpService));
            if(dumpService != null)
            {
               dumpService.registerDumper(this);
            }
         }
         this.battlefield = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.userTitlesRender = (Main.osgi.getService(IBattleField) as BattlefieldModel).spectatorMode?new SpectatorUserTitlesRender():new DefaultUserTitlesRender();
         this.userTitlesRender.setBattlefield(this.battlefield);
         TankExplosionModel(Main.osgi.getService(ITankExplosionModel)).initObject(tankData.hull, "explosionTexture", "shockWaveTexture", "smokeTexture");
		 TankKritModel(Main.osgi.getService(ITankKritModel)).initObject(tankData.hull, "explosionTexture", "shockWaveTexture", "smokeTexture");
      }
      
      public function initTank(clientObject:ClientObject, clientTank:ClientTank, parts:TankParts, notificationOfEnter:Boolean = true, tpd:TankPhysicsData = null) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         tankData.local = clientTank.self;
         var tank:Tank = this.createTank(tankData,parts);
         tankData.tank = tank;
		 tankData.tank.tpd = tpd;
         tankData.sounds.tank = tank;
         tankData.teamType = clientTank.teamType;
         tankData.incarnation = clientTank.incarnationId;
         tankData.user = clientObject;
         this.setNormalTextures(tankData);
         this.setTankSpec(tankData,clientTank.tankSpecification,true);
         var tankWeapon:IWeapon = tankData.weapon;
         tankData.tank.turretTurnAcceleration = 2;
         tankData.tank.maxTurretTurnSpeed = 2;
         tankWeapon.ownerLoaded(clientObject);
         if(clientTank.self)
         {
            this.localUserData = tankData;
            this.userTitlesRender.setLocalData(this.localUserData);
            this.initLocalTank(tankData);
         }
         tankData.logEvent("Initialized");
         if(clientTank.tankState != null)
         {
            this.putTankIntoBattle(tankData,clientTank);
         }
         this.tankDispatcher.dispatchEvent(TankEvent.LOADED,tankData);
         this.battlefield.addTank(tankData);
         this.suicideTime = int.MAX_VALUE;
         if(notificationOfEnter)
         {
            StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).userConnect(clientObject,tankData.userName,tankData.teamType,tankData.userName,tankData.userRank);
         }
         if(!tankData.local)
         {
            this.configureRemoteTankTitle(tankData);
         }
         if(tankData.local)
         {
            tankData.tank.setHullTransformUpdater(new LocalHullTransformUpdater(tankData.tank));
         }
         else
         {
            tankData.tank.setHullTransformUpdater(new RemoteHullTransformUpdater(tankData.tank));
         }
      }
      
      public function activateTank(clientObject:ClientObject) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"TankModel: Incorrect call of activateTank() clientObject=" + clientObject + ", tankData=" + tankData);
            return;
         }
         tankData.logEvent("Activated");
         this.setNormalState(tankData);
         if(tankData.local)
         {
            this.updateUILock(0);
         }
         this.tankDispatcher.dispatchEvent(TankEvent.ACTIVATED,tankData);
      }
      
      public function setTemperature(clientObject:ClientObject, value:Number) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"TankModel: Incorrect call of setTemperature() clientObject=" + clientObject + ", tankData=" + tankData);
            return;
         }
         this.setTankTemperature(tankData.tank,value);
      }
      
      public function getTankData(clientObject:ClientObject) : TankData
      {
         if(clientObject == null)
         {
            return null;
         }
         return TankData(clientObject.getParams(TankModel));
      }
      
      public function move(clientObject:ClientObject, pos:Vector3d, orientation:Vector3d, linearVelocity:Vector3d, angleVelocity:Vector3d, turretAngle:Number, control:int, isControl:Boolean) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null || tankData == this.localUserData)
         {
            return;
         }
         var tank:Tank = tankData.tank;
         this.interpolateVector3d(0.5,tank.state.pos,pos,pos);
         this.interpolateVector3d(0.5,tank.state.velocity,linearVelocity,linearVelocity);
         this.interpolateVector3d(0.5,tank.state.rotation,angleVelocity,angleVelocity);
         this.interpolateOrientation(0.5,tank.state.orientation,orientation,orientation);
         this.setTankState(tankData,pos,orientation,linearVelocity,angleVelocity,turretAngle,control,isControl);
      }
      
      private function interpolateVector3d(smooth:Number, param2:Vector3, param3:Vector3d, param4:Vector3d) : void
      {
         param4.x = param2.x + (param3.x - param2.x) * smooth;
         param4.y = param2.y + (param3.y - param2.y) * smooth;
         param4.z = param2.z + (param3.z - param2.z) * smooth;
      }
      
      private function interpolateOrientation(param1:Number, param2:Quaternion, param3:Vector3d, param4:Vector3d) : void
      {
         this._orientation.setFromEulerAnglesXYZ(param3.x,param3.y,param3.z);
         this._orientation2.slerp(param2,this._orientation,param1);
         this._orientation2.getEulerAngles(this._eulerAngles);
         param4.x = this._eulerAngles.x;
         param4.y = this._eulerAngles.y;
         param4.z = this._eulerAngles.z;
      }
      
      public function prepareToSpawn(clientObject:ClientObject, pos:Vector3d, orientation:Vector3d) : void
      {
         var pivotPosition:Vector3 = null;
         var targetDirection:Vector3 = null;
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"TankModel: Incorrect call of prepareToSpawn() clientObject=" + clientObject + ", tankData=" + tankData);
            return;
         }
         tankData.logEvent("Prepare to spawn");
         tankData.deadTime = 0;
         this.battlefield.removeTankFromField(tankData);
         if(!tankData.local)
         {
            tankData.tank.lockTransformUpdate();
         }
         if(this.localUserData != null && clientObject == this.localUserData.user)
         {
            pivotPosition = new Vector3(pos.x,pos.y,pos.z + 200);
            targetDirection = new Vector3(-Math.sin(orientation.z),Math.cos(orientation.z),0);
            //if(this.firstSpawn)
            //{
               //this.battlefield.initFollowCamera(pivotPosition,targetDirection);
            //}
            //else
            //{
               this.battlefield.initFlyCamera(pivotPosition,targetDirection);
            //}
            this.correctionEnabled = false;
         }
      }
      
      public function spawn(clientObject:ClientObject, spec:TankSpecification, teamType:BattleTeamType, pos:Vector3d, orientation:Vector3d, health:int, incarnationId:int) : void
      {
         var changeTeamAlert:ChangeTeamAlert = null;
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"TankModel: Incorrect call of spawn() clientObject=" + clientObject + ", tankData=" + tankData);
            return;
         }
         tankData.logEvent("Spawn begin");
         var tank:Tank = tankData.tank;
         if(tankData.local && teamType != BattleTeamType.NONE && teamType != tankData.teamType || tankData.local && this.firstSpawn && teamType != BattleTeamType.NONE)
         {
            changeTeamAlert = new ChangeTeamAlert(CHANGE_TEAM_ALERT_DELAY,teamType == BattleTeamType.RED?int(ChangeTeamAlert.RED):int(ChangeTeamAlert.BLUE));
            changeTeamAlert.x = Main.stage.stageWidth - changeTeamAlert.width >> 1;
            changeTeamAlert.y = Main.stage.stageHeight - changeTeamAlert.height >> 1;
            Main.stage.addChild(changeTeamAlert);
         }
         tankData.deadTime = 0;
         tankData.enabled = true;
         tankData.incarnation = incarnationId;
         this.setTankHealth(tankData,health);
         tankData.teamType = teamType;
         tankData.tank.title.setTeamType(teamType);
         this.setTankSpec(tankData,spec,true);
         tank.skin.resetColorTransform();
         pos.z = pos.z + 200;
         tankData.tank.clearAccumulators();
         var zeroVector3d:Vector3d = new Vector3d(0,0,0);
         this.setTankState(tankData,pos,orientation,zeroVector3d,zeroVector3d,0,0,true);
         this.setNormalTextures(tankData);
         tankData.sounds.setIdleMode();
         this.setTransparentState(tankData);
         if(tankData.local)
         {
            tankData = this.localUserData;
            this.idleTimerEnabled = true;
            this.activationTime = getTimer() + this.battlefield.getRespawnInvulnerabilityPeriod();
            this.suicideTime = int.MAX_VALUE;
            this.awaitingKillCommand = false;
            tankData.tank.title.show();
            tankData.weapon.reset();
            this.updateUILock(0);
            this.configureOtherTankTitles();
            this.firstSpawn = false;
         }
         else
         {
            this.configureRemoteTankTitle(tankData);
         }
         this.controlsLocked = false;
         tankData.logEvent("Spawned");
         this.tankDispatcher.dispatchEvent(TankEvent.SPAWNED,tankData);
         if(!tankData.local)
         {
            tankData.tank.unlockTransformUpdate();
         }
      }
      
      public function kill(clientObject:ClientObject, reason:DeathReason, killerTankId:String) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            return;
         }
         this.setControlState(tankData,0);
         tankData.logEvent("Killed");
         tankData.enabled = false;
         tankData.health = 0;
         tankData.deadTime = RESPAWN_DELAY;
         tankData.weapon.ownerDisabled(clientObject);
         tankData.tank.title.hideIndicators();
         if(tankData.local)
         {
            this._userControlsEnabled = false;
            this.awaitingKillCommand = false;
            this.readyToSpawnCommandSent = false;
            this.battlefield.hideSuicideIndicator();
            this.suicideTime = int.MAX_VALUE;
            tankData.tank.collisionGroup = tankData.tank.collisionGroup & ~CollisionGroup.BONUS_WITH_TANK;
         }
         this.createDeathEffects(tankData);
         this.showUserDeathMessage(clientObject,reason,killerTankId);
         this.tankDispatcher.dispatchEvent(TankEvent.KILLED,tankData);
         this.stop(tankData);
         this.battlefield.logicUnits.addLogicUnit(new BeforeKillTankTask(getTimer() + 3000,tankData.tank));
      }
	  
	  public function kill1(clientObject:ClientObject, reason:DeathReason, killerTankId:String) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            return;
         }
         this.setControlState(tankData,0);
         tankData.logEvent("Killed");
         tankData.enabled = false;
         tankData.health = 0;
         tankData.deadTime = RESPAWN_DELAY;
         tankData.weapon.ownerDisabled(clientObject);
         tankData.tank.title.hideIndicators();
         if(tankData.local)
         {
            this._userControlsEnabled = false;
            this.awaitingKillCommand = false;
            this.readyToSpawnCommandSent = false;
            this.battlefield.hideSuicideIndicator();
            this.suicideTime = int.MAX_VALUE;
            tankData.tank.collisionGroup = tankData.tank.collisionGroup & ~CollisionGroup.BONUS_WITH_TANK;
         }
         this.createDeathEffects(tankData);
         this.tankDispatcher.dispatchEvent(TankEvent.KILLED,tankData);
         this.stop(tankData);
      }
	  
	  public function krit(clientObject:ClientObject) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            return;
         }
         this.battlefield.addGraphicEffect(new TankKritGraphicEffect(tankData));
      }
      
      public function changeHealth(clientObject:ClientObject, newHealth:int) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"TankModel: Incorrect call of changeHealth() clientObject=" + clientObject + ", tankData=" + tankData);
            return;
         }
         this.setTankHealth(tankData,newHealth);
      }
      
      public function changeSpecification(clientObject:ClientObject, tankSpecification:TankSpecification, immediate:Boolean) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"TankModel: Incorrect call of changeSpecification() clientObject=" + clientObject + ", tankData=" + tankData);
            return;
         }
         this.setTankSpec(tankData,tankSpecification,immediate);
      }
      
      public function update(tankData:TankData, time:int, deltaMillis:int, deltaSec:Number, interpolationValue:Number, cameraPos:Vector3D) : void
      {
         var tank:Tank = tankData.tank;
         this.rotateTurret(tankData,deltaSec);
         this.userTitlesRender.updateTitle(tankData,cameraPos);
         tank.skin.updateColorTransform(deltaSec);
         tank.updateSkin(interpolationValue);
         if(tankData.deadTime > 0)
         {
            tankData.deadTime = tankData.deadTime - deltaMillis;
            if(tankData.deadTime <= 0)
            {
               tankData.deadTime = 0;
               this.battlefield.removeTankFromField(tankData);
            }
         }
         if(tankData.local)
         {
            this.updateLocalTank(time,deltaMillis);
         }
      }
      
      public function disableUserControls(stopNotification:Boolean) : void
      {
         if(this.localUserData == null)
         {
            return;
         }
         this._userControlsEnabled = false;
         this.controlBits = 0;
         this.applyControlState(this.localUserData,0);
         this.localUserData.weapon.disable();
         if(stopNotification)
         {
            this.correctionEnabled = false;
         }
      }
      
      public function enableUserControls() : void
      {
         if(this.localUserData == null || !this.localUserData.enabled)
         {
            return;
         }
         this._userControlsEnabled = true;
         this.correctionEnabled = true;
         this.applyControlState(this.localUserData,this.controlBits);
         if(this.localUserData.spawnState == TankSpawnState.ACTIVE)
         {
            this.localUserData.weapon.enable();
         }
      }
      
      public function stop(tankData:TankData) : void
      {
         this.setControlState(tankData,0);
         tankData.weapon.ownerDisabled(tankData.user);
      }
      
      public function resetIdleTimer(disable:Boolean) : void
      {
         if(disable)
         {
            this.idleTimerEnabled = false;
         }
         this.idleTime = 0;
      }
      
      public function get userControlsEnabled() : Boolean
      {
         return this._userControlsEnabled;
      }
      
      public function userStatChanged(userId:String, userName:String, userRank:int) : void
      {
         var title:UserTitle = null;
         var tankData:TankData = this.tankDataById[userId];
         if(tankData != null)
         {
            tankData.userName = userName;
            tankData.userRank = userRank;
            if(tankData.tank != null)
            {
               title = tankData.tank.title;
               title.setLabelText(userName);
               title.setRank(userRank);
            }
         }
      }
      
      public function readLocalTankPosition(pos:Vector3D) : void
      {
         if(this.localUserData == null)
         {
            return;
         }
         var v:Vector3 = this.localUserData.tank.state.pos;
         pos.x = v.x;
         pos.y = v.y;
         pos.z = v.z;
      }
      
      public function effectStarted(clientObject:ClientObject, effectId:int, duration:int) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"TankModel::effectStarted(): Incorrect call clientObject=" + clientObject + ", tankData=" + tankData + ", effectId=" + effectId);
            return;
         }
         tankData.tank.title.showIndicator(effectId,duration);
      }
      
      public function effectStopped(clientObject:ClientObject, effectId:int) : void
      {
         var tankData:TankData = this.getTankData(clientObject);
         if(tankData == null || tankData.tank == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"TankModel::effectStopped(): Incorrect call clientObject=" + clientObject + ", tankData=" + tankData + ", effectId=" + effectId);
            return;
         }
         tankData.tank.title.hideIndicator(effectId);
      }
      
      public function get dumperName() : String
      {
         return "tank";
      }
      
      public function dump(params:Vector.<String>) : String
      {
         return "=== TankModel dump ===\n" + "userControlsEnabled=" + this._userControlsEnabled + "\n" + "correctionEnabled=" + this.correctionEnabled + "\n" + "nextCorrectionTime=" + this.nextCorrectionTime + "\n" + "reverseBackTurn=" + this.reverseBackTurn + "\n" + "ctrlBits=" + this.controlBits + "\n" + "uiControlLockCount=" + this.uiControlLockCount + "\n" + "suicideTime=" + this.suicideTime + "\n" + "awaitingKillCommand=" + this.awaitingKillCommand + "\n" + "firstSpawn=" + this.firstSpawn + "\n" + "activationTime=" + this.activationTime + "\n" + "idleTime=" + this.idleTime + "\n" + "idleKickPeriod=" + this.idleKickPeriod + "\n" + "=== Eend of TankModel dump ===";
      }
      
      public function chatOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function chatClosed() : void
      {
         this.updateUILock(-1);
      }
      
      public function setMuteSound(mute:Boolean) : void
      {
      }
      
      private function showUserDeathMessage(clientObject:ClientObject, reason:DeathReason, killerTankId:String) : void
      {
         switch(reason)
         {
            case DeathReason.SUICIDE:
               this.gui.logUserAction(clientObject.id,this.suicideMessage);
               break;
            case DeathReason.KILLED_IN_BATTLE:
               if(killerTankId == clientObject.id)
               {
                  this.gui.logUserAction(clientObject.id,this.suicideMessage);
               }
               else
               {
                  this.gui.logUserAction(killerTankId,this.killMessage,clientObject.id);
               }
         }
      }
      
      private function initModel() : void
      {
         this.modelService = IModelService(Main.osgi.getService(IModelService));
         this.tankDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
         this.battlefield = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.userTitlesRender = (Main.osgi.getService(IBattleField) as BattlefieldModel).spectatorMode?new SpectatorUserTitlesRender():new DefaultUserTitlesRender();
         this.userTitlesRender.setBattlefield(this.battlefield);
         this.gui = Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI;
         this.effectsModel = IEffectsVisualizationModel(this.modelService.getModelsByInterface(IEffectsVisualizationModel)[0]);
         this.inventoryModel = IInventory(this.modelService.getModelsByInterface(IInventory)[0]);
         var locale:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.suicideMessage = locale.getText(TextConst.BATTLE_PLAYER_SUICIDED);
         this.killMessage = locale.getText(TextConst.BATTLE_PLAYER_KILLED);
         this.initKeyTable();
         var networkService:INetworkService = INetworkService(Main.osgi.getService(INetworkService));
         if(networkService != null)
         {
            networkService.addEventListener(this);
         }
         var focusService:IFocusService = IFocusService(Main.osgi.getService(IFocusService));
         if(focusService != null)
         {
            focusService.addFocusListener(this);
         }
      }
      
      private function putTankIntoBattle(tankData:TankData, clientTank:ClientTank) : void
      {
         var tankState:TankState = clientTank.tankState;
         tankData.enabled = true;
         this.setTankHealth(tankData,clientTank.health);
         if(clientTank.health <= 0)
         {
            this.setDeadTextures(tankData);
            tankData.tank.title.hide();
         }
         else if(TankData.localTankData != null && !clientTank.self)
         {
            this.configureRemoteTankTitle(tankData);
         }
         var zeroVector3d:Vector3d = new Vector3d(0,0,0);
         this.setTankState(tankData,tankState.position,tankState.orientation,zeroVector3d,zeroVector3d,tankState.turretAngle,tankState.control,true);
         switch(clientTank.spawnState)
         {
            case TankSpawnState.NEWCOME:
               this.setTransparentState(tankData);
               break;
            case TankSpawnState.ACTIVE:
               this.setNormalState(tankData);
         }
      }
      
      private function initLocalTank(tankData:TankData) : void
      {
         TankData.localTankData = tankData;
         this.idleTime = 0;
         this.paused = false;
         Main.stage.focus = null;
         this.localUserData = tankData;
         this.userTitlesRender.setLocalData(this.localUserData);
         this.battlefield.setLocalUser(tankData.user);
         this.firstSpawn = true;
         this.correctionEnabled = false;
         this._userControlsEnabled = false;
         this.idleTimerEnabled = false;
         this.idleKickPeriod = this.battlefield.getBattlefieldData().idleKickPeriod;
         this.setBackTurnMode();
         Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         Main.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
         this.readyToSpawnCommandSent = true;
         this.battlefield.setCameraTarget(tankData.tank);
         var title:UserTitle = this.localUserData.tank.title;
         title.setRank(tankData.userRank);
         title.setLabelText(tankData.userName);
         tankData.health = 10000;
         title.setHealth(tankData.health);
         title.setConfiguration(UserTitle.BIT_HEALTH | UserTitle.BIT_WEAPON | UserTitle.BIT_EFFECTS);
         title.setWeaponStatus(100);
         title.show();
      }
      
      private function isSameTeam(teamType1:BattleTeamType, teamType2:BattleTeamType) : Boolean
      {
         return teamType1 != BattleTeamType.NONE && teamType1 == teamType2;
      }
      
      private function createDeathEffects(tankData:TankData) : void
      {
         this.battlefield.addGraphicEffect(new TankDeathGraphicEffect(tankData));
      }
      
      private function rotateTurret(tankData:TankData, deltaSec:Number) : void
      {
         var tank:Tank = tankData.tank;
         var turretRotationDir:int = ((tankData.ctrlBits & TURRET_LEFT) >> 4) - ((tankData.ctrlBits & TURRET_RIGHT) >> 5);
         if(turretRotationDir != 0)
         {
            if((tankData.ctrlBits & CENTER_TURRET) != 0)
            {
               tankData.ctrlBits = tankData.ctrlBits & ~CENTER_TURRET;
               if(tankData.local)
               {
                  this.controlBits = this.controlBits & ~CENTER_TURRET;
               }
               if(tank.turretDirSign == turretRotationDir)
               {
                  tank.stopTurret();
                  tankData.sounds.playTurretSound(false);
               }
            }
            tank.rotateTurret(turretRotationDir * deltaSec,false);
         }
         else if((tankData.ctrlBits & CENTER_TURRET) != 0)
         {
            if(tank.rotateTurret(-tank.turretDirSign * deltaSec,true))
            {
               tankData.ctrlBits = tankData.ctrlBits & ~CENTER_TURRET;
               tank.stopTurret();
            }
         }
         else
         {
            tank.stopTurret();
         }
         tankData.sounds.playTurretSound(tankData.tank.turretTurnSpeed != 0);
      }
      
      private function updateTitle(tankData:TankData, cameraPos:Vector3D) : void
      {
         var pos:Vector3 = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var distance:Number = NaN;
         var tank:Tank = tankData.tank;
         if(tankData.health <= 0)
         {
            tankData.tank.title.hide();
         }
         else if(!tankData.local && this.localUserData != null)
         {
            if(!this.isSameTeam(this.localUserData.teamType,tankData.teamType))
            {
               pos = tank.state.pos;
               dx = pos.x - cameraPos.x;
               dy = pos.y - cameraPos.y;
               dz = pos.z - cameraPos.z;
               distance = Math.sqrt(dx * dx + dy * dy + dz * dz);
               if(distance >= this.titleHideDistance || this.isTankInvisible(tankData,cameraPos))
               {
                  tank.title.hide();
               }
               else if(distance < this.titleShowDistance)
               {
                  tank.title.show();
               }
            }
            else
            {
               tank.title.show();
            }
         }
      }
      
      private function isTankInvisible(tankData:TankData, cameraPos:Vector3D) : Boolean
      {
         var collisionDetector:TanksCollisionDetector = this.battlefield.getBattlefieldData().collisionDetector;
         var points:Vector.<Vector3> = tankData.tank.visibilityPoints;
         var len:int = points.length;
         for(var i:int = 0; i < len; i++)
         {
            this.point.vCopy(points[i]);
            if(this.isTankPointVisible(this.point,tankData,cameraPos,collisionDetector))
            {
               return false;
            }
         }
         return true;
      }
      
      private function isTankPointVisible(point:Vector3, tankData:TankData, cameraPos:Vector3D, collisionDetector:TanksCollisionDetector) : Boolean
      {
         point.vTransformBy3(tankData.tank.baseMatrix);
         point.vAdd(tankData.tank.state.pos);
         this.rayOrigin.copyFromVector3D(cameraPos);
         this.rayVector.vDiff(point,this.rayOrigin);
         return !collisionDetector.intersectRayWithStatic(this.rayOrigin,this.rayVector,CollisionGroup.STATIC,1,null,this.rayIntersection);
      }
      
      public function testRespawn() : void
      {
         this.isRespawned = true;
      }
      
      public function activateTankCommand(user:ClientObject) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;activate_tank");
      }
      
      private function updateLocalTank(time:int, timeDelta:int) : void
      {
         var pos:Vector3 = null;
         var weaponStatus:Number = NaN;
         if(this.localUserData.enabled)
         {
            pos = this.localUserData.tank.state.pos;
            if(time >= this.suicideTime || pos.z < MIN_ALLOWED_Z)
            {
               this.sendSuicideCommand(pos);
            }
            weaponStatus = this.localUserData.weapon.update(time,timeDelta);
            this.localUserData.tank.title.setWeaponStatus(100 * weaponStatus);
            if(this.localUserData.spawnState != TankSpawnState.ACTIVE && time >= this.activationTime && this.localUserData.tankCollisionCount == 0)
            {
               this.activationTime = int.MAX_VALUE;
               this.activateTankCommand(this.localUserData.user);
            }
         }
         if(this.localUserData.deadTime == 0 && !this.paused && !this.readyToSpawnCommandSent)
         {
            this.readyToSpawnCommandSent = true;
         }
         if(this.correctionEnabled && time >= this.nextCorrectionTime)
         {
            this.localUserData.tank.getPhysicsState(this._pos3d,this._orient3d,this._linVel3d,this._angVel3d);
            this.moveCommand(this.localUserData.user,time,this._pos3d,this._orient3d,this._linVel3d,this._angVel3d,this.localUserData.tank.turretDir,this.localUserData.ctrlBits);
            this.nextCorrectionTime = this.nextCorrectionTime + CORRECTION_INTERVAL;
         }
         if(this.paused || this.idleTimerEnabled)
         {
            this.checkIdleKick(timeDelta);
         }
         if(this.paused)
         {
            this.gui.setPauseTimeout((this.idleKickPeriod - this.idleTime - 4000) / 1000);
         }
      }
      
      private function moveCommand(obj:ClientObject, time:int, pos:Vector3d, orientation:Vector3d, linVel:Vector3d, angVel:Vector3d, turretDir:Number, controlBits:int) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;move;" + (pos.x + "@" + pos.y + "@" + pos.z) + "@" + (orientation.x + "@" + orientation.y + "@" + orientation.z) + "@" + (linVel.x + "@" + linVel.y + "@" + linVel.z) + "@" + (angVel.x + "@" + angVel.y + "@" + angVel.z) + ";" + turretDir + ";" + controlBits);
      }
      
      private function sendSuicideCommand(pos:Vector3) : void
      {
         if(!this.awaitingKillCommand)
         {
            this.suicideTime = int.MAX_VALUE;
            this.awaitingKillCommand = true;
            this.suicideCommand(this.localUserData.user,DeathReason.SUICIDE,new Vector3d(pos.x,pos.y,pos.z));
         }
      }
      
      private function suicideCommand(user:ClientObject, reason:DeathReason, pos:Vector3d) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;suicide");
      }
      
      private function checkIdleKick(deltaMillis:int) : void
      {
         if(this.idleTime >= this.idleKickPeriod)
         {
            this.idleTimerEnabled = false;
         }
         else
         {
            this.idleTime = this.idleTime + deltaMillis;
            this.battlefield.printDebugValue("Idle time",Number(this.idleTime / 1000).toFixed(2));
            this.battlefield.printDebugValue("Time to idle kick",Number((this.idleKickPeriod - this.idleTime) / 1000).toFixed(2));
         }
      }
      
      private function setTransparentState(tankData:TankData) : void
      {
         tankData.spawnState = TankSpawnState.NEWCOME;
         tankData.tank.collisionGroup = CollisionGroup.TANK;
         tankData.tank.tracksCollisionGroup = CollisionGroup.ACTIVE_TRACK;
         tankData.tank.skin.hullMesh.alpha = 0.5;
         tankData.tank.skin.turretMesh.alpha = 0.5;
         tankData.tank.postCollisionPredicate = IBodyCollisionPredicate(this.battlefield);
      }
      
      private function setNormalState(tankData:TankData) : void
      {
         tankData.spawnState = TankSpawnState.ACTIVE;
         tankData.tank.collisionGroup = CollisionGroup.TANK | CollisionGroup.ACTIVE_TRACK | CollisionGroup.WEAPON;
         if(tankData == TankData.localTankData)
         {
            tankData.tank.collisionGroup = tankData.tank.collisionGroup | CollisionGroup.BONUS_WITH_TANK;
         }
         tankData.tank.tracksCollisionGroup = CollisionGroup.ACTIVE_TRACK;
         tankData.tank.skin.hullMesh.alpha = 1;
         tankData.tank.skin.turretMesh.alpha = 1;
         tankData.tank.postCollisionPredicate = null;
      }
      
      private function initTankColoring(objectsRegister:ObjectRegister, tankData:TankData, tankParts:TankParts) : void
      {
         try
         {
            tankData.coloring = ResourceUtil.getResource(ResourceType.IMAGE,tankParts.coloringObjectId).bitmapData == null?new StubBitmapData(16711935):ResourceUtil.getResource(ResourceType.IMAGE,tankParts.coloringObjectId).bitmapData;
         }
         catch(e:Error)
         {
            tankData.coloring = new StubBitmapData(16711935);
         }
      }
      
      public function onKey(e:KeyboardEvent) : void
      {
         var k:* = undefined;
         this.idleTime = 0;
         var keyDown:Boolean = e.type == "keyDown";
         if(keyDown)
         {
				if(e.keyCode != ALT_KEY_CODE && !e.altKey)
				{
				   if(this.paused)
				   {
					  this.resume();
				   }
				   else if(this.uiControlLockCount == 0 && (e.keyCode == PAUSE_KEY_CODE_1 || e.keyCode == PAUSE_KEY_CODE_2))
				   {
					  this.pause();
				   }
				}
				k = this.keyTableDown[e.keyCode];
			//}
         }
         else
         {
            k = this.keyTableUp[e.keyCode];
         }
         if(k != undefined && !this.controlsLocked)
         {
            if(keyDown)
            {
               this.controlBits = this.controlBits | int(k);
            }
            else
            {
               this.controlBits = this.controlBits & ~int(k);
            }
            if(this.reverseBackTurn)
            {
               this.controlBits = this.controlBits | REVERSE_TURN_BIT;
            }
            else
            {
               this.controlBits = this.controlBits & ~REVERSE_TURN_BIT;
            }
            if(this._userControlsEnabled)
            {
               this.applyControlState(this.localUserData,this.controlBits);
            }
         }
         else if(keyDown)
         {
            this.handleKeyDown(e);
         }
      }
      
      private function handleKeyDown(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case SUICIDE_KEY_CODE:
               if(e.ctrlKey)
               {
                  this.startSuicideCountdown();
               }
               break;
            case Keyboard.DELETE:
               this.startSuicideCountdown();
         }
      }
      
      private function startSuicideCountdown() : void
      {
         if(this._userControlsEnabled && !this.awaitingKillCommand && this.suicideTime == int.MAX_VALUE)
         {
            this.suicideTime = getTimer() + SUICIDE_DELAY;
            this.battlefield.showSuicideIndicator(SUICIDE_DELAY);
         }
      }
      
      private function initKeyTable() : void
      {
         var keyCode:int = 0;
         this.keyTableDown = new Dictionary();
         this.keyTableUp = new Dictionary();
         var keyBindings:Vector.<int> = Vector.<int>([Keyboard.UP, FORWARD, 87, FORWARD, Keyboard.DOWN, BACK, 83, BACK, Keyboard.LEFT, LEFT, 65, LEFT, Keyboard.RIGHT, RIGHT, 68, RIGHT, 90, TURRET_LEFT, 188, TURRET_LEFT, 88, TURRET_RIGHT, 190, TURRET_RIGHT]);
		 var len:int = keyBindings.length;
         for (var i:int = 0; i < len; i = i + 2)
         {
            keyCode = keyBindings[i];
            this.keyTableDown[keyCode] = this.keyTableUp[keyCode] = keyBindings[int(i + 1)];
         }
         this.keyTableDown[67] = CENTER_TURRET;
         this.keyTableDown[191] = CENTER_TURRET;
      }
      
      private function setTankHealth(tankData:TankData, health:int) : void
      {
         tankData.health = health;
         tankData.tank.title.setHealth(health);
         var maxHealth:int = 10000;
         if(tankData.local)
         {
            this.inventoryModel.lockItem(InventoryItemType.FISRT_AID,InventoryLock.FORCED,health >= maxHealth);
         }
      }
      
      private function setTankSpec(tankData:TankData, spec:TankSpecification, immediate:Boolean) : void
      {
         tankData.tank.setMaxSpeed(spec.speed*100,immediate);
         tankData.tank.setMaxTurnSpeed(spec.turnSpeed,immediate);
         tankData.tank.setMaxTurretTurnSpeed(spec.turretRotationSpeed,immediate);
      }
      
      private function setTankState(tankData:TankData, pos:Vector3d, orient:Vector3d, linVel:Vector3d, angVel:Vector3d, turretDir:Number, control:int, isControl:Boolean) : void
      {
         if(pos != null && orient != null && linVel != null && angVel != null)
         {
            tankData.tank.setPhysicsState(pos,orient,linVel,angVel);
            this.setControlState(tankData,control);
            tankData.tank.turretDir = turretDir;
         }
      }
      
      private function createTank(tankData:TankData, cl:TankParts) : Tank
      {
         var hullDescriptor:TankSkinHull = new TankSkinHull(ResourceUtil.getResource(ResourceType.MODEL,cl.hullObjectId).mesh,this.v3dtov3(ResourceUtil.getResource(ResourceType.MODEL,cl.hullObjectId).turretMount));
         var obj:* = ResourceUtil.getResource(ResourceType.MODEL,cl.turretObjectId);
         var turretDescriptor:TankSkinTurret = new TankSkinTurret(ResourceUtil.getResource(ResourceType.MODEL,cl.turretObjectId).mesh,this.v3dtov3(ResourceUtil.getResource(ResourceType.MODEL,cl.turretObjectId).flagMount));
         var colormap:ImageResouce = ResourceUtil.getResource(ResourceType.IMAGE,cl.coloringObjectId) as ImageResouce;
         var skin:TankSkin = new TankSkin(hullDescriptor,turretDescriptor,colormap,new BitmapData(512,512),cl.hullObjectId + "_lightmap",cl.hullObjectId + "_details",cl.turretObjectId + "_lightmap",cl.turretObjectId + "_details",null);
         var tank:Tank = new Tank(skin,tankData.mass,1,1,1,1,tankData.local,tankData.local?this.battlefield.getBattlefieldData().viewport.getFrontContainer():this.battlefield.getBattlefieldData().viewport.getMapContainer());
         tank.tankData = tankData;
         return tank;
      }
      
      private function v3dtov3(src:Vector3D) : Vector3
      {
         return new Vector3(src.x,src.y,src.z);
      }
      
      private function setNormalTextures(tankData:TankData) : void
      {
         tankData.tank.skin.setNormalState();
      }
      
      private function setDeadTextures(tankData:TankData) : void
      {
         tankData.tank.skin.setDeadState();
      }
      
      public function applyControlState(tankData:TankData, ctrlBits:int) : void
      {
         var time:int = 0;
         if(tankData.enabled && tankData.ctrlBits != ctrlBits)
         {
			 if(iit)
			 {
				 ctrlBits = 0;
			 }
            this.setControlState(tankData,ctrlBits);
            tankData.tank.getPhysicsState(this._pos3d, this._orient3d, this._linVel3d, this._angVel3d);
            time = getTimer();
            this.moveCommand(this.localUserData.user,time,this._pos3d,this._orient3d,this._linVel3d,this._angVel3d,tankData.tank.turretDir,ctrlBits);
            this.nextCorrectionTime = time + CORRECTION_INTERVAL;
         }
      }
      
      public function setControlState(tankData:TankData, ctrlBits:int) : void
      {
         var k:Number = NaN;
         if(!tankData.enabled)
         {
            return;
         }
		 tankData.ctrlBits = ctrlBits;
		 var throttle:Number = tankData.power;
		 var moveDir:int = int((ctrlBits & FORWARD) != 0) - int((ctrlBits & BACK) != 0);
         //var throttleLeft:Number = moveDir * throttle;
         //var throttleRight:Number = moveDir * throttle;
         var turnDir:Number = int((ctrlBits & LEFT) != 0) - int((ctrlBits & RIGHT) != 0);
         var tank:Tank = tankData.tank;
		 if (moveDir < 0)
		 {
			turnDir = -turnDir;
		 }
         /*if(moveDir == 0)
         {
            tank.setBrakes(false,false);
            k = 0.8;
            throttleLeft = throttleLeft - turnDir * throttle * k;
            throttleRight = throttleRight + turnDir * throttle * k;
         }
         else
         {
            k = 0.4;
            if(moveDir == 1)
            {
               tank.setBrakes(turnDir == 1,turnDir == -1);
               if(turnDir == 1)
               {
                  throttleLeft = throttleLeft - throttle * k;
               }
               if(turnDir == -1)
               {
                  throttleRight = throttleRight - throttle * k;
               }
            }
            else if((ctrlBits & REVERSE_TURN_BIT) == 0)
            {
               tank.setBrakes(turnDir == -1,turnDir == 1);
               if(turnDir == -1)
               {
                  throttleLeft = throttleLeft + throttle * k;
               }
               if(turnDir == 1)
               {
                  throttleRight = throttleRight + throttle * k;
               }
            }
            else
            {
               tank.setBrakes(turnDir == 1,turnDir == -1);
               if(turnDir == 1)
               {
                  throttleLeft = throttleLeft + throttle * k;
               }
               if(turnDir == -1)
               {
                  throttleRight = throttleRight + throttle * k;
               }
            }
         }*/
         tankData.tank.setThrottle(throttle, throttle);//(throttleLeft,throttleRight);
         if(moveDir != 0)
         {
            tankData.sounds.setAccelerationMode();
         }
         else if(turnDir != 0)
         {
            tankData.sounds.setTurningMode();
         }
         else
         {
            tankData.sounds.setIdleMode();
         }
		 tankData.tank.movedir = moveDir;
		 tankData.tank.turndir = -turnDir;
		 tankData.tank.leftTrack.updateControls();
		 tankData.tank.rightTrack.updateControls();
      }
      
      private function updateUILock(lockCountDelta:int) : void
      {
         this.uiControlLockCount = this.uiControlLockCount + lockCountDelta;
         if(this.uiControlLockCount <= 0)
         {
            this.enableUserControls();
         }
         else
         {
            this.disableUserControls(false);
         }
      }
      
      private function setBackTurnMode() : void
      {
         var settings:IBattleSettings = IBattleSettings(Main.osgi.getService(IBattleSettings));
         this.reverseBackTurn = false;
      }
      
      private function createTankSounds(soundScheme:TankSoundScheme) : TankSounds
      {
         var prefix:String = Game.local?"":"resources/";
         var idleSound:Sound = new Sound(new URLRequest(prefix + "engineidle.mp3"));
         if(idleSound == null)
         {
            return null;
         }
         var startMovingSound:Sound = new Sound(new URLRequest(prefix + "startmoving.mp3"));
         if(startMovingSound == null)
         {
            return null;
         }
         var movingSound:Sound = new Sound(new URLRequest(prefix + "move.mp3"));
         if(movingSound == null)
         {
            return null;
         }
         var turretSound:Sound = new Sound(new URLRequest(prefix + "turret.mp3"));
         if(turretSound == null)
         {
            return null;
         }
         return new TankSounds(null,null,idleSound,startMovingSound,movingSound,turretSound);
      }
      
      public function pause() : void
      {
         this.paused = true;
         this.gui.showPauseIndicator(true);
      }
      
      private function resume() : void
      {
         this.paused = false;
         this.gui.showPauseIndicator(false);
      }
      
      private function configureOtherTankTitles() : void
      {
         var otherTankData:* = null;
         var key:* = undefined;
         var effects:Vector.<ClientBattleEffect> = null;
         var now:int = 0;
         var effect:ClientBattleEffect = null;
         var delta:int = 0;
         var duration:int = 0;
         var bfData:BattlefieldData = this.battlefield.getBattlefieldData();
         for(otherTankData in bfData.activeTanks)
         {
            if(otherTankData != this.localUserData || !otherTankData.local)
            {
               this.configureRemoteTankTitle(otherTankData);
               effects = this.effectsModel.getInitialEffects(otherTankData.user.id);
               if(effects != null)
               {
                  now = getTimer();
                  for each(effect in effects)
                  {
                     delta = now - effect.receiveTime;
                     duration = effect.duration - delta;
                     if(duration > 0)
                     {
                        otherTankData.tank.title.showIndicator(effect.effectId,duration);
                     }
                  }
               }
            }
         }
      }
      
      private function configureRemoteTankTitle(tankData:TankData) : void
      {
         this.userTitlesRender.configurateTitle(tankData);
      }
      
      private function setTankTemperature(tank:Tank, temperature:Number) : void
      {
         tank.skin.targetColorTransformOffset = -temperature;
      }
   }
}

import alternativa.resource.Tanks3DSResource;
import alternativa.tanks.vehicles.tanks.TankSkinHull;
import flash.utils.Dictionary;

class HullsRegistry
{
    
   
   private var hulls:Dictionary;
   
   function HullsRegistry()
   {
      this.hulls = new Dictionary();
      super();
   }
   
   public function getHull(resource:Tanks3DSResource) : TankSkinHull
   {
      var hull:TankSkinHull = this.hulls[resource.id];
      return hull;
   }
}

import alternativa.resource.Tanks3DSResource;
import alternativa.tanks.vehicles.tanks.TankSkinTurret;
import flash.utils.Dictionary;

class TurretsRegistry
{
    
   
   private var turrets:Dictionary;
   
   function TurretsRegistry()
   {
      this.turrets = new Dictionary();
      super();
   }
   
   public function getTurret(resource:Tanks3DSResource) : TankSkinTurret
   {
      var turret:TankSkinTurret = this.turrets[resource.id];
      return turret;
   }
}

import alternativa.resource.Tanks3DSResource;
import alternativa.tanks.vehicles.tanks.TankSkinHull;
import alternativa.tanks.vehicles.tanks.TankSkinTurret;

class TankPartsRegistry
{
    
   
   private var hullsRegistry:HullsRegistry;
   
   private var turretsRegistry:TurretsRegistry;
   
   function TankPartsRegistry()
   {
      this.hullsRegistry = new HullsRegistry();
      this.turretsRegistry = new TurretsRegistry();
      super();
   }
   
   public function getHullDescriptor(resource:Tanks3DSResource) : TankSkinHull
   {
      return this.hullsRegistry.getHull(resource);
   }
   
   public function getTurretDescriptor(resource:Tanks3DSResource) : TankSkinTurret
   {
      return this.turretsRegistry.getTurret(resource);
   }
}
