package controls.statassets
{
   import assets.resultwindow.bres_BG_BLACKCORNER;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class BlackRoundRect extends StatLineBase
   {
       
      
      public function BlackRoundRect()
      {
         super();
         tl = new bres_BG_BLACKCORNER(1,1);
         px = new BitmapData(1,1,true,2566914048);
      }
      
      override protected function draw() : void
      {
         var matrix:Matrix = null;
         var g:Graphics = this.graphics;
         g.clear();
         g.beginBitmapFill(tl);
         g.drawRect(0,0,8,8);
         g.endFill();
         matrix = new Matrix();
         matrix.rotate(Math.PI * 0.5);
         matrix.translate(_width - 8,0);
         g.beginBitmapFill(tl,matrix);
         g.drawRect(_width - 8,0,8,8);
         g.endFill();
         matrix = new Matrix();
         matrix.rotate(Math.PI);
         matrix.translate(_width - 8,_height - 8);
         g.beginBitmapFill(tl,matrix);
         g.drawRect(_width - 8,_height - 8,8,8);
         g.endFill();
         matrix = new Matrix();
         matrix.rotate(Math.PI * 1.5);
         matrix.translate(0,_height - 8);
         g.beginBitmapFill(tl,matrix);
         g.drawRect(0,_height - 8,8,8);
         g.endFill();
         g.beginBitmapFill(px);
         g.drawRect(8,0,_width - 16,_height);
         g.drawRect(0,8,8,_height - 16);
         g.drawRect(_width - 8,8,8,_height - 16);
         g.endFill();
      }
   }
}
