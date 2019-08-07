package alternativa.tanks.models.battlefield
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class ViewportBorder
   {
      [Embed(source="v/1.png")]
      private static var bmpClassCorner1:Class;
      
      private static var bmdCorner1:BitmapData = Bitmap(new bmpClassCorner1()).bitmapData;
      [Embed(source="v/2.png")]
      private static var bmpClassCorner2:Class;
      
      private static var bmdCorner2:BitmapData = Bitmap(new bmpClassCorner2()).bitmapData;
      [Embed(source="v/3.png")]
      private static var bmpClassCorner3:Class;
      
      private static var bmdCorner3:BitmapData = Bitmap(new bmpClassCorner3()).bitmapData;
      [Embed(source="v/4.png")]
      private static var bmpClassCorner4:Class;
      
      private static var bmdCorner4:BitmapData = Bitmap(new bmpClassCorner4()).bitmapData;
      [Embed(source="v/5.png")]
      private static var bmpClassBorderLeft:Class;
      
      private static var bmdBorderLeft:BitmapData = Bitmap(new bmpClassBorderLeft()).bitmapData;
      [Embed(source="v/6.png")]
      private static var bmpClassBorderRight:Class;
      
      private static var bmdBorderRight:BitmapData = Bitmap(new bmpClassBorderRight()).bitmapData;
      [Embed(source="v/7.png")]
      private static var bmpClassBorderTop:Class;
      
      private static var bmdBorderTop:BitmapData = Bitmap(new bmpClassBorderTop()).bitmapData;
      [Embed(source="v/8.png")]
      private static var bmpClassBorderBottom:Class;
      
      private static var bmdBorderBottom:BitmapData = Bitmap(new bmpClassBorderBottom()).bitmapData;
       
      
      public function ViewportBorder()
      {
         super();
      }
      
      public function draw(g:Graphics, w:int, h:int) : void
      {
         var padding:int = 4;
         this.fillBorderRect(g,bmdCorner1,padding - bmdCorner1.width,padding - bmdCorner1.height,bmdCorner1.width,bmdCorner1.height);
         this.fillBorderRect(g,bmdCorner2,w - padding,padding - bmdCorner2.height,bmdCorner2.width,bmdCorner2.height);
         this.fillBorderRect(g,bmdCorner3,padding - bmdCorner3.width,h - padding,bmdCorner3.width,bmdCorner3.height);
         this.fillBorderRect(g,bmdCorner4,w - padding,h - padding,bmdCorner4.width,bmdCorner4.height);
         this.fillBorderRect(g,bmdBorderTop,padding,padding - bmdBorderTop.height,w - 2 * padding,bmdBorderTop.height);
         this.fillBorderRect(g,bmdBorderBottom,padding,h - padding,w - 2 * padding,bmdBorderBottom.height);
         this.fillBorderRect(g,bmdBorderLeft,padding - bmdBorderLeft.width,padding,bmdBorderLeft.width,h - 2 * padding);
         this.fillBorderRect(g,bmdBorderRight,w - padding,padding,bmdBorderRight.width,h - 2 * padding);
      }
      
      private function fillBorderRect(g:Graphics, bitmap:BitmapData, x:int, y:int, w:int, h:int) : void
      {
         var m:Matrix = new Matrix();
         m.tx = x;
         m.ty = y;
         g.beginBitmapFill(bitmap,m);
         g.drawRect(x,y,w,h);
         g.endFill();
      }
   }
}
