package alternativa.console
{
   public interface IConsole
   {
       
      
      function addToggleKey(param1:uint, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void;
      
      function addLine(param1:String) : void;
      
      function clear() : void;
      
      function dispose() : void;
      
      function addVariable(param1:ConsoleVar) : void;
      
      function removeVariable(param1:String) : void;
      
      function addCommandHandler(param1:String, param2:Function) : void;
      
      function removeCommandHandler(param1:String) : void;
      
      function getCommandList() : Array;
      
      function getAlpha() : Number;
      
      function setAlpha(param1:Number) : void;
      
      function getHeight() : int;
      
      function setHeight(param1:int) : void;
      
      function setFontSize(param1:int) : void;
      
      function show() : void;
      
      function hide() : void;
      
      function hideDelayed(param1:uint) : void;
      
      function isDebugMode() : Boolean;
      
      function getText() : String;
   }
}
