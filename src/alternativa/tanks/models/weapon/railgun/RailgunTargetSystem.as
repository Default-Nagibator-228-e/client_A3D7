package alternativa.tanks.models.weapon.railgun
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.models.ctf.ICTFModel;
   import alternativa.tanks.models.tank.TankData;
   import flash.utils.Dictionary;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class RailgunTargetSystem
   {
      
      private static const FLAG_CARRIER_BONUS:Number = 10;
      
      private static const DISTANCE_WEIGHT:Number = 0.65;
      
      private static const BASE_DISTANCE:Number = 20000;
      
      private static const MAX_PRIORITY:Number = 1000;
       
      
      private const COLLISION_GROUP:int = 16;
      
      private const MAX_RAY_LENGTH:Number = 1.0E10;
      
      private var collisionDetector:ICollisionDetector;
      
      private var upAngleStep:Number;
      
      private var upRaysNum:int;
      
      private var downAngleStep:Number;
      
      private var downRaysNum:int;
      
      private var weakeningCoeff:Number;
      
      private var multybodyPredicate:MultybodyCollisionPredicate;
      
      private var intersection:RayIntersection;
      
      private var dir:Vector3;
      
      private var rotationMatrix:Matrix3;
      
      private var origin:Vector3;
      
      private var _v:Vector3;
      
      private var bestDirectionIndex:int;
      
      private var maxDirectionPriority:Number;
      
      private var bestEffectivity:Number;
      
      private var currTargets:Array;
      
      private var currHitPoints:Array;
      
      private var ctfModel:ICTFModel;
      
      private var maxAngle:Number;
      
      public function RailgunTargetSystem()
      {
         this.multybodyPredicate = new MultybodyCollisionPredicate();
         this.intersection = new RayIntersection();
         this.dir = new Vector3();
         this.rotationMatrix = new Matrix3();
         this.origin = new Vector3();
         this._v = new Vector3();
         this.currTargets = [];
         this.currHitPoints = [];
         super();
      }
      
      public function setParams(collisionDetector:ICollisionDetector, upAngle:Number, upRaysNum:int, downAngle:Number, downRaysNum:int, weakeningCoeff:Number, ctfModel:ICTFModel) : void
      {
         this.collisionDetector = collisionDetector;
         this.upAngleStep = upAngle / upRaysNum;
         this.upRaysNum = upRaysNum;
         this.downAngleStep = downAngle / downRaysNum;
         this.downRaysNum = downRaysNum;
         this.weakeningCoeff = weakeningCoeff;
         this.ctfModel = ctfModel;
         this.maxAngle = upAngle > downAngle?Number(upAngle):Number(downAngle);
      }
      
      public function getTargets(shooterData:TankData, barrelOrigin:Vector3, baseDir:Vector3, rotationAxis:Vector3, tanks:Dictionary, shotResult:RailgunShotResult) : void
      {
         shotResult.targets.length = 0;
         shotResult.hitPoints.length = 0;
         this.bestEffectivity = 0;
         this.bestDirectionIndex = 10000;
         this.maxDirectionPriority = 0;
         this.checkAllDirections(shooterData,barrelOrigin,baseDir,rotationAxis,tanks,shotResult);
         if(this.bestEffectivity == 0)
         {
            this.collectTargetsAlongRay(shooterData,barrelOrigin,baseDir,tanks,shotResult);
         }
         this.multybodyPredicate.bodies = null;
         this.currHitPoints.length = 0;
         this.currTargets.length = 0;
      }
      
      private function checkAllDirections(shooterData:TankData, barrelOrigin:Vector3, baseDir:Vector3, rotationAxis:Vector3, tanks:Dictionary, shotResult:RailgunShotResult) : void
      {
         var i:int = 0;
         this.checkDirection(barrelOrigin,baseDir,0,0,shooterData,tanks,shotResult);
         this.rotationMatrix.fromAxisAngle(rotationAxis,this.upAngleStep);
         this.dir.vCopy(baseDir);
         var angle:Number = 0;
         for(i = 1; i <= this.upRaysNum; i++)
         {
            angle = angle + this.upAngleStep;
            this.dir.vTransformBy3(this.rotationMatrix);
            this.checkDirection(barrelOrigin,this.dir,angle,i,shooterData,tanks,shotResult);
         }
         this.rotationMatrix.fromAxisAngle(rotationAxis,-this.downAngleStep);
         this.dir.vCopy(baseDir);
         angle = 0;
         for(i = 1; i <= this.downRaysNum; i++)
         {
            angle = angle + this.downAngleStep;
            this.dir.vTransformBy3(this.rotationMatrix);
            this.checkDirection(barrelOrigin,this.dir,angle,i,shooterData,tanks,shotResult);
         }
      }
      
      private function checkDirection(barrelOrigin:Vector3, barrelDir:Vector3, angle:Number, dirIndex:int, shooterData:TankData, tanks:Dictionary, shotResult:RailgunShotResult) : void
      {
         var distance:Number = NaN;
         var directionPriority:Number = NaN;
         var len:int = 0;
         var i:int = 0;
         this.currTargets.length = 0;
         this.currHitPoints.length = 0;
         var effectivity:Number = this.evaluateDirection(barrelOrigin,barrelDir,shooterData,tanks,this.currTargets,this.currHitPoints);
         if(effectivity > 0)
         {
            distance = this._v.vDiff(this.currHitPoints[0],barrelOrigin).vLength();
            directionPriority = this.getDirectionPriority(angle,distance);
            if(effectivity > this.bestEffectivity || effectivity == this.bestEffectivity && directionPriority > this.maxDirectionPriority)
            {
               this.bestEffectivity = effectivity;
               this.bestDirectionIndex = dirIndex;
               this.maxDirectionPriority = directionPriority;
               shotResult.dir.vCopy(barrelDir);
               len = this.currTargets.length;
               for(i = 0; i < len; i++)
               {
                  shotResult.targets[i] = this.currTargets[i];
                  shotResult.hitPoints[i] = this.currHitPoints[i];
               }
               shotResult.targets.length = len;
               if(this.currHitPoints.length > len)
               {
                  shotResult.hitPoints[len] = this.currHitPoints[len];
                  shotResult.hitPoints.length = len + 1;
               }
               else
               {
                  shotResult.hitPoints.length = len;
               }
            }
         }
      }
      
      private function evaluateDirection(barrelOrigin:Vector3, barrelDir:Vector3, shooterData:TankData, tanks:Dictionary, targets:Array, hitPoints:Array) : Number
      {
         var body:Body = null;
         var targetData:TankData = null;
         var targetIsEnemy:Boolean = false;
         this.multybodyPredicate.bodies = new Dictionary();
         this.multybodyPredicate.bodies[shooterData.tank] = true;
         this.origin.vCopy(barrelOrigin);
         var effectivity:Number = 0;
         var effectivityCoeff:Number = 1;
         var firstTarget:Boolean = true;
         while(this.collisionDetector.intersectRay(this.origin,barrelDir,this.COLLISION_GROUP,this.MAX_RAY_LENGTH,this.multybodyPredicate,this.intersection))
         {
            body = this.intersection.primitive.body;
            if(body == null)
            {
               hitPoints.push(this.intersection.pos.vClone());
               break;
            }
            targetData = tanks[body];
            if(targetData != null)
            {
               targetIsEnemy = shooterData.teamType == BattleTeamType.NONE || shooterData.teamType != targetData.teamType;
               if(firstTarget)
               {
                  if(targetData.health > 0 && !targetIsEnemy)
                  {
                     return 0;
                  }
                  firstTarget = false;
               }
               if(targetData.health > 0)
               {
                  if(targetIsEnemy)
                  {
                     if(this.ctfModel != null && this.ctfModel.isFlagCarrier(targetData))
                     {
                        effectivity = effectivity + FLAG_CARRIER_BONUS * effectivityCoeff;
                     }
                     else
                     {
                        effectivity = effectivity + effectivityCoeff;
                     }
                  }
                  else
                  {
                     effectivity = effectivity - effectivityCoeff;
                  }
               }
               effectivityCoeff = effectivityCoeff * this.weakeningCoeff;
               targets.push(targetData);
               hitPoints.push(this.intersection.pos.vClone());
            }
            this.multybodyPredicate.bodies[body] = true;
            this.origin.vCopy(this.intersection.pos);
         }
         return effectivity;
      }
      
      private function collectTargetsAlongRay(shooterData:TankData, barrelOrigin:Vector3, barrelDir:Vector3, tanks:Dictionary, shotResult:RailgunShotResult) : void
      {
         var body:Body = null;
         var targetData:TankData = null;
         shotResult.hitPoints.length = 0;
         shotResult.targets.length = 0;
         shotResult.dir.vCopy(barrelDir);
         this.multybodyPredicate.bodies = new Dictionary();
         this.multybodyPredicate.bodies[shooterData.tank] = true;
         this.origin.vCopy(barrelOrigin);
         while(this.collisionDetector.intersectRay(this.origin,barrelDir,this.COLLISION_GROUP,this.MAX_RAY_LENGTH,this.multybodyPredicate,this.intersection))
         {
            body = this.intersection.primitive.body;
            if(body == null)
            {
               shotResult.hitPoints.push(this.intersection.pos.vClone());
               break;
            }
            targetData = tanks[body];
            if(targetData != null)
            {
               shotResult.targets.push(targetData);
               shotResult.hitPoints.push(this.intersection.pos.vClone());
            }
            this.multybodyPredicate.bodies[body] = true;
            this.origin.vCopy(this.intersection.pos);
         }
      }
      
      private function getDirectionPriority(angle:Number, distance:Number) : Number
      {
         return MAX_PRIORITY - (DISTANCE_WEIGHT * distance / BASE_DISTANCE + (1 - DISTANCE_WEIGHT) * angle / this.maxAngle);
      }
   }
}

import alternativa.physics.Body;
import alternativa.physics.collision.IRayCollisionPredicate;
import flash.utils.Dictionary;

class MultybodyCollisionPredicate implements IRayCollisionPredicate
{
    
   
   public var bodies:Dictionary;
   
   function MultybodyCollisionPredicate()
   {
      this.bodies = new Dictionary();
      super();
   }
   
   public function considerBody(body:Body) : Boolean
   {
      return this.bodies[body] == null;
   }
}
