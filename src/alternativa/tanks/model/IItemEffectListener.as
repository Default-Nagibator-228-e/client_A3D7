package alternativa.tanks.model
{
   public interface IItemEffectListener
   {
       
      
      function setTimeRemaining(param1:String, param2:Number) : void;
      
      function effectStopped(param1:String) : void;
   }
}
