package forms.shop.components.window
{
   import forms.shop.indicators.ShopIndicators;
   import alternativa.types.Long;
   import controls.base.DefaultButtonBase;
   import flash.display.Bitmap;
   
   public class ShopWindowJumpButton extends DefaultButtonBase
   {
       
      
      private var _categoryId:Long;
      
      private var _activeDiscounts:Boolean;
      
      public function ShopWindowJumpButton(param1:Long, param2:String)
      {
         super();
         this._categoryId = param1;
         label = param2;
      }
      
      public function get categoryId() : Long
      {
         return this._categoryId;
      }
      
      public function get activeDiscounts() : Boolean
      {
         return this._activeDiscounts;
      }
      
      public function activateDiscountsIcon() : void
      {
         var _loc1_:Bitmap = new Bitmap(ShopIndicators.discounts);
         _loc1_.y = -5;
         _loc1_.x = width - int(_loc1_.width / 2) - 2;
         addChild(_loc1_);
         this._activeDiscounts = true;
      }
   }
}
