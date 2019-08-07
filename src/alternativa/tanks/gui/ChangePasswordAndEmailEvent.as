package alternativa.tanks.gui
{
   import flash.events.Event;
   
   public class ChangePasswordAndEmailEvent extends Event
   {
      
      public static const CHANGE_PRESSED:String = "ChangePressed";
      
      public static const CANCEL_PRESSED:String = "ChancelPressed";
       
      
      public function ChangePasswordAndEmailEvent(type:String)
      {
         super(type);
      }
   }
}
