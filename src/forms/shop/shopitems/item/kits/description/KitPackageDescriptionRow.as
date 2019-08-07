package forms.shop.shopitems.item.kits.description
{
   import assets.Diamond;
   import controls.Money;
   import controls.base.LabelBase;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import forms.ColorConstants;
   import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
   
   public class KitPackageDescriptionRow extends Sprite
   {
       
      
      public function KitPackageDescriptionRow(param1:KitPackageItemInfo)
      {
         super();
         var _loc2_:LabelBase = new LabelBase();
         _loc2_.textColor = ColorConstants.WHITE;
         _loc2_.align = TextFormatAlign.LEFT;
         _loc2_.text = param1.itemName + (param1.count <= 1?"":" ×" + String(param1.count));
         _loc2_.x = KitPackageDescriptionView.LEFT_TOP_MARGIN;
         addChild(_loc2_);
         var _loc3_:Diamond = new Diamond();
         _loc3_.x = KitPackageDescriptionView.WIDTH - _loc2_.x - _loc3_.width;
         _loc3_.y = 4;
         addChild(_loc3_);
         var _loc4_:int = param1.crystalPrice * param1.count;
         var _loc5_:LabelBase = new LabelBase();
         _loc5_.color = ColorConstants.WHITE;
         _loc5_.align = TextFormatAlign.RIGHT;
         _loc5_.text = Money.numToString(_loc4_,false);
         _loc5_.x = _loc3_.x - _loc5_.width - 1;
         addChild(_loc5_);
      }
   }
}
