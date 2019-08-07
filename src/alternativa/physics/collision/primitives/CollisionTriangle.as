package alternativa.physics.collision.primitives
{
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.types.BoundBox;
   
   public class CollisionTriangle extends CollisionPrimitive
   {
       
      
      public var v0:Vector3;
      
      public var v1:Vector3;
      
      public var v2:Vector3;
      
      public var e0:Vector3;
      
      public var e1:Vector3;
      
      public var e2:Vector3;
      
      public function CollisionTriangle(v0:Vector3, v1:Vector3, v2:Vector3, collisionGroup:int)
      {
         this.v0 = new Vector3();
         this.v1 = new Vector3();
         this.v2 = new Vector3();
         this.e0 = new Vector3();
         this.e1 = new Vector3();
         this.e2 = new Vector3();
         super(TRIANGLE,collisionGroup);
         this.initVertices(v0,v1,v2);
      }
      
      override public function calculateAABB() : BoundBox
      {
         var a:Number = NaN;
         var b:Number = NaN;
         var epsilon:Number = 0.005;
         var eps_c:Number = epsilon * transform.c;
         var eps_g:Number = epsilon * transform.g;
         var eps_k:Number = epsilon * transform.k;
         a = this.v0.x * transform.a + this.v0.y * transform.b;
         aabb.minX = aabb.maxX = a + eps_c;
         b = a - eps_c;
         if(b > aabb.maxX)
         {
            aabb.maxX = b;
         }
         else if(b < aabb.minX)
         {
            aabb.minX = b;
         }
         a = this.v0.x * transform.e + this.v0.y * transform.f;
         aabb.minY = aabb.maxY = a + eps_g;
         b = a - eps_g;
         if(b > aabb.maxY)
         {
            aabb.maxY = b;
         }
         else if(b < aabb.minY)
         {
            aabb.minY = b;
         }
         a = this.v0.x * transform.i + this.v0.y * transform.j;
         aabb.minZ = aabb.maxZ = a + eps_k;
         b = a - eps_k;
         if(b > aabb.maxZ)
         {
            aabb.maxZ = b;
         }
         else if(b < aabb.minZ)
         {
            aabb.minZ = b;
         }
         a = this.v1.x * transform.a + this.v1.y * transform.b;
         b = a + eps_c;
         if(b > aabb.maxX)
         {
            aabb.maxX = b;
         }
         else if(b < aabb.minX)
         {
            aabb.minX = b;
         }
         b = a - eps_c;
         if(b > aabb.maxX)
         {
            aabb.maxX = b;
         }
         else if(b < aabb.minX)
         {
            aabb.minX = b;
         }
         a = this.v1.x * transform.e + this.v1.y * transform.f;
         b = a + eps_g;
         if(b > aabb.maxY)
         {
            aabb.maxY = b;
         }
         else if(b < aabb.minY)
         {
            aabb.minY = b;
         }
         b = a - eps_g;
         if(b > aabb.maxY)
         {
            aabb.maxY = b;
         }
         else if(b < aabb.minY)
         {
            aabb.minY = b;
         }
         a = this.v1.x * transform.i + this.v1.y * transform.j;
         b = a + eps_k;
         if(b > aabb.maxZ)
         {
            aabb.maxZ = b;
         }
         else if(b < aabb.minZ)
         {
            aabb.minZ = b;
         }
         b = a - eps_k;
         if(b > aabb.maxZ)
         {
            aabb.maxZ = b;
         }
         else if(b < aabb.minZ)
         {
            aabb.minZ = b;
         }
         a = this.v2.x * transform.a + this.v2.y * transform.b;
         b = a + eps_c;
         if(b > aabb.maxX)
         {
            aabb.maxX = b;
         }
         else if(b < aabb.minX)
         {
            aabb.minX = b;
         }
         b = a - eps_c;
         if(b > aabb.maxX)
         {
            aabb.maxX = b;
         }
         else if(b < aabb.minX)
         {
            aabb.minX = b;
         }
         a = this.v2.x * transform.e + this.v2.y * transform.f;
         b = a + eps_g;
         if(b > aabb.maxY)
         {
            aabb.maxY = b;
         }
         else if(b < aabb.minY)
         {
            aabb.minY = b;
         }
         b = a - eps_g;
         if(b > aabb.maxY)
         {
            aabb.maxY = b;
         }
         else if(b < aabb.minY)
         {
            aabb.minY = b;
         }
         a = this.v2.x * transform.i + this.v2.y * transform.j;
         b = a + eps_k;
         if(b > aabb.maxZ)
         {
            aabb.maxZ = b;
         }
         else if(b < aabb.minZ)
         {
            aabb.minZ = b;
         }
         b = a - eps_k;
         if(b > aabb.maxZ)
         {
            aabb.maxZ = b;
         }
         else if(b < aabb.minZ)
         {
            aabb.minZ = b;
         }
         aabb.minX = aabb.minX + transform.d;
         aabb.maxX = aabb.maxX + transform.d;
         aabb.minY = aabb.minY + transform.h;
         aabb.maxY = aabb.maxY + transform.h;
         aabb.minZ = aabb.minZ + transform.l;
         aabb.maxZ = aabb.maxZ + transform.l;
         return aabb;
      }
      
      override public function getRayIntersection(origin:Vector3, vector:Vector3, epsilon:Number, normal:Vector3) : Number
      {
         var t:Number = NaN;
         var vz:Number = vector.x * transform.c + vector.y * transform.g + vector.z * transform.k;
         if(vz < epsilon && vz > -epsilon)
         {
            return -1;
         }
         var tx:Number = origin.x - transform.d;
         var ty:Number = origin.y - transform.h;
         var tz:Number = origin.z - transform.l;
         var oz:Number = tx * transform.c + ty * transform.g + tz * transform.k;
         t = -oz / vz;
         if(t < 0)
         {
            return -1;
         }
         var ox:Number = tx * transform.a + ty * transform.e + tz * transform.i;
         var oy:Number = tx * transform.b + ty * transform.f + tz * transform.j;
         tx = ox + t * (vector.x * transform.a + vector.y * transform.e + vector.z * transform.i);
         ty = oy + t * (vector.x * transform.b + vector.y * transform.f + vector.z * transform.j);
         tz = oz + t * vz;
         if(this.e0.x * (ty - this.v0.y) - this.e0.y * (tx - this.v0.x) < 0 || this.e1.x * (ty - this.v1.y) - this.e1.y * (tx - this.v1.x) < 0 || this.e2.x * (ty - this.v2.y) - this.e2.y * (tx - this.v2.x) < 0)
         {
            return -1;
         }
         normal.x = transform.c;
         normal.y = transform.g;
         normal.z = transform.k;
         return t;
      }
      
      override public function copyFrom(source:CollisionPrimitive) : CollisionPrimitive
      {
         super.copyFrom(source);
         var tri:CollisionTriangle = source as CollisionTriangle;
         if(tri != null)
         {
            this.v0.vCopy(tri.v0);
            this.v1.vCopy(tri.v1);
            this.v2.vCopy(tri.v2);
            this.e0.vCopy(tri.e0);
            this.e1.vCopy(tri.e1);
            this.e2.vCopy(tri.e2);
         }
         return this;
      }
      
      override public function toString() : String
      {
         return "[CollisionTriangle v0=" + this.v0 + ", v1=" + this.v1 + ", v2=" + this.v2 + "]";
      }
      
      override protected function createPrimitive() : CollisionPrimitive
      {
         return new CollisionTriangle(this.v0,this.v1,this.v2,collisionGroup);
      }
      
      private function initVertices(v0:Vector3, v1:Vector3, v2:Vector3) : void
      {
         this.v0.vCopy(v0);
         this.v1.vCopy(v1);
         this.v2.vCopy(v2);
         this.e0.vDiff(v1,v0);
         this.e0.vNormalize();
         this.e1.vDiff(v2,v1);
         this.e1.vNormalize();
         this.e2.vDiff(v0,v2);
         this.e2.vNormalize();
      }
   }
}
