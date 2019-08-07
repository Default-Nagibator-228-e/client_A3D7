package alternativa.tanks.models.weapon
{
   import alternativa.tanks.models.tank.TankData;
   
   public interface IWeaponController
   {
       
      
      function stopEffects(param1:TankData) : void;
      
      function reset() : void;
      
      function setLocalUser(param1:TankData) : void;
      
      function clearLocalUser() : void;
      
      function activateWeapon(param1:int) : void;
      
      function deactivateWeapon(param1:int, param2:Boolean) : void;
      
      function update(param1:int, param2:int) : Number;
   }
}
