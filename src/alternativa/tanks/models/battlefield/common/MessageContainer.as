package alternativa.tanks.models.battlefield.common
{
   import flash.display.Sprite;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class MessageContainer extends Sprite
   {
      
      private static const BLUE_TEAM_FONT_COLOR:uint = 4691967;
      
      private static const RED_TEAM_FONT_COLOR:uint = 15741974;
      
      private static const DEFAULT_FONT_COLOR:uint = 65280;
       
      
      public var messageSpacing:int = 3;
      
      protected var container:Sprite;
      
      protected var shift:Number;
      
      public function MessageContainer()
      {
         this.container = new Sprite();
         super();
         addChild(this.container);
      }
      
      public static function getTeamFontColor(teamType:BattleTeamType) : uint
      {
         switch(teamType)
         {
            case BattleTeamType.BLUE:
               return BLUE_TEAM_FONT_COLOR;
            case BattleTeamType.RED:
               return RED_TEAM_FONT_COLOR;
            default:
               return DEFAULT_FONT_COLOR;
         }
      }
      
      public function shiftMessages(deleteFromBuffer:Boolean = false) : MessageLine
      {
         var len:int = this.container.numChildren;
         if(len == 0)
         {
            return null;
         }
         var element:MessageLine = MessageLine(this.container.getChildAt(0));
         this.shift = int(element.height + element.y + this.messageSpacing);
         this.container.removeChild(element);
         len--;
         for(var i:int = 0; i < len; i++)
         {
            this.container.getChildAt(i).y = this.container.getChildAt(i).y - this.shift;
         }
         return element;
      }
      
      protected function unshiftMessage(line:MessageLine) : void
      {
         line.y = 0;
         line.alpha = 1;
         this.container.addChildAt(line,0);
         var len:int = this.container.numChildren;
         for(var i:int = 1; i < len; i++)
         {
            this.container.getChildAt(i).y = this.container.getChildAt(i).y + int(line.height + this.messageSpacing);
         }
      }
      
      protected function pushMessage(line:MessageLine) : void
      {
         var curY:int = this.container.numChildren > 0?int(int(this.container.height + this.messageSpacing)):int(0);
         line.y = curY;
         this.container.addChild(line);
      }
   }
}
