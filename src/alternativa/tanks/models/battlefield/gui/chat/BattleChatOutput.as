package alternativa.tanks.models.battlefield.gui.chat
{
   import alternativa.tanks.models.battlefield.common.MessageContainer;
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import alternativa.tanks.models.battlefield.event.ChatOutputLineEvent;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class BattleChatOutput extends MessageContainer
   {
       
      
      private const MAX_MESSAGES:int = 100;
      
      private const MIN_MESSAGES:int = 5;
      
      private var buffer:Array;
      
      private var minimizedMode:Boolean = true;
      
      public function BattleChatOutput()
      {
         this.buffer = [];
         super();
      }
      
      public function addLine(messageLabel:String, userRank:int, userName:String, teamType:BattleTeamType, text:String) : void
      {
         if(this.minimizedMode && container.numChildren > this.MIN_MESSAGES || !this.minimizedMode && container.numChildren >= this.MAX_MESSAGES)
         {
            this.shiftMessages();
         }
         var color:uint = getTeamFontColor(teamType);
         var line:BattleChatLine = new BattleChatLine(300,messageLabel,userRank,userName,text,color);
         line.addEventListener(ChatOutputLineEvent.KILL_ME,this.onKillLine);
         this.buffer.push(line);
         if(this.buffer.length > this.MAX_MESSAGES)
         {
            this.buffer.shift();
         }
         pushMessage(line);
      }
      
      public function addSpectatorLine(text:String) : void
      {
         if(this.minimizedMode && container.numChildren > this.MIN_MESSAGES || !this.minimizedMode && container.numChildren >= this.MAX_MESSAGES)
         {
            this.shiftMessages();
         }
         var line:SpectatorMessageLine = new SpectatorMessageLine(300,text);
         line.addEventListener(ChatOutputLineEvent.KILL_ME,this.onKillLine);
         this.buffer.push(line);
         if(this.buffer.length > this.MAX_MESSAGES)
         {
            this.buffer.shift();
         }
         pushMessage(line);
      }
      
      public function addSystemMessage(text:String) : void
      {
         if(this.minimizedMode && container.numChildren > this.MIN_MESSAGES || !this.minimizedMode && container.numChildren >= this.MAX_MESSAGES)
         {
            this.shiftMessages();
         }
         var line:BattleChatSystemLine = new BattleChatSystemLine(300,text);
         line.addEventListener(ChatOutputLineEvent.KILL_ME,this.onKillLine);
         this.buffer.push(line);
         if(this.buffer.length > this.MAX_MESSAGES)
         {
            this.buffer.shift();
         }
         pushMessage(line);
      }
      
      override public function shiftMessages(deleteFromBuffer:Boolean = false) : MessageLine
      {
         var line:MessageLine = super.shiftMessages();
         this.y = this.y + shift;
         if(deleteFromBuffer)
         {
            this.buffer.shift();
         }
         return line;
      }
      
      public function maximize() : void
      {
         var i:int = 0;
         var line:MessageLine = null;
         this.minimizedMode = false;
         var len:int = this.buffer.length - container.numChildren;
         for(i = 0; i < container.numChildren; i++)
         {
            line = MessageLine(container.getChildAt(i));
            line.killStop();
         }
         for(i = len - 1; i >= 0; i--)
         {
            try
            {
               unshiftMessage(MessageLine(this.buffer[i]));
            }
            catch(err:Error)
            {
            }
         }
      }
      
      public function minimize() : void
      {
         var i:int = 0;
         var line:MessageLine = null;
         this.minimizedMode = true;
         var len:int = container.numChildren - this.MIN_MESSAGES;
         for(i = 0; i < len; i++)
         {
            this.shiftMessages();
         }
         for(i = 0; i < container.numChildren; i++)
         {
            line = MessageLine(container.getChildAt(i));
            if(!line.live)
            {
               this.shiftMessages();
               i--;
            }
            else
            {
               line.killStart();
            }
         }
      }
      
      public function clear() : void
      {
         this.buffer.length = 0;
         for(var i:int = container.numChildren - 1; i >= 0; i--)
         {
            container.removeChildAt(i);
         }
      }
      
      private function onKillLine(e:ChatOutputLineEvent) : void
      {
         if(this.minimizedMode && container.contains(e.line))
         {
            this.shiftMessages();
         }
         e.line.removeEventListener(ChatOutputLineEvent.KILL_ME,this.onKillLine);
      }
   }
}
