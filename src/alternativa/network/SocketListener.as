package alternativa.network
{
   import alternativa.network.ICommandHandler;
   import alternativa.network.ICommandSender;
   
   public class SocketListener implements ICommandHandler
   {
       
      
      public function SocketListener()
      {
         super();
      }
      
      public function open() : void
      {
      }
      
      public function close() : void
      {
      }
      
      public function disconnect(errorMessage:String) : void
      {
      }
      
      public function executeCommand(command:Object) : void
      {
      }
      
      public function get commandSender() : ICommandSender
      {
         return null;
      }
      
      public function set commandSender(commandSender:ICommandSender) : void
      {
      }
   }
}
