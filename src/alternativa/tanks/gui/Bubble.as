package alternativa.tanks.gui
{
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.geom.Matrix;
   
   public class Bubble extends Shape
   {
       
      
      public var startR:Number;
      
      public var r:Number;
      
      public var time:int;
      
      public var lifeTime:int;
      
      public function Bubble(r:Number, lifeTime:int)
      {
         super();
         this.startR = r;
         this.lifeTime = lifeTime;
         this.resize(r);
      }
      
      public function resize(r:Number) : void
      {
         this.r = r;
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(2.1 * r,2.1 * r,0,-r * 1.2,-r * 1.2);
         this.graphics.beginGradientFill(GradientType.RADIAL,new Array(16777215,8353114,13618112),new Array(0.6,0.3,0.4),new Array(0,220,255),matrix);
         this.graphics.drawCircle(0,0,r);
      }
   }
}
