package alternativa.osgi.service.focus
{
   import flash.display.DisplayObject;
   
   public interface IFocusService
   {
       
      
      function addFocusListener(param1:IFocusListener) : void;
      
      function removeFocusListener(param1:IFocusListener) : void;
      
      function getFocus() : Object;
      
      function clearFocus(param1:DisplayObject) : void;
   }
}
