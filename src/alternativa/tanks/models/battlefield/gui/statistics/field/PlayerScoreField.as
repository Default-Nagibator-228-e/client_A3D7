package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import assets.icons.BattleInfoIcons;
   import controls.Label;
   import controls.resultassets.WhiteFrame;
   
   public class PlayerScoreField extends IconField
   {
      
      private static const ICON_X:int = 9;
      
      private static const ICON_Y:int = 10;
      
      private static const LABEL_X:int = 9;
      
      private static const LABEL_Y:int = 6;
      
      private static const TEXT_SIZE:int = 18;
       
      
      private var whiteFrame:WhiteFrame;
      
      public function PlayerScoreField(iconType:int)
      {
         super(iconType);
      }
      
      override protected function init() : void
      {
         this.whiteFrame = new WhiteFrame();
         addChild(this.whiteFrame);
         if(iconType > -1)
         {
            icon = new BattleInfoIcons();
            icon.type = iconType;
            addChild(icon);
            icon.x = ICON_X;
            icon.y = ICON_Y;
         }
         label = new Label();
         label.color = 16777215;
         addChild(label);
         if(icon)
         {
            label.x = icon.x + icon.width + LABEL_X;
         }
         else
         {
            label.x = LABEL_X;
         }
         label.y = LABEL_Y;
         label.size = TEXT_SIZE;
         label.bold = true;
         this.score = 0;
      }
      
      public function set score(value:int) : void
      {
         text = value.toString();
         this.whiteFrame.width = label.x + label.width + 10;
      }
   }
}
