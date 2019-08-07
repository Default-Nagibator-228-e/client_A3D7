package alternativa.tanks.models.weapon.plasma
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public interface IPlasmaShotListener
   {
       
      
      function plasmaShotDissolved(param1:PlasmaShot) : void;
      
      function plasmaShotHit(param1:PlasmaShot, param2:Vector3, param3:Vector3, param4:Body) : void;
   }
}
