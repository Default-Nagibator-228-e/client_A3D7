package alternativa.tanks.camera
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.console.ConsoleVarInt;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.utils.MathUtils;
   import alternativa.tanks.vehicles.tanks.Tank;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   
   public class FollowCameraController extends CameraControllerBase implements IFollowCameraController
   {
      
      public static var effectsEnabled:Boolean = true;
      
      public static var maxPositionError:Number = 10;
      
      public static var maxAngleError:Number = Math.PI / 180;
      
      public static var camSpeedThreshold:Number = 10;
      
      private static var fixedPitch:ConsoleVarFloat = new ConsoleVarFloat("cam_fixedpitch",10 * Math.PI / 180,-1,1);
      
      private static var noPitchCorrection:ConsoleVarInt = new ConsoleVarInt("cam_nopitchcorrection",1,0,1);
      
      private static var pitchCorrectionCoeff:ConsoleVarFloat = new ConsoleVarFloat("cam_pitchcorrectioncoeff",1,0,10);
      
      private static var reboundDelay:ConsoleVarInt = new ConsoleVarInt("cam_rebound",1000,0,2000);
      
      private static var elevationAngles:Vector.<Number> = new Vector.<Number>(1,true);
      
      private static var rotationMatrix:Matrix3 = new Matrix3();
      
      private static var axis:Vector3 = new Vector3();
      
      private static var rayDirection:Vector3 = new Vector3();
      
      private static const MIN_CAMERA_ANGLE:Number = 5 * Math.PI / 180;
      
      private static const KEY_CAMERA_UP:uint = Keyboard.Q;
      
      private static const ALT_KEY_CAMERA_UP:uint = 221;
      
      private static const KEY_CAMERA_DOWN:uint = Keyboard.E;
      
      private static const ALT_KEY_CAMERA_DOWN:uint = 219;
      
      private static const HEIGHT_CHANGE_STEP:Number = 50;
      
      private static const MIN_HEIGHT:Number = 150;
      
      private static const MAX_HEIGHT:Number = 3100;
      
      private static const MIN_DISTANCE:Number = 300;
      
      private static const COLLISION_OFFSET:Number = 50;
      
      private static var currentPosition:Vector3 = new Vector3();
      
      private static var currentRotation:Vector3 = new Vector3();
      
      private static var vin:Vector.<Number> = Vector.<Number>([0,0,0,0,1,0]);
      
      private static var vout:Vector.<Number> = Vector.<Number>([0,0,0,0,1,0]);
      
      private static var rayOrigin:Vector3 = new Vector3();
      
      private static var flatDirection:Vector3 = new Vector3();
      
      private static var positionDelta:Vector3 = new Vector3();
      
      private static var rayIntersection:RayIntersection = new RayIntersection();
       
      
      private var stage:Stage;
      
      private var collisionDetector:ICollisionDetector;
      
      private var cameraCollisionGroup:int;
      
      public var _cameraHeight:Number = 0;
      
      private var cameraDistance:Number = 0;
      
      private var locked:Boolean;
      
      private var keyUpPressed:Boolean;
      
      private var keyDownPressed:Boolean;
      
      private var active:Boolean;
      
      private var _tank:Tank;
      
      private var position:Vector3;
      
      private var rotation:Vector3;
      
      private var targetPosition:Vector3;
      
      private var targetDirection:Vector3;
      
      private var linearSpeed:Number = 0;
      
      private var pitchSpeed:Number = 0;
      
      private var yawSpeed:Number = 0;
      
      private var modifiers:Vector.<ICameraStateModifier>;
      
      private var lastCollisionDistance:Number = 10000000;
      
      private var lastMinDistanceTime:int;
      
      private var cameraPositionData:CameraPositionData;
      
      private var baseElevation:Number;
      
      private var extraPitchFromTarget:Number = 0;
      
      public function FollowCameraController(stage:Stage, collisionDetector:ICollisionDetector, camera:GameCamera, cameraCollisionGroup:int)
      {
         this.position = new Vector3();
         this.rotation = new Vector3();
         this.targetPosition = new Vector3();
         this.targetDirection = new Vector3();
         this.modifiers = new Vector.<ICameraStateModifier>();
         this.cameraPositionData = new CameraPositionData();
         super(camera);
         if(stage == null)
         {
            throw new ArgumentError("Parameter stage cannot be null");
         }
         if(collisionDetector == null)
         {
            throw new ArgumentError("Parameter collisionDetector cannot be null");
         }
         this.stage = stage;
         this.collisionDetector = collisionDetector;
         this.cameraCollisionGroup = cameraCollisionGroup;
         this.cameraHeight = 600;
      }
      
      public function setDefaultSettings() : void
      {
         noPitchCorrection.value = 1;
      }
      
      public function setAlternateSettings() : void
      {
         noPitchCorrection.value = 0;
      }
      
      public function addModifier(modifier:ICameraStateModifier) : void
      {
         if(!effectsEnabled || this.modifiers.indexOf(modifier) > -1)
         {
            return;
         }
         this.modifiers.push(modifier);
         modifier.onAddedToController(this);
      }
      
      public function get tank() : Tank
      {
         return this._tank;
      }
      
      public function set tank(value:Tank) : void
      {
         this._tank = value;
      }
      
      public function initByTarget(targetPosition:Vector3, targetDirection:Vector3) : void
      {
         this.targetPosition.vCopy(targetPosition);
         this.targetDirection.vCopy(targetDirection);
         this.lastMinDistanceTime = 0;
         this.getCameraPositionData(targetPosition,targetDirection,false,10000,this.cameraPositionData);
         this.position.vCopy(this.cameraPositionData.position);
         this.rotation.x = this.getPitchAngle(this.cameraPositionData) - 0.5 * Math.PI;
         this.rotation.z = Math.atan2(-targetDirection.x,targetDirection.y);
         setPosition(this.position);
         setOrientation(this.rotation);
      }
      
      public function initCameraComponents() : void
      {
         this.position.vCopy(camera.pos);
         this.rotation.vReset(camera.rotationX,camera.rotationY,camera.rotationZ);
      }
      
      public function activate() : void
      {
         if(this.active)
         {
            return;
         }
         this.active = true;
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      public function deactivate() : void
      {
         if(!this.active)
         {
            return;
         }
         this.active = false;
         this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
         this.keyUpPressed = false;
         this.keyDownPressed = false;
      }
      
      public function update(time:int, timeDelta:int) : void
      {
         var modifier:ICameraStateModifier = null;
         if(this._tank == null)
         {
            return;
         }
         var dt:Number = timeDelta * 0.001;
         if(dt > 0.1)
         {
            dt = 0.1;
         }
         this.updateHeight();
         if(!this.locked)
         {
            this.updateTargetState();
         }
         this.getCameraPositionData(this.targetPosition,this.targetDirection,true,dt,this.cameraPositionData);
         positionDelta.vDiff(this.cameraPositionData.position,this.position);
         var positionError:Number = positionDelta.vLength();
         if(positionError > maxPositionError)
         {
            this.linearSpeed = this.getLinearSpeed(positionError - maxPositionError);
         }
         var distance:Number = this.linearSpeed * dt;
         if(distance > positionError)
         {
            distance = positionError;
         }
         positionDelta.vNormalize().vScale(distance);
         var targetPitchAngle:Number = this.getPitchAngle(this.cameraPositionData);
         var targetYawAngle:Number = Math.atan2(-this.targetDirection.x,this.targetDirection.y);
         var currentPitchAngle:Number = MathUtils.clampAngle(this.rotation.x + 0.5 * Math.PI);
         var currentYawAngle:Number = MathUtils.clampAngle(this.rotation.z);
         var pitchError:Number = MathUtils.clampAngleFast(targetPitchAngle - currentPitchAngle);
         this.pitchSpeed = this.getAngularSpeed(pitchError,this.pitchSpeed);
         var deltaPitch:Number = this.pitchSpeed * dt;
         if(pitchError > 0 && deltaPitch > pitchError || pitchError < 0 && deltaPitch < pitchError)
         {
            deltaPitch = pitchError;
         }
         var yawError:Number = MathUtils.clampAngleFast(targetYawAngle - currentYawAngle);
         this.yawSpeed = this.getAngularSpeed(yawError,this.yawSpeed);
         var deltaYaw:Number = this.yawSpeed * dt;
         if(yawError > 0 && deltaYaw > yawError || yawError < 0 && deltaYaw < yawError)
         {
            deltaYaw = yawError;
         }
         this.linearSpeed = this.snap(this.linearSpeed,0,camSpeedThreshold);
         this.pitchSpeed = this.snap(this.pitchSpeed,0,camSpeedThreshold);
         this.yawSpeed = this.snap(this.yawSpeed,0,camSpeedThreshold);
         this.position.vAdd(positionDelta);
         this.rotation.x = this.rotation.x + deltaPitch;
         this.rotation.z = this.rotation.z + deltaYaw;
         currentPosition.vCopy(this.position);
         currentRotation.vCopy(this.rotation);
         for(var i:int = 0; i < this.modifiers.length; i++)
         {
            modifier = this.modifiers[i];
            if(!modifier.update(time,timeDelta,currentPosition,currentRotation))
            {
               modifier.destroy();
               this.modifiers.splice(i,1);
               i--;
            }
         }
         setPosition(currentPosition);
         setOrientation(currentRotation);
      }
      
      public function setLocked(locked:Boolean) : void
      {
         this.locked = locked;
      }
      
      public function get cameraHeight() : Number
      {
         return this._cameraHeight;
      }
      
      public function set cameraHeight(value:Number) : void
      {
         this._cameraHeight = MathUtils.clamp(value,MIN_HEIGHT,MAX_HEIGHT);
         var d:Number = this.getCamDistance(this._cameraHeight);
         this.baseElevation = Math.atan2(this._cameraHeight,d);
         this.cameraDistance = Math.sqrt(this._cameraHeight * this._cameraHeight + d * d);
         this.lastMinDistanceTime = 0;
      }
      
      public function getCameraState(targetPosition:Vector3, targetDirection:Vector3, resultingPosition:Vector3, resultingAngles:Vector3) : void
      {
         this.getCameraPositionData(targetPosition,targetDirection,false,10000,this.cameraPositionData);
         resultingAngles.x = this.getPitchAngle(this.cameraPositionData) - 0.5 * Math.PI;
         resultingAngles.z = Math.atan2(-targetDirection.x,targetDirection.y);
         resultingPosition.vCopy(this.cameraPositionData.position);
      }
      
      private function getCameraPositionData(targetPosition:Vector3, targetDirection:Vector3, useReboundDelay:Boolean, dt:Number, result:CameraPositionData) : void
      {
         var angle:Number = NaN;
         var now:int = 0;
         var delta:Number = NaN;
         var actualElevation:Number = this.baseElevation;
         var xyLength:Number = Math.sqrt(targetDirection.x * targetDirection.x + targetDirection.y * targetDirection.y);
         if(xyLength < 0.00001)
         {
            flatDirection.x = 1;
            flatDirection.y = 0;
         }
         else
         {
            flatDirection.x = targetDirection.x / xyLength;
            flatDirection.y = targetDirection.y / xyLength;
         }
         result.extraPitch = 0;
         result.t = 1;
         var minCollisionDistance:Number = this.cameraDistance;
         rayOrigin.vCopy(targetPosition);
         elevationAngles[0] = actualElevation;
         axis.x = flatDirection.y;
         axis.y = -flatDirection.x;
         flatDirection.vReverse();
         for each(angle in elevationAngles)
         {
            rotationMatrix.fromAxisAngle(axis,-angle);
            rotationMatrix.transformVector(flatDirection,rayDirection);
            minCollisionDistance = this.getCollisionDistance(rayOrigin,rayDirection,this.cameraDistance,minCollisionDistance);
         }
         if(useReboundDelay)
         {
            now = getTimer();
            if(minCollisionDistance <= this.lastCollisionDistance + 0.001)
            {
               this.lastCollisionDistance = minCollisionDistance;
               this.lastMinDistanceTime = now;
            }
            else if(now - this.lastMinDistanceTime < reboundDelay.value)
            {
               minCollisionDistance = this.lastCollisionDistance;
            }
            else
            {
               this.lastCollisionDistance = minCollisionDistance;
            }
         }
         if(minCollisionDistance < this.cameraDistance)
         {
            result.t = minCollisionDistance / this.cameraDistance;
            if(minCollisionDistance < MIN_DISTANCE)
            {
               rayOrigin.vAddScaled(minCollisionDistance,rayDirection);
               delta = MIN_DISTANCE - minCollisionDistance;
               if(this.collisionDetector.intersectRay(rayOrigin,Vector3.Z_AXIS,this.cameraCollisionGroup,delta,null,rayIntersection))
               {
                  delta = rayIntersection.t - 10;
                  if(delta < 0)
                  {
                     delta = 0;
                  }
               }
               result.position.vCopy(rayOrigin).vAddScaled(delta,Vector3.Z_AXIS);
            }
            else
            {
               result.position.vCopy(rayOrigin).vAddScaled(minCollisionDistance,rayDirection);
            }
         }
         else
         {
            result.position.vCopy(rayOrigin).vAddScaled(this.cameraDistance,rayDirection);
         }
      }
      
      private function getCollisionDistance(rayOrigin:Vector3, rayDirection:Vector3, rayLength:Number, minCollisionDistance:Number) : Number
      {
         var distance:Number = NaN;
         if(this.collisionDetector.intersectRay(rayOrigin,rayDirection,this.cameraCollisionGroup,rayLength,null,rayIntersection))
         {
            distance = rayIntersection.t;
            if(distance < COLLISION_OFFSET)
            {
               distance = 0;
            }
            else
            {
               distance = distance - COLLISION_OFFSET;
            }
            if(distance < minCollisionDistance)
            {
               return distance;
            }
         }
         return minCollisionDistance;
      }
      
      private function updateTargetState() : void
      {
         this._tank.skin.turretMesh.matrix.transformVectors(vin,vout);
         this.targetPosition.vReset(vout[0],vout[1],vout[2]);
         this.targetDirection.vReset(vout[3] - this.targetPosition.x,vout[4] - this.targetPosition.y,vout[5] - this.targetPosition.z);
      }
      
      private function onKey(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case KEY_CAMERA_UP:
            case ALT_KEY_CAMERA_UP:
               this.keyUpPressed = e.type == KeyboardEvent.KEY_DOWN;
               break;
            case KEY_CAMERA_DOWN:
            case ALT_KEY_CAMERA_DOWN:
               this.keyDownPressed = e.type == KeyboardEvent.KEY_DOWN;
         }
      }
      
      private function updateHeight() : void
      {
         if(this.keyUpPressed == this.keyDownPressed)
         {
            return;
         }
         var heightChangeDir:int = this.keyUpPressed?int(1):int(-1);
         this.cameraHeight = this._cameraHeight + heightChangeDir * HEIGHT_CHANGE_STEP;
      }
      
      private function getCamDistance(h:Number) : Number
      {
         var d1:Number = 600;
         var d2:Number = 1300;
         var hMin:Number = 200;
         var hMax:Number = 3300;
         var hMid:Number = 0.5 * (hMax + hMin);
         var a:Number = hMid;
         var b:Number = d2;
         var v:Number = hMin - hMid;
         var k:Number = (d2 - d1) / (v * v);
         return -k * (h - a) * (h - a) + b;
      }
      
      private function getLinearSpeed(positionError:Number) : Number
      {
         return 3 * positionError;
      }
      
      private function getAngularSpeed(angleError:Number, currentSpeed:Number) : Number
      {
         var k:Number = 3;
         if(angleError < -maxAngleError)
         {
            return k * (angleError + maxAngleError);
         }
         if(angleError > maxAngleError)
         {
            return k * (angleError - maxAngleError);
         }
         return currentSpeed;
      }
      
      private function snap(value:Number, snapValue:Number, epsilon:Number) : Number
      {
         if(value > snapValue - epsilon && value < snapValue + epsilon)
         {
            return snapValue;
         }
         return value;
      }
      
      private function getPitchAngle(cameraPositionData:CameraPositionData) : Number
      {
         var angle:Number = this.baseElevation - fixedPitch.value;
         if(angle < 0)
         {
            angle = 0;
         }
         var t:Number = cameraPositionData.t;
         if(t >= 1 || angle < MIN_CAMERA_ANGLE || noPitchCorrection.value == 1)
         {
            return cameraPositionData.extraPitch - angle;
         }
         var k:Number = 1.5;
         return cameraPositionData.extraPitch - Math.atan2(t * this._cameraHeight,pitchCorrectionCoeff.value * this._cameraHeight * (1 / Math.tan(angle) - (1 - t) / Math.tan(this.baseElevation)));
      }
      
      private function moveValueTowards(value:Number, targetValue:Number, delta:Number) : Number
      {
         if(value < targetValue)
         {
            value = value + delta;
            return value > targetValue?Number(targetValue):Number(value);
         }
         if(value > targetValue)
         {
            value = value - delta;
            return value < targetValue?Number(targetValue):Number(value);
         }
         return value;
      }
   }
}

import alternativa.math.Vector3;

class CameraPositionData
{
    
   
   public var t:Number;
   
   public var extraPitch:Number;
   
   public var position:Vector3;
   
   function CameraPositionData()
   {
      this.position = new Vector3();
      super();
   }
}
