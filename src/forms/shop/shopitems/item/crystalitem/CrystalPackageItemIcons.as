package forms.shop.shopitems.item.crystalitem
{
   import flash.display.BitmapData;
   
   public class CrystalPackageItemIcons
   {
      [Embed(source="2.png")]
      private static const crystalBlueClass:Class;
      
      public static const crystalBlue:BitmapData = new crystalBlueClass().bitmapData;
      [Embed(source="1.png")]
      private static const crystalWhiteClass:Class;
      
      public static const crystalWhite:BitmapData = new crystalWhiteClass().bitmapData;
      [Embed(source="3.png")]
      private static const premiumClass:Class;
      
      public static const premium:BitmapData = new premiumClass().bitmapData;
       
      
      public function CrystalPackageItemIcons()
      {
         super();
      }
   }
}
