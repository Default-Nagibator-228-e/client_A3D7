package controls.resultassets
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class ResultWindowBase extends Sprite
   {
       
      
      protected var tl:BitmapData;
      
      protected var px:BitmapData;
      
      protected var _width:int = 10;
      
      protected var _height:int = 10;
      
      public function ResultWindowBase()
      {
         super();
      }
      
      override public function set width(w:Number) : void
      {
         this._width = Math.floor(w);
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(h:Number) : void
      {
         this._height = Math.floor(h);
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      protected function draw() : void
      {
         var matrix:Matrix = null;
         var g:Graphics = this.graphics;
         g.clear();
         g.beginBitmapFill(this.tl);
         g.drawRect(0,0,4,4);
         g.endFill();
         matrix = new Matrix();
         matrix.rotate(Math.PI * 0.5);
         matrix.translate(this._width - 4,0);
         g.beginBitmapFill(this.tl,matrix);
         g.drawRect(this._width - 4,0,4,4);
         g.endFill();
         matrix = new Matrix();
         matrix.rotate(Math.PI);
         matrix.translate(this._width - 4,this._height - 4);
         g.beginBitmapFill(this.tl,matrix);
         g.drawRect(this._width - 4,this._height - 4,4,4);
         g.endFill();
         matrix = new Matrix();
         matrix.rotate(Math.PI * 1.5);
         matrix.translate(0,this._height - 4);
         g.beginBitmapFill(this.tl,matrix);
         g.drawRect(0,this._height - 4,4,4);
         g.endFill();
         g.beginBitmapFill(this.px);
         g.drawRect(4,0,this._width - 8,this._height);
         g.drawRect(0,4,4,this._height - 8);
         g.drawRect(this._width - 4,4,4,this._height - 8);
         g.endFill();
      }
   }
}
