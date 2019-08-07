package alternativa.tanks.models.battlefield.inventory
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class CooldownIndicator extends Sprite
   {
      
      private static const ANGLE_45:Number = 0.25 * Math.PI;
      
      private static const ANGLE_135:Number = 0.75 * Math.PI;
      
      private static const ANGLE_225:Number = 1.25 * Math.PI;
      
      private static const ANGLE_315:Number = 1.75 * Math.PI;
      
      private static var points:Vector.<Point>;
       
      
      private var size:Number;
      
      private var overlay:Shape;
      
      public function CooldownIndicator(size:int, radius:int)
      {
         super();
         if(points == null)
         {
            this.initPoints();
         }
         this.size = size;
         graphics.beginFill(0,0.7);
         graphics.drawRoundRect(0,0,size,size,radius);
         graphics.endFill();
         addChild(this.overlay = new Shape());
      }
      
      public function draw(percent:Number) : void
      {
         var x:int = 0;
         var y:int = 0;
         var index:int = 0;
         var angle:Number = 2 * Math.PI * percent;
         if(angle < ANGLE_45)
         {
            index = 0;
            x = 0.5 * this.size * (1 + Math.tan(angle));
            y = 0;
         }
         else if(angle < ANGLE_135)
         {
            index = 1;
            x = this.size;
            y = 0.5 * this.size * (1 - 1 / Math.tan(angle));
         }
         else if(angle < ANGLE_225)
         {
            index = 2;
            x = 0.5 * this.size * (1 - Math.tan(angle));
            y = this.size;
         }
         else if(angle < ANGLE_315)
         {
            index = 3;
            x = 0;
            y = 0.5 * this.size * (1 + 1 / Math.tan(angle));
         }
         else
         {
            index = 4;
            x = 0.5 * this.size * (1 + Math.tan(angle));
            y = 0;
         }
         var g:Graphics = this.overlay.graphics;
         g.clear();
         var p:Point = points[5];
         g.beginFill(16711680);
         for(g.moveTo(x,y); index < 6; )
         {
            p = points[index];
            g.lineTo(this.size * p.x,this.size * p.y);
            index++;
         }
         g.lineTo(x,y);
         g.endFill();
         mask = this.overlay;
      }
      
      private function initPoints() : void
      {
         points = new Vector.<Point>(6);
         points[0] = new Point(1,0);
         points[1] = new Point(1,1);
         points[2] = new Point(0,1);
         points[3] = new Point(0,0);
         points[4] = new Point(0.5,0);
         points[5] = new Point(0.5,0.5);
      }
   }
}
