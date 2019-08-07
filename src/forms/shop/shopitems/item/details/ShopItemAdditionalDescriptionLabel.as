package forms.shop.shopitems.item.details
{
   import forms.shop.components.item.GridItemBase;
   import controls.base.LabelBase;
   import forms.ColorConstants;
   
   public class ShopItemAdditionalDescriptionLabel extends GridItemBase
   {
      
      private static const WIDTH:int = 800;
       
      
      public function ShopItemAdditionalDescriptionLabel(param1:String)
      {
         var _loc2_:LabelBase = null;
         super();
         _loc2_ = new LabelBase();
         _loc2_.color = ColorConstants.GREEN_TEXT;
         _loc2_.htmlText = param1;
         _loc2_.multiline = true;
         _loc2_.wordWrap = true;
         _loc2_.width = WIDTH;
         addChild(_loc2_);
      }
      
      override public function get forceNewLine() : Boolean
      {
         return true;
      }
   }
}
