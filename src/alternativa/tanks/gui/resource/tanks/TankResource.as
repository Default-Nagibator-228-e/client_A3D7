package alternativa.tanks.gui.resource.tanks
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Mesh;
   import flash.geom.Vector3D;
   
   public class TankResource
   {
       
      
      public var mesh:Mesh;
      
      public var next:Object;
      
      public var id:String;
      
      public var muzzles:Vector.<Vector3D>;
      
      public var flagMount:Vector3D;
      
      public var turretMount:Vector3D;
      
      public var objects:Vector.<Object3D>;
      
      public function TankResource(mesh:Mesh, id:String, next:Object = null, muzzles:Vector.<Vector3D> = null, flagMount:Vector3D = null, turretMount:Vector3D = null)
      {
         super();
         this.mesh = mesh;
         this.id = id;
         this.next = next;
         this.muzzles = muzzles;
         this.flagMount = flagMount;
         this.turretMount = turretMount;
         this.objects = new Vector.<Object3D>();
      }
   }
}
