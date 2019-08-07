package utils
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextUtils
   {
       
      
      public function TextUtils()
      {
         super();
      }
      
      public static function getTextInCells(tf:TextField, cellWidth:int, cellHeight:int, gridColor:uint = 52224, gridAlpha:Number = 0.5, gridLinThickness:int = 1) : BitmapData
      {
         var charRect:Rectangle = null;
         var shiftX:int = 0;
         var shiftY:int = 0;
         var format:TextFormat = tf.getTextFormat();
         var oldLetterSpacing:Object = format.letterSpacing;
         format.letterSpacing = 4;
         tf.setTextFormat(format);
         var length:int = tf.text.length;
         var bd:BitmapData = new BitmapData(cellWidth * length,cellHeight,true,16777215);
         var grid:Shape = new Shape();
         grid.graphics.lineStyle(gridLinThickness,gridColor,gridAlpha);
         grid.graphics.drawRect(0,0,length * cellWidth - gridLinThickness,cellHeight - gridLinThickness);
         for(var i:int = 1; i < length; i++)
         {
            grid.graphics.moveTo(i * cellWidth,0);
            grid.graphics.lineTo(i * cellWidth,cellHeight);
         }
         bd.draw(grid);
         var m:Matrix = new Matrix();
         for(i = 0; i < length; i++)
         {
            charRect = tf.getCharBoundaries(i);
            charRect.width = charRect.width - 4;
            shiftX = Math.round((cellWidth - charRect.width) * 0.5);
            shiftY = Math.round((cellHeight - charRect.height) * 0.5);
            m.tx = -charRect.x + i * cellWidth + shiftX;
            m.ty = -charRect.y + shiftY;
            bd.draw(tf,m,null,BlendMode.NORMAL,new Rectangle(i * cellWidth + shiftX,charRect.y + shiftY,charRect.width + 1,charRect.height),true);
         }
         format.letterSpacing = oldLetterSpacing;
         tf.setTextFormat(format);
         return bd;
      }
   }
}
