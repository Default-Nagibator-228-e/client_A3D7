package forms.shop.shopitems.item.crystalonlypaymode
{
   import forms.shop.shopitems.item.OtherShopItemButton;
   import alternativa.tanks.model.payment.modes.PayMode;
   import platform.client.fp10.core.type.IGameObject;
   
   public class CrystalOnlyPayModeButton extends OtherShopItemButton
   {
       
      
      public function CrystalOnlyPayModeButton(param1:IGameObject)
      {
         super(param1,PayMode(param1.adapt(PayMode)).getName(),PayMode(param1.adapt(PayMode)).getImage());
      }
   }
}
