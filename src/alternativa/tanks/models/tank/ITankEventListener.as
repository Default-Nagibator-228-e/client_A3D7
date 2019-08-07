package alternativa.tanks.models.tank
{
   public interface ITankEventListener
   {
       
      
      function handleTankEvent(param1:int, param2:TankData) : void;
   }
}
