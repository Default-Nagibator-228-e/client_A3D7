package alternativa.proplib.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Occluder;
   import alternativa.proplib.utils.ByteArrayMap;
   import alternativa.proplib.utils.TextureByteDataMap;
   import utils.textureutils.TextureByteData;
   import flash.utils.ByteArray;
   
   public class PropMesh extends PropObject
   {
      
      public static const DEFAULT_TEXTURE:String = "$$$_DEFAULT_TEXTURE_$$$";
      
      public static var threshold:Number = 0.01;
      
      public static var occluderDistanceThreshold:Number = 0.01;
      
      public static var occluderAngleThreshold:Number = 0.01;
      
      public static var occluderConvexThreshold:Number = 0.01;
      
      public static var occluderUvThreshold:int = 1;
      
      public static var meshDistanceThreshold:Number = 0.001;
      
      public static var meshUvThreshold:Number = 0.001;
      
      public static var meshAngleThreshold:Number = 0.001;
      
      public static var meshConvexThreshold:Number = 0.01;
       
      
      public var textures:TextureByteDataMap;
      
      public var occluders:Vector.<Occluder>;
      
      public function PropMesh(param1:ByteArray, param2:String, param3:Object, param4:ByteArrayMap, param5:TextureByteDataMap)
      {
         super(PropObjectType.MESH);
         this.parseModel(param1,param2,param3,param4,param5);
      }
      
      private function parseModel(param1:ByteArray, param2:String, param3:Object, param4:ByteArrayMap, param5:TextureByteDataMap) : void
      {
         var _loc8_:* = null;
         var _loc9_:String = null;
         var _loc10_:TextureByteData = null;
         var _loc6_:Mesh = this.processObjects(param1,param2);
         this.initMesh(_loc6_);
         this.object = _loc6_;
         var _loc7_:String = this.getTextureFileName(_loc6_);
         if(_loc7_ == null && param3 == null)
         {
            throw new Error("PropMesh: no textures found");
         }
         if(param3 == null)
         {
            param3 = {};
         }
         if(_loc7_ != null)
         {
            param3[PropMesh.DEFAULT_TEXTURE] = _loc7_;
         }
         this.textures = new TextureByteDataMap();
         for(_loc8_ in param3)
         {
            _loc9_ = param3[_loc8_];
            if(param5 == null)
            {
               _loc10_ = new TextureByteData(param4.getValue(_loc9_),null);
            }
            else
            {
               _loc10_ = param5.getValue(_loc9_);
            }
            this.textures.putValue(_loc8_,_loc10_);
         }
      }
      
      private function processObjects(param1:ByteArray, param2:String) : Mesh
      {
         var _loc8_:Object3D = null;
         var _loc9_:String = null;
         param1.position = 0;
         var _loc3_:Parser3DS = new Parser3DS();
         _loc3_.parse(param1);
         var _loc4_:Vector.<Object3D> = _loc3_.objects;
         var _loc5_:int = _loc4_.length;
         var _loc6_:Mesh = null;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = _loc4_[_loc7_];
            _loc9_ = _loc8_.name.toLowerCase();
            if(_loc9_.indexOf("occl") == 0)
            {
               this.addOccluder(Mesh(_loc8_));
            }
            else if(param2 == _loc9_)
            {
               _loc6_ = Mesh(_loc8_);
            }
            _loc7_++;
         }
         return _loc6_ != null?_loc6_:Mesh(_loc4_[0]);
      }
      
      private function getTextureFileName(param1:Mesh) : String
      {
         var _loc3_:TextureMaterial = null;
         var _loc2_:Face = param1.alternativa3d::faceList;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.material as TextureMaterial;
            if(_loc3_ != null)
            {
               return _loc3_.diffuseMapURL.toLowerCase();
            }
            _loc2_ = _loc2_.alternativa3d::next;
         }
         return null;
      }
      
      private function addOccluder(param1:Mesh) : void
      {
         param1.weldVertices(occluderDistanceThreshold,occluderUvThreshold);
         param1.weldFaces(occluderAngleThreshold,occluderUvThreshold,occluderConvexThreshold);
         var _loc2_:Occluder = new Occluder();
         _loc2_.createForm(param1,true);
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.z = param1.z;
         _loc2_.rotationX = param1.rotationX;
         _loc2_.rotationY = param1.rotationY;
         _loc2_.rotationZ = param1.rotationZ;
         if(this.occluders == null)
         {
            this.occluders = new Vector.<Occluder>();
         }
         this.occluders.push(_loc2_);
      }
      
      private function initMesh(param1:Mesh) : void
      {
         param1.weldVertices(meshDistanceThreshold,meshUvThreshold);
         param1.weldFaces(meshAngleThreshold,meshUvThreshold,meshConvexThreshold);
         param1.threshold = threshold;
      }
      
      override public function traceProp() : void
      {
         var _loc1_:* = null;
         var _loc2_:TextureByteData = null;
         super.traceProp();
         for(_loc1_ in this.textures)
         {
            _loc2_ = this.textures[_loc1_];
         }
      }
   }
}