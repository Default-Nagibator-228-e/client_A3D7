package alternativa.tanks.models.battlefield.spectator
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.GameCamera;
   
   public class WalkMovement implements MovementMethod
   {
      
      private static const direction:Vector3 = new Vector3();
      
      private static const localDirection:Vector3 = new Vector3();
       
      
      private var conSpeed:ConsoleVarFloat;
      
      private var conAcceleration:ConsoleVarFloat;
      
      public function WalkMovement(param1:ConsoleVarFloat, param2:ConsoleVarFloat)
      {
         super();
         this.conSpeed = param1;
         this.conAcceleration = param2;
      }
      
      public function getDisplacement(param1:UserInput, param2:GameCamera, param3:Number) : Vector3
      {
         localDirection.y = param1.getForwardDirection();
         localDirection.x = param1.getSideDirection();
         var _loc4_:Number = Math.cos(param2.rotationZ);
         var _loc5_:Number = Math.sin(param2.rotationZ);
         direction.x = localDirection.x * _loc4_ - localDirection.y * _loc5_;
         direction.y = localDirection.x * _loc5_ + localDirection.y * _loc4_;
         direction.z = param1.getVerticalDirection();
         if(direction.lengthSqr() > 0)
         {
            direction.normalize();
         }
         if(param1.isAcceleratied())
         {
            direction.scale(this.conSpeed.value * this.conAcceleration.value * param3);
         }
         else
         {
            direction.scale(this.conSpeed.value * param3);
         }
         return direction;
      }
   }
}
