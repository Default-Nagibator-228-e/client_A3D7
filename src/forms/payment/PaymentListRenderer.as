package forms.payment
{
   import controls.Label;
   import controls.statassets.StatLineBackgroundNormal;
   import controls.statassets.StatLineBackgroundSelected;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import utils.TextUtils;
   
   public class PaymentListRenderer extends CellRenderer
   {
      
      private static var _withSMSText:Boolean = false;
       
      
      private var nicon:DisplayObject;
      
      private var sicon:DisplayObject;
      
      public function PaymentListRenderer()
      {
         super();
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
         _withSMSText = _data.smsText !== "";
         var nr:DisplayObject = new StatLineBackgroundNormal();
         var sl:DisplayObject = new StatLineBackgroundSelected();
         this.nicon = this.myIcon(_data);
         setStyle("upSkin",nr);
         setStyle("downSkin",nr);
         setStyle("overSkin",nr);
         setStyle("selectedUpSkin",sl);
         setStyle("selectedOverSkin",sl);
         setStyle("selectedDownSkin",sl);
      }
      
      override public function set listData(value:ListData) : void
      {
         _listData = value;
         label = _listData.label;
         if(this.nicon != null)
         {
            setStyle("icon",this.nicon);
         }
      }
      
      private function myIcon(data:Object) : Sprite
      {
         var cont:Sprite = null;
         cont = new Sprite();
         var number:Label = new Label();
         var smsText:Label = new Label();
         var smsTextBmp:Bitmap = new Bitmap();
         var cost:Label = new Label();
         var crystals:Label = new Label();
         var roubles:Label = new Label();
         var subwidth:int = !!_withSMSText?int(60):int((_width - 72) / 2);
         number.autoSize = TextFieldAutoSize.NONE;
         number.align = TextFormatAlign.CENTER;
         number.size = 13;
         number.height = 20;
         number.x = -5;
         number.width = 70;
         number.text = _data.number;
         cont.addChild(number);
         cost.autoSize = TextFieldAutoSize.NONE;
         cost.align = TextFormatAlign.RIGHT;
         cost.size = 13;
         cost.height = 20;
         cost.text = _data.cost;
         cost.x = 72;
         cost.width = int(subwidth) - 7;
         cont.addChild(cost);
         if(_withSMSText)
         {
            smsText.autoSize = TextFieldAutoSize.NONE;
            smsText.align = TextFormatAlign.LEFT;
            smsText.size = 12;
            smsText.height = 20;
            smsTextBmp.x = 72;
            smsText.width = _width - 170;
            smsText.text = _data.smsText;
            smsTextBmp.bitmapData = TextUtils.getTextInCells(smsText,12,18,5898034);
            cont.addChild(smsTextBmp);
            cost.x = smsText.width + 74;
         }
         crystals.autoSize = TextFieldAutoSize.NONE;
         crystals.align = TextFormatAlign.RIGHT;
         crystals.size = 13;
         crystals.height = 20;
         crystals.x = cost.x + cost.width + 2;
         crystals.width = int(_width - crystals.x - 12);
         crystals.text = _data.crystals;
         cont.addChild(crystals);
         return cont;
      }
      
      override protected function drawBackground() : void
      {
         var styleName:String = !!enabled?mouseState:"disabled";
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
      }
      
      override protected function drawIcon() : void
      {
         var oldIcon:DisplayObject = icon;
         var styleName:String = !!enabled?mouseState:"disabled";
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
