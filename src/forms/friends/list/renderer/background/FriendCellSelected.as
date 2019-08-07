package forms.friends.list.renderer.background
{
   import controls.cellrenderer.ButtonState;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   
   public class FriendCellSelected extends ButtonState
   {
      [Embed(source="f/1.png")]
      private static var leftIconClass:Class;
      
      private static var leftIconBitmapData:BitmapData = Bitmap(new leftIconClass()).bitmapData;
      [Embed(source="f/2.png")]
      private static var centerIconClass:Class;
      
      private static var centerIconBitmapData:BitmapData = Bitmap(new centerIconClass()).bitmapData;
      [Embed(source="f/3.png")]
      private static var rightIconClass:Class;
      
      private static var rightIconBitmapData:BitmapData = Bitmap(new rightIconClass()).bitmapData;
       
      
      public function FriendCellSelected()
      {
         super();
         bmpLeft = leftIconBitmapData;
         bmpCenter = centerIconBitmapData;
         bmpRight = rightIconBitmapData;
      }
      
      override public function draw() : void
      {
         var _loc1_:Graphics = null;
         _loc1_ = l.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(bmpLeft);
         _loc1_.drawRect(0,0,5,20);
         _loc1_.endFill();
         l.x = 0;
         l.y = 0;
         _loc1_ = c.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(bmpCenter);
         _loc1_.drawRect(0,0,_width - 10,20);
         _loc1_.endFill();
         c.x = 5;
         c.y = 0;
         _loc1_ = r.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(bmpRight);
         _loc1_.drawRect(0,0,5,20);
         _loc1_.endFill();
         r.x = _width - 5;
         r.y = 0;
      }
   }
}
