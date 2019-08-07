package forms.shop.shopitems.item.kits.description
{
   import alternativa.osgi.service.locale.ILocaleService;
   import forms.shop.shopitems.item.details.ShopItemDetails;
   import forms.shop.shopitems.item.kits.description.panel.KitPackageDescriptionPanel;
   import alternativa.tanks.model.payment.shop.kit.KitPackage;
   import assets.Diamond;
   import controls.Money;
   import controls.base.LabelBase;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import forms.ColorConstants;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   
   public class KitPackageDescriptionView extends ShopItemDetails
   {
      
      public static const LEFT_TOP_MARGIN:int = 12;
      
      public static const ITEM_HEIGHT:int = 17;
      
      public static const WIDTH:int = 350;
      
      [Inject]
      public static var localeService:ILocaleService;
       
      
      private var container:Sprite;
      
      public function KitPackageDescriptionView(param1:IGameObject)
      {
         super(param1);
         this.container = new Sprite();
         this.container.y = 3;
         addChild(this.container);
         this.addPanel();
         this.addHeader();
         this.addRows();
         this.addSummary();
      }
      
      private function addPanel() : void
      {
         var _loc1_:KitPackageDescriptionPanel = new KitPackageDescriptionPanel();
         _loc1_.resize(this.kitPackage.getItemInfos().length);
         this.container.addChild(_loc1_);
      }
      
      private function addHeader() : void
      {
         var _loc2_:LabelBase = null;
         var _loc1_:LabelBase = new LabelBase();
         _loc1_.color = ColorConstants.GREEN_LABEL;
         _loc1_.align = TextFormatAlign.LEFT;
         _loc1_.text = localeService.getText(TanksLocale.TEXT_ITEMS_IN_KIT);
         _loc1_.x = LEFT_TOP_MARGIN;
         _loc1_.y = LEFT_TOP_MARGIN;
         this.container.addChild(_loc1_);
         _loc2_ = new LabelBase();
         _loc2_.color = ColorConstants.GREEN_LABEL;
         _loc2_.align = TextFormatAlign.RIGHT;
         _loc2_.text = localeService.getText(TanksLocale.TEXT_GARAGE_PRICE);
         _loc2_.x = WIDTH - _loc2_.width - _loc1_.x;
         _loc2_.y = _loc1_.y;
         this.container.addChild(_loc2_);
      }
      
      private function addRows() : void
      {
         var _loc2_:KitPackageItemInfo = null;
         var _loc3_:KitPackageDescriptionRow = null;
         var _loc1_:int = LEFT_TOP_MARGIN + ITEM_HEIGHT;
         for each(_loc2_ in this.kitPackage.getItemInfos())
         {
            _loc3_ = new KitPackageDescriptionRow(_loc2_);
            _loc3_.y = _loc1_;
            this.container.addChild(_loc3_);
            _loc1_ = _loc1_ + ITEM_HEIGHT;
         }
      }
      
      private function addSummary() : void
      {
         var _loc1_:LabelBase = null;
         _loc1_ = new LabelBase();
         _loc1_.color = ColorConstants.GREEN_LABEL;
         _loc1_.align = TextFormatAlign.LEFT;
         _loc1_.text = localeService.getText(TanksLocale.TEXT_TOTAL_PRICE_KIT);
         _loc1_.x = LEFT_TOP_MARGIN;
         _loc1_.y = LEFT_TOP_MARGIN + (this.kitPackage.getItemInfos().length + 1) * ITEM_HEIGHT + LEFT_TOP_MARGIN;
         this.container.addChild(_loc1_);
         var _loc2_:Diamond = new Diamond();
         _loc2_.x = WIDTH - _loc1_.x - _loc2_.width;
         _loc2_.y = _loc1_.y + 4;
         this.container.addChild(_loc2_);
         var _loc3_:LabelBase = new LabelBase();
         _loc3_.color = ColorConstants.GREEN_LABEL;
         _loc3_.align = TextFormatAlign.RIGHT;
         _loc3_.text = Money.numToString(this.getKitPrice(),false);
         _loc3_.x = _loc2_.x - _loc3_.width - 1;
         _loc3_.y = _loc1_.y;
         this.container.addChild(_loc3_);
      }
      
      private function getKitPrice() : int
      {
         var _loc2_:KitPackageItemInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.kitPackage.getItemInfos())
         {
            _loc1_ = _loc1_ + _loc2_.crystalPrice * _loc2_.count;
         }
         return _loc1_;
      }
      
      private function get kitPackage() : KitPackage
      {
         return KitPackage(shopItemObject.adapt(KitPackage));
      }
   }
}
