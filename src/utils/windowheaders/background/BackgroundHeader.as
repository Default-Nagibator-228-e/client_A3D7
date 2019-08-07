package utils.windowheaders.background
{
   import flash.display.BitmapData;
   
   public class BackgroundHeader
   {
      [Embed(source="1.png")]
      private static const shortBackgroundHeaderClass:Class;
      
      public static const shortBackgroundHeader:BitmapData = new shortBackgroundHeaderClass().bitmapData;
      [Embed(source="2.png")]
      private static const longBackgroundHeaderClass:Class;
      
      public static const longBackgroundHeader:BitmapData = new longBackgroundHeaderClass().bitmapData;
      [Embed(source="3.png")]
      private static const verticalBackgroundHeaderClass:Class;
      
      public static const verticalBackgroundHeader:BitmapData = new verticalBackgroundHeaderClass().bitmapData;
       
      
      public function BackgroundHeader()
      {
         super();
      }
   }
}
