package alternativa.tanks.models.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   
   use namespace alternativa3d;
   
   public class SimplePlane extends Mesh
   {
       
      
      private var a:Vertex;
      
      private var b:Vertex;
      
      private var c:Vertex;
      
      private var d:Vertex;
      
      private var face:Face;
      
      private var originX:Number;
      
      private var originY:Number;
      
      public function SimplePlane(width:Number, length:Number, originX:Number, originY:Number)
      {
         super();
         this.originX = originX;
         this.originY = originY;
         boundMinX = -originX * width;
         boundMaxX = boundMinX + width;
         boundMinY = -originY * length;
         boundMaxY = boundMinY + length;
         boundMinZ = 0;
         boundMaxZ = 0;
         this.a = this.createVertex(boundMinX,boundMinY,0,0,1);
         this.b = this.createVertex(boundMaxX,boundMinY,0,1,1);
         this.c = this.createVertex(boundMaxX,boundMaxY,0,1,0);
         this.d = this.createVertex(boundMinX,boundMaxY,0,0,0);
         this.face = this.createQuad(this.a,this.b,this.c,this.d);
         calculateFacesNormals();
      }
      
      public function setUVs(ua:Number, va:Number, ub:Number, vb:Number, uc:Number, vc:Number, ud:Number, vd:Number) : void
      {
         this.a.u = ua;
         this.a.v = va;
         this.b.u = ub;
         this.b.v = vb;
         this.c.u = uc;
         this.c.v = vc;
         this.d.u = ud;
         this.d.v = vd;
      }
      
      public function set material(value:Material) : void
      {
         this.face.material = value;
      }
      
      public function set width(value:Number) : void
      {
         boundMinX = this.a.x = this.d.x = -this.originX * value;
         boundMaxX = this.b.x = this.c.x = boundMinX + value;
      }
      
      public function get length() : Number
      {
         return boundMaxY - boundMinY;
      }
      
      public function set length(value:Number) : void
      {
         boundMinY = this.a.y = this.b.y = -this.originY * value;
         boundMaxY = this.d.y = this.c.y = boundMinY + value;
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
      
      private function createQuad(a:Vertex, b:Vertex, c:Vertex, d:Vertex) : Face
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
         newFace.wrapper.next.next.next = new Wrapper();
         newFace.wrapper.next.next.next.vertex = d;
         return newFace;
      }
   }
}
