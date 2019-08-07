package forms.shop.shopitems.item.base
{
   import alternativa.osgi.service.locale.ILocaleService;
   import forms.shop.shopitems.event.ShopItemChosen;
   import forms.shop.shopitems.item.CountableItemButton;
   import forms.shop.shopitems.item.utils.FormatUtils;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.CapsStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import forms.ColorConstants;
   
   public class ShopItemButton extends ShopButton
   {
      [Embed(source="1.png")]
      private static const bonusIconClass:Class;
      
      public static var localeService:ILocaleService;
      
      protected static const WIDTH:int = 279;
      
      protected static const HEIGHT:int = 143;
      
      protected static const COMMON_LEFT_MARGIN:int = 30;
       
      
      protected var bonusIcon:Bitmap;
      
      protected var preview:Bitmap;
      
      protected var priceLabel:LabelBase;
      
      protected var oldPriceSprite:Sprite;
      
      protected var oldPriceLabel:LabelBase;
      
      protected var strikeoutLineThickness:Number;
      
      protected var strikeoutLineColor:uint;
      
      protected var oldPriceLabelSize:uint;
      
      private var discountEnabled:Boolean;
      
      private var priceWithDiscount:Number;
      
      private var buttonSkin:ButtonItemSkin;
      
      public function ShopItemButton(param2:ButtonItemSkin)
      {
         this.bonusIcon = new Bitmap(new bonusIconClass().bitmapData);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.buttonSkin = param2;
         super(this.buttonSkin);
      }
      
      override protected function init() : void
      {
         super.init();
		 /*
         var _loc1_:ImageResource = this.shopItem.getPreview();
         if(_loc1_ != null)
         {
            if(_loc1_.isLazy && !_loc1_.isLoaded)
            {
               _loc1_.loadLazyResource(new ImageResourceLoadingWrapper(this));
            }
            else
            {
               this.preview = new Bitmap(_loc1_.data);
            }
         }
		 */
         this.discountEnabled = this.isShopItemDiscountEnabled();
         this.priceWithDiscount = 0;//this.shopItem.getPriceWithDiscount();
         this.initOldPriceParams();
         this.initOldPriceLabel();
         this.initLabels();
         this.initPreview();
         this.align();
         this.addDiscountLabelIfHasDiscount();
      }
      
      protected function initLabels() : void
      {
      }
      
      protected function initOldPriceParams() : void
      {
         this.strikeoutLineThickness = 1;
         this.strikeoutLineColor = ColorConstants.SHOP_MONEY_TEXT_LABEL_COLOR;
         this.oldPriceLabelSize = 16;
      }
      
      private function initOldPriceLabel() : void
      {
         this.oldPriceSprite = new Sprite();
         this.oldPriceLabel = new LabelBase();
         this.oldPriceLabel.text = this.getOldPriceLabelText();
         this.oldPriceLabel.color = this.strikeoutLineColor;
         this.oldPriceLabel.autoSize = TextFieldAutoSize.LEFT;
         this.oldPriceLabel.size = this.oldPriceLabelSize;
         this.oldPriceLabel.bold = true;
         this.oldPriceLabel.mouseEnabled = false;
         this.oldPriceSprite.addChild(this.oldPriceLabel);
         var _loc1_:int = 2;
         var _loc2_:int = _loc1_ + this.oldPriceLabel.textWidth;
         var _loc3_:int = int(this.oldPriceLabel.height / 2);
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.lineStyle(this.strikeoutLineThickness,this.strikeoutLineColor,1,true,LineScaleMode.NONE,CapsStyle.NONE);
         _loc4_.graphics.moveTo(_loc1_,_loc3_);
         _loc4_.graphics.lineTo(_loc2_,_loc3_);
         this.oldPriceSprite.addChild(_loc4_);
      }
      
      private function getPriceLabelSize() : int
      {
         //switch(localeService.language)
         //{
            //case "fa":
               //return 16;
            //default:
               return 22;
         //}
      }
      
      protected function addPriceLabel(jjh:Number) : void
      {
         this.priceLabel = new LabelBase();
         this.priceLabel.text = this.getFormattedPriceText(jjh) + " " + "руб";
         this.priceLabel.color = ColorConstants.SHOP_MONEY_TEXT_LABEL_COLOR;
         this.priceLabel.size = this.getPriceLabelSize();
         this.priceLabel.autoSize = TextFieldAutoSize.LEFT;
         this.priceLabel.bold = true;
         this.priceLabel.mouseEnabled = false;
         addChild(this.priceLabel);
         this.fixChineseCurrencyLabelRendering(this.priceLabel);
      }
      
      public function setPreviewResource() : void
      {
         //this.preview = new Bitmap(param1.data);
         //this.updateLazyLoadedPreview();
      }
      
      protected function updateLazyLoadedPreview() : void
      {
         this.setPreview();
         this.align();
      }
      
      protected function initPreview() : void
      {
         if(this.preview != null)
         {
            this.setPreview();
         }
      }
      
      protected function setPreview() : void
      {
         addChildAt(this.preview,2);
      }
      
      //protected function get shopItem() : ShopItem
      //{
         //return ShopItem(this.item.adapt(ShopItem));
      //}
      
      protected function fixChineseCurrencyLabelRendering(param1:LabelBase) : void
      {
         //if(this.shopItem.getCurrencyName() == "元")
         //{
            //param1.embedFonts = fontService.isEmbeddedFontsInLang("cn");
            //param1.setTextFormat(fontService.getFontsFormatInLang("cn"));
         //}
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ShopItemChosen());
      }
      /*
      public function applyPayModeDiscountAndUpdatePriceLabel(param1:IGameObject) : void
      {
         if(this.item.hasModel(SpecialKitPackage))
         {
            this.priceLabel.text = this.getPriceLabelText();
            return;
         }
         var _loc2_:ShopDiscount = ShopDiscount(param1.adapt(ShopDiscount));
         this.priceWithDiscount = _loc2_.applyDiscount(this.priceWithDiscount);
         this.discountEnabled = this.discountEnabled || _loc2_.isEnabled();
         if(this.isShopItemDiscountEnabled())
         {
            this.priceLabel.text = this.getPriceLabelText();
         }
         else
         {
            this.addDiscountLabelIfHasDiscount();
         }
      }
      */
      private function addDiscountLabelIfHasDiscount() : void
      {
         var _loc1_:Bitmap = null;
         if(this.hasDiscount())
         {
            this.priceLabel.text = this.getPriceLabelText();
            addChild(this.oldPriceSprite);
            this.align();
            _loc1_ = salesIcon;
         }
         if(false)//(paymentWindowService.hasBonusForItem(this.item))
         {
            if(this is CountableItemButton)
            {
               if(CountableItemButton(this).getCount() > 1)
               {
                  _loc1_ = this.bonusIcon;
               }
            }
            else
            {
               _loc1_ = this.bonusIcon;
            }
         }
         if(_loc1_ != null)
         {
            this.addCornerIcon(_loc1_);
         }
      }
      
      private function addCornerIcon(param1:Bitmap) : void
      {
         param1.x = x + this.buttonSkin.normalState.width - param1.width - 8;
         param1.y = y + 7;
         addChild(param1);
      }
      
      protected function getPriceWithDiscount() : Number
      {
         return this.priceWithDiscount;
      }
      
      protected function hasDiscount() : Boolean
      {
         return this.discountEnabled;
      }
      
      private function isShopItemDiscountEnabled() : Boolean
      {
         return false;//ShopDiscount(this.item.adapt(ShopDiscount)).isEnabled();
      }
      
      protected function getPriceLabelText() : String
      {
         return this.getFormattedPriceText(this.getPriceWithDiscount()) + " " + "руб";//this.shopItem.getCurrencyName();
      }
      
      protected function getOldPriceLabelText() : String
      {
         return this.getFormattedPriceText(0 + "");//this.shopItem.getPrice()) + " " + this.shopItem.getCurrencyName();
      }
      
      protected function getFormattedPriceText(param1:Number) : String
      {
         return FormatUtils.valueToString(param1, 0, false);//this.shopItem.getCurrencyRoundingPrecision(),false);
      }
      
      protected function align() : void
      {
      }
      
      override public function get width() : Number
      {
         return WIDTH;
      }
      
      override public function get height() : Number
      {
         return HEIGHT;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         //this.item = null;
         removeEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      public function activateDisabledFilter() : void
      {
         alpha = 0.9;
      }
   }
}
