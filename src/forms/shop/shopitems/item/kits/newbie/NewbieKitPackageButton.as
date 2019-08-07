package forms.shop.shopitems.item.kits.newbie
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
   
   public class NewbieKitPackageButton extends ShopItemButton
   {
      
      private static const SIDE_PADDING:int = 25;
      
      private static const TOP_PADDING:int = 10;
      
      private static const CENTER:int = 400;
       
      
      private var premiumIcon:Bitmap;
      
      private var goldIcon:Bitmap;
      
      public function NewbieKitPackageButton(param1:IGameObject)
      {
         super(param1,new NewbieKitShopItemSkin());
      }
      
      override protected function initOldPriceParams() : void
      {
         super.initOldPriceParams();
         strikeoutLineThickness = 3;
         oldPriceLabelSize = this.getPriceLabelSize();
      }
      
      override protected function initLabels() : void
      {
         this.addCrystalsAndPriceLabels();
         this.addPremiumAndGoldIconAndLabel();
         this.addSuppliesIconAndLabel();
      }
      
      private function getPriceLabelSize() : int
      {
         switch(localeService.language)
         {
            case "fa":
               return 25;
            default:
               return 35;
         }
      }
      
      private function getCrystalsLabelSize() : int
      {
         switch(localeService.language)
         {
            case "fa":
               return 55;
            default:
               return 75;
         }
      }
      
      private function addCrystalsAndPriceLabels() : void
      {
         var _loc1_:LabelBase = new LabelBase();
         _loc1_.text = FormatUtils.valueToString(this.newbieKitPackage.getCrystalsAmount(),0,false);
         _loc1_.color = ColorConstants.SHOP_CRYSTALS_TEXT_LABEL_COLOR;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.size = this.getCrystalsLabelSize();
         _loc1_.x = SIDE_PADDING;
         _loc1_.y = TOP_PADDING;
         _loc1_.bold = true;
         _loc1_.mouseEnabled = false;
         addChild(_loc1_);
         var _loc2_:Bitmap = new Bitmap(SpecialKitIcons.crystal);
         _loc2_.x = _loc1_.x + _loc1_.width + 5;
         _loc2_.y = _loc1_.y + 20;
         addChild(_loc2_);
         addPriceLabel();
         priceLabel.size = this.getPriceLabelSize();
         priceLabel.x = _loc1_.x;
         priceLabel.y = _loc1_.y + _loc1_.height - 12;
      }
      
      private function addPremiumAndGoldIconAndLabel() : void
      {
         var _loc2_:LabelBase = null;
         var _loc3_:LabelBase = null;
         this.premiumIcon = new Bitmap();
         this.premiumIcon.x = CENTER;
         addChild(this.premiumIcon);
         var _loc1_:int = this.newbieKitPackage.getPremiumDurationInDays();
         _loc2_ = new LabelBase();
         _loc2_.text = "+" + timeUnitService.getLocalizedDaysString(_loc1_);
         _loc2_.color = ColorConstants.WHITE;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.bold = true;
         _loc2_.mouseEnabled = false;
         addChild(_loc2_);
         if(this.packageHasGold())
         {
            this.premiumIcon.bitmapData = SpecialKitIcons.premiumSmall;
            this.premiumIcon.y = TOP_PADDING + 20;
            _loc2_.x = this.premiumIcon.x;
            _loc2_.y = this.premiumIcon.y + this.premiumIcon.height - 5;
            _loc2_.size = 26;
            this.goldIcon = new Bitmap(SpecialKitIcons.gold);
            this.goldIcon.x = this.premiumIcon.x + this.premiumIcon.width + 15;
            this.goldIcon.y = TOP_PADDING + 20;
            addChild(this.goldIcon);
            _loc3_ = new LabelBase();
            _loc3_.text = "+" + this.newbieKitPackage.getGoldAmount();
            _loc3_.x = this.goldIcon.x + 7;
            _loc3_.y = this.goldIcon.y + this.goldIcon.height - 15;
            _loc3_.color = ColorConstants.WHITE;
            _loc3_.autoSize = TextFieldAutoSize.LEFT;
            _loc3_.size = 26;
            _loc3_.bold = true;
            _loc3_.mouseEnabled = false;
            addChild(_loc3_);
         }
         else
         {
            this.premiumIcon.bitmapData = SpecialKitIcons.premium;
            this.premiumIcon.y = TOP_PADDING + 5;
            addChild(this.premiumIcon);
            _loc2_.x = this.premiumIcon.x + 12;
            _loc2_.y = this.premiumIcon.y + this.premiumIcon.height - 10;
            _loc2_.size = this.getPriceLabelSize();
         }
      }
      
      private function addSuppliesIconAndLabel() : void
      {
         var _loc1_:Bitmap = new Bitmap(SpecialKitIcons.supplies);
         _loc1_.y = -8;
         addChild(_loc1_);
         var _loc2_:LabelBase = new LabelBase();
         _loc2_.text = "+" + this.newbieKitPackage.getEverySupplyAmount().toString();
         _loc2_.y = TOP_PADDING;
         _loc2_.color = ColorConstants.WHITE;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.size = 71;
         _loc2_.bold = true;
         _loc2_.mouseEnabled = false;
         addChild(_loc2_);
         if(this.packageHasGold())
         {
            _loc1_.x = CENTER + 180;
            _loc2_.x = _loc1_.x + 20;
         }
         else
         {
            _loc1_.x = this.premiumIcon.x + this.premiumIcon.width + 30;
            _loc2_.x = _loc1_.x - 12;
         }
      }
      
      private function get newbieKitPackage() : SpecialKitPackage
      {
         return SpecialKitPackage(item.adapt(SpecialKitPackage));
      }
      
      private function packageHasGold() : Boolean
      {
         return this.newbieKitPackage.getGoldAmount() > 0;
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
