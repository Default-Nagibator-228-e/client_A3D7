package alternativa.osgi.service.focus
{
   public interface IFocusListener
   {
       
      
      function focusIn(param1:Object) : void;
      
      function focusOut(param1:Object) : void;
      
      function activate() : void;
      
      function deactivate() : void;
   }
}
