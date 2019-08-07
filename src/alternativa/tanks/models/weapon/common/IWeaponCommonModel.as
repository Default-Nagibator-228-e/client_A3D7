package alternativa.tanks.models.weapon.common
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public interface IWeaponCommonModel
   {
       
      
      function getCommonData(param1:ClientObject) : WeaponCommonData;
      
      function createShotEffects(param1:ClientObject, param2:Tank, param3:int, param4:Vector3, param5:Vector3) : void;
      
      function createExplosionEffects(param1:ClientObject, param2:Camera3D, param3:Boolean, param4:Vector3, param5:Vector3, param6:TankData, param7:Number) : void;
   }
}
