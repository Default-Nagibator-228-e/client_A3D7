package forms.shop.shopitems.item.base
{
   public class GreyShopItemSkin extends ButtonItemSkin
   {
      [Embed(source="3.png")]
      private static const normalStateClass:Class;
      [Embed(source="4.png")]
      private static const overStateClass:Class;
       
      
      public function GreyShopItemSkin()
      {
         super();
         normalState = new normalStateClass().bitmapData;
         overState = new overStateClass().bitmapData;
      }
   }
}
