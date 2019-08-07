package alternativa.tanks.display.usertitle
{
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ProgressBar
   {
      
      private static var matrix:Matrix = new Matrix();
       
      
      private var maxValue:int;
      
      private var barWidth:int;
      
      private var shadowTipWidth:int;
      
      private var shadowHeight:int;
      
      private var barOffsetX:int;
      
      private var barOffsetY:int;
      
      private var skin:ProgressBarSkin;
      
      private var barTipWidth:int;
      
      private var barHeight:int;
      
      private var _progress:int;
      
      private var canvas:Shape;
      
      private var x:int;
      
      private var y:int;
      
      private var rect:Rectangle;
      
      public function ProgressBar(x:int, y:int, maxValue:int, barWidth:int, skin:ProgressBarSkin)
      {
         this.canvas = new Shape();
         super();
         this.x = x;
         this.y = y;
         this.maxValue = maxValue;
         this.barWidth = barWidth;
         this.setSkin(skin);
         this.rect = new Rectangle(x,y,2 * this.shadowTipWidth + barWidth,this.shadowHeight);
      }
      
      public function setSkin(skin:ProgressBarSkin) : void
      {
         this.skin = skin;
         this.barTipWidth = skin.leftTipBg.width;
         this.barHeight = skin.leftTipBg.height;
         this.shadowTipWidth = skin.shadowLeftTip.width;
         this.shadowHeight = skin.shadow.height;
         this.barOffsetX = this.shadowTipWidth - this.barTipWidth;
         this.barOffsetY = this.shadowHeight - this.barHeight >> 1;
      }
      
      public function get progress() : int
      {
         return this._progress;
      }
      
      public function set progress(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         else if(value > this.maxValue)
         {
            value = this.maxValue;
         }
         this._progress = value;
      }
      
      public function draw(texture:BitmapData, sp:TextureMaterial) : void
      {
         var bgStart:int = 0;
         var g:Graphics = this.canvas.graphics;
         g.clear();
         g.beginBitmapFill(this.skin.shadowLeftTip);
         g.drawRect(0,0,this.shadowTipWidth,this.shadowHeight);
         g.beginBitmapFill(this.skin.shadow);
         g.drawRect(this.shadowTipWidth,0,this.barWidth - 2 * this.barTipWidth,this.shadowHeight);
         g.beginBitmapFill(this.skin.shadowRightTip);
         g.drawRect(this.shadowTipWidth + this.barWidth - 2 * this.barTipWidth,0,this.shadowTipWidth,this.shadowHeight);
         g.endFill();
         var displayWidth:int = this.barWidth * this._progress / this.maxValue;
         var w:int = this.barWidth - this.barTipWidth;
         if(displayWidth >= this.barTipWidth)
         {
            if(displayWidth == this.barWidth)
            {
               this.drawFullBar(g,this.skin.color,this.skin.leftTipFg,this.skin.rightTipFg);
               bgStart = displayWidth;
            }
            else
            {
               matrix.tx = this.barOffsetX;
               matrix.ty = this.barOffsetY;
               g.beginBitmapFill(this.skin.leftTipFg,matrix,false);
               g.drawRect(this.barOffsetX,this.barOffsetY,this.barTipWidth,this.barHeight);
               if(displayWidth > this.barTipWidth)
               {
                  if(displayWidth > w)
                  {
                     displayWidth = w;
                  }
                  bgStart = displayWidth;
                  g.beginFill(this.skin.color);
                  g.drawRect(this.barOffsetX + this.barTipWidth,this.barOffsetY,displayWidth - this.barTipWidth,this.barHeight);
               }
               else
               {
                  bgStart = this.barTipWidth;
               }
            }
         }
         if(bgStart == 0)
         {
            this.drawFullBar(g,this.skin.bgColor,this.skin.leftTipBg,this.skin.rightTipBg);
         }
         else if(bgStart < this.barWidth)
         {
            g.beginFill(this.skin.bgColor);
            g.drawRect(this.barOffsetX + bgStart,this.barOffsetY,w - bgStart,this.barHeight);
            matrix.tx = this.barOffsetX + w;
            matrix.ty = this.barOffsetY;
            g.beginBitmapFill(this.skin.rightTipBg,matrix,false);
            g.drawRect(this.barOffsetX + w,this.barOffsetY,this.barTipWidth,this.barHeight);
         }
         g.endFill();
         texture.fillRect(this.rect,0);
         matrix.tx = this.x;
         matrix.ty = this.y;
         texture.draw(this.canvas,matrix);
         sp.texture = texture;
      }
      
      private function drawFullBar(g:Graphics, color:uint, leftTip:BitmapData, rightTip:BitmapData) : void
      {
         var w:int = this.barWidth - this.barTipWidth;
         matrix.tx = this.barOffsetX;
         matrix.ty = this.barOffsetY;
         g.beginBitmapFill(leftTip,matrix,false);
         g.drawRect(this.barOffsetX,this.barOffsetY,this.barTipWidth,this.barHeight);
         g.beginFill(color);
         g.drawRect(this.barOffsetX + this.barTipWidth,this.barOffsetY,w - this.barTipWidth,this.barHeight);
         matrix.tx = this.barOffsetX + w;
         g.beginBitmapFill(rightTip,matrix,false);
         g.drawRect(this.barOffsetX + w,this.barOffsetY,this.barTipWidth,this.barHeight);
      }
   }
}
