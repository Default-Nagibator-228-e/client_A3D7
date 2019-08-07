package alternativa.tanks.models.battlefield.event
{
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import flash.events.Event;
   
   public class ChatOutputLineEvent extends Event
   {
      
      public static const KILL_ME:String = "KillMe";
       
      
      private var _line:MessageLine;
      
      public function ChatOutputLineEvent(type:String, line:MessageLine)
      {
         super(type,false,false);
         this._line = line;
      }
      
      public function get line() : MessageLine
      {
         return this._line;
      }
   }
}
