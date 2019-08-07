package forms.garage
{
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.DisplayObject;
   
   public class PartsListRenderer extends CellRenderer
   {
      
      private static var defaultStyles:Object = {
         "upSkin":null,
         "downSkin":null,
         "overSkin":null,
         "disabledSkin":null,
         "selectedDisabledSkin":null,
         "selectedUpSkin":null,
         "selectedDownSkin":null,
         "selectedOverSkin":null,
         "textFormat":null,
         "disabledTextFormat":null,
         "embedFonts":null,
         "textPadding":5
      };
       
      
      private var nicon:DisplayObject;
      
      private var sicon:DisplayObject;
      
      public function PartsListRenderer()
      {
         super();
         this.buttonMode = true;
         this.useHandCursor = true;
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
         this.nicon = value.iconNormal;
         this.sicon = value.iconSelected;
      }
      
      override public function set listData(value:ListData) : void
      {
         _listData = value;
         label = _listData.label;
         if(this.nicon != null && this.sicon != null)
         {
            setStyle("icon",this.nicon);
            setStyle("selectedUpIcon",this.sicon);
            setStyle("selectedOverIcon",this.sicon);
            setStyle("selectedDownIcon",this.sicon);
         }
      }
      
      override protected function drawBackground() : void
      {
      }
      
      override protected function drawLayout() : void
      {
      }
      
      override protected function drawIcon() : void
      {
         var oldIcon:DisplayObject = icon;
         var styleName:String = enabled?mouseState:"disabled";
         if(selected)
         {
            styleName = "selected" + styleName.substr(0,1).toUpperCase() + styleName.substr(1);
         }
         styleName = styleName + "Icon";
         var iconStyle:Object = getStyleValue(styleName);
         if(iconStyle == null)
         {
            iconStyle = getStyleValue("icon");
         }
         if(iconStyle != null)
         {
            icon = getDisplayObjectInstance(iconStyle);
         }
         if(icon != null)
         {
            addChildAt(icon,1);
         }
         if(oldIcon != null && oldIcon != icon && oldIcon.parent == this)
         {
            removeChild(oldIcon);
         }
      }
   }
}
