package alternativa.tanks.hulls
{
   import alternativa.engine3d.objects.Mesh;
   import flash.geom.Vector3D;
   
   public class Hull
   {
       
      
      public var mesh:Mesh;
      
      public var mountPoint:Vector3D;
      
      public function Hull(mesh:Mesh, mountPoint:Vector3D)
      {
         super();
         this.mesh = mesh;
         this.mountPoint = mountPoint;
      }
   }
}
