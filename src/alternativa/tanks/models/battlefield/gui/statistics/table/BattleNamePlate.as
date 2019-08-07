package alternativa.tanks.models.battlefield.gui.statistics.table
{
   import controls.Label;
   import controls.statassets.BlackRoundRect;
   
   public class BattleNamePlate extends BlackRoundRect
   {
      
      private static const PADDING:int = 3;
       
      
      private var label:Label;
      
      public function BattleNamePlate(battleName:String, fontSize:int)
      {
         super();
         this.label = new Label();
         this.label.size = fontSize;
         this.label.text = battleName;
         addChild(this.label);
         this.label.y = PADDING;
         height = 2 * PADDING + this.label.height;
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         this.label.x = int(width - this.label.width) >> 1;
      }
   }
}
