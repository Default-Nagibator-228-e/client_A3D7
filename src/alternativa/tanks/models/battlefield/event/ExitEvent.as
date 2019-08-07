package alternativa.tanks.models.battlefield.event
{
   import flash.events.Event;
   
   public class ExitEvent extends Event
   {
      
      public static const EXIT:String = "exit";
       
      
      public function ExitEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
