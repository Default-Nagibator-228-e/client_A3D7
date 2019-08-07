package alternativa.tanks.models.weapon.ricochet
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public interface IRicochetShotListener
   {
       
      
      function shotHit(param1:RicochetShot, param2:Vector3, param3:Vector3, param4:Body) : void;
   }
}
