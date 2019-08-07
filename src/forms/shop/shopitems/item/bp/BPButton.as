package forms.shop.shopitems.item.bp
{
   import forms.shop.shopitems.item.base.ShopItemButton;
   import forms.shop.shopitems.item.base.ShopItemSkins;
   import forms.shop.shopitems.item.utils.FormatUtils;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextFieldAutoSize;
   import forms.ColorConstants;
   import flash.net.navigateToURL;
   
   public class BPButton extends ShopItemButton
   {
      
      private static const LEFT_PADDING:int = 18;
      
      private static const RIGHT_PADDING:int = 18;
      
      private static const TOP_PADDING:int = 17;
      
      private static const BOTTOM_PADDING:int = 17;
      
      private static const CRYSTAL_ICON_X:int = 153;
      
      private static const CRYSTAL_ICON_Y:int = -2;
       
      
      private var crystalLabel:LabelBase;
      
      private var crystalBlueIcon:Bitmap;
      
      private var premiumLabel:LabelBase;
      
      private var premiumIcon:Bitmap;
      
      private var presentLabel:LabelBase;
      
      private var presentSecondLabel:LabelBase;
      
      private var presentIcon:Bitmap;
	  
	  private var cr:Number = 0;
	  
	  private var pr:Number = 0;
	  
	  private var tr:String = "";
      
      public function BPButton(param1:Number,param2:Number,param3:String)
      {
		 cr = param1;
		 pr = param2;
		 tr = param3;
         super(ShopItemSkins.GREEN);
		 addEventListener(MouseEvent.CLICK,uy);
      }
      
      override protected function initLabels() : void
      {
         if(this.hasPresent)
         {
            this.initPackageWithPresent();
         }
         else
         {
            this.initPackageWithoutPresent();
         }
         this.initCrystalsAndPriceInnerLabels();
         //if(this.hasPremium)
         //{
            //this.initPackageWithPremium();
         //}
      }
	  
	  private function uy(e:Event) : void
      {
         navigateToURL(new URLRequest(tr), '_self')
      }
      
      private function getCrystalsLabelSize() : int
      {
         //switch(localeService.language)
         //{
            //case "fa":
               //return 25;
            //default:
               return 30;
         //}
      }
      
      private function getPresentCrystalsLabelSize() : int
      {
         //switch(localeService.language)
         //{
            //case "fa":
               //return 15;
            //default:
               return 19;
         //}
      }
      
      private function getPresentLabelSize() : int
      {
         //switch(localeService.language)
         //{
            //case "fa":
               //return 15;
            //default:
               return 22;
         //}
      }
      
      private function initCrystalsAndPriceInnerLabels() : void
      {
         //this.crystalLabel = new LabelBase();
         //this.crystalLabel.text = FormatUtils.valueToString(cr,0,false);
         //this.crystalLabel.color = ColorConstants.SHOP_CRYSTALS_TEXT_LABEL_COLOR;
         //this.crystalLabel.autoSize = TextFieldAutoSize.LEFT;
         //this.crystalLabel.size = this.getCrystalsLabelSize();
         //this.crystalLabel.bold = true;
         //this.crystalLabel.mouseEnabled = false;
         //addChild(this.crystalLabel);
         this.crystalBlueIcon = new Bitmap(BPItemIcons.crystalBlue);
         addChild(this.crystalBlueIcon);
         addPriceLabel(pr);
      }
      
      private function initPackageWithPresent() : void
      {
         //if(paymentWindowService.hasBonusForItem(item))
         //{
            //setSkin(ShopItemSkins.RED);
         //}
         this.presentLabel = new LabelBase();
         this.presentLabel.text = "+" + FormatUtils.valueToString(0,0,false);
         this.presentLabel.color = 16777215;
         this.presentLabel.autoSize = TextFieldAutoSize.LEFT;
         this.presentLabel.size = this.getPresentLabelSize();
         this.presentLabel.bold = true;
         this.presentLabel.mouseEnabled = false;
         addChild(this.presentLabel);
         this.presentSecondLabel = new LabelBase();
         this.presentSecondLabel.text = "в подарок!";
         this.presentSecondLabel.color = 16777215;
         this.presentSecondLabel.autoSize = TextFieldAutoSize.LEFT;
         this.presentSecondLabel.size = this.getPresentCrystalsLabelSize();
         this.presentSecondLabel.mouseEnabled = false;
         addChild(this.presentSecondLabel);
         this.presentIcon = new Bitmap(BPItemIcons.crystalWhite);
         addChild(this.presentIcon);
      }
      
      private function initPackageWithoutPresent() : void
      {
         setSkin(ShopItemSkins.GREY);
      }
      
      private function get hasPresent() : Boolean
      {
         return false;
      }
      
      override protected function align() : void
      {
         //this.crystalLabel.x = LEFT_PADDING;
         //this.crystalLabel.y = TOP_PADDING;
         this.crystalBlueIcon.x = LEFT_PADDING;
         this.crystalBlueIcon.y = TOP_PADDING;
         priceLabel.x = LEFT_PADDING;
         priceLabel.y = this.crystalBlueIcon.y + this.crystalBlueIcon.height - 5;
         if(preview != null)
         {
            preview.x = CRYSTAL_ICON_X;
            preview.y = CRYSTAL_ICON_Y;
         }
         //if(this.hasPremium)
         //{
            //this.premiumLabel.x = LEFT_PADDING;
            //this.premiumIcon.x = this.premiumLabel.x + this.premiumLabel.width + 5;
            //this.premiumIcon.y = HEIGHT - BOTTOM_PADDING - this.premiumIcon.height;
            //this.premiumLabel.y = this.premiumIcon.y + 4;
         //}
         if(this.hasPresent)
         {
            this.presentIcon.x = WIDTH - RIGHT_PADDING - this.presentIcon.width;
            this.presentLabel.x = this.presentIcon.x - this.presentLabel.width;
            this.presentSecondLabel.x = this.presentLabel.x;
            this.presentSecondLabel.y = HEIGHT - BOTTOM_PADDING - this.presentSecondLabel.height;
            this.presentLabel.y = this.presentSecondLabel.y - this.presentSecondLabel.height + 4;
            this.presentIcon.y = this.presentLabel.y + 5;
         }
         if(hasDiscount())
         {
            //if(this.hasPremium)
            //{
               //this.crystalLabel.y = this.crystalLabel.y - 5;
               //this.crystalBlueIcon.y = this.crystalBlueIcon.y - 5;
               //priceLabel.y = priceLabel.y - 5;
               //this.premiumIcon.y = this.premiumIcon.y + 5;
               //this.premiumLabel.y = this.premiumLabel.y + 5;
            //}
            oldPriceSprite.x = priceLabel.x;
            oldPriceSprite.y = priceLabel.y + priceLabel.height - 5;
         }
      }
   }
}
