package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.BodyState;
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.PhysicsUtils;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.ICollisionPredicate;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.physics.constraints.MaxDistanceConstraint;
   import alternativa.physics.rigid.SkinnedBody3D;
   import alternativa.tanks.bonuses.BonusState;
   import alternativa.tanks.bonuses.IBonus;
   import alternativa.tanks.bonuses.IBonusListener;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.vehicles.tanks.Tank;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   
   use namespace altphysics;
   
   public class ParaBonus extends SkinnedBody3D implements IBonus, ICollisionPredicate
   {
      
      private static const BOX_MASS:Number = 20;
      
      private static const BOX_HALF_SIZE:Number = 75;
      
      private static const PARACHUTE_MASS:Number = 10;
      
      private static const PARACHUTE_RADIUS:Number = 180;
      
      private static const CORDS_LENGTH:Number = 400;
      
      private static const TAKEN_ANIMATION_TIME:int = 2000;
      
      private static const FLASH_DURATION:int = 300;
      
      private static const ALPHA_DURATION:int = TAKEN_ANIMATION_TIME - FLASH_DURATION;
      
      private static const MAX_ADDITIVE_VALUE:int = 204;
      
      private static const ADDITIVE_SPEED_UP:Number = Number(MAX_ADDITIVE_VALUE) / FLASH_DURATION;
      
      private static const ADDITIVE_SPEED_DOWN:Number = Number(MAX_ADDITIVE_VALUE) / (TAKEN_ANIMATION_TIME - FLASH_DURATION);
      
      private static const UP_SPEED:Number = 300;
      
      private static const ANGLE_SPEED:Number = 2;
      
      private static const PHYSICS_STATE_FULL:int = 1;
      
      private static const PHYSICS_STATE_PARABOX:int = 2;
      
      private static const PHYSICS_STATE_BOX:int = 3;
      
      private static const WARNING_TIME:int = 8000;
      
      private static const PARACHUTE_REMOVAL_TIME:int = 2000;
      
      private static const BLINK_INTERVAL:int = 500;
      
      private static const DELTA_ALPHA:Number = 0.5;
      
      private static const MIN_ALPHA:Number = 1 - DELTA_ALPHA;
      
      private static const COEFF:Number = 10;
      
      private static const defaultState:BodyState = new BodyState();
      
      private static var pools:Dictionary = new Dictionary();
       
      
      private var _bonusId:String;
      
      private var bonusState:int;
      
      private var bonusListener:IBonusListener;
      
      private var parachute:Parachute;
      
      private var cordsMesh:Cords;
      
      private var cordsConstaints:Vector.<MaxDistanceConstraint>;
      
      private var timeToLive:int;
      
      private var currBlinkInterval:int;
      
      private var visibilitySwitchTime:int;
      
      private var takenAnimationTime:int;
      
      private var parachuteTimeLeft:int;
      
      private var additiveValue:int;
      
      private var alphaSpeed:Number;
      
      private var physicsState:int;
      
      private var pool:Pool;
      
      //private var light:OmniLight;
      
      public function ParaBonus(pool:Pool, boxMesh:Mesh, parachuteMesh:Mesh, parachuteInnerMesh:Mesh, cordMaterial:Material)
      {
         //this.light = new OmniLight(16745512,150,500);
         super(1 / BOX_MASS, Matrix3.IDENTITY);
         this.pool = pool;
         var hs:Vector3 = new Vector3(BOX_HALF_SIZE,BOX_HALF_SIZE,BOX_HALF_SIZE);
         PhysicsUtils.getBoxInvInertia(BOX_MASS,hs,invInertia);
         var collisionBox:CollisionBox = new CollisionBox(hs,CollisionGroup.BONUS_WITH_STATIC);
         collisionBox.postCollisionPredicate = this;
         addCollisionPrimitive(collisionBox);
         canFreeze = true;
         skin = boxMesh.clone();
         this.createParachuteAndCords(parachuteMesh,parachuteInnerMesh,cordMaterial);
      }
      
      public static function create(bonusData:BonusCommonData) : ParaBonus
      {
         var pool:Pool = pools[bonusData];
         if(pool == null)
         {
            pool = new Pool();
            pools[bonusData] = pool;
         }
         if(pool.numObjects == 0)
         {
            return new ParaBonus(pool,bonusData.boxMesh,bonusData.parachuteMesh,bonusData.parachuteInnerMesh,bonusData.cordMaterial);
         }
         var bonus:ParaBonus = pool.objects[--pool.numObjects];
         pool.objects[pool.numObjects] = null;
         return bonus;
      }
      
      public static function deletePool(bonusData:BonusCommonData) : void
      {
         delete pools[bonusData];
      }
      
      public function init(bonusId:String, timeToLive:int, isFalling:Boolean) : void
      {
         this._bonusId = bonusId;
         this.timeToLive = timeToLive < 0?int(int.MAX_VALUE):int(timeToLive);
         this.bonusState = isFalling?int(BonusState.FALLING):int(BonusState.RESTING);
         collisionPrimitives.head.primitive.collisionGroup = collisionPrimitives.head.primitive.collisionGroup | CollisionGroup.BONUS_WITH_TANK;
         skin.alpha = 1;
         var colorTransform:ColorTransform = skin.colorTransform;
         if(colorTransform != null)
         {
            colorTransform.redOffset = 0;
            colorTransform.greenOffset = 0;
            colorTransform.blueOffset = 0;
         }
         this.additiveValue = 0;
         this.parachute.outerMesh.alpha = 1;
         this.cordsMesh.alpha = 1;
         this.visibilitySwitchTime = 0;
         this.takenAnimationTime = TAKEN_ANIMATION_TIME;
         this.parachuteTimeLeft = PARACHUTE_REMOVAL_TIME;
         this.currBlinkInterval = BLINK_INTERVAL;
         frozen = false;
         freezeCounter = 0;
         state.copy(defaultState);
         prevState.copy(defaultState);
         this.parachute.state.copy(defaultState);
         this.parachute.prevState.copy(defaultState);
      }
      
      public function get bonusId() : String
      {
         return this._bonusId;
      }
      
      public function isFalling() : Boolean
      {
         return this.bonusState == BonusState.FALLING;
      }
      
      public function readBonusPosition(result:Vector3) : void
      {
         result.x = state.pos.x;
         result.y = state.pos.y;
         result.z = state.pos.z;
      }
      
      public function setBonusPosition(x:Number, y:Number, z:Number) : void
      {
         state.pos.vReset(x,y,z);
         prevState.copy(state);
      }
      
      public function setRestingState(x:Number, y:Number, z:Number) : void
      {
         setPositionXYZ(x,y,z);
         frozen = false;
         freezeCounter = 0;
         if(this.bonusState != BonusState.RESTING)
         {
            this.bonusState = BonusState.RESTING;
            this.detachParachute();
         }
      }
      
      public function setTakenState() : void
      {
         this.takenAnimationTime = TAKEN_ANIMATION_TIME;
         _skin.alpha = 1;
         if(this.bonusState == BonusState.FALLING)
         {
            this.detachParachute();
         }
         this.bonusState = BonusState.TAKEN;
      }
      
      public function setRemovedState() : void
      {
         this.bonusState = BonusState.REMOVING;
      }
      
      public function attach(pos:Vector3, rigidWorld:PhysicsScene, container:Scene3DContainer, listener:IBonusListener) : void
      {
         var c:MaxDistanceConstraint = null;
         rigidWorld.addBody(this);
         TanksCollisionDetector(rigidWorld.collisionDetector).addBody(this);
         if(container != null)
         {
            //container.addChild(this.light);
            container.addChild(_skin);
         }
         state.pos.x = pos.x + 50;
         state.pos.y = pos.y + 50;
         state.pos.z = pos.z;
         state.rotation.z = 0.15;
         //this.light.x = state.pos.x;
         //this.light.y = state.pos.y;
         //this.light.z = state.pos.z;
         prevState.copy(state);
         if(this.bonusState == BonusState.FALLING)
         {
            rigidWorld.addBody(this.parachute);
            this.parachute.addToContainer(container);
            for each(c in this.cordsConstaints)
            {
               rigidWorld.addConstraint(c);
            }
            this.parachute.state.pos.vCopy(pos);
            this.parachute.state.pos.z = this.parachute.state.pos.z + 0.5 * CORDS_LENGTH;
            this.parachute.state.rotation.z = 0.3;
            this.parachute.prevState.copy(this.parachute.state);
            if(container != null)
            {
               container.addChild(this.cordsMesh);
            }
            this.physicsState = PHYSICS_STATE_FULL;
         }
         else
         {
            this.physicsState = PHYSICS_STATE_BOX;
         }
         this.updateSkin(1);
         _skin.useLight = true;
		 _skin.useShadowMap = true;
         this.bonusListener = listener;
      }
	  
	  public function attach1(pos:Vector3, rigidWorld:PhysicsScene, container:Scene3DContainer, listener:IBonusListener) : void
      {
         var c:MaxDistanceConstraint = null;
         rigidWorld.addBody(this);
         TanksCollisionDetector(rigidWorld.collisionDetector).addBody(this);
         if(container != null)
         {
            container.addChild(_skin);
         }
         state.pos.x = pos.x + 50;
         state.pos.y = pos.y + 50;
         state.pos.z = pos.z-1190;
         state.rotation.z = 0.15;
         prevState.copy(state);
         this.physicsState = PHYSICS_STATE_BOX;
         this.updateSkin(1);
         _skin.useLight = true;
		 _skin.useShadowMap = true;
         this.bonusListener = listener;
      }
      
      public function update(time:int, millis:int, interpolationTime:Number) : Boolean
      {
         this.updateSkin(interpolationTime);
         this.timeToLive = this.timeToLive - millis;
         if(this.bonusState == BonusState.FALLING)
         {
            return true;
         }
         if(this.bonusState == BonusState.TAKEN)
         {
            if(this.takenAnimationTime < 0)
            {
               return false;
            }
            this.playTakenAnimation(millis);
         }
         if(this.parachuteTimeLeft > 0)
         {
            this.parachuteTimeLeft = this.parachuteTimeLeft - millis;
            if(this.parachuteTimeLeft <= 0)
            {
               this.removeParachuteGraphics();
               this.removeParachutePhysics();
            }
            else
            {
               this.cordsMesh.alpha = this.parachute.outerMesh.alpha = this.parachuteTimeLeft / PARACHUTE_REMOVAL_TIME;
            }
         }
         if((this.bonusState == BonusState.RESTING || this.bonusState == BonusState.REMOVING) && this.timeToLive < WARNING_TIME)
         {
            this.playWarningAnimation(time,millis);
         }
         if(this.bonusState == BonusState.REMOVING && this.timeToLive > WARNING_TIME)
         {
            return false;
         }
         return this.bonusState != BonusState.REMOVED;
      }
      
      public function destroy() : void
      {
         _skin.alternativa3d::removeFromParent();
         //this.light.alternativa3d::removeFromParent();
         this.removeParachuteGraphics();
         this.removeCordConstraints();
         this.removeParachutePhysics();
         TanksCollisionDetector(world.collisionDetector).removeBody(this);
         world.removeBody(this);
         this.pool.objects[this.pool.numObjects++] = this;
      }
      
      public function considerCollision(primitive:CollisionPrimitive) : Boolean
      {
         if(primitive.body == null)
         {
            if(this.bonusState == BonusState.FALLING)
            {
               this.onStaticCollision();
            }
            return true;
         }
         if(primitive.body is Tank)
         {
            this.onTankCollision();
         }
         return false;
      }
      
      private function onStaticCollision() : void
      {
         this.bonusState = BonusState.RESTING;
         this.detachParachute();
         if(this.bonusListener != null)
         {
            this.bonusListener.onBonusDropped(this);
         }
      }
      
      private function detachParachute() : void
      {
         this.removeCordConstraints();
         this.startParachuteDissolving();
      }
      
      private function startParachuteDissolving() : void
      {
         this.parachuteTimeLeft = PARACHUTE_REMOVAL_TIME;
      }
      
      private function onTankCollision() : void
      {
         collisionPrimitives.head.primitive.collisionGroup = collisionPrimitives.head.primitive.collisionGroup & ~CollisionGroup.BONUS_WITH_TANK;
         this.bonusListener.onTankCollision(this);
      }
      
      override public function updateSkin(t:Number) : void
      {
         super.updateSkin(t);
         if(this.parachute != null)
         {
            this.parachute.updateSkin(t);
            this.cordsMesh.updateVertices();
         }
         //this.light.x = state.pos.x;
         //this.light.y = state.pos.y;
         //this.light.z = state.pos.z;
      }
      
      private function createParachuteAndCords(parachuteMesh:Mesh, parachuteInnerMesh:Mesh, cordsMaterial:Material) : void
      {
         var angle:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         this.parachute = new Parachute(PARACHUTE_MASS,PARACHUTE_RADIUS,10,0.8,0,parachuteMesh,parachuteInnerMesh);
         this.cordsMesh = new Cords(266,BOX_HALF_SIZE,12,skin,this.parachute.outerMesh);
         this.cordsMesh.setMaterialToAllFaces(cordsMaterial);
         this.cordsConstaints = new Vector.<MaxDistanceConstraint>();
         var numStraps:int = 4;
         var angleStep:Number = 2 * Math.PI / numStraps;
         for(var i:int = 0; i < numStraps; i++)
         {
            angle = i * angleStep;
            x = PARACHUTE_RADIUS * Math.cos(angle);
            y = PARACHUTE_RADIUS * Math.sin(angle);
            this.cordsConstaints.push(new MaxDistanceConstraint(this.parachute,this,new Vector3(x,y,0),new Vector3(0,0,50),CORDS_LENGTH));
         }
      }
      
      private function removeParachuteGraphics() : void
      {
         this.parachute.removeFromContainer();
         this.cordsMesh.alternativa3d::removeFromParent();
      }
      
      private function removeCordConstraints() : void
      {
         var c:MaxDistanceConstraint = null;
         if(this.physicsState == PHYSICS_STATE_FULL)
         {
            for each(c in this.cordsConstaints)
            {
               c.world.removeConstraint(c);
            }
            this.parachute.state.rotation.vScale(0.05);
            this.parachute.saveState();
            this.physicsState = PHYSICS_STATE_PARABOX;
         }
      }
      
      private function removeParachutePhysics() : void
      {
         if(this.physicsState == PHYSICS_STATE_PARABOX)
         {
            this.parachute.world.removeBody(this.parachute);
            this.physicsState = PHYSICS_STATE_BOX;
         }
      }
      
      private function playWarningAnimation(time:int, deltaMsec:Number) : void
      {
         if(this.visibilitySwitchTime == 0)
         {
            this.alphaSpeed = -COEFF * DELTA_ALPHA / this.currBlinkInterval;
            this.visibilitySwitchTime = time + this.currBlinkInterval;
         }
         else
         {
            skin.alpha = skin.alpha + this.alphaSpeed * deltaMsec;
            if(this.bonusState == BonusState.REMOVING && this.alphaSpeed < 0)
            {
               if(skin.alpha <= 0)
               {
                  this.bonusState = BonusState.REMOVED;
               }
            }
            else
            {
               if(skin.alpha < MIN_ALPHA)
               {
                  skin.alpha = MIN_ALPHA;
               }
               if(time >= this.visibilitySwitchTime)
               {
                  if(this.currBlinkInterval > 22)
                  {
                     this.currBlinkInterval = this.currBlinkInterval - 12;
                  }
                  this.visibilitySwitchTime = this.visibilitySwitchTime + this.currBlinkInterval;
                  if(this.alphaSpeed < 0)
                  {
                     this.alphaSpeed = COEFF * DELTA_ALPHA / this.currBlinkInterval;
                     skin.alpha = MIN_ALPHA;
                  }
                  else
                  {
                     this.alphaSpeed = -COEFF * DELTA_ALPHA / this.currBlinkInterval;
                     skin.alpha = 1;
                  }
               }
            }
         }
      }
      
      private function playTakenAnimation(millis:int) : void
      {
         addForce(new Vector3(0,0,world._gravity.vLength() / invMass));
         state.velocity.vReset(0,0,UP_SPEED * this.takenAnimationTime / TAKEN_ANIMATION_TIME + UP_SPEED * 0.1);
         state.rotation.vReset(0,0,ANGLE_SPEED * this.takenAnimationTime / TAKEN_ANIMATION_TIME + ANGLE_SPEED * 0.1);
         if(this.takenAnimationTime > TAKEN_ANIMATION_TIME - FLASH_DURATION)
         {
            this.additiveValue = this.additiveValue + ADDITIVE_SPEED_UP * millis;
            if(this.additiveValue > MAX_ADDITIVE_VALUE)
            {
               this.additiveValue = MAX_ADDITIVE_VALUE;
            }
         }
         else
         {
            this.additiveValue = this.additiveValue - ADDITIVE_SPEED_DOWN * millis;
            if(this.additiveValue < 0)
            {
               this.additiveValue = 0;
            }
         }
         var colorTransform:ColorTransform = skin.colorTransform;
         if(colorTransform == null)
         {
            colorTransform = new ColorTransform();
            skin.colorTransform = colorTransform;
         }
         colorTransform.redOffset = this.additiveValue;
         colorTransform.blueOffset = this.additiveValue;
         colorTransform.greenOffset = this.additiveValue;
         if(this.takenAnimationTime < ALPHA_DURATION)
         {
            skin.alpha = this.takenAnimationTime / ALPHA_DURATION;
         }
         this.takenAnimationTime = this.takenAnimationTime - millis;
      }
   }
}

import alternativa.tanks.models.effects.common.bonuscommon.ParaBonus;

class Pool {

	public var objects:Vector.<ParaBonus> = new Vector.<ParaBonus>();
	public var numObjects:int;

}

