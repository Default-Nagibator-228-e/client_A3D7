package alternativa.tanks.models.battlefield.spectator
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.GameCamera;
   
   public class FlightMovement implements MovementMethod
   {
      
      private static const direction:Vector3 = new Vector3();
      
      private static const localDirection:Vector3 = new Vector3();
       
      
      private var conSpeed:ConsoleVarFloat;
      
      private var conAcceleration:ConsoleVarFloat;
      
      public function FlightMovement(param1:ConsoleVarFloat, param2:ConsoleVarFloat)
      {
         super();
         this.conSpeed = param1;
         this.conAcceleration = param2;
      }
      
      public function getDisplacement(param1:UserInput, param2:GameCamera, param3:Number) : Vector3
      {
         localDirection.x = param1.getSideDirection();
         localDirection.y = -param1.getVerticalDirection();
         localDirection.z = param1.getForwardDirection();
         param2.getGlobalVector(localDirection,direction);
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
