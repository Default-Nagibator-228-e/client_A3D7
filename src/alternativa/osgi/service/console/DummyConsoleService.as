package alternativa.osgi.service.console
{
   public class DummyConsoleService implements IConsoleService
   {
       
      
      public function DummyConsoleService()
      {
         super();
      }
      
      public function showConsole() : void
      {
      }
      
      public function hideConsole() : void
      {
      }
      
      public function clearConsole() : void
      {
      }
      
      public function writeToConsole(message:String, ... vars) : void
      {
      }
      
      public function writeToConsoleChannel(channel:String, message:String, ... vars) : void
      {
      }
      
      public function get console() : Object
      {
         return null;
      }
   }
}
