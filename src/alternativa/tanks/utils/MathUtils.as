package alternativa.tanks.utils
{
   public class MathUtils
   {
      
      public static const PI2:Number = 2 * Math.PI;
       
      
      public function MathUtils()
      {
         super();
      }
      
      public static function clamp(value:Number, min:Number, max:Number) : Number
      {
         if(value < min)
         {
            return min;
         }
         if(value > max)
         {
            return max;
         }
         return value;
      }
      
      public static function clampAngle(radians:Number) : Number
      {
         radians = radians % PI2;
         if(radians < -Math.PI)
         {
            return PI2 + radians;
         }
         if(radians > Math.PI)
         {
            return radians - PI2;
         }
         return radians;
      }
      
      public static function clampAngleFast(radians:Number) : Number
      {
         if(radians < -Math.PI)
         {
            return PI2 + radians;
         }
         if(radians > Math.PI)
         {
            return radians - PI2;
         }
         return radians;
      }
      
      public static function nearestPowerOf2(param1:int) : int
      {
         return 1 << Math.ceil(Math.log(param1) / Math.LN2);
      }
   }
}
