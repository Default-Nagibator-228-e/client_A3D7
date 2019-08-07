package alternativa.physics.rigid
{
   import alternativa.math.Matrix3;
   import alternativa.physics.Body;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   
   public class Body3D extends Body
   {
       
      
      public function Body3D(invMass:Number, invInertia:Matrix3)
      {
         super(invMass,invInertia);
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
      }
      
      public function removeFromContainer() : void
      {
      }
      
      public function updateSkin(t:Number) : void
      {
      }
   }
}
