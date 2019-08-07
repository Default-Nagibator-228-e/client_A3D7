package alternativa.tanks.models.sfx.shoot.thunder
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.display.BlendMode;
   
   use namespace alternativa3d;
   
   public class ThunderShotEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const speed1:Number = 500;
      
      private static const speed2:Number = 1000;
      
      private static const speed3:Number = 1500;
      
      private static const raySpeed1:Number = 1500;
      
      private static const raySpeed2:Number = 2500;
      
      private static const raySpeed3:Number = 1300;
      
      private static var basePoint:Vector3 = new Vector3();
      
      private static var direction:Vector3 = new Vector3();
      
      private static var axis:Vector3 = new Vector3();
      
      private static var eulerAngles:Vector3 = new Vector3();
      
      private static var rayMaterial:FillMaterial = new FillMaterial(4294753806);
      
      private static var turretMatrix:Matrix4 = new Matrix4();
      
      private static var trailMatrix:Matrix3 = new Matrix3();
      
      private static var trailMatrix2:Matrix3 = new Matrix3();
       
      
      private var turret:Object3D;
      
      private var localMuzzlePoint:Vector3;
      
      private var sprite1:Sprite3D;
      
      private var sprite2:Sprite3D;
      
      private var sprite3:Sprite3D;
      
      private var ray1:Trail;
      
      private var ray2:Trail;
      
      private var ray3:Trail;
      
      private var distance1:Number = 40;
      
      private var distance2:Number = 75;
      
      private var distance3:Number = 80;
      
      private var rayDistance1:Number = 0;
      
      private var rayDistance2:Number = 0;
      
      private var rayDistance3:Number = 0;
      
      private var angle1:Number;
      
      private var angle2:Number;
      
      private var angle3:Number;
      
      private var timeToLive:int;
	  
	  private var light:OmniLight;
      
      public function ThunderShotEffect(objectPool:ObjectPool)
      {
         super(objectPool);
         this.createParticles();
		 this.light = new OmniLight(16745512,200,400);
      }
      
      public function init(turret:Object3D, muzzleLocalPoint:Vector3, material:Material) : void
      {
         this.turret = turret;
         this.localMuzzlePoint = muzzleLocalPoint;
         this.sprite1.material = material;
         this.sprite2.material = material;
         this.sprite3.material = material;
         this.timeToLive = 50;
         this.distance1 = 40;
         this.distance2 = 75;
         this.distance3 = 80;
         this.rayDistance1 = 0;
         this.rayDistance2 = 0;
         this.rayDistance3 = 0;
         this.angle1 = Math.random() * 2 * Math.PI;
         this.angle2 = Math.random() * 2 * Math.PI;
         this.angle3 = Math.random() * 2 * Math.PI;
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         container.addChild(this.sprite1);
         container.addChild(this.sprite2);
         container.addChild(this.sprite3);
		 container.addChild(this.light);
         container.addChild(this.ray1);
         container.addChild(this.ray2);
         container.addChild(this.ray3);
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         if(this.timeToLive < 0)
         {
            return false;
         }
         turretMatrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         turretMatrix.transformVector(this.localMuzzlePoint,basePoint);
         direction.x = turretMatrix.b;
         direction.y = turretMatrix.f;
         direction.z = turretMatrix.j;
         var dt:Number = 0.001 * millis;
         this.rayDistance1 = this.rayDistance1 + dt * raySpeed1;
         this.rayDistance2 = this.rayDistance2 + dt * raySpeed2;
         this.rayDistance3 = this.rayDistance3 + dt * raySpeed3;
         this.setSpritePosition(this.sprite1,basePoint,direction,this.distance1);
         this.setSpritePosition(this.sprite2,basePoint,direction,this.distance2);
         this.setSpritePosition(this.sprite3, basePoint, direction, this.distance3);
		 light.x = basePoint.x + direction.x * distance3;
         light.y = basePoint.y + direction.y * distance3;
         light.z = basePoint.z + direction.z * distance3;
         this.setRayMatrix(this.ray1,this.angle1,basePoint,direction,this.rayDistance1,0,10);
         this.setRayMatrix(this.ray2,this.angle2,basePoint,direction,this.rayDistance2,-7,0);
         this.setRayMatrix(this.ray3,this.angle3,basePoint,direction,this.rayDistance3,7,0);
         this.distance1 = this.distance1 + dt * speed1;
         this.distance2 = this.distance2 + dt * speed2;
         this.distance3 = this.distance3 + dt * speed3;
         this.timeToLive = this.timeToLive - millis;
         return true;
      }
      
      public function destroy() : void
      {
         this.sprite1.removeFromParent();
         this.sprite2.removeFromParent();
         this.sprite3.removeFromParent();
         this.ray1.removeFromParent();
         this.ray2.removeFromParent();
         this.ray3.removeFromParent();
		 this.light.removeFromParent();
         storeInPool();
      }
      
      public function kill() : void
      {
         this.timeToLive = -1;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      override protected function getClass() : Class
      {
         return ThunderShotEffect;
      }
      
      private function createParticles() : void
      {
         this.sprite1 = this.createSprite(120);
         this.sprite2 = this.createSprite(99.75);
         this.sprite3 = this.createSprite(79.5);
         this.ray1 = new Trail(0.8,rayMaterial);
         this.ray2 = new Trail(0.75,rayMaterial);
         this.ray3 = new Trail(0.82,rayMaterial);
      }
      
      private function createSprite(size:Number) : Sprite3D
      {
         var sprite:Sprite3D = new Sprite3D(size,size);
         sprite.rotation = 2 * Math.PI * Math.random();
         sprite.blendMode = BlendMode.SCREEN;
		 sprite.useLight = true;
		 sprite.useDepth = false;
		 sprite.useShadowMap = false;
         return sprite;
      }
      
      private function setSpritePosition(sprite:Sprite3D, basePoint:Vector3, dir:Vector3, distance:Number) : void
      {
         sprite.x = basePoint.x + dir.x * distance;
         sprite.y = basePoint.y + dir.y * distance;
         sprite.z = basePoint.z + dir.z * distance;
      }
      
      private function setRayMatrix(ray:Mesh, angle:Number, basePoint:Vector3, dir:Vector3, distance:Number, dx:Number, dz:Number) : void
      {
         trailMatrix.fromAxisAngle(Vector3.Y_AXIS,angle);
         if(dir.y < -0.99999 || dir.y > 0.99999)
         {
            axis.x = 0;
            axis.y = 0;
            axis.z = 1;
            angle = dir.y < 0?Number(Math.PI):Number(0);
         }
         else
         {
            axis.x = dir.z;
            axis.y = 0;
            axis.z = -dir.x;
            axis.vNormalize();
            angle = Math.acos(dir.y);
         }
         trailMatrix2.fromAxisAngle(axis,angle);
         trailMatrix.append(trailMatrix2);
         trailMatrix.getEulerAngles(eulerAngles);
         ray.rotationX = eulerAngles.x;
         ray.rotationY = eulerAngles.y;
         ray.rotationZ = eulerAngles.z;
         ray.x = basePoint.x + dir.x * distance + dx * trailMatrix.a + dz * trailMatrix.c;
         ray.y = basePoint.y + dir.y * distance + dx * trailMatrix.e + dz * trailMatrix.g;
         ray.z = basePoint.z + dir.z * distance + dx * trailMatrix.i + dz * trailMatrix.k;
      }
   }
}

