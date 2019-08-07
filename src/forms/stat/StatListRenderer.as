package forms.stat
{
   import controls.Label;
   import controls.Money;
   import controls.Rank;
   import controls.rangicons.RangIconSmall;
   import controls.statassets.StatLineBackgroundNormal;
   import controls.statassets.StatLineBackgroundSelected;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class StatListRenderer extends CellRenderer
   {
       
      
      protected var nicon:DisplayObject;
      
      private var sicon:DisplayObject;
      
      public function StatListRenderer()
      {
         super();
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
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
      
      protected function bg(_selected:Boolean) : DisplayObject
      {
         var cont:Sprite = new Sprite();
         return cont;
      }
      
      protected function myIcon(data:Object) : Sprite
      {
         var pos:Label = null;
         var info:Label = null;
         var infoString:String = null;
         var format:TextFormat = null;
         var infoX:int = 0;
         var cont:Sprite = new Sprite();
         pos = new Label();
         var rangIcon:RangIconSmall = new RangIconSmall(_data.rank);
         var rangString:Label = new Label();
         var name:Label = new Label();
         pos.autoSize = TextFieldAutoSize.NONE;
         pos.align = TextFormatAlign.RIGHT;
         pos.width = 45;
         pos.text = _data.pos < 0?" ":_data.pos;
         cont.addChild(pos);
         if(_data.rank > 0)
         {
            rangIcon.y = 3;
            rangIcon.x = 53;
            cont.addChild(rangIcon);
            rangString.text = Rank.name(int(_data.rank));
            rangString.x = 63;
            cont.addChild(rangString);
         }
         name.autoSize = TextFieldAutoSize.NONE;
         name.height = 18;
         name.text = _data.callsign;
         name.selectable = true;
         name.x = 178;
         name.width = _width - 520;
         cont.addChild(name);
         infoX = int(_width - 375);
         info = new Label();
         info.autoSize = TextFieldAutoSize.NONE;
         info.align = TextFormatAlign.RIGHT;
         info.width = 60;
         info.x = infoX;
         info.text = _data.score > -1?Money.numToString(_data.score,false):" ";
         cont.addChild(info);
         infoX = infoX + 60;
         info = new Label();
         info.autoSize = TextFieldAutoSize.NONE;
         info.align = TextFormatAlign.RIGHT;
         info.width = 70;
         info.x = infoX;
         info.text = _data.kills > -1?Money.numToString(_data.kills,false):" ";
         cont.addChild(info);
         infoX = infoX + 70;
         info = new Label();
         info.autoSize = TextFieldAutoSize.NONE;
         info.align = TextFormatAlign.RIGHT;
         info.width = 50;
         info.x = infoX;
         info.text = _data.deaths > -1?Money.numToString(_data.deaths,false):" ";
         cont.addChild(info);
         infoX = infoX + 50;
         info = new Label();
         info.autoSize = TextFieldAutoSize.NONE;
         info.align = TextFormatAlign.RIGHT;
         info.width = 40;
         info.x = infoX;
         info.text = _data.ratio > -1?Money.numToString(_data.ratio):_data.ratio == -11?" ":"—";
         cont.addChild(info);
         infoX = infoX + 40;
         info = new Label();
         info.autoSize = TextFieldAutoSize.NONE;
         info.align = TextFormatAlign.RIGHT;
         info.width = 65;
         info.x = infoX;
         info.htmlText = _data.wealth > -1?Money.numToString(_data.wealth,false):" ";
         cont.addChild(info);
         infoX = infoX + 75;
         info = new Label();
         info.autoSize = TextFieldAutoSize.NONE;
         info.align = TextFormatAlign.RIGHT;
         info.width = 69;
         info.x = infoX;
         info.text = _data.rating > -1?Money.numToString(_data.rating):" ";
         cont.addChild(info);
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
