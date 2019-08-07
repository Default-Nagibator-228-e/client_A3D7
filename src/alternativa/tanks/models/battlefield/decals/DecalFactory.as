package alternativa.tanks.models.battlefield.decals
{
   import alternativa.debug.dump.ObjectDumper;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Decal;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.physics.CollisionGroup;
   import flash.geom.Vector3D;
   
   public class DecalFactory
   {
      
      private static const ANGLE_LIMIT:Number = 85 * Math.PI / 180;
      
      private static const rayHit:RayIntersection = new RayIntersection();
      
      private static const direction:Vector3 = new Vector3();
      
      private static const right:Vector3 = new Vector3();
      
      private static const up:Vector3 = new Vector3();
      
      private static const normal:Vector3 = new Vector3();
      
      private static const origins:Vector.<Vector3> = Vector.<Vector3>([new Vector3(),new Vector3(),new Vector3(),new Vector3(),new Vector3()]);
      
      private static const position3D:Vector3D = new Vector3D();
      
      private static const normal3D:Vector3D = new Vector3D();
       
      
      private var collisionDetector:ICollisionDetector;
      
      public function DecalFactory(param1:ICollisionDetector)
      {
         super();
         this.collisionDetector = param1;
      }
      
      public function createDecal(param1:Vector3, param2:Vector3, param3:Number, param4:TextureMaterial, param5:KDContainer, param6:RotationState) : Decal
      {
         var _loc8_:Vector3 = null;
         var _loc9_:Number = NaN;
         direction.vDiff(param1,param2);
         var _loc7_:Number = direction.vLength() + 200;
         direction.vNormalize();
         right.vCross2(direction,Vector3.Z_AXIS).vNormalize();
         up.vCross2(right,direction);
         Vector3(origins[4]).vCopy(param2);
         Vector3(origins[0]).vCopy(param2).vAddScaled(50,right);
         Vector3(origins[1]).vCopy(param2).vAddScaled(50,up);
         Vector3(origins[2]).vCopy(param2).vAddScaled(-50,right);
         Vector3(origins[3]).vCopy(param2).vAddScaled(-50,up);
         normal.reset(0,0,0);
         for each(_loc8_ in origins)
         {
            if(this.collisionDetector.intersectRayWithStatic(_loc8_,direction,CollisionGroup.STATIC,_loc7_,null,rayHit))
            {
               normal.vAdd(rayHit.normal);
            }
         }
         normal.vNormalize();
         this.copyToVector3D(param1,position3D);
         this.copyToVector3D(normal,normal3D);
         _loc9_ = this.getRotation(param6);
         return param5.createDecal(position3D,normal3D,param3,_loc9_,ANGLE_LIMIT,300,param4);
      }
	  
	  public function createS(param1:Vector3, param2:Vector3, param3:Object3D, param4:TextureMaterial, param5:KDContainer, param6:RotationState) : Decal
      {
         var _loc8_:Vector3 = null;
         var _loc9_:Number = NaN;
         direction.vDiff(param1,param2);
         var _loc7_:Number = direction.vLength() + 200;
         direction.vNormalize();
         right.vCross2(direction,Vector3.Z_AXIS).vNormalize();
         up.vCross2(right,direction);
         Vector3(origins[4]).vCopy(param2);
         Vector3(origins[0]).vCopy(param2).vAddScaled(50,right);
         Vector3(origins[1]).vCopy(param2).vAddScaled(50,up);
         Vector3(origins[2]).vCopy(param2).vAddScaled(-50,right);
         Vector3(origins[3]).vCopy(param2).vAddScaled(-50,up);
         normal.reset(0,0,0);
         for each(_loc8_ in origins)
         {
            if(this.collisionDetector.intersectRayWithStatic(_loc8_,direction,CollisionGroup.STATIC,_loc7_,null,rayHit))
            {
               normal.vAdd(rayHit.normal);
            }
         }
         normal.vNormalize();
         this.copyToVector3D(param1,position3D);
         this.copyToVector3D(normal,normal3D);
         _loc9_ = this.getRotation(param6);
         return param5.createShad(position3D,normal3D,param3,_loc9_,param4);
      }
      
      public function copyToVector3D(param1:Vector3, param2:Vector3D) : void
      {
         param2.x = param1.x;
         param2.y = param1.y;
         param2.z = param1.z;
      }
      
      private function getRotation(param1:RotationState) : Number
      {
         switch(param1)
         {
            case RotationState.WITHOUT_ROTATION:
               return 0;
            default:
               return Math.random() * 2 * Math.PI;
         }
      }
   }
}
