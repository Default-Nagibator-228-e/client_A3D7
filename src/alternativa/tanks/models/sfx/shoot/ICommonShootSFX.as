package alternativa.tanks.models.sfx.shoot
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.sfx.EffectsPair;
   
   public interface ICommonShootSFX
   {
       
      
      function createShotEffects(param1:ClientObject, param2:Vector3, param3:Object3D, param4:Camera3D) : EffectsPair;
      
      function createExplosionEffects(param1:ClientObject, param2:Vector3, param3:Camera3D, param4:Number) : EffectsPair;
   }
}
