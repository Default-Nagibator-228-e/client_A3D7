package alternativa.network
{
   public interface ICommandSender
   {
       
      
      function sendCommand(param1:Object, param2:Boolean = false) : void;
      
      function close() : void;
      
      function get id() : int;
   }
}
