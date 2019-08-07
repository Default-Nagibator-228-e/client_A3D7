package alternativa.tanks.help
{
   import flash.text.TextFormat;
   
   public interface IHelpService
   {
       
      
      function registerHelper(param1:String, param2:int, param3:Helper, param4:Boolean) : void;
      
      function unregisterHelper(param1:String, param2:int) : void;
      
      function showHelper(param1:String, param2:int) : void;
      
      function hideHelper(param1:String, param2:int) : void;
      
      function showHelp() : void;
      
      function hideHelp() : void;
      
      function setHelperTextFormat(param1:TextFormat) : void;
   }
}
