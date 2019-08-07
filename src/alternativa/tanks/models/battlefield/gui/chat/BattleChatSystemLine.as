package alternativa.tanks.models.battlefield.gui.chat
{
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import controls.Label;
   
   public class BattleChatSystemLine extends MessageLine
   {
       
      
      private var output:Label;
      
      private var _width:int;
      
      public function BattleChatSystemLine(width:int, text:String)
      {
         this.output = new Label();
         super();
         this.output.color = 8454016;
         this.output.multiline = true;
         this.output.wordWrap = true;
         this.output.mouseEnabled = false;
         this.output.text = text;
         addChild(this.output);
         this.width = width;
      }
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         this.output.width = this._width - 5;
      }
   }
}
