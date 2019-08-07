package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   
   public class TankSkinTurret extends TankSkinPart
   {
       
      
      public var flagMountPoint:Vector3;
      
      public var mesh1:Mesh;
      
      public function TankSkinTurret(mesh:Mesh, flagMountPoint:Vector3)
      {
         super(mesh,false);
         this.flagMountPoint = flagMountPoint;
         this.mesh1 = mesh;
      }
      
      override protected function getMesh() : Mesh
      {
         return this.mesh1;
      }
   }
}
