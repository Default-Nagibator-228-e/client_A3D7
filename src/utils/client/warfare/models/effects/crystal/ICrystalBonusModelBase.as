package utils.client.warfare.models.effects.crystal
{
   import utils.client.models.ClientObject;
   import alternativa.types.Long;
   
   public interface ICrystalBonusModelBase
   {
       
      
      function activated(param1:ClientObject, param2:Long, param3:int) : void;
   }
}
