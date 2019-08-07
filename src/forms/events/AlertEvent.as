package forms.events
{
   import flash.events.Event;
   
   public class AlertEvent extends Event
   {
      
      public static const ALERT_BUTTON_PRESSED:String = "CloseAlert";
       
      
      private var _typeButton:String;
      
      public function AlertEvent(typeButton:String)
      {
         super(ALERT_BUTTON_PRESSED,true,false);
         this._typeButton = typeButton;
      }
      
      public function get typeButton() : String
      {
         return this._typeButton;
      }
   }
}
