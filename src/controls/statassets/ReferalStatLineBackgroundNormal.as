package controls.statassets
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ReferalStatLineBackgroundNormal extends Sprite
   {
      
      public static var bg:Bitmap = new Bitmap();
       
      
      public function ReferalStatLineBackgroundNormal()
      {
         super();
         addChild(new Bitmap(bg.bitmapData));
      }
   }
}
