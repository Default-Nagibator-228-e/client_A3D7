package controls
{
   import assets.window.bitmaps.WindowBGTile;
   import assets.window.bitmaps.WindowBottom;
   import assets.window.bitmaps.WindowLeft;
   import assets.window.bitmaps.WindowRight;
   import assets.window.bitmaps.WindowTop;
   import assets.window.elemets.WindowBottomLeftCorner;
   import assets.window.elemets.WindowBottomRightCorner;
   import assets.window.elemets.WindowTopLeftCorner;
   import assets.window.elemets.WindowTopRightCorner;
   import utils.Filters;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import utils.windowheaders.background.BackgroundHeader;
   import utils.FontParamsUtil;
   
   public class TankWindow2 extends Sprite
   {
       
      
      private var _width:int;
	  
	  private static const HEADER_BACKGROUND_HEIGHT:int = 25;
      
      private static const HEADER_BACKGROUND_INNER_HEIGHT:int = 22;
      
      private var _height:int;
      
      private var tl:WindowTopLeftCorner;
      
      private var tr:WindowTopRightCorner;
      
      private var bl:WindowBottomLeftCorner;
      
      private var br:WindowBottomRightCorner;
      
      private var bgBMP:WindowBGTile;
      
      private var topBMP:WindowTop;
      
      private var bottomBMP:WindowBottom;
      
      private var leftBMP:WindowLeft;
      
      private var rightBMP:WindowRight;
      
      public var bg:Sprite;
      
      public var bg1:Sprite;
      
      public var bg2:Sprite;
      
      public var bg3:Sprite;
      
      private var top:Shape;
      
      private var bottom:Shape;
      
      private var left:Shape;
      
      private var right:Shape;
      
      private var mcHeader:Bitmap;
	  
	  private const GAP_11:int = 11;
      
      private var label:Label = new Label();
      
      private var _header:int = 0;
      
      public function TankWindow2(width:int = -1, height:int = -1)
      {
         this.tl = new WindowTopLeftCorner();
         this.tr = new WindowTopRightCorner();
         this.bl = new WindowBottomLeftCorner();
         this.br = new WindowBottomRightCorner();
         this.bgBMP = new WindowBGTile(0,0);
         this.topBMP = new WindowTop(0,0);
         this.bottomBMP = new WindowBottom(0,0);
         this.leftBMP = new WindowLeft(0,0);
         this.rightBMP = new WindowRight(0,0);
         this.bg = new Sprite();
         this.bg1 = new Sprite();
         this.bg2 = new Sprite();
         this.bg3 = new Sprite();
         this.top = new Shape();
         this.bottom = new Shape();
         this.left = new Shape();
         this.right = new Shape();
         super();
         this._width = width;
         this._height = height;
         this.ConfigUI();
         this.draw();
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
         this.label.bold = true;
		 this.label.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
         this.label.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
		 this.setHeader();
      }
	  
	  private function setHeader(param1:String = "МОЙ ТАНК") : void
      {
         this.label.htmlText = param1;
         if(this.label.width > this.label.height)
         {
            if(this.label.width + 2 * this.GAP_11 < BackgroundHeader.shortBackgroundHeader.width)
            {
               this.mcHeader = new Bitmap(BackgroundHeader.shortBackgroundHeader);
            }
            else
            {
               this.mcHeader = new Bitmap(BackgroundHeader.longBackgroundHeader);
            }
         }
         else
         {
            this.mcHeader = new Bitmap(BackgroundHeader.verticalBackgroundHeader);
         }
         addChild(this.mcHeader);
         addChild(this.label);
         this.draw();
      }
      
      override public function set width(w:Number) : void
      {
         this._width = int(w);
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(h:Number) : void
      {
         this._height = int(h);
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      private function ConfigUI() : void
      {
         this._width = this._width == -1?int(scaleX * 100):int(this._width);
         this._height = this._height == -1?int(scaleY * 100):int(this._height);
         scaleX = 1;
         scaleY = 1;
         addChild(this.bg);
         addChild(this.bg1);
         addChild(this.bg3);
         addChild(this.bg2);
         addChild(this.top);
         addChild(this.bottom);
         addChild(this.left);
         addChild(this.right);
         addChild(this.tl);
         addChild(this.tr);
         addChild(this.bl);
         addChild(this.br);
      }
      
      private function draw() : void
      {
         this.bg.graphics.clear();
         this.bg.graphics.beginBitmapFill(this.bgBMP);
         this.bg.graphics.drawRect(7,7,this._width - 14,7);
         this.bg.graphics.endFill();
         this.bg1.graphics.clear();
         this.bg1.graphics.beginBitmapFill(this.bgBMP);
         this.bg1.graphics.drawRect(7,7,7,this._height - 14);
         this.bg1.graphics.endFill();
         this.bg2.graphics.clear();
         this.bg2.graphics.beginBitmapFill(this.bgBMP);
         this.bg2.graphics.drawRect(this._width - 14,7,7,this._height - 14);
         this.bg2.graphics.endFill();
         this.bg3.graphics.clear();
         this.bg3.graphics.beginBitmapFill(this.bgBMP);
         this.bg3.graphics.drawRect(7,this._height - 14,this._width - 14,7);
         this.bg3.graphics.endFill();
         this.top.graphics.clear();
         this.top.graphics.beginBitmapFill(this.topBMP);
         this.top.graphics.drawRect(0,0,this._width - 22,11);
         this.top.graphics.endFill();
         this.top.x = 11;
         this.bottom.graphics.clear();
         this.bottom.graphics.beginBitmapFill(this.bottomBMP);
         this.bottom.graphics.drawRect(0,0,this._width - 22,11);
         this.bottom.graphics.endFill();
         this.bottom.x = 11;
         this.bottom.y = this._height - 11;
         this.left.graphics.clear();
         this.left.graphics.beginBitmapFill(this.leftBMP);
         this.left.graphics.drawRect(0,0,11,this._height - 22);
         this.left.graphics.endFill();
         this.left.x = 0;
         this.left.y = 11;
         this.right.graphics.clear();
         this.right.graphics.beginBitmapFill(this.rightBMP);
         this.right.graphics.drawRect(0,0,11,this._height - 22);
         this.right.graphics.endFill();
         this.right.x = this._width - 11;
         this.right.y = 11;
         this.tl.x = 0;
         this.tl.y = 0;
         this.tr.x = this._width - this.tr.width;
         this.tr.y = 0;
         this.bl.x = 0;
         this.bl.y = this._height - this.bl.height;
         this.br.x = this._width - this.br.width;
         this.br.y = this._height - this.br.height;
         if(this.mcHeader != null)
         {
            if(this.label.width > this.label.height)
            {
               this.mcHeader.x = this.width - this.mcHeader.width >> 1;
               this.mcHeader.y = -HEADER_BACKGROUND_HEIGHT;
               this.label.x = this.width - this.label.width >> 1;
               this.label.y = 5 - (HEADER_BACKGROUND_INNER_HEIGHT + this.label.height >> 1);
            }
            else
            {
               this.mcHeader.x = -HEADER_BACKGROUND_HEIGHT;
               this.mcHeader.y = this.height - this.mcHeader.height >> 1;
               this.label.x = 5 - (HEADER_BACKGROUND_INNER_HEIGHT + this.label.width >> 1);
               this.label.y = this.height - this.label.height >> 1;
            }
         }
      }
   }
}
