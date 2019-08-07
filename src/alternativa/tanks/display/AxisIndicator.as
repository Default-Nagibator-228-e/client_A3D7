package alternativa.tanks.display
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import flash.display.Shape;
   
   use namespace alternativa3d;
   
   public class AxisIndicator extends Shape
   {
       
      
      private var _size:int;
      
      private var axis1:Vector.<Number>;
	  
      private var bitOffset:int = 0;
      
      public function AxisIndicator(size:int)
      {
         this.axis1 = Vector.<Number>([0,0,0,0,0,0]);
         super();
         this._size = size;
      }
      
      public function update(camera:Camera3D) : void
      {
         var kx:Number = NaN;
         var ky:Number = NaN;
         graphics.clear();
         camera.composeMatrix();
         this.axis1[0] = camera.ma;
         this.axis1[1] = camera.mb;
         this.axis1[2] = camera.me;
         this.axis1[3] = camera.mf;
         this.axis1[4] = camera.mi;
         this.axis1[5] = camera.mj;
		 bitOffset = 16;
         for(var i:int = 0; i < 6; i += 2, bitOffset -= 8)
         {
            kx = this.axis1[i] + 1;
            ky = this.axis1[int(i + 1)] + 1;
            graphics.lineStyle(0,255 << bitOffset);
            graphics.moveTo(this._size,this._size);
            graphics.lineTo(this._size * kx,this._size * ky);
         }
      }
      
      public function get size() : int
      {
         return this._size;
      }
   }
}
