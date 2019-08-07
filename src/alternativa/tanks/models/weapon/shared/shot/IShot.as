package alternativa.tanks.models.weapon.shared.shot
{
   import utils.client.models.ClientObject;
   
   public interface IShot
   {
       
      
      function getShotData(param1:ClientObject) : ShotData;
   }
}
