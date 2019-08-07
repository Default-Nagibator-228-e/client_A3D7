package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.UVMatrixProvider;
   import alternativa.tanks.materials.TrackMaterial;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   public class TrackSkin
   {
       
      
      private var uvsProvider:UVMatrixProvider;
      
      private var faces:Vector.<Face>;
      
      private var vertices:Vector.<Vertex>;
      
      private var ratio:Number;
      
      private var distance:Number = 0;
      
      public var material:TrackMaterial;
      
      public function TrackSkin()
      {
         this.faces = new Vector.<Face>();
         super();
      }
      
      private static function getRatio(param1:Face) : Number
      {
         var _loc2_:Vector.<Vertex> = param1.vertices;
         return getRatioForVertices(_loc2_[0],_loc2_[1]);
      }
      
      private static function getRatioForVertices(param1:Vertex, param2:Vertex) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         var _loc5_:Number = param1.z - param2.z;
         var vertexDistanceXYZ:Number = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
         var _loc7_:Number = param1.u - param2.u;
         var _loc8_:Number = param1.v - param2.v;
         var vertexDistanceUV:Number = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
         return vertexDistanceUV / vertexDistanceXYZ;
      }
      
      public function addFace(param1:Face) : void
      {
         this.faces.push(param1);
      }
      
      public function init() : void
      {
         var polygon:Face = null;
         var newVertex:* = undefined;
         var vertex:Vertex = null;
         var co:Number = 0;
         var dictionary:Dictionary = new Dictionary();
         for each(polygon in this.faces)
         {
            for each(vertex in polygon.vertices)
            {
               dictionary[vertex] = true;
            }
            co = co + getRatio(polygon);
         }
         this.ratio = co / this.faces.length;
         this.vertices = new Vector.<Vertex>();
         for(newVertex in dictionary)
         {
            this.vertices.push(newVertex);
         }
      }
      
      public function move(param1:Number) : void
      {
         var _loc2_:Matrix = null;
         this.distance = this.distance + param1 * this.ratio;
         if(this.uvsProvider != null)
         {
            _loc2_ = this.uvsProvider.getMatrix();
            _loc2_.tx = this.distance;
         }
      }
      
      public function setMaterial(param1:Material) : void
      {
         param1.name = "tracks";
         var _loc2_:Face = null;
         var _loc3_:TrackMaterial = null;
         for each(_loc2_ in this.faces)
         {
            _loc2_.material = param1;
         }
         if(param1 is TrackMaterial)
         {
            this.material = param1 as TrackMaterial;
            _loc3_ = param1 as TrackMaterial;
            this.uvsProvider = _loc3_.uvMatrixProvider;
         }
      }
   }
}
