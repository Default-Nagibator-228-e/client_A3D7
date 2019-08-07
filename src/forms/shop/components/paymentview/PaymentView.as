package forms.shop.components.paymentview
{
   import forms.shop.windows.ShopWindow;
   import flash.display.Sprite;
   
   public class PaymentView extends Sprite
   {
       
      
      public var window:ShopWindow;
      
      public function PaymentView()
      {
         super();
      }
      
      public function render(param1:int, param2:int) : void
      {
      }
      
      public function destroy() : void
      {
         this.window = null;
      }
      
      public function postRender() : void
      {
      }
   }
}
