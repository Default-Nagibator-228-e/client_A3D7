package alternativa.tanks.models.battlefield.gui
{
   import assets.IconAlarm;
   import controls.Label;
   import controls.statassets.BlackRoundRect;
   import flash.text.TextFieldAutoSize;
   
   public class PauseIndicator extends BlackRoundRect
   {
       
      
      private var label1:Label;
      
      private var label2:Label;
      
      private var timelLabel:Label;
      
      private var battleLeaveText:String;
      
      private var _seconds:int;
      
      public function PauseIndicator(pauseEnabledText:String, pressAnyKeyText:String, battleLeaveText:String)
      {
         super();
         this.battleLeaveText = battleLeaveText;
         var topBottomMargin:int = 33;
         var leftRightMargin:int = 33;
         var spacing:int = 5;
         var fontSize:int = 15;
         var icon:IconAlarm = new IconAlarm();
         addChild(icon);
         icon.y = topBottomMargin;
         var yy:int = icon.y + icon.height + 2 * spacing;
         this.label1 = new Label();
         this.label1.size = fontSize;
         this.label1.text = pauseEnabledText;
         this.label1.y = yy;
         addChild(this.label1);
         width = this.label1.textWidth;
         yy = yy + (this.label1.height + spacing);
         this.label2 = new Label();
         this.label2.size = fontSize;
         this.label2.text = pressAnyKeyText;
         this.label2.y = yy;
         addChild(this.label2);
         if(width < this.label2.textWidth)
         {
            width = this.label2.textWidth;
         }
         yy = yy + (this.label2.height + spacing);
         this.timelLabel = new Label();
         this.timelLabel.size = fontSize;
         this.timelLabel.autoSize = TextFieldAutoSize.LEFT;
         this.timelLabel.text = battleLeaveText + " 99:99";
         this.timelLabel.y = yy;
         addChild(this.timelLabel);
         if(width < this.timelLabel.textWidth)
         {
            width = this.timelLabel.textWidth;
         }
         width = width + 2 * leftRightMargin;
         icon.x = width - icon.width >> 1;
         this.label1.x = width - this.label1.width >> 1;
         this.label2.x = width - this.label2.width >> 1;
         height = yy + this.timelLabel.height + topBottomMargin - 5;
      }
      
      public function set seconds(value:int) : void
      {
         if(this._seconds == value)
         {
            return;
         }
         this._seconds = value;
         var minutes:int = this._seconds / 60;
         this._seconds = this._seconds - minutes * 60;
         var s:String = this._seconds < 10?"0" + this._seconds:this._seconds.toString();
         this.timelLabel.text = this.battleLeaveText + " " + minutes + ":" + s;
         this.timelLabel.x = width - this.timelLabel.width >> 1;
      }
   }
}
