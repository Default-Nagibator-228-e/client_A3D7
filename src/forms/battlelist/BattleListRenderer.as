package forms.battlelist
{
   import assets.cellrenderer.battlelist.CellRenderer_disabledDownSkin;
   import assets.cellrenderer.battlelist.CellRenderer_disabledOverSkin;
   import assets.cellrenderer.battlelist.CellRenderer_disabledSelectedDownSkin;
   import assets.cellrenderer.battlelist.CellRenderer_disabledSelectedOverSkin;
   import assets.cellrenderer.battlelist.CellRenderer_disabledSelectedUpSkin;
   import assets.cellrenderer.battlelist.CellRenderer_disabledUpSkin;
   import assets.cellrenderer.battlelist.CellRenderer_downSkin;
   import assets.cellrenderer.battlelist.CellRenderer_overSkin;
   import assets.cellrenderer.battlelist.CellRenderer_selectedDownSkin;
   import assets.cellrenderer.battlelist.CellRenderer_selectedOverSkin;
   import assets.cellrenderer.battlelist.CellRenderer_selectedUpSkin;
   import assets.cellrenderer.battlelist.CellRenderer_upSkin;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.DisplayObject;
   
   public class BattleListRenderer extends CellRenderer
   {
      
      private static var defaultStyles:Object = {
         "upSkin":"CellRenderer_upSkin",
         "downSkin":"CellRenderer_downSkin",
         "overSkin":"CellRenderer_overSkin",
         "disabledSkin":"CellRenderer_disabledSkin",
         "selectedDisabledSkin":"CellRenderer_selectedDisabledSkin",
         "selectedUpSkin":"CellRenderer_selectedUpSkin",
         "selectedDownSkin":"CellRenderer_selectedUpSkin",
         "selectedOverSkin":"CellRenderer_selectedUpSkin",
         "textFormat":null,
         "disabledTextFormat":null,
         "embedFonts":null,
         "textPadding":5
      };
       
      
      private var access:Boolean = true;
      
      private var nicon:DisplayObject;
      
      private var sicon:DisplayObject;
      
      public function BattleListRenderer()
      {
         super();
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
         this.access = value.accessible;
         this.nicon = value.iconNormal;
         this.sicon = value.iconSelected;
         if(!this.access)
         {
            setStyle("upSkin",CellRenderer_disabledUpSkin);
            setStyle("downSkin",CellRenderer_disabledDownSkin);
            setStyle("overSkin",CellRenderer_disabledOverSkin);
            setStyle("selectedUpSkin",CellRenderer_disabledSelectedUpSkin);
            setStyle("selectedOverSkin",CellRenderer_disabledSelectedOverSkin);
            setStyle("selectedDownSkin",CellRenderer_disabledSelectedDownSkin);
         }
         else
         {
            setStyle("upSkin",CellRenderer_upSkin);
            setStyle("downSkin",CellRenderer_downSkin);
            setStyle("overSkin",CellRenderer_overSkin);
            setStyle("selectedUpSkin",CellRenderer_selectedUpSkin);
            setStyle("selectedOverSkin",CellRenderer_selectedOverSkin);
            setStyle("selectedDownSkin",CellRenderer_selectedDownSkin);
         }
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
         var styleName:String = enabled?mouseState:"disabled";
         if(selected)
         {
            styleName = "selected" + styleName.substr(0,1).toUpperCase() + styleName.substr(1);
         }
         styleName = styleName + "Skin";
         var bg:DisplayObject = background;
         background = getDisplayObjectInstance(getStyleValue(styleName));
         addChildAt(background,0);
         if(bg != null && bg != background)
         {
            removeChild(bg);
         }
      }
      
      override protected function drawLayout() : void
      {
         super.drawLayout();
         background.width = width - 4;
         background.height = height;
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
