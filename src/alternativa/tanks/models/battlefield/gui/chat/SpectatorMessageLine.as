package alternativa.tanks.models.battlefield.gui.chat
{
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import controls.Label;
   
   public class SpectatorMessageLine extends MessageLine
   {
       
      
      private var message:String;
      
      private var _width:int;
      
      private var output:Label;
      
      private var spectatorFrom:Label;
      
      private var _namesWidth:int = 0;
      
      public function SpectatorMessageLine(_width:int, message:String)
      {
         this.output = new Label();
         this.spectatorFrom = new Label();
         super();
         this._width = _width;
         this.message = message;
         this.spectatorFrom.color = 16776960;
         this.spectatorFrom.text = "    [Наблюдатель]: ";
         this.spectatorFrom.thickness = 50;
         this.spectatorFrom.sharpness = 0;
         this.output.color = 16777215;
         this.output.multiline = true;
         this.output.wordWrap = true;
         this.output.mouseEnabled = false;
         var fx:int = 0;
         addChild(this.spectatorFrom);
         this.spectatorFrom.x = fx;
         fx = fx + this.spectatorFrom.textWidth;
         addChild(this.output);
         this._namesWidth = fx;
         if(this._namesWidth > _width / 2)
         {
            this.output.y = 15;
            this.output.x = 0;
            this.output.width = _width - 5;
         }
         else
         {
            this.output.x = this._namesWidth + 3;
            this.output.y = 0;
            this.output.width = _width - this._namesWidth - 8;
         }
         this.output.text = message;
      }
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         if(this._namesWidth > this._width / 2 && this.output.text.length * 8 > this._width - this._namesWidth)
         {
            this.output.y = 21;
            this.output.x = 0;
            this.output.width = this._width - 5;
            this.output.height = 20;
         }
         else
         {
            this.output.x = this._namesWidth;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 5;
            this.output.height = 20;
         }
      }
   }
}
