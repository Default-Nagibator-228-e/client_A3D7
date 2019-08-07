package alternativa.tanks.models.weapon.gun
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.HitInfo;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.models.weapon.shared.CommonTargetEvaluator;
   import alternativa.tanks.models.weapon.shared.CommonTargetSystem;
   import alternativa.tanks.models.weapon.shared.ICommonTargetEvaluator;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import utils.client.commons.types.Vector3d;
   import utils.client.warfare.models.tankparts.weapon.gun.GunModelBase;
   import utils.client.warfare.models.tankparts.weapon.gun.IGunModelBase;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.utils.WeaponsManager;
   
   use namespace alternativa3d;
   
   public class SmokyModel extends GunModelBase implements IGunModelBase, IObjectLoadListener, IWeaponController
   {
      
      public static var DISTANCE_WEIGHT:Number = 0.5;
      [Embed(source="s/1.png")]
      private static const DECAL:Class;
      
      private var decalMaterial:TextureMaterial;
       
      
      private var modelService:IModelService;
      
      private var battlefieldModel:IBattleField;
      
      private var tankModel:TankModel;
      
      private var weaponCommonModel:IWeaponCommonModel;
      
      private var weaponWeakeningModel:IWeaponWeakeningModel;
      
      private var localTankData:TankData;
      
      private var localShotData:ShotData;
      
      private var localWeaponCommonData:WeaponCommonData;
      
      private var targetSystem:CommonTargetSystem;
      
      private var hitInfo:HitInfo;
      
      private var weaponUtils:WeaponUtils;
      
      private var _triggerPressed:Boolean;
      
      private var nextReadyTime:int;
      
      private var _hitPos:Vector3;
      
      private var _hitPosLocal:Vector3;
      
      private var _hitPosGlobal:Vector3;
      
      private var _gunDirGlobal:Vector3;
      
      private var _muzzlePosGlobal:Vector3;
      
      private var _barrelOrigin:Vector3;
      
      private var _xAxis:Vector3;
      
      private var _hitPos3d:Vector3d;
      
      private var _tankPos3d:Vector3d;
      
      private var targetEvaluator:ICommonTargetEvaluator;
      
      private var maxTargetingDistance:Number = 100000;
      
      public function SmokyModel()
      {
         this.hitInfo = new HitInfo();
         this.weaponUtils = WeaponUtils.getInstance();
         this._hitPos = new Vector3();
         this._hitPosLocal = new Vector3();
         this._hitPosGlobal = new Vector3();
         this._gunDirGlobal = new Vector3();
         this._muzzlePosGlobal = new Vector3();
         this._barrelOrigin = new Vector3();
         this._xAxis = new Vector3();
         this._hitPos3d = new Vector3d(0,0,0);
         this._tankPos3d = new Vector3d(0,0,0);
         super();
         _interfaces.push(IModel,IGunModelBase,IObjectLoadListener,IWeaponController);
         decalMaterial = new TextureMaterial(new DECAL().bitmapData,true);
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         if(this.modelService != null)
         {
            return;
         }
         this.modelService = IModelService(Main.osgi.getService(IModelService));
         this.battlefieldModel = Main.osgi.getService(IBattleField) as IBattleField;
         this.tankModel = Main.osgi.getService(ITank) as TankModel;
         this.weaponCommonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
      }
      
      public function fire(clientObject:ClientObject, firingTankId:String, affectedPoint:Vector3d, affectedTankId:String, weakeningCoeff:Number) : void
      {
         var affectedTankObject:ClientObject = null;
         var affectedTankData:TankData = null;
         var firingTank:ClientObject = BattleController.activeTanks[firingTankId];
         if(firingTank == null)
         {
            return;
         }
         if(this.tankModel.localUserData != null)
         {
            if(firingTank.id == this.tankModel.localUserData.user.id)
            {
               return;
            }
         }
         var firingTankData:TankData = this.tankModel.getTankData(firingTank);
         var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(firingTankData.turret);
         var barrelIndex:int = 0;
         this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh,commonData.muzzles[barrelIndex],this._muzzlePosGlobal,this._gunDirGlobal);
         this.weaponCommonModel.createShotEffects(firingTankData.turret,firingTankData.tank,barrelIndex,this._muzzlePosGlobal,this._gunDirGlobal);
         if(affectedPoint == null)
         {
            return;
         }
         this._hitPos.x = affectedPoint.x;
         this._hitPos.y = affectedPoint.y;
         this._hitPos.z = affectedPoint.z;
         if(affectedTankId != null)
         {
            affectedTankObject = BattleController.activeTanks[affectedTankId];
            if(affectedTankObject == null)
            {
               return;
            }
            affectedTankData = this.tankModel.getTankData(affectedTankObject);
            if(affectedTankData == null || affectedTankData.tank == null)
            {
               return;
            }
            this.weaponCommonModel.createExplosionEffects(firingTankData.turret,this.battlefieldModel.getBattlefieldData().viewport.camera,true,this._hitPos,this._gunDirGlobal,affectedTankData,weakeningCoeff);
            this.battlefieldModel.tankHit(affectedTankData,this._gunDirGlobal,weakeningCoeff * commonData.impactCoeff);
         }
         else
         {
            this.weaponCommonModel.createExplosionEffects(firingTankData.turret,this.battlefieldModel.getBattlefieldData().viewport.camera,false,affectedPoint.toVector3(),this._gunDirGlobal,null,weakeningCoeff * commonData.impactCoeff);
            //this.battlefieldModel.addDecal(affectedPoint.toVector3(),this._barrelOrigin,250,decalMaterial);
         }
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         this.objectLoaded(null);
         this.localTankData = localUserData;
         this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
         this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
         this.targetEvaluator = CommonTargetEvaluator.create(this.localTankData,this.localShotData,this.battlefieldModel,this.weaponWeakeningModel,this.modelService);
         this.targetSystem = new CommonTargetSystem(this.maxTargetingDistance, this.localShotData.autoAimingAngleUp.value, this.localShotData.numRaysUp.value, this.localShotData.autoAimingAngleDown.value, this.localShotData.numRaysDown.value, this.battlefieldModel.getBattlefieldData().collisionDetector, this.targetEvaluator);// new CommonTargetSystem(this.maxTargetingDistance, this.localShotData.autoAimingAngleUp.value, this.localShotData.numRaysUp.value, this.localShotData.autoAimingAngleDown.value, this.localShotData.numRaysDown.value, this.battlefieldModel.getBattlefieldData().collisionDetector, this.targetEvaluator);
         this.reset();
      }
      
      public function clearLocalUser() : void
      {
         this.localTankData = null;
         this.localShotData = null;
         this.localWeaponCommonData = null;
         this.targetSystem = null;
         this.targetEvaluator = null;
      }
      
      public function update(time:int, deltaTime:int) : Number
      {
         var impactCoeff:Number = NaN;
         var key:* = undefined;
         var td:* = null;
         var v:Vector3 = null;
         if(!this._triggerPressed || time < this.nextReadyTime)
         {
            if(time < this.nextReadyTime)
            {
               return 1 + (time - this.nextReadyTime) / this.localShotData.reloadMsec.value;
            }
            return 1;
         }
         this.nextReadyTime = time + this.localShotData.reloadMsec.value;
         this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel],this._muzzlePosGlobal,this._barrelOrigin,this._xAxis,this._gunDirGlobal);
         this.weaponCommonModel.createShotEffects(this.localTankData.turret,this.localTankData.tank,this.localWeaponCommonData.currBarrel,this._muzzlePosGlobal,this._gunDirGlobal);
         var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
         var victimData:TankData = null;
         var hitPos:Vector3d = null;
         var distance:Number = 0;
         if(this.targetSystem.getTarget(this._barrelOrigin,this._gunDirGlobal,this._xAxis,this.localTankData.tank,this.hitInfo))
         {
            distance = this.hitInfo.distance * 0.01;
            hitPos = this._hitPos3d;
            hitPos.x = this.hitInfo.position.x;
            hitPos.y = this.hitInfo.position.y;
            hitPos.z = this.hitInfo.position.z;
            if(this.hitInfo.body != null)
            {
               for(td in bfData.activeTanks)
               {
                  if(this.hitInfo.body == td.tank)
                  {
                     victimData = td;
                     break;
                  }
               }
            }
            impactCoeff = this.weaponWeakeningModel.getImpactCoeff(this.localTankData.turret,distance);
            this.weaponCommonModel.createExplosionEffects(this.localTankData.turret,bfData.viewport.camera,false,this.hitInfo.position,this._gunDirGlobal,victimData,impactCoeff);
            if(victimData != null)
            {
               this._hitPosGlobal.vDiff(this.hitInfo.position,victimData.tank.state.pos);
               victimData.tank.baseMatrix.transformVectorInverse(this._hitPosGlobal,this._hitPosLocal);
               hitPos.x = this._hitPosLocal.x;
               hitPos.y = this._hitPosLocal.y;
               hitPos.z = this._hitPosLocal.z;
            }
         }
         if(victimData != null)
         {
            v = victimData.tank.state.pos;
            this._tankPos3d.x = v.x;
            this._tankPos3d.y = v.y;
            this._tankPos3d.z = v.z;
            this.fireCommand(this.localTankData.turret, distance, hitPos, victimData.user.id, victimData.incarnation, this._tankPos3d);
			//this.battlefieldModel.addDecal(hitPos.toVector3(),this._barrelOrigin,250,decalMaterial);
         }
         else
         {
            this.fireCommand(this.localTankData.turret,distance,hitPos,null,-1,null);
            if(hitPos != null)
            {
               //this.battlefieldModel.getBattlefieldData().viewport.addDecal(hitPos.toVector3(),this._barrelOrigin,250,decalMaterial);
            }
         }
         return 0;
      }
      
      private function fireCommand(turret:ClientObject, distance:Number, hitPos:Vector3d, victimId:String, victimInc:int, tankPos:Vector3d) : void
      {
         var js:Object = new Object();
         js.distance = distance;
         js.hitPos = hitPos;
         js.victimId = victimId;
         js.victimInc = victimInc;
         js.tankPos = tankPos;
         js.reloadTime = this.localShotData.reloadMsec.value;
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(js));
      }
      
      public function activateWeapon(time:int) : void
      {
         this._triggerPressed = true;
      }
      
      public function deactivateWeapon(time:int, sendServerCommand:Boolean) : void
      {
         this._triggerPressed = false;
      }
      
      public function reset() : void
      {
         this._triggerPressed = false;
         this.nextReadyTime = 0;
      }
      
      public function stopEffects(ownerTankData:TankData) : void
      {
      }
   }
}
