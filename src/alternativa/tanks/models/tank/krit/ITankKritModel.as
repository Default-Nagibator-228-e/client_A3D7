package alternativa.tanks.models.tank.krit
{
   import utils.client.models.ClientObject;
   import alternativa.tanks.models.tank.TankData;
   
   public interface ITankKritModel
   {
       
      
      function createExplosionEffects(param1:ClientObject, param2:TankData) : void;
   }
}
