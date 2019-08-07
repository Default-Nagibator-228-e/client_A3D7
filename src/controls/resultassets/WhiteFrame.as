package controls.resultassets
{
   import assets.resultwindow.items_mini_CENTER;
   import assets.resultwindow.items_mini_LEFT;
   import assets.resultwindow.items_mini_RIGHT;
   import controls.ButtonState;
   import flash.display.Graphics;
   
   public class WhiteFrame extends ButtonState
   {
       
      
      public function WhiteFrame()
      {
         super();
         bmpLeft = new items_mini_LEFT(1,1);
         bmpCenter = new items_mini_CENTER(1,1);
         bmpRight = new items_mini_RIGHT(1,1);
      }
      
      override public function draw() : void
      {
         var g:Graphics = null;
         g = l.graphics;
         g.clear();
         g.beginBitmapFill(bmpLeft);
         g.drawRect(0,0,20,40);
         g.endFill();
         l.x = 0;
         l.y = 0;
         g = c.graphics;
         g.clear();
         g.beginBitmapFill(bmpCenter);
         g.drawRect(0,0,_width - 40,40);
         g.endFill();
         c.x = 20;
         c.y = 0;
         g = r.graphics;
         g.clear();
         g.beginBitmapFill(bmpRight);
         g.drawRect(0,0,20,40);
         g.endFill();
         r.x = _width - 20;
         r.y = 0;
      }
   }
}
