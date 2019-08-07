package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import controls.base.DefaultButtonBase;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldAutoSize;
   
   public class ServerMessage extends Sprite
   {
      [Embed(source="1.png")]
      private static const IconImage:Class;
      
      private static const iconImage:BitmapData = new IconImage().bitmapData;
      
      private var _refreshButton:DefaultButtonBase;
      
      private var _supportLink:LabelBase;
      
      private var window:TankWindow;
      
      private var description:LabelBase;
      
      private var field:TankWindowInner;
      
      private var icon:Bitmap;
      
      private var SUPPORT_URL:String;
      
      public function ServerMessage(str:String)
      {
         var _loc5_:Number = NaN;
         super();
         var _loc2_:Number = 300;
         var _loc3_:Number = 12;
         var _loc4_:Number = 10;
         _loc5_ = -2;
         var _loc6_:Number = 47;
         var _loc7_:Number = 33;
         var _loc8_:Number = 100;
         this.icon = new Bitmap(iconImage);
         this.icon.x = 23;
         this.icon.y = 23;
         this.description = new LabelBase();
         this.description.color = 5898035;
         this.description.multiline = true;
         this.description.autoSize = TextFieldAutoSize.LEFT;
         this.description.x = this.icon.x + this.icon.width + _loc3_ - 4;
         this.description.y = _loc3_ + _loc3_ - 3;
		 this.description.text = str;
         this.description.selectable = true;
         if(this.description.y + this.description.height > this.icon.y + this.icon.height)
         {
            _loc6_ = _loc6_ + (this.description.y + this.description.height - this.icon.y - this.icon.height);
         }
         this.window = new TankWindow(_loc2_,_loc3_ + _loc6_ + _loc4_ + _loc7_ + _loc4_ + _loc5_ + _loc7_ + _loc3_);
         this.field = new TankWindowInner(_loc2_ - _loc3_ * 2,_loc6_,TankWindowInner.GREEN);
         this.field.x = _loc3_;
         this.field.y = _loc3_;
         addChild(this.window);
         this.window.addChild(this.field);
         this.window.addChild(this.icon);
         this.window.addChild(this.description);
         this._refreshButton = new DefaultButtonBase();
         this._refreshButton.label = "Ок";
         this._refreshButton.x = _loc3_ + 1;
         this._refreshButton.y = _loc3_ + _loc6_ + _loc4_;
         this._refreshButton.width = this._refreshButton.width + 24 * 2;
         this._refreshButton.addEventListener(MouseEvent.CLICK,this.onRefreshButtonClick);
         this.window.addChild(this._refreshButton);
         this.redraw();
		 Main.stage.addEventListener(Event.RESIZE, redraw);
      }
      
      private function reposition(e:Event = null) : void
      {
		 this.window.x = Main.stage.stageWidth - this.window.width >> 1;
         this.window.y = Main.stage.stageHeight - this.window.height >> 1;
      }
      
      private function onSupportClick(param1:TextEvent) : void
      {
         navigateToURL(new URLRequest(this.SUPPORT_URL),"_blank");
      }
      
      private function onRefreshButtonClick(param1:MouseEvent = null) : void
      {
		  this.parent.removeChild(this);
		 removeChild(this.window);
         this.window.removeChild(this.field);
         this.window.removeChild(this.icon);
         this.window.removeChild(this.description);
         this._refreshButton.removeEventListener(MouseEvent.CLICK,this.onRefreshButtonClick);
         this.window.removeChild(this._refreshButton);
		 Main.stage.removeEventListener(Event.RESIZE, redraw);
		 this.window = null;
         this.field = null;
         this.icon = null;
         this.description = null;
         this._refreshButton = null;
      }
      
      private function redraw(e:Event = null) : void
      {
         this.field.width = 40 + this.icon.width + this.description.width;
         this.field.height = Math.max(this.icon.height,this.description.height) + 20;
         this.window.width = this.field.width + 24;
         this.window.height = 40 + this.field.height + this._refreshButton.height;
         if(this.description.height < this.icon.height)
         {
            this.description.y = this.icon.y + (this.icon.height - this.description.textHeight >> 1) - 3;
         }
         this._refreshButton.x = this.window.width - this._refreshButton.width >> 1;
         this._refreshButton.y = this.field.y + this.field.height + 8;
         this.reposition();
      }
      
      public function set text(param1:String) : void
      {
         this.redraw();
      }
      
      public function setSupportUrl(param1:String) : void
      {
         this.SUPPORT_URL = param1;
      }
   }
}
