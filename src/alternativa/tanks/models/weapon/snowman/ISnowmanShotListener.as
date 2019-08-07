package alternativa.tanks.models.weapon.snowman
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public interface ISnowmanShotListener
   {
       
      
      function snowShotDissolved(param1:SnowmanShot) : void;
      
      function snowShotHit(param1:SnowmanShot, param2:Vector3, param3:Vector3, param4:Body) : void;
   }
}
