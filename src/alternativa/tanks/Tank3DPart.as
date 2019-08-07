package alternativa.tanks
{
   import alternativa.engine3d.objects.Mesh;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   
   public class Tank3DPart
   {
       
      
      public var mesh:Mesh;
      
      public var lightmap:BitmapData;
      
      public var details:BitmapData;
      
      public var turretMountPoint:Vector3D;
      
      public var animatedPaint:Boolean;
      
      public function Tank3DPart()
      {
         super();
      }
   }
}
