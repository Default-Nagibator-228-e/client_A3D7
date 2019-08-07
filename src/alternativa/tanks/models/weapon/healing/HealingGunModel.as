package alternativa.tanks.models.weapon.healing
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.physics.altphysics;
   import alternativa.register.ObjectRegister;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.sfx.healing.HealingGunSFXModel;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.ITankEventDispatcher;
   import alternativa.tanks.models.tank.ITankEventListener;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankEvent;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import utils.client.commons.types.Vector3d;
   import utils.client.warfare.models.sfx.healing.IHealingSFXModelBase;
   import utils.client.warfare.models.tankparts.weapon.healing.HealingGunModelBase;
   import utils.client.warfare.models.tankparts.weapon.healing.IHealingGunModelBase;
   import utils.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   import utils.client.warfare.models.tankparts.weapon.healing.struct.IsisAction;
   import utils.reygazu.anticheat.variables.SecureInt;
   import utils.client.battleservice.model.team.BattleTeamType;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.utils.WeaponsManager;
   
   use namespace altphysics;
   
   public class HealingGunModel extends HealingGunModelBase implements IHealingGunModelBase, IWeaponController, ITankEventListener, IDumper
   {
       
      
      private var modelService:IModelService;
      
      private var bfInterface:IBattleField;
      
      private var tankInterface:TankModel;
      
      private var weaponCommonInterface:IWeaponCommonModel;
      
      private var sfxModel:HealingGunSFXModel;
      
      private var currTarget:TankData;
      
      private var targetSystem:HealingGunTargetSystem;
      
      private var weaponUtils:WeaponUtils;
      
      private var active:Boolean;
      
      private var localTankData:TankData;
      
      private var localCommonData:WeaponCommonData;
      
      private var localGunData:HealingGunData;
      
      private var currentCharge:Number = 0;
      
      private var nextTickTime:SecureInt;
      
      private var lastUpdateTime:SecureInt;
      
      private var muzzlePosGlobal:Vector3;
      
      private var barrelOrigin:Vector3;
      
      private var axisX:Vector3;
      
      private var axisY:Vector3;
      
      private var vec:Vector3;
      
      private var pos3d:Vector3d;
      
      public function HealingGunModel()
      {
         this.targetSystem = new HealingGunTargetSystem();
         this.weaponUtils = new WeaponUtils();
         this.nextTickTime = new SecureInt("nextTickTime isida",0);
         this.lastUpdateTime = new SecureInt("lastUpdateTime isida",0);
         this.muzzlePosGlobal = new Vector3();
         this.barrelOrigin = new Vector3();
         this.axisX = new Vector3();
         this.axisY = new Vector3();
         this.vec = new Vector3();
         this.pos3d = new Vector3d(0,0,0);
         super();
         _interfaces.push(IModel,IHealingGunModelBase,IWeaponController);
      }
      
      public function initObject(clientObject:ClientObject, angle:Number, capacity:int, chargeRate:int, checkPeriodMsec:int, coneAngle:Number, dischargeRate:int, radius:Number) : void
      {
         var tankDispatcher:ITankEventDispatcher = null;
         WeaponsManager.getIsidaSFX(clientObject);
         if(this.modelService == null)
         {
            this.modelService = Main.osgi.getService(IModelService) as IModelService;
            this.bfInterface = this.modelService.getModelsByInterface(IBattleField)[0] as IBattleField;
            this.tankInterface = Main.osgi.getService(ITank) as TankModel;
            this.weaponCommonInterface = this.modelService.getModelsByInterface(IWeaponCommonModel)[0] as IWeaponCommonModel;
            this.sfxModel = Main.osgi.getService(IHealingSFXModelBase) as HealingGunSFXModel;
            tankDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
            tankDispatcher.addTankEventListener(TankEvent.KILLED,this);
            tankDispatcher.addTankEventListener(TankEvent.UNLOADED,this);
         }
         var data:HealingGunData = new HealingGunData();
         data.capacity.value = capacity;
         data.tickPeriod.value = checkPeriodMsec;
         data.lockAngle.value = coneAngle;
         data.lockAngleCos.value = Math.cos(coneAngle);
         data.maxRadius.value = radius * 100;
         data.maxAngle.value = angle;
         data.maxAngleCos.value = Math.cos(angle);
         data.dischargeRate.value = dischargeRate;
         data.chargeRate.value = chargeRate;
         clientObject.putParams(HealingGunModel,data);
      }
      
      public function init(clientObject:ClientObject, isisActions:Array) : void
      {
         var isisAction:IsisAction = null;
         var shooterData:TankData = null;
         var targetData:TankData = null;
         var objectRegister:ObjectRegister = clientObject.register;
         var len:int = isisActions.length;
         for(var i:int = 0; i < len; i++)
         {
            isisAction = isisActions[i];
            shooterData = this.getTankData(objectRegister,isisAction.shooterId);
            if(shooterData != null)
            {
               if(isisAction.type == IsisActionType.IDLE)
               {
                  this.sfxModel.createOrUpdateEffects(shooterData,isisAction.type,null);
               }
               else
               {
                  targetData = this.getTankData(objectRegister,isisAction.targetId);
                  if(targetData != null)
                  {
                     this.sfxModel.createOrUpdateEffects(shooterData,isisAction.type,targetData);
                  }
               }
            }
         }
      }
      
      public function startWeapon(clientObject:ClientObject, isisAction:IsisAction) : void
      {
         var targetData:TankData = null;
         var objectRegister:ObjectRegister = clientObject.register;
         var shooterData:TankData = this.getTankData(objectRegister,isisAction.shooterId);
         if(shooterData == null || !shooterData.enabled)
         {
            return;
         }
         if(this.tankInterface.localUserData != null)
         {
            if(shooterData == this.tankInterface.localUserData)
            {
               return;
            }
         }
         if(isisAction.type == IsisActionType.IDLE)
         {
            this.sfxModel.createOrUpdateEffects(shooterData,isisAction.type,null);
         }
         else
         {
            targetData = this.getTankData(objectRegister,isisAction.targetId);
            if(targetData == null || !targetData.enabled)
            {
               return;
            }
            this.sfxModel.createOrUpdateEffects(shooterData,isisAction.type,targetData);
         }
      }
      
      public function stopWeapon(clientObject:ClientObject, healerId:String) : void
      {
         var ownerTankData:TankData = this.getTankData(clientObject.register,healerId);
         if(this.tankInterface.localUserData != null)
         {
            if(ownerTankData == this.tankInterface.localUserData)
            {
               return;
            }
         }
         if(ownerTankData != null)
         {
            this.sfxModel.destroyEffectsByOwner(ownerTankData);
         }
      }
      
      public function stopEffects(ownerTankData:TankData) : void
      {
         this.sfxModel.destroyEffectsByOwner(ownerTankData);
      }
      
      public function reset() : void
      {
         this.currTarget = null;
         this.nextTickTime.value = int.MAX_VALUE;
         this.currentCharge = this.localGunData == null?Number(0):Number(this.localGunData.capacity.value);
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         var dumpService:IDumpService = IDumpService(Main.osgi.getService(IDumpService));
         if(dumpService != null)
         {
            dumpService.registerDumper(this);
         }
         this.localTankData = localUserData;
         this.localGunData = this.getHealingData(localUserData.turret);
         this.localCommonData = this.weaponCommonInterface.getCommonData(localUserData.turret);
         this.currentCharge = this.localGunData.capacity.value;
         this.active = false;
         this.currTarget = null;
      }
      
      public function clearLocalUser() : void
      {
         var dumpService:IDumpService = IDumpService(Main.osgi.getService(IDumpService));
         if(dumpService != null)
         {
            dumpService.unregisterDumper(this.dumperName);
         }
         this.localTankData = null;
         this.localGunData = null;
         this.localCommonData = null;
         this.active = false;
         this.currTarget = null;
      }
      
      public function activateWeapon(time:int) : void
      {
         if(this.active)
         {
            return;
         }
         this.active = true;
         this.lastUpdateTime.value = time;
         this.nextTickTime.value = time + this.localGunData.tickPeriod.value;
         this.currTarget = this.lockTarget(this.localCommonData,this.localTankData);
         if(this.currTarget == null)
         {
            this.sfxModel.createOrUpdateEffects(this.localTankData,IsisActionType.IDLE,null);
            this.startWeaponCommand(this.localTankData.turret,0,null);
         }
         else
         {
            this.startActiveMode(this.localTankData,this.currTarget);
         }
      }
      
      public function deactivateWeapon(time:int, sendServerCommand:Boolean) : void
      {
         if(!this.active)
         {
            return;
         }
         this.active = false;
         this.currTarget = null;
         this.lastUpdateTime.value = time;
         this.sfxModel.destroyEffectsByOwner(this.localTankData);
         if(sendServerCommand)
         {
            this.stopWeaponCommand(this.localTankData.turret);
         }
      }
      
      private function stopWeaponCommand(turr:ClientObject) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;stop_fire");
      }
      
      public function update(time:int, deltaTime:int) : Number
      {
         var targetPos:Vector3 = null;
         if(this.active)
         {
            if(this.currentCharge == 0)
            {
               this.deactivateWeapon(time,true);
            }
            else
            {
               if(this.currTarget == null)
               {
                  this.currTarget = this.lockTarget(this.localCommonData,this.localTankData);
                  if(this.currTarget != null)
                  {
                     this.startActiveMode(this.localTankData,this.currTarget);
                  }
               }
               else if(!this.validateTarget())
               {
                  this.currTarget = null;
                  this.sfxModel.createOrUpdateEffects(this.localTankData,IsisActionType.IDLE,null);
                  this.startWeaponCommand(this.localTankData.turret,0,null);
               }
               if(time >= this.nextTickTime.value)
               {
                  this.nextTickTime.value = this.nextTickTime.value + this.localGunData.tickPeriod.value;
                  if(this.currTarget != null)
                  {
                     targetPos = this.currTarget.tank.state.pos;
                     this.pos3d.x = targetPos.x;
                     this.pos3d.y = targetPos.y;
                     this.pos3d.z = targetPos.z;
                     this.vec.vDiff(targetPos,this.localTankData.tank.state.pos);
                     this.actCommand(this.localTankData.turret,this.currTarget.incarnation,this.currTarget.user.id,this.pos3d,this.vec.vLength());
                  }
                  else
                  {
                     this.actCommand(this.localTankData.turret,0,null,null,0);
                  }
               }
               this.currentCharge = this.currentCharge - 0.001 * (time - this.lastUpdateTime.value) * this.localGunData.dischargeRate.value;
               if(this.currentCharge < 0)
               {
                  this.currentCharge = 0;
               }
               this.lastUpdateTime.value = time;
            }
         }
         else if(this.currentCharge < this.localGunData.capacity.value)
         {
            this.currentCharge = this.currentCharge + 0.001 * (time - this.lastUpdateTime.value) * this.localGunData.chargeRate.value;
            if(this.currentCharge > this.localGunData.capacity.value)
            {
               this.currentCharge = this.localGunData.capacity.value;
            }
            this.lastUpdateTime.value = time;
         }
         return this.currentCharge / this.localGunData.capacity.value;
      }
      
      private function actCommand(turret:ClientObject, victimInc:int, victimId:String, pos3d:Vector3d, vLength:int) : void
      {
         var obj:Object = new Object();
         obj.victimId = victimId;
         obj.distance = this.localGunData.maxRadius.value;
         obj.tickPeriod = this.localGunData.tickPeriod.value;
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(obj));
      }
      
      public function handleTankEvent(eventType:int, tankData:TankData) : void
      {
         if(eventType == TankEvent.KILLED || eventType == TankEvent.UNLOADED)
         {
            this.sfxModel.destroyEffectsByOwner(tankData);
            if(tankData == this.currTarget)
            {
               this.currTarget = null;
               this.sfxModel.createOrUpdateEffects(this.localTankData,IsisActionType.IDLE,null);
               this.startWeaponCommand(this.localTankData.turret,0,null);
            }
            else
            {
               this.sfxModel.destroyEffectsByTarget(tankData);
            }
         }
      }
      
      public function get dumperName() : String
      {
         return "healgun";
      }
      
      public function dump(params:Vector.<String>) : String
      {
         return "=== HealingGunModel dump ===\n" + "active=" + this.active + "\n" + "currentCharge=" + this.currentCharge + "\n" + "currTarget=" + this.currTarget + "\n" + "nextTickTime=" + this.nextTickTime + "\n" + "=== end of HealingGunModel dump ===";
      }
      
      private function getHealingData(clientObject:ClientObject) : HealingGunData
      {
         return HealingGunData(clientObject.getParams(HealingGunModel));
      }
      
      private function lockTarget(commonData:WeaponCommonData, weaponOwnerData:TankData) : TankData
      {
         var v:Vector3 = commonData.muzzles[0];
         this.weaponUtils.calculateGunParams(weaponOwnerData.tank.skin.turretMesh,v,this.muzzlePosGlobal,this.barrelOrigin,this.axisX,this.axisY);
         var bfData:BattlefieldData = this.bfInterface.getBattlefieldData();
         return this.targetSystem.getTarget(weaponOwnerData,this.localGunData,v.y,this.barrelOrigin,this.axisY,this.axisX,5,6,TanksCollisionDetector(bfData.physicsScene.collisionDetector),bfData.tanks);
      }
      
      private function validateTarget() : Boolean
      {
         var v:Vector3 = this.localCommonData.muzzles[0];
         this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,v,this.muzzlePosGlobal,this.barrelOrigin,this.axisX,this.axisY);
         var bfData:BattlefieldData = this.bfInterface.getBattlefieldData();
         return this.targetSystem.validateTarget(this.localTankData,this.currTarget,this.localGunData,this.axisY,this.barrelOrigin,v.y,bfData.collisionDetector);
      }
      
      private function startActiveMode(shooterData:TankData, targetData:TankData) : void
      {
         var mode:IsisActionType = this.getEffectsMode(shooterData,targetData);
         this.sfxModel.createOrUpdateEffects(shooterData,mode,targetData);
         this.startWeaponCommand(shooterData.turret,targetData.incarnation,targetData.user.id);
      }
      
      private function startWeaponCommand(turrObj:ClientObject, incId:int, victimId:String) : void
      {
         var js:Object = new Object();
         js.incId = incId;
         js.victimId = victimId;
         Network(Main.osgi.getService(INetworker)).send("battle;start_fire;" + JSON.stringify(js));
      }
      
      private function getTankData(objectRegister:ObjectRegister, userId:String) : TankData
      {
         var userObject:ClientObject = BattleController.activeTanks[userId];
         if(userObject == null)
         {
            return null;
         }
         var tankData:TankData = this.tankInterface.getTankData(userObject);
         if(tankData == null || tankData.tank == null)
         {
            return null;
         }
         return tankData;
      }
      
      private function isEnemyTarget(ownerData:TankData, targetData:TankData) : Boolean
      {
         return ownerData.teamType == BattleTeamType.NONE || ownerData.teamType != targetData.teamType;
      }
      
      private function getEffectsMode(ownerData:TankData, targetData:TankData) : IsisActionType
      {
         var isEnemy:Boolean = this.isEnemyTarget(ownerData,targetData);
         return isEnemy?IsisActionType.DAMAGE:IsisActionType.HEAL;
      }
   }
}

import alternativa.types.Long;

class InitData
{
    
   
   public var shooters:Vector.<Long>;
   
   public var targets:Vector.<Long>;
   
   function InitData()
   {
      this.shooters = new Vector.<Long>();
      this.targets = new Vector.<Long>();
      super();
   }
}
