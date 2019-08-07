package alternativa.tanks.models.weapon.freeze
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.SFXUtils;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   
   public class FreezeGraphicEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const PARTICLE_ANIMATION_FPS:Number = 30;
      
      private static const PARTICLE_START_SCALE:Number = 0.5;
      
      private static const PARTICLE_END_SCALE:Number = 3;
      
      private static const PLANE_LENGTH:int = 350;
      
      private static const PLANE_WIDTH:int = 210;
      
      private static const PARTICLE_SIZE:Number = 150;
      
      private static const MAX_PARTICLES:int = 20;
      
      private static const PARTICLE_ROTATON_SPEED:Number = 3;
      
      private static var matrix:Matrix3 = new Matrix3();
      
      private static var turretMatrix:Matrix4 = new Matrix4();
      
      private static var barrelOrigin:Vector3 = new Vector3();
      
      private static var direction:Vector3 = new Vector3();
      
      private static var turretAxisX:Vector3 = new Vector3();
      
      private static var particlePosition:Vector3 = new Vector3();
      
      private static var globalMuzzlePosition:Vector3 = new Vector3();
      
      private static var intersection:RayIntersection = new RayIntersection();
       
      
      private var shooterData:TankData;
      
      private var range:Number;
      
      private var coneHalfAngleTan:Number;
      
      private var particleSpeed:Number;
      
      private var localMuzzlePosition:Vector3;
      
      private var turret:Object3D;
      
      private var sfxData:FreezeSFXData;
      
      private var collisionDetector:ICollisionDetector;
      
      private var particles:Vector.<Particle>;
      
      private var particleScalePerDistance:Number;
      
      private var numParticleFrames:int;
      
      private var particleEmissionPeriod:Number;
      
      private var time:int;
      
      private var nextEmissionTime:int;
      
      private var numParticles:int;
      
      private var container:Scene3DContainer;
      
      private var dead:Boolean;
      
      private var collisionGroup:int = 16;
      
      private var plane:AnimatedPlane;
      
      public function FreezeGraphicEffect(objectPool:ObjectPool)
      {
         this.localMuzzlePosition = new Vector3();
         this.particles = new Vector.<Particle>(MAX_PARTICLES);
         super(objectPool);
         this.plane = new AnimatedPlane(PLANE_WIDTH,PLANE_LENGTH);
      }
      
      public function init(shooterData:TankData, range:Number, coneAngle:Number, particleSpeed:Number, localMuzzlePosition:Vector3, turret:Object3D, sfxData:FreezeSFXData, collisionDetector:ICollisionDetector) : void
      {
         var ctp:ColorTransformEntry = null;
         var colorTransform:ColorTransform = null;
         this.shooterData = shooterData;
         this.range = range;
         this.coneHalfAngleTan = Math.tan(0.5 * coneAngle);
         this.particleSpeed = particleSpeed;
         this.localMuzzlePosition.vCopy(localMuzzlePosition);
         this.turret = turret;
         this.sfxData = sfxData;
         this.collisionDetector = collisionDetector;
         this.particleScalePerDistance = 2 * (PARTICLE_END_SCALE - PARTICLE_START_SCALE) / range;
         this.numParticleFrames = sfxData.particleMaterials.length;
         this.particleEmissionPeriod = 1000 * range / (MAX_PARTICLES * particleSpeed);
         this.numParticles = 0;
         this.time = this.nextEmissionTime = getTimer();
         this.plane.setMaterials(sfxData.planeMaterials);
         this.plane.currFrame = 0;
         if(sfxData.colorTransformPoints != null)
         {
            ctp = sfxData.colorTransformPoints[0];
            colorTransform = this.plane.colorTransform == null?new ColorTransform():this.plane.colorTransform;
            colorTransform.alphaMultiplier = ctp.alphaMultiplier;
            colorTransform.alphaOffset = ctp.alphaOffset;
            colorTransform.redMultiplier = ctp.redMultiplier;
            colorTransform.redOffset = ctp.redOffset;
            colorTransform.greenMultiplier = ctp.greenMultiplier;
            colorTransform.greenOffset = ctp.greenOffset;
            colorTransform.blueMultiplier = ctp.blueMultiplier;
            colorTransform.blueOffset = ctp.blueOffset;
            this.plane.colorTransform = colorTransform;
         }
         else
         {
            this.plane.colorTransform = null;
         }
         this.dead = false;
      }
      
      public function destroy() : void
      {
         while(this.numParticles > 0)
         {
            this.removeParticle(0);
         }
         this.plane.alternativa3d::removeFromParent();
         this.plane.clearMaterials();
         this.container = null;
         this.shooterData = null;
         this.turret = null;
         this.sfxData = null;
         this.collisionDetector = null;
         storeInPool();
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         var particle:Particle = null;
         var velocity:Vector3 = null;
         var scale:Number = NaN;
         var size:Number = NaN;
         this.calculateParameters();
         var dt:Number = 0.001 * millis;
         if(this.collisionDetector.intersectRayWithStatic(barrelOrigin,direction,CollisionGroup.STATIC,this.localMuzzlePosition.y + PLANE_WIDTH,null,intersection))
         {
            this.plane.visible = false;
         }
         else
         {
            this.plane.visible = true;
            this.plane.update(dt,25);
            SFXUtils.alignObjectPlaneToView(this.plane,globalMuzzlePosition,direction,camera.pos);
         }
         if(!this.dead && this.numParticles < MAX_PARTICLES && this.time >= this.nextEmissionTime)
         {
            this.nextEmissionTime = this.nextEmissionTime + this.particleEmissionPeriod;
            this.addParticle();
         }
         for(var i:int = 0; i < this.numParticles; i++)
         {
            particle = this.particles[i];
            particlePosition.x = particle.x;
            particlePosition.y = particle.y;
            particlePosition.z = particle.z;
            if(particle.distance > this.range || this.collisionDetector.intersectRayWithStatic(particlePosition,particle.velocity,this.collisionGroup,dt,null,intersection))
            {
               this.removeParticle(i--);
            }
            else
            {
               velocity = particle.velocity;
               particle.x = particle.x + velocity.x * dt;
               particle.y = particle.y + velocity.y * dt;
               particle.z = particle.z + velocity.z * dt;
               particle.distance = particle.distance + this.particleSpeed * dt;
               particle.rotation = particle.rotation + PARTICLE_ROTATON_SPEED * dt;
               particle.material = this.sfxData.particleMaterials[int(particle.currFrame)];
               particle.currFrame = particle.currFrame + PARTICLE_ANIMATION_FPS * dt;
               if(particle.currFrame >= this.numParticleFrames)
               {
                  particle.currFrame = 0;
               }
               scale = PARTICLE_START_SCALE + this.particleScalePerDistance * particle.distance;
               if(scale > PARTICLE_END_SCALE)
               {
                  scale = PARTICLE_END_SCALE;
               }
               size = PARTICLE_SIZE * scale;
               particle.width = size;
               particle.height = size;
               particle.updateColorTransofrm(this.range,this.sfxData.colorTransformPoints);
            }
         }
         this.time = this.time + millis;
         return !this.dead || this.numParticles > 0;
      }
      
      public function kill() : void
      {
         if(!this.dead)
         {
            this.dead = true;
            this.plane.alternativa3d::removeFromParent();
         }
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         this.container = container;
         container.addChild(this.plane);
      }
      
      override protected function getClass() : Class
      {
         return FreezeGraphicEffect;
      }
      
      private function calculateParameters() : void
      {
         turretMatrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         turretAxisX.x = turretMatrix.a;
         turretAxisX.y = turretMatrix.e;
         turretAxisX.z = turretMatrix.i;
         direction.x = turretMatrix.b;
         direction.y = turretMatrix.f;
         direction.z = turretMatrix.j;
         turretMatrix.transformVector(this.localMuzzlePosition,globalMuzzlePosition);
         var barrleLength:Number = this.localMuzzlePosition.y;
         barrelOrigin.x = globalMuzzlePosition.x - barrleLength * direction.x;
         barrelOrigin.y = globalMuzzlePosition.y - barrleLength * direction.y;
         barrelOrigin.z = globalMuzzlePosition.z - barrleLength * direction.z;
      }
      
      private function addParticle() : void
      {
         var offset:Number = Math.random() * 50;
         if(!this.plane.visible && intersection.t < this.localMuzzlePosition.y + offset)
         {
            return;
         }
         var particle:Particle = Particle.getParticle();
         particle.rotation = Math.random() * Math.PI * 2;
         particle.currFrame = Math.random() * this.numParticleFrames;
         var angle:Number = 2 * Math.PI * Math.random();
         matrix.fromAxisAngle(direction,angle);
         turretAxisX.vTransformBy3(matrix);
         var d:Number = this.range * this.coneHalfAngleTan * Math.random();
         direction.x = direction.x * this.range + turretAxisX.x * d;
         direction.y = direction.y * this.range + turretAxisX.y * d;
         direction.z = direction.z * this.range + turretAxisX.z * d;
         direction.vNormalize();
         particle.velocity.x = this.particleSpeed * direction.x;
         particle.velocity.y = this.particleSpeed * direction.y;
         particle.velocity.z = this.particleSpeed * direction.z;
         particle.velocity.vAdd(this.shooterData.tank.state.velocity);
         particle.distance = offset;
         particle.x = globalMuzzlePosition.x + offset * direction.x;
         particle.y = globalMuzzlePosition.y + offset * direction.y;
         particle.z = globalMuzzlePosition.z + offset * direction.z;
         var _loc5_:* = this.numParticles++;
         this.particles[_loc5_] = particle;
         this.container.addChild(particle);
      }
      
      private function removeParticle(index:int) : void
      {
         var particle:Particle = this.particles[index];
         this.particles[index] = this.particles[--this.numParticles];
         this.particles[this.numParticles] = null;
         particle.dispose();
      }
   }
}

