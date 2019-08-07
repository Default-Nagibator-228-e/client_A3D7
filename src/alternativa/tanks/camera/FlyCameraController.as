package alternativa.tanks.camera
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.math.Vector3;
   import alternativa.tanks.utils.MathUtils;
   import flash.geom.Vector3D;
   
   public class FlyCameraController extends CameraControllerBase implements ICameraController
   {
      
      private static const FLY_HEIGHT:Number = 3000;
      
      private static const cameraPosition:Vector3 = new Vector3();
       
      
      private var p1:Vector3;
      
      private var p2:Vector3;
      
      private var p3:Vector3;
      
      private var p4:Vector3;
      
      public var totalDistance:Number;
      
      public var distance:Number;
      
      private var acceleration:Number;
      
      private var speed:Number;
      
      private var angleValuesX:AngleValues;
      
      private var angleValuesZ:AngleValues;
      
      public function FlyCameraController(camera:GameCamera,cont:Object3DContainer=null)
      {
         this.p1 = new Vector3();
         this.p2 = new Vector3();
         this.p3 = new Vector3();
         this.p4 = new Vector3();
         this.angleValuesX = new AngleValues();
         this.angleValuesZ = new AngleValues();
         super(camera,cont);
      }
      
      public function init(targetPosition:Vector3, targetAngles:Vector3, travelTime:int) : void
      {
         this.p1.vCopy(camera.pos);
         this.p2.vCopy(this.p1);
         this.p4.vCopy(targetPosition);
         this.p3.vCopy(this.p4);
         this.p2.z = this.p4.z;//this.p3.z = (this.p1.z > this.p4.z?this.p1.z:this.p4.z) + FLY_HEIGHT;
         var k:Number = 4000000 / (travelTime * travelTime);
         this.angleValuesX.init(MathUtils.clampAngle(camera.rotationX),targetAngles.x,k);
         this.angleValuesZ.init(MathUtils.clampAngle(camera.rotationZ),targetAngles.z,k);
         this.totalDistance = new Vector3().vDiff(this.p4,this.p1).vLength();
         this.acceleration = this.totalDistance * k;
         this.distance = 0;
         this.speed = 0;
      }
	  
	  public function init1(targetPosition:Vector3, travelTime:int) : void
      {
		 this.p1.vCopy(camera.pos);
         this.p2.vCopy(this.p1);
         this.p4.vCopy(targetPosition);
         this.p3.vCopy(this.p4);
         this.p2.z = this.p3.z = (this.p1.z > this.p4.z?this.p1.z:this.p4.z);
         var k:Number = 4000000 / (travelTime * travelTime);
         this.angleValuesX.init(MathUtils.clampAngle(camera.rotationX),0,k);
         this.angleValuesZ.init(MathUtils.clampAngle(camera.rotationZ),0,k);
         this.totalDistance = new Vector3().vDiff(this.p4,this.p1).vLength();
         this.acceleration = this.totalDistance * k;
         this.distance = 0;
         this.speed = 0;
      }
      
      public function update(time:int, deltaMsec:int) : void
      {
         if(this.speed < 0)
         {
            return;
         }
         if(this.distance > 0.5 * this.totalDistance && this.acceleration > 0)
         {
            this.acceleration = -this.acceleration;
            this.angleValuesX.reverseAcceleration();
            this.angleValuesZ.reverseAcceleration();
         }
         var dt:Number = 0.001 * deltaMsec;
         var dv:Number = this.acceleration * dt;
         this.distance = this.distance + (this.speed + 0.5 * dv) * dt;
         this.speed = this.speed + dv;
         if(this.distance > this.totalDistance)
         {
            this.distance = this.totalDistance;
         }
         this.bezier(this.distance / this.totalDistance,this.p1,this.p2,this.p3,this.p4,cameraPosition);
         setPosition(cameraPosition);
		 if (cont == null)
		 {
			rotateBy(this.angleValuesX.update(dt), 0, this.angleValuesZ.update(dt));
		 }
      }
      
      private function bezier(t:Number, p1:Vector3D, p2:Vector3D, p3:Vector3D, p4:Vector3D, result:Vector3) : void
      {
         var t1:Number = 1 - t;
         var a:Number = t1 * t1;
         var b:Number = 3 * t * a;
         a = a * t1;
         var d:Number = t * t;
         var c:Number = 3 * d * t1;
         d = d * t;
         result.x = a * p1.x + b * p2.x + c * p3.x + d * p4.x;
         result.y = a * p1.y + b * p2.y + c * p3.y + d * p4.y;
         result.z = a * p1.z + b * p2.z + c * p3.z + d * p4.z;
      }
   }
}

class AngleValues
{
    
   
   private var currentAngle:Number;
   
   private var totalAngle:Number;
   
   private var angularAcceleration:Number;
   
   private var angularSpeed:Number;
   
   private var angleDirection:Number;
   
   function AngleValues()
   {
      super();
   }
   
   public function init(startAngle:Number, targetAngle:Number, accelerationCoeff:Number) : void
   {
      this.totalAngle = targetAngle - startAngle;
      if(this.totalAngle < 0)
      {
         this.totalAngle = -this.totalAngle;
         this.angleDirection = -1;
      }
      else
      {
         this.angleDirection = 1;
      }
      if(this.totalAngle > Math.PI)
      {
         this.angleDirection = -this.angleDirection;
         this.totalAngle = 2 * Math.PI - this.totalAngle;
      }
      this.angularAcceleration = accelerationCoeff * this.totalAngle;
      this.angularSpeed = 0;
      this.currentAngle = 0;
   }
   
   public function reverseAcceleration() : void
   {
      this.angularAcceleration = -this.angularAcceleration;
   }
   
   public function update(dt:Number) : Number
   {
      var dv:Number = NaN;
      var delta:Number = NaN;
      var da:Number = NaN;
      if(this.currentAngle < this.totalAngle)
      {
         dv = this.angularAcceleration * dt;
         delta = (this.angularSpeed + 0.5 * dv) * dt;
         this.angularSpeed = this.angularSpeed + dv;
         da = this.totalAngle - this.currentAngle;
         if(da < delta)
         {
            delta = da;
         }
         this.currentAngle = this.currentAngle + delta;
         return delta * this.angleDirection;
      }
      return 0;
   }
}
