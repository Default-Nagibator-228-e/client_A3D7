package alternativa.network
{
   public interface ICommandHandler
   {
       
      
      function open() : void;
      
      function close() : void;
      
      function disconnect(param1:String) : void;
      
      function executeCommand(param1:Object) : void;
      
      function get commandSender() : ICommandSender;
      
      function set commandSender(param1:ICommandSender) : void;
   }
}
