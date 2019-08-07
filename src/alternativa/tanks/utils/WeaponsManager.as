package alternativa.tanks.utils
{
   import alternativa.init.Main;
   import utils.client.models.ClientObject;
   import alternativa.register.ClientClass;
   import alternativa.tanks.models.sfx.flame.FlamethrowerSFXModel;
   import alternativa.tanks.models.sfx.healing.HealingGunSFXModel;
   import alternativa.tanks.models.sfx.shoot.ICommonShootSFX;
   import alternativa.tanks.models.sfx.shoot.gun.SmokySFXModel;
   import alternativa.tanks.models.sfx.shoot.plasma.PlasmaSFXModel;
   import alternativa.tanks.models.sfx.shoot.railgun.RailgunSFXModel;
   import alternativa.tanks.models.sfx.shoot.ricochet.RicochetSFXModel;
   import alternativa.tanks.models.sfx.shoot.shaft.ShaftSFXModel;
   import alternativa.tanks.models.sfx.shoot.snowman.SnowmanSFXModel;
   import alternativa.tanks.models.sfx.shoot.thunder.ThunderSFXModel;
   import alternativa.tanks.models.weapon.IWeapon;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonModel;
   import alternativa.tanks.models.weapon.freeze.FreezeSFXModel;
   import utils.client.warfare.models.sfx.healing.IHealingSFXModelBase;
   import flash.utils.Dictionary;
   
   public class WeaponsManager
   {
      
      public static var shotDatas:Dictionary = new Dictionary();
      
      public static var specialEntity:Dictionary = new Dictionary();
      
      private static var railgunSFXModels:Dictionary = new Dictionary();
      
      private static var smokySFXModels:Dictionary = new Dictionary();
      
      private static var flamethrowerSFXModels:Dictionary = new Dictionary();
      
      private static var twinsSFXModels:Dictionary = new Dictionary();
      
      private static var isidaSFXModel:HealingGunSFXModel;
      
      private static var thunderSFXModels:ThunderSFXModel;
      
      private static var frezeeSFXModels:FreezeSFXModel;
      
      private static var ricochetSFXModels:RicochetSFXModel;
      
      private static var shaftSFXModel:Dictionary = new Dictionary();
      
      private static var turretObjects:Dictionary = new Dictionary();
      
      private static var snowmanSFXModels:Dictionary = new Dictionary();
       
      
      public function WeaponsManager()
      {
         super();
      }
      
      public static function getWeapon(owner:ClientObject, clientObject:ClientObject, impactForce:Number, kickback:Number, turretRotationAcceleration:Number, turretRotationSpeed:Number) : IWeapon
      {
         var model:WeaponCommonModel = Main.osgi.getService(IWeaponCommonModel) as WeaponCommonModel;
         if(model == null)
         {
            model = new WeaponCommonModel();
            Main.osgi.registerService(IWeaponCommonModel,model);
         }
         model.initObject(clientObject,impactForce,kickback,turretRotationAcceleration,turretRotationSpeed);
         model.objectLoaded(clientObject);
         return model;
      }
      
      public static function getRailgunSFX(clientObject:ClientObject) : RailgunSFXModel
      {
         var returned:RailgunSFXModel = null;
         if(railgunSFXModels == null)
         {
            railgunSFXModels = new Dictionary();
         }
         if(railgunSFXModels[clientObject.id] == null)
         {
            railgunSFXModels[clientObject.id] = new RailgunSFXModel();
            railgunSFXModels[clientObject.id].initObject(clientObject,clientObject.id + "_" + "chargingPart1",clientObject.id + "_" + "chargingPart2",clientObject.id + "_" + "chargingPart3",clientObject.id + "_" + "shot",clientObject.id + "_" + "ashot");
         }
         returned = railgunSFXModels[clientObject.id];
         if(returned == null)
         {
            throw new Error("А где FearMachine????" + clientObject.id);
         }
         return returned;
      }
      
      public static function getSmokySFX(clientObject:ClientObject) : SmokySFXModel
      {
         var returnObject:SmokySFXModel = null;
         if(smokySFXModels == null)
         {
            smokySFXModels = new Dictionary();
         }
         if(smokySFXModels[clientObject.id] == null)
         {
            smokySFXModels[clientObject.id] = new SmokySFXModel();
            smokySFXModels[clientObject.id].initObject(clientObject,clientObject.id + "_explosion",clientObject.id + "_explosion_sound",clientObject.id + "_shot",clientObject.id + "_shot_sound");
         }
         returnObject = smokySFXModels[clientObject.id];
         return returnObject;
      }
      
      public static function getFlamethrowerSFX(clientObject:ClientObject) : FlamethrowerSFXModel
      {
         if(flamethrowerSFXModels == null)
         {
            flamethrowerSFXModels = new Dictionary();
         }
         if(flamethrowerSFXModels[clientObject.id] == null)
         {
            flamethrowerSFXModels[clientObject.id] = new FlamethrowerSFXModel();
            flamethrowerSFXModels[clientObject.id].initObject(clientObject,clientObject.id + "_fire","flamethrower_sound");
         }
         return flamethrowerSFXModels[clientObject.id];
      }
      
      public static function getTwinsSFX(clientObject:ClientObject) : PlasmaSFXModel
      {
         if(twinsSFXModels == null)
         {
            twinsSFXModels = new Dictionary();
         }
         if(twinsSFXModels[clientObject.id] == null)
         {
            twinsSFXModels[clientObject.id] = new PlasmaSFXModel();
            twinsSFXModels[clientObject.id].initObject(clientObject,"twins_explosionSound",clientObject.id + "_explosionTexture",clientObject.id + "_plasmaTexture","twins_shotSound",clientObject.id + "_shotTexture");
         }
         return twinsSFXModels[clientObject.id];
      }
      
      public static function getIsidaSFX(clientObject:ClientObject) : HealingGunSFXModel
      {
         if(isidaSFXModel == null)
         {
            isidaSFXModel = new HealingGunSFXModel();
            Main.osgi.registerService(IHealingSFXModelBase,isidaSFXModel);
         }
         isidaSFXModel.initObject(clientObject,clientObject.id + "_damagingRayId","damagingSoundId",clientObject.id + "_damagingTargetBallId",clientObject.id + "_damagingWeaponBallId",clientObject.id + "_healingRayId","healingSoundId",clientObject.id + "_healingTargetBallId",clientObject.id + "_healingWeaponBallId","idleSoundId",clientObject.id + "_idleWeaponBallId");
         return isidaSFXModel;
      }
      
      public static function getThunderSFX(clientObject:ClientObject) : ThunderSFXModel
      {
         if(thunderSFXModels == null)
         {
            thunderSFXModels = new ThunderSFXModel();
         }
         thunderSFXModels.initObject(clientObject,clientObject.id + "_explosionResourceId","thunder_explosionSoundResourceId",clientObject.id + "_shotResourceId","thunder_shotSoundResourceId");
         return thunderSFXModels;
      }
      
      public static function getFrezeeSFXModel(clientObject:ClientObject) : FreezeSFXModel
      {
         if(frezeeSFXModels == null)
         {
            frezeeSFXModels = new FreezeSFXModel();
         }
         frezeeSFXModels.initObject(clientObject,17,clientObject.id + "_particleTextureResourceId",clientObject.id + "_planeTextureResourceId","frezee_sound");
         return frezeeSFXModels;
      }
      
      public static function getRicochetSFXModel(clientObject:ClientObject) : RicochetSFXModel
      {
         if(ricochetSFXModels == null)
         {
            ricochetSFXModels = new RicochetSFXModel();
         }
         ricochetSFXModels.initObject(clientObject,clientObject.id + "_bumpFlashTextureId","ricochet_explosionSoundId",clientObject.id + "_explosionTextureId","ricochetSoundId",clientObject.id + "_shotFlashTextureId","ricochet_shotSoundId",clientObject.id + "_shotTextureId",clientObject.id + "_tailTrailTextureId");
         return ricochetSFXModels;
      }
      
      public static function getShaftSFX(clientObject:ClientObject) : ShaftSFXModel
      {
         var returnObject:ShaftSFXModel = null;
         if(shaftSFXModel == null)
         {
            shaftSFXModel = new Dictionary();
         }
         if(shaftSFXModel[clientObject.id] == null)
         {
			//throw new Error(clientObject.id);
            shaftSFXModel[clientObject.id] = new ShaftSFXModel();
            shaftSFXModel[clientObject.id].initObject(clientObject,clientObject.id + "_explosion",clientObject.id + "_explosion_sound",clientObject.id + "_shot",clientObject.id + "_shot_sound");
         }
         returnObject = shaftSFXModel[clientObject.id];
         return returnObject;
      }
      
      public static function getObjectFor(id:String) : ClientObject
      {
         if(turretObjects[id] == null)
         {
            turretObjects[id] = initObject(id);
         }
         return turretObjects[id];
      }
      
      public static function getSnowmanSFX(clientObject:ClientObject) : SnowmanSFXModel
      {
         if(snowmanSFXModels == null)
         {
            snowmanSFXModels = new Dictionary();
         }
         if(snowmanSFXModels[clientObject.id] == null)
         {
            snowmanSFXModels[clientObject.id] = new SnowmanSFXModel();
            snowmanSFXModels[clientObject.id].initObject(clientObject,"snowman_shotExplosion",clientObject.id + "_fire",clientObject.id + "_snow","snowman_shotSound",clientObject.id + "_snow");
         }
         return snowmanSFXModels[clientObject.id];
      }
      
      public static function getCommonShotSFX(turret:ClientObject) : ICommonShootSFX
      {
         var returnObject:ICommonShootSFX = null;
         var id:String = turret.id.split("_")[0];
         switch(id)
         {
            case "smoky":
               returnObject = getSmokySFX(turret);
               break;
            case "twins":
               returnObject = getTwinsSFX(turret);
               break;
            case "shaft":
               returnObject = getShaftSFX(turret);
               break;
            case "snowman":
               returnObject = getSnowmanSFX(turret);
         }
         return returnObject;
      }
      
      private static function initObject(id:String) : ClientObject
      {
         var obj:ClientObject = new ClientObject(id,new ClientClass(id,null,id,null),id,null);
         return obj;
      }
      
      public static function destroy() : void
      {
         isidaSFXModel = null;
         twinsSFXModels = null;
         flamethrowerSFXModels = null;
         smokySFXModels = null;
         railgunSFXModels = null;
         thunderSFXModels = null;
         ricochetSFXModels = null;
         frezeeSFXModels = null;
         shaftSFXModel = null;
         snowmanSFXModels = null;
      }
   }
}
