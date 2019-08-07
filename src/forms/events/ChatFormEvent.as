package forms.events
{
   import flash.events.Event;
   
   public class ChatFormEvent extends Event
   {
      
      public static const SEND_MESSAGE:String = "SendMessage";
       
      
      public var rangTo:int;
      
      public var nameTo:String;
      
      public function ChatFormEvent(_rangTo:int = 0, _nameTo:String = "")
      {
         this.rangTo = _rangTo;
         this.nameTo = _nameTo;
         super(SEND_MESSAGE,true,false);
      }
   }
}
