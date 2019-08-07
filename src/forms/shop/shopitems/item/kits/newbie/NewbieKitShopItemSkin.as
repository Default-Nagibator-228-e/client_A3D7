package forms.shop.shopitems.item.kits.newbie
{
   import forms.shop.shopitems.item.base.ButtonItemSkin;
   
   public class NewbieKitShopItemSkin extends ButtonItemSkin
   {
      
      private static const normalStateClass:Class = NewbieKitShopItemSkin_normalStateClass;
      
      private static const overStateClass:Class = NewbieKitShopItemSkin_overStateClass;
       
      
      public function NewbieKitShopItemSkin()
      {
         super();
         normalState = new normalStateClass().bitmapData;
         overState = new overStateClass().bitmapData;
      }
   }
}
