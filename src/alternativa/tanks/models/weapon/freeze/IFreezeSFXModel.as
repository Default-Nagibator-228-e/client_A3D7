package alternativa.tanks.models.weapon.freeze
{
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   
   public interface IFreezeSFXModel
   {
       
      
      function createEffects(param1:TankData, param2:WeaponCommonData) : void;
      
      function destroyEffects(param1:TankData) : void;
   }
}
