package alternativa.tanks.models.battlefield.gui.statistics.messages
{
   import alternativa.tanks.models.battlefield.common.MessageContainer;
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import alternativa.tanks.models.battlefield.event.ChatOutputLineEvent;
   
   public class BattleMessagesOutput extends MessageContainer
   {
       
      
      public var maxMessages:int = 10;
      
      public function BattleMessagesOutput()
      {
         super();
      }
      
      public function addLine(line:UserActionOutputLine) : void
      {
         var msg:MessageLine = null;
         pushMessage(line);
         if(container.numChildren > this.maxMessages)
         {
            msg = shiftMessages();
            if(msg != null)
            {
               msg.removeEventListener(ChatOutputLineEvent.KILL_ME,this.onKillLine);
            }
         }
         line.addEventListener(ChatOutputLineEvent.KILL_ME,this.onKillLine);
         line.x = -line.width - 10;
      }
      
      private function onKillLine(e:ChatOutputLineEvent) : void
      {
         if(container.contains(e.line))
         {
            shiftMessages();
         }
         e.line.removeEventListener(ChatOutputLineEvent.KILL_ME,this.onKillLine);
      }
   }
}
