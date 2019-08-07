package alternativa.tanks.gui
{
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class ProgressBar extends Sprite
   {
       
      
      private var bar:Shape;
      
      private var fill:Shape;
      
      private var fillMask:Shape;
      
      private const barColor:uint = 0;
      
      private const fillColor:uint = 3394560;
      
      private var _width:int;
      
      private var _height:int = 5;
      
      private var _progress:Number = 0;
      
      public function ProgressBar()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         tabEnabled = false;
         tabChildren = false;
         this.bar = new Shape();
         this.fill = new Shape();
         this.fillMask = new Shape();
         addChild(this.bar);
         addChild(this.fill);
         addChild(this.fillMask);
         this.fill.mask = this.fillMask;
      }
      
      private function repaintFill() : void
      {
         this.fill.graphics.clear();
         this.fill.graphics.beginFill(this.fillColor,1);
         this.fill.graphics.drawRect(0,0,Math.round(this._progress * this._width),this._height);
      }
      
      public function resize(width:int) : void
      {
         this._width = width;
         this.bar.graphics.clear();
         this.bar.graphics.beginFill(this.barColor,1);
         this.bar.graphics.drawRoundRect(0,0,this._width,this._height,this._height,this._height);
         this.fillMask.graphics.clear();
         this.fillMask.graphics.beginFill(0,1);
         this.fillMask.graphics.drawRoundRect(0,0,this._width,this._height,this._height,this._height);
         if(this._progress > 0)
         {
            this.setProgress(this._progress);
         }
      }
      
      public function setProgress(n:Number) : void
      {
         this._progress = n;
         if(this._width > 0)
         {
            this.repaintFill();
         }
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
   }
}
