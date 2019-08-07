package controls.cellrenderer
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class ButtonState extends Sprite
   {
       
      
      public const l:Shape = new Shape();
      
      public const c:Shape = new Shape();
      
      public const r:Shape = new Shape();
      
      public var bmpLeft:BitmapData;
      
      public var bmpCenter:BitmapData;
      
      public var bmpRight:BitmapData;
      
      public var _width:int;
      
      public function ButtonState()
      {
         this.bmpLeft = new BitmapData(1,1);
         this.bmpCenter = new BitmapData(1,1);
         this.bmpRight = new BitmapData(1,1);
         super();
         addChild(this.l);
         addChild(this.c);
         addChild(this.r);
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = int(param1);
         this.draw();
      }
      
      public function draw() : void
      {
         var _loc1_:Graphics = null;
         _loc1_ = this.l.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this.bmpLeft);
         _loc1_.drawRect(0,0,7,30);
         _loc1_.endFill();
         this.l.x = 0;
         this.l.y = 0;
         _loc1_ = this.c.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this.bmpCenter);
         _loc1_.drawRect(0,0,this._width - 14,30);
         _loc1_.endFill();
         this.c.x = 7;
         this.c.y = 0;
         _loc1_ = this.r.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this.bmpRight);
         _loc1_.drawRect(0,0,7,30);
         _loc1_.endFill();
         this.r.x = this._width - 7;
         this.r.y = 0;
      }
   }
}
