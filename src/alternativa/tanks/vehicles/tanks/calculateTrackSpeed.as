package alternativa.tanks.vehicles.tanks
{
   public class calculateTrackSpeed
   {
      
      private static const FORWARD:int = 1;
      
      private static const BACK:int = 2;
      
      private static const LEFT:int = 4;
      
      private static const RIGHT:int = 8;
      
      private static const TURRET_LEFT:int = 16;
      
      private static const TURRET_RIGHT:int = 32;
      
      private static const CENTER_TURRET:int = 64;
      
      private static const REVERSE_TURN_BIT:int = 128;
      
      private static const minSpeed:Number = 0.1;
      
      private static const minASpeed:Number = 0.01;
       
      
      private var k_V:Number = 0.012;
      
      private var k_aV:Number = 2.49;
      
      private var speedSmoother:Number = 0.2;
      
      private var trackVelocities:Array;
      
      public function calculateTrackSpeed()
      {
         this.trackVelocities = new Array();
         super();
      }
      
      public function calcTrackSpeed(moduleV:Number, moduleaV:Number, controlbits:int, numContacts:int, numCollision:int, maxSpeed:Number, trackID:Number) : Number
      {
         var desiredSpeedKoef:Number = NaN;
         var linearMovementDirection:int = !(controlbits & FORWARD) && !(controlbits & BACK)?int(int(0)):!(controlbits & FORWARD) && controlbits & BACK?int(int(-1)):int(int(1));
         var angularMovementDirection:int = !(controlbits & LEFT) && !(controlbits & RIGHT)?int(int(0)):!(controlbits & LEFT) && controlbits & RIGHT?int(int(-1)):int(int(1));
         var logicConst:int = controlbits & FORWARD && controlbits & BACK && !(int(int(controlbits & RIGHT)) || int(int(controlbits & LEFT))) || controlbits & RIGHT && controlbits & LEFT && !(int(int(controlbits & FORWARD)) || int(int(controlbits & BACK)))?int(int(0)):int(int(1));
         var tankState:int = numContacts == 0?int(int(-1)):numCollision == 0?int(int(0)):int(int(1));
         var isFreezed:Boolean = moduleV < minSpeed * 50 && moduleaV < minASpeed * 500?Boolean(Boolean(true)):Boolean(Boolean(false));
         var trackSpeed:Number = linearMovementDirection != 0 && angularMovementDirection == 0?Number(Number(linearMovementDirection * this.k_V * moduleV)):linearMovementDirection == 0 && angularMovementDirection != 0?Number(Number(trackID * angularMovementDirection * this.k_aV * moduleaV)):linearMovementDirection != 0 && angularMovementDirection < 0?Number(Number(Math.pow(3 / 4,linearMovementDirection * trackID) * linearMovementDirection * this.k_V * moduleV)):linearMovementDirection != 0 && angularMovementDirection > 0?Number(Number(Math.pow(4 / 3,linearMovementDirection * trackID) * linearMovementDirection * this.k_V * moduleV)):Number(Number(this.trackVelocities[trackID + 1] * (1 - this.speedSmoother)));
         if(tankState != 0 && (linearMovementDirection != 0 || angularMovementDirection != 0) && !(numContacts == 0 && numCollision == 0))
         {
            desiredSpeedKoef = linearMovementDirection != 0 && angularMovementDirection == 0?Number(Number(linearMovementDirection * minSpeed)):linearMovementDirection == 0 && angularMovementDirection != 0?Number(Number(trackID * angularMovementDirection * minASpeed * 10)):linearMovementDirection != 0 && angularMovementDirection < 0?Number(Number(Math.pow(3 / 4,linearMovementDirection * trackID) * linearMovementDirection * minSpeed)):linearMovementDirection != 0 && angularMovementDirection > 0?Number(Number(Math.pow(4 / 3,linearMovementDirection * trackID) * linearMovementDirection * minSpeed)):Number(Number(this.trackVelocities[trackID + 1] * (1 - this.speedSmoother)));
            trackSpeed = desiredSpeedKoef * (tankState == -1?5 * this.k_V * maxSpeed:isFreezed == true?5 * this.k_V * maxSpeed:10 * this.k_V * maxSpeed);
         }
         var actualSpeed:Number = logicConst * (!!isNaN(trackSpeed)?0:trackSpeed);
         if(Math.abs(actualSpeed) - 9 < 0.3)
         {
            actualSpeed = 1.04 * actualSpeed;
         }
         this.trackVelocities[trackID + 1] = actualSpeed;
         return actualSpeed;
      }
   }
}
