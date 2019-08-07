package alternativa.tanks.models.battlefield
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.console.ConsoleVarInt;
   import alternativa.console.IConsole;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.SkyBox;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.battlefield.gui.models.statistics.IStatisticsModelBase;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.debug.IDebugService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.osgi.service.focus.IFocusService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.network.INetworkListener;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.physics.Body;
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.IBodyCollisionPredicate;
   import alternativa.proplib.PropLibRegistry;
   import alternativa.register.ObjectRegister;
   import alternativa.register.SpaceInfo;
   import alternativa.resource.StubBitmapData;
   import alternativa.service.IAddressService;
   import alternativa.service.IModelService;
   import alternativa.service.ISpaceService;
   import alternativa.service.Logger;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.bonuses.IBonus;
   import alternativa.tanks.bonuses.IBonusListener;
   import alternativa.tanks.camera.FlyCameraController;
   import alternativa.tanks.camera.FollowCameraController;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.camera.ICameraController;
   import alternativa.tanks.camera.ICameraStateModifier;
   import alternativa.tanks.camera.IFollowCameraController;
   import alternativa.tanks.camera.ProjectileHitCameraModifier;
   import alternativa.tanks.config.Config;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.IPanelListener;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.models.battlefield.decals.DecalFactory;
   import alternativa.tanks.models.battlefield.decals.FadingDecalsRenderer;
   import alternativa.tanks.models.battlefield.decals.Queue;
   import alternativa.tanks.models.battlefield.decals.RotationState;
   import alternativa.tanks.models.battlefield.dust.Dust;
   import alternativa.tanks.models.battlefield.gamemode.IGameMode;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.hp.HP;
   import alternativa.tanks.models.battlefield.logic.BattleLogicUnits;
   import alternativa.tanks.models.battlefield.shadows.BattleShadow;
   import alternativa.tanks.models.effects.common.bonuscommon.BonusCommonModel;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.ITankEventDispatcher;
   import alternativa.tanks.models.tank.ITankEventListener;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankEvent;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.sfx.ISpecialEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sound.ISoundManager;
   import alternativa.tanks.sound.SoundManager;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tanks.Tank;
   import utils.DebugPanel;
   import utils.client.commons.types.Vector3d;
   import utils.client.models.battlefield.BattleBonus;
   import utils.client.models.battlefield.BattlefieldModelBase;
   import utils.client.models.battlefield.BattlefieldResources;
   import utils.client.models.battlefield.BattlefieldSoundScheme;
   import utils.client.models.battlefield.IBattlefieldModelBase;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import flash.system.System;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import forms.progr.CheckLoader;
   import alternativa.tanks.gui.ILoader;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import alternativa.tanks.models.battlefield.gui.RenderSystem;
   import alternativa.tanks.models.anticheat.SpeedHackChecker;
   import alternativa.tanks.models.battlefield.spectator.SpectatorCameraController;
   
   use namespace altphysics;
   
   public class BattlefieldModel extends BattlefieldModelBase implements IBattlefieldModelBase, IBattleField, IObjectLoadListener, IBonusListener, INetworkListener, IPanelListener, IBodyCollisionPredicate, IDumper, ITankEventListener
   {
      
      private static const MAP_MIPMAP_RESOLUTION:Number = 5.8;
      
      private static const CONSOLE_COMMAND_ID:String = "battle";
      
      private static const PHYSICS_STEP_MILLIS:int = 30;
      
      private static const MAX_FRAMERATE:int = 60;
      
      private static const MIN_FRAMERATE:int = 1;
      
      private static const MAX_FRAME_TIME:int = 10000;
      
      private static const ADAPTIVE_FPS_CHANGE_INTERVAL:int = 60;
      
      private static const CAMERA_FLY_TIME:int = 3000;
      
      private static const MAX_TEMPORARY_DECALS:int = 10;
      
      private static const DECAL_FADING_TIME_MS:int = 20000;
      [Embed(source="b/1.png")]
      private static const DUST_DATA:Class;
       
      
      private var objectPoolService:IObjectPoolService;
      
      private var materialRegistry:IMaterialRegistry;
      
      private var modelsRegister:IModelService;
      
      private var adaptiveFrameCounter:int;
      
      private var adaptiveFpsEnabled:Boolean = false;
      
      private var debugPanel:DebugPanel;
      
      private var tankInterface:ITank;
      
      public var _soundManager:ISoundManager;
      
      public var bfData:BattlefieldData;
      
      private var suicideIndicator:SuicideIndicator;
      
      private var screenSizeSteps:int = 10;
      
      private var screenSize:int;
      
      private var plugins:Vector.<IBattlefieldPlugin>;
      
      private var pluginCount:int;
      
      private var border:ViewportBorder;
      
      private var deltaSec:Number = 0;
      
      private var debugMode:Boolean;
      
      private var doRender:Boolean;
      
      private var physicsTimeStat:TimeStatistics;
      
      private var logicTimeStat:TimeStatistics;
      
      private var fullTimeStat:TimeStatistics;
      
      private var lastError:Error;
      
      private var uiLockCount:int;
      
      private var cameraUnlockCounter:int;
      
      public var activeCameraController:ICameraController;
      
      public var followCameraController:IFollowCameraController;
      
      public var flyCameraController:FlyCameraController;
      
      public var freeCameraController:SpectatorCameraController;
      
      private var cameraPosition:Vector3;
      
      public var cameraAngles:Vector3;
      
      private var startTime:int;
      
      private var logicTime:int;
      
      public var physicsTime:int;
      
      private var a3dRenderTime:int;
      
      private var gui:IBattlefieldGUI;
      
      private var throwDebugError:Boolean;
      
      private var panelUnlockCounter:int;
      
      private var tankExplosionStartPosition:ConsoleVarInt;
      
      private var tankExplosionVolume:ConsoleVarFloat;
      
      private var muteSound:Boolean;
      
      private var speedHackDetector:SpeedHackChecker;
      
      public var spectatorMode:Boolean;
      
      private var renderSystem:RenderSystem;
      
      public var logicUnits:BattleLogicUnits;
      
      private var lastLogicUnitsUpdate:Number;
      
      private var shadows:BattleShadow;
      
      private var dusts:Dust;
      
      private var decalFactory:DecalFactory;
      
      private const temporaryDecals:Queue = new Queue();
      
      private const allDecals:Dictionary = new Dictionary();
      
      private var fadingDecalRenderer:FadingDecalsRenderer;
      
      private var gameMode:IGameMode;
      
      public var libs:PropLibRegistry;
	        
      public function BattlefieldModel()
      {
         this.screenSize = this.screenSizeSteps;
         this.border = new ViewportBorder();
         this.physicsTimeStat = new TimeStatistics();
         this.logicTimeStat = new TimeStatistics();
         this.fullTimeStat = new TimeStatistics();
         this.cameraPosition = new Vector3();
         this.cameraAngles = new Vector3();
         this.tankExplosionStartPosition = new ConsoleVarInt("tankexpl_soffset",0,0,1000);
         this.tankExplosionVolume = new ConsoleVarFloat("tankexpl_svolume",0.4,0,1);
         this.libs = new PropLibRegistry();
         super();
         _interfaces.push(IModel,IBattleField,IBattlefieldModelBase,IObjectLoadListener,IPanelListener);
         this.objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         this.materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         this.modelsRegister = IModelService(Main.osgi.getService(IModelService));
         this.logicUnits = new BattleLogicUnits();
         ProjectileHitCameraModifier.initVars();
         FollowCameraController.effectsEnabled = true;
         var console:IConsole = IConsole(Main.osgi.getService(IConsole));
         if(console != null)
         {
            console.addCommandHandler("toggle_debug_textures",this.onToggleTextureDebug);
         }
         PanelModel(Main.osgi.getService(IPanel)).panelListeners.push(this);
         this.speedHackDetector = new SpeedHackChecker(this);
      }
      
      public function bugReportOpened() : void
      {
         this.changeUILockCount(1);
      }
      
      public function bugReportClosed() : void
      {
         this.changeUILockCount(-1);
      }
      
      public function settingsOpened() : void
      {
         this.changeUILockCount(1);
      }
      
      public function settingsCanceled() : void
      {
         this.changeUILockCount(-1);
      }
      
      public function settingsAccepted() : void
      {
         this.changeUILockCount(-1);
         if(this.bfData == null)
         {
            return;
         }
         var settings:IBattleSettings = this.getBattleSettings();
         if(settings != null)
         {
            this.bfData.skybox.visible = settings.showSkyBox;
            this.adaptiveFPS = settings.adaptiveFPS;
            if(this.bfData.ambientChannel == null && settings.bgSound || this.bfData.ambientChannel != null && !settings.bgSound)
            {
               this.toggleAmbientSound();
            }
            if(settings.fog)
            {
               this.bfData.viewport.enableFog();
            }
            else
            {
               this.bfData.viewport.disnableFog();
            }
            if(settings.useSoftParticle)
            {
               this.bfData.viewport.enableSoftParticles();
            }
            else
            {
               this.bfData.viewport.disnableSoftParticles();
            }
            this.dusts.enabled = settings.dust;
            this.bfData.viewport.camera.useShadowMap = settings.shadows;
            this.bfData.viewport.camera.shadowMapStrength = settings.shadows?Number(0.75):Number(0);
            this.bfData.viewport.camera.deferredLighting = settings.defferedLighting;
			this.bfData.viewport.camera.directionalLight.intensity = settings.defferedLighting? 0.65:0.5;
			//this.bfData.viewport.camera.ssao = settings.defferedLighting;
			this.bfData.viewport.camera.view.antiAliasEnabled = PanelModel(Main.osgi.getService(IPanel)).SSAO;
         }
      }
      
      public function connect() : void
      {
      }
      
      public function disconnect() : void
      {
         this.removeMainListeners();
         this.removeKeyboardListeners();
         this._soundManager.stopAllSounds();
      }
      
      public function getBattlefieldData() : BattlefieldData
      {
         return this.bfData;
      }
      
      public function initObject(clientObject:ClientObject, battlefieldResources:BattlefieldResources, battlefieldSoundScheme:BattlefieldSoundScheme, idleKickPeriodMsec:int, mapDescriptorResourceId:String, respawnInvulnerabilityPeriodMsec:int, skyboxTextureResourceId:String, spectator:Boolean, gameMode:IGameMode) : void
      {
         this.debugMode = Main.osgi.getService(IDebugService) != null;
         this.spectatorMode = spectator;
         this.gameMode = gameMode;
         this.panelUnlockCounter = 2;
         this.throwDebugError = false;
         this.tankInterface = Main.osgi.getService(ITank) as ITank;
         var networkService:INetworkService = Main.osgi.getService(INetworkService) as INetworkService;
         if(networkService != null)
         {
            networkService.addEventListener(this);
         }
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         this.gui = Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI;
         this.bfData = new BattlefieldData();
         this.bfData.bfObject = clientObject;
         this.bfData.guiContainer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).contentLayer;
         this.bfData.respawnInvulnerabilityPeriod = respawnInvulnerabilityPeriodMsec;
         this.bfData.idleKickPeriod = idleKickPeriodMsec;
         this.initSounds(battlefieldSoundScheme);
         this.initPhysicsAndViewport();
         this.initMap(mapDescriptorResourceId,skyboxTextureResourceId);
         var dumpService:IDumpService = IDumpService(Main.osgi.getService(IDumpService));
         if(dumpService != null)
         {
            dumpService.registerDumper(this);
         }
         this.startTime = getTimer();
         this.logicTime = 0;
         this.physicsTime = 0;
         this.a3dRenderTime = 0;
      }
      
      public function initBonuses(clientObject:ClientObject, bonuses:Array) : void
      {
         var bonusData:BattleBonus = null;
         if(bonuses == null)
         {
            return;
         }
         for each(bonusData in bonuses)
         {
            this.createBonusAndAttach(clientObject.register,bonusData.id,bonusData.objectId,bonusData.position,bonusData.timeFromAppearing,false,clientObject);
         }
      }
      
      public function addBonus(clientObject:ClientObject, bonusId:String, bonusObjectId:String, position:Vector3d, disappearingTime:int = 21) : void
      {
         this.createBonusAndAttach(clientObject.register,bonusId,bonusObjectId,position,0,true,clientObject,disappearingTime);
      }
	  
	  public function addBonus1(clientObject:ClientObject, bonusId:String, bonusObjectId:String, position:Vector3d, disappearingTime:int = 21) : void
      {
         this.createBonusAndAttach1(clientObject.register,bonusId,bonusObjectId,position,0,true,clientObject,disappearingTime);
      }
      
      public function bonusDropped(clientObject:ClientObject, bonusId:String, bonusObjectId:String, position:Vector3d, timeFromAppearing:int) : void
      {
         var bonus:IBonus = this.bfData.bonuses[bonusId];
         if(bonus == null)
         {
            bonus = this.createBonusAndAttach(clientObject.register,bonusId,bonusObjectId,position,timeFromAppearing,false,clientObject);
            if(bonus == null)
            {
               return;
            }
         }
         bonus.setRestingState(position.x,position.y,position.z);
      }
      
      public function removeBonus(clientObject:ClientObject, bonusId:String) : void
      {
         if(this.bfData == null)
         {
            return;
         }
         var bonus:IBonus = this.bfData.bonuses[bonusId];
         if(bonus != null)
         {
            bonus.setRemovedState();
         }
      }
      
      public function bonusTaken(clientObject:ClientObject, bonusId:String) : void
      {
         var sound:Sound3D = null;
         var position:Vector3 = null;
         if(this.bfData == null)
         {
            return;
         }
         var bonus:IBonus = this.bfData.bonuses[bonusId];
         if(bonus == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"BattlefieldModel::bonusTaken(): bonus not found. Bonus id=" + bonusId);
         }
         else
         {
            bonus.setTakenState();
            if(this.bfData.bonusTakenSound != null)
            {
               sound = Sound3D.create(this.bfData.bonusTakenSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,0.5);
               position = new Vector3();
               bonus.readBonusPosition(position);
               this.addSound3DEffect(Sound3DEffect.create(this.objectPoolService.objectPool,null,position,sound));
            }
         }
      }
      
      public function onBonusDropped(bonus:IBonus) : void
      {
         var position:Vector3 = new Vector3();
         bonus.readBonusPosition(position);
      }
      
      public function onTankCollision(bonus:IBonus) : void
      {
         if(bonus.isFalling())
         {
            this.onBonusDropped(bonus);
         }
         this.attemptToTakeBonus(this.bfData.bfObject,bonus.bonusId);
      }
      
      private function attemptToTakeBonus(bfObject:ClientObject, bonusId:String) : void
      {
         var localTankData:TankData = this.tankInterface.getTankData(this.bfData.localUser);
         var json:Object = new Object();
         json.bonus_id = bonusId;
         json.real_tank_position = new Vector3d(localTankData.tank.state.pos.x,localTankData.tank.state.pos.y,localTankData.tank.state.pos.z);
         Network(Main.osgi.getService(INetworker)).send("battle;attempt_to_take_bonus;" + JSON.stringify(json));
      }
      
      public function battleStart(clientObject:ClientObject) : void
      {
         var i:int = 0;
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).startBattle();
            }
         }
      }
      
      public function battleFinish(clientObject:ClientObject) : void
      {
         var key:* = undefined;
         var tankData:* = null;
         var bonus:IBonus = null;
         var i:int = 0;
         this.tankInterface.disableUserControls(true);
         for(tankData in this.bfData.activeTanks)
         {
            tankData.tank.title.hideIndicators();
            this.tankInterface.stop(tankData);
            tankData.enabled = false;
         }
         this.suicideIndicator.visible = false;
         this.tankInterface.resetIdleTimer(true);
         for(key in this.bfData.bonuses)
         {
            bonus = this.bfData.bonuses[key];
            bonus.destroy();
            delete this.bfData.bonuses[key];
         }
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).finishBattle();
            }
         }
      }
      
      public function battleRestart(clientObject:ClientObject) : void
      {
         var key:* = undefined;
         var i:int = 0;
         for(key in this.bfData.activeTanks)
         {
            this.removeTankFromField(key as TankData);
         }
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).restartBattle();
            }
         }
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         (Main.osgi.getService(ILoader) as CheckLoader).setFullAndClose(null);
         var prefix:String = Game.local?"":"resources/";
         this._soundManager = SoundManager.createSoundManager(this.bfData.ambientSound);
         var settings:IBattleSettings = this.getBattleSettings();
         this.muteSound = settings.muteSound;
         if(!this.muteSound && settings.bgSound)
         {
            this.bfData.ambientChannel = this._soundManager.playSound(this.bfData.ambientSound,0,1000000,new SoundTransform(0.5));
         }
         this.addMainListeners();
         this.addKeyboardListeners();
         this.bfData.time = getTimer();
         this.onResize(null);
         var tankEventDispatcher:ITankEventDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
         if(tankEventDispatcher != null)
         {
            tankEventDispatcher.addTankEventListener(TankEvent.KILLED,this);
            tankEventDispatcher.addTankEventListener(TankEvent.SPAWNED,this);
         }
         if(!this.spectatorMode)
         {
            Network(Main.osgi.getService(INetworker)).send("battle;get_init_data_local_tank");
         }
         else
         {
            BattleController.localTankInited = true;
            Network(Main.osgi.getService(INetworker)).send("battle;spectator_user_init");
            this.activateSpectatorCamera();
         }
		 settingsAccepted();
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
         if(this.bfData == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"BattlefieldModel::objectUnloaded Called more than once");
            return;
         }
         var networkService:INetworkService = INetworkService(Main.osgi.getService(INetworkService));
         if(networkService != null)
         {
            networkService.removeEventListener(this);
         }
		 if(StatisticsModel(Main.osgi.getService(IBattlefieldGUI)) != null)
         {
            StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).objectUnloaded(null);
         }
         Main.debug.unregisterCommand(CONSOLE_COMMAND_ID);
         this.materialRegistry.clear();
         this.removeMainListeners();
         this.removeKeyboardListeners();
         this._soundManager.stopAllSounds();
         this._soundManager.removeAllEffects();
         this.bfData.viewport.camera.view.clear();
         this.bfData.viewport.camera.view = null;
         this.bfData.viewport.clearContainers();
         this.bfData.guiContainer.removeChild(this.bfData.viewport);
         IFocusService(Main.osgi.getService(IFocusService)).clearFocus(this.bfData.viewport);
         this.bfData.guiContainer.stage.frameRate = MAX_FRAMERATE;
         this.setCameraTarget(null);
         this.debugPanel = null;
         this.bfData = null;
         this.suicideIndicator = null;
         var bgService:IBackgroundService = IBackgroundService(Main.osgi.getService(IBackgroundService));
         if(bgService != null)
         {
            bgService.drawBg();
         }
         var dumpService:IDumpService = IDumpService(Main.osgi.getService(IDumpService));
         if(dumpService != null)
         {
            dumpService.unregisterDumper(this.dumperName);
         }
         var storageService:IStorageService = IStorageService(Main.osgi.getService(IStorageService));
         storageService.getStorage().data.cameraHeight = this.followCameraController.cameraHeight;
         var tankEventDispatcher:ITankEventDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
         tankEventDispatcher.removeTankEventListener(TankEvent.KILLED,this);
         tankEventDispatcher.removeTankEventListener(TankEvent.SPAWNED,this);
      }
      
      public function addGraphicEffect(effect:IGraphicEffect) : void
      {
         if(effect == null)
         {
            return;
         }
         this.bfData.graphicEffects[effect] = true;
         effect.addToContainer(this.bfData.viewport.getMapContainer());
      }
      
      public function addSound3DEffect(effect:ISound3DEffect) : void
      {
         if(effect != null && !this.muteSound)
         {
            this._soundManager.addEffect(effect);
         }
      }
      
      public function setLocalUser(clinetObject:ClientObject) : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.localUser = clinetObject;
      }
      
      public function addTank(tankData:TankData) : void
      {
         var i:int = 0;
         this.bfData.tanks[tankData.tank] = tankData;
         if(tankData.enabled)
         {
            this.addTankToField(tankData);
         }
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).addUser(tankData.user);
            }
         }
         if(tankData.local)
         {
            this.updatePanelUnlockCounter();
         }
      }
      
      public function removeTank(tankData:TankData) : void
      {
         var i:int = 0;
         if(this.bfData == null)
         {
            return;
         }
         if(this.bfData.activeTanks[tankData] != null)
         {
            this.removeTankFromField(tankData);
            delete this.bfData.tanks[tankData.tank];
         }
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).removeUser(tankData.user);
            }
         }
      }
      
      public function onResize(e:Event) : void
      {
         var scrSize:Number = this.screenSize / this.screenSizeSteps;
         var stage:Stage = this.bfData.guiContainer.stage;
         var w:Number = stage.stageWidth;
         var h:Number = stage.stageHeight;
         var sw:int = w * scrSize;
         var sh:int = h * scrSize;
         this.bfData.viewport.resize(sw,sh);
         this.bfData.viewport.x = 0.5 * (w - sw);
         this.bfData.viewport.y = 0.5 * (h - sh);
         var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
         if(bgService != null)
         {
            bgService.drawBg(new Rectangle(0.5 * (w - sw),0.5 * (h - sh),sw,sh));
         }
         this.bfData.viewport.overlay.graphics.clear();
         if(this.screenSize < this.screenSizeSteps)
         {
            this.border.draw(this.bfData.viewport.overlay.graphics,sw,sh);
         }
         this.suicideIndicator.x = (w - suicideIndicator.wi)*0.5;
         this.suicideIndicator.y = (h - suicideIndicator.he)*0.5;
      }
      
      public function getObjectPool() : ObjectPool
      {
         return this.objectPoolService.objectPool;
      }
      
      public function initFlyCamera(pivotPosition:Vector3, targetDirection:Vector3) : void
      {
         if(this.activeCameraController == this.freeCameraController)
         {
            return;
         }
         this.followCameraController.deactivate();
         this.followCameraController.getCameraState(pivotPosition,targetDirection,this.cameraPosition,this.cameraAngles);
         this.flyCameraController.init(this.cameraPosition,this.cameraAngles,CAMERA_FLY_TIME);
         this.activeCameraController = this.flyCameraController;
      }
      
      public function initFollowCamera(pivotPosition:Vector3, targetDirection:Vector3) : void
      {
         this.followCameraController.activate();
         this.followCameraController.setLocked(true);
         this.followCameraController.initByTarget(pivotPosition,targetDirection);
         this.activeCameraController = this.followCameraController;
         this.incCameraUnlockCounter();
      }
      
      public function activateFollowCamera() : void
      {
         this.followCameraController.activate();
         this.followCameraController.setLocked(false);
         this.activeCameraController = this.followCameraController;
         TankModel(this.tankInterface).lockControls(false);
      }
      
      public function activateSpectatorCamera() : void
      {
         if(this.activeCameraController == this.followCameraController)
         {
            this.followCameraController.deactivate();
         }
         this.activeCameraController = this.freeCameraController;
         this.freeCameraController.activate();
         TankModel(this.tankInterface).lockControls(true);
      }
      
      private function toggleFreeCamera() : void
      {
         if(this.activeCameraController != this.freeCameraController)
         {
            if(this.activeCameraController == this.followCameraController)
            {
               this.followCameraController.deactivate();
            }
            this.activeCameraController = this.freeCameraController;
            this.freeCameraController.activate();
            TankModel(this.tankInterface).lockControls(true);
         }
         else
         {
            this.freeCameraController.deactivate();
            this.followCameraController.activate();
            this.followCameraController.setLocked(false);
            this.activeCameraController = this.followCameraController;
            TankModel(this.tankInterface).lockControls(false);
         }
      }
      
      public function setCameraTarget(tank:Tank) : void
      {
         this.followCameraController.tank = tank;
      }
      
      public function showSuicideIndicator(time:int) : void
      {
		 this.suicideIndicator.visible = true;
		 //throw new Error(time);
         this.suicideIndicator.seconds = time;
      }
      
      public function hideSuicideIndicator() : void
      {
         this.suicideIndicator.visible = false;
      }
      
      public function getRespawnInvulnerabilityPeriod() : int
      {
         return this.getBattlefieldData().respawnInvulnerabilityPeriod;
      }
      
      public function removeTankFromField(tankData:TankData) : void
      {
         var i:int = 0;
         if(this.bfData.activeTanks[tankData] == null)
         {
            return;
         }
         delete this.bfData.activeTanks[tankData];
         tankData.logEvent("Removed from field");
         tankData.tank.removeFromContainer();
         this.bfData.physicsScene.removeBody(tankData.tank);
         this.bfData.collisionDetector.removeBody(tankData.tank);
         this.tankInterface.stop(tankData);
         this._soundManager.removeEffect(tankData.sounds);
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).removeUserFromField(tankData.user);
            }
         }
         if(this.followCameraController.tank == tankData.tank)
         {
            this.followCameraController.deactivate();
         }
      }
      
      public function considerBodies(body1:Body, body2:Body) : Boolean
      {
         var tankData:TankData = null;
         if(body1.postCollisionPredicate != null && body2.postCollisionPredicate == null)
         {
            tankData = this.bfData.tanks[body1];
            tankData.tankCollisionCount++;
         }
         else if(body1.postCollisionPredicate == null && body2.postCollisionPredicate != null)
         {
            tankData = this.bfData.tanks[body2];
            tankData.tankCollisionCount++;
         }
         return false;
      }
      
      public function printDebugValue(valueName:String, value:String) : void
      {
         this.debugPanel.printValue(valueName,value);
      }
      
      public function addPlugin(plugin:IBattlefieldPlugin) : void
      {
         if(this.plugins == null)
         {
            this.plugins = new Vector.<IBattlefieldPlugin>();
         }
         if(this.plugins.indexOf(plugin) < 0)
         {
            this.plugins[this.pluginCount++] = plugin;
         }
      }
      
      public function removePlugin(plugin:IBattlefieldPlugin) : void
      {
         var idx:int = 0;
         if(this.plugins != null)
         {
            idx = this.plugins.indexOf(plugin);
            if(idx > -1)
            {
               this.plugins.splice(idx,1);
               this.pluginCount--;
            }
         }
      }
      
      public function get soundManager() : ISoundManager
      {
         return this._soundManager;
      }
      
      public function tankHit(tankData:TankData, direction:Vector3, power:Number) : void
      {
      }
      
      public function get dumperName() : String
      {
         return "currbattle";
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var tankData:TankData = null;
         var plugin:IBattlefieldPlugin = null;
         var active:Boolean = false;
         if(this.bfData == null)
         {
            return "";
         }
         var str:String = "=== BattlefieldModel dump ===\n";
         if(this.plugins != null && this.pluginCount > 0)
         {
            str = str + "Plugins list:\n";
            for each(plugin in this.plugins)
            {
               str = str + (" " + plugin.battlefieldPluginName + "\n");
            }
            str = str + "End of plugins list\n";
         }
         str = str + "Tanks list:\n";
         var counter:int = 0;
         for each(tankData in this.bfData.tanks)
         {
            active = this.bfData.activeTanks[tankData] != null;
            str = str + ("--- Tank " + counter++ + " ---\n" + "active=" + active + "\n" + tankData.toString() + "\n");
         }
         str = str + "End of tanks list\n";
         str = str + "=== End BattlefieldModel dump ===\n";
         return str;
      }
      
      public function handleTankEvent(eventType:int, tankData:TankData) : void
      {
         switch(eventType)
         {
            case TankEvent.SPAWNED:
               this.spawnTank(tankData);
               break;
            case TankEvent.KILLED:
               this.killTank(tankData);
         }
      }
      
      public function addFollowCameraModifier(modifier:ICameraStateModifier) : void
      {
         this.followCameraController.addModifier(modifier);
      }
      
      public function setMuteSound(mute:Boolean) : void
      {
         var settings:IBattleSettings = null;
         var key:* = undefined;
         if(this.bfData == null)
         {
            return;
         }
         this.muteSound = mute;
         if(mute)
         {
            this._soundManager.stopAllSounds();
            this._soundManager.removeAllEffects();
            this.bfData.ambientChannel = null;
         }
         else
         {
            settings = this.getBattleSettings();
            if(settings.bgSound)
            {
               this.bfData.ambientChannel = this._soundManager.playSound(this.bfData.ambientSound,0,1000000,new SoundTransform(0.5));
            }
            for(key in this.bfData.activeTanks)
            {
               this._soundManager.addEffect(TankData(key).sounds);
            }
         }
      }
      
      private function spawnTank(tankData:TankData) : void
      {
         if(this.bfData.activeTanks[tankData] != null)
         {
            return;
         }
         this.addTankToField(tankData);
         this._soundManager.addEffect(tankData.sounds);
      }
      
      private function killTank(tankData:TankData) : void
      {
         var sound3D:Sound3D = null;
         var turretMesh:Mesh = null;
         this._soundManager.removeEffect(tankData.sounds);
         this._soundManager.killEffectsByOwner(tankData.user);
         for (var key:* in bfData.graphicEffects) {
				var effect:ISpecialEffect = key;
				if (effect.owner == tankData.user) {
					effect.kill();
				}
			}
         if(this.bfData.killSound != null)
         {
            sound3D = Sound3D.create(this.bfData.killSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,this.tankExplosionVolume.value);
            turretMesh = tankData.tank.skin.turretMesh;
            this.addSound3DEffect(Sound3DEffect.create(this.objectPoolService.objectPool,null,new Vector3(turretMesh.x,turretMesh.y,turretMesh.z),sound3D,0,this.tankExplosionStartPosition.value));
         }
         if(this.followCameraController.tank == tankData.tank)
         {
            this.followCameraController.setLocked(true);
         }
      }
      
      private function initSounds(battlefieldSoundScheme:BattlefieldSoundScheme) : void
      {
         this.bfData.ambientSound = ResourceUtil.getResource(ResourceType.SOUND,battlefieldSoundScheme.ambientSound).sound;
         this.bfData.bonusTakenSound = ResourceUtil.getResource(ResourceType.SOUND,"bonusTakenSound").sound;
         this.bfData.battleFinishSound = ResourceUtil.getResource(ResourceType.SOUND,"battleFinishSound").sound;
         this.bfData.killSound = ResourceUtil.getResource(ResourceType.SOUND,"killSound").sound;
      }
      
      private function initPhysicsAndViewport() : void
      {
         var physics:PhysicsScene = new PhysicsScene();
         this.bfData.physicsScene = physics;
         physics.usePrediction = true;
         physics.gravity = new Vector3(0,0,-1000);
         physics.collisionIterations = 3;
         physics.contactIterations = 3;
         physics.maxPenResolutionSpeed = 100;
         physics.allowedPenetration = 5;
         physics.collisionDetector = this.bfData.collisionDetector = new TanksCollisionDetector();
         this.bfData.viewport = new BattleView3D(this.debugMode,this.bfData.collisionDetector,this);
         this.shadows = new BattleShadow(this.bfData.viewport);
         //this.shadows.on();
         this.bfData.guiContainer.addChild(this.bfData.viewport);
         this.dusts = new Dust(this);
         this.dusts.init(new DUST_DATA().bitmapData,50000,5000,180,0.75,0.15);
         this.suicideIndicator = new SuicideIndicator("Самоуничтожение через ");
         this.bfData.viewport.addChild(this.suicideIndicator);
		 this.hideSuicideIndicator();
         Main.stage.focus = this.bfData.viewport;
         this.cameraUnlockCounter = 0;
         this.doRender = false;
         this.debugPanel = new DebugPanel();
         this.debugPanel.visible = false;
         this.followCameraController = new FollowCameraController(Main.stage,this.bfData.collisionDetector,this.bfData.viewport.camera,CollisionGroup.CAMERA);
         this.flyCameraController = new FlyCameraController(this.bfData.viewport.camera);
         this.freeCameraController = new SpectatorCameraController(this.bfData.viewport.camera);
         var settings:IBattleSettings = this.getBattleSettings();
         FollowCameraController(this.followCameraController).setDefaultSettings();
         var storage:IStorageService = Main.osgi.getService(IStorageService) as IStorageService;
         this.screenSize = storage.getStorage().data.screenSize;
         if(this.screenSize == 0)
         {
            this.screenSize = this.screenSizeSteps;
         }
         var cameraHeight:int = storage.getStorage().data.cameraHeight;
         if(cameraHeight != 0)
         {
            this.followCameraController.cameraHeight = cameraHeight;
         }
         this.decalFactory = new DecalFactory(this.bfData.collisionDetector);
         this.fadingDecalRenderer = new FadingDecalsRenderer(DECAL_FADING_TIME_MS,this);
         var stage:Stage = this.bfData.guiContainer.stage;
         var w:Number = stage.stageWidth * this.screenSize;
         var h:Number = stage.stageHeight * this.screenSize;
         this.bfData.viewport.resize(w,h);
      }
      
      private function initMap(mapResourceId:String, skyboxId:String) : void
      {
         this.bfData.skybox = this.createSkyBox(skyboxId);
         this.bfData.viewport.setSkyBox(this.bfData.skybox);
         var c:Config = new Config();
         c.load("config.xml?rand=" + Math.random(),mapResourceId);
      }
      
      public function removeDecal(param1:Decal) : void
      {
      }
      
      public function addDecal(param1:Vector3, param2:Vector3, param3:Number, param4:TextureMaterial, param5:RotationState = null) : void
      {
      }
      
      public function build(mapTree:KDContainer, c:Vector.<CollisionPrimitive>, lights:Vector.<Light3D>) : void
      {
         this.bfData.viewport._mapContainer = mapTree;
         this.bfData.viewport.initLights(lights);
         var collisionDetector:TanksCollisionDetector = TanksCollisionDetector(this.bfData.physicsScene.collisionDetector);
         collisionDetector.buildKdTree(c);
         this.onMapBuildingComplete(null);
      }
      
      private function createSkyBox(skyboxId:String) : SkyBox
      {
         var skyBoxTexture:BitmapData = null;
         switch(skyboxId)
         {
            case "skybox_default":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_2").bitmapData;
               break;
            case "skybox_desert":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_3").bitmapData;
               break;
            case "skybox_iran":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_4").bitmapData;
               break;
            case "skybox_halloween":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_5").bitmapData;
               break;
            case "skybox_winter":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_6").bitmapData;
               break;
            case "skybox_plato":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_7").bitmapData;
               break;
            case "skybox_new_year":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_8").bitmapData;
               break;
            case "skybox_winter_evening":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_9").bitmapData;
               break;
            case "skybox_evening":
               skyBoxTexture = ResourceUtil.getResource(ResourceType.IMAGE, "cs_10").bitmapData;
               break;
            default:
               skyBoxTexture = new StubBitmapData(0);
         }
         var material:TextureMaterial = new TextureMaterial(skyBoxTexture);
         var SKYBOX_SIZE:int = 200000;
         var skyBox:SkyBox = new SkyBox(SKYBOX_SIZE, material, material, material, material, material, material);
         var m:Matrix = new Matrix();
         var sides:Array = [SkyBox.RIGHT,SkyBox.BACK,SkyBox.LEFT,SkyBox.FRONT];
         for(var i:int = 0; i < sides.length; i++)
         {
            m.identity();
            m.scale(1 / 6,1);
            m.translate(i / 6.01,0);
            skyBox.transformUV(sides[i],m);
         }
         m.identity();
         m.scale(-1 / 6.01,-1);
         m.translate(5 / 6,1);
         skyBox.transformUV(SkyBox.TOP,m);
         m.identity();
         m.scale(-1 / 6.01,-1);
         m.translate(1,1);
         skyBox.transformUV(SkyBox.BOTTOM,m);
         return skyBox;
      }
      
      private function onMapBuildingComplete(e:Event) : void
      {
         this.gui = Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI;
         this.doRender = true;
         this.incCameraUnlockCounter();
         this.updatePanelUnlockCounter();
         if(this.gameMode != null)
         {
            this.gameMode.applyChanges(this.bfData.viewport);
         }
         this.objectLoaded(null);
      }
      
      private function addMainListeners() : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.guiContainer.addEventListener(Event.ENTER_FRAME, this.loop);
		 this.bfData.guiContainer.addEventListener(Event.FRAME_CONSTRUCTED,this.lo);
         this.bfData.guiContainer.stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      private function removeMainListeners() : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.guiContainer.removeEventListener(Event.ENTER_FRAME, this.loop);
		 this.bfData.guiContainer.removeEventListener(Event.FRAME_CONSTRUCTED,this.lo);
         this.bfData.guiContainer.stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      public function addKeyboardListeners() : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.guiContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.bfData.guiContainer.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      public function removeKeyboardListeners() : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.guiContainer.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.bfData.guiContainer.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      private function updateTimeStat(delta:int, stat:TimeStatistics, timeMessage:String, fpsMessage:String) : void
      {
         stat.timeAccum = stat.timeAccum + delta;
         if(++stat.stepCounter >= stat.numSteps)
         {
            stat.avrgTime = stat.timeAccum / stat.stepCounter;
            stat.avrgFps = 1000 / stat.avrgTime;
            stat.stepCounter = 0;
            stat.timeAccum = 0;
            if(this.debugPanel.visible)
            {
               this.debugPanel.printValue(timeMessage,stat.avrgTime.toFixed(2));
               this.debugPanel.printValue(fpsMessage,stat.avrgFps.toFixed(2));
            }
         }
      }
	  
	  private function lo(e:Event) : void
      {
         //if(this.doRender)
         //{
			System.gc();
            this.bfData.viewport.update();
         //}
      }
      
      private function loop(e:Event) : void
      {
		 System.gc();
         var fps:Number = NaN;
         var i:int = 0;
         var runningTime:int = 0;
         var t1:int = getTimer();
         var deltaMsec:int = t1 - this.bfData.time;
         this.bfData.time = t1;
         if(deltaMsec <= 0)
         {
            return;
         }
         this.deltaSec = 0.001 * deltaMsec;
         if(this.adaptiveFpsEnabled)
         {
            if(++this.adaptiveFrameCounter == ADAPTIVE_FPS_CHANGE_INTERVAL)
            {
               this.adaptiveFrameCounter = 0;
               if(this.fullTimeStat.avrgFps < Main.stage.frameRate - 1)
               {
                  Main.stage.frameRate = this.fullTimeStat.avrgFps < MIN_FRAMERATE?Number(MIN_FRAMERATE):Number(this.fullTimeStat.avrgFps);
               }
               else
               {
                  fps = Main.stage.frameRate + 1;
                  Main.stage.frameRate = fps > MAX_FRAMERATE?Number(MAX_FRAMERATE):Number(fps);
               }
               /*if(this.debugPanel.visible)
               {
                  this.debugPanel.printValue("Stage frame rate",Main.stage.frameRate.toFixed(2));
               }*/
            }
         }
         t1 = getTimer();
         this.runPhysics(PHYSICS_STEP_MILLIS);
         var t2:int = getTimer();
         this.physicsTime = this.physicsTime + (t2 - t1);
         t1 = t2;
         if(this.activeCameraController != null)
         {
            this.activeCameraController.update(this.bfData.time,deltaMsec);
         }
         this.bfData.viewport.camera.calculateAdditionalData();
         var t:Number = 1 - (this.bfData.physTime - this.bfData.time) / PHYSICS_STEP_MILLIS;
         this.updateTanks(this.bfData.time,deltaMsec,this.deltaSec,t);
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).tick(this.bfData.time,deltaMsec,this.deltaSec,t);
            }
         }
         this.lastLogicUnitsUpdate = this.bfData.physTime - this.lastLogicUnitsUpdate;
         this.logicUnits.update(this.bfData.physTime,this.lastLogicUnitsUpdate);
         this.playSpecialEffects(deltaMsec);
         this.updateBonuses(this.bfData.time,deltaMsec,t);
         deltaMsec = getTimer() - this.bfData.time;
         t2 = getTimer();
         this.logicTime = this.logicTime + (t2 - t1);
         t1 = t2;
         this.dusts.update();
         /*if(this.debugPanel.visible)
         {
            runningTime = getTimer() - this.startTime;
            this.debugPanel.printValue("Running time",runningTime);
            this.debugPanel.printValue("Physics time",this.physicsTime,":",Number(this.physicsTime / runningTime).toFixed(4));
            this.debugPanel.printValue("Logic time",this.logicTime,":",Number(this.logicTime / runningTime).toFixed(4));
            this.debugPanel.printValue("A3D render time",this.a3dRenderTime,":",Number(this.a3dRenderTime / runningTime).toFixed(4));
         }*/
      }
      
      private function onAlertButtonPressed(e:Event) : void
      {
         var spaceService:ISpaceService = null;
         var panelObjectId:String = null;
         var spaceInfo:SpaceInfo = null;
         if(this.debugMode)
         {
            spaceService = ISpaceService(Main.osgi.getService(ISpaceService));
            panelObjectId = "aaa";
            spaceInfo = spaceService.getSpaceByObjectId(panelObjectId);
         }
         var addressService:IAddressService = IAddressService(Main.osgi.getService(IAddressService));
         if(addressService != null)
         {
            addressService.reload();
         }
      }
      
      private function runPhysics(dt:int) : void
      {
         var key:* = undefined;
         var tankData:* = null;
         var time:int = 0;
		 System.gc();
         if(this.bfData.time - this.bfData.physTime > MAX_FRAME_TIME)
         {
            this.bfData.physTime = this.bfData.time - MAX_FRAME_TIME;
         }
         if(this.bfData.physTime < this.bfData.time)
         {
            for(tankData in this.bfData.activeTanks)
            {
               tankData.tankCollisionCount = 0;
            }
            while(this.bfData.physTime < this.bfData.time)
            {
               time = getTimer();
               this.bfData.physicsScene.update(dt);
               this.bfData.physTime = this.bfData.physTime + dt;
               this.updateTimeStat(getTimer() - time,this.physicsTimeStat,"Physics avrg time","Physics avrg fps");
            }
         }
      }
      
      private function updateTanks(time:int, deltaMillis:int, deltaSec:Number, t:Number) : void
      {
         var key:* = undefined;
         var localTankData:TankData = null;
         var camPos:Vector3D = this.bfData.viewport.camera.pos;
         for(key in this.bfData.activeTanks)
         {
            this.tankInterface.update(key as TankData,time,deltaMillis,deltaSec,t,camPos);
         }
         if(this.bfData.localUser != null)
         {
            localTankData = this.tankInterface.getTankData(this.bfData.localUser);
            if(this.bfData.activeTanks[localTankData] == null)
            {
               this.tankInterface.update(localTankData,time,deltaMillis,deltaSec,t,camPos);
            }
         }
      }
      
      private function playSpecialEffects(dt:int) : void
      {
         var camera:GameCamera = bfData.viewport.camera;
			for (var key:* in bfData.graphicEffects) {
				var effect:ISpecialEffect = key;
				if (!effect.play(dt, camera)) {
					effect.destroy();
					delete bfData.graphicEffects[key];
				}
			}
         if(!this.muteSound)
         {
            this._soundManager.updateSoundEffects(dt,camera);
         }
      }
      
      private function updateBonuses(time:int, dt:int, t:Number) : void
      {
         var key:* = undefined;
         var bonus:IBonus = null;
         for(key in this.bfData.bonuses)
         {
            bonus = this.bfData.bonuses[key];
            if(!bonus.update(time,dt,t))
            {
               bonus.destroy();
               delete this.bfData.bonuses[key];
            }
         }
      }
      
      private function addTankToField(tankData:TankData) : void
      {
         var i:int = 0;
         if(this.bfData.activeTanks[tankData] != null)
         {
            return;
         }
         this.bfData.activeTanks[tankData] = true;
         tankData.tank.addToContainer(this.bfData.viewport.getMapContainer());
         tankData.tank.updateSkin(1);
         tankData.logEvent("Added to field");
         this.bfData.physicsScene.addBody(tankData.tank);
         this.bfData.collisionDetector.addBody(tankData.tank);
         this._soundManager.addEffect(tankData.sounds);
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).addUserToField(tankData.user);
            }
         }
         if(tankData.tank == this.followCameraController.tank && this.activeCameraController != this.freeCameraController)
         {
            this.followCameraController.activate();
            this.followCameraController.setLocked(false);
            this.followCameraController.initCameraComponents();
            this.activeCameraController = this.followCameraController;
         }
         this.dusts.addTank(tankData);
      }
      
      private function onKey(e:KeyboardEvent) : void
      {
         this.tankInterface.resetIdleTimer(false);
         if(e.type == KeyboardEvent.KEY_DOWN)
         {
            this.handleKeyDown(e);
         }
      }
      
      public function cheatDetected() : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;speedhack_detected");
      }
      
      private function handleKeyDown(e:KeyboardEvent) : void
      {
         var tankData:TankData = null;
         var camera:Camera3D = null;
         switch(e.keyCode)
         {
            case Keyboard.NUMPAD_ADD:
            case 187:
               this.setScreenSize(this.screenSize + 1);
			   //this.bfData.viewport.camera.shadowMap.noiseRadius += 0.1;
               break;
            case Keyboard.NUMPAD_SUBTRACT:
            case 189:
               this.setScreenSize(this.screenSize - 1);
			   //this.bfData.viewport.camera.shadowMap.noiseRadius -= 0.1;
               break;/*
            case 187:
               //this.setScreenSize(this.screenSize + 1);
			   this.bfData.viewport.camera.shadowMap.noiseSize += 1;
               break;
            case 189:
               //this.setScreenSize(this.screenSize - 1);
			   this.bfData.viewport.camera.shadowMap.noiseSize -= 1;
               break;*/
            case 66:
               if(this.debugMode)
               {
                  if(e.ctrlKey && this.bfData != null)
                  {
                     for each(tankData in this.bfData.tanks)
                     {
                        tankData.tank.showCollisionGeometry = !tankData.tank.showCollisionGeometry;
                     }
                     camera = this.bfData.viewport.camera;
                     camera.debug = !camera.debug;
                  }
               }
         }
      }
      
      private function toggleTextureDebug() : Boolean
      {
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         var textureDebug:Boolean = storage.data.textureDebug1;
         storage.data.textureDebug1 = !textureDebug;
         storage.flush();
         return !textureDebug;
      }
      
      private function toggleAmbientSound() : void
      {
         if(this.bfData.ambientChannel != null)
         {
            this._soundManager.stopSound(this.bfData.ambientChannel);
            this.bfData.ambientChannel = null;
         }
         else
         {
            this.bfData.ambientChannel = this._soundManager.playSound(this.bfData.ambientSound,0,100000,new SoundTransform(0.5));
         }
      }
      
      private function setScreenSize(size:int) : void
      {
         this.screenSize = size > this.screenSizeSteps?int(this.screenSizeSteps):size < 1?int(1):int(size);
         var storage:IStorageService = Main.osgi.getService(IStorageService) as IStorageService;
         storage.getStorage().data.screenSize = this.screenSize;
         this.onResize(null);
      }
	  
	  private function createBonusAndAttach1(objectRegister:ObjectRegister, bonusId:String, bonusObjectId:String, position:Vector3d, livingTime:int, isFalling:Boolean, clientObject:ClientObject, disappearingTime:int = 21) : IBonus
      {
         var bonusObject:ClientObject = clientObject;
         if(bonusObject == null)
         {
            return null;
         }
         var bonusModel:BonusCommonModel = new BonusCommonModel();
         bonusModel.initObject(clientObject,"bonus_box_" + bonusId.split("_")[0],"cords",disappearingTime,"parachute_inner","parachute");
         var bonus:IBonus = bonusModel.getBonus(bonusObject,bonusId,livingTime,false);
         this.bfData.bonuses[bonus.bonusId] = bonus;
         bonus.attach1(new Vector3(position.x,position.y,position.z),this.bfData.physicsScene,this.bfData.viewport.getMapContainer(),this);
         return bonus;
      }
      
      private function createBonusAndAttach(objectRegister:ObjectRegister, bonusId:String, bonusObjectId:String, position:Vector3d, livingTime:int, isFalling:Boolean, clientObject:ClientObject, disappearingTime:int = 21) : IBonus
      {
         var bonusObject:ClientObject = clientObject;
         if(bonusObject == null)
         {
            return null;
         }
         var bonusModel:BonusCommonModel = new BonusCommonModel();
         bonusModel.initObject(clientObject,"bonus_box_" + bonusId.split("_")[0],"cords",disappearingTime,"parachute_inner","parachute");
         var bonus:IBonus = bonusModel.getBonus(bonusObject,bonusId,livingTime,isFalling);
         this.bfData.bonuses[bonus.bonusId] = bonus;
         bonus.attach(new Vector3(position.x,position.y,position.z),this.bfData.physicsScene,this.bfData.viewport.getMapContainer(),this);
         return bonus;
      }
      
      private function set adaptiveFPS(value:Boolean) : void
      {
         if(this.adaptiveFpsEnabled == value)
         {
            return;
         }
         this.adaptiveFpsEnabled = value;
         if(!this.adaptiveFpsEnabled)
         {
            this.bfData.guiContainer.stage.frameRate = MAX_FRAMERATE;
         }
      }
      
      private function getBattleSettings() : IBattleSettings
      {
         return IBattleSettings(Main.osgi.getService(IBattleSettings));
      }
      
      private function changeUILockCount(delta:int) : void
      {
         this.uiLockCount = this.uiLockCount + delta;
         if(this.uiLockCount < 0)
         {
            this.uiLockCount = 0;
         }
      }
      
      private function incCameraUnlockCounter() : void
      {
         this.cameraUnlockCounter = this.cameraUnlockCounter + 1;
         if(this.cameraUnlockCounter == 2)
         {
            this.doRender = true;
         }
      }
      
      private function updatePanelUnlockCounter() : void
      {
         var modelService:IModelService = null;
         var panelModel:IPanel = null;
         if(this.panelUnlockCounter == 0)
         {
            return;
         }
         this.panelUnlockCounter--;
         if(this.panelUnlockCounter == 0)
         {
            modelService = IModelService(Main.osgi.getService(IModelService));
            panelModel = IPanel(modelService.getModelsByInterface(IPanel)[0]);
            panelModel.partSelected(4);
         }
      }
      
      private function onToggleTextureDebug(console:IConsole, params:Array) : void
      {
         if(this.toggleTextureDebug())
         {
            console.addLine("Debug textures enabled");
         }
         else
         {
            console.addLine("Debug textures disabled");
         }
      }
   }
}

class TimeStatistics
{
    
   
   public var timeAccum:Number = 0;
   
   public var stepCounter:int;
   
   public var numSteps:int = 10;
   
   public var avrgTime:Number = 0;
   
   public var avrgFps:Number = 100;
   
   function TimeStatistics()
   {
      super();
   }
}
