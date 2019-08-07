package forms
{
   import alternativa.osgi.service.locale.ILocaleService;
   import controls.Label;
   import controls.TankWindow;
   import utils.Filters;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import utils.windowheaders.background.BackgroundHeader;
   import utils.FontParamsUtil;
   
   public class TankWindowWithHeader extends Sprite
   {
      
      private static const HEADER_BACKGROUND_HEIGHT:int = 25;
      
      private static const HEADER_BACKGROUND_INNER_HEIGHT:int = 22;
      
      public static var localeService:ILocaleService;
       
      
      private const GAP_11:int = 11;
      
      private var label:Label;
      
      private var window:TankWindow;
      
      private var headerBackground:Bitmap;
      
      public function TankWindowWithHeader(param1:String = null)
      {
         this.label = new Label();
         super();
         this.window = new TankWindow();
         addChild(this.window);
         this.initHeaderStyle();
         if(param1 != null)
         {
            this.setHeader(param1);
         }
      }
      
      public static function createWindow(param1:String, param2:int = -1, param3:int = -1) : TankWindowWithHeader
      {
         var _loc4_:TankWindowWithHeader = new TankWindowWithHeader(param1);
         _loc4_.width = param2;
         _loc4_.height = param3;
         return _loc4_;
      }
      
      private function initHeaderStyle() : void
      {
         var _loc1_:String = "ru";
         if(_loc1_ == "fa")
         {
            this.label.setTextFormat(new TextFormat("IRANYekan"));
         }
         else if(_loc1_ == "cn")
         {
            this.label.setTextFormat(new TextFormat("simsun"));
         }
         this.label.filters = Filters.SHADOW_FILTERS;
         this.label.size = 16;
         this.label.color = 12632256;
		 this.label.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
         this.label.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
         this.label.bold = true;
      }
      
      private function setHeader(param1:String) : void
      {
         this.label.text = param1;
         if(this.label.width > this.label.height)
         {
            if(this.label.width + 2 * this.GAP_11 < BackgroundHeader.shortBackgroundHeader.width)
            {
               this.headerBackground = new Bitmap(BackgroundHeader.shortBackgroundHeader);
            }
            else
            {
               this.headerBackground = new Bitmap(BackgroundHeader.longBackgroundHeader);
            }
         }
         else
         {
            this.headerBackground = new Bitmap(BackgroundHeader.verticalBackgroundHeader);
         }
         addChild(this.headerBackground);
         addChild(this.label);
         this.resize();
      }
      
      public function setHeaderId(param1:String) : void
      {
         this.setHeader(localeService.getText(param1));
      }
      
      override public function set width(param1:Number) : void
      {
         this.window.width = param1;
         this.resize();
      }
      
      override public function get width() : Number
      {
         return this.window.width;
      }
      
      override public function set height(param1:Number) : void
      {
         this.window.height = param1;
         this.resize();
      }
      
      override public function get height() : Number
      {
         return this.window.height;
      }
      
      private function resize() : void
      {
         if(this.headerBackground != null)
         {
            if(this.label.width > this.label.height)
            {
               this.headerBackground.x = this.window.width - this.headerBackground.width >> 1;
               this.headerBackground.y = -HEADER_BACKGROUND_HEIGHT;
               this.label.x = this.window.width - this.label.width >> 1;
               this.label.y = 5 - (HEADER_BACKGROUND_INNER_HEIGHT + this.label.height >> 1);
            }
            else
            {
               this.headerBackground.x = -HEADER_BACKGROUND_HEIGHT;
               this.headerBackground.y = this.window.height - this.headerBackground.height >> 1;
               this.label.x = 5 - (HEADER_BACKGROUND_INNER_HEIGHT + this.label.width >> 1);
               this.label.y = this.window.height - this.label.height >> 1;
            }
         }
      }
   }
}
