package forms.battlelist
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.cellrenderer.battlelist.CellBlue;
   import assets.cellrenderer.battlelist.CellNormalUp;
   import assets.cellrenderer.battlelist.CellRed;
   import controls.ButtonState;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   
   public class TeamListRenderer extends CellRenderer
   {
       
      
      private var format:TextFormat;
      
      private var nicon:DisplayObject;
      
      private var greenStyle:ButtonState;
      
      private var redStyle:ButtonState;
      
      private var BlueStyle:ButtonState;
      
      private var noNameText:String;
	  
	  public var sfr:Sprite = new Sprite();
	  
	  private var name1:String = "";
	  
	  private var rang:int = 0;
      
      public function TeamListRenderer()
      {
         this.format = new TextFormat("MyriadPro",13);
         this.greenStyle = new CellNormalUp();
         this.redStyle = new CellRed();
         this.BlueStyle = new CellBlue();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         super();
         this.format.color = 16777215;
         setStyle("textFormat",this.format);
         setStyle("embedFonts",true);
         this.noNameText = localeService.getText(TextConst.BATTLEINFO_PANEL_NONAME_TEXT);
      }
      
      override public function set data(value:Object) : void
      {
         var currentStyle:ButtonState = null;
         _data = value;
         nicon = this.myIcon(_data);
		 //nicon.addEventListener(MouseEvent.CLICK, r);
         switch(_data.style)
         {
            case "green":
               currentStyle = this.greenStyle;
               break;
            case "red":
               currentStyle = this.redStyle;
               break;
            case "blue":
               currentStyle = this.BlueStyle;
         }
         setStyle("upSkin",currentStyle);
         setStyle("downSkin",currentStyle);
         setStyle("overSkin",currentStyle);
         setStyle("selectedUpSkin",currentStyle);
         setStyle("selectedOverSkin",currentStyle);
         setStyle("selectedDownSkin",currentStyle);
      }
      
      private function myIcon(data:Object) : Sprite
      {
         var icon:Bitmap = null;
         var name:Label = null;
         var kills:Label = null;
         var rangIcon:RangIconSmall = null;
         var bmp:BitmapData = new BitmapData(_width,20,true,0);
         var cont:Sprite = new Sprite();
         name = new Label();
         name.autoSize = TextFieldAutoSize.NONE;
         name.color = 16777215;
         name.alpha = data.playerName == ""?Number(0.5):Number(1);
         name.text = data.playerName == ""?this.noNameText:data.playerName;
         name.height = 20;
         name.width = _width - 48;
         name.x = 12;
         name.y = 0;
         kills = new Label();
         kills.color = 16777215;
         kills.autoSize = TextFieldAutoSize.NONE;
         kills.align = TextFormatAlign.RIGHT;
         kills.text = data.playerName == ""?" ":String(data.kills);
         kills.height = 20;
         kills.width = 120;
         kills.x = _width - 135;
         kills.y = 0;
		 name1 = data.playerName;
		 rang = data.rang;
         if(data.rang > 0)
         {
            rangIcon = new RangIconSmall(data.rang);
            rangIcon.x = -2;
            rangIcon.y = 2;
            cont.addChild(rangIcon);
         }
		 //sfr.addChild(name);
		 this.addEventListener(MouseEvent.CLICK, r);
         cont.addChild(name);
         cont.addChild(kills);
         return cont;
      }
	  
	  private function r(e:MouseEvent) : void
      {
		//var h:String = (e.target as Label).text;
		//while(h.search(":") != -1)
        // {
            //h = h.replace(":","");
         //}
		 //while(h.search(" ") != -1)
         //{
            //h = h.replace(" ","");
         //}
		//if (!(h == Game.log))
		//{
			if (name1 != "")
			{
				var tim:Timer = new Timer(100,1);
				tim.addEventListener(TimerEvent.TIMER_COMPLETE, function(param1:Event):void
				{
					Game.cont.visible = true;
					Game.cont.past(rang, name1, "bat");
				});
				tim.start();
			}
		//}
      }
      
      override public function set listData(value:ListData) : void
      {
         _listData = value;
         label = "";
         if(this.nicon != null)
         {
            setStyle("icon",this.nicon);
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
