package utils.tweener.easing
{
   public class Expo
   {
       
      
      public function Expo()
      {
         super();
      }
      
      public static function easeIn(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 == 0?Number(param2):Number(param3 * Math.pow(2,10 * (param1 / param4 - 1)) + param2 - param3 * 0.001);
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 == param4?Number(param2 + param3):Number(param3 * (-Math.pow(2,-10 * param1 / param4) + 1) + param2);
      }
      
      public static function easeInOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if(param1 == 0)
         {
            return param2;
         }
         if(param1 == param4)
         {
            return param2 + param3;
         }
         if((param1 = param1 / (param4 * 0.5)) < 1)
         {
            return param3 * 0.5 * Math.pow(2,10 * (param1 - 1)) + param2;
         }
         return param3 * 0.5 * (-Math.pow(2,-10 * --param1) + 2) + param2;
      }
   }
}
