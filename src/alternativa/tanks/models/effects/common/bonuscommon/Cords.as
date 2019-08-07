package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   
   use namespace alternativa3d;
   
   public class Cords extends Mesh
   {
      
      private static var meshMatrix:Matrix4 = new Matrix4();
       
      
      private var box:Object3D;
      
      private var parachute:Object3D;
      
      private var numStraps:int;
      
      private var topVertices:Vector.<Vertex>;
      
      private var topLocalPoints:Vector.<Vector3>;
      
      private var boxVertex:Vertex;
      
      private var boxLocalPoint:Vector3;
      
      public function Cords(radius:Number, boxHalfSize:Number, numStraps:int, box:Object3D, parachute:Object3D)
      {
         super();
         this.box = box;
         this.parachute = parachute;
         this.numStraps = numStraps;
         this.topVertices = new Vector.<Vertex>(2 * numStraps);
         this.topLocalPoints = new Vector.<Vector3>(numStraps);
         this.createGeometry(radius,boxHalfSize);
      }
      
      public function updateVertices() : void
      {
         var point:Vector3 = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         var v:Vertex = null;
         meshMatrix.setMatrix(this.parachute.x,this.parachute.y,this.parachute.z,this.parachute.rotationX,this.parachute.rotationY,this.parachute.rotationZ);
         for(var i:int = 0; i < this.numStraps; i++)
         {
            point = this.topLocalPoints[i];
            x = point.x * meshMatrix.a + point.y * meshMatrix.b + point.z * meshMatrix.c + meshMatrix.d;
            y = point.x * meshMatrix.e + point.y * meshMatrix.f + point.z * meshMatrix.g + meshMatrix.h;
            z = point.x * meshMatrix.i + point.y * meshMatrix.j + point.z * meshMatrix.k + meshMatrix.l;
            v = this.topVertices[2 * i];
            v.x = x;
            v.y = y;
            v.z = z;
            v = this.topVertices[2 * i + 1];
            v.x = x;
            v.y = y;
            v.z = z;
         }
         meshMatrix.setMatrix(this.box.x,this.box.y,this.box.z,this.box.rotationX,this.box.rotationY,this.box.rotationZ);
         point = this.boxLocalPoint;
         this.boxVertex.x = point.x * meshMatrix.a + point.y * meshMatrix.b + point.z * meshMatrix.c + meshMatrix.d;
         this.boxVertex.y = point.x * meshMatrix.e + point.y * meshMatrix.f + point.z * meshMatrix.g + meshMatrix.h;
         this.boxVertex.z = point.x * meshMatrix.i + point.y * meshMatrix.j + point.z * meshMatrix.k + meshMatrix.l;
         calculateBounds();
         calculateFacesNormals();
      }
      
      private function createGeometry(radius:Number, boxHalfSize:Number) : void
      {
         var angle:Number = NaN;
         var localPoint:Vector3 = null;
         var firstIndex:int = 0;
         var secondIndex:int = 0;
         this.boxLocalPoint = new Vector3(0,0,boxHalfSize);
         this.boxVertex = this.createVertex(0,0,boxHalfSize,0,1);
         var angleStep:Number = 2 * Math.PI / this.numStraps;
         for(var i:int = 0; i < this.numStraps; i++)
         {
            angle = i * angleStep;
            localPoint = new Vector3(radius * Math.cos(angle),radius * Math.sin(angle),0);
            this.topLocalPoints[i] = localPoint;
            this.topVertices[2 * i] = this.createVertex(localPoint.x,localPoint.y,localPoint.z,0,0);
            this.topVertices[2 * i + 1] = this.createVertex(localPoint.x,localPoint.y,localPoint.z,1,1);
         }
         for(var faceIndex:int = 0; faceIndex < this.numStraps; faceIndex++)
         {
            firstIndex = 2 * faceIndex;
            secondIndex = firstIndex + 3;
            if(secondIndex >= 2 * this.numStraps)
            {
               secondIndex = secondIndex - 2 * this.numStraps;
            }
            this.createTriFace(this.boxVertex,this.topVertices[firstIndex],this.topVertices[secondIndex]);
            this.createTriFace(this.boxVertex,this.topVertices[secondIndex],this.topVertices[firstIndex]);
         }
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
      
      private function createTriFace(a:Vertex, b:Vertex, c:Vertex) : Face
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
}
