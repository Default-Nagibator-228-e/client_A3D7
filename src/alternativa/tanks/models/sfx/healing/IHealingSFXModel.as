package alternativa.tanks.models.sfx.healing
{
   import alternativa.tanks.models.tank.TankData;
   import utils.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   
   public interface IHealingSFXModel
   {
       
      
      function createOrUpdateEffects(param1:TankData, param2:IsisActionType, param3:TankData) : void;
      
      function destroyEffectsByOwner(param1:TankData) : void;
      
      function destroyEffectsByTarget(param1:TankData) : void;
   }
}
