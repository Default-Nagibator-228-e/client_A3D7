package alternativa.tanks.models.tank
{
   public interface ITankEventDispatcher
   {
       
      
      function addTankEventListener(param1:int, param2:ITankEventListener) : void;
      
      function removeTankEventListener(param1:int, param2:ITankEventListener) : void;
      
      function dispatchEvent(param1:int, param2:TankData) : void;
   }
}
