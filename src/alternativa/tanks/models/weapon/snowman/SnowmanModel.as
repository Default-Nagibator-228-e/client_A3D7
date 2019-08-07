package alternativa.tanks.models.weapon.snowman
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.physics.Body;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.sfx.shoot.snowman.SnowmanSFXData;
   import alternativa.tanks.models.sfx.shoot.snowman.SnowmanSFXModel;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.HitInfo;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.models.weapon.common.WeaponCommonModel;
   import alternativa.tanks.models.weapon.shared.CommonTargetEvaluator;
   import alternativa.tanks.models.weapon.shared.CommonTargetSystem;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import utils.client.commons.types.Vector3d;
   import flash.utils.Dictionary;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.utils.WeaponsManager;
   
   public class SnowmanModel implements IObjectLoadListener, ISnowmanShotListener, IWeaponController
   {
       
      
      private var _triggerPressed:Boolean;
      
      private var shotId:int;
      
      private var activeShots:Dictionary;
      
      private var localTankData:TankData;
      
      private var localShotData:ShotData;
      
      private var localWeaponCommonData:WeaponCommonData;
      
      private var modelService:IModelService;
      
      private var battlefieldModel:IBattleField;
      
      private var tankModel:TankModel;
      
      private var weaponCommonModel:WeaponCommonModel;
      
      private var weaponWeakeningModel:IWeaponWeakeningModel;
      
      private var targetSystem:CommonTargetSystem;
      
      private var hitInfo:HitInfo;
      
      private var weaponUtils:WeaponUtils;
      
      private var nextReadyTime:int;
      
      private var _dirToTarget:Vector3;
      
      private var _barrelOrigin:Vector3;
      
      private var _gunDirGlobal:Vector3;
      
      private var _xAxis:Vector3;
      
      private var _hitPosGlobal:Vector3;
      
      private var _hitPosLocal:Vector3;
      
      private var _muzzlePosGlobal:Vector3;
      
      private var _hitPos:Vector3;
      
      private var _hitPos3d:Vector3d;
      
      private var _tankPos3d:Vector3d;
      
      private var _dirToTarget3d:Vector3d;
      
      private var intersection:RayIntersection;
      
      private var targetEvaluator:CommonTargetEvaluator;
      
      private var maxTargetingDistance:Number = 100000;
      
      public function SnowmanModel()
      {
         this.activeShots = new Dictionary();
         this.hitInfo = new HitInfo();
         this.weaponUtils = WeaponUtils.getInstance();
         this._dirToTarget = new Vector3();
         this._barrelOrigin = new Vector3();
         this._gunDirGlobal = new Vector3();
         this._xAxis = new Vector3();
         this._hitPosGlobal = new Vector3();
         this._hitPosLocal = new Vector3();
         this._muzzlePosGlobal = new Vector3();
         this._hitPos = new Vector3();
         this._hitPos3d = new Vector3d(0,0,0);
         this._tankPos3d = new Vector3d(0,0,0);
         this._dirToTarget3d = new Vector3d(0,0,0);
         this.intersection = new RayIntersection();
         super();
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         this.cacheInterfaces();
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
         var playerShots:Dictionary = null;
         var shot:SnowmanShot = null;
         for each(playerShots in this.activeShots)
         {
            for each(shot in playerShots)
            {
               shot.kill();
            }
         }
         this.activeShots = new Dictionary();
      }
      
      public function initObject(clientObject:ClientObject, chargeRadius:Number, distance:Number, speed:Number) : void
      {
         var data:SnowmanGunData = new SnowmanGunData();
         data.shotSpeed = speed * 100;
         data.shotRange = distance * 100;
         data.shotRadius = chargeRadius * 100;
         clientObject.putParams(SnowmanModel,data);
      }
      
      public function fire(clientObject:ClientObject, firingTankId:String, shotId:int, dirToTarget:Vector3d) : void
      {
         var firingTankData:TankData = null;
         this.objectLoaded(null);
         var firingTankObject:ClientObject = BattleController.activeTanks[firingTankId];
         if(firingTankObject == null)
         {
            return;
         }
         if(this.tankModel.localUserData != null)
         {
            if(firingTankId == this.tankModel.localUserData.user.id)
            {
               return;
            }
         }
         firingTankData = this.tankModel.getTankData(firingTankObject);
         if(firingTankData.tank == null)
         {
            return;
         }
         var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(firingTankData.turret);
         this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh,commonData.muzzles[0],this._muzzlePosGlobal,this._gunDirGlobal);
         this.weaponCommonModel.createShotEffects(firingTankData.turret,firingTankData.tank,0,this._muzzlePosGlobal,this._gunDirGlobal);
         if(shotId > -1)
         {
            this._dirToTarget.x = dirToTarget.x;
            this._dirToTarget.y = dirToTarget.y;
            this._dirToTarget.z = dirToTarget.z;
            this.createShot(false,shotId,firingTankData,this._muzzlePosGlobal,this._dirToTarget);
         }
      }
      
      public function hit(clientObject:ClientObject, firingTankId:String, shotId:int, affectedPoint:Vector3d, affectedTankId:String, weakeningCoeff:Number) : void
      {
         var shot:SnowmanShot = null;
         var affectedTankObject:ClientObject = null;
         var affectedTankData:TankData = null;
         var commonData:WeaponCommonData = null;
         var firingTankObject:ClientObject = BattleController.activeTanks[firingTankId];
         if(firingTankObject == null)
         {
            return;
         }
         var firingTankData:TankData = this.tankModel.getTankData(firingTankObject);
         if(firingTankData.tank == null)
         {
            return;
         }
         var tankShots:Dictionary = this.activeShots[firingTankId];
         if(tankShots != null)
         {
            shot = tankShots[shotId];
            if(shot != null)
            {
               this.removeShot(shot);
               shot.kill();
            }
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
            if(affectedTankData.tank == null)
            {
               return;
            }
            this.weaponCommonModel.createExplosionEffects(firingTankData.turret,this.battlefieldModel.getBattlefieldData().viewport.camera,true,this._hitPos,this._gunDirGlobal,affectedTankData,weakeningCoeff);
            commonData = this.weaponCommonModel.getCommonData(firingTankData.turret);
            this.battlefieldModel.tankHit(affectedTankData,this._gunDirGlobal,weakeningCoeff * commonData.impactCoeff);
         }
         else
         {
            this.weaponCommonModel.createExplosionEffects(firingTankData.turret,this.battlefieldModel.getBattlefieldData().viewport.camera,false,this._hitPos,null,null,weakeningCoeff);
         }
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         this.objectLoaded(null);
         this.localTankData = localUserData;
         this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
         this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
         this.targetEvaluator = CommonTargetEvaluator.create(this.localTankData,this.localShotData,this.battlefieldModel,this.weaponWeakeningModel,this.modelService);
         this.targetSystem = new CommonTargetSystem(this.maxTargetingDistance,this.localShotData.autoAimingAngleUp.value,this.localShotData.numRaysUp.value,this.localShotData.autoAimingAngleDown.value,this.localShotData.numRaysDown.value,this.battlefieldModel.getBattlefieldData().collisionDetector,this.targetEvaluator);
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
         if(!this._triggerPressed || time < this.nextReadyTime)
         {
            if(time < this.nextReadyTime)
            {
               return 1 + (time - this.nextReadyTime) / this.localShotData.reloadMsec.value;
            }
            return 1;
         }
         this.nextReadyTime = time + this.localShotData.reloadMsec.value;
         var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
         var collisionDetector:TanksCollisionDetector = TanksCollisionDetector(bfData.physicsScene.collisionDetector);
         var muzzlePosLocal:Vector3 = this.localWeaponCommonData.muzzles[0];
         this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,muzzlePosLocal,this._muzzlePosGlobal,this._barrelOrigin,this._xAxis,this._gunDirGlobal);
         var canFire:Boolean = !collisionDetector.intersectRay(this._barrelOrigin,this._gunDirGlobal,CollisionGroup.STATIC,muzzlePosLocal.y,null,this.intersection);
         this.weaponCommonModel.createShotEffects(this.localTankData.turret,this.localTankData.tank,this.localWeaponCommonData.currBarrel,this._muzzlePosGlobal,this._gunDirGlobal);
         var realShotId:int = -1;
         if(canFire)
         {
            if(this.targetSystem.getTarget(this._muzzlePosGlobal,this._gunDirGlobal,this._xAxis,this.localTankData.tank,this.hitInfo))
            {
               this._dirToTarget.vCopy(this.hitInfo.direction);
            }
            else
            {
               this._dirToTarget.vCopy(this._gunDirGlobal);
            }
            this._dirToTarget3d.x = this._dirToTarget.x;
            this._dirToTarget3d.y = this._dirToTarget.y;
            this._dirToTarget3d.z = this._dirToTarget.z;
            realShotId = this.shotId;
            this.createShot(true,this.shotId,this.localTankData,this._muzzlePosGlobal,this._dirToTarget);
            this.shotId++;
         }
         this.fireCommand(this.localTankData.turret,this.localWeaponCommonData.currBarrel,realShotId,this._dirToTarget3d);
         this.localWeaponCommonData.currBarrel = 0;
         return 0;
      }
      
      private function fireCommand(turr:ClientObject, currBarrel:int, realShotId:int, _dirToTarget3d:Vector3d) : void
      {
         var js:Object = new Object();
         js.realShotId = realShotId;
         js.dirToTarget = _dirToTarget3d;
         js.reloadTime = this.localShotData.reloadMsec.value;
         Network(Main.osgi.getService(INetworker)).send("battle;start_fire;" + JSON.stringify(js));
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
      
      public function stopEffects(tankData:TankData) : void
      {
      }
      
      public function snowShotDissolved(shot:SnowmanShot) : void
      {
         this.removeShot(shot);
      }
      
      public function snowShotHit(shot:SnowmanShot, hitPoint:Vector3, hitDir:Vector3, body:Body) : void
      {
         var key:* = undefined;
         var td:* = null;
         var v:Vector3 = null;
         this.removeShot(shot);
         var affectedTankData:TankData = null;
         if(body != null)
         {
            for(td in this.battlefieldModel.getBattlefieldData().activeTanks)
            {
               if(body == td.tank)
               {
                  this._hitPosGlobal.vDiff(hitPoint,body.state.pos);
                  body.baseMatrix.transformVectorInverse(this._hitPosGlobal,this._hitPosLocal);
                  this._hitPos3d.x = this._hitPosLocal.x;
                  this._hitPos3d.y = this._hitPosLocal.y;
                  this._hitPos3d.z = this._hitPosLocal.z;
                  affectedTankData = td;
                  break;
               }
            }
         }
         else
         {
            this._hitPos3d.x = hitPoint.x;
            this._hitPos3d.y = hitPoint.y;
            this._hitPos3d.z = hitPoint.z;
         }
         var distance:Number = 0.01 * shot.totalDistance;
         var weakeingCoeff:Number = this.weaponWeakeningModel.getImpactCoeff(shot.shooterData.turret,distance);
         this.weaponCommonModel.createExplosionEffects(shot.shooterData.turret,this.battlefieldModel.getBattlefieldData().viewport.camera,false,hitPoint,hitDir,affectedTankData,weakeingCoeff);
         if(affectedTankData != null)
         {
            v = affectedTankData.tank.state.pos;
            this._tankPos3d.x = v.x;
            this._tankPos3d.y = v.y;
            this._tankPos3d.z = v.z;
            this.hitCommand(shot.shooterData.turret,shot.shotId,this._hitPos3d,affectedTankData.user.id,affectedTankData.incarnation,this._tankPos3d,distance);
         }
         else
         {
            this.hitCommand(shot.shooterData.turret,shot.shotId,this._hitPos3d,null,-1,null,distance);
         }
      }
      
      private function hitCommand(turrObj:ClientObject, shotId:int, hitPos:Vector3d, affectedTankId:String, incr:int, tankPos:Vector3d, distance:int) : void
      {
         var js:Object = new Object();
         js.shotId = shotId;
         js.hitPos = hitPos;
         js.victimId = affectedTankId;
         js.incr = incr;
         js.tankPos = tankPos;
         js.distance = distance;
         js.reloadTime = this.localShotData.reloadMsec.value;
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(js));
      }
      
      private function getWeaponData(clientObject:ClientObject) : SnowmanGunData
      {
         return clientObject.getParams(SnowmanModel) as SnowmanGunData;
      }
      
      private function removeShot(shot:SnowmanShot) : void
      {
         var tankShots:Dictionary = this.activeShots[shot.shooterData.user.id];
         if(tankShots != null)
         {
            delete tankShots[shot.shotId];
         }
      }
      
      private function createShot(active:Boolean, shotId:int, tankData:TankData, muzzleGlobalPos:Vector3, dirToTarget:Vector3) : void
      {
         var data:SnowmanGunData = this.getWeaponData(tankData.turret);
         var tankShots:Dictionary = this.activeShots[tankData.user.id];
         if(tankShots == null)
         {
            this.activeShots[tankData.user.id] = tankShots = new Dictionary();
         }
         var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
         var plasmaShootSfx:SnowmanSFXModel = WeaponsManager.getSnowmanSFX(WeaponsManager.getObjectFor(tankData.turret.id));
         var plasmaData:SnowmanSFXData = plasmaShootSfx.getSnowmanSFXData(tankData.turret);
         var shot:SnowmanShot = SnowmanShot.getShot();
         shot.init(shotId,active,data,muzzleGlobalPos,dirToTarget,tankData,this,plasmaData,bfData.physicsScene.collisionDetector,this.weaponWeakeningModel);
         tankShots[shotId] = shot;
         this.battlefieldModel.addGraphicEffect(shot);
      }
      
      private function cacheInterfaces() : void
      {
         if(this.modelService == null)
         {
            this.modelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefieldModel = IBattleField(this.modelService.getModelsByInterface(IBattleField)[0]);
            this.tankModel = Main.osgi.getService(ITank) as TankModel;
            this.weaponCommonModel = Main.osgi.getService(IWeaponCommonModel) as WeaponCommonModel;
            this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
         }
      }
   }
}
