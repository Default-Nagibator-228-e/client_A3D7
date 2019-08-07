package forms.shop.payment
{
   import alternativa.osgi.service.locale.ILocaleService;
   import forms.shop.components.itemcategoriesview.ItemCategoriesView;
   import forms.shop.components.itemscategory.ItemsCategoryView;
   import forms.shop.components.paymentview.PaymentView;
   import forms.shop.payment.item.PayModeButton;
   import forms.shop.shopitems.item.base.ShopItemButton;
   import forms.shop.shopitems.item.details.ShopItemAdditionalDescriptionLabel;
   import alternativa.tanks.model.payment.shop.ShopItemDetailsView;
   import alternativa.tanks.model.payment.shop.ShopItemView;
   import alternativa.tanks.model.payment.shop.description.ShopItemAdditionalDescription;
   import alternativa.tanks.model.payment.shop.specialkit.SpecialKitPackage;
   import alternativa.types.Long;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   
   public class PayModeChooseView extends PaymentView
   {
      
      [Inject]
      public static var localeService:ILocaleService;
      
      private static const COLUMN_COUNT:int = 5;
      
      private static const COLUMN_SPACING:int = 2;
      
      private static const PAYMENT_CATEGORY_ID:Long = new Long(0,0);
      
      private static const PAYMENT_CATEGORY_WITH_DISCOUNT_ID:Long = new Long(0,1);
       
      
      private var view:ItemCategoriesView;
      
      private var selectedItem:IGameObject;
      
      private var _width:int;
      
      private var _height:int;
      
      public function PayModeChooseView(param1:IGameObject)
      {
         super();
         this.selectedItem = param1;
         this.view = new ItemCategoriesView();
         addChild(this.view);
         this.addSelectedItemView();
      }
      
      private function addSelectedItemView() : void
      {
         var _loc1_:ItemsCategoryView = null;
         var _loc4_:ShopItemDetailsView = null;
         _loc1_ = new ItemsCategoryView(localeService.getText(TanksLocale.TEXT_SHOP_WINDOW_YOUR_CHOICE),"",this.selectedItem.id);
         _loc1_.items.horizontalSpacing = 50;
         var _loc2_:ShopItemButton = ShopItemButton(ShopItemView(this.selectedItem.adapt(ShopItemView)).getButtonView());
         _loc2_.activateDisabledFilter();
         _loc2_.mouseEnabled = false;
         _loc1_.addItem(_loc2_);
         if(this.selectedItem.hasModel(ShopItemDetailsView))
         {
            _loc4_ = ShopItemDetailsView(this.selectedItem.adapt(ShopItemDetailsView));
            if(_loc4_.isDetailedViewRequired())
            {
               _loc1_.addItem(_loc4_.getDetailsView());
            }
         }
         var _loc3_:String = ShopItemAdditionalDescription(this.selectedItem.adapt(ShopItemAdditionalDescription)).getAdditionalDescription();
         if(_loc3_)
         {
            _loc1_.addItem(new ShopItemAdditionalDescriptionLabel(_loc3_));
         }
         this.view.addCategory(_loc1_);
      }
      
      public function addPaymentCategoriesWithDiscountView() : void
      {
         this.view.addCategory(this.createPaymentCategoriesView(localeService.getText(TanksLocale.TEXT_SHOP_WINDOW_PAYMENT_CATEGORY_WITH_DISCOUNT_HEADER),localeService.getText(TanksLocale.TEXT_SHOP_WINDOW_PAYMENT_CATEGORY_WITH_DISCOUNT_DESCRIPTION),PAYMENT_CATEGORY_WITH_DISCOUNT_ID));
      }
      
      public function addPaymentCategoriesView() : void
      {
         this.view.addCategory(this.createPaymentCategoriesView(localeService.getText(TanksLocale.TEXT_SHOP_WINDOW_PAYMENT_CATEGORY_HEADER),localeService.getText(TanksLocale.TEXT_SHOP_WINDOW_PAYMENT_CATEGORY_DESCRIPTION),PAYMENT_CATEGORY_ID));
      }
      
      public function addPaymentCategoriesViewForOdnoklassniki(param1:Boolean) : void
      {
         this.view.addCategory(this.createPaymentCategoriesView(localeService.getText(TanksLocale.TEXT_SHOP_PAYMENT_CATEGORY_HEADER_FOR_ODNOKLASSNIKY),localeService.getText(TanksLocale.TEXT_SHOP_PAYMENT_CATEGORY_DESCRIPTION_FOR_ODNOKLASSNIKY),!!param1?PAYMENT_CATEGORY_WITH_DISCOUNT_ID:PAYMENT_CATEGORY_ID));
      }
      
      private function createPaymentCategoriesView(param1:String, param2:String, param3:Long) : ItemsCategoryView
      {
         var _loc4_:ItemsCategoryView = new ItemsCategoryView(param1,param2,param3);
         _loc4_.items.columnCount = COLUMN_COUNT;
         _loc4_.items.spacing = COLUMN_SPACING;
         return _loc4_;
      }
      
      public function addPayMode(param1:IGameObject) : void
      {
         var _loc2_:Boolean = this.selectedItem.hasModel(SpecialKitPackage);
         var _loc3_:PayModeButton = new PayModeButton(param1,_loc2_);
         this.view.addItem(!!_loc3_.hasDiscount()?PAYMENT_CATEGORY_WITH_DISCOUNT_ID:PAYMENT_CATEGORY_ID,_loc3_);
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
         this.view = null;
      }
   }
}
