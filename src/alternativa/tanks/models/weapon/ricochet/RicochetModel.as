package alternativa.tanks.models.weapon.ricochet
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import utils.client.models.IModel;
   import utils.client.models.IObjectLoadListener;
   import utils.client.models.ClientObject;
   import alternativa.physics.Body;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.register.ObjectRegister;
   import alternativa.service.IModelService;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.sfx.SpriteShotEffect;
   import alternativa.tanks.models.sfx.shoot.ricochet.IRicochetSFXModel;
   import alternativa.tanks.models.sfx.shoot.ricochet.RicochetSFXData;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.models.weapon.shared.CommonTargetEvaluator;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.vehicles.tanks.Tank;
   import utils.client.commons.types.Vector3d;
   import utils.client.warfare.models.tankparts.weapon.ricochet.IRicochetModelBase;
   import utils.client.warfare.models.tankparts.weapon.ricochet.RicochetModelBase;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.utils.getTimer;
   import alternativa.network.INetworker;
   import alternativa.network.Network;
   import alternativa.tanks.utils.WeaponsManager;
   
   public class RicochetModel extends RicochetModelBase implements IRicochetModelBase, IObjectLoadListener, IWeaponController, IRicochetShotListener
   {
      
      private static const EXPLOSION_SIZE:Number = 266;
      
      private static var objectPoolService:IObjectPoolService;
       
      
      private var weaponCommonModel:IWeaponCommonModel;
      
      private var weakeningModel:IWeaponWeakeningModel;
      
      private var battlefield:IBattleField;
      
      private var tankModel:TankModel;
      
      private var ricochetSfxModel:IRicochetSFXModel;
      
      private var localTankData:TankData;
      
      private var localRicochetData:RicochetData;
      
      private var localRicochetSFXData:RicochetSFXData;
      
      private var localShotData:ShotData;
      
      private var localWeaponCommonData:WeaponCommonData;
      
      private var triggerPressed:Boolean;
      
      private var readyTime:int;
      
      private var currentEnergy:Number = 0;
      
      private var targetSystem:RicochetTargetSystem;
      
      private var weaponUtils:WeaponUtils;
      
      private var _barrelOrigin:Vector3;
      
      private var _gunDirGlobal:Vector3;
      
      private var _xAxis:Vector3;
      
      private var _muzzlePosGlobal:Vector3;
      
      private var _shotDirection:Vector3;
      
      private var _localPosition:Vector3;
      
      private var _hitDirection:Vector3;
      
      private var rayHit:RayIntersection;
      
      private var SHOT_FLASH_SIZE:Number = 150;
      
      private var SHOT_FLASH_DURATION:int = 50;
      
      private var SHOT_FLASH_FADE:int = 100;
      
      public function RicochetModel()
      {
         this.weaponUtils = WeaponUtils.getInstance();
         this._barrelOrigin = new Vector3();
         this._gunDirGlobal = new Vector3();
         this._xAxis = new Vector3();
         this._muzzlePosGlobal = new Vector3();
         this._shotDirection = new Vector3();
         this._localPosition = new Vector3();
         this._hitDirection = new Vector3();
         this.rayHit = new RayIntersection();
         super();
         _interfaces.push(IModel,IObjectLoadListener,IWeaponController);
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
      }
      
      public function hit(clientObject:ClientObject, targetId:String, hitPoint:Vector3d, hitDirectionX:int, hitDirectionY:int, hitDirectionZ:int, weakeningCoeff:Number) : void
      {
         var targetData:TankData = this.getTankDataSafe(targetId,clientObject.register);
         if(targetData == null)
         {
            return;
         }
         var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(clientObject);
         this._localPosition.vReset(hitPoint.x,hitPoint.y,hitPoint.z);
         this._hitDirection.vReset(hitDirectionX / 32767,hitDirectionY / 32767,hitDirectionZ / 32767).vNormalize();
         this.battlefield.tankHit(targetData,this._hitDirection,weakeningCoeff * commonData.impactCoeff);
         this._hitDirection.vScale(weakeningCoeff * commonData.impactForce);
         //targetData.tank.addWorldForceAtLocalPoint(this._localPosition, this._hitDirection, this.localWeaponCommonData.kickback);
		 //targetData.tank.addWorldForceScaled(this._localPosition, this._hitDirection, -this.localWeaponCommonData.kickback);
		 targetData.tank.addWorldForceinP(_muzzlePosGlobal, _gunDirGlobal, -this.localWeaponCommonData.kickback, targetData.tank.state.pos);
      }
      
      public function fire(clientObject:ClientObject, shooterId:String, shotDirectionX:int, shotDirectionY:int, shotDirectionZ:int) : void
      {
         var shooterData:TankData = this.getTankDataSafe(shooterId,clientObject.register);
         if(shooterData == null)
         {
            return;
         }
         if(this.tankModel.localUserData != null)
         {
            if(shooterData == this.tankModel.localUserData)
            {
               return;
            }
         }
         var ricochetData:RicochetData = RicochetData(shooterData.turret.getParams(RicochetData));
         var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(shooterData.turret);
         var sfxData:RicochetSFXData = this.ricochetSfxModel.getSfxData(shooterData.turret);
         var muzzlePosLocal:Vector3 = commonData.muzzles[0];
         this.weaponUtils.calculateGunParams(shooterData.tank.skin.turretMesh,muzzlePosLocal,this._muzzlePosGlobal,this._barrelOrigin,this._xAxis,this._gunDirGlobal);
         this._shotDirection.vReset(shotDirectionX / 32767,shotDirectionY / 32767,shotDirectionZ / 32767).vNormalize();
         var ricochetShot:RicochetShot = this.createShotEffects(shooterData, ricochetData, sfxData, commonData, muzzlePosLocal, this._muzzlePosGlobal, this._shotDirection, this._gunDirGlobal);
		 var offsetAlongBarrel:Number = ((this.rayHit.t / muzzlePosLocal.y * 255 - 128) + 128) / 255 * commonData.muzzles[0].y;
         var hitPos:Vector3 = this._barrelOrigin.vClone();
         hitPos.vAddScaled(offsetAlongBarrel, _gunDirGlobal);
		 //shooterData.tank.addWorldForceinP(hitPos,_shotDirection,-commonData.impactForce * commonData.impactCoeff,hitPos);
		 if(IBattleField(IModelService(Main.osgi.getService(IModelService)).getModelsByInterface(IBattleField)[0]).getBattlefieldData().collisionDetector.intersectRay(hitPos,this._shotDirection,CollisionGroup.WEAPON,ricochetData.shotSpeed,null,rayHit))
            {
               if (this.rayHit.primitive.body != null)
			   {
					this.rayHit.primitive.body.addWorldForceScaled(this._muzzlePosGlobal, this._gunDirGlobal, commonData.kickback);
			   }
            }
      }
      
      public function hitSelf(clientObject:ClientObject, shooterId:String, relativeHitPosition:int) : void
      {
         var shooterData:TankData = this.getTankDataSafe(shooterId,clientObject.register);
         if(shooterData == null)
         {
            return;
         }
         var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(clientObject);
         var sfxData:RicochetSFXData = this.ricochetSfxModel.getSfxData(clientObject);
         var muzzlePosLocal:Vector3 = commonData.muzzles[0];
         this.weaponUtils.calculateGunParams(shooterData.tank.skin.turretMesh,muzzlePosLocal,this._muzzlePosGlobal,this._barrelOrigin,this._xAxis,this._gunDirGlobal);
         this.createSelfHitEffects(shooterData,sfxData,commonData,relativeHitPosition,this._barrelOrigin,this._gunDirGlobal);
      }
      
      public function initObject(clientObject:ClientObject, energyCapacity:int, energyPerShot:int, energyRechargeSpeed:Number, shotDistance:Number, shotRadius:Number, shotSpeed:Number) : void
      {
         var modelService:IModelService = null;
         var weaponData:RicochetData = new RicochetData(100 * shotRadius,100 * shotSpeed,energyCapacity,energyPerShot,energyRechargeSpeed,100 * shotDistance);
         clientObject.putParams(RicochetData,weaponData);
         WeaponsManager.getRicochetSFXModel(clientObject);
         if(this.battlefield == null)
         {
            modelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefield = IBattleField(modelService.getModelsByInterface(IBattleField)[0]);
            this.tankModel = TankModel(Main.osgi.getService(ITank));
            this.weaponCommonModel = IWeaponCommonModel(modelService.getModelsByInterface(IWeaponCommonModel)[0]);
         }
         this.objectLoaded(clientObject);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         var modelService:IModelService = null;
         if(this.weakeningModel == null)
         {
            modelService = IModelService(Main.osgi.getService(IModelService));
            this.weakeningModel = IWeaponWeakeningModel(modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
            this.ricochetSfxModel = WeaponsManager.getRicochetSFXModel(object);
         }
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
      }
      
      public function stopEffects(ownerTankData:TankData) : void
      {
      }
      
      public function reset() : void
      {
         this.readyTime = 0;
         this.currentEnergy = this.localRicochetData.energyCapacity;
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         var turretObject:ClientObject = localUserData.turret;
         this.localTankData = localUserData;
         this.localRicochetData = RicochetData(turretObject.getParams(RicochetData));
         this.localRicochetSFXData = RicochetSFXData(turretObject.getParams(RicochetSFXData));
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         this.localShotData = WeaponsManager.shotDatas[turretObject.id];
         this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
         var battleField:IBattleField = IBattleField(modelService.getModelsByInterface(IBattleField)[0]);
         var tanksCollisionDetector:TanksCollisionDetector = battleField.getBattlefieldData().collisionDetector;
         var commonTargetEvaluator:CommonTargetEvaluator = CommonTargetEvaluator.create(this.localTankData,this.localShotData,this.battlefield,this.weakeningModel,modelService);
         this.targetSystem = new RicochetTargetSystem(this.localShotData.autoAimingAngleUp.value,this.localShotData.numRaysUp.value,this.localShotData.autoAimingAngleDown.value,this.localShotData.numRaysDown.value,this.localRicochetData.shotDistance,tanksCollisionDetector,commonTargetEvaluator);
      }
      
      public function clearLocalUser() : void
      {
         this.localTankData = null;
         this.localRicochetData = null;
         this.localShotData = null;
         this.localWeaponCommonData = null;
         this.targetSystem = null;
      }
      
      public function activateWeapon(time:int) : void
      {
         this.triggerPressed = true;
      }
      
      public function deactivateWeapon(time:int, sendServerCommand:Boolean) : void
      {
         this.triggerPressed = false;
      }
      
      public function update(time:int, deltaTime:int) : Number
      {
         var energyCapacity:int = this.localRicochetData.energyCapacity;
         if(this.currentEnergy < energyCapacity)
         {
            this.currentEnergy = this.currentEnergy + this.localRicochetData.energyRechargeSpeed * deltaTime * 0.001;
            if(this.currentEnergy > energyCapacity)
            {
               this.currentEnergy = energyCapacity;
            }
         }
         if(this.triggerPressed && time >= this.readyTime && this.currentEnergy >= this.localRicochetData.energyPerShot)
         {
            this.doFire(this.localWeaponCommonData);
         }
         return this.currentEnergy / this.localRicochetData.energyCapacity;
      }
      
      public function shotHit(shot:RicochetShot, hitPoint:Vector3, hitDir:Vector3, targetBody:Body) : void
      {
         var targetTank:Tank = null;
         var targetTankData:TankData = null;
         var pos:Vector3 = null;
         var hitPos3d:Vector3d = null;
         var targetPos3d:Vector3d = null;
         this.createExplosion(hitPoint, shot.sfxData);
         if(shot.shooterData == this.localTankData)
         {
            targetTank = Tank(targetBody);
            targetTankData = targetTank.tankData;
            pos = new Vector3().vCopy(hitPoint).vSubtract(targetTank.state.pos);
            pos.vTransformBy3Tr(targetTank.baseMatrix);
            hitPos3d = new Vector3d(pos.x, pos.y, pos.z);
            pos = targetTank.state.pos;
            targetPos3d = new Vector3d(pos.x, pos.y, pos.z);
			targetBody.addWorldForceScaled(this._muzzlePosGlobal, this._gunDirGlobal, -this.localWeaponCommonData.kickback);
            this.hitCommand(this.localTankData.turret, targetTankData.user.id, shot.id, targetTankData.incarnation, hitPos3d, targetPos3d, hitDir.x * 32767, hitDir.y * 32767, hitDir.z * 32767, 0.01 * shot.totalDistance);
         }
      }
      
      private function hitCommand(turr:ClientObject, victimId:String, shotId:int, inc:int, hitPos3d:Vector3d, targetPos3d:Vector3d, x:Number, y:Number, z:Number, distance:Number) : void
      {
         var js:Object = new Object();
         js.victimId = victimId;
         js.shotId = shotId;
         js.distance = distance;
         js.hitPos3d = hitPos3d;
         js.x = x;
         js.y = y;
         js.z = z;
         js.self_hit = false;
         js.reloadTime = this.localShotData.reloadMsec.value;
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(js));
      }
      
      private function createExplosion(position:Vector3, sfxData:RicochetSFXData) : void
      {
         var explosionEffect:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(objectPoolService.objectPool.getObject(AnimatedSpriteEffectNew));
         var posProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
         posProvider.init(position,50);
         var animaton:TextureAnimation = sfxData.dataExplosion;
         explosionEffect.init(EXPLOSION_SIZE,EXPLOSION_SIZE,animaton,Math.random() * Math.PI * 2,posProvider,0.5,0.5,null,0,"normal",0,0,0);
         this.battlefield.addGraphicEffect(explosionEffect);
         this.addSoundEffect(sfxData.explosionSound,position,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,0.8);
      }
      
      private function addSoundEffect(sound:Sound, position:Vector3, nearRadius:Number, farRadius:Number, farDelimiter:Number, soundVolume:Number) : void
      {
         var sound3d:Sound3D = null;
         var soundEffect:Sound3DEffect = null;
         if(sound != null)
         {
            sound3d = Sound3D.create(sound,nearRadius,farRadius,farDelimiter,soundVolume);
            soundEffect = Sound3DEffect.create(objectPoolService.objectPool,null,position,sound3d);
            this.battlefield.addSound3DEffect(soundEffect);
         }
      }
      
      private function doFire(commonData:WeaponCommonData) : void
      {
         var relativeHitPosition:int = 0;
         var pos:Vector3 = null;
         var pos3d:Vector3d = null;
         var ricochetShot:RicochetShot = null;
         this.readyTime = getTimer() + this.localShotData.reloadMsec.value;
         this.currentEnergy = this.currentEnergy - this.localRicochetData.energyPerShot;
         var muzzlePosLocal:Vector3 = commonData.muzzles[0];
         this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,muzzlePosLocal,this._muzzlePosGlobal,this._barrelOrigin,this._xAxis,this._gunDirGlobal);
         if(this.battlefield.getBattlefieldData().collisionDetector.intersectRayWithStatic(this._barrelOrigin,this._gunDirGlobal,CollisionGroup.STATIC,muzzlePosLocal.y,null,this.rayHit))
         {
            relativeHitPosition = this.rayHit.t / muzzlePosLocal.y * 255 - 128;
            pos = this.localTankData.tank.state.pos;
            pos3d = new Vector3d(pos.x,pos.y,pos.z);
            this.createSelfHitEffects(this.localTankData,this.localRicochetSFXData,this.localWeaponCommonData,relativeHitPosition,this._barrelOrigin,this._gunDirGlobal);
            this.hitSelfCommand(this.localTankData.turret,this.localTankData.incarnation,relativeHitPosition,pos3d);
         }
         else
         {
            if(!this.targetSystem.getShotDirection(this._muzzlePosGlobal,this._gunDirGlobal,this._xAxis,this.localTankData.tank,this._shotDirection))
            {
               this._shotDirection.vCopy(this._gunDirGlobal);
            }
            ricochetShot = this.createShotEffects(this.localTankData,this.localRicochetData,this.localRicochetSFXData,commonData,muzzlePosLocal,this._muzzlePosGlobal,this._shotDirection,this._gunDirGlobal);
            this.fireCommand(this.localTankData.turret,ricochetShot.id,this._shotDirection.x * 32767,this._shotDirection.y * 32767,this._shotDirection.z * 32767);
         }
      }
      
      private function hitSelfCommand(turr:ClientObject, inc:int, relativeHitPos:int, pos3d:Vector3d) : void
      {
         var js:Object = new Object();
         js.self_hit = true;
         js.reloadTime = this.localShotData.reloadMsec.value;
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(js));
      }
      
      private function fireCommand(turr:ClientObject, shotid:int, x:Number, y:Number, z:Number) : void
      {
         var json:Object = new Object();
         json.shotid = shotid;
         json.x = x;
         json.y = y;
         json.z = z;
         Network(Main.osgi.getService(INetworker)).send("battle;start_fire;" + JSON.stringify(json));
      }
      
      private function createShotEffects(shooterData:TankData, ricochetData:RicochetData, ricochetSFXData:RicochetSFXData, weaponCommonData:WeaponCommonData, localMuzzlePosition:Vector3, globalMuzzlePosition:Vector3, shotDirection:Vector3, gunDirection:Vector3) : RicochetShot
      {
         var sound:Sound3D = null;
         var soundEffect:Sound3DEffect = null;
         var ricochetShot:RicochetShot = RicochetShot(objectPoolService.objectPool.getObject(RicochetShot));
         ricochetShot.init(globalMuzzlePosition,shotDirection,shooterData,ricochetData,ricochetSFXData,this.battlefield.getBattlefieldData().collisionDetector,this.weakeningModel,this,this.battlefield);
         this.battlefield.addGraphicEffect(ricochetShot);
         var shotFlashEffect:FlashEffect = FlashEffect(objectPoolService.objectPool.getObject(FlashEffect));
         shotFlashEffect.init(ricochetSFXData.shotFlashMaterial,localMuzzlePosition,shooterData.tank.skin.turretMesh,20,this.SHOT_FLASH_SIZE,this.SHOT_FLASH_DURATION,this.SHOT_FLASH_FADE,ricochetSFXData.colorTransform,0,0,Math.PI/2);
         this.battlefield.addGraphicEffect(shotFlashEffect);
         if(ricochetSFXData.shotSound != null)
         {
            sound = Sound3D.create(ricochetSFXData.shotSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,0.8);
            soundEffect = Sound3DEffect.create(objectPoolService.objectPool,null,globalMuzzlePosition,sound);
            this.battlefield.addSound3DEffect(soundEffect);
         }
         //shooterData.tank.addWorldForceScaled(globalMuzzlePosition, gunDirection, -weaponCommonData.kickback);
		 shooterData.tank.addWorldForceinP(globalMuzzlePosition,gunDirection,-weaponCommonData.kickback,globalMuzzlePosition);
         return ricochetShot;
      }
      
      private function createSelfHitEffects(shooterData:TankData, ricochetSFXData:RicochetSFXData, weaponCommonData:WeaponCommonData, relativeHitPos:int, globalBarrelOrigin:Vector3, gunDirection:Vector3) : void
      {
         var sound:Sound3D = null;
         var soundEffect:Sound3DEffect = null;
         var offsetAlongBarrel:Number = (relativeHitPos + 128) / 255 * weaponCommonData.muzzles[0].y;
         var hitPos:Vector3 = globalBarrelOrigin.vClone();
         hitPos.vAddScaled(offsetAlongBarrel,gunDirection);
         if(ricochetSFXData.shotSound != null)
         {
            sound = Sound3D.create(ricochetSFXData.shotSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,0.8);
            soundEffect = Sound3DEffect.create(objectPoolService.objectPool,null,hitPos,sound);
            this.battlefield.addSound3DEffect(soundEffect);
         }
         this.createExplosion(hitPos,ricochetSFXData);
         //shooterData.tank.addWorldForceScaled(globalBarrelOrigin,gunDirection,-weaponCommonData.impactForce);
		 shooterData.tank.addWorldForceinP(globalBarrelOrigin,gunDirection,-weaponCommonData.impactForce,globalBarrelOrigin);
      }
      
      private function getTankDataSafe(objectId:String, objectRegister:ObjectRegister) : TankData
      {
         var object:ClientObject = BattleController.activeTanks[objectId];
         if(object == null)
         {
            return null;
         }
         var tankData:TankData = this.tankModel.getTankData(object);
         if(tankData == null || tankData.tank == null)
         {
            return null;
         }
         return tankData;
      }
   }
}
