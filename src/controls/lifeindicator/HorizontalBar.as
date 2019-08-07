package controls.lifeindicator
{
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.geom.Matrix;
   
   public class HorizontalBar extends Shape
   {
      
      private static var drawMatrix:Matrix = new Matrix();
       
      
      private var left:BitmapData;
      
      private var middle:BitmapData;
      
      private var right:BitmapData;
      
      private var _width:int = 0;
      
      public function HorizontalBar(left:BitmapData, middle:BitmapData, right:BitmapData)
      {
         super();
         this.left = left;
         this.middle = middle;
         this.right = right;
      }
      
      public function setWidth(value:int) : void
      {
         if(value == this._width)
         {
            return;
         }
         this._width = value;
         this.draw(this._width);
      }
      
      private function draw(w:int) : void
      {
         graphics.clear();
         if(w <= 0)
         {
            return;
         }
         var tw:int = this.left.width;
         var h:int = this.left.height;
         var w1:int = w >> 1;
         var w2:int = 2 * tw;
         if(w <= w2)
         {
            graphics.beginBitmapFill(this.left);
            w1 = w >> 1;
            graphics.drawRect(0,0,w1,h);
            drawMatrix.tx = w1;
            graphics.beginBitmapFill(this.right,drawMatrix);
            graphics.drawRect(w1,0,w - w1,h);
            graphics.endFill();
         }
         else
         {
            graphics.beginBitmapFill(this.left);
            graphics.drawRect(0,0,tw,h);
            drawMatrix.tx = tw;
            w1 = w - w2;
            graphics.beginBitmapFill(this.middle,drawMatrix);
            graphics.drawRect(tw,0,w1,h);
            drawMatrix.tx = tw + w1;
            graphics.beginBitmapFill(this.right,drawMatrix);
            graphics.drawRect(drawMatrix.tx,0,tw,h);
            graphics.endFill();
         }
      }
   }
}
