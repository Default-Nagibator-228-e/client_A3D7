package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import assets.icons.BattleInfoIcons;
   
   public class TDMScoreField extends TeamScoreFieldBase
   {
      
      private static const ICON_WIDTH:int = 17;
      
      private static const ICON_Y:int = 10;
       
      
      private var icon:BattleInfoIcons;
      
      public function TDMScoreField()
      {
         super();
         this.icon = new BattleInfoIcons();
         this.icon.type = BattleInfoIcons.KILL_LIMIT;
         addChild(this.icon);
         this.icon.y = ICON_Y;
      }
      
      override protected function calculateWidth() : int
      {
         var spacing:int = 5;
         var maxWidth:int = labelRed.width > labelBlue.width?int(labelRed.width):int(labelBlue.width);
         labelRed.x = spacing + spacing + (maxWidth - labelRed.width >> 1);
         this.icon.x = labelRed.x + maxWidth + spacing;
         labelBlue.x = this.icon.x + ICON_WIDTH + spacing + (maxWidth - labelBlue.width >> 1);
         return labelBlue.x + maxWidth + spacing + spacing;
      }
   }
}
