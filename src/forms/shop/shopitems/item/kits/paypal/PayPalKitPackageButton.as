package forms.shop.shopitems.item.kits.paypal
{
   import forms.shop.shopitems.item.base.ShopItemButton;
   import forms.shop.shopitems.item.kits.SpecialKitIcons;
   import forms.shop.shopitems.item.utils.FormatUtils;
   import alternativa.tanks.model.payment.shop.specialkit.SpecialKitPackage;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.text.TextFieldAutoSize;
   import forms.ColorConstants;
   import platform.client.fp10.core.type.IGameObject;
   
   public class PayPalKitPackageButton extends ShopItemButton
   {
      
      private static const SIDE_PADDING:int = 25;
      
      private static const TOP_PADDING:int = 10;
       
      
      private var crystalIcon:Bitmap;
      
      private var premiumIcon:Bitmap;
      
      private var payPalIcon:Bitmap;
      
      public function PayPalKitPackageButton(param1:IGameObject)
      {
         super(param1,new PayPallKitShopItemSkin());
      }
      
      override protected function initOldPriceParams() : void
      {
         super.initOldPriceParams();
         strikeoutLineThickness = 3;
         oldPriceLabelSize = 35;
      }
      
      override protected function initLabels() : void
      {
         this.addCrystalsAndPriceLabels();
         this.addPremiumIconAndLabel();
         this.addSuppliesIconAndLabel();
      }
      
      private function addCrystalsAndPriceLabels() : void
      {
         var _loc1_:LabelBase = null;
         _loc1_ = new LabelBase();
         _loc1_.text = FormatUtils.valueToString(this.newbieKitPackage.getCrystalsAmount(),0,false);
         _loc1_.color = ColorConstants.SHOP_CRYSTALS_TEXT_LABEL_COLOR;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.size = 75;
         _loc1_.x = SIDE_PADDING;
         _loc1_.y = TOP_PADDING;
         _loc1_.bold = true;
         _loc1_.mouseEnabled = false;
         addChild(_loc1_);
         this.crystalIcon = new Bitmap(SpecialKitIcons.crystal);
         this.crystalIcon.x = _loc1_.x + _loc1_.width + 5;
         this.crystalIcon.y = _loc1_.y + 20;
         addChild(this.crystalIcon);
         addPriceLabel();
         priceLabel.size = 35;
         priceLabel.x = _loc1_.x;
         priceLabel.y = _loc1_.y + _loc1_.height - 12;
         this.addPayPalIcon();
      }
      
      private function addPayPalIcon() : void
      {
         this.payPalIcon = new Bitmap(PayPalKitPackageItemIcons.payPalIcon);
         this.payPalIcon.x = priceLabel.x + 206;
         this.payPalIcon.y = priceLabel.y + 5;
         addChild(this.payPalIcon);
      }
      
      private function addPremiumIconAndLabel() : void
      {
         var _loc1_:LabelBase = null;
         this.premiumIcon = new Bitmap(SpecialKitIcons.premium);
         this.premiumIcon.x = this.crystalIcon.x + this.crystalIcon.height + 100;
         this.premiumIcon.y = TOP_PADDING + 5;
         addChild(this.premiumIcon);
         _loc1_ = new LabelBase();
         _loc1_.text = "+" + timeUnitService.getLocalizedDaysString(this.newbieKitPackage.getPremiumDurationInDays());
         _loc1_.x = this.premiumIcon.x + 12;
         _loc1_.y = this.premiumIcon.y + this.premiumIcon.height - 10;
         _loc1_.color = ColorConstants.WHITE;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.size = 35;
         _loc1_.bold = true;
         _loc1_.mouseEnabled = false;
         addChild(_loc1_);
      }
      
      private function addSuppliesIconAndLabel() : void
      {
         var _loc1_:Bitmap = new Bitmap(SpecialKitIcons.supplies);
         _loc1_.x = this.premiumIcon.x + this.premiumIcon.width + 30;
         _loc1_.y = -8;
         addChild(_loc1_);
         var _loc2_:LabelBase = new LabelBase();
         _loc2_.text = "+" + this.newbieKitPackage.getEverySupplyAmount().toString();
         _loc2_.x = _loc1_.x - 12;
         _loc2_.y = TOP_PADDING;
         _loc2_.color = ColorConstants.WHITE;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.size = 71;
         _loc2_.bold = true;
         _loc2_.mouseEnabled = false;
         addChild(_loc2_);
      }
      
      private function get newbieKitPackage() : SpecialKitPackage
      {
         return SpecialKitPackage(item.adapt(SpecialKitPackage));
      }
      
      override public function get widthInCells() : int
      {
         return 3;
      }
      
      override protected function initPreview() : void
      {
      }
      
      override protected function setPreview() : void
      {
      }
      
      override protected function align() : void
      {
         if(hasDiscount())
         {
            oldPriceSprite.x = SIDE_PADDING;
            priceLabel.x = oldPriceSprite.x + oldPriceSprite.width + 10;
            oldPriceSprite.y = priceLabel.y;
         }
      }
   }
}
