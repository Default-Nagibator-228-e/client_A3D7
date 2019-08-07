package controls.statassets
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ReferalStatLineBackgroundSelected extends Sprite
   {
      
      public static var bg:Bitmap = new Bitmap();
       
      
      public function ReferalStatLineBackgroundSelected()
      {
         super();
         addChild(new Bitmap(bg.bitmapData));
      }
   }
}
