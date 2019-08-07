package alternativa.tanks.models.sfx.flame
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.sfx.Partic;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.SFXUtils;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.utils.getTimer;
   
   public class FlamethrowerGraphicEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const ANIMATION_FPS:Number = 30;
      
      private static const START_SCALE:Number = 0.5;
      
      private static const END_SCALE:Number = 4;
      
      private static var particleBaseSize:ConsoleVarFloat = new ConsoleVarFloat("flame_base_size",100,1,1000);
      
      private static var matrix:Matrix3 = new Matrix3();
      
      private static var particlePosition:Vector3 = new Vector3();
      
      private static var barrelOrigin:Vector3 = new Vector3();
      
      private static var gunDirection:Vector3 = new Vector3();
      
      private static var xAxis:Vector3 = new Vector3();
      
      private static var globalMuzzlePosition:Vector3 = new Vector3();
      
      private static var intersection:RayIntersection = new RayIntersection();
       
      
      private var range:Number;
      
      private var scalePerDistance:Number;
      
      private var coneHalfAngleTan:Number;
      
      private var maxParticles:int;
      
      private var particleSpeed:Number;
      
      private var localMuzzlePosition:Vector3;
      
      private var turret:Object3D;
      
      private var sfxData:FlamethrowerSFXData;
      
      private var container:Scene3DContainer;
      
      private var particles:Vector.<Particle>;
      
      private var numParticles:int;
      
      private var numFrames:int;
      
      private var collisionDetector:TanksCollisionDetector;
      
      private var dead:Boolean;
      
      private var emissionDelta:int;
      
      private var nextEmissionTime:int;
      
      private var time:int;
      
      private var collisionGroup:int = 16;
      
      private var weakeningModel:IWeaponWeakeningModel;
      
      private var shooterData:TankData;
      
      private var animatedTexture:TextureAnimation;
	  
	  private var parti:Partic;
	  
	  private var localPosition:Vector3 = new Vector3();
	  
	  private static var globalPosition:Vector3 = new Vector3();
	  
	  private static var turretMatrix:Matrix4 = new Matrix4();
      
      public function FlamethrowerGraphicEffect(objectPool:ObjectPool)
      {
         this.localMuzzlePosition = new Vector3();
         this.particles = new Vector.<Particle>();
         super(objectPool);
      }
      
      public function init(shooterData:TankData, range:Number, coneAngle:Number, maxParticles:int, particleSpeed:Number, muzzleLocalPos:Vector3, turret:Object3D, sfxData:FlamethrowerSFXData, collisionDetector:TanksCollisionDetector, weakeningModel:IWeaponWeakeningModel) : void
      {
         this.shooterData = shooterData;
         this.range = range;
         this.scalePerDistance = 2 * (END_SCALE - START_SCALE) / range;
         this.coneHalfAngleTan = Math.tan(0.5 * coneAngle);
         this.maxParticles = maxParticles;
         this.particleSpeed = particleSpeed;
         this.localMuzzlePosition.vCopy(muzzleLocalPos);
         this.turret = turret;
         this.sfxData = sfxData;
         this.collisionDetector = collisionDetector;
         this.weakeningModel = weakeningModel;
         this.numFrames = sfxData.materials.length;
         this.emissionDelta = 1000 * range / (maxParticles * particleSpeed);
         this.time = this.nextEmissionTime = getTimer();
         this.particles.length = maxParticles;
         this.dead = false;
         this.animatedTexture = sfxData.data;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         this.container = container;
		 addShot();
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         var dt:Number = NaN;
         var particle:Particle = null;
         var velocity:Vector3 = null;
         var scale:Number = NaN;
         var size:Number = NaN;
		 var sde:Boolean = !this.dead && this.time >= this.nextEmissionTime;
		 if (sde)
		 {
			if (this.numParticles < this.maxParticles)
			{
				this.nextEmissionTime += this.emissionDelta;
				this.tryToAddParticle();
			}
			turretMatrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
			turretMatrix.transformVector(this.localPosition, globalPosition);
			SFXUtils.alignObjectPlaneToView(this.parti.sprite, globalPosition, new Vector3(this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ), camera.pos);
			parti.sprite.x = globalPosition.x;
			parti.sprite.y = globalPosition.y;
			parti.sprite.z = globalPosition.z;
			parti.sprite.rotationX = this.turret.rotationX;
			parti.sprite.rotationY = this.turret.rotationY;
			parti.sprite.rotationZ = this.turret.rotationZ;
			parti.updateC(millis);
		 }
		 parti.sprite.visible = sde;
         dt = 0.001 * millis;
         for(var i:int = 0; i < this.numParticles; i++)
         {
            particle = this.particles[i];
            particlePosition.x = particle.x;
            particlePosition.y = particle.y;
            particlePosition.z = particle.z;
			var d:Number = particle.distance / range;
			particle.alpha = d >= 0.5? 1 - d*0.75 : 1;
            if(particle.distance > this.range || this.collisionDetector.intersectRayWithStatic(particlePosition,particle.velocity,this.collisionGroup,dt,null,intersection))
            {
				this.removeParticle(i--);
            }
            else
            {
               velocity = particle.velocity;
               particle.x = particle.x + dt * velocity.x;
               particle.y = particle.y + dt * velocity.y;
               particle.z = particle.z + dt * velocity.z;
			   particle.rotation += (Math.PI / 180)*2;
               particle.distance = particle.distance + this.particleSpeed * dt;
               particle.update(millis);
               scale = START_SCALE + this.scalePerDistance * particle.distance;
               if(scale > END_SCALE)
               {
                  scale = END_SCALE;
               }
               size = scale * particleBaseSize.value;
               particle.width = size;
               particle.height = size;
               particle.updateC(millis);
            }
         }
         this.time += millis;
         return !this.dead || this.numParticles > 0;
      }
      
      public function destroy() : void
      {
         while(this.numParticles > 0)
         {
            this.removeParticle(0);
         }
         this.collisionDetector = null;
         this.turret = null;
         this.shooterData = null;
         this.sfxData = null;
		 container.removeChild(parti.sprite);
		 parti = null;
         storeInPool();
      }
      
      public function kill() : void
      {
         this.dead = true;
      }
      
      override protected function getClass() : Class
      {
         return FlamethrowerGraphicEffect;
      }
      
      private function tryToAddParticle() : void
      {
         var barrelLength:Number = NaN;
         matrix.setRotationMatrix(this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         barrelOrigin.x = 0;
         barrelOrigin.y = 0;
         barrelOrigin.z = this.localMuzzlePosition.z;
         barrelOrigin.vTransformBy3(matrix);
         barrelOrigin.x = barrelOrigin.x + this.turret.x;
         barrelOrigin.y = barrelOrigin.y + this.turret.y;
         barrelOrigin.z = barrelOrigin.z + this.turret.z;
         gunDirection.x = matrix.b;
         gunDirection.y = matrix.f;
         gunDirection.z = matrix.j;
         var offset:Number = Math.random() * 50;
         if(!this.collisionDetector.intersectRayWithStatic(barrelOrigin,gunDirection,CollisionGroup.STATIC,this.localMuzzlePosition.y + offset,null,intersection))
         {
            barrelLength = this.localMuzzlePosition.y + 3*20;
            globalMuzzlePosition.x = barrelOrigin.x + gunDirection.x * barrelLength;
            globalMuzzlePosition.y = barrelOrigin.y + gunDirection.y * barrelLength;
            globalMuzzlePosition.z = barrelOrigin.z + gunDirection.z * barrelLength;
            xAxis.x = matrix.a;
            xAxis.y = matrix.e;
            xAxis.z = matrix.i;
            this.addParticle(globalMuzzlePosition,gunDirection,xAxis,offset);
         }
      }
	  
	  private function addShot() : void
      {
			var barrelLength:Number = NaN;
			 matrix.setRotationMatrix(this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
			 barrelOrigin.x = 0;
			 barrelOrigin.y = 0;
			 barrelOrigin.z = this.localMuzzlePosition.z;
			 barrelOrigin.vTransformBy3(matrix);
			 barrelOrigin.x = barrelOrigin.x + this.turret.x;
			 barrelOrigin.y = barrelOrigin.y + this.turret.y;
			 barrelOrigin.z = barrelOrigin.z + this.turret.z;
			 gunDirection.x = matrix.b;
			 gunDirection.y = matrix.f;
			 gunDirection.z = matrix.j;
			 var offset:Number = Math.random() * 50;
			 if(!this.collisionDetector.intersectRayWithStatic(barrelOrigin,gunDirection,CollisionGroup.STATIC,this.localMuzzlePosition.y + offset,null,intersection))
			 {
				barrelLength = this.localMuzzlePosition.y;
				localPosition = new Vector3(this.localMuzzlePosition.x,this.localMuzzlePosition.y,this.localMuzzlePosition.z);
				//this.localPosition.y += 12*20;
				//this.localPosition.y += 2*20;
				this.localPosition.x += 2.7*20;
				globalMuzzlePosition.x = barrelOrigin.x + gunDirection.x * barrelLength;
				globalMuzzlePosition.y = barrelOrigin.y + gunDirection.y * barrelLength;
				globalMuzzlePosition.z = barrelOrigin.z + gunDirection.z * barrelLength;
				xAxis.x = matrix.a;
				xAxis.y = matrix.e;
				xAxis.z = matrix.i;
				var particle:Partic = new Partic(this.sfxData.shot);
				 particle.currFrame = Math.random() * this.numFrames;
				 var angle:Number = 2 * Math.PI * Math.random();
				 matrix.fromAxisAngle(gunDirection,angle);
				 xAxis.vTransformBy3(matrix);
				 var d:Number = this.range * this.coneHalfAngleTan * Math.random();
				 gunDirection.x = gunDirection.x * this.range + xAxis.x * d;
				 gunDirection.y = gunDirection.y * this.range + xAxis.y * d;
				 gunDirection.z = gunDirection.z * this.range + xAxis.z * d;
				 gunDirection.vNormalize();
				 particle.velocity.x = this.particleSpeed * gunDirection.x;
				 particle.velocity.y = this.particleSpeed * gunDirection.y;
				 particle.velocity.z = this.particleSpeed * gunDirection.z;
				 particle.velocity.vAdd(this.shooterData.tank.state.velocity);
				 particle.distance = offset;
				 particle.sprite.x = globalMuzzlePosition.x + offset * gunDirection.x;
				 particle.sprite.y = globalMuzzlePosition.y + offset * gunDirection.y;
				 particle.sprite.z = globalMuzzlePosition.z + offset * gunDirection.z;
				 parti = particle;
				 this.container.addChild(particle.sprite);
			 }
      }
      
      private function addParticle(globalMuzzlePosition:Vector3, direction:Vector3, gunAxisX:Vector3, offset:Number) : void
      {
         var particle:Particle = Particle.getParticle(this.animatedTexture);
         particle.currFrame = Math.random() * this.numFrames;
         var angle:Number = 2 * Math.PI * Math.random();
         matrix.fromAxisAngle(direction,angle);
         gunAxisX.vTransformBy3(matrix);
         var d:Number = this.range * this.coneHalfAngleTan * Math.random();
         direction.x = direction.x * this.range + gunAxisX.x * d;
         direction.y = direction.y * this.range + gunAxisX.y * d;
         direction.z = direction.z * this.range + gunAxisX.z * d;
         direction.vNormalize();
         particle.velocity.x = this.particleSpeed * direction.x;
         particle.velocity.y = this.particleSpeed * direction.y;
         particle.velocity.z = this.particleSpeed * direction.z;
         particle.velocity.vAdd(this.shooterData.tank.state.velocity);
         particle.distance = offset;
         particle.x = globalMuzzlePosition.x + offset * direction.x;
         particle.y = globalMuzzlePosition.y + offset * direction.y;
         particle.z = globalMuzzlePosition.z + offset * direction.z;
         var _loc8_:* = this.numParticles++;
         this.particles[_loc8_] = particle;
         this.container.addChild(particle);
		 this.container.addChild(particle.light);
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
import alternativa.engine3d.lights.OmniLight;
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.math.Vector3;
import alternativa.tanks.engine3d.AnimatedSprite3D;
import alternativa.tanks.engine3d.TextureAnimation;
import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
import flash.geom.ColorTransform;

class Particle extends AnimatedSprite3D
{
   
   private static var INITIAL_POOL_SIZE:int = 20;
   
   private static var pool:Vector.<Particle> = new Vector.<Particle>(INITIAL_POOL_SIZE);
   
   private static var poolIndex:int = -1;
    
   
   public var velocity:Vector3;
   
   public var distance:Number = 0;
   
   public var currFrame:Number = 0;
   
   public var light:OmniLight;
	  
   private var framesPerMillisecond:Number;
   
   private var aData:TextureAnimation;
   
   function Particle(animData:TextureAnimation)
   {
      this.velocity = new Vector3();
	  aData = animData;
      super(100,100);
      colorTransform = new ColorTransform();
      this.softAttenuation = 140;
      super.setAnimationData(animData);
      super.setFrameIndex(0);
      super.looped = true;
	  super.useDepth = false;
	  super.useLight = false;
	  super.useShadowMap = false;
	  this.framesPerMillisecond = 0.001 * animData.fps;
	  this.light = new OmniLight(16745512, 500, 1000);
	  var fdgdfsss:Number = Math.random();
	  fdgdfsss > 0.75 ? this.light.attenuationBegin = 500 * fdgdfsss : this.light.attenuationBegin = 375;
	  fdgdfsss > 0.75 ? this.light.attenuationEnd = 1000 * fdgdfsss : this.light.attenuationEnd = 750;
   }
   
   public static function getParticle(animData:TextureAnimation) : Particle
   {
      return new Particle(animData);
   }
   
   public function dispose() : void
   {
      alternativa3d::removeFromParent();
	  this.light.alternativa3d::removeFromParent();
      material = null;
      pool[++poolIndex] = this;
   }
   
   public function updateC(millis:int) : void
   {
	  while (this.currFrame >= aData.material.length)
	  {
		  this.currFrame -= aData.material.length;
	  }
	  this.material = aData.material[int(this.currFrame)];
	  this.currFrame += this.framesPerMillisecond * millis;
	  this.light.x = this.x;
      this.light.y = this.y;
      this.light.z = this.z;
	  this.light.attenuationBegin -= millis;
	  this.light.attenuationEnd -= millis;
   }
}
