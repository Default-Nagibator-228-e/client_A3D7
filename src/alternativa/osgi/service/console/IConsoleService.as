package alternativa.osgi.service.console
{
   public interface IConsoleService
   {
       
      
      function showConsole() : void;
      
      function hideConsole() : void;
      
      function clearConsole() : void;
      
      function writeToConsole(param1:String, ... rest) : void;
      
      function writeToConsoleChannel(param1:String, param2:String, ... rest) : void;
      
      function get console() : Object;
   }
}
