package alternativa.physics
{
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.IBodyCollisionPredicate;
   import alternativa.physics.collision.types.BoundBox;
   
   use namespace altphysics;
   
   public class Body
   {
      
      public static var linDamping:Number = 0.997;
      
      public static var rotDamping:Number = 0.997;
      
      private static var _r:Vector3 = new Vector3();
      
      private static var _f:Vector3 = new Vector3();
       
      
      public var id:int;
      
      public var name:String;
      
      public var world:PhysicsScene;
      
      public var movable:Boolean = true;
      
      public var canFreeze:Boolean = false;
      
      public var freezeCounter:int;
      
      public var frozen:Boolean = false;
      
      public var aabb:BoundBox;
      
      public var postCollisionPredicate:IBodyCollisionPredicate;
      
      public var state:BodyState;
      
      public var prevState:BodyState;
      
      public var accel:Vector3;
      
      public var angleAccel:Vector3;
      
      public var material:BodyMaterial;
      
      public var invMass:Number = 1;
      
      public var invInertia:Matrix3;
      
      public var invInertiaWorld:Matrix3;
      
      public var baseMatrix:Matrix3;
      
      public const MAX_CONTACTS:int = 20;
      
      public var contacts:Vector.<Contact>;
      
      public var contactsNum:int;
      
      public var collisionPrimitives:CollisionPrimitiveList;
      
      public var forceAccum:Vector3;
      
      public var torqueAccum:Vector3;
      
      public function Body(invMass:Number, invInertia:Matrix3)
      {
         this.aabb = new BoundBox();
         this.state = new BodyState();
         this.prevState = new BodyState();
         this.accel = new Vector3();
         this.angleAccel = new Vector3();
         this.material = new BodyMaterial();
         this.invInertia = new Matrix3();
         this.invInertiaWorld = new Matrix3();
         this.baseMatrix = new Matrix3();
         this.contacts = new Vector.<Contact>(this.MAX_CONTACTS);
         this.forceAccum = new Vector3();
         this.torqueAccum = new Vector3();
         super();
         this.invMass = invMass;
         this.invInertia.copy(invInertia);
      }
      
      public function addCollisionPrimitive(primitive:CollisionPrimitive, localTransform:Matrix4 = null) : void
      {
         if(primitive == null)
         {
            throw new ArgumentError("Primitive cannot be null");
         }
         if(this.collisionPrimitives == null)
         {
            this.collisionPrimitives = new CollisionPrimitiveList();
         }
         this.collisionPrimitives.append(primitive);
         primitive.setBody(this,localTransform);
      }
      
      public function removeCollisionPrimitive(primitive:CollisionPrimitive) : void
      {
         if(this.collisionPrimitives == null)
         {
            return;
         }
         primitive.setBody(null);
         this.collisionPrimitives.remove(primitive);
         if(this.collisionPrimitives.size == 0)
         {
            this.collisionPrimitives = null;
         }
      }
      
      public function interpolate(t:Number, pos:Vector3, orientation:Quaternion) : void
      {
         var t1:Number = NaN;
         t1 = 1 - t;
         pos.x = this.prevState.pos.x * t1 + this.state.pos.x * t;
         pos.y = this.prevState.pos.y * t1 + this.state.pos.y * t;
         pos.z = this.prevState.pos.z * t1 + this.state.pos.z * t;
         orientation.w = this.prevState.orientation.w * t1 + this.state.orientation.w * t;
         orientation.x = this.prevState.orientation.x * t1 + this.state.orientation.x * t;
         orientation.y = this.prevState.orientation.y * t1 + this.state.orientation.y * t;
         orientation.z = this.prevState.orientation.z * t1 + this.state.orientation.z * t;
      }
      
      public function setPosition(pos:Vector3) : void
      {
         this.state.pos.vCopy(pos);
      }
      
      public function setPositionXYZ(x:Number, y:Number, z:Number) : void
      {
         this.state.pos.vReset(x,y,z);
      }
      
      public function setVelocity(vel:Vector3) : void
      {
         this.state.velocity.vCopy(vel);
      }
      
      public function setVelocityXYZ(x:Number, y:Number, z:Number) : void
      {
         this.state.velocity.vReset(x,y,z);
      }
      
      public function setRotation(rot:Vector3) : void
      {
         this.state.rotation.vCopy(rot);
      }
      
      public function setRotationXYZ(x:Number, y:Number, z:Number) : void
      {
         this.state.rotation.vReset(x,y,z);
      }
      
      public function setOrientation(q:Quaternion) : void
      {
         this.state.orientation.copy(q);
      }
      
      public function applyRelPosWorldImpulse(r:Vector3, dir:Vector3, magnitude:Number) : void
      {
         var d:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         d = magnitude * this.invMass;
         this.state.velocity.x = this.state.velocity.x + d * dir.x;
         this.state.velocity.y = this.state.velocity.y + d * dir.y;
         this.state.velocity.z = this.state.velocity.z + d * dir.z;
         var x:Number = (r.y * dir.z - r.z * dir.y) * magnitude;
         y = (r.z * dir.x - r.x * dir.z) * magnitude;
         z = (r.x * dir.y - r.y * dir.x) * magnitude;
         this.state.rotation.x = this.state.rotation.x + (this.invInertiaWorld.a * x + this.invInertiaWorld.b * y + this.invInertiaWorld.c * z);
         this.state.rotation.y = this.state.rotation.y + (this.invInertiaWorld.e * x + this.invInertiaWorld.f * y + this.invInertiaWorld.g * z);
         this.state.rotation.z = this.state.rotation.z + (this.invInertiaWorld.i * x + this.invInertiaWorld.j * y + this.invInertiaWorld.k * z);
      }
      
      public function addForce(f:Vector3) : void
      {
         this.forceAccum.vAdd(f);
      }
      
      public function addForceXYZ(fx:Number, fy:Number, fz:Number) : void
      {
         this.forceAccum.x = this.forceAccum.x + fx;
         this.forceAccum.y = this.forceAccum.y + fy;
         this.forceAccum.z = this.forceAccum.z + fz;
      }
      
      public function addWorldForceXYZ(px:Number, py:Number, pz:Number, fx:Number, fy:Number, fz:Number) : void
      {
         var rx:Number = NaN;
         var ry:Number = NaN;
         this.forceAccum.x = this.forceAccum.x + fx;
         this.forceAccum.y = this.forceAccum.y + fy;
         this.forceAccum.z = this.forceAccum.z + fz;
         var pos:Vector3 = this.state.pos;
         rx = px - pos.x;
         ry = py - pos.y;
         var rz:Number = pz - pos.z;
         this.torqueAccum.x = this.torqueAccum.x + (ry * fz - rz * fy);
         this.torqueAccum.y = this.torqueAccum.y + (rz * fx - rx * fz);
         this.torqueAccum.z = this.torqueAccum.z + (rx * fy - ry * fx);
      }
      
      public function addWorldForce(pos:Vector3, force:Vector3) : void
      {
         this.forceAccum.vAdd(force);
         this.torqueAccum.vAdd(_r.vDiff(pos,this.state.pos).vCross(force));
      }
      
      public function addWorldForceScaled(pos:Vector3, force:Vector3, scale:Number) : void
      {
         _f.x = scale * force.x;
         _f.y = scale * force.y;
         _f.z = scale * force.z;
         this.forceAccum.vAdd(_f);
         this.torqueAccum.vAdd(_r.vDiff(pos,this.state.pos).vCross(_f));
      }
	  
	  public function addWorldForceinP(pos:Vector3, force:Vector3, scale:Number, loc:Vector3) : void
      {
         _f.x = scale * force.x;
         _f.y = scale * force.y;
         _f.z = scale * force.z;
         this.forceAccum.vAdd(_f);
         this.torqueAccum.vAdd(_r.vDiff(pos,loc).vCross(_f));
      }
      
      public function addLocalForce(pos:Vector3, force:Vector3) : void
      {
         this.baseMatrix.transformVector(pos,_r);
         this.baseMatrix.transformVector(force,_f);
         this.forceAccum.vAdd(_f);
         this.torqueAccum.vAdd(_r.vCross(_f));
      }
      
      public function addWorldForceAtLocalPoint(localPos:Vector3, worldForce:Vector3, scale:Number = 1) : void
      {
         this.baseMatrix.transformVector(localPos,_r);
         this.forceAccum.vAdd(worldForce);
         this.torqueAccum.vAdd(_r.vCross(worldForce));
      }
      
      public function beforePhysicsStep(dt:Number) : void
      {
      }
      
      public function addTorque(t:Vector3) : void
      {
         this.torqueAccum.vAdd(t);
      }
      
      altphysics function clearAccumulators() : void
      {
         this.forceAccum.x = this.forceAccum.y = this.forceAccum.z = 0;
         this.torqueAccum.x = this.torqueAccum.y = this.torqueAccum.z = 0;
      }
      
      altphysics function calcAccelerations() : void
      {
         this.accel.x = this.forceAccum.x * this.invMass;
         this.accel.y = this.forceAccum.y * this.invMass;
         this.accel.z = this.forceAccum.z * this.invMass;
         this.angleAccel.x = this.invInertiaWorld.a * this.torqueAccum.x + this.invInertiaWorld.b * this.torqueAccum.y + this.invInertiaWorld.c * this.torqueAccum.z;
         this.angleAccel.y = this.invInertiaWorld.e * this.torqueAccum.x + this.invInertiaWorld.f * this.torqueAccum.y + this.invInertiaWorld.g * this.torqueAccum.z;
         this.angleAccel.z = this.invInertiaWorld.i * this.torqueAccum.x + this.invInertiaWorld.j * this.torqueAccum.y + this.invInertiaWorld.k * this.torqueAccum.z;
      }
      
      public function calcDerivedData() : void
      {
         var item:CollisionPrimitiveListItem = null;
         var primitive:CollisionPrimitive = null;
         this.state.orientation.toMatrix3(this.baseMatrix);
         this.invInertiaWorld.copy(this.invInertia).append(this.baseMatrix).prependTransposed(this.baseMatrix);
         if(this.collisionPrimitives != null)
         {
            this.aabb.infinity();
            item = this.collisionPrimitives.head;
            while(item != null)
            {
               primitive = item.primitive;
               primitive.transform.setFromMatrix3(this.baseMatrix,this.state.pos);
               if(primitive.localTransform != null)
               {
                  primitive.transform.prepend(primitive.localTransform);
               }
               primitive.calculateAABB();
               this.aabb.addBoundBox(primitive.aabb);
               item = item.next;
            }
         }
      }
      
      altphysics function saveState() : void
      {
         this.prevState.copy(this.state);
      }
      
      altphysics function restoreState() : void
      {
         this.state.copy(this.prevState);
      }
      
      altphysics function integrateVelocity(dt:Number) : void
      {
         this.state.velocity.x = this.state.velocity.x + this.accel.x * dt;
         this.state.velocity.y = this.state.velocity.y + this.accel.y * dt;
         this.state.velocity.z = this.state.velocity.z + this.accel.z * dt;
         this.state.rotation.x = this.state.rotation.x + this.angleAccel.x * dt;
         this.state.rotation.y = this.state.rotation.y + this.angleAccel.y * dt;
         this.state.rotation.z = this.state.rotation.z + this.angleAccel.z * dt;
         this.state.velocity.x = this.state.velocity.x * linDamping;
         this.state.velocity.y = this.state.velocity.y * linDamping;
         this.state.velocity.z = this.state.velocity.z * linDamping;
         this.state.rotation.x = this.state.rotation.x * rotDamping;
         this.state.rotation.y = this.state.rotation.y * rotDamping;
         this.state.rotation.z = this.state.rotation.z * rotDamping;
      }
      
      altphysics function integratePosition(dt:Number) : void
      {
         this.state.pos.x = this.state.pos.x + this.state.velocity.x * dt;
         this.state.pos.y = this.state.pos.y + this.state.velocity.y * dt;
         this.state.pos.z = this.state.pos.z + this.state.velocity.z * dt;
         this.state.orientation.addScaledVector(this.state.rotation,dt);
      }
   }
}
