package forms.shop.payment.item
{
   import forms.shop.payment.event.PayModeChosen;
   import forms.shop.shopitems.item.base.ShopButton;
   import alternativa.tanks.model.payment.modes.PayMode;
   import alternativa.tanks.model.payment.shop.discount.ShopDiscount;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import platform.client.fp10.core.type.IGameObject;
   
   public class PayModeButton extends ShopButton
   {
      
      public static const WIDTH:int = 157;
      
      public static const HEIGHT:int = 52;
       
      
      private var payMode:IGameObject;
      
      private var isSpecialOffer:Boolean = false;
      
      public function PayModeButton(param1:IGameObject, param2:Boolean)
      {
         this.payMode = param1;
         this.isSpecialOffer = param2;
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         super(PaymentItemSkin.SKIN);
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new PayModeChosen(this.payMode));
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:Bitmap = new Bitmap(PayMode(this.payMode.adapt(PayMode)).getImage().data);
         addChild(_loc1_);
         _loc1_.x = WIDTH - _loc1_.width >> 1;
         _loc1_.y = HEIGHT - _loc1_.height >> 1;
         if(this.hasDiscount())
         {
            salesIcon.x = _loc1_.x + _loc1_.width - salesIcon.width + 1;
            salesIcon.y = _loc1_.y - 1;
            addChild(salesIcon);
         }
      }
      
      public function hasDiscount() : Boolean
      {
         return ShopDiscount(this.payMode.adapt(ShopDiscount)).isEnabled() && !this.isSpecialOffer;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.payMode = null;
         removeEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      override public function get width() : Number
      {
         return WIDTH;
      }
      
      override public function get height() : Number
      {
         return HEIGHT;
      }
   }
}
