package utils.client.models.core.community.chat.types
{
   public class ChatMessage
   {
       
      
      public var sourceUser:UserChat;
      
      public var targetUser:UserChat;
      
      public var system:Boolean;
      
      public var text:String;
      
      public var sysCollor:uint;
      
      public function ChatMessage()
      {
         super();
      }
   }
}
