package alternativa.tanks.camera
{
   public class CameraFovCalculator
   {
      
      private static const NARROW_SCREEN:Number = 12;
      
      private static const WIDE_SCREEN:Number = 16;
      
      private static const DIVIDER:Number = 9;
      
      private static const DEFAULT_FOV:Number = Math.PI / 2;
       
      
      public function CameraFovCalculator()
      {
         super();
      }
      
      public static function getCameraFov(param1:Number, param2:Number) : Number
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc3_:Number = param2 / DIVIDER;
         var _loc4_:Number = param1 / _loc3_;
         if(_loc4_ <= NARROW_SCREEN)
         {
            return DEFAULT_FOV;
         }
         _loc5_ = _loc4_ - (WIDE_SCREEN - NARROW_SCREEN);
         if(_loc5_ < NARROW_SCREEN)
         {
            _loc5_ = NARROW_SCREEN;
         }
         _loc6_ = _loc5_ * _loc3_;
         _loc7_ = Math.sqrt(_loc6_ * _loc6_ + param2 * param2) * 0.5 / Math.tan(DEFAULT_FOV * 0.5);
         return Math.atan(Math.sqrt(param1 * param1 + param2 * param2) * 0.5 / _loc7_) * 2;
      }
   }
}
