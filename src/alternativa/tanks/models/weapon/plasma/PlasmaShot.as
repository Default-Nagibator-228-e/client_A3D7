package alternativa.tanks.models.weapon.plasma
{
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.physics.Body;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.IRayCollisionPredicate;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.engine3d.AnimatedSprite3D;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.sfx.shoot.plasma.PlasmaSFXData;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.sfx.IGraphicEffect;
   
   public class PlasmaShot implements IGraphicEffect, IRayCollisionPredicate
   {
      
      public static const SIZE:Number = 250;
      
      private static const INITIAL_POOL_SIZE:int = 20;
      
      private static var pool:Vector.<PlasmaShot> = new Vector.<PlasmaShot>(INITIAL_POOL_SIZE);
      
      private static var poolIndex:int = -1;
      
      private static const ANIMATION_FPS:Number = 30;
      
      private static const NUM_RADIAL_RAYS:int = 8;
      
      private static const RADIAL_ANGLE_STEP:Number = 2 * Math.PI / NUM_RADIAL_RAYS;
      
      private static var _rotationMatrix:Matrix3 = new Matrix3();
      
      private static var _rayOrigin:Vector3 = new Vector3();
      
      private static var _rayDirection:Vector3 = new Vector3();
      
      private static var _rayHit:RayIntersection = new RayIntersection();
       
      
      public var shotId:int;
      
      public var active:Boolean;
      
      public var shooterData:TankData;
      
      public var totalDistance:Number = 0;
      
      private var radialPoints:Vector.<Vector3>;
      
      private var currPosition:Vector3;
      
      private var direction:Vector3;
      
      private var listener:IPlasmaShotListener;
      
      private var plasmaData:PlasmaGunData;
      
      private var collisionDetector:ICollisionDetector;
      
      private var sprite:AnimatedSprite3D;
      
      private var numFrames:int;
      
      private var currentFrame:Number;
      
      private var weakeningModel:IWeaponWeakeningModel;
      
      private var sfxData:PlasmaSFXData;
	  
	  private var light:OmniLight;
      
      public function PlasmaShot()
      {
         this.currPosition = new Vector3();
         this.direction = new Vector3();
         super();
         this.radialPoints = new Vector.<Vector3>(NUM_RADIAL_RAYS);
         for(var i:int = 0; i < NUM_RADIAL_RAYS; i++)
         {
            this.radialPoints[i] = new Vector3();
         }
         this.sprite = new AnimatedSprite3D(SIZE, SIZE);
		 this.light = new OmniLight(0x0000ff, 150, 300);
      }
      
      public static function getShot() : PlasmaShot
      {
         if(poolIndex == -1)
         {
            return new PlasmaShot();
         }
         var shot:PlasmaShot = pool[poolIndex];
         var _loc2_:* = poolIndex--;
         pool[_loc2_] = null;
         return shot;
      }
      
      public function init(shotId:int, active:Boolean, plasmaData:PlasmaGunData, startPosition:Vector3, direction:Vector3, shooterData:TankData, listener:IPlasmaShotListener, sfxData:PlasmaSFXData, collisionDetector:ICollisionDetector, weakeningModel:IWeaponWeakeningModel) : void
      {
         this.shotId = shotId;
         this.active = active;
         this.plasmaData = plasmaData;
         this.currPosition.vCopy(startPosition);
         this.direction.vCopy(direction);
         this.shooterData = shooterData;
         this.listener = listener;
         this.collisionDetector = collisionDetector;
         this.weakeningModel = weakeningModel;
         this.sfxData = sfxData;
         var animationData:TextureAnimation = sfxData.explosionData;
		 this.light.color = animationData.material[8].texture.getPixel32(int(animationData.material[8].texture.width / 2), int(animationData.material[8].texture.height / 2));
         var animationData:TextureAnimation = sfxData.shotData;
		 this.sprite.setAnimationData(animationData);
         this.sprite.setFrameIndex(this.sprite.getNumFrames() * Math.random());
         this.sprite.rotation = 6.28 * Math.random();
         this.sprite.colorTransform = sfxData.colorTransform;
         this.totalDistance = 0;
         this.initRadialPoints(startPosition,direction,plasmaData.shotRadius);
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         container.addChild(this.sprite);
		 container.addChild(this.light);
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         var i:int = 0;
         var p:Vector3 = null;
         if(this.totalDistance > this.plasmaData.shotRange)
         {
            this.listener.plasmaShotDissolved(this);
            return false;
         }
         var dt:Number = 0.001 * millis;
         var distance:Number = this.plasmaData.shotSpeed * dt;
         this.totalDistance = this.totalDistance + distance;
         this.sprite.update(millis);
         if(this.active)
         {
            if(this.collisionDetector.intersectRay(this.currPosition,this.direction,CollisionGroup.WEAPON,distance,this,_rayHit))
            {
               if(_rayHit.primitive != null)
               {
                  this.listener.plasmaShotHit(this,_rayHit.pos,this.direction,_rayHit.primitive.body);
               }
               return false;
            }
            for(i = 0; i < NUM_RADIAL_RAYS; i++)
            {
               p = this.radialPoints[i];
               if(this.collisionDetector.intersectRay(p,this.direction,CollisionGroup.WEAPON,distance,this,_rayHit))
               {
                  if(_rayHit.primitive.body != null)
                  {
                     this.listener.plasmaShotHit(this,_rayHit.pos,this.direction,_rayHit.primitive.body);
                     return false;
                  }
               }
            }
            _rayOrigin.x = this.currPosition.x;
            _rayOrigin.y = this.currPosition.y;
            _rayOrigin.z = this.currPosition.z + this.plasmaData.shotRadius;
            _rayDirection.z = -1;
            if(this.collisionDetector.intersectRayWithStatic(_rayOrigin,_rayDirection,CollisionGroup.STATIC,this.plasmaData.shotRadius,null,_rayHit))
            {
               this.listener.plasmaShotHit(this,this.currPosition,this.direction,null);
               return false;
            }
         }
         var dx:Number = distance * this.direction.x;
         var dy:Number = distance * this.direction.y;
         var dz:Number = distance * this.direction.z;
         this.currPosition.x = this.currPosition.x + dx;
         this.currPosition.y = this.currPosition.y + dy;
         this.currPosition.z = this.currPosition.z + dz;
         for(i = 0; i < NUM_RADIAL_RAYS; i++)
         {
            p = this.radialPoints[i];
            p.x = p.x + dx;
            p.y = p.y + dy;
            p.z = p.z + dz;
         }
         var size:Number = SIZE * this.weakeningModel.getImpactCoeff(this.shooterData.turret,0.01 * this.totalDistance);
         this.sprite.width = size;
         this.sprite.height = size;
         this.sprite.x = this.currPosition.x;
         this.sprite.y = this.currPosition.y;
         this.sprite.z = this.currPosition.z;
         this.sprite.rotation = this.sprite.rotation - 0.003 * millis;
		 this.light.x = sprite.x;
		 this.light.y = sprite.y;
		 this.light.z = sprite.z;
         return true;
      }
      
      public function destroy() : void
      {
         this.sprite.parent.removeChild(this.sprite);
		 this.light.parent.removeChild(this.light);
         this.plasmaData = null;
         this.listener = null;
         this.collisionDetector = null;
         this.shooterData = null;
         this.weakeningModel = null;
         this.sfxData = null;
         this.sprite.material = null;
         this.sprite.colorTransform = null;
         var _loc1_:* = ++poolIndex;
         pool[_loc1_] = this;
      }
      
      public function kill() : void
      {
         this.totalDistance = this.plasmaData.shotRange + 1;
      }
      
      public function considerBody(body:Body) : Boolean
      {
         return this.shooterData.tank != body;
      }
      
      public function toString() : String
      {
         return "[PlasmaCharge tankId=" + this.shooterData.user.id + ", chargeId=" + this.shotId + "]";
      }
      
      private function initRadialPoints(centerPoint:Vector3, shotDirection:Vector3, shotRadius:Number) : void
      {
         var axis:int = 0;
         var min:Number = 1.0e308;
         var d:Number = shotDirection.x < 0?Number(-shotDirection.x):Number(shotDirection.x);
         if(d < min)
         {
            min = d;
            axis = 0;
         }
         d = shotDirection.y < 0?Number(-shotDirection.y):Number(shotDirection.y);
         if(d < min)
         {
            min = d;
            axis = 1;
         }
         d = shotDirection.z < 0?Number(-shotDirection.z):Number(shotDirection.z);
         if(d < min)
         {
            axis = 2;
         }
         var v:Vector3 = new Vector3();
         switch(axis)
         {
            case 0:
               v.x = 0;
               v.y = shotDirection.z;
               v.z = -shotDirection.y;
               break;
            case 1:
               v.x = -shotDirection.z;
               v.y = 0;
               v.z = shotDirection.x;
               break;
            case 2:
               v.x = shotDirection.y;
               v.y = -shotDirection.x;
               v.z = 0;
         }
         v.vNormalize().vScale(shotRadius);
         _rotationMatrix.fromAxisAngle(shotDirection,RADIAL_ANGLE_STEP);
         Vector3(this.radialPoints[0]).vCopy(centerPoint).vAdd(v);
         for(var i:int = 1; i < NUM_RADIAL_RAYS; i++)
         {
            v.vTransformBy3(_rotationMatrix);
            Vector3(this.radialPoints[i]).vCopy(centerPoint).vAdd(v);
         }
      }
   }
}
