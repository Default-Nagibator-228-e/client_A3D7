package alternativa.tanks.models.weapon.weakening
{
   import utils.client.models.ClientObject;
   
   public interface IWeaponWeakeningModel
   {
       
      
      function getImpactCoeff(param1:ClientObject, param2:Number) : Number;
      
      function getFullDamageRadius(param1:ClientObject) : Number;
   }
}