import alternativa.engine3d.alternativa3d;
import alternativa.engine3d.core.Face;
import alternativa.engine3d.core.Vertex;
import alternativa.engine3d.core.Wrapper;
import alternativa.engine3d.materials.Material;
import alternativa.engine3d.objects.Mesh;
import flash.display.BlendMode;

use namespace alternativa3d;

class Trail extends Mesh
{
    
   
   function Trail(scale:Number, material:Material)
   {
      super();
      var w:Number = 4;
      var h:Number = 240 * scale;
      var a:Vertex = this.createVertex(-w,0,0,0,0);
      var b:Vertex = this.createVertex(w,0,0,0,1);
      var c:Vertex = this.createVertex(0,h,0,1,0.5);
      this.createFace(a,b,c).material = material;
      this.createFace(c,b,a).material = material;
      calculateFacesNormals(true);
      calculateBounds();
      blendMode = BlendMode.SCREEN;
      alpha = 0.3;
	  this.useDepth = false;
	  this.useLight = false;
	  this.useShadowMap = false;
   }
   
   private function createVertex(x:Number, y:Number, z:Number, u:Number, v:Number) : Vertex
   {
      var newVertex:Vertex = new Vertex();
      newVertex.next = vertexList;
      vertexList = newVertex;
      newVertex.x = x;
      newVertex.y = y;
      newVertex.z = z;
      newVertex.u = u;
      newVertex.v = v;
      return newVertex;
   }
   
   private function createFace(a:Vertex, b:Vertex, c:Vertex) : Face
   {
      var newFace:Face = new Face();
      newFace.next = faceList;
      faceList = newFace;
      newFace.wrapper = new Wrapper();
      newFace.wrapper.vertex = a;
      newFace.wrapper.next = new Wrapper();
      newFace.wrapper.next.vertex = b;
      newFace.wrapper.next.next = new Wrapper();
      newFace.wrapper.next.next.vertex = c;
      return newFace;
   }
}
