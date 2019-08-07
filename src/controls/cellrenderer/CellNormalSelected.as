package controls.cellrenderer
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   
   public class CellNormalSelected extends CellRendererDefault
   {
      [Embed(source="n/1.png")]
      private static const normalLeft:Class;
      
      private static const normalLeftData:BitmapData = Bitmap(new normalLeft()).bitmapData;
      [Embed(source="n/2.png")]
      private static const normalCenter:Class;
      
      private static const normalCenterData:BitmapData = Bitmap(new normalCenter()).bitmapData;
      [Embed(source="n/3.png")]
      private static const normalRight:Class;
      
      private static const normalRightData:BitmapData = Bitmap(new normalRight()).bitmapData;
       
      
      public function CellNormalSelected()
      {
         super();
         bmpLeft = normalLeftData;
         bmpCenter = normalCenterData;
         bmpRight = normalRightData;
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
         l.y = 1;
         _loc1_ = c.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(bmpCenter);
         _loc1_.drawRect(0,0,_width - 10,20);
         _loc1_.endFill();
         c.x = 5;
         c.y = 1;
         _loc1_ = r.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(bmpRight);
         _loc1_.drawRect(0,0,5,20);
         _loc1_.endFill();
         r.x = _width - 5;
         r.y = 1;
      }
   }
}