import alternativa.engine3d.alternativa3d;
import alternativa.engine3d.objects.Sprite3D;
import alternativa.math.Vector3;
import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
import flash.geom.ColorTransform;

class Particle extends Sprite3D
{
   
   private static var INITIAL_POOL_SIZE:int = 20;
   
   private static var pool:Vector.<Particle> = new Vector.<Particle>(INITIAL_POOL_SIZE);
   
   private static var poolIndex:int = -1;
    
   
   public var velocity:Vector3;
   
   public var distance:Number = 0;
   
   public var currFrame:Number;
   
   function Particle()
   {
      this.velocity = new Vector3();
      super(100, 100);
	  this.useDepth = false;
	  this.useLight = false;
	  this.useShadowMap = false;
      colorTransform = new ColorTransform();
   }
   
   public static function getParticle() : Particle
   {
      if(poolIndex == -1)
      {
         return new Particle();
      }
      var particle:Particle = pool[poolIndex];
      var _loc2_:* = poolIndex--;
      pool[_loc2_] = null;
      return particle;
   }
   
   public function dispose() : void
   {
      alternativa3d::removeFromParent();
      material = null;
      pool[++poolIndex] = this;
   }
   
   public function updateColorTransofrm(maxDistance:Number, points:Vector.<ColorTransformEntry>) : void
   {
      var point1:ColorTransformEntry = null;
      var point2:ColorTransformEntry = null;
      var i:int = 0;
      if(points == null)
      {
         return;
      }
      var t:Number = this.distance / maxDistance;
      if(t <= 0)
      {
         point1 = points[0];
         this.copyStructToColorTransform(point1,colorTransform);
      }
      else if(t >= 1)
      {
         point1 = points[points.length - 1];
         this.copyStructToColorTransform(point1,colorTransform);
      }
      else
      {
         i = 1;
         point1 = points[0];
         point2 = points[1];
         while(point2.t < t)
         {
            i++;
            point1 = point2;
            point2 = points[i];
         }
         t = (t - point1.t) / (point2.t - point1.t);
         this.interpolateColorTransform(point1,point2,t,colorTransform);
      }
      alpha = colorTransform.alphaMultiplier;
   }
   
