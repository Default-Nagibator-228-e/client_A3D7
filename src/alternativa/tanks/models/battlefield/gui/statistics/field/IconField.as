package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import assets.icons.BattleInfoIcons;
   import controls.Label;
   import flash.display.Sprite;
   
   public class IconField extends Sprite
   {
       
      
      protected var icon:BattleInfoIcons;
      
      protected var iconType:int;
      
      protected var label:Label;
      
      public function IconField(iconType:int = -1)
      {
         super();
         this.iconType = iconType;
         this.init();
      }
      
      protected function init() : void
      {
         if(this.iconType > -1)
         {
            this.icon = new BattleInfoIcons();
            this.icon.type = this.iconType;
            addChild(this.icon);
            this.icon.x = 0;
            this.icon.y = 0;
         }
         this.label = new Label();
         this.label.color = 16777215;
         if(this.icon)
         {
            this.label.x = this.icon.width + 3;
         }
         addChild(this.label);
      }
      
      public function set text(value:String) : void
      {
         this.label.htmlText = value;
      }
      
      public function set size(value:Number) : void
      {
         this.label.size = value;
      }
   }
}
