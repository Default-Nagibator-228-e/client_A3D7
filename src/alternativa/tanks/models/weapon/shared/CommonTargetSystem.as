package alternativa.tanks.models.weapon.shared
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.models.weapon.common.HitInfo;
   import alternativa.tanks.physics.CollisionGroup;
   
   public class CommonTargetSystem
   {
      
      private static const COLLISION_GROUP:int = CollisionGroup.WEAPON;
      
      private static var matrix:Matrix3 = new Matrix3();
      
      private static var rayDir1:Vector3 = new Vector3();
      
      private static var rayDir2:Vector3 = new Vector3();
      
      private static var intersection:RayIntersection = new RayIntersection();
       
      
      private var maxDistance:Number;
      
      public var maxAngleUp:Number;
      
      public var numRaysUp:int;
      
      public var maxAngleDown:Number;
      
      public var numRaysDown:int;
      
      private var collisionDetector:ICollisionDetector;
      
      private var targetEvaluator:ICommonTargetEvaluator;
      
      private var maxPriority:Number;
      
      private var bestTarget:Body;
      
      private var hitDistance:Number;
      
      private var bestDirection:Vector3;
      
      private var normal:Vector3;
      
      private var predicate:GunPredicate;
      
      public function CommonTargetSystem(maxDistance:Number, maxAngleUp:Number, numRaysUp:int, maxAngleDown:Number, numRaysDown:int, collisionDetector:ICollisionDetector, targetEvaluator:ICommonTargetEvaluator)
      {
         this.bestDirection = new Vector3();
         this.normal = new Vector3();
         this.predicate = new GunPredicate();
         super();
         this.maxDistance = maxDistance;
         this.maxAngleUp = maxAngleUp;
         this.numRaysUp = numRaysUp;
         this.maxAngleDown = maxAngleDown;
         this.numRaysDown = numRaysDown;
         this.collisionDetector = collisionDetector;
         this.targetEvaluator = targetEvaluator;
      }
      
      public function getTarget(barrelOrigin:Vector3, gunDirection:Vector3, gunRotationAxis:Vector3, shooterBody:Body, hitInfo:HitInfo) : Boolean
      {
         var body:Body = null;
         this.maxPriority = 0;
         this.hitDistance = this.maxDistance + 1;
         this.bestTarget = null;
         this.predicate.shooter = shooterBody;
         if(this.collisionDetector.intersectRay(barrelOrigin,gunDirection,COLLISION_GROUP,this.maxDistance,this.predicate,intersection))
         {
            this.normal.vCopy(intersection.normal);
            this.bestDirection.vCopy(gunDirection);
            this.hitDistance = intersection.t;
            body = intersection.primitive.body;
            if(body != null)
            {
               this.bestTarget = body;
               this.maxPriority = this.targetEvaluator.getTargetPriority(body,this.hitDistance,0);
            }
         }
         if(this.numRaysUp > 0)
         {
            this.checkSector(barrelOrigin,gunDirection,gunRotationAxis,this.numRaysUp,this.maxAngleUp / this.numRaysUp);
         }
         if(this.numRaysDown > 0)
         {
            this.checkSector(barrelOrigin,gunDirection,gunRotationAxis,this.numRaysDown,-this.maxAngleDown / this.numRaysDown);
         }
         this.predicate.shooter = null;
         if(this.hitDistance <= this.maxDistance)
         {
            hitInfo.distance = this.hitDistance;
            hitInfo.normal.vCopy(this.normal);
            hitInfo.direction.vCopy(this.bestDirection);
            hitInfo.position.vCopy(barrelOrigin).vAddScaled(this.hitDistance,this.bestDirection);
            hitInfo.body = this.bestTarget;
            this.bestTarget = null;
            return true;
         }
         return false;
      }
      
      private function checkSector(barrelOrigin:Vector3, gunDirection:Vector3, barrelRotationAxis:Vector3, raysNum:int, angleStep:Number) : void
      {
         var body:Body = null;
         var targetPriority:Number = NaN;
         matrix.fromAxisAngle(barrelRotationAxis,angleStep);
         if(angleStep < 0)
         {
            angleStep = -angleStep;
         }
         rayDir2.vCopy(gunDirection);
         var angle:Number = 0;
         for(var i:int = 1; i <= raysNum; i++)
         {
            angle = angle + angleStep;
            rayDir1.vCopy(rayDir2);
            matrix.transformVector(rayDir1,rayDir2);
            if(this.collisionDetector.intersectRay(barrelOrigin,rayDir2,COLLISION_GROUP,this.maxDistance,this.predicate,intersection))
            {
               body = intersection.primitive.body;
               if(body != null)
               {
                  targetPriority = this.targetEvaluator.getTargetPriority(body,intersection.t,angle);
                  if(targetPriority > this.maxPriority)
                  {
                     this.maxPriority = targetPriority;
                     this.bestTarget = body;
                     this.bestDirection.vCopy(rayDir2);
                     this.hitDistance = intersection.t;
                  }
               }
            }
         }
      }
   }
}

import alternativa.physics.Body;
import alternativa.physics.collision.IRayCollisionPredicate;

class GunPredicate implements IRayCollisionPredicate
{
    
   
   public var shooter:Body;
   
   function GunPredicate()
   {
      super();
   }
   
   public function considerBody(body:Body) : Boolean
   {
      return this.shooter != body;
   }
}
