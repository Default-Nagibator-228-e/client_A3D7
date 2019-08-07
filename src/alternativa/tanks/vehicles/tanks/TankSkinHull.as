package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   
   public class TankSkinHull extends TankSkinPart
   {
       
      
      public var turretMountPoint:Vector3;
      
      public var mesh1:Mesh;
      
      public function TankSkinHull(mesh2:Mesh, turretMountPoint:Vector3)
      {
         super(mesh2,true);
         this.mesh1 = mesh2;
         this.turretMountPoint = turretMountPoint;
      }
      
      override protected function getMesh() : Mesh
      {
         return this.mesh1;
      }
   }
}
