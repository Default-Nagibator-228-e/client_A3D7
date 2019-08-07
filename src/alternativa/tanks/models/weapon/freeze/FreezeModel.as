package alternativa.tanks.models.weapon.freeze
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.register.ObjectRegister;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.models.weapon.flamethrower.FlamethrowerTargetValidator;
   import alternativa.tanks.models.weapon.shared.ConicAreaTargetSystem;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.vehicles.tanks.Tank;
   import utils.client.commons.types.Vector3d;
   import utils.client.warfare.models.tankparts.weapon.freeze.FreezeModelBase;
   import utils.client.warfare.models.tankparts.weapon.freeze.IFreezeModelBase;
   import flash.utils.getTimer;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.utils.WeaponsManager;
   
   public class FreezeModel extends FreezeModelBase implements IFreezeModelBase, IWeaponController, IFreezeModel
   {
       
      
      private var modelService:IModelService;
      
      private var battlefieldModel:IBattleField;
      
      private var tankModel:TankModel;
      
      private var weaponCommonModel:IWeaponCommonModel;
      
      private var weaponWeakeningModel:IWeaponWeakeningModel;
      
      private var sfxModel:IFreezeSFXModel;
      
      private var localTankData:TankData;
      
      private var localFreezeData:FreezeData;
      
      private var localWeaponCommonData:WeaponCommonData;
      
      private var currentEnergy:Number = 0;
      
      private var nextTargetCheckTime:int;
      
      private var lastUpdateTime:int;
      
      private var active:Boolean;
      
      private var weaponUtils:WeaponUtils;
      
      private var targetSystem:ConicAreaTargetSystem;
      
      private var targetIds:Array;
      
      private var targetPositions:Array;
      
      private var targetIncarnations:Array;
      
      private var targetDistances:Array;
      
      private var barrelOrigin:Vector3;
      
      private var gunGlobalDir:Vector3;
      
      private var gunRotationAxis:Vector3;
      
      private var muzzlePosGlobal:Vector3;
      
      public function FreezeModel()
      {
         this.weaponUtils = WeaponUtils.getInstance();
         this.targetIds = [];
         this.targetPositions = [];
         this.targetIncarnations = [];
         this.targetDistances = [];
         this.barrelOrigin = new Vector3();
         this.gunGlobalDir = new Vector3();
         this.gunRotationAxis = new Vector3();
         this.muzzlePosGlobal = new Vector3();
         super();
         _interfaces.push(IModel,IWeaponController,IFreezeModel);
      }
      
      public function startFire(clientObject:ClientObject, shooterId:String) : void
      {
         var tankData:TankData = this.getTankDataSafe(clientObject.register,shooterId);
         if(tankData != null && tankData != this.tankModel.localUserData)
         {
            this.createEffects(tankData,this.weaponCommonModel.getCommonData(tankData.turret));
         }
      }
      
      public function stopFire(clientObject:ClientObject, shooterId:String) : void
      {
         var tankData:TankData = this.getTankDataSafe(clientObject.register,shooterId);
         if(tankData != null && tankData.enabled && tankData != this.tankModel.localUserData)
         {
            this.stopEffects(tankData);
         }
      }
      
      public function initObject(clientObject:ClientObject, damageAreaConeAngle:Number, damageAreaRange:Number, energyCapacity:int, energyDischargeSpeed:int, energyRechargeSpeed:int, weaponTickMsec:int) : void
      {
         this.cacheInterfaces();
         var freezeData:FreezeData = new FreezeData(damageAreaConeAngle,100 * damageAreaRange,energyCapacity,energyDischargeSpeed,energyRechargeSpeed,weaponTickMsec);
         clientObject.putParams(FreezeModel,freezeData);
         WeaponsManager.getFrezeeSFXModel(clientObject);
         if(this.sfxModel == null)
         {
            this.sfxModel = WeaponsManager.getFrezeeSFXModel(clientObject);
         }
      }
      
      public function getFreezeData(clientObject:ClientObject) : FreezeData
      {
         return FreezeData(clientObject.getParams(FreezeModel));
      }
      
      public function stopEffects(ownerTankData:TankData) : void
      {
         if(this.sfxModel != null)
         {
            this.sfxModel.destroyEffects(ownerTankData);
         }
      }
      
      public function reset() : void
      {
         this.currentEnergy = this.localFreezeData.energyCapacity;
         this.lastUpdateTime = getTimer();
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         this.localTankData = localUserData;
         this.localFreezeData = this.getFreezeData(localUserData.turret);
         this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
         this.currentEnergy = this.localFreezeData.energyCapacity;
         this.lastUpdateTime = 0;
         var numRays:int = 5;
         var numSteps:int = 6;
         this.targetSystem = new ConicAreaTargetSystem(this.localFreezeData.damageAreaRange,this.localFreezeData.damageAreaConeAngle,numRays,numSteps,this.battlefieldModel.getBattlefieldData().collisionDetector,new FlamethrowerTargetValidator());
      }
      
      public function clearLocalUser() : void
      {
         this.localTankData = null;
         this.localFreezeData = null;
         this.localWeaponCommonData = null;
         this.targetSystem = null;
      }
      
      public function activateWeapon(time:int) : void
      {
         this.active = true;
         this.nextTargetCheckTime = time + this.localFreezeData.weaponTickMsec.value;
         this.lastUpdateTime = time;
         this.startFireCommand(this.localTankData.turret);
         this.createEffects(this.localTankData,this.localWeaponCommonData);
      }
      
      private function startFireCommand(cl:ClientObject) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;start_fire");
      }
      
      public function deactivateWeapon(time:int, sendServerCommand:Boolean) : void
      {
         this.active = false;
         this.lastUpdateTime = time;
         if(sendServerCommand)
         {
            this.stopFireCommand(this.localTankData.turret);
         }
         this.stopEffects(this.localTankData);
      }
      
      private function stopFireCommand(tur:ClientObject) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;stop_fire");
      }
      
      public function update(time:int, deltaTime:int) : Number
      {
         var energyCapacity:Number = NaN;
         if(this.active)
         {
            if(time >= this.nextTargetCheckTime)
            {
               this.nextTargetCheckTime = this.nextTargetCheckTime + this.localFreezeData.weaponTickMsec.value;
               this.checkTargets(this.localWeaponCommonData,this.localTankData);
            }
            this.currentEnergy = this.currentEnergy - this.localFreezeData.energyDischargeSpeed * (time - this.lastUpdateTime) * 0.001;
            if(this.currentEnergy <= 0)
            {
               this.currentEnergy = 0;
               this.deactivateWeapon(time,true);
            }
         }
         else
         {
            energyCapacity = this.localFreezeData.energyCapacity;
            if(this.currentEnergy < energyCapacity)
            {
               this.currentEnergy = this.currentEnergy + this.localFreezeData.energyRechargeSpeed * (time - this.lastUpdateTime) * 0.001;
               if(this.currentEnergy > energyCapacity)
               {
                  this.currentEnergy = energyCapacity;
               }
            }
         }
         this.lastUpdateTime = time;
         return this.currentEnergy / this.localFreezeData.energyCapacity;
      }
      
      private function checkTargets(commonData:WeaponCommonData, tankData:TankData) : void
      {
         var i:int = 0;
         var target:Tank = null;
         var targetData:TankData = null;
         var targetPosition:Vector3 = null;
         var pos3d:Vector3d = null;
         var muzzleLocalPos:Vector3 = commonData.muzzles[0];
         this.weaponUtils.calculateGunParams(tankData.tank.skin.turretMesh,muzzleLocalPos,this.muzzlePosGlobal,this.barrelOrigin,this.gunRotationAxis,this.gunGlobalDir);
         this.targetIds.length = 0;
         var barrelLength:Number = muzzleLocalPos.y;
         this.targetSystem.getTargets(this.localTankData.tank,barrelLength,0.3,this.barrelOrigin,this.gunGlobalDir,this.gunRotationAxis,this.targetIds,this.targetDistances);
         var len:int = this.targetIds.length;
         if(len > 0)
         {
            for(i = 0; i < len; i++)
            {
               target = this.targetIds[i];
               targetData = target.tankData;
               this.targetIds[i] = targetData.user.id;
               this.targetDistances[i] = 0.01 * this.targetDistances[i];
               this.targetIncarnations[i] = targetData.incarnation;
               targetPosition = target.state.pos;
               pos3d = this.targetPositions[i];
               if(pos3d == null)
               {
                  pos3d = new Vector3d(targetPosition.x,targetPosition.y,targetPosition.z);
                  this.targetPositions[i] = pos3d;
               }
               else
               {
                  pos3d.x = targetPosition.x;
                  pos3d.y = targetPosition.y;
                  pos3d.z = targetPosition.z;
               }
            }
            this.targetIncarnations.length = len;
            this.targetPositions.length = len;
            this.hitCommand(tankData.turret,this.targetIds,this.targetIncarnations,this.targetPositions,this.targetDistances);
         }
      }
      
      private function hitCommand(turr:ClientObject, victims:Array, victimsInc:Array, targetPositions:Array, targetDistances:Array) : void
      {
         var json:Object = new Object();
         json.victims = victims;
         json.targetDistances = targetDistances;
         json.tickPeriod = this.localFreezeData.weaponTickMsec.value;
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(json));
      }
      
      private function createEffects(tankData:TankData, commonData:WeaponCommonData) : void
      {
         if(this.sfxModel != null)
         {
            this.sfxModel.createEffects(tankData,commonData);
         }
      }
      
      private function getTankDataSafe(register:ObjectRegister, tankId:String) : TankData
      {
         var tankObject:ClientObject = BattleController.activeTanks[tankId];
         if(tankObject == null)
         {
            return null;
         }
         var tankData:TankData = this.tankModel.getTankData(tankObject);
         if(tankData == null || tankData.tank == null)
         {
            return null;
         }
         return tankData;
      }
      
      private function cacheInterfaces() : void
      {
         if(this.modelService == null)
         {
            this.modelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefieldModel = IBattleField(this.modelService.getModelsByInterface(IBattleField)[0]);
            this.tankModel = TankModel(Main.osgi.getService(ITank));
            this.weaponCommonModel = IWeaponCommonModel(this.modelService.getModelsByInterface(IWeaponCommonModel)[0]);
            this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
         }
      }
   }
}
