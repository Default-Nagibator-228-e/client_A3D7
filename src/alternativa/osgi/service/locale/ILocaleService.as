package alternativa.osgi.service.locale
{
   import flash.display.BitmapData;
   
   public interface ILocaleService
   {
       
      
      function registerText(param1:String, param2:String) : void;
      
      function registerTextArray(param1:String, param2:Array) : void;
      
      function registerTextMulty(param1:Array) : void;
      
      function registerImage(param1:String, param2:BitmapData) : void;
      
      function getText(param1:String, ... rest) : String;
      
      function getTextArray(param1:String) : Array;
      
      function getImage(param1:String) : BitmapData;
      
      function get language() : String;
   }
}
