package alternativa.tanks.help
{
   import controls.Label;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.TextFormat;
   
   public class BubbleHelper extends Helper
   {
      
      private static var defaultTextFormat:TextFormat = new TextFormat("Tahoma",10,16777215,true);
       
      
      private var back:Shape;
      
      private var outline:Shape;
      
      public const r:int = 16;
      
      private const lineThickness:int = 1;
      
      private const lineColor:uint = 16777215;
      
      private const fillColor:uint = 0;
      
      private const lineAlpha:Number = 1;
      
      private const fillAlpha:Number = 0.85;
      
      private const arrowShift:int = 24.0;
      
      private const arrowWidth:int = 24.0;
      
      private var _arrowLehgth:int = 48.0;
      
      private var _arrowAlign:int;
      
      private var _align:int;
      
      private var arrowP1:Point;
      
      private var arrowP2:Point;
      
      private var arrowTarget:Point;
      
      private var outlineArrowP1:Point;
      
      private var outlineArrowP2:Point;
      
      private var outlineArrowTarget:Point;
      
      private var arrowDirection:Boolean;
      
      private var descriptionLabel:Label;
      
      private var margin:int = 12;
      
      private var bmp:Bitmap;
      
      private var bd:BitmapData;
      
      private var backContainer:Sprite;
      
      public function BubbleHelper()
      {
         this.arrowP1 = new Point();
         this.arrowP2 = new Point();
         this.arrowTarget = new Point();
         this.outlineArrowP1 = new Point();
         this.outlineArrowP2 = new Point();
         this.outlineArrowTarget = new Point();
         super();
         _size = new Point();
         _targetPoint = new Point();
         this.bmp = new Bitmap();
         addChild(this.bmp);
         this.backContainer = new Sprite();
         this.backContainer.mouseEnabled = false;
         this.backContainer.mouseChildren = false;
         this.backContainer.tabEnabled = false;
         this.backContainer.tabChildren = false;
         this.outline = new Shape();
         this.backContainer.addChild(this.outline);
         this.back = new Shape();
         this.backContainer.addChild(this.back);
         this.arrowAlign = HelperAlign.MIDDLE_RIGHT;
         this.descriptionLabel = new Label();
         this.descriptionLabel.multiline = true;
         addChild(this.descriptionLabel);
         this.descriptionLabel.x = this.margin - 3;
         this.descriptionLabel.y = this.margin - 4;
         this.descriptionLabel.mouseEnabled = false;
         this.descriptionLabel.tabEnabled = false;
      }
      
      public static function set textFormat(tf:TextFormat) : void
      {
         BubbleHelper.defaultTextFormat = tf;
      }
      
      override public function draw(size:Point) : void
      {
         _size.x = int(size.x);
         _size.y = int(size.y);
         this.outline.graphics.clear();
         this.outline.graphics.beginFill(this.lineColor,this.lineAlpha);
         this.outline.graphics.drawRoundRect(-this.lineThickness,-this.lineThickness,size.x + this.lineThickness * 2,size.y + this.lineThickness * 2,this.r + 2,this.r + 2);
         this.outline.graphics.drawRoundRect(0,0,size.x,size.y,this.r,this.r);
         this.back.graphics.clear();
         this.back.graphics.beginFill(this.fillColor,this.fillAlpha);
         this.back.graphics.drawRoundRect(0,0,size.x,size.y,this.r,this.r);
         var tga:Number = this._arrowLehgth / this.arrowWidth;
         if(this._arrowAlign & HelperAlign.TOP_MASK)
         {
            this.arrowP1.y = 0;
            this.arrowP2.y = 0;
            this.arrowTarget.y = -this._arrowLehgth;
            this.outlineArrowP1.y = 0;
            this.outlineArrowP2.y = 0;
            this.outlineArrowTarget.y = -tga * (this.arrowWidth + this.lineThickness * 2);
         }
         else if(this._arrowAlign & HelperAlign.MIDDLE_MASK)
         {
            this.arrowP1.y = size.y - this.arrowWidth >> 1;
            this.arrowP2.y = this.arrowP1.y + this.arrowWidth;
            this.arrowTarget.y = this.arrowP1.y;
            this.outlineArrowP1.y = this.arrowP1.y - this.lineThickness;
            this.outlineArrowP2.y = this.arrowP1.y + this.arrowWidth + this.lineThickness;
            this.outlineArrowTarget.y = this.outlineArrowP1.y;
         }
         else
         {
            this.arrowP1.y = size.y;
            this.arrowP2.y = size.y;
            this.arrowTarget.y = size.y + this._arrowLehgth;
            this.outlineArrowP1.y = size.y;
            this.outlineArrowP2.y = size.y;
            this.outlineArrowTarget.y = size.y + tga * (this.arrowWidth + this.lineThickness * 2);
         }
         if(this._arrowAlign & HelperAlign.LEFT_MASK)
         {
            if(this.arrowDirection == HelperArrowDirection.VERTICAL)
            {
               this.arrowTarget.x = this.arrowShift;
               this.arrowP1.x = this.arrowShift;
               this.arrowP2.x = this.arrowShift + this.arrowWidth;
               this.outlineArrowTarget.x = this.arrowShift - this.lineThickness;
               this.outlineArrowP1.x = this.arrowShift - this.lineThickness;
               this.outlineArrowP2.x = this.arrowShift + this.arrowWidth + this.lineThickness;
            }
            else
            {
               this.arrowTarget.x = -this._arrowLehgth;
               this.arrowP1.x = 0;
               this.arrowP2.x = 0;
               this.outlineArrowTarget.x = -tga * (this.arrowWidth + this.lineThickness * 2);
               this.outlineArrowP1.x = 0;
               this.outlineArrowP2.x = 0;
            }
            if(this._arrowAlign & HelperAlign.TOP_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x,this.arrowP1.y - this.lineThickness,this.arrowP2.x - this.arrowP1.x,this.lineThickness);
            }
            else if(this._arrowAlign & HelperAlign.MIDDLE_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x - this.lineThickness,this.arrowP1.y,this.lineThickness,this.arrowP2.y - this.arrowP1.y);
            }
            else
            {
               this.outline.graphics.drawRect(this.arrowP1.x,this.arrowP1.y,this.arrowP2.x - this.arrowP1.x,this.lineThickness);
            }
         }
         else if(this._arrowAlign & HelperAlign.CENTER_MASK)
         {
            this.arrowTarget.x = size.x - this.arrowWidth >> 1;
            this.arrowP1.x = this.arrowTarget.x;
            this.arrowP2.x = this.arrowTarget.x + this.arrowWidth;
            this.outlineArrowTarget.x = this.arrowTarget.x - this.lineThickness;
            this.outlineArrowP1.x = this.outlineArrowTarget.x;
            this.outlineArrowP2.x = this.arrowP2.x + this.lineThickness;
            if(this._arrowAlign & HelperAlign.TOP_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x,this.arrowP1.y - this.lineThickness,this.arrowP2.x - this.arrowP1.x,this.lineThickness);
            }
            else
            {
               this.outline.graphics.drawRect(this.arrowP1.x,this.arrowP1.y,this.arrowP2.x - this.arrowP1.x,this.lineThickness);
            }
         }
         else
         {
            if(this.arrowDirection == HelperArrowDirection.VERTICAL)
            {
               this.arrowTarget.x = size.x - this.arrowShift;
               this.arrowP1.x = this.arrowTarget.x;
               this.arrowP2.x = this.arrowP1.x - this.arrowWidth;
               this.outlineArrowTarget.x = this.arrowTarget.x + this.lineThickness;
               this.outlineArrowP1.x = this.outlineArrowTarget.x;
               this.outlineArrowP2.x = this.arrowTarget.x - this.arrowWidth - this.lineThickness;
            }
            else
            {
               this.arrowTarget.x = size.x + this._arrowLehgth;
               this.arrowP1.x = size.x;
               this.arrowP2.x = size.x;
               this.outlineArrowTarget.x = size.x + tga * (this.arrowWidth + this.lineThickness * 2);
               this.outlineArrowP1.x = size.x;
               this.outlineArrowP2.x = size.x;
            }
            if(this._arrowAlign & HelperAlign.TOP_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x,this.arrowP1.y - this.lineThickness,this.arrowP2.x - this.arrowP1.x,this.lineThickness);
            }
            else if(this._arrowAlign & HelperAlign.MIDDLE_MASK)
            {
               this.outline.graphics.drawRect(this.arrowP1.x,this.arrowP1.y,this.lineThickness,this.arrowP2.y - this.arrowP1.y);
            }
            else
            {
               this.outline.graphics.drawRect(this.arrowP1.x,this.arrowP1.y,this.arrowP2.x - this.arrowP1.x,this.lineThickness);
            }
         }
         this.back.graphics.moveTo(this.arrowTarget.x,this.arrowTarget.y);
         this.back.graphics.lineTo(this.arrowP1.x,this.arrowP1.y);
         this.back.graphics.lineTo(this.arrowP2.x,this.arrowP2.y);
         this.back.graphics.lineTo(this.arrowTarget.x,this.arrowTarget.y);
         this.outline.graphics.beginFill(this.lineColor,this.lineAlpha);
         this.outline.graphics.moveTo(this.outlineArrowTarget.x,this.outlineArrowTarget.y);
         this.outline.graphics.lineTo(this.outlineArrowP1.x,this.outlineArrowP1.y);
         this.outline.graphics.lineTo(this.outlineArrowP2.x,this.outlineArrowP2.y);
         this.outline.graphics.lineTo(this.outlineArrowTarget.x,this.outlineArrowTarget.y);
         this.outline.graphics.moveTo(this.arrowTarget.x,this.arrowTarget.y);
         this.outline.graphics.lineTo(this.arrowP1.x,this.arrowP1.y);
         this.outline.graphics.lineTo(this.arrowP2.x,this.arrowP2.y);
         this.outline.graphics.lineTo(this.arrowTarget.x,this.arrowTarget.y);
         var stageQuality:String = stage.quality;
         stage.quality = StageQuality.HIGH;
         var matrix:Matrix = new Matrix();
         if(this.outlineArrowTarget.x < 0)
         {
            matrix.tx = -Math.round(this.outlineArrowTarget.x);
            this.bmp.x = Math.round(this.outlineArrowTarget.x);
         }
         else
         {
            matrix.tx = this.lineThickness;
            this.bmp.x = -this.lineThickness;
         }
         if(this.outlineArrowTarget.y < 0)
         {
            matrix.ty = -Math.round(this.outlineArrowTarget.y);
            this.bmp.y = Math.round(this.outlineArrowTarget.y);
         }
         else
         {
            matrix.ty = this.lineThickness;
            this.bmp.y = -this.lineThickness;
         }
         this.bmp.bitmapData = new BitmapData(Math.round(this.outline.width),Math.round(this.outline.height),true,0);
         this.bmp.bitmapData.draw(this.backContainer,matrix,new ColorTransform(),BlendMode.NORMAL,null,true);
         stage.quality = stageQuality;
         this.descriptionLabel.width = size.x - this.margin * 2;
      }
      
      override public function align(stageWidth:int, stageHeight:int) : void
      {
         this.targetPoint = targetPoint;
      }
      
      public function get arrowLehgth() : int
      {
         return this._arrowLehgth;
      }
      
      public function set arrowLehgth(value:int) : void
      {
         this._arrowLehgth = value;
      }
      
      public function get arrowAlign() : int
      {
         return this._arrowAlign;
      }
      
      public function set arrowAlign(value:int) : void
      {
         if(value == HelperAlign.MIDDLE_CENTER)
         {
            this._arrowAlign = HelperAlign.BOTTOM_LEFT;
         }
         else
         {
            this._arrowAlign = value;
         }
         if(this._arrowAlign & HelperAlign.TOP_MASK || this._arrowAlign & HelperAlign.BOTTOM_MASK)
         {
            this.arrowDirection = HelperArrowDirection.VERTICAL;
         }
         else
         {
            this.arrowDirection = HelperArrowDirection.HORIZONTAL;
         }
      }
      
      public function set text(value:String) : void
      {
         this.descriptionLabel.htmlText = value;
         _size.x = Math.round(this.descriptionLabel.textWidth + this.margin * 2);
         _size.y = Math.round(this.descriptionLabel.textHeight + this.margin * 2) - 3;
      }
      
      override public function set targetPoint(p:Point) : void
      {
         var localCoords:Point = null;
         super.targetPoint = p;
         if(parent != null)
         {
            localCoords = parent.globalToLocal(p);
            this.x = Math.round(localCoords.x - this.outlineArrowTarget.x);
            this.y = Math.round(localCoords.y - this.outlineArrowTarget.y);
         }
      }
   }
}