   private function interpolateColorTransform(ct1:ColorTransformEntry, ct2:ColorTransformEntry, t:Number, result:ColorTransform) : void
   {
      result.alphaMultiplier = ct1.alphaMultiplier + t * (ct2.alphaMultiplier - ct1.alphaMultiplier);
      result.alphaOffset = ct1.alphaOffset + t * (ct2.alphaOffset - ct1.alphaOffset);
      result.redMultiplier = ct1.redMultiplier + t * (ct2.redMultiplier - ct1.redMultiplier);
      result.redOffset = ct1.redOffset + t * (ct2.redOffset - ct1.redOffset);
      result.greenMultiplier = ct1.greenMultiplier + t * (ct2.greenMultiplier - ct1.greenMultiplier);
      result.greenOffset = ct1.greenOffset + t * (ct2.greenOffset - ct1.greenOffset);
      result.blueMultiplier = ct1.blueMultiplier + t * (ct2.blueMultiplier - ct1.blueMultiplier);
      result.blueOffset = ct1.blueOffset + t * (ct2.blueOffset - ct1.blueOffset);
   }
   
   private function copyStructToColorTransform(source:ColorTransformEntry, result:ColorTransform) : void
   {
      result.alphaMultiplier = source.alphaMultiplier;
      result.alphaOffset = source.alphaOffset;
      result.redMultiplier = source.redMultiplier;
      result.redOffset = source.redOffset;
      result.greenMultiplier = source.greenMultiplier;
      result.greenOffset = source.greenOffset;
      result.blueMultiplier = source.blueMultiplier;
      result.blueOffset = source.blueOffset;
   }
}

import alternativa.engine3d.materials.Material;
import alternativa.tanks.models.sfx.SimplePlane;

class AnimatedPlane extends SimplePlane
{
    
   
   public var currFrame:Number;
   
   private var materials:Vector.<Material>;
   
   private var numFrames:int;
   
   function AnimatedPlane(width:Number, length:Number)
   {
      super(width,length,0.5,0);
      setUVs(0, 0, 0, 1, 1, 1, 1, 0);
	  this.useDepth = false;
	  this.useLight = false;
	  this.useShadowMap = false;
   }
   
   public function setMaterials(materials:Vector.<Material>) : void
   {
      this.materials = materials;
      this.numFrames = materials.length;
   }
   
   public function clearMaterials() : void
   {
      this.materials = null;
      material = null;
   }
   
   public function update(dt:Number, fps:Number) : void
   {
      this.currFrame = this.currFrame + dt * fps;
      if(this.currFrame >= this.numFrames)
      {
         this.currFrame = 0;
      }
      material = this.materials[int(this.currFrame)];
   }
}
