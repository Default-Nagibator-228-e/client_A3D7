package alternativa.tanks.models.weapon
{
   import utils.client.models.ClientObject;
   
   public interface IWeapon
   {
       
      
      function ownerLoaded(param1:ClientObject) : void;
      
      function ownerUnloaded(param1:ClientObject) : void;
      
      function ownerDisabled(param1:ClientObject) : void;
      
      function update(param1:int, param2:int) : Number;
      
      function reset() : void;
      
      function enable() : void;
      
      function disable() : void;
      
      function stop() : void;
      
      function getTurretRotationAccel(param1:ClientObject) : Number;
      
      function getTurretRotationSpeed(param1:ClientObject) : Number;
      
      function getWeaponController() : IWeaponController;
   }
}
