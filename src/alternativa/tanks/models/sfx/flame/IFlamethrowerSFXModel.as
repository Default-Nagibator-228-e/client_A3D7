package alternativa.tanks.models.sfx.flame
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.sfx.EffectsPair;
   
   public interface IFlamethrowerSFXModel
   {
       
      
      function getSpecialEffects(param1:TankData, param2:Vector3, param3:Object3D, param4:IWeaponWeakeningModel) : EffectsPair;
   }
}
