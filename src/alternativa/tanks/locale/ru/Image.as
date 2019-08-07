package alternativa.tanks.locale.ru
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.ImageConst;
   import flash.display.BitmapData;
   
   public class Image
   {
      
      [Embed(source="i/1.png")]
      private static const bitmapReferalHeader:Class;
      
      public static const REFERAL_WINDOW_HEADER_IMAGE:BitmapData = new bitmapReferalHeader().bitmapData;
      [Embed(source="i/2.png")]
      private static const bitmapAbon:Class;
      
      private static const CONGRATULATION_WINDOW_TICKET_IMAGE:BitmapData = new bitmapAbon().bitmapData;
       
      
      public function Image()
      {
         super();
      }
      
      public static function init(localeService:ILocaleService) : void
      {
         localeService.registerImage(ImageConst.REFERAL_WINDOW_HEADER_IMAGE,Image.REFERAL_WINDOW_HEADER_IMAGE);
         localeService.registerImage(ImageConst.CONGRATULATION_WINDOW_TICKET_IMAGE,Image.CONGRATULATION_WINDOW_TICKET_IMAGE);
      }
   }
}
