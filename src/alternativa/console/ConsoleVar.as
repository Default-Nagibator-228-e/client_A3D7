package alternativa.console
{
   import alternativa.init.Main;
   
   public class ConsoleVar
   {
       
      
      protected var varName:String;
      
      protected var inputListener:Function;
      
      public function ConsoleVar(varName:String, inputListener:Function = null)
      {
         super();
         this.varName = varName;
         this.inputListener = inputListener;
         var console:IConsole = IConsole(Main.osgi.getService(IConsole));
         if(console != null)
         {
            console.addVariable(this);
         }
      }
      
      public function getName() : String
      {
         return this.varName;
      }
      
      public function destroy() : void
      {
         var console:IConsole = IConsole(Main.osgi.getService(IConsole));
         if(console != null)
         {
            console.removeVariable(this.varName);
         }
         this.inputListener = null;
      }
      
      public function processConsoleInput(console:IConsole, params:Array) : void
      {
         var oldValue:String = null;
         var errorText:String = null;
         if(params.length == 0)
         {
            console.addLine(this.varName + " = " + this.toString());
         }
         else
         {
            oldValue = this.toString();
            errorText = this.acceptInput(params[0]);
            if(errorText == null)
            {
               console.addLine(this.varName + " is set to " + this.toString() + " (was " + oldValue + ")");
               if(this.inputListener != null)
               {
                  this.inputListener.call(null,this);
               }
            }
            else
            {
               console.addLine(errorText);
            }
         }
      }
      
      protected function acceptInput(value:String) : String
      {
         return "Not implemented";
      }
      
      public function toString() : String
      {
         return "Not implemented";
      }
   }
}
