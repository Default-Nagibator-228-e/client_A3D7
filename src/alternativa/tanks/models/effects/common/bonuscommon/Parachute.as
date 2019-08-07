package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsUtils;
   import alternativa.physics.rigid.Body3D;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   
   use namespace alternativa3d;
   
   public class Parachute extends Body3D
   {
      
      private static var _force:Vector3 = new Vector3();
      
      private static var _v:Vector3 = new Vector3();
      
      private static var _o:Quaternion = new Quaternion();
       
      
      private var k1:Number = 0;
      
      private var k2:Number = 0;
      
      public var outerMesh:Mesh;
      
      public function Parachute(mass:Number, radius:Number, height:Number, k1:Number, k2:Number, outerMeshRef:Mesh, innerMeshRef:Mesh)
      {
         super(1 / mass,Matrix3.IDENTITY);
         PhysicsUtils.getCylinderInvInertia(mass,radius,height,invInertia);
         this.k1 = k1;
         this.k2 = k2;
         this.outerMesh = Mesh(outerMeshRef.clone());
      }
      
      override public function beforePhysicsStep(dt:Number) : void
      {
         var dz:Number = NaN;
         var dx:Number = state.velocity.x;
         var dy:Number = state.velocity.y;
         dz = state.velocity.z;
         var speed:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         if(speed < 0.001)
         {
            return;
         }
         dx = dx / speed;
         dy = dy / speed;
         dz = dz / speed;
         var mag:Number = this.k1 * speed * speed + this.k2 * speed * speed * speed;
         _force.x = -dx * mag;
         _force.y = -dy * mag;
         _force.z = -dz * mag;
         addForce(_force);
      }
      
      override public function addToContainer(container:Scene3DContainer) : void
      {
         if(container != null)
         {
            container.addChild(this.outerMesh);
         }
      }
      
      override public function removeFromContainer() : void
      {
         this.outerMesh.removeFromParent();
      }
      
      override public function updateSkin(t:Number) : void
      {
         interpolate(t,_v,_o);
         this.outerMesh.x = _v.x;
         this.outerMesh.y = _v.y;
         this.outerMesh.z = _v.z;
         _o.normalize();
         _o.getEulerAngles(_v);
         this.outerMesh.rotationX = _v.x;
         this.outerMesh.rotationY = _v.y;
         this.outerMesh.rotationZ = _v.z;
      }
   }
}
