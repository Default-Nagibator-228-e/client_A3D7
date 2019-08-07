package forms.shop.components.window
{
   import alternativa.model.description.IDescription;
   import alternativa.osgi.service.locale.ILocaleService;
   import forms.shop.events.ShopWindowBackButtonEvent;
   import forms.shop.events.ShopWindowJumpButtonEvent;
   import alternativa.tanks.model.payment.paymentstate.PaymentState;
   import alternativa.tanks.model.payment.paymentstate.PaymentWindowService;
   import alternativa.tanks.model.payment.shop.category.ShopCategory;
   import alternativa.tanks.model.payment.shop.discount.ShopDiscount;
   import alternativa.tanks.model.payment.shop.featuring.ShopItemFeaturing;
   import alternativa.tanks.model.payment.shop.itemcategory.ShopItemCategory;
   import alternativa.tanks.service.payment.IPaymentService;
   import alternativa.types.Long;
   import base.DiscreteSprite;
   import controls.base.DefaultButtonBase;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.client.commons.types.ShopCategoryEnum;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   
   public class ShopWindowNavigationBar extends DiscreteSprite
   {
      
      [Inject]
      public static var paymentService:IPaymentService;
      
      [Inject]
      public static var localeService:ILocaleService;
      
      [Inject]
      public static var paymentWindowService:PaymentWindowService;
      
      private static const HEIGHT:int = 37;
      
      private static const PADDING_VERTICAL:int = 4;
      
      private static const BUTTON_WIDTH:int = 120;
      
      private static const BUTTON_SPACING:int = 8;
      
      private static const BUTTONS_LEFT_PADDING:int = 11;
       
      
      private var jumpButtons:Vector.<ShopWindowJumpButton>;
      
      private var backButton:DefaultButtonBase;
      
      private var shopCategoryNameToId:Dictionary;
      
      private var categoriesWithDiscount:Dictionary;
      
      public function ShopWindowNavigationBar(param1:Vector.<IGameObject>, param2:Vector.<IGameObject>)
      {
         super();
         this.initCategoryDiscounts(param2);
         this.initNavigation(param1);
         this.initBackButton();
      }
      
      private function initCategoryDiscounts(param1:Vector.<IGameObject>) : void
      {
         var _loc2_:IGameObject = null;
         var _loc3_:IGameObject = null;
         this.categoriesWithDiscount = new Dictionary();
         for each(_loc2_ in param1)
         {
            _loc3_ = ShopItemCategory(_loc2_.adapt(ShopItemCategory)).getCategory();
            if(this.needMarkCategory(_loc3_,_loc2_))
            {
               this.categoriesWithDiscount[_loc3_.id.toString()] = true;
            }
         }
      }
      
      private function needMarkCategory(param1:IGameObject, param2:IGameObject) : Boolean
      {
         if(paymentWindowService.hasBonusForCategory(param1))
         {
            return true;
         }
         return ShopDiscount(param2.adapt(ShopDiscount)).isEnabled() && !ShopItemFeaturing(param2.adapt(ShopItemFeaturing)).isHiddenInOriginalCategory();
      }
      
      private function initNavigation(param1:Vector.<IGameObject>) : void
      {
         var _loc2_:IGameObject = null;
         var _loc3_:ShopCategory = null;
         var _loc4_:IDescription = null;
         var _loc5_:ShopWindowJumpButton = null;
         this.jumpButtons = new Vector.<ShopWindowJumpButton>();
         this.shopCategoryNameToId = new Dictionary();
         for each(_loc2_ in param1)
         {
            _loc3_ = ShopCategory(_loc2_.adapt(ShopCategory));
            if(_loc3_.isWithJumpButton())
            {
               _loc4_ = IDescription(_loc2_.adapt(IDescription));
               _loc5_ = this.addCategoryJumpButton(_loc2_.id,_loc4_.getName());
               if(this.hasDiscount(_loc2_.id))
               {
                  _loc5_.activateDiscountsIcon();
               }
            }
            this.shopCategoryNameToId[_loc3_.getType()] = _loc2_.id;
         }
      }
      
      private function addCategoryJumpButton(param1:Long, param2:String) : ShopWindowJumpButton
      {
         var _loc3_:ShopWindowJumpButton = new ShopWindowJumpButton(param1,param2);
         _loc3_.addEventListener(MouseEvent.CLICK,this.onJumpButtonPressed,false,0,true);
         _loc3_.width = BUTTON_WIDTH;
         addChild(_loc3_);
         this.jumpButtons.push(_loc3_);
         return _loc3_;
      }
      
      private function hasDiscount(param1:Long) : Boolean
      {
         return this.categoriesWithDiscount[param1.toString()];
      }
      
      private function onJumpButtonPressed(param1:MouseEvent) : void
      {
         this.navigateToCategoryById((param1.currentTarget as ShopWindowJumpButton).categoryId);
      }
      
      public function navigateToCategoryByType(param1:ShopCategoryEnum) : void
      {
         var _loc2_:Long = this.shopCategoryNameToId[param1];
         if(_loc2_)
         {
            this.navigateToCategoryById(_loc2_);
         }
      }
      
      public function navigateToCategoryById(param1:Long) : void
      {
         dispatchEvent(new ShopWindowJumpButtonEvent(ShopWindowJumpButtonEvent.CLICK,param1));
      }
      
      private function initBackButton() : void
      {
         this.backButton = new DefaultButtonBase();
         this.backButton.tabEnabled = false;
         this.backButton.label = localeService.getText(TanksLocale.TEXT_BACK_BUTTON);
         this.backButton.visible = false;
         this.backButton.addEventListener(MouseEvent.CLICK,this.onBackButtonPressed);
         addChild(this.backButton);
      }
      
      private function onBackButtonPressed(param1:MouseEvent) : void
      {
         dispatchEvent(new ShopWindowBackButtonEvent(ShopWindowBackButtonEvent.CLICK));
      }
      
      public function resize(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ShopWindowJumpButton = null;
         _loc2_ = BUTTONS_LEFT_PADDING;
         for each(_loc3_ in this.jumpButtons)
         {
            _loc3_.y = PADDING_VERTICAL;
            _loc3_.x = _loc2_;
            _loc2_ = _loc2_ + (_loc3_.width + (!!_loc3_.activeDiscounts?0:BUTTON_SPACING));
         }
         this.backButton.y = PADDING_VERTICAL;
         this.backButton.x = BUTTONS_LEFT_PADDING;
      }
      
      public function switchToState(param1:PaymentState) : void
      {
         this.setJumpButtonsVisible(!paymentWindowService.isStoppedOnPaymentForm() && param1 == PaymentState.ITEM_CHOOSE && !paymentWindowService.isSingleItemPayment());
         this.backButton.visible = !paymentWindowService.isStoppedOnPaymentForm() && param1 != PaymentState.ITEM_CHOOSE && (!paymentWindowService.isSingleItemPayment() || param1 != PaymentState.PAYMODE_CHOOSE);
      }
      
      private function setJumpButtonsVisible(param1:Boolean) : void
      {
         var _loc2_:ShopWindowJumpButton = null;
         for each(_loc2_ in this.jumpButtons)
         {
            _loc2_.visible = param1;
         }
      }
      
      override public function get height() : Number
      {
         return HEIGHT;
      }
      
      public function destroy() : void
      {
         var _loc1_:ShopWindowJumpButton = null;
         for each(_loc1_ in this.jumpButtons)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onJumpButtonPressed);
         }
         this.backButton.removeEventListener(MouseEvent.CLICK,this.onBackButtonPressed);
         this.jumpButtons = null;
      }
   }
}
