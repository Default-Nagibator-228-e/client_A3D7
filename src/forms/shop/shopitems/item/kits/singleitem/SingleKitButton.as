package forms.shop.shopitems.item.kits.singleitem
{
   import forms.shop.shopitems.item.base.ShopItemButton;
   import forms.shop.shopitems.item.kits.SpecialKitIcons;
   import forms.shop.shopitems.item.utils.FormatUtils;
   import alternativa.tanks.model.payment.shop.specialkit.SpecialKitPackage;
   import controls.base.LabelBase;
   import controls.labels.MouseDisabledLabel;
   import flash.display.Bitmap;
   import flash.text.TextFieldAutoSize;
   import forms.ColorConstants;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.client.panel.model.shop.specialkit.view.singleitem.SingleItemKitViewCC;
   
   public class SingleKitButton extends ShopItemButton
   {
      
      private static const SIDE_PADDING:int = 25;
      
      private static const TOP_PADDING:int = 10;
       
      
      private var crystalIcon:Bitmap;
      
      private var premiumIcon:Bitmap;
      
      private var suppliesIcon:Bitmap;
      
      private var goldIcon:Bitmap;
      
      private var itemIcon:Bitmap;
      
      private var brandIcon:Bitmap;
      
      private var lastXPosition:int;
      
      public function SingleKitButton(param1:IGameObject, param2:SingleItemKitViewCC)
      {
         this.crystalIcon = new Bitmap(SpecialKitIcons.crystal);
         this.premiumIcon = new Bitmap(SpecialKitIcons.premiumSmall);
         this.suppliesIcon = new Bitmap(SpecialKitIcons.supplies);
         this.goldIcon = new Bitmap(SpecialKitIcons.gold);
         if(param2.preview != null)
         {
            this.itemIcon = new Bitmap(param2.preview.data);
         }
         if(param2.brandIcon != null)
         {
            this.brandIcon = new Bitmap(param2.brandIcon.data);
         }
         super(param1,new SingleShopItemSkin(param2));
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
         this.addBrandIcon();
         this.lastXPosition = this.crystalIcon.x + this.crystalIcon.width + 40;
         this.addPremiumIconAndLabel();
         this.addGoldIconAndLabel();
         this.addItemIcon();
         this.addSuppliesIconAndLabel();
      }
      
      private function addBrandIcon() : void
      {
         if(this.brandIcon)
         {
            addChild(this.brandIcon);
            this.brandIcon.x = priceLabel.x + 206;
            this.brandIcon.y = priceLabel.y + 5;
         }
      }
      
      private function addCrystalsAndPriceLabels() : void
      {
         var _loc1_:LabelBase = new MouseDisabledLabel();
         _loc1_.text = FormatUtils.valueToString(this.specialKit.getCrystalsAmount(),0,false);
         _loc1_.color = ColorConstants.SHOP_CRYSTALS_TEXT_LABEL_COLOR;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.size = 75;
         _loc1_.x = SIDE_PADDING;
         _loc1_.y = TOP_PADDING;
         _loc1_.bold = true;
         addChild(_loc1_);
         this.crystalIcon.x = _loc1_.x + _loc1_.width + 5;
         this.crystalIcon.y = _loc1_.y + 20;
         addChild(this.crystalIcon);
         addPriceLabel();
         priceLabel.size = 35;
         priceLabel.x = _loc1_.x;
         priceLabel.y = _loc1_.y + _loc1_.height - 12;
      }
      
      private function addPremiumIconAndLabel() : void
      {
         var _loc1_:int = this.specialKit.getPremiumDurationInDays();
         if(_loc1_ == 0)
         {
            return;
         }
         this.premiumIcon.x = this.lastXPosition;
         this.lastXPosition = this.lastXPosition + (this.premiumIcon.width + 10);
         this.premiumIcon.y = TOP_PADDING + 20;
         addChild(this.premiumIcon);
         var _loc2_:LabelBase = new MouseDisabledLabel();
         _loc2_.text = "+" + timeUnitService.getLocalizedDaysString(_loc1_);
         _loc2_.x = this.premiumIcon.x + 2;
         _loc2_.y = this.premiumIcon.y + this.premiumIcon.height + 5;
         _loc2_.color = ColorConstants.WHITE;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.size = 26;
         _loc2_.bold = true;
         addChild(_loc2_);
      }
      
      private function addGoldIconAndLabel() : void
      {
         var _loc1_:int = this.specialKit.getGoldAmount();
         if(_loc1_ == 0)
         {
            return;
         }
         this.goldIcon.x = this.lastXPosition + 10;
         this.goldIcon.y = TOP_PADDING + 20;
         this.lastXPosition = this.lastXPosition + this.goldIcon.width;
         addChild(this.goldIcon);
         var _loc2_:LabelBase = new MouseDisabledLabel();
         _loc2_.text = "+" + _loc1_;
         _loc2_.x = this.goldIcon.x + 16;
         _loc2_.y = this.goldIcon.y + this.goldIcon.height - 5;
         _loc2_.color = ColorConstants.WHITE;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.size = 26;
         _loc2_.bold = true;
         addChild(_loc2_);
      }
      
      private function addItemIcon() : void
      {
         var _loc2_:LabelBase = null;
         if(this.itemIcon == null)
         {
            return;
         }
         this.itemIcon.x = this.lastXPosition;
         if(this.specialKit.getEverySupplyAmount() < 1)
         {
            this.itemIcon.x = this.itemIcon.x + 100;
         }
         this.itemIcon.y = TOP_PADDING + 10;
         this.lastXPosition = this.lastXPosition + this.itemIcon.width;
         addChild(this.itemIcon);
         var _loc1_:int = this.specialKit.getItemsCount();
         if(_loc1_ > 1)
         {
            _loc2_ = new MouseDisabledLabel();
            _loc2_.text = "+" + _loc1_.toString();
            _loc2_.x = this.itemIcon.x + 100;
            _loc2_.y = this.itemIcon.y;
            _loc2_.color = ColorConstants.WHITE;
            _loc2_.autoSize = TextFieldAutoSize.LEFT;
            _loc2_.size = 45;
            _loc2_.bold = true;
            addChild(_loc2_);
         }
      }
      
      private function addSuppliesIconAndLabel() : void
      {
         var _loc1_:LabelBase = null;
         if(this.specialKit.getEverySupplyAmount() > 0)
         {
            this.suppliesIcon.x = Math.min(this.lastXPosition,WIDTH * this.widthInCells - this.suppliesIcon.width);
            this.suppliesIcon.y = -5;
            addChild(this.suppliesIcon);
            _loc1_ = new MouseDisabledLabel();
            _loc1_.text = "+" + this.specialKit.getEverySupplyAmount().toString();
            _loc1_.x = this.suppliesIcon.x + 140;
            _loc1_.y = this.suppliesIcon.y + 83;
            _loc1_.color = ColorConstants.WHITE;
            _loc1_.autoSize = TextFieldAutoSize.LEFT;
            _loc1_.size = 45;
            _loc1_.bold = true;
            addChild(_loc1_);
         }
      }
      
      private function get specialKit() : SpecialKitPackage
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
