package controls.cellrenderer
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class CellUnavailable extends CellRendererDefault
   {
      [Embed(source="u/1.png")]
      private static const normalLeft:Class;
      
      private static const normalLeftData:BitmapData = Bitmap(new normalLeft()).bitmapData;
      [Embed(source="u/2.png")]
      private static const normalCenter:Class;
      
      private static const normalCenterData:BitmapData = Bitmap(new normalCenter()).bitmapData;
      [Embed(source="u/3.png")]
      private static const normalRight:Class;
      
      private static const normalRightData:BitmapData = Bitmap(new normalRight()).bitmapData;
       
      
      public function CellUnavailable()
      {
         super();
         bmpLeft = normalLeftData;
         bmpCenter = normalCenterData;
         bmpRight = normalRightData;
      }
   }
}
