package forms.shop.payment
{
   import alternativa.osgi.service.locale.ILocaleService;
   import forms.shop.components.itemcategoriesview.ItemCategoriesView;
   import forms.shop.components.itemscategory.ItemsCategoryView;
   import forms.shop.components.paymentview.PaymentView;
   import forms.shop.paymentform.item.PaymentFormItemBase;
   import forms.shop.shopitems.item.base.ShopItemButton;
   import alternativa.tanks.model.payment.modes.PayMode;
   import alternativa.tanks.model.payment.shop.ShopItemView;
   import alternativa.types.Long;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   
   public class PaymentFormView extends PaymentView
   {
      
      [Inject]
      public static var localeService:ILocaleService;
      
      private static const CATEGORY_ID:Long = new Long(0,0);
       
      
      private var view:ItemCategoriesView;
      
      private var selectedItem:IGameObject;
      
      private var chosenPayMode:IGameObject;
      
      private var _width:int;
      
      private var _height:int;
      
      public function PaymentFormView(param1:IGameObject, param2:IGameObject)
      {
         super();
         this.selectedItem = param1;
         this.chosenPayMode = param2;
         this.view = new ItemCategoriesView();
         addChild(this.view);
         this.addSelectedItemView();
         if(param2 != null)
         {
            this.addPaymentCategory();
         }
      }
      
      private function addSelectedItemView() : void
      {
         var _loc1_:ItemsCategoryView = new ItemsCategoryView(localeService.getText(TanksLocale.TEXT_SHOP_WINDOW_YOUR_CHOICE),"",this.selectedItem.id);
         var _loc2_:ShopItemButton = ShopItemButton(ShopItemView(this.selectedItem.adapt(ShopItemView)).getButtonView());
         _loc2_.activateDisabledFilter();
         _loc2_.mouseEnabled = false;
         if(this.chosenPayMode != null)
         {
            _loc2_.applyPayModeDiscountAndUpdatePriceLabel(this.chosenPayMode);
         }
         _loc1_.addItem(_loc2_);
         this.view.addCategory(_loc1_);
      }
      
      private function addPaymentCategory() : void
      {
         var _loc1_:PayMode = PayMode(this.chosenPayMode.adapt(PayMode));
         var _loc2_:ItemsCategoryView = new ItemsCategoryView(_loc1_.getName(),_loc1_.getDescription(),CATEGORY_ID);
         this.view.addCategory(_loc2_);
      }
      
      public function addPaymentForm(param1:PaymentFormItemBase) : void
      {
         this.view.addItem(CATEGORY_ID,param1);
      }
      
      override public function render(param1:int, param2:int) : void
      {
         this._width = param1;
         this._height = param2;
         this.view.render(param1,param2);
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.view.destroy();
         this.selectedItem = null;
         this.chosenPayMode = null;
         this.view = null;
      }
   }
}
