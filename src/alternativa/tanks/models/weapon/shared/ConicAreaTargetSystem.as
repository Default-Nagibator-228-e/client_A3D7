package alternativa.tanks.models.weapon.shared
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.physics.CollisionGroup;
   import flash.utils.Dictionary;
   
   public class ConicAreaTargetSystem
   {
      
      private static const collisionGroup:int = CollisionGroup.WEAPON;
      
      private static const origin:Vector3 = new Vector3();
       
      
      private var range:Number;
      
      private var halfConeAngle:Number;
      
      private var numRays:int;
      
      private var numSteps:int;
      
      private var collisionDetector:ICollisionDetector;
      
      private var targetValidator:ITargetValidator;
      
      private var _xAxis:Vector3;
      
      private var matrix:Matrix3;
      
      private var rotationMatrix:Matrix3;
      
      private var intersection:RayIntersection;
      
      private var predicate:GunPredicate;
      
      private var rayDir:Vector3;
      
      private var muzzlePos:Vector3;
      
      private var distanceByTarget:Dictionary;
      
      public function ConicAreaTargetSystem(range:Number, coneAngle:Number, numRays:int, numSteps:int, collisionDetector:ICollisionDetector, targetValidator:ITargetValidator)
      {
         this._xAxis = new Vector3();
         this.matrix = new Matrix3();
         this.rotationMatrix = new Matrix3();
         this.intersection = new RayIntersection();
         this.predicate = new GunPredicate();
         this.rayDir = new Vector3();
         this.muzzlePos = new Vector3();
         super();
         this.range = range;
         this.halfConeAngle = 0.5 * coneAngle;
         this.numRays = numRays;
         this.numSteps = numSteps;
         this.collisionDetector = collisionDetector;
         this.targetValidator = targetValidator;
      }
      
      public function getTargets(shooter:Body, barrelLength:Number, fireOriginOffsetCoeff:Number, barrelOrigin:Vector3, gunDir:Vector3, gunRotationAxis:Vector3, targetBodies:Array, targetDistances:Array) : void
      {
         var key:* = undefined;
         var distance:Number = NaN;
         this.predicate.shooter = shooter;
         this.distanceByTarget = new Dictionary();
         var fireOriginOffset:Number = fireOriginOffsetCoeff * barrelLength;
         var extraDamageAreaRange:Number = barrelLength - fireOriginOffset;
         if(this.collisionDetector.intersectRay(barrelOrigin,gunDir,collisionGroup,barrelLength,this.predicate,this.intersection))
         {
            if(this.intersection.primitive.body == null)
            {
               return;
            }
         }
         this._xAxis.vCopy(gunRotationAxis);
         this.muzzlePos.vCopy(barrelOrigin).vAddScaled(fireOriginOffset,gunDir);
         this.range = this.range + extraDamageAreaRange;
         this.processRay(this.muzzlePos,gunDir,this.range);
         this.rotationMatrix.fromAxisAngle(gunDir,Math.PI / this.numSteps);
         var angleStep:Number = this.halfConeAngle / this.numRays;
         for(var i:int = 0; i < this.numSteps; i++)
         {
            this.processSector(this.muzzlePos,gunDir,this._xAxis,this.numRays,angleStep);
            this.processSector(this.muzzlePos,gunDir,this._xAxis,this.numRays,-angleStep);
            this._xAxis.vTransformBy3(this.rotationMatrix);
         }
         var numTargets:int = 0;
         for(targetBodies[numTargets] in this.distanceByTarget)
         {
            distance = this.distanceByTarget[key] - extraDamageAreaRange;
            if(distance < 0)
            {
               distance = 0;
            }
            targetDistances[numTargets] = distance;
            numTargets++;
         }
         targetBodies.length = numTargets;
         targetDistances.length = numTargets;
         this.predicate.shooter = null;
         this.predicate.clearInvalidTargets();
         this.distanceByTarget = null;
      }
      
      private function processSector(rayOrigin:Vector3, gunDir:Vector3, rotationAxis:Vector3, numRays:int, angleStep:Number) : void
      {
         var rayAngle:Number = 0;
         for(var i:int = 0; i < numRays; i++)
         {
            rayAngle = rayAngle + angleStep;
            this.matrix.fromAxisAngle(rotationAxis,rayAngle);
            this.matrix.transformVector(gunDir,this.rayDir);
            this.processRay(rayOrigin,this.rayDir,this.range);
         }
      }
      
      private function processRay(rayOrigin:Vector3, rayDirection:Vector3, rayLength:Number) : void
      {
         var body:Body = null;
         var d:Number = NaN;
         origin.vCopy(rayOrigin);
         var distance:Number = 0;
         while(rayLength > 0.1)
         {
            if(this.collisionDetector.intersectRay(origin,rayDirection,collisionGroup,rayLength,this.predicate,this.intersection))
            {
               body = this.intersection.primitive.body;
               if(body == null)
               {
                  break;
               }
               origin.vAddScaled(this.intersection.t,rayDirection);
               distance = distance + this.intersection.t;
               if(this.targetValidator.isValidTarget(body))
               {
                  this.predicate.addTarget(body);
                  d = this.distanceByTarget[body];
                  if(isNaN(d) || d > distance)
                  {
                     this.distanceByTarget[body] = distance;
                  }
               }
               else
               {
                  this.predicate.addInvalidTarget(body);
               }
               rayLength = rayLength - this.intersection.t;
               continue;
            }
            break;
         }
         this.predicate.clearTargets();
      }
   }
}

import alternativa.physics.Body;
import alternativa.physics.collision.IRayCollisionPredicate;
import flash.utils.Dictionary;

class GunPredicate implements IRayCollisionPredicate
{
    
   
   public var shooter:Body;
   
   private var targets:Dictionary;
   
   private var invalidTargets:Dictionary;
   
   function GunPredicate()
   {
      this.targets = new Dictionary();
      this.invalidTargets = new Dictionary();
      super();
   }
   
   public function considerBody(body:Body) : Boolean
   {
      return this.shooter != body && this.targets[body] == null && this.invalidTargets[body] == null;
   }
   
   public function addTarget(body:Body) : void
   {
      this.targets[body] = true;
   }
   
   public function addInvalidTarget(body:Body) : void
   {
      this.invalidTargets[body] = true;
   }
   
   public function clearTargets() : void
   {
      var key:* = undefined;
      for(key in this.targets)
      {
         delete this.targets[key];
      }
   }
   
   public function clearInvalidTargets() : void
   {
      var key:* = undefined;
      for(key in this.invalidTargets)
      {
         delete this.invalidTargets[key];
      }
   }
}
