package alternativa.osgi.service.console
{
   public class ConsoleService implements IConsoleService
   {
       
      
      private var _console:Object;
      
      public function ConsoleService(console:Object)
      {
         super();
         this._console = console;
      }
      
      public function writeToConsole(message:String, ... vars) : void
      {
         var i:int = 0;
         if(this.console != null)
         {
            for(i = 0; i < vars.length; i++)
            {
               message = message.replace("%" + (i + 1),vars[i]);
            }
            this._console.write(message,0);
         }
      }
      
      public function writeToConsoleChannel(channel:String, message:String, ... vars) : void
      {
         var i:int = 0;
         if(this.console != null)
         {
            for(i = 0; i < vars.length; i++)
            {
               message = message.replace("%" + (i + 1),vars[i]);
            }
         }
      }
      
      public function hideConsole() : void
      {
         if(this._console != null)
         {
            this._console.hide();
         }
      }
      
      public function showConsole() : void
      {
         if(this._console != null)
         {
            this._console.show();
         }
      }
      
      public function clearConsole() : void
      {
         if(this._console != null)
         {
            this._console.clear();
         }
      }
      
      public function get console() : Object
      {
         return this._console;
      }
   }
}
