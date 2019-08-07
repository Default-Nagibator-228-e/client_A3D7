package forms.shop.shopitems.item.garageitem
{
   import forms.shop.shopitems.item.details.ShopItemDetails;
   import alternativa.tanks.model.payment.shop.paint.PaintPackage;
   import controls.base.LabelBase;
   import forms.ColorConstants;
   import platform.client.fp10.core.type.IGameObject;
   
   public class PaintPackageDescriptionView extends ShopItemDetails
   {
      
      private static const WIDTH:int = 250;
       
      
      public function PaintPackageDescriptionView(param1:IGameObject)
      {
         super(param1);
         this.addDescription();
      }
      
      private function addDescription() : void
      {
         var _loc1_:LabelBase = null;
         _loc1_ = new LabelBase();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.color = ColorConstants.GREEN_TEXT;
         _loc1_.htmlText = PaintPackage(shopItemObject.adapt(PaintPackage)).getDescription();
         _loc1_.mouseWheelEnabled = false;
         _loc1_.width = WIDTH;
         addChild(_loc1_);
      }
   }
}
