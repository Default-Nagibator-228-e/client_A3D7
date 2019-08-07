package alternativa.physics.constraints
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.altphysics;
   
   use namespace altphysics;
   
   public class MaxDistanceConstraint extends Constraint
   {
       
      
      altphysics var body1:Body;
      
      altphysics var body2:Body;
      
      altphysics var r1:Vector3;
      
      altphysics var r2:Vector3;
      
      altphysics var maxDistance:Number;
      
      altphysics var wr1:Vector3;
      
      altphysics var wr2:Vector3;
      
      private var minClosingVel:Number;
      
      private var velByUnitImpulseN:Number;
      
      private var impulseDirection:Vector3;
      
      public function MaxDistanceConstraint(body1:Body, body2:Body, r1:Vector3, r2:Vector3, maxDistance:Number)
      {
         this.wr1 = new Vector3();
         this.wr2 = new Vector3();
         this.impulseDirection = new Vector3();
         super();
         this.body1 = body1;
         this.body2 = body2;
         this.r1 = r1.vClone();
         this.r2 = r2.vClone();
         this.maxDistance = maxDistance;
      }
      
      override public function preProcess(dt:Number) : void
      {
         var m:Matrix3 = null;
         var p1:Vector3 = null;
         var len:Number = NaN;
         var p2:Vector3 = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         var vx:Number = NaN;
         var vy:Number = NaN;
         var vz:Number = NaN;
         m = this.body1.baseMatrix;
         this.wr1.x = m.a * this.r1.x + m.b * this.r1.y + m.c * this.r1.z;
         this.wr1.y = m.e * this.r1.x + m.f * this.r1.y + m.g * this.r1.z;
         this.wr1.z = m.i * this.r1.x + m.j * this.r1.y + m.k * this.r1.z;
         if(this.body2 != null)
         {
            m = this.body2.baseMatrix;
            this.wr2.x = m.a * this.r2.x + m.b * this.r2.y + m.c * this.r2.z;
            this.wr2.y = m.e * this.r2.x + m.f * this.r2.y + m.g * this.r2.z;
            this.wr2.z = m.i * this.r2.x + m.j * this.r2.y + m.k * this.r2.z;
         }
         else
         {
            this.wr2.x = this.r2.x;
            this.wr2.y = this.r2.y;
            this.wr2.z = this.r2.z;
         }
         p1 = this.body1.state.pos;
         this.impulseDirection.x = this.wr2.x - this.wr1.x - p1.x;
         this.impulseDirection.y = this.wr2.y - this.wr1.y - p1.y;
         this.impulseDirection.z = this.wr2.z - this.wr1.z - p1.z;
         if(this.body2 != null)
         {
            p2 = this.body2.state.pos;
            this.impulseDirection.x = this.impulseDirection.x + p2.x;
            this.impulseDirection.y = this.impulseDirection.y + p2.y;
            this.impulseDirection.z = this.impulseDirection.z + p2.z;
         }
         len = Math.sqrt(this.impulseDirection.x * this.impulseDirection.x + this.impulseDirection.y * this.impulseDirection.y + this.impulseDirection.z * this.impulseDirection.z);
         var delta:Number = len - this.maxDistance;
         if(delta > 0)
         {
            satisfied = false;
            if(len < 0.001)
            {
               this.impulseDirection.x = 1;
            }
            else
            {
               len = 1 / len;
               this.impulseDirection.x = this.impulseDirection.x * len;
               this.impulseDirection.y = this.impulseDirection.y * len;
               this.impulseDirection.z = this.impulseDirection.z * len;
            }
            this.minClosingVel = delta / (world.penResolutionSteps * dt);
            if(this.minClosingVel > world.maxPenResolutionSpeed)
            {
               this.minClosingVel = world.maxPenResolutionSpeed;
            }
            this.velByUnitImpulseN = 0;
            if(this.body1.movable)
            {
               vx = this.wr1.y * this.impulseDirection.z - this.wr1.z * this.impulseDirection.y;
               vy = this.wr1.z * this.impulseDirection.x - this.wr1.x * this.impulseDirection.z;
               vz = this.wr1.x * this.impulseDirection.y - this.wr1.y * this.impulseDirection.x;
               m = this.body1.invInertiaWorld;
               x = m.a * vx + m.b * vy + m.c * vz;
               y = m.e * vx + m.f * vy + m.g * vz;
               z = m.i * vx + m.j * vy + m.k * vz;
               vx = y * this.wr1.z - z * this.wr1.y;
               vy = z * this.wr1.x - x * this.wr1.z;
               vz = x * this.wr1.y - y * this.wr1.x;
               this.velByUnitImpulseN = this.velByUnitImpulseN + (this.body1.invMass + vx * this.impulseDirection.x + vy * this.impulseDirection.y + vz * this.impulseDirection.z);
            }
            if(this.body2 != null && this.body2.movable)
            {
               vx = this.wr2.y * this.impulseDirection.z - this.wr2.z * this.impulseDirection.y;
               vy = this.wr2.z * this.impulseDirection.x - this.wr2.x * this.impulseDirection.z;
               vz = this.wr2.x * this.impulseDirection.y - this.wr2.y * this.impulseDirection.x;
               m = this.body2.invInertiaWorld;
               x = m.a * vx + m.b * vy + m.c * vz;
               y = m.e * vx + m.f * vy + m.g * vz;
               z = m.i * vx + m.j * vy + m.k * vz;
               vx = y * this.wr2.z - z * this.wr2.y;
               vy = z * this.wr2.x - x * this.wr2.z;
               vz = x * this.wr2.y - y * this.wr2.x;
               this.velByUnitImpulseN = this.velByUnitImpulseN + (this.body2.invMass + vx * this.impulseDirection.x + vy * this.impulseDirection.y + vz * this.impulseDirection.z);
            }
         }
         else
         {
            satisfied = true;
         }
      }
      
      override public function apply(dt:Number) : void
      {
         if(satisfied)
         {
            return;
         }
         var vel:Vector3 = this.body1.state.velocity;
         var rot:Vector3 = this.body1.state.rotation;
         var vx:Number = vel.x + rot.y * this.wr1.z - rot.z * this.wr1.y;
         var vy:Number = vel.y + rot.z * this.wr1.x - rot.x * this.wr1.z;
         var vz:Number = vel.z + rot.x * this.wr1.y - rot.y * this.wr1.x;
         if(this.body2 != null)
         {
            vel = this.body2.state.velocity;
            rot = this.body2.state.rotation;
            vx = vx - (vel.x + rot.y * this.wr2.z - rot.z * this.wr2.y);
            vy = vy - (vel.y + rot.z * this.wr2.x - rot.x * this.wr2.z);
            vz = vz - (vel.z + rot.x * this.wr2.y - rot.y * this.wr2.x);
         }
         var closingVel:Number = vx * this.impulseDirection.x + vy * this.impulseDirection.y + vz * this.impulseDirection.z;
         if(closingVel > this.minClosingVel)
         {
            return;
         }
         var impulse:Number = (this.minClosingVel - closingVel) / this.velByUnitImpulseN;
         if(this.body1.movable)
         {
            this.body1.applyRelPosWorldImpulse(this.wr1,this.impulseDirection,impulse);
         }
         if(this.body2 != null && this.body2.movable)
         {
            this.body2.applyRelPosWorldImpulse(this.wr2,this.impulseDirection,-impulse);
         }
      }
   }
}
