package forms.shop.shopitems.item.kits.paypal
{
   import forms.shop.shopitems.item.base.ButtonItemSkin;
   
   public class PayPallKitShopItemSkin extends ButtonItemSkin
   {
      
      private static const normalStateClass:Class = PayPallKitShopItemSkin_normalStateClass;
      
      private static const overStateClass:Class = PayPallKitShopItemSkin_overStateClass;
       
      
      public function PayPallKitShopItemSkin()
      {
         super();
         normalState = new normalStateClass().bitmapData;
         overState = new overStateClass().bitmapData;
      }
   }
}
