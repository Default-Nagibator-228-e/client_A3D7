package
{
   import alternativa.init.BattlefieldGUIActivator;
   import alternativa.init.BattlefieldModelActivator;
   import alternativa.init.BattlefieldSharedActivator;
   import alternativa.init.Main;
   import alternativa.init.TanksWarfareActivator;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.register.ClientClass;
   import alternativa.tanks.gui.resource.ResourceType;
   import alternativa.tanks.gui.resource.ResourceUtil;
   import alternativa.service.IModelService;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.model.BattleSelectModel;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.StatisticsModel;
   import alternativa.tanks.models.battlefield.gamemode.GameModes;
   import alternativa.tanks.models.battlefield.gamemode.IGameMode;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.gui.Physics;
   import alternativa.tanks.models.battlefield.gui.chat.ChatModel;
   import alternativa.tanks.models.battlefield.gui.statistics.fps.FPSText;
   import alternativa.tanks.models.battlefield.hp.HP;
   import alternativa.tanks.models.ctf.CTFModel;
   import alternativa.tanks.models.effects.zone.Zone;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.tank.explosion.ITankExplosionModel;
   import alternativa.tanks.models.tank.explosion.TankExplosionModel;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonModel;
   import alternativa.tanks.models.weapon.flamethrower.FlamethrowerModel;
   import alternativa.tanks.models.weapon.flamethrower.IFlamethrower;
   import alternativa.tanks.models.weapon.freeze.FreezeModel;
   import alternativa.tanks.models.weapon.gun.SmokyModel;
   import alternativa.tanks.models.weapon.healing.HealingGunModel;
   import alternativa.tanks.models.weapon.plasma.PlasmaModel;
   import alternativa.tanks.models.weapon.railgun.RailgunModel;
   import alternativa.tanks.models.weapon.ricochet.RicochetModel;
   import alternativa.tanks.models.weapon.shaft.ShaftModel;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.models.weapon.snowman.SnowmanModel;
   import alternativa.tanks.models.weapon.thunder.ThunderModel;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.models.weapon.weakening.WeaponWeakeningModel;
   import alternativa.tanks.vehicles.tanks.TankPhysicsData;
   import flash.net.Socket;
   import flash.text.TextFieldAutoSize;
   //import com.adobe.tvsdk.mediacore.utils.TimeRange;
   import utils.client.commons.types.DeathReason;
   import utils.client.commons.types.TankParts;
   import utils.client.commons.types.TankSpecification;
   import utils.client.commons.types.TankState;
   import utils.client.commons.types.Vector3d;
   import utils.client.models.battlefield.BattlefieldSoundScheme;
   import utils.client.models.ctf.ClientFlag;
   import utils.client.models.ctf.FlagsState;
   import utils.client.models.ctf.ICaptureTheFlagModelBase;
   import utils.client.models.tank.ClientTank;
   import utils.client.models.tank.TankSpawnState;
   import utils.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   import utils.client.warfare.models.tankparts.weapon.healing.struct.IsisAction;
   import utils.client.warfare.models.tankparts.weapon.railgun.IRailgunModelBase;
   import utils.reygazu.anticheat.events.CheatManagerEvent;
   import utils.reygazu.anticheat.managers.CheatManager;
   import controls.Label;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import forms.Alert;
   import utils.client.battlefield.gui.models.effectsvisualization.BattleEffect;
   import utils.client.battlefield.gui.models.statistics.BattleStatInfo;
   import utils.client.battlefield.gui.models.statistics.UserStat;
   import utils.client.battleselect.IBattleSelectModelBase;
   import utils.client.battleservice.model.team.BattleTeamType;
   import alternativa.tanks.gui.AlertBugWindow;
   import alternativa.tanks.gui.ServerMessage;
   import alternativa.network.INetworkListener;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.network.commands.Command;
   import alternativa.network.commands.Type;
   import alternativa.service.server.models.inventory.ServerInventoryData;
   import alternativa.service.server.models.inventory.ServerInventoryModel;
   import alternativa.service.server.models.mines.ServerBattleMinesModel;
   import alternativa.tanks.utils.WeaponsManager;
   import flash.utils.setTimeout;
   import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.Keyboard;
	import flash.utils.*;
	import utils.FontParamsUtil;
   
   public class BattleController implements INetworkListener
   {
      
      public static var activeTanks:Dictionary;
      
      public static var localTankInited:Boolean = false;
      
      public static var client:ClientObject;
      
      private static var railgunModel:RailgunModel;
      
      private static var smokyModel:SmokyModel;
      
      private static var flamethrowerModel:FlamethrowerModel;
      
      private static var twinsModel:PlasmaModel;
      
      private static var isidaModel:HealingGunModel;
      
      private static var thunderModel:ThunderModel;
      
      private static var frezeeModel:FreezeModel;
      
      private static var ricochetModel:RicochetModel;
      
      private static var shaftModel:ShaftModel;
      
      private static var snowmanModel:SnowmanModel;
       
      
      public var battle:BattlefieldModelActivator;
      
      private var preparedPos:Vector3d;
      
      private var myTank:ClientTank;
      
      private var ctfObj:ClientObject;
      
      private var serverInventoryModel:ServerInventoryModel;
      
      private var serverMinesModel:ServerBattleMinesModel;
      
      public var testLabelPing:Label;
	  
	  public var testPhysic:Physics;
	  
	  private var pi:uint = 0;
	  
	  public var de:Label;
	  
	  public var mt:Array = null;
	  
	  public var mh:Array = null;
	  
	  public var pmt:Array = null;
	  
	  public var pmh:Array = null;
	  
	  private var zone:Zone = new Zone();
	  
	  public var startTime:uint;
	  
	  private var time:uint;
	  
	  private var sock:Socket;
	  
	  private var tim:Timer;
      
      public function BattleController()
      {
         this.ctfObj = new ClientObject("ctfModel",null,"ctfModelObj",null);
         this.serverInventoryModel = new ServerInventoryModel();
         this.serverMinesModel = new ServerBattleMinesModel();
         super();
         var models:TanksWarfareActivator = new TanksWarfareActivator();
         models.start(Main.osgi);
         var gui:BattlefieldGUIActivator = new BattlefieldGUIActivator();
         gui.start(Main.osgi);
         var shared:BattlefieldSharedActivator = new BattlefieldSharedActivator();
         shared.start(Main.osgi);
         this.battle = new BattlefieldModelActivator();
         this.battle.start(Main.osgi);
         var expl:TanksWarfareActivator = new TanksWarfareActivator();
         expl.start(Main.osgi);
         Main.osgi.registerService(IBattleField,this.battle.bm);
         activeTanks = new Dictionary();
         var explosionModel:TankExplosionModel = new TankExplosionModel();
         Main.osgi.registerService(ITankExplosionModel, explosionModel);
      }
	  
	  private function onconn(e:Event) : void {
			startTime = getTimer() - time;
			sock.close();
			if (testLabelPing != null && de != null)
			{
				if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
				 {
					 if (this.testLabelPing != null && Main.contentUILayer.contains(this.testLabelPing))
					 {
						Main.contentUILayer.removeChild(this.testLabelPing);
					 }
					 if (this.de != null && Main.contentUILayer.contains(this.de))
					 {
						Main.contentUILayer.removeChild(this.de);
					 }
					 return;
				 }
				 this.de.visible = true;
				 this.testLabelPing.visible = true;
				 if (startTime < 0)
				 {
					startTime = 0;
					//return;
				 }
				 if (startTime > 999)
				 {
					startTime = 999;
				 }
				 this.testLabelPing.text = startTime + "";
				 this.de.x = Main.contentLayer.stage.stageWidth - 46 - this.testLabelPing.width;
				 this.de.y = Main.contentLayer.stage.stageHeight - 75;
				 this.testLabelPing.textColor = 0xFF0000;
				 if(startTime<500) 
				 { 
					this.testLabelPing.textColor = 0xFFFF00;
				 } 
				 if(startTime<80) 
				 { 
					 this.testLabelPing.textColor = 0x33FF00;
				 }
				 this.testLabelPing.x = Main.contentLayer.stage.stageWidth - 46 + this.de.width - this.testLabelPing.width;
				 this.testLabelPing.y = Main.contentLayer.stage.stageHeight - 75;
			}
			tim = new Timer(2000,1);
			tim.addEventListener(TimerEvent.TIMER_COMPLETE, function(param1:Event):void
			{
				sock = new Socket("127.0.0.1",4894);
				time = getTimer();
				sock.addEventListener(Event.CONNECT,onconn);
			});
			tim.start();
		}
      
      public static function getWeaponController(obj:ClientObject) : IWeaponController
      {
         var weaponController:IWeaponController = null;
         var id:String = obj.id.split("_")[0];
         var turrEntity:* = WeaponsManager.specialEntity[obj.id];
         switch(id)
         {
            case "railgun":
               if(railgunModel == null)
               {
                  railgunModel = new RailgunModel();
               }
               railgunModel.initObject(obj,turrEntity.char,turrEntity.wae);
               railgunModel.objectLoaded(obj);
               weaponController = railgunModel;
               break;
            case "smoky":
               if(smokyModel == null)
               {
                  smokyModel = new SmokyModel();
               }
               smokyModel.objectLoaded(obj);
               weaponController = smokyModel;
               break;
            case "flamethrower":
               if(flamethrowerModel == null)
               {
                  flamethrowerModel = new FlamethrowerModel();
                  Main.osgi.registerService(IFlamethrower,flamethrowerModel);
               }
               flamethrowerModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.cone_angle,turrEntity.cooling_speed,turrEntity.heat_limit,turrEntity.heating_speed,turrEntity.range,turrEntity.target_detection_interval);
               weaponController = flamethrowerModel;
               break;
            case "twins":
               if(twinsModel == null)
               {
                  twinsModel = new PlasmaModel();
               }
               twinsModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.shot_radius,turrEntity.shot_range,turrEntity.shot_speed);
               weaponController = twinsModel;
               break;
            case "isida":
               if(isidaModel == null)
               {
                  isidaModel = new HealingGunModel();
               }
               isidaModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.angle,turrEntity.capacity,turrEntity.chargeRate,turrEntity.tickPeriod,turrEntity.coneAngle,turrEntity.dischargeRate,turrEntity.radius);
               weaponController = isidaModel;
               break;
            case "thunder":
               if(thunderModel == null)
               {
                  thunderModel = new ThunderModel();
               }
               thunderModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.impactForce,turrEntity.maxSplashDamageRadius,turrEntity.minSplashDamagePercent,turrEntity.minSplashDamageRadius);
               weaponController = thunderModel;
               break;
            case "frezee":
               if(frezeeModel == null)
               {
                  frezeeModel = new FreezeModel();
               }
               frezeeModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.damageAreaConeAngle,turrEntity.damageAreaRange,turrEntity.energyCapacity,turrEntity.energyDischargeSpeed,turrEntity.energyRechargeSpeed,turrEntity.weaponTickMsec);
               weaponController = frezeeModel;
               break;
            case "ricochet":
               if(ricochetModel == null)
               {
                  ricochetModel = new RicochetModel();
               }
               ricochetModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.energyCapacity,turrEntity.energyPerShot,turrEntity.energyRechargeSpeed,turrEntity.shotDistance,turrEntity.shotRadius,turrEntity.shotSpeed);
               weaponController = ricochetModel;
               break;
            case "shaft":
               if(shaftModel == null)
               {
                  shaftModel = new ShaftModel();
               }
			   shaftModel.objectLoaded(obj);
               weaponController = shaftModel;
               break;
            case "snowman":
               if(snowmanModel == null)
               {
                  snowmanModel = new SnowmanModel();
               }
               snowmanModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.shot_radius,turrEntity.shot_range,turrEntity.shot_speed);
               weaponController = snowmanModel;
         }
         return weaponController;
      }
      
      public function onData(data:Command) : void
      {
         var parser:Object = null;
         var battle:BattleStatInfo = null;
         var users:Array = null;
         var i:int = 0;
         var obj:Object = null;
         var tempArr:Array = null;
         var pos:Vector3d = null;
         var alertWindow:Alert = null;
         var json:Object = null;
         var ctfModel:CTFModel = null;
         var flagsState:FlagsState = null;
         var blueFlag:ClientFlag = null;
         var redFlag:ClientFlag = null;
         var table:ServerMessage = null;
         var jsParser:Object = null;
         var items:Array = null;
         var item:Object = null;
         var _item:ServerInventoryData = null;
         var jsArray:Object = null;
         var effects:Array = null;
         var effect:BattleEffect = null;
         var alert:AlertBugWindow = null;
         try
         {
            switch(data.type)
            {
               case Type.BATTLE:
				   switch(data.args[0])
					{
					  case "init_battle_model":
						 this.initBattle(data.args[1]);
						 break;
					  case "init_gui_model":
						 parser = JSON.parse(data.args[1]);
						 battle = new BattleStatInfo();
						 battle.blueScore = parser.score_blue;
						 battle.fund = parser.fund;
						 battle.redScore = parser.score_red;
						 battle.scoreLimit = parser.scoreLimit;
						 battle.teamPlay = parser.team;
						 battle.timeLeft = parser.currTime;
						 battle.timeLimit = parser.timeLimit;
						 PanelModel(Main.osgi.getService(IPanel)).isInBattle = true;
						 users = new Array();
						 StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).initObject(null,parser.name);
						 i = 0;
						 for each(obj in parser.users)
						 {
							users[i] = new UserStat(0,0,obj.nickname,obj.rank,0,0,BattleTeamType.getType(obj.teamType),obj.nickname,0);
							i++;
						 }
						 StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).init(new ClientObject("bfObject",null,"bfObject",null),battle,users);
						 ChatModel(Main.osgi.getService(IChatBattle)).objectLoaded(null);
						 PanelModel(Main.osgi.getService(IPanel)).unlock();
						 this.serverMinesModel.init();
						 sock = new Socket("213.108.4.22",4894);
						 time = getTimer();
						 sock.addEventListener(Event.CONNECT,onconn);
						 CheatManager.getInstance().addEventListener(CheatManagerEvent.CHEAT_DETECTION, Game.onUserEntered);
						 break;
					  case "init_tank":
						 this.initTank(data.args[1]);
						 break;
					  case "activate_tank":
						 if(activeTanks[data.args[1]] != null)
						 {
							TankModel(Main.osgi.getService(ITank)).activateTank(activeTanks[data.args[1]]);
						 }
						 break;
					  case "krit":
						 if(activeTanks[data.args[1]] != null)
						 {
							TankModel(Main.osgi.getService(ITank)).krit(activeTanks[data.args[1]]);
						 }
						 break;
					  case "kill_tank":
						 if(activeTanks[data.args[1]] != null)
						 {
							TankModel(Main.osgi.getService(ITank)).kill(activeTanks[data.args[1]],DeathReason.getReason(data.args[2]),data.args[3]);
						 }
						 break;
					  case "kill_tank1":
						 if(activeTanks[data.args[1]] != null)
						 {
							TankModel(Main.osgi.getService(ITank)).kill1(activeTanks[data.args[1]],DeathReason.getReason(data.args[2]),data.args[3]);
						 }
						 break;
					  case "prepare_to_spawn":
						 if(activeTanks[data.args[1]] != null)
						 {
							tempArr = String(data.args[2]).split("@");
							pos = new Vector3d(tempArr[0],tempArr[1],tempArr[2]);
							TankModel(Main.osgi.getService(ITank)).prepareToSpawn(activeTanks[data.args[1]], pos, new Vector3d(0, 0, tempArr[3]));
						 }
						 break;
					  case "spawn":
						 this.parseSpawnCommand(data.args[1]);
						 break;
					  case "init_physics":
						 this.parsePhysics(data.args[1]);
						 break;
					  case "init_physics_p_t":
						 this.parsePhysicsPT(data.args[1]);
						 break;
					  case "init_physics_p_h":
						 this.parsePhysicsPH(data.args[1]);
						 break;
					  case "move":
						 this.moveTank(data.args[1]);
						 break;
					  case "chat":
						 this.onChatMessage(data.args[1]);
						 break;
					  case "spectator_message":
						 ChatModel(Main.osgi.getService(IChatBattle)).addSpectatorMessage(data.args[1]);
						 break;
					  case "remove_user":
						 this.removeUser(data.args[1]);
						 break;
					  case "z":
                        this.parseZone(data.args[1]);
						break;
					  case "res_user":
						 this.resUser(data.args[1]);
						 break;
					  case "res1_user":
						 this.resUser1(data.args[1]);
						 break;
					  case "tank_smooth":
                         this.tankSmooth(data.args[1]);
						 break;
					 case "spawn_bonus":
                        this.parseSpawnBonus(data.args[1]);
						break;
					 case "parse_bonus":
                        this.parseSpawnBonus1(data.args[1]);
						break;
                     case "take_bonus_by":
                        BattlefieldModel(Main.osgi.getService(IBattleField)).bonusTaken(null, data.args[1]);
						break;
                     case "user_log":
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).logUserAction(data.args[1], data.args[2]);
						break;
                     case "set_cry":
                        PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null, int(data.args[1]));
						break;
					 case "gold":
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).ctfMessages.addMessage(0xFFA500, "Скоро будет сброшен золотой ящик");
						BattlefieldModel(Main.osgi.getService(IBattleField)).soundManager.playSound(ResourceUtil.getResource(ResourceType.SOUND, "gold").sound, 0, 1);
						break;
					 case "remove_bonus":
                        BattlefieldModel(Main.osgi.getService(IBattleField)).removeBonus(null, data.args[1]);
						break;
                     case "start_fire":
                        this.parseStartFire(activeTanks[data.args[1]], data.args[1], data.args.length > 2?data.args[2]:"");
						break;
                     case "fire":
                        this.parseFire(activeTanks[data.args[1]], data.args[2]);
						break;
					 case "hp":
                        this.parseHP(activeTanks[data.args[1]], data.args[2], int(data.args[3]));
						break;
                     case "change_health":
                        TankModel(Main.osgi.getService(ITank)).changeHealth(activeTanks[data.args[1]], data.args[2]);
						break;
                     case "init_shots_data":
                        this.parseShotsData(data.args[1]);
						break;
                     case "stop_fire":
                        this.parseStopFire(activeTanks[data.args[1]], data.args[1]);
						break;
                     case "kick_for_cheats":
                        Network(Main.osgi.getService(INetworker)).destroy();
                        BattlefieldModel(Main.osgi.getService(IBattleField)).objectUnloaded(null);
                        BattleController(Main.osgi.getService(IBattleController)).destroy();
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).objectUnloaded(null);
                        ChatModel(Main.osgi.getService(IChatBattle)).objectUnloaded(null);
                        for(i = 0; i < Main.mainContainer.numChildren; i++)
                        {
                           Main.mainContainer.removeChildAt(1);
                        }
                        IBackgroundService(Main.osgi.getService(IBackgroundService)).drawBg();
                        IBackgroundService(Main.osgi.getService(IBackgroundService)).showBg();
                        alertWindow = new Alert(-1,true);
                        alertWindow._msg = "Вы не понравились античиту";
                        Main.systemUILayer.addChild(alertWindow);
						break;
                     case "update_player_statistic":
                        this.parseUpdatePlayerStatistic(data.args[1]);
						break;
                     case "change_fund":
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).fundChange(null, data.args[1]);
						break;
                     case "battle_finish":
                        this.parseFinishBattle(data.args[1]);
						break;
                     case "battle_restart":
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).restart(null,data.args[1]);
                        BattlefieldModel(Main.osgi.getService(IBattleField)).battleRestart(null);
						break;
                     case "start_fire_twins":
                        this.parseStartFireTwins(activeTanks[data.args[1]], data.args[2]);
						break;
                     case "start_fire_snowman":
                        this.parseStartFireSnowman(activeTanks[data.args[1]], data.args[2]);
						break;
                     case "change_spec_tank":
                        this.parseChangeSpecTank(activeTanks[data.args[1]], data.args[2]);
						break;
                     case "change_temperature_tank":
                        TankModel(Main.osgi.getService(ITank)).setTemperature(activeTanks[data.args[1]], data.args[2]);
						break;
                     case "fire_ricochet":
                        this.parseRicochetFire(data.args[1], data.args[2]);
						break;
                     case "change_team_scores":
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).changeTeamScore(null, BattleTeamType.getType(data.args[1]), data.args[2]);
						break;
                     case "init_ctf_model":
                        json = JSON.parse(data.args[1]);
                        ctfModel = new CTFModel();
                        ctfModel.initObject(this.ctfObj,"flagBlueModel_pedestal","flagBlueModel_img","flagBlue","flagRedModel_pedestal","flagRedModel_img","flagRed",null,new Vector3(json.posBlueFlag.x,json.posBlueFlag.y,json.posBlueFlag.z),new Vector3(json.posRedFlag.x,json.posRedFlag.y,json.posRedFlag.z));
                        flagsState = new FlagsState();
                        blueFlag = new ClientFlag();
                        blueFlag.flagBasePosition = new Vector3(json.basePosBlueFlag.x,json.basePosBlueFlag.y,json.basePosBlueFlag.z);
                        blueFlag.flagPosition = new Vector3(json.posBlueFlag.x,json.posBlueFlag.y,json.posBlueFlag.z);
                        blueFlag.flagCarrierId = json.blueFlagCarrierId;
                        redFlag = new ClientFlag();
                        redFlag.flagBasePosition = new Vector3(json.basePosRedFlag.x,json.basePosRedFlag.y,json.basePosRedFlag.z);
                        redFlag.flagPosition = new Vector3(json.posRedFlag.x,json.posRedFlag.y,json.posRedFlag.z);
                        redFlag.flagCarrierId = json.redFlagCarrierId;
                        flagsState.blueFlag = blueFlag;
                        flagsState.redFlag = redFlag;
                        ctfModel.initFlagsState(this.ctfObj,flagsState);
                        Main.osgi.registerService(ICaptureTheFlagModelBase, ctfModel);
						break;
                     case "flagTaken":
                        CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase)).flagTaken(null, data.args[1], BattleTeamType.getType(data.args[2]));
						break;
                     case "deliver_flag":
                        CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase)).flagDelivered(null, BattleTeamType.getType(data.args[1]), data.args[2]);
						break;
                     case "flag_drop":
                        json = JSON.parse(data.args[1]);
                        CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase)).dropFlag(null, new Vector3d(json.x, json.y, json.z), BattleTeamType.getType(json.flagTeam));
						break;
                     case "return_flag":
                        CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase)).returnFlagToBase(null, BattleTeamType.getType(data.args[1]), data.args[2]);
						break;
                     case "show_warning_table":
                        table = new ServerMessage(data.args[1]);
                        Main.stage.addChild(table);
						break;
                     case "change_user_team":
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).changeUserTeam(null, data.args[1], BattleTeamType.getType(data.args[2]));
						break;
                     case "init_inventory":
                        this.serverInventoryModel.init();
                        jsParser = JSON.parse(data.args[1]);
                        items = new Array();
                        for each(item in jsParser.items)
                        {
                           _item = new ServerInventoryData();
                           _item.count = item.count;
                           _item.id = item.id;
                           _item.itemEffectTime = item.itemEffectTime;
                           _item.itemRestSec = item.itemRestSec;
                           _item.slotId = item.slotId;
                           items.push(_item);
                        }
                        this.serverInventoryModel.initInventory(items);
						break;
                     case "activate_item":
                        this.serverInventoryModel.activateItem(data.args[1]);
						break;
					 case "activate_itemb":
                        this.serverInventoryModel.activateItemb(data.args[1]);
						break;
                     case "enable_effect":
                        this.serverInventoryModel.enableEffect(activeTanks[data.args[1]], data.args[2], data.args[3]);
						break;
                     case "disnable_effect":
                        this.serverInventoryModel.disnableEffect(activeTanks[data.args[1]], data.args[2]);
						break;
                     case "init_effects":
                        jsArray = JSON.parse(data.args[1]);
                        effects = new Array();
                        for each(obj in jsArray.effects)
                        {
                           effect = new BattleEffect();
                           effect.durationTime = obj.durationTime;
                           effect.itemIndex = obj.itemIndex;
                           effect.userID = obj.userID;
                           effects.push(effect);
                        }
                        this.serverInventoryModel.enableEffects(effects);
						break;
                     case "local_user_killed":
                        this.serverInventoryModel.localTankKilled();
						break;
                     case "init_mine_model":
                        this.serverMinesModel.initModel(data.args[1]);
						break;
                     case "remove_mines":
                        this.serverMinesModel.removeMines(data.args[1]);
						break;
                     case "put_mine":
                        json = JSON.parse(data.args[1]);
                        this.serverMinesModel.putMine(activeTanks[json.userId], json);
						break;
                     case "activate_mine":
                        this.serverMinesModel.activateMine(data.args[1]);
						break;
                     case "hit_mine":
                        this.serverMinesModel.hitMine(activeTanks[data.args[2]], data.args[1]);
						break;
                     case "init_mines":
                        this.serverMinesModel.initMines(data.args[1]);
					}
            }
         }
         catch(e:Error)
         {
			throw new Error(e.getStackTrace());
            alert = new AlertBugWindow();
            alert.text = "Произошла ошибка: " + e.getStackTrace();
            //Main.systemUILayer.addChild(alert);
         }
      }
      
      private function parseRicochetFire(tankId:String, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var user:ClientObject = activeTanks[tankId];
         ricochetModel.hit(user,parser.victim,new Vector3d(parser.hitPos3d.x,parser.hitPos3d.y,parser.hitPos3d.z),parser.x,parser.y,parser.z,1);
      }
      
      private function parseChangeSpecTank(client:ClientObject, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var tankSpec:TankSpecification = new TankSpecification();
         tankSpec.speed = parser.speed;
         tankSpec.turnSpeed = parser.turnSpeed;
         tankSpec.turretRotationSpeed = parser.turretRotationSpeed;
		 TankModel(Main.osgi.getService(ITank)).getTankData(client).tank.tpd.maxForwardSpeed = parser.speed;
		 TankModel(Main.osgi.getService(ITank)).getTankData(client).tank.tpd.maxBackwardSpeed = parser.speed;
		 TankModel(Main.osgi.getService(ITank)).getTankData(client).tank.tpd.maxTurnSpeed = parser.turnSpeed;
         TankModel(Main.osgi.getService(ITank)).changeSpecification(client,tankSpec,parser.immediate);
      }
      
      private function parseStartFireSnowman(user:ClientObject, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         snowmanModel.fire(user,user.id,parser.realShotId,new Vector3d(parser.dirToTarget.x,parser.dirToTarget.y,parser.dirToTarget.z));
      }
      
      private function parseStartFireTwins(user:ClientObject, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         twinsModel.fire(user,user.id,parser.currBarrel,parser.realShotId,new Vector3d(parser.dirToTarget.x,parser.dirToTarget.y,parser.dirToTarget.z));
      }
      
      private function parseFinishBattle(json:String) : void
      {
         var obj:Object = null;
         var stat:UserStat = null;
         var parser:Object = JSON.parse(json);
         var users:Array = new Array();
         for each(obj in parser.users)
         {
            stat = new UserStat(obj.kills,obj.deaths,obj.id,obj.rank,obj.score,obj.prize,BattleTeamType.getType(obj.team_type),obj.id,obj.zv);
            users.push(stat);
         }
         StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).finish(null,users,parser.time_to_restart / 1000);
         BattlefieldModel(Main.osgi.getService(IBattleField)).battleFinish(null);
      }
      
      private function parseUpdatePlayerStatistic(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var stat:UserStat = new UserStat(parser.kills,parser.deaths,parser.id,parser.rank,parser.score,0,BattleTeamType.getType(parser.team_type),parser.id,parser.zv);
         StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).changeUsersStat(null,new Array(stat));
      }
	  
	  private function parseZone(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         zone.ded(new Vector3(parser.x+50,parser.y+50,parser.z-1199),parser.type);
      }
      
      private function parseSpawnCommand(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var pos:Vector3d = new Vector3d(parser.x,parser.y,parser.z);
         var rot:Vector3d = new Vector3d(0,0,parser.rot);
         var tankSpec:TankSpecification = new TankSpecification();
         tankSpec.speed = parser.speed;
         tankSpec.turnSpeed = parser.turn_speed;
         tankSpec.turretRotationSpeed = parser.turret_rotation_speed;
         TankModel(Main.osgi.getService(ITank)).spawn(activeTanks[parser.tank_id],tankSpec,BattleTeamType.getType(parser.team_type),pos,rot,parser.health,parser.incration_id);
      }
      
      private function parseShotsData(js:String) : void
      {
         var obj:Object = null;
         var shotData:ShotData = null;
         var specialEntity:* = undefined;
         var parser:Object = JSON.parse(js);
         var models:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var wwm:WeaponWeakeningModel = WeaponWeakeningModel(models.getModelsByInterface(IWeaponWeakeningModel)[0]);
         for each(obj in parser.weapons)
         {
            shotData = new ShotData(obj.reload);
            shotData.autoAimingAngleDown.value = obj.auto_aiming_down;
            shotData.autoAimingAngleUp.value = obj.auto_aiming_up;
            shotData.numRaysDown.value = obj.num_rays_down;
            shotData.numRaysUp.value = obj.num_rays_up;
            if(obj.has_wwd)
            {
               wwm.initObject(WeaponsManager.getObjectFor(obj.id),obj.max_damage_radius,obj.minimumDamagePercent,obj.minimumDamageRadius);
            }
            specialEntity = obj.special_entity;
            WeaponsManager.shotDatas[obj.id] = shotData;
            WeaponsManager.specialEntity[obj.id] = specialEntity;
         }
      }
      
      private function parseStopFire(user:ClientObject, firing:String) : void
      {
         var flamethrower:FlamethrowerModel = null;
         var models:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var td:TankData = TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[user.id] as ClientObject);
         var id:String = td.turret.id.split("_")[0];
         switch(id)
         {
            case "flamethrower":
               flamethrower = Main.osgi.getService(IFlamethrower) as FlamethrowerModel;
               flamethrower.stopFire(user,firing);
               break;
            case "isida":
               isidaModel.stopWeapon(user,firing);
               break;
            case "frezee":
               frezeeModel.stopFire(user,firing);
         }
      }
	  
	  private function parseHP(user:ClientObject, f:int, fi:int) : void
      {
         var td:TankData = TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[user.id] as ClientObject);
         var sdf:Label = new Label();
		 sdf.text = f + "";
		 sdf.filters = [new GlowFilter(0,0.8,4,4,3)];
		 //sdf.bold = true;
		 //sdf.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
         //sdf.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
		 sdf.size = 18;
		 if (fi == 1)
		 {
			 sdf.textColor = 0xffffff;
		 }
		 if (fi == 2)
		 {
			 sdf.textColor = 0x008000;
		 }
		 if (fi == 3)
		 {
			 sdf.textColor = 0xffff00;
		 }
		 if (fi == 0)
		 {
			 sdf.textColor = 0xFF0000;
		 }
		 var rt:BitmapData = new BitmapData(sdf.textWidth+20, sdf.textHeight + 10,true,16777215);
		 var m: Matrix = new Matrix();
		 m.scale(1, 1);
		 rt.draw(sdf, m);
		 var h:HP = new HP(this.battle.bm);
		 h.init(rt, 5000000, 5000, 180, 1, 0.15);
		 h.addTankHP(td);
      }
      
      private function parseStartFire(param1:ClientObject, param2:String, param3:String) : void
      {
         var _loc4_:IModelService = null;
         var _loc7_:RailgunModel = null;
         var _loc8_:FlamethrowerModel = null;
         var _loc9_:IsisAction = null;
         var _loc10_:Object = null;
         _loc4_ = Main.osgi.getService(IModelService) as IModelService;
         var _loc5_:TankData = TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[param1.id] as ClientObject);
         var _loc6_:String = _loc5_.turret.id.split("_")[0];
         switch(_loc6_)
         {
            case "railgun":
               _loc7_ = _loc4_.getModelsByInterface(IRailgunModelBase)[0] as RailgunModel;
               _loc7_.startFire(param1,param2);
               break;
            case "flamethrower":
               _loc8_ = Main.osgi.getService(IFlamethrower) as FlamethrowerModel;
               _loc8_.startFire(param1,param2);
               break;
            case "isida":
               _loc9_ = new IsisAction();
               _loc10_ = JSON.parse(param3);
               _loc9_.shooterId = _loc10_.shooterId;
               _loc9_.targetId = _loc10_.targetId;
               _loc9_.type = IsisActionType.getType(_loc10_.type);
               isidaModel.startWeapon(param1,_loc9_);
               break;
            case "frezee":
               frezeeModel.startFire(param1,param2);
               break;
            case "ricochet":
               _loc10_ = JSON.parse(param3);
               ricochetModel.fire(param1,param2,_loc10_.x,_loc10_.y,_loc10_.z);
         }
      }
	  
	  private function parsePhysics(js:String) : void
      {
         var parser:Object = null;
         try
         {
            parser = JSON.parse(js);
         }
         catch(e:Error)
         {
            return;
         }
		 this.mt = parser.pt as Array;
         this.mh = parser.ph as Array;
      }
	  
	  private function parsePhysicsPT(js:String) : void
      {
		 pmt = js.split("&");
		 pmt.removeAt(pmt.length - 1);
		 //throw new Error(js);
      }
	  
	  private function parsePhysicsPH(js:String) : void
      {
         pmh = js.split("&");
		 pmh.removeAt(pmh.length - 1);
		 Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onPressed1);
      }
	  
	  private function onPressed1(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.F7)
         {
            if (testPhysic == null)
			{
				testPhysic = new Physics();
			}else{
				testPhysic.er();
			}
			testPhysic.visible ? Main.blur3() : Main.unblur();
         }
      }
      
      private function parseFire(user:ClientObject, js:String) : void
      {
         var parser:Object = null;
         var td:TankData = null;
         var targetInc:Array = null;
         var hitPoints:Array = null;
         var targets:Array = null;
         var targetPostitions:Array = null;
         var railgun:RailgunModel = null;
         var hitPoint:Vector3d = null;
         var smoky:SmokyModel = null;
         var hitPos:Vector3d = null;
         var i:int = 0;
         parser = null;
         try
         {
            parser = JSON.parse(js);
         }
         catch(e:Error)
         {
            return;
         }
         td = TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[user.id] as ClientObject);
         var id:String = td.turret.id.split("_")[0];
         switch(id)
         {
            case "railgun":
               targetInc = parser.targetInc as Array;
               hitPoints = parser.hitPoints as Array;
               targets = parser.targets as Array;
               targetPostitions = parser.targetPostitions as Array;
               for(i = 0; i < hitPoints.length; i++)
               {
                  hitPoints[i] = this.objToVec3d(hitPoints[i]);
               }
               railgun = getWeaponController(td.turret) as RailgunModel;
               railgun.fire(user,user.id,hitPoints,targets);
               break;
            case "smoky":
               if(parser.hitPos != null)
               {
                  hitPoint = new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z);
               }
               smoky = getWeaponController(td.turret) as SmokyModel;
               smoky.fire(user,user.id,hitPoint,parser.victimId,1);
               break;
            case "twins":
               twinsModel.hit(user,user.id,parser.shotId,new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z),parser.victimId,0.3);
               break;
            case "thunder":
               if(parser.hitPos != null)
               {
                  hitPos = new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z);
               }
               thunderModel.fire(user,user.id,hitPos,parser.mainTargetId,1,parser.splashTargetIds,null);
               break;
            case "shaft":
			   if(parser.hitPos != null)
               {
                  hitPoint = new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z);
               }
               shaftModel = getWeaponController(td.turret) as ShaftModel;
               shaftModel.fire(user,user.id,hitPoint,parser.victimId,1);
               break;
            case "snowman":
               snowmanModel.hit(user,user.id,parser.shotId,new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z),parser.victimId,0.3);
         }
      }
      
      private function objToVec3d(obj:Object) : Vector3d
      {
         return new Vector3d(obj.x,obj.y,obj.z);
      }
	  
	  private function parseSpawnBonus1(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var client:ClientClass = new ClientClass(parser.id,null,parser.id,null);
         var bonus_obj:ClientObject = new ClientObject(parser.id,client,client.name,null);
         BattlefieldModel(Main.osgi.getService(IBattleField)).addBonus1(bonus_obj,parser.id,parser.id,new Vector3d(parser.x,parser.y,parser.z),parser.disappearing_time);
      }
      
      private function parseSpawnBonus(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var client:ClientClass = new ClientClass(parser.id,null,parser.id,null);
         var bonus_obj:ClientObject = new ClientObject(parser.id,client,client.name,null);
         BattlefieldModel(Main.osgi.getService(IBattleField)).addBonus(bonus_obj,parser.id,parser.id,new Vector3d(parser.x,parser.y,parser.z),parser.disappearing_time);
      }
      
      private function controlSmooth(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var turrDir:Number = parser.turretDir;
         var ctrlBits:int = parser.ctrlBits;
         if(activeTanks[parser.tank_id] != null)
         {
            TankModel(Main.osgi.getService(ITank)).setControlState(TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[parser.tank_id]),ctrlBits);
         }
      }
      
      private function tankSmooth(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var pos:Vector3d = new Vector3d(0,0,0);
         var orient:Vector3d = new Vector3d(0,0,0);
         var line:Vector3d = new Vector3d(0,0,0);
         var ange:Vector3d = new Vector3d(0,0,0);
         pos.x = parser.position.x;
         pos.y = parser.position.y;
         pos.z = parser.position.z;
         orient.x = parser.orient.x;
         orient.y = parser.orient.y;
         orient.z = parser.orient.z;
         line.x = parser.line.x;
         line.y = parser.line.y;
         line.z = parser.line.z;
         ange.x = parser.angle.x;
         ange.y = parser.angle.y;
         ange.z = parser.angle.z;
         var turrDir:Number = parser.turretDir;
         var ctrlBits:int = parser.ctrlBits;
         if(activeTanks[parser.tank_id] != null)
         {
            TankModel(Main.osgi.getService(ITank)).move(activeTanks[parser.tank_id] as ClientObject,pos,orient,line,ange,turrDir,ctrlBits,false);
         }
      }
      
      private function tracePing(ping:Number) : void
      {
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			 if (this.testLabelPing != null && Main.contentUILayer.contains(this.testLabelPing))
			 {
				Main.contentUILayer.removeChild(this.testLabelPing);
			 }
			 if (this.de != null && Main.contentUILayer.contains(this.de))
			 {
				Main.contentUILayer.removeChild(this.de);
			 }
			 return;
		 }
		 this.de.visible = true;
		 this.testLabelPing.visible = true;
		 if (ping < 0)
		 {
			ping = 0;
		 }
		 if (ping > 999)
		 {
			ping = 999;
		 }
		 this.testLabelPing.text = ping + "";
		 this.de.x = Main.contentLayer.stage.stageWidth - 46 - this.testLabelPing.width;
         this.de.y = Main.contentLayer.stage.stageHeight - 75;
		 this.testLabelPing.textColor = 0xFF0000;
		 if(ping<500)
		 { 
			this.testLabelPing.textColor = 0xFFFF00;
		 } 
		 if(ping<80) 
		 { 
			 this.testLabelPing.textColor = 0x33FF00;
		 }
         this.testLabelPing.x = Main.contentLayer.stage.stageWidth - 46 + this.de.width - this.testLabelPing.width;
         this.testLabelPing.y = Main.contentLayer.stage.stageHeight - 75;
      }
      
      private function removeUser(s:String) : void
      {
		 var dsw:TankModel = TankModel(Main.osgi.getService(ITank));
		 if (activeTanks[s] != null)
		 {
			dsw.objectUnloaded(activeTanks[s]);
			StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).userDisconnect(null, dsw.getTankData(activeTanks[s]).userName);
		 }
      }
	  
	  private function resUser(s:String) : void
      {
         TankModel(Main.osgi.getService(ITank)).objectUnloaded(activeTanks[s]);
      }
	  
	  private function resUser1(js:String) : void
      {
         var state:TankState = null;
         var json:Object = JSON.parse(js);
         var tankParts:TankParts = new TankParts();
         tankParts.coloringObjectId = json.colormap_id;
         tankParts.hullObjectId = json.hull_id;
         tankParts.turretObjectId = json.turret_id;
		 var tp:TankPhysicsData = new TankPhysicsData();
		 tp.mass = json.mass;
		 tp.power = json.power;
		 tp.maxForwardSpeed = json.maxForwardSpeed;
		 tp.maxBackwardSpeed = json.maxBackwardSpeed;
		 tp.maxTurnSpeed = json.maxTurnSpeed;
		 tp.springDamping = json.springDamping;
		 tp.drivingForceOffsetZ = json.drivingForceOffsetZ;
		 tp.smallVelocity = json.smallVelocity;
		 tp.rayRestLengthCoeff = json.rayRestLengthCoeff;
		 tp.dynamicFriction = json.dynamicFriction;
		 tp.brakeFriction = json.brakeFriction;
		 tp.sideFriction = json.sideFriction;
		 tp.spotTurnPowerCoeff = json.spotTurnPowerCoeff;
		 tp.spotTurnDynamicFriction = json.spotTurnDynamicFriction;
		 tp.spotTurnSideFriction = json.spotTurnSideFriction;
		 tp.moveTurnPowerCoeffOuter = json.moveTurnPowerCoeffOuter;
		 tp.moveTurnPowerCoeffInner = json.moveTurnPowerCoeffInner;
		 tp.moveTurnDynamicFrictionInner = json.moveTurnDynamicFrictionInner;
		 tp.moveTurnDynamicFrictionOuter = json.moveTurnDynamicFrictionOuter;
		 tp.moveTurnSideFriction = json.moveTurnSideFriction;
		 tp.moveTurnSpeedCoeffInner = json.moveTurnSpeedCoeffInner;
		 tp.moveTurnSpeedCoeffOuter = json.moveTurnSpeedCoeffOuter;
         var spec:TankSpecification = new TankSpecification();
         spec.speed = json.maxForwardSpeed;
         spec.turnSpeed = json.maxTurnSpeed;
         spec.turretRotationSpeed = json.turret_turn_speed;
         var position:Vector3d = new Vector3d(0,0,0);
         var temp:Array = String(json.position).split("@");
         position.x = int(temp[0]);
         position.y = int(temp[1]);
         position.z = int(temp[2]);
         if(!json.state_null)
         {
            state = new TankState();
            state.health = json.health;
            state.orientation = new Vector3d(0,0,temp[3]);
            state.position = position;
            state.turretAngle = 0;
         }
         var clientTank:ClientTank = new ClientTank();
         clientTank.health = json.health;
         clientTank.incarnationId = json.icration;
         clientTank.self = json.tank_id == client.id;
         var stateSpawn:String = json.state;
         clientTank.spawnState = stateSpawn == "newcome"?TankSpawnState.NEWCOME:stateSpawn == "active"?TankSpawnState.ACTIVE:stateSpawn == "suicide"?TankSpawnState.SUICIDE:TankSpawnState.ACTIVE;
         clientTank.tankSpecification = spec;
         clientTank.tankState = state;
         clientTank.teamType = BattleTeamType.getType(json.team_type);
         this.myTank = clientTank;
         var tankModelService:TankModel = Main.osgi.getService(ITank) as TankModel;
         if(clientTank.self)
         {
            localTankInited = true;
         }
         activeTanks[json.tank_id] = this.initClientObject(json.tank_id,json.tank_id);
         tankModelService.initObject(activeTanks[json.tank_id],json.battleId,json.mass,json.power,null,tankParts,null,json.impact_force,json.kickback,json.turret_rotation_accel,json.turret_turn_speed,json.nickname,json.rank,json.turret_id1);
         tankModelService.initTank(activeTanks[json.tank_id], clientTank, tankParts, false,tp);
		 StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).logUserAction(json.tank_id,"сменил вооружение");
	  }
      
      private function onChatMessage(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         if(!parser.system)
         {
            ChatModel(Main.osgi.getService(IChatBattle)).addMessage(null,null,parser.message,BattleTeamType.getType(parser.team_type),parser.team,parser.nickname,parser.rank);
         }
         else
         {
            ChatModel(Main.osgi.getService(IChatBattle)).addSystemMessage(null,parser.message);
         }
      }
      
      private function moveTank(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var pos:Vector3d = new Vector3d(0,0,0);
         var orient:Vector3d = new Vector3d(0,0,0);
         var line:Vector3d = new Vector3d(0,0,0);
         var ange:Vector3d = new Vector3d(0,0,0);
         pos.x = parser.position.x;
         pos.y = parser.position.y;
         pos.z = parser.position.z;
         orient.x = parser.orient.x;
         orient.y = parser.orient.y;
         orient.z = parser.orient.z;
         line.x = parser.line.x;
         line.y = parser.line.y;
         line.z = parser.line.z;
         ange.x = parser.angle.x;
         ange.y = parser.angle.y;
         ange.z = parser.angle.z;
         var turrDir:Number = parser.turretDir;
         var ctrlBits:int = parser.ctrlBits;
         if(activeTanks[parser.tank_id] != null)
         {
            TankModel(Main.osgi.getService(ITank)).move(activeTanks[parser.tank_id] as ClientObject,pos,orient,line,ange,turrDir,ctrlBits,true);
         }
      }
      
      private function initTank(js:String) : void
      {
         var state:TankState = null;
         var json:Object = JSON.parse(js);
         var tankParts:TankParts = new TankParts();
         tankParts.coloringObjectId = json.colormap_id;
         tankParts.hullObjectId = json.hull_id;
         tankParts.turretObjectId = json.turret_id;
		 var tp:TankPhysicsData = new TankPhysicsData();
		 tp.mass = json.mass;
		 tp.power = json.power;
		 tp.maxForwardSpeed = json.maxForwardSpeed;
		 tp.maxBackwardSpeed = json.maxBackwardSpeed;
		 tp.maxTurnSpeed = json.maxTurnSpeed;
		 tp.springDamping = json.springDamping;
		 tp.drivingForceOffsetZ = json.drivingForceOffsetZ;
		 tp.smallVelocity = json.smallVelocity;
		 tp.rayRestLengthCoeff = json.rayRestLengthCoeff;
		 tp.dynamicFriction = json.dynamicFriction;
		 tp.brakeFriction = json.brakeFriction;
		 tp.sideFriction = json.sideFriction;
		 tp.spotTurnPowerCoeff = json.spotTurnPowerCoeff;
		 tp.spotTurnDynamicFriction = json.spotTurnDynamicFriction;
		 tp.spotTurnSideFriction = json.spotTurnSideFriction;
		 tp.moveTurnPowerCoeffOuter = json.moveTurnPowerCoeffOuter;
		 tp.moveTurnPowerCoeffInner = json.moveTurnPowerCoeffInner;
		 tp.moveTurnDynamicFrictionInner = json.moveTurnDynamicFrictionInner;
		 tp.moveTurnDynamicFrictionOuter = json.moveTurnDynamicFrictionOuter;
		 tp.moveTurnSideFriction = json.moveTurnSideFriction;
		 tp.moveTurnSpeedCoeffInner = json.moveTurnSpeedCoeffInner;
		 tp.moveTurnSpeedCoeffOuter = json.moveTurnSpeedCoeffOuter;
         var spec:TankSpecification = new TankSpecification();
         spec.speed = json.maxForwardSpeed;
         spec.turnSpeed = json.maxTurnSpeed;
         spec.turretRotationSpeed = json.turret_turn_speed;
         var position:Vector3d = new Vector3d(0,0,0);
         var temp:Array = String(json.position).split("@");
         position.x = int(temp[0]);
         position.y = int(temp[1]);
         position.z = int(temp[2]);
         if(!json.state_null)
         {
            state = new TankState();
            state.health = json.health;
            state.orientation = new Vector3d(0,0,temp[3]);
            state.position = position;
            state.turretAngle = 0;
         }
         var clientTank:ClientTank = new ClientTank();
         clientTank.health = json.health;
         clientTank.incarnationId = json.icration;
         clientTank.self = json.tank_id == client.id;
         var stateSpawn:String = json.state;
         clientTank.spawnState = stateSpawn == "newcome"?TankSpawnState.NEWCOME:stateSpawn == "active"?TankSpawnState.ACTIVE:stateSpawn == "suicide"?TankSpawnState.SUICIDE:TankSpawnState.ACTIVE;
         clientTank.tankSpecification = spec;
         clientTank.tankState = state;
         clientTank.teamType = BattleTeamType.getType(json.team_type);
         this.myTank = clientTank;
         var tankModelService:TankModel = Main.osgi.getService(ITank) as TankModel;
         if(clientTank.self)
         {
            localTankInited = true;
         }
         activeTanks[json.tank_id] = this.initClientObject(json.tank_id,json.tank_id);
         tankModelService.initObject(activeTanks[json.tank_id],json.battleId,json.mass,json.power,null,tankParts,null,json.impact_force,json.kickback,json.turret_rotation_accel,json.turret_turn_speed,json.nickname,json.rank,json.turret_id1);
         tankModelService.initTank(activeTanks[json.tank_id],clientTank,tankParts,localTankInited,tp);
      }
	  
	  public function addKeyboardListeners() : void
      {
         Main.stage.addEventListener(KeyboardEvent.KEY_DOWN, (Main.osgi.getService(ITank) as TankModel).onKey);
		 Main.stage.addEventListener(KeyboardEvent.KEY_UP, (Main.osgi.getService(ITank) as TankModel).onKey);
		 (Main.osgi.getService(IWeaponCommonModel) as WeaponCommonModel).addKeyboardListeners();
      }
      
      public function removeKeyboardListeners() : void
      {
         Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, (Main.osgi.getService(ITank) as TankModel).onKey);
		 Main.stage.removeEventListener(KeyboardEvent.KEY_UP, (Main.osgi.getService(ITank) as TankModel).onKey);
		 (Main.osgi.getService(IWeaponCommonModel) as WeaponCommonModel).removeKeyboardListeners();
      }
      
      private function initBattle(js:String) : void
      {
         this.initLocalClientObject(PanelModel(Main.osgi.getService(IPanel)).userName,PanelModel(Main.osgi.getService(IPanel)).userName);
         var json:Object = JSON.parse(js);
         var soundsParams:BattlefieldSoundScheme = new BattlefieldSoundScheme();
         soundsParams.ambientSound = json.sound_id;
         var gameMode:IGameMode = GameModes.getGameMode(json.game_mode);
         this.battle.bm.initObject(client,null,soundsParams,json.kick_period_ms,json.map_id,json.invisible_time,json.skybox_id,json.spectator,gameMode);
      }
      
      public function initClientObject(id:String, name:String) : ClientObject
      {
         var clientClass:ClientClass = new ClientClass(id,null,name);
         return new ClientObject(id,clientClass,name,null);
      }
      
      private function initLocalClientObject(id:String, name:String) : void
      {
         var clientClass:ClientClass = new ClientClass(id,null,name);
         var clientObject:ClientObject = new ClientObject(id,clientClass,name,null);
         client = clientObject;
      }
      
      public function destroy() : void
      {
         var t:* = undefined;
		 if (tim != null)
		 {
			 tim.reset();
			 sock.removeEventListener(Event.CONNECT,onconn);
		 }
		 if (BattlefieldModel(Main.osgi.getService(IBattleField)) != null)
		 {
			BattlefieldModel(Main.osgi.getService(IBattleField)).spectatorMode = false;
			BattlefieldModel(Main.osgi.getService(IBattleField)).objectUnloaded(null);
		 }
		 if (serverInventoryModel != null)
		 {
			if (serverInventoryModel.inventoryModel != null)
			{
				serverInventoryModel.inventoryModel.objectUnloaded(null);
			}
		 }
         localTankInited = false;
         for each(t in activeTanks)
         {
            TankModel(Main.osgi.getService(ITank)).objectUnloaded(t as ClientObject);
         }
      }
   }
}
