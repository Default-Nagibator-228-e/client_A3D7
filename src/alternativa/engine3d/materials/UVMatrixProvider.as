package alternativa.engine3d.materials
{
   import flash.geom.Matrix;
   
   public class UVMatrixProvider
   {
       
      
      private var matrixValues:Vector.<Number>;
      
      private var matrix:Matrix;
      
      public function UVMatrixProvider()
      {
         this.matrixValues = new Vector.<Number>(8);
         this.matrix = new Matrix();
         super();
      }
      
      public function getMatrix() : Matrix
      {
         return this.matrix;
      }
      
      public function getValues() : Vector.<Number>
      {
         var _loc1_:Matrix = this.getMatrix();
         this.matrixValues[0] = _loc1_.a;
         this.matrixValues[1] = _loc1_.b;
         this.matrixValues[2] = _loc1_.tx;
         this.matrixValues[3] = 0;
         this.matrixValues[4] = _loc1_.c;
         this.matrixValues[5] = _loc1_.d;
         this.matrixValues[6] = _loc1_.ty;
         this.matrixValues[7] = 0;
         return this.matrixValues;
      }
   }
}
