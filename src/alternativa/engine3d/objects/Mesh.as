package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.RayIntersectionData;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.gfx.core.BitmapTextureResource;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class Mesh extends Object3D
   {
       
      
      public var clipping:int = 2;
      
      public var sorting:int = 1;
      
      public var threshold:Number = 0.01;
      
      alternativa3d var vertexList:Vertex;
      
      alternativa3d var faceList:Face;
      
      alternativa3d var vertexBuffer:VertexBufferResource;
      
      alternativa3d var indexBuffer:IndexBufferResource;
      
      alternativa3d var numOpaqueTriangles:int;
      
      alternativa3d var numTriangles:int;
	  
	  alternativa3d var iu:BitmapTextureResource;
      
      protected var opaqueMaterials:Vector.<Material>;
      
      protected var opaqueBegins:Vector.<int>;
      
      protected var opaqueNums:Vector.<int>;
      
      protected var opaqueLength:int = 0;
      
      private var transparentList:Face;
      
      public function Mesh()
      {
         this.opaqueMaterials = new Vector.<Material>();
         this.opaqueBegins = new Vector.<int>();
         this.opaqueNums = new Vector.<int>();
         super();
      }
      
      public static function calculateVerticesNormalsBySmoothingGroupsForMeshList(param1:Vector.<Object3D>, param2:Number = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc8_:Mesh = null;
         var _loc9_:Face = null;
         var _loc10_:Vertex = null;
         var _loc11_:Wrapper = null;
         var _loc16_:Object3D = null;
         var _loc17_:Vertex = null;
         var _loc18_:Number = NaN;
         var _loc19_:* = null;
         var _loc12_:Dictionary = new Dictionary();
         var _loc13_:int = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc13_)
         {
            _loc8_ = param1[_loc3_] as Mesh;
            if(_loc8_ != null)
            {
               _loc8_.deleteResources();
               _loc8_.composeMatrix();
               _loc16_ = _loc8_;
               while(_loc16_._parent != null)
               {
                  _loc16_ = _loc16_._parent;
                  _loc16_.composeMatrix();
                  _loc8_.appendMatrix(_loc16_);
               }
               _loc10_ = _loc8_.vertexList;
               while(_loc10_ != null)
               {
                  _loc4_ = _loc10_.x;
                  _loc5_ = _loc10_.y;
                  _loc6_ = _loc10_.z;
                  _loc10_.x = _loc8_.ma * _loc4_ + _loc8_.mb * _loc5_ + _loc8_.mc * _loc6_ + _loc8_.md;
                  _loc10_.y = _loc8_.me * _loc4_ + _loc8_.mf * _loc5_ + _loc8_.mg * _loc6_ + _loc8_.mh;
                  _loc10_.z = _loc8_.mi * _loc4_ + _loc8_.mj * _loc5_ + _loc8_.mk * _loc6_ + _loc8_.ml;
                  _loc10_ = _loc10_.next;
               }
               _loc8_.calculateNormalsAndRemoveDegenerateFaces();
               _loc9_ = _loc8_.faceList;
               while(_loc9_ != null)
               {
                  if(_loc9_.smoothingGroups > 0)
                  {
                     _loc11_ = _loc9_.wrapper;
                     while(_loc11_ != null)
                     {
                        _loc10_ = _loc11_.vertex;
                        if(!_loc12_[_loc10_])
                        {
                           _loc12_[_loc10_] = new Dictionary();
                        }
                        _loc12_[_loc10_][_loc9_] = true;
                        _loc11_ = _loc11_.next;
                     }
                  }
                  _loc9_ = _loc9_.next;
               }
            }
            _loc3_++;
         }
         var _loc14_:Vector.<Vertex> = new Vector.<Vertex>();
         var _loc15_:int = 0;
         for each(_loc14_[_loc15_] in _loc12_)
         {
            _loc15_++;
         }
         if(_loc15_ > 0)
         {
            shareFaces(_loc14_,0,_loc15_,0,param2,new Vector.<int>(),_loc12_);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc13_)
         {
            _loc8_ = param1[_loc3_] as Mesh;
            if(_loc8_ != null)
            {
               _loc8_.vertexList = null;
               _loc9_ = _loc8_.faceList;
               while(_loc9_ != null)
               {
                  _loc11_ = _loc9_.wrapper;
                  while(_loc11_ != null)
                  {
                     _loc10_ = _loc11_.vertex;
                     _loc17_ = new Vertex();
                     _loc17_.x = _loc10_.x;
                     _loc17_.y = _loc10_.y;
                     _loc17_.z = _loc10_.z;
                     _loc17_.u = _loc10_.u;
                     _loc17_.v = _loc10_.v;
                     _loc17_.id = _loc10_.id;
                     _loc17_.normalX = _loc9_.normalX;
                     _loc17_.normalY = _loc9_.normalY;
                     _loc17_.normalZ = _loc9_.normalZ;
                     if(_loc9_.smoothingGroups > 0)
                     {
                        for(_loc19_ in _loc12_[_loc10_])
                        {
                           if(_loc9_ != _loc19_ && (_loc9_.smoothingGroups & _loc19_.smoothingGroups) > 0)
                           {
                              _loc17_.normalX = _loc17_.normalX + _loc19_.normalX;
                              _loc17_.normalY = _loc17_.normalY + _loc19_.normalY;
                              _loc17_.normalZ = _loc17_.normalZ + _loc19_.normalZ;
                           }
                        }
                        _loc18_ = _loc17_.normalX * _loc17_.normalX + _loc17_.normalY * _loc17_.normalY + _loc17_.normalZ * _loc17_.normalZ;
                        if(_loc18_ > 0.001)
                        {
                           _loc18_ = 1 / Math.sqrt(_loc18_);
                           _loc17_.normalX = _loc17_.normalX * _loc18_;
                           _loc17_.normalY = _loc17_.normalY * _loc18_;
                           _loc17_.normalZ = _loc17_.normalZ * _loc18_;
                        }
                     }
                     _loc11_.vertex = _loc17_;
                     _loc17_.next = _loc8_.vertexList;
                     _loc8_.vertexList = _loc17_;
                     _loc11_ = _loc11_.next;
                  }
                  _loc9_ = _loc9_.next;
               }
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc13_)
         {
            _loc8_ = param1[_loc3_] as Mesh;
            if(_loc8_ != null)
            {
               _loc8_.invertMatrix();
               _loc10_ = _loc8_.vertexList;
               while(_loc10_ != null)
               {
                  _loc4_ = _loc10_.x;
                  _loc5_ = _loc10_.y;
                  _loc6_ = _loc10_.z;
                  _loc10_.x = _loc8_.ma * _loc4_ + _loc8_.mb * _loc5_ + _loc8_.mc * _loc6_ + _loc8_.md;
                  _loc10_.y = _loc8_.me * _loc4_ + _loc8_.mf * _loc5_ + _loc8_.mg * _loc6_ + _loc8_.mh;
                  _loc10_.z = _loc8_.mi * _loc4_ + _loc8_.mj * _loc5_ + _loc8_.mk * _loc6_ + _loc8_.ml;
                  _loc4_ = _loc10_.normalX;
                  _loc5_ = _loc10_.normalY;
                  _loc6_ = _loc10_.normalZ;
                  _loc10_.normalX = _loc8_.ma * _loc4_ + _loc8_.mb * _loc5_ + _loc8_.mc * _loc6_;
                  _loc10_.normalY = _loc8_.me * _loc4_ + _loc8_.mf * _loc5_ + _loc8_.mg * _loc6_;
                  _loc10_.normalZ = _loc8_.mi * _loc4_ + _loc8_.mj * _loc5_ + _loc8_.mk * _loc6_;
                  _loc10_ = _loc10_.next;
               }
               _loc9_ = _loc8_.faceList;
               while(_loc9_ != null)
               {
                  _loc4_ = _loc9_.normalX;
                  _loc5_ = _loc9_.normalY;
                  _loc6_ = _loc9_.normalZ;
                  _loc9_.normalX = _loc8_.ma * _loc4_ + _loc8_.mb * _loc5_ + _loc8_.mc * _loc6_;
                  _loc9_.normalY = _loc8_.me * _loc4_ + _loc8_.mf * _loc5_ + _loc8_.mg * _loc6_;
                  _loc9_.normalZ = _loc8_.mi * _loc4_ + _loc8_.mj * _loc5_ + _loc8_.mk * _loc6_;
                  _loc9_.offset = _loc9_.wrapper.vertex.x * _loc9_.normalX + _loc9_.wrapper.vertex.y * _loc9_.normalY + _loc9_.wrapper.vertex.z * _loc9_.normalZ;
                  _loc9_ = _loc9_.next;
               }
            }
            _loc3_++;
         }
      }
      
      private static function shareFaces(param1:Vector.<Vertex>, param2:int, param3:int, param4:int, param5:Number, param6:Vector.<int>, param7:Dictionary) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Vertex = null;
         var _loc13_:Vertex = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Number = NaN;
         var _loc17_:Vertex = null;
         var _loc18_:Vertex = null;
         var _loc19_:* = undefined;
         switch(param4)
         {
            case 0:
               _loc8_ = param2;
               while(_loc8_ < param3)
               {
                  _loc11_ = param1[_loc8_];
                  _loc11_.offset = _loc11_.x;
                  _loc8_++;
               }
               break;
            case 1:
               _loc8_ = param2;
               while(_loc8_ < param3)
               {
                  _loc11_ = param1[_loc8_];
                  _loc11_.offset = _loc11_.y;
                  _loc8_++;
               }
               break;
            case 2:
               _loc8_ = param2;
               while(_loc8_ < param3)
               {
                  _loc11_ = param1[_loc8_];
                  _loc11_.offset = _loc11_.z;
                  _loc8_++;
               }
         }
         param6[0] = param2;
         param6[1] = param3 - 1;
         var _loc12_:int = 2;
         while(_loc12_ > 0)
         {
            _loc12_--;
            _loc14_ = param6[_loc12_];
            _loc9_ = _loc14_;
            _loc12_--;
            _loc15_ = param6[_loc12_];
            _loc8_ = _loc15_;
            _loc11_ = param1[_loc14_ + _loc15_ >> 1];
            _loc16_ = _loc11_.offset;
            while(_loc8_ <= _loc9_)
            {
               _loc17_ = param1[_loc8_];
               while(_loc17_.offset > _loc16_)
               {
                  _loc8_++;
                  _loc17_ = param1[_loc8_];
               }
               _loc18_ = param1[_loc9_];
               while(_loc18_.offset < _loc16_)
               {
                  _loc9_--;
                  _loc18_ = param1[_loc9_];
               }
               if(_loc8_ <= _loc9_)
               {
                  param1[_loc8_] = _loc18_;
                  param1[_loc9_] = _loc17_;
                  _loc8_++;
                  _loc9_--;
               }
            }
            if(_loc15_ < _loc9_)
            {
               param6[_loc12_] = _loc15_;
               _loc12_++;
               param6[_loc12_] = _loc9_;
               _loc12_++;
            }
            if(_loc8_ < _loc14_)
            {
               param6[_loc12_] = _loc8_;
               _loc12_++;
               param6[_loc12_] = _loc14_;
               _loc12_++;
            }
         }
         _loc8_ = param2;
         _loc11_ = param1[_loc8_];
         _loc9_ = _loc8_ + 1;
         while(_loc9_ <= param3)
         {
            if(_loc9_ < param3)
            {
               _loc13_ = param1[_loc9_];
            }
            if(_loc9_ == param3 || _loc11_.offset - _loc13_.offset > param5)
            {
               if(_loc9_ - _loc8_ > 1)
               {
                  if(param4 < 2)
                  {
                     shareFaces(param1,_loc8_,_loc9_,param4 + 1,param5,param6,param7);
                  }
                  else
                  {
                     _loc10_ = _loc8_ + 1;
                     while(_loc10_ < _loc9_)
                     {
                        _loc13_ = param1[_loc10_];
                        for(_loc19_ in param7[_loc13_])
                        {
                           param7[_loc11_][_loc19_] = true;
                        }
                        _loc10_++;
                     }
                     _loc10_ = _loc8_ + 1;
                     while(_loc10_ < _loc9_)
                     {
                        _loc13_ = param1[_loc10_];
                        for(_loc19_ in param7[_loc11_])
                        {
                           param7[_loc13_][_loc19_] = true;
                        }
                        _loc10_++;
                     }
                  }
               }
               if(_loc9_ < param3)
               {
                  _loc8_ = _loc9_;
                  _loc11_ = param1[_loc8_];
               }
            }
            _loc9_++;
         }
      }
      
      public function addVertex(param1:Number, param2:Number, param3:Number, param4:Number = 0, param5:Number = 0, param6:Object = null) : Vertex
      {
         var _loc8_:Vertex = null;
         this.deleteResources();
         var _loc7_:Vertex = new Vertex();
         _loc7_.x = param1;
         _loc7_.y = param2;
         _loc7_.z = param3;
         _loc7_.u = param4;
         _loc7_.v = param5;
         _loc7_.id = param6;
         if(this.vertexList != null)
         {
            _loc8_ = this.vertexList;
            while(_loc8_.next != null)
            {
               _loc8_ = _loc8_.next;
            }
            _loc8_.next = _loc7_;
         }
         else
         {
            this.vertexList = _loc7_;
         }
         return _loc7_;
      }
      
      public function removeVertex(param1:Vertex) : Vertex
      {
         var _loc3_:Vertex = null;
         var _loc5_:Face = null;
         var _loc6_:Face = null;
         var _loc7_:Wrapper = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter vertex must be non-null.");
         }
         var _loc2_:Vertex = this.vertexList;
         while(_loc2_ != null)
         {
            if(_loc2_ == param1)
            {
               if(_loc3_ != null)
               {
                  _loc3_.next = _loc2_.next;
               }
               else
               {
                  this.vertexList = _loc2_.next;
               }
               _loc2_.next = null;
               break;
            }
            _loc3_ = _loc2_;
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            throw new ArgumentError("Vertex not found.");
         }
         var _loc4_:Face = this.faceList;
         while(_loc4_ != null)
         {
            _loc6_ = _loc4_.next;
            _loc7_ = _loc4_.wrapper;
            while(_loc7_ != null)
            {
               if(_loc7_.vertex == _loc2_)
               {
                  break;
               }
               _loc7_ = _loc7_.next;
            }
            if(_loc7_ != null)
            {
               if(_loc5_ != null)
               {
                  _loc5_.next = _loc6_;
               }
               else
               {
                  this.faceList = _loc6_;
               }
               _loc4_.next = null;
            }
            else
            {
               _loc5_ = _loc4_;
            }
            _loc4_ = _loc6_;
         }
         return _loc2_;
      }
      
      public function removeVertexById(param1:Object) : Vertex
      {
         var _loc3_:Vertex = null;
         var _loc5_:Face = null;
         var _loc6_:Face = null;
         var _loc7_:Wrapper = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         var _loc2_:Vertex = this.vertexList;
         while(_loc2_ != null)
         {
            if(_loc2_.id == param1)
            {
               if(_loc3_ != null)
               {
                  _loc3_.next = _loc2_.next;
               }
               else
               {
                  this.vertexList = _loc2_.next;
               }
               _loc2_.next = null;
               break;
            }
            _loc3_ = _loc2_;
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            throw new ArgumentError("Vertex not found.");
         }
         var _loc4_:Face = this.faceList;
         while(_loc4_ != null)
         {
            _loc6_ = _loc4_.next;
            _loc7_ = _loc4_.wrapper;
            while(_loc7_ != null)
            {
               if(_loc7_.vertex == _loc2_)
               {
                  break;
               }
               _loc7_ = _loc7_.next;
            }
            if(_loc7_ != null)
            {
               if(_loc5_ != null)
               {
                  _loc5_.next = _loc6_;
               }
               else
               {
                  this.faceList = _loc6_;
               }
               _loc4_.next = null;
            }
            else
            {
               _loc5_ = _loc4_;
            }
            _loc4_ = _loc6_;
         }
         return _loc2_;
      }
      
      public function containsVertex(param1:Vertex) : Boolean
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter vertex must be non-null.");
         }
         var _loc2_:Vertex = this.vertexList;
         while(_loc2_ != null)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      public function containsVertexWithId(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         var _loc2_:Vertex = this.vertexList;
         while(_loc2_ != null)
         {
            if(_loc2_.id == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      public function getVertexById(param1:Object) : Vertex
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         var _loc2_:Vertex = this.vertexList;
         while(_loc2_ != null)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
            _loc2_ = _loc2_.next;
         }
         return null;
      }
      
      public function addFace(param1:Vector.<Vertex>, param2:Material = null, param3:Object = null) : Face
      {
         var _loc8_:Wrapper = null;
         var _loc9_:Vertex = null;
         var _loc10_:Face = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter vertices must be non-null.");
         }
         var _loc4_:int = param1.length;
         if(_loc4_ < 3)
         {
            throw new ArgumentError(_loc4_ + " vertices not enough.");
         }
         var _loc5_:Face = new Face();
         _loc5_.material = param2;
         _loc5_.id = param3;
         var _loc6_:Wrapper = null;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc8_ = new Wrapper();
            _loc9_ = param1[_loc7_];
            if(_loc9_ == null)
            {
               throw new ArgumentError("Null vertex in vector.");
            }
            if(!this.containsVertex(_loc9_))
            {
               throw new ArgumentError("Vertex not found.");
            }
            _loc8_.vertex = _loc9_;
            if(_loc6_ != null)
            {
               _loc6_.next = _loc8_;
            }
            else
            {
               _loc5_.wrapper = _loc8_;
            }
            _loc6_ = _loc8_;
            _loc7_++;
         }
         if(this.faceList != null)
         {
            _loc10_ = this.faceList;
            while(_loc10_.next != null)
            {
               _loc10_ = _loc10_.next;
            }
            _loc10_.next = _loc5_;
         }
         else
         {
            this.faceList = _loc5_;
         }
         return _loc5_;
      }
      
      public function addFaceByIds(param1:Array, param2:Material = null, param3:Object = null) : Face
      {
         var _loc8_:Wrapper = null;
         var _loc9_:Vertex = null;
         var _loc10_:Face = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter vertices must be non-null.");
         }
         var _loc4_:int = param1.length;
         if(_loc4_ < 3)
         {
            throw new ArgumentError(_loc4_ + " vertices not enough.");
         }
         var _loc5_:Face = new Face();
         _loc5_.material = param2;
         _loc5_.id = param3;
         var _loc6_:Wrapper = null;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc8_ = new Wrapper();
            _loc9_ = this.getVertexById(param1[_loc7_]);
            if(_loc9_ == null)
            {
               throw new ArgumentError("Vertex not found.");
            }
            _loc8_.vertex = _loc9_;
            if(_loc6_ != null)
            {
               _loc6_.next = _loc8_;
            }
            else
            {
               _loc5_.wrapper = _loc8_;
            }
            _loc6_ = _loc8_;
            _loc7_++;
         }
         if(this.faceList != null)
         {
            _loc10_ = this.faceList;
            while(_loc10_.next != null)
            {
               _loc10_ = _loc10_.next;
            }
            _loc10_.next = _loc5_;
         }
         else
         {
            this.faceList = _loc5_;
         }
         return _loc5_;
      }
      
      public function addTriFace(param1:Vertex, param2:Vertex, param3:Vertex, param4:Material = null, param5:Object = null) : Face
      {
         var _loc7_:Face = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter v1 must be non-null.");
         }
         if(param2 == null)
         {
            throw new TypeError("Parameter v2 must be non-null.");
         }
         if(param3 == null)
         {
            throw new TypeError("Parameter v3 must be non-null.");
         }
         if(!this.containsVertex(param1))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(param2))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(param3))
         {
            throw new ArgumentError("Vertex not found.");
         }
         var _loc6_:Face = new Face();
         _loc6_.material = param4;
         _loc6_.id = param5;
         _loc6_.wrapper = new Wrapper();
         _loc6_.wrapper.vertex = param1;
         _loc6_.wrapper.next = new Wrapper();
         _loc6_.wrapper.next.vertex = param2;
         _loc6_.wrapper.next.next = new Wrapper();
         _loc6_.wrapper.next.next.vertex = param3;
         if(this.faceList != null)
         {
            _loc7_ = this.faceList;
            while(_loc7_.next != null)
            {
               _loc7_ = _loc7_.next;
            }
            _loc7_.next = _loc6_;
         }
         else
         {
            this.faceList = _loc6_;
         }
         return _loc6_;
      }
      
      public function addQuadFace(param1:Vertex, param2:Vertex, param3:Vertex, param4:Vertex, param5:Material = null, param6:Object = null) : Face
      {
         var _loc8_:Face = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter v1 must be non-null.");
         }
         if(param2 == null)
         {
            throw new TypeError("Parameter v2 must be non-null.");
         }
         if(param3 == null)
         {
            throw new TypeError("Parameter v3 must be non-null.");
         }
         if(param4 == null)
         {
            throw new TypeError("Parameter v4 must be non-null.");
         }
         if(!this.containsVertex(param1))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(param2))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(param3))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(param4))
         {
            throw new ArgumentError("Vertex not found.");
         }
         var _loc7_:Face = new Face();
         _loc7_.material = param5;
         _loc7_.id = param6;
         _loc7_.wrapper = new Wrapper();
         _loc7_.wrapper.vertex = param1;
         _loc7_.wrapper.next = new Wrapper();
         _loc7_.wrapper.next.vertex = param2;
         _loc7_.wrapper.next.next = new Wrapper();
         _loc7_.wrapper.next.next.vertex = param3;
         _loc7_.wrapper.next.next.next = new Wrapper();
         _loc7_.wrapper.next.next.next.vertex = param4;
         if(this.faceList != null)
         {
            _loc8_ = this.faceList;
            while(_loc8_.next != null)
            {
               _loc8_ = _loc8_.next;
            }
            _loc8_.next = _loc7_;
         }
         else
         {
            this.faceList = _loc7_;
         }
         return _loc7_;
      }
      
      public function removeFace(param1:Face) : Face
      {
         var _loc3_:Face = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter face must be non-null.");
         }
         var _loc2_:Face = this.faceList;
         while(_loc2_ != null)
         {
            if(_loc2_ == param1)
            {
               if(_loc3_ != null)
               {
                  _loc3_.next = _loc2_.next;
               }
               else
               {
                  this.faceList = _loc2_.next;
               }
               _loc2_.next = null;
               break;
            }
            _loc3_ = _loc2_;
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            throw new ArgumentError("Face not found.");
         }
         return _loc2_;
      }
      
      public function removeFaceById(param1:Object) : Face
      {
         var _loc3_:Face = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         var _loc2_:Face = this.faceList;
         while(_loc2_ != null)
         {
            if(_loc2_.id == param1)
            {
               if(_loc3_ != null)
               {
                  _loc3_.next = _loc2_.next;
               }
               else
               {
                  this.faceList = _loc2_.next;
               }
               _loc2_.next = null;
               break;
            }
            _loc3_ = _loc2_;
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            throw new ArgumentError("Face not found.");
         }
         return _loc2_;
      }
      
      public function containsFace(param1:Face) : Boolean
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter face must be non-null.");
         }
         var _loc2_:Face = this.faceList;
         while(_loc2_ != null)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      public function containsFaceWithId(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         var _loc2_:Face = this.faceList;
         while(_loc2_ != null)
         {
            if(_loc2_.id == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      public function getFaceById(param1:Object) : Face
      {
         if(param1 == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         var _loc2_:Face = this.faceList;
         while(_loc2_ != null)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
            _loc2_ = _loc2_.next;
         }
         return null;
      }
      
      public function addVerticesAndFaces(param1:Vector.<Number>, param2:Vector.<Number>, param3:Vector.<int>, param4:Boolean = false, param5:Material = null) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc11_:Vertex = null;
         var _loc13_:Face = null;
         var _loc14_:Face = null;
         var _loc15_:Wrapper = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Vertex = null;
         var _loc19_:Wrapper = null;
         this.deleteResources();
         if(param1 == null)
         {
            throw new TypeError("Parameter vertices must be non-null.");
         }
         if(param2 == null)
         {
            throw new TypeError("Parameter uvs must be non-null.");
         }
         if(param3 == null)
         {
            throw new TypeError("Parameter indices must be non-null.");
         }
         var _loc9_:int = param1.length / 3;
         if(_loc9_ != param2.length / 2)
         {
            throw new ArgumentError("Vertices count and uvs count doesn\'t match.");
         }
         var _loc10_:int = param3.length;
         if(!param4 && _loc10_ % 3)
         {
            throw new ArgumentError("Incorrect indices.");
         }
         _loc6_ = 0;
         _loc8_ = 0;
         while(_loc6_ < _loc10_)
         {
            if(_loc6_ == _loc8_)
            {
               _loc17_ = param4?int(int(param3[_loc6_])):int(int(3));
               if(_loc17_ < 3)
               {
                  throw new ArgumentError(_loc17_ + " vertices not enough.");
               }
               _loc8_ = param4?int(int(_loc17_ + ++_loc6_)):int(int(_loc6_ + _loc17_));
               if(_loc8_ > _loc10_)
               {
                  throw new ArgumentError("Incorrect indices.");
               }
            }
            _loc16_ = param3[_loc6_];
            if(_loc16_ < 0 || _loc16_ >= _loc9_)
            {
               throw new RangeError("Index is out of bounds.");
            }
            _loc6_++;
         }
         if(this.vertexList != null)
         {
            _loc11_ = this.vertexList;
            while(_loc11_.next != null)
            {
               _loc11_ = _loc11_.next;
            }
         }
         var _loc12_:Vector.<Vertex> = new Vector.<Vertex>(_loc9_);
         _loc6_ = 0;
         _loc7_ = 0;
         _loc8_ = 0;
         while(_loc6_ < _loc9_)
         {
            _loc18_ = new Vertex();
            _loc18_.x = param1[_loc7_];
            _loc7_++;
            _loc18_.y = param1[_loc7_];
            _loc7_++;
            _loc18_.z = param1[_loc7_];
            _loc7_++;
            _loc18_.u = param2[_loc8_];
            _loc8_++;
            _loc18_.v = param2[_loc8_];
            _loc8_++;
            _loc12_[_loc6_] = _loc18_;
            if(_loc11_ != null)
            {
               _loc11_.next = _loc18_;
            }
            else
            {
               this.vertexList = _loc18_;
            }
            _loc11_ = _loc18_;
            _loc6_++;
         }
         if(this.faceList != null)
         {
            _loc13_ = this.faceList;
            while(_loc13_.next != null)
            {
               _loc13_ = _loc13_.next;
            }
         }
         _loc6_ = 0;
         _loc8_ = 0;
         while(_loc6_ < _loc10_)
         {
            if(_loc6_ == _loc8_)
            {
               _loc8_ = param4?int(int(param3[_loc6_] + ++_loc6_)):int(int(_loc6_ + 3));
               _loc15_ = null;
               _loc14_ = new Face();
               _loc14_.material = param5;
               if(_loc13_ != null)
               {
                  _loc13_.next = _loc14_;
               }
               else
               {
                  this.faceList = _loc14_;
               }
               _loc13_ = _loc14_;
            }
            _loc19_ = new Wrapper();
            _loc19_.vertex = _loc12_[param3[_loc6_]];
            if(_loc15_ != null)
            {
               _loc15_.next = _loc19_;
            }
            else
            {
               _loc14_.wrapper = _loc19_;
            }
            _loc15_ = _loc19_;
            _loc6_++;
         }
      }
      
      public function get vertices() : Vector.<Vertex>
      {
         var _loc1_:Vector.<Vertex> = new Vector.<Vertex>();
         var _loc2_:int = 0;
         var _loc3_:Vertex = this.vertexList;
         while(_loc3_ != null)
         {
            _loc1_[_loc2_] = _loc3_;
            _loc2_++;
            _loc3_ = _loc3_.next;
         }
         return _loc1_;
      }
      
      public function get faces() : Vector.<Face>
      {
         var _loc1_:Vector.<Face> = new Vector.<Face>();
         var _loc2_:int = 0;
         var _loc3_:Face = this.faceList;
         while(_loc3_ != null)
         {
            _loc1_[_loc2_] = _loc3_;
            _loc2_++;
            _loc3_ = _loc3_.next;
         }
         return _loc1_;
      }
      
      public function weldVertices(param1:Number = 0, param2:Number = 0) : void
      {
         var _loc3_:Vertex = null;
         var _loc4_:Vertex = null;
         var _loc9_:Wrapper = null;
         this.deleteResources();
         var _loc5_:Vector.<Vertex> = new Vector.<Vertex>();
         var _loc6_:int = 0;
         _loc3_ = this.vertexList;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.next;
            _loc3_.next = null;
            _loc5_[_loc6_] = _loc3_;
            _loc6_++;
            _loc3_ = _loc4_;
         }
         this.vertexList = null;
         this.group(_loc5_,0,_loc6_,0,param1,param2,new Vector.<int>());
         var _loc7_:Face = this.faceList;
         while(_loc7_ != null)
         {
            _loc9_ = _loc7_.wrapper;
            while(_loc9_ != null)
            {
               if(_loc9_.vertex.value != null)
               {
                  _loc9_.vertex = _loc9_.vertex.value;
               }
               _loc9_ = _loc9_.next;
            }
            _loc7_ = _loc7_.next;
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc3_ = _loc5_[_loc8_];
            if(_loc3_.value == null)
            {
               _loc3_.next = this.vertexList;
               this.vertexList = _loc3_;
            }
            _loc8_++;
         }
      }
      
      public function weldFaces(angleThreshold:Number = 0, uvThreshold:Number = 0, convexThreshold:Number = 0, pairWeld:Boolean = false) : void
      {
         var i:int = 0;
         var j:int = 0;
         var key:* = undefined;
         var sibling:* = null;
         var face:* = null;
         var wp:Wrapper = null;
         var sp:Wrapper = null;
         var w:Wrapper = null;
         var s:Wrapper = null;
         var wn:Wrapper = null;
         var sn:Wrapper = null;
         var wm:Wrapper = null;
         var sm:Wrapper = null;
         var vertex:Vertex = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var abu:Number = NaN;
         var abv:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var acu:Number = NaN;
         var acv:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var nl:Number = NaN;
         var faceIdCounter:Number = NaN;
         var dictionary:Dictionary = null;
         var island:Vector.<Face> = null;
         var siblings:Dictionary = null;
         var unfit:Dictionary = null;
         var num:int = 0;
         var det:Number = NaN;
         var ima:Number = NaN;
         var imb:Number = NaN;
         var imc:Number = NaN;
         var imd:Number = NaN;
         var ime:Number = NaN;
         var imf:Number = NaN;
         var img:Number = NaN;
         var imh:Number = NaN;
         var ma:Number = NaN;
         var mb:Number = NaN;
         var mc:Number = NaN;
         var md:Number = NaN;
         var me:Number = NaN;
         var mf:Number = NaN;
         var mg:Number = NaN;
         var mh:Number = NaN;
         var du:Number = NaN;
         var dv:Number = NaN;
         var weld:Boolean = false;
         var newFace:Face = null;
         var digitThreshold:Number = 0.001;
         angleThreshold = Math.cos(angleThreshold) - digitThreshold;
         uvThreshold = uvThreshold + digitThreshold;
         convexThreshold = Math.cos(Math.PI - convexThreshold) - digitThreshold;
         var faceSet:Dictionary = new Dictionary();
         var map:Dictionary = new Dictionary();
         for each(face in this.faces)
         {
            a = face.wrapper.vertex;
            b = face.wrapper.next.vertex;
            c = face.wrapper.next.next.vertex;
            abx = b.x - a.x;
            aby = b.y - a.y;
            abz = b.z - a.z;
            acx = c.x - a.x;
            acy = c.y - a.y;
            acz = c.z - a.z;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            nl = nx * nx + ny * ny + nz * nz;
            if(nl > digitThreshold)
            {
               nl = 1 / Math.sqrt(nl);
               nx = nx * nl;
               ny = ny * nl;
               nz = nz * nl;
               face.normalX = nx;
               face.normalY = ny;
               face.normalZ = nz;
               face.offset = a.x * nx + a.y * ny + a.z * nz;
               faceSet[face] = true;
               for(wn = face.wrapper; wn != null; wn = wn.next)
               {
                  vertex = wn.vertex;
                  dictionary = map[vertex];
                  if(dictionary == null)
                  {
                     dictionary = new Dictionary();
                     map[vertex] = dictionary;
                  }
                  dictionary[face] = true;
               }
               continue;
            }
         }
         faceSet = new Dictionary();
         faceIdCounter = 0;
         island = new Vector.<Face>();
         siblings = new Dictionary();
         unfit = new Dictionary();
         while(true)
         {
            face = null;
            for(face in faceSet)
            {
               delete faceSet[key];
            }
            if(face == null)
            {
               break;
            }
            num = 0;
            island[num] = face;
            num++;
            a = face.wrapper.vertex;
            b = face.wrapper.next.vertex;
            c = face.wrapper.next.next.vertex;
            abx = b.x - a.x;
            aby = b.y - a.y;
            abz = b.z - a.z;
            abu = b.u - a.u;
            abv = b.v - a.v;
            acx = c.x - a.x;
            acy = c.y - a.y;
            acz = c.z - a.z;
            acu = c.u - a.u;
            acv = c.v - a.v;
            nx = face.normalX;
            ny = face.normalY;
            nz = face.normalZ;
            det = -nx * acy * abz + acx * ny * abz + nx * aby * acz - abx * ny * acz - acx * aby * nz + abx * acy * nz;
            ima = (-ny * acz + acy * nz) / det;
            imb = (nx * acz - acx * nz) / det;
            imc = (-nx * acy + acx * ny) / det;
            imd = (a.x * ny * acz - nx * a.y * acz - a.x * acy * nz + acx * a.y * nz + nx * acy * a.z - acx * ny * a.z) / det;
            ime = (ny * abz - aby * nz) / det;
            imf = (-nx * abz + abx * nz) / det;
            img = (nx * aby - abx * ny) / det;
            imh = (nx * a.y * abz - a.x * ny * abz + a.x * aby * nz - abx * a.y * nz - nx * aby * a.z + abx * ny * a.z) / det;
            ma = abu * ima + acu * ime;
            mb = abu * imb + acu * imf;
            mc = abu * imc + acu * img;
            md = abu * imd + acu * imh + a.u;
            me = abv * ima + acv * ime;
            mf = abv * imb + acv * imf;
            mg = abv * imc + acv * img;
            mh = abv * imd + acv * imh + a.v;
            for(key in unfit)
            {
               delete unfit[key];
            }
            for(i = 0; i < num; i++)
            {
               face = island[i];
               for(key in siblings)
               {
                  delete siblings[key];
               }
               for(w = face.wrapper; w != null; w = w.next)
               {
                  for(key in map[w.vertex])
                  {
                     if(faceSet[key] && !unfit[key])
                     {
                        siblings[key] = true;
                     }
                  }
               }
               for(sibling in siblings)
               {
                  if(nx * sibling.normalX + ny * sibling.normalY + nz * sibling.normalZ >= angleThreshold)
                  {
                     for(s = sibling.wrapper; s != null; s = s.next)
                     {
                        vertex = s.vertex;
                        du = ma * vertex.x + mb * vertex.y + mc * vertex.z + md - vertex.u;
                        dv = me * vertex.x + mf * vertex.y + mg * vertex.z + mh - vertex.v;
                        if(du > uvThreshold || du < -uvThreshold || dv > uvThreshold || dv < -uvThreshold)
                        {
                           break;
                        }
                     }
                     if(s == null)
                     {
                        for(w = face.wrapper; w != null; w = w.next)
                        {
                           wn = w.next != null?w.next:face.wrapper;
                           for(s = sibling.wrapper; s != null; s = s.next)
                           {
                              sn = s.next != null?s.next:sibling.wrapper;
                              if(w.vertex == sn.vertex && wn.vertex == s.vertex)
                              {
                                 break;
                              }
                           }
                           if(s != null)
                           {
                              break;
                           }
                        }
                        if(w != null)
                        {
                           island[num] = sibling;
                           num++;
                           delete faceSet[sibling];
                        }
                     }
                     else
                     {
                        unfit[sibling] = true;
                     }
                  }
                  else
                  {
                     unfit[sibling] = true;
                  }
               }
            }
            if(num == 1)
            {
               faceSet[faceIdCounter] = island[0];
               faceIdCounter++;
            }
            else
            {
               while(true)
               {
                  weld = false;
                  for(i = 0; i < num - 1; i++)
                  {
                     face = island[i];
                     if(face != null)
                     {
                        for(j = 1; j < num; j++)
                        {
                           sibling = island[j];
                           if(sibling != null)
                           {
                              for(w = face.wrapper; w != null; w = w.next)
                              {
                                 wn = w.next != null?w.next:face.wrapper;
                                 for(s = sibling.wrapper; s != null; s = s.next)
                                 {
                                    sn = s.next != null?s.next:sibling.wrapper;
                                    if(w.vertex == sn.vertex && wn.vertex == s.vertex)
                                    {
                                       break;
                                    }
                                 }
                                 if(s != null)
                                 {
                                    break;
                                 }
                              }
                              if(w != null)
                              {
                                 while(true)
                                 {
                                    wm = wn.next != null?wn.next:face.wrapper;
                                    sp = sibling.wrapper;
                                    while(sp.next != s && sp.next != null)
                                    {
                                       sp = sp.next;
                                    }
                                    if(wm.vertex == sp.vertex)
                                    {
                                       wn = wm;
                                       s = sp;
                                       continue;
                                    }
                                    break;
                                 }
                                 while(true)
                                 {
                                    wp = face.wrapper;
                                    while(wp.next != w && wp.next != null)
                                    {
                                       wp = wp.next;
                                    }
                                    sm = sn.next != null?sn.next:sibling.wrapper;
                                    if(wp.vertex == sm.vertex)
                                    {
                                       w = wp;
                                       sn = sm;
                                       continue;
                                    }
                                    break;
                                 }
                                 a = w.vertex;
                                 b = sm.vertex;
                                 c = wp.vertex;
                                 abx = b.x - a.x;
                                 aby = b.y - a.y;
                                 abz = b.z - a.z;
                                 acx = c.x - a.x;
                                 acy = c.y - a.y;
                                 acz = c.z - a.z;
                                 nx = acz * aby - acy * abz;
                                 ny = acx * abz - acz * abx;
                                 nz = acy * abx - acx * aby;
                                 if(nx < digitThreshold && nx > -digitThreshold && ny < digitThreshold && ny > -digitThreshold && nz < digitThreshold && nz > -digitThreshold)
                                 {
                                    if(abx * acx + aby * acy + abz * acz > 0)
                                    {
                                       continue;
                                    }
                                 }
                                 else if(face.normalX * nx + face.normalY * ny + face.normalZ * nz < 0)
                                 {
                                    continue;
                                 }
                                 nl = 1 / Math.sqrt(abx * abx + aby * aby + abz * abz);
                                 abx = abx * nl;
                                 aby = aby * nl;
                                 abz = abz * nl;
                                 nl = 1 / Math.sqrt(acx * acx + acy * acy + acz * acz);
                                 acx = acx * nl;
                                 acy = acy * nl;
                                 acz = acz * nl;
                                 if(abx * acx + aby * acy + abz * acz >= convexThreshold)
                                 {
                                    a = s.vertex;
                                    b = wm.vertex;
                                    c = sp.vertex;
                                    abx = b.x - a.x;
                                    aby = b.y - a.y;
                                    abz = b.z - a.z;
                                    acx = c.x - a.x;
                                    acy = c.y - a.y;
                                    acz = c.z - a.z;
                                    nx = acz * aby - acy * abz;
                                    ny = acx * abz - acz * abx;
                                    nz = acy * abx - acx * aby;
                                    if(nx < digitThreshold && nx > -digitThreshold && ny < digitThreshold && ny > -digitThreshold && nz < digitThreshold && nz > -digitThreshold)
                                    {
                                       if(abx * acx + aby * acy + abz * acz > 0)
                                       {
                                          continue;
                                       }
                                    }
                                    else if(face.normalX * nx + face.normalY * ny + face.normalZ * nz < 0)
                                    {
                                       continue;
                                    }
                                    nl = 1 / Math.sqrt(abx * abx + aby * aby + abz * abz);
                                    abx = abx * nl;
                                    aby = aby * nl;
                                    abz = abz * nl;
                                    nl = 1 / Math.sqrt(acx * acx + acy * acy + acz * acz);
                                    acx = acx * nl;
                                    acy = acy * nl;
                                    acz = acz * nl;
                                    if(abx * acx + aby * acy + abz * acz >= convexThreshold)
                                    {
                                       weld = true;
                                       newFace = new Face();
                                       newFace.material = face.material;
                                       newFace.normalX = face.normalX;
                                       newFace.normalY = face.normalY;
                                       newFace.normalZ = face.normalZ;
                                       newFace.offset = face.offset;
                                       for(wm = null; wn != w; )
                                       {
                                          sm = new Wrapper();
                                          sm.vertex = wn.vertex;
                                          if(wm != null)
                                          {
                                             wm.next = sm;
                                          }
                                          else
                                          {
                                             newFace.wrapper = sm;
                                          }
                                          wm = sm;
                                          wn = wn.next != null?wn.next:face.wrapper;
                                       }
                                       while(sn != s)
                                       {
                                          sm = new Wrapper();
                                          sm.vertex = sn.vertex;
                                          if(wm != null)
                                          {
                                             wm.next = sm;
                                          }
                                          else
                                          {
                                             newFace.wrapper = sm;
                                          }
                                          wm = sm;
                                          sn = sn.next != null?sn.next:sibling.wrapper;
                                       }
                                       island[i] = newFace;
                                       island[j] = null;
                                       face = newFace;
                                       if(pairWeld)
                                       {
                                          break;
                                       }
                                    }
                                 }
                                 continue;
                              }
                              continue;
                           }
                        }
                     }
                  }
                  if(!weld)
                  {
                     break;
                  }
               }
               for(i = 0; i < num; i++)
               {
                  face = island[i];
                  if(face != null)
                  {
                     face.calculateBestSequenceAndNormal();
                     faceSet[faceIdCounter] = face;
                     faceIdCounter++;
                  }
               }
            }
         }
      }
      
      private function group(param1:Vector.<Vertex>, param2:int, param3:int, param4:int, param5:Number, param6:Number, param7:Vector.<int>) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Vertex = null;
         var _loc11_:Number = NaN;
         var _loc13_:Vertex = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Number = NaN;
         var _loc17_:Vertex = null;
         var _loc18_:Vertex = null;
         switch(param4)
         {
            case 0:
               _loc8_ = param2;
               while(_loc8_ < param3)
               {
                  _loc10_ = param1[_loc8_];
                  _loc10_.offset = _loc10_.x;
                  _loc8_++;
               }
               _loc11_ = param5;
               break;
            case 1:
               _loc8_ = param2;
               while(_loc8_ < param3)
               {
                  _loc10_ = param1[_loc8_];
                  _loc10_.offset = _loc10_.y;
                  _loc8_++;
               }
               _loc11_ = param5;
               break;
            case 2:
               _loc8_ = param2;
               while(_loc8_ < param3)
               {
                  _loc10_ = param1[_loc8_];
                  _loc10_.offset = _loc10_.z;
                  _loc8_++;
               }
               _loc11_ = param5;
               break;
            case 3:
               _loc8_ = param2;
               while(_loc8_ < param3)
               {
                  _loc10_ = param1[_loc8_];
                  _loc10_.offset = _loc10_.u;
                  _loc8_++;
               }
               _loc11_ = param6;
               break;
            case 4:
               _loc8_ = param2;
               while(_loc8_ < param3)
               {
                  _loc10_ = param1[_loc8_];
                  _loc10_.offset = _loc10_.v;
                  _loc8_++;
               }
               _loc11_ = param6;
         }
         param7[0] = param2;
         param7[1] = param3 - 1;
         var _loc12_:int = 2;
         while(_loc12_ > 0)
         {
            _loc12_--;
            _loc14_ = param7[_loc12_];
            _loc9_ = _loc14_;
            _loc12_--;
            _loc15_ = param7[_loc12_];
            _loc8_ = _loc15_;
            _loc10_ = param1[_loc14_ + _loc15_ >> 1];
            _loc16_ = _loc10_.offset;
            while(_loc8_ <= _loc9_)
            {
               _loc17_ = param1[_loc8_];
               while(_loc17_.offset > _loc16_)
               {
                  _loc8_++;
                  _loc17_ = param1[_loc8_];
               }
               _loc18_ = param1[_loc9_];
               while(_loc18_.offset < _loc16_)
               {
                  _loc9_--;
                  _loc18_ = param1[_loc9_];
               }
               if(_loc8_ <= _loc9_)
               {
                  param1[_loc8_] = _loc18_;
                  param1[_loc9_] = _loc17_;
                  _loc8_++;
                  _loc9_--;
               }
            }
            if(_loc15_ < _loc9_)
            {
               param7[_loc12_] = _loc15_;
               _loc12_++;
               param7[_loc12_] = _loc9_;
               _loc12_++;
            }
            if(_loc8_ < _loc14_)
            {
               param7[_loc12_] = _loc8_;
               _loc12_++;
               param7[_loc12_] = _loc14_;
               _loc12_++;
            }
         }
         _loc8_ = param2;
         _loc10_ = param1[_loc8_];
         _loc9_ = _loc8_ + 1;
         while(_loc9_ <= param3)
         {
            if(_loc9_ < param3)
            {
               _loc13_ = param1[_loc9_];
            }
            if(_loc9_ == param3 || _loc10_.offset - _loc13_.offset > _loc11_)
            {
               if(param4 < 4 && _loc9_ - _loc8_ > 1)
               {
                  this.group(param1,_loc8_,_loc9_,param4 + 1,param5,param6,param7);
               }
               if(_loc9_ < param3)
               {
                  _loc8_ = _loc9_;
                  _loc10_ = param1[_loc8_];
               }
            }
            else if(param4 == 4)
            {
               _loc13_.value = _loc10_;
            }
            _loc9_++;
         }
      }
      
      public function setMaterialToAllFaces(param1:Material) : void
      {
         var _loc2_:Face = null;
         this.deleteResources();
		 if (param1 is TextureMaterial)
		 {
			this.iu = new BitmapTextureResource((param1 as TextureMaterial).texture, true);
		 }else{
			this.iu = new BitmapTextureResource(new BitmapData(1,1), true);
		 }
         var tempmat:Material = Boolean(param1)?param1.clone():null;
         if(tempmat)
         {
            tempmat.name = "tracks";
         }
         _loc2_ = this.faceList;
         while(_loc2_ != null)
         {
            try
            {
               if(_loc2_.material.name == "tracks")
               {
                  _loc2_.material = tempmat;
               }
               else
               {
                  _loc2_.material = param1;
               }
            }
            catch(e:Error)
            {
               _loc2_.material = param1;
            }
            _loc2_ = _loc2_.next;
         }
      }
      
      public function calculateFacesNormals(param1:Boolean = true) : void
      {
         var _loc3_:Wrapper = null;
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Vertex = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         this.deleteResources();
         var _loc2_:Face = this.faceList;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.wrapper;
            _loc4_ = _loc3_.vertex;
            _loc3_ = _loc3_.next;
            _loc5_ = _loc3_.vertex;
            _loc3_ = _loc3_.next;
            _loc6_ = _loc3_.vertex;
            _loc7_ = _loc5_.x - _loc4_.x;
            _loc8_ = _loc5_.y - _loc4_.y;
            _loc9_ = _loc5_.z - _loc4_.z;
            _loc10_ = _loc6_.x - _loc4_.x;
            _loc11_ = _loc6_.y - _loc4_.y;
            _loc12_ = _loc6_.z - _loc4_.z;
            _loc13_ = _loc12_ * _loc8_ - _loc11_ * _loc9_;
            _loc14_ = _loc10_ * _loc9_ - _loc12_ * _loc7_;
            _loc15_ = _loc11_ * _loc7_ - _loc10_ * _loc8_;
            if(param1)
            {
               _loc16_ = _loc13_ * _loc13_ + _loc14_ * _loc14_ + _loc15_ * _loc15_;
               if(_loc16_ > 0.001)
               {
                  _loc16_ = 1 / Math.sqrt(_loc16_);
                  _loc13_ = _loc13_ * _loc16_;
                  _loc14_ = _loc14_ * _loc16_;
                  _loc15_ = _loc15_ * _loc16_;
               }
            }
            _loc2_.normalX = _loc13_;
            _loc2_.normalY = _loc14_;
            _loc2_.normalZ = _loc15_;
            _loc2_.offset = _loc4_.x * _loc13_ + _loc4_.y * _loc14_ + _loc4_.z * _loc15_;
            _loc2_ = _loc2_.next;
         }
      }
      
      public function calculateVerticesNormals(param1:Boolean = false, param2:Number = 0) : void
      {
         var _loc3_:Vertex = null;
         var _loc4_:Number = NaN;
         var _loc6_:Wrapper = null;
         var _loc7_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc9_:Vertex = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Vector.<Vertex> = null;
         this.deleteResources();
         _loc3_ = this.vertexList;
         while(_loc3_ != null)
         {
            _loc3_.normalX = 0;
            _loc3_.normalY = 0;
            _loc3_.normalZ = 0;
            _loc3_ = _loc3_.next;
         }
         var _loc5_:Face = this.faceList;
         while(_loc5_ != null)
         {
            _loc6_ = _loc5_.wrapper;
            _loc7_ = _loc6_.vertex;
            _loc6_ = _loc6_.next;
            _loc8_ = _loc6_.vertex;
            _loc6_ = _loc6_.next;
            _loc9_ = _loc6_.vertex;
            _loc10_ = _loc8_.x - _loc7_.x;
            _loc11_ = _loc8_.y - _loc7_.y;
            _loc12_ = _loc8_.z - _loc7_.z;
            _loc13_ = _loc9_.x - _loc7_.x;
            _loc14_ = _loc9_.y - _loc7_.y;
            _loc15_ = _loc9_.z - _loc7_.z;
            _loc16_ = _loc15_ * _loc11_ - _loc14_ * _loc12_;
            _loc17_ = _loc13_ * _loc12_ - _loc15_ * _loc10_;
            _loc18_ = _loc14_ * _loc10_ - _loc13_ * _loc11_;
            _loc4_ = _loc16_ * _loc16_ + _loc17_ * _loc17_ + _loc18_ * _loc18_;
            if(_loc4_ > 0.001)
            {
               _loc4_ = 1 / Math.sqrt(_loc4_);
               _loc16_ = _loc16_ * _loc4_;
               _loc17_ = _loc17_ * _loc4_;
               _loc18_ = _loc18_ * _loc4_;
            }
            _loc6_ = _loc5_.wrapper;
            while(_loc6_ != null)
            {
               _loc3_ = _loc6_.vertex;
               _loc3_.normalX = _loc3_.normalX + _loc16_;
               _loc3_.normalY = _loc3_.normalY + _loc17_;
               _loc3_.normalZ = _loc3_.normalZ + _loc18_;
               _loc6_ = _loc6_.next;
            }
            _loc5_ = _loc5_.next;
         }
         if(param1)
         {
            _loc19_ = this.vertices;
            this.weldNormals(_loc19_,0,_loc19_.length,0,param2,new Vector.<int>());
         }
         _loc3_ = this.vertexList;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.normalX * _loc3_.normalX + _loc3_.normalY * _loc3_.normalY + _loc3_.normalZ * _loc3_.normalZ;
            if(_loc4_ > 0.001)
            {
               _loc4_ = 1 / Math.sqrt(_loc4_);
               _loc3_.normalX = _loc3_.normalX * _loc4_;
               _loc3_.normalY = _loc3_.normalY * _loc4_;
               _loc3_.normalZ = _loc3_.normalZ * _loc4_;
            }
            _loc3_ = _loc3_.next;
         }
      }
      
      alternativa3d function weldNormals(param1:Vector.<Vertex>, param2:int, param3:int, param4:int, param5:Number, param6:Vector.<int>) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Vertex = null;
         var _loc12_:Vertex = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Vertex = null;
         var _loc17_:Vertex = null;
         switch(param4)
         {
            case 0:
               _loc7_ = param2;
               while(_loc7_ < param3)
               {
                  _loc10_ = param1[_loc7_];
                  _loc10_.offset = _loc10_.x;
                  _loc7_++;
               }
               break;
            case 1:
               _loc7_ = param2;
               while(_loc7_ < param3)
               {
                  _loc10_ = param1[_loc7_];
                  _loc10_.offset = _loc10_.y;
                  _loc7_++;
               }
               break;
            case 2:
               _loc7_ = param2;
               while(_loc7_ < param3)
               {
                  _loc10_ = param1[_loc7_];
                  _loc10_.offset = _loc10_.z;
                  _loc7_++;
               }
         }
         param6[0] = param2;
         param6[1] = param3 - 1;
         var _loc11_:int = 2;
         while(_loc11_ > 0)
         {
            _loc11_--;
            _loc13_ = param6[_loc11_];
            _loc8_ = _loc13_;
            _loc11_--;
            _loc14_ = param6[_loc11_];
            _loc7_ = _loc14_;
            _loc10_ = param1[_loc13_ + _loc14_ >> 1];
            _loc15_ = _loc10_.offset;
            while(_loc7_ <= _loc8_)
            {
               _loc16_ = param1[_loc7_];
               while(_loc16_.offset > _loc15_)
               {
                  _loc7_++;
                  _loc16_ = param1[_loc7_];
               }
               _loc17_ = param1[_loc8_];
               while(_loc17_.offset < _loc15_)
               {
                  _loc8_--;
                  _loc17_ = param1[_loc8_];
               }
               if(_loc7_ <= _loc8_)
               {
                  param1[_loc7_] = _loc17_;
                  param1[_loc8_] = _loc16_;
                  _loc7_++;
                  _loc8_--;
               }
            }
            if(_loc14_ < _loc8_)
            {
               param6[_loc11_] = _loc14_;
               _loc11_++;
               param6[_loc11_] = _loc8_;
               _loc11_++;
            }
            if(_loc7_ < _loc13_)
            {
               param6[_loc11_] = _loc7_;
               _loc11_++;
               param6[_loc11_] = _loc13_;
               _loc11_++;
            }
         }
         _loc7_ = param2;
         _loc10_ = param1[_loc7_];
         _loc8_ = _loc7_ + 1;
         while(_loc8_ <= param3)
         {
            if(_loc8_ < param3)
            {
               _loc12_ = param1[_loc8_];
            }
            if(_loc8_ == param3 || _loc10_.offset - _loc12_.offset > param5)
            {
               if(_loc8_ - _loc7_ > 1)
               {
                  if(param4 < 2)
                  {
                     this.weldNormals(param1,_loc7_,_loc8_,param4 + 1,param5,param6);
                  }
                  else
                  {
                     _loc9_ = _loc7_ + 1;
                     while(_loc9_ < _loc8_)
                     {
                        _loc12_ = param1[_loc9_];
                        _loc10_.normalX = _loc10_.normalX + _loc12_.normalX;
                        _loc10_.normalY = _loc10_.normalY + _loc12_.normalY;
                        _loc10_.normalZ = _loc10_.normalZ + _loc12_.normalZ;
                        _loc9_++;
                     }
                     _loc9_ = _loc7_ + 1;
                     while(_loc9_ < _loc8_)
                     {
                        _loc12_ = param1[_loc9_];
                        _loc12_.normalX = _loc10_.normalX;
                        _loc12_.normalY = _loc10_.normalY;
                        _loc12_.normalZ = _loc10_.normalZ;
                        _loc9_++;
                     }
                  }
               }
               if(_loc8_ < param3)
               {
                  _loc7_ = _loc8_;
                  _loc10_ = param1[_loc7_];
               }
            }
            _loc8_++;
         }
      }
      
      public function calculateVerticesNormalsByAngle(param1:Number, param2:Number = 0) : void
      {
         var _loc3_:Face = null;
         var _loc4_:Wrapper = null;
         var _loc5_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc9_:* = undefined;
         var _loc10_:Number = NaN;
         var _loc11_:* = null;
         this.deleteResources();
         this.calculateNormalsAndRemoveDegenerateFaces();
         var _loc6_:Dictionary = new Dictionary();
         _loc5_ = this.vertexList;
         while(_loc5_ != null)
         {
            _loc6_[_loc5_] = new Dictionary();
            _loc5_ = _loc5_.next;
         }
         _loc3_ = this.faceList;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.wrapper;
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_.vertex;
               _loc6_[_loc5_][_loc3_] = true;
               _loc4_ = _loc4_.next;
            }
            _loc3_ = _loc3_.next;
         }
         var _loc7_:Vector.<Vertex> = this.vertices;
         shareFaces(_loc7_,0,_loc7_.length,0,param2,new Vector.<int>(),_loc6_);
         this.vertexList = null;
         param1 = Math.cos(param1);
         _loc3_ = this.faceList;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.wrapper;
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_.vertex;
               _loc8_ = new Vertex();
               _loc8_.x = _loc5_.x;
               _loc8_.y = _loc5_.y;
               _loc8_.z = _loc5_.z;
               _loc8_.u = _loc5_.u;
               _loc8_.v = _loc5_.v;
               _loc8_.id = _loc5_.id;
               _loc8_.normalX = _loc3_.normalX;
               _loc8_.normalY = _loc3_.normalY;
               _loc8_.normalZ = _loc3_.normalZ;
               for each(_loc11_ in _loc6_[_loc5_])
               {
                  if(_loc3_ != _loc11_ && _loc3_.normalX * _loc11_.normalX + _loc3_.normalY * _loc11_.normalY + _loc3_.normalZ * _loc11_.normalZ >= param1)
                  {
                     _loc8_.normalX = _loc8_.normalX + _loc11_.normalX;
                     _loc8_.normalY = _loc8_.normalY + _loc11_.normalY;
                     _loc8_.normalZ = _loc8_.normalZ + _loc11_.normalZ;
                  }
               }
               _loc10_ = _loc8_.normalX * _loc8_.normalX + _loc8_.normalY * _loc8_.normalY + _loc8_.normalZ * _loc8_.normalZ;
               if(_loc10_ > 0.001)
               {
                  _loc10_ = 1 / Math.sqrt(_loc10_);
                  _loc8_.normalX = _loc8_.normalX * _loc10_;
                  _loc8_.normalY = _loc8_.normalY * _loc10_;
                  _loc8_.normalZ = _loc8_.normalZ * _loc10_;
               }
               _loc4_.vertex = _loc8_;
               _loc8_.next = this.vertexList;
               this.vertexList = _loc8_;
               _loc4_ = _loc4_.next;
            }
            _loc3_ = _loc3_.next;
         }
      }
      
      public function calculateVerticesNormalsBySmoothingGroups(param1:Number = 0) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Face = null;
         var _loc4_:Vertex = null;
         var _loc5_:Wrapper = null;
         var _loc9_:Vertex = null;
         var _loc10_:Number = NaN;
         var _loc11_:* = null;
         this.deleteResources();
         this.calculateNormalsAndRemoveDegenerateFaces();
         var _loc6_:Dictionary = new Dictionary();
         _loc3_ = this.faceList;
         while(_loc3_ != null)
         {
            if(_loc3_.smoothingGroups > 0)
            {
               _loc5_ = _loc3_.wrapper;
               while(_loc5_ != null)
               {
                  _loc4_ = _loc5_.vertex;
                  if(!_loc6_[_loc4_])
                  {
                     _loc6_[_loc4_] = new Dictionary();
                  }
                  _loc6_[_loc4_][_loc3_] = true;
                  _loc5_ = _loc5_.next;
               }
            }
            _loc3_ = _loc3_.next;
         }
         var _loc7_:Vector.<Vertex> = new Vector.<Vertex>();
         var _loc8_:int = 0;
         for each(_loc7_[_loc8_] in _loc6_)
         {
            _loc8_++;
         }
         if(_loc8_ > 0)
         {
            shareFaces(_loc7_,0,_loc8_,0,param1,new Vector.<int>(),_loc6_);
         }
         this.vertexList = null;
         _loc3_ = this.faceList;
         while(_loc3_ != null)
         {
            _loc5_ = _loc3_.wrapper;
            while(_loc5_ != null)
            {
               _loc4_ = _loc5_.vertex;
               _loc9_ = new Vertex();
               _loc9_.x = _loc4_.x;
               _loc9_.y = _loc4_.y;
               _loc9_.z = _loc4_.z;
               _loc9_.u = _loc4_.u;
               _loc9_.v = _loc4_.v;
               _loc9_.id = _loc4_.id;
               _loc9_.normalX = _loc3_.normalX;
               _loc9_.normalY = _loc3_.normalY;
               _loc9_.normalZ = _loc3_.normalZ;
               if(_loc3_.smoothingGroups > 0)
               {
                  for each(_loc11_ in _loc6_[_loc4_])
                  {
                     if(_loc3_ != _loc11_ && (_loc3_.smoothingGroups & _loc11_.smoothingGroups) > 0)
                     {
                        _loc9_.normalX = _loc9_.normalX + _loc11_.normalX;
                        _loc9_.normalY = _loc9_.normalY + _loc11_.normalY;
                        _loc9_.normalZ = _loc9_.normalZ + _loc11_.normalZ;
                     }
                  }
                  _loc10_ = _loc9_.normalX * _loc9_.normalX + _loc9_.normalY * _loc9_.normalY + _loc9_.normalZ * _loc9_.normalZ;
                  if(_loc10_ > 0.001)
                  {
                     _loc10_ = 1 / Math.sqrt(_loc10_);
                     _loc9_.normalX = _loc9_.normalX * _loc10_;
                     _loc9_.normalY = _loc9_.normalY * _loc10_;
                     _loc9_.normalZ = _loc9_.normalZ * _loc10_;
                  }
               }
               _loc5_.vertex = _loc9_;
               _loc9_.next = this.vertexList;
               this.vertexList = _loc9_;
               _loc5_ = _loc5_.next;
            }
            _loc3_ = _loc3_.next;
         }
      }
      
      private function calculateNormalsAndRemoveDegenerateFaces() : void
      {
         var _loc2_:Face = null;
         var _loc3_:Wrapper = null;
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Vertex = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc1_:Face = this.faceList;
         this.faceList = null;
         while(_loc1_ != null)
         {
            _loc2_ = _loc1_.next;
            _loc3_ = _loc1_.wrapper;
            _loc4_ = _loc3_.vertex;
            _loc3_ = _loc3_.next;
            _loc5_ = _loc3_.vertex;
            _loc3_ = _loc3_.next;
            _loc6_ = _loc3_.vertex;
            _loc7_ = _loc5_.x - _loc4_.x;
            _loc8_ = _loc5_.y - _loc4_.y;
            _loc9_ = _loc5_.z - _loc4_.z;
            _loc10_ = _loc6_.x - _loc4_.x;
            _loc11_ = _loc6_.y - _loc4_.y;
            _loc12_ = _loc6_.z - _loc4_.z;
            _loc1_.normalX = _loc12_ * _loc8_ - _loc11_ * _loc9_;
            _loc1_.normalY = _loc10_ * _loc9_ - _loc12_ * _loc7_;
            _loc1_.normalZ = _loc11_ * _loc7_ - _loc10_ * _loc8_;
            _loc13_ = _loc1_.normalX * _loc1_.normalX + _loc1_.normalY * _loc1_.normalY + _loc1_.normalZ * _loc1_.normalZ;
            if(_loc13_ > 0.001)
            {
               _loc13_ = 1 / Math.sqrt(_loc13_);
               _loc1_.normalX = _loc1_.normalX * _loc13_;
               _loc1_.normalY = _loc1_.normalY * _loc13_;
               _loc1_.normalZ = _loc1_.normalZ * _loc13_;
               _loc1_.offset = _loc4_.x * _loc1_.normalX + _loc4_.y * _loc1_.normalY + _loc4_.z * _loc1_.normalZ;
               _loc1_.next = this.faceList;
               this.faceList = _loc1_;
            }
            else
            {
               _loc1_.next = null;
            }
            _loc1_ = _loc2_;
         }
      }
      
      public function optimizeForDynamicBSP(param1:int = 1) : void
      {
         var _loc3_:Face = null;
         var _loc5_:Face = null;
         var _loc6_:Face = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:Face = null;
         var _loc15_:Wrapper = null;
         var _loc16_:Vertex = null;
         var _loc17_:Vertex = null;
         var _loc18_:Vertex = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:Vertex = null;
         var _loc25_:Number = NaN;
         this.deleteResources();
         var _loc2_:Face = this.faceList;
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc5_ = null;
            _loc6_ = _loc2_;
            while(_loc6_ != null)
            {
               _loc7_ = _loc6_.normalX;
               _loc8_ = _loc6_.normalY;
               _loc9_ = _loc6_.normalZ;
               _loc10_ = _loc6_.offset;
               _loc11_ = _loc10_ - this.threshold;
               _loc12_ = _loc10_ + this.threshold;
               _loc13_ = 0;
               _loc14_ = _loc2_;
               while(_loc14_ != null)
               {
                  if(_loc14_ != _loc6_)
                  {
                     _loc15_ = _loc14_.wrapper;
                     _loc16_ = _loc15_.vertex;
                     _loc15_ = _loc15_.next;
                     _loc17_ = _loc15_.vertex;
                     _loc15_ = _loc15_.next;
                     _loc18_ = _loc15_.vertex;
                     _loc15_ = _loc15_.next;
                     _loc19_ = _loc16_.x * _loc7_ + _loc16_.y * _loc8_ + _loc16_.z * _loc9_;
                     _loc20_ = _loc17_.x * _loc7_ + _loc17_.y * _loc8_ + _loc17_.z * _loc9_;
                     _loc21_ = _loc18_.x * _loc7_ + _loc18_.y * _loc8_ + _loc18_.z * _loc9_;
                     _loc22_ = _loc19_ < _loc11_ || _loc20_ < _loc11_ || _loc21_ < _loc11_;
                     _loc23_ = _loc19_ > _loc12_ || _loc20_ > _loc12_ || _loc21_ > _loc12_;
                     while(_loc15_ != null)
                     {
                        _loc24_ = _loc15_.vertex;
                        _loc25_ = _loc24_.x * _loc7_ + _loc24_.y * _loc8_ + _loc24_.z * _loc9_;
                        if(_loc25_ < _loc11_)
                        {
                           _loc22_ = true;
                           if(_loc23_)
                           {
                              break;
                           }
                        }
                        else if(_loc25_ > _loc12_)
                        {
                           _loc23_ = true;
                           if(_loc22_)
                           {
                              break;
                           }
                        }
                        _loc15_ = _loc15_.next;
                     }
                     if(_loc23_ && _loc22_)
                     {
                        _loc13_++;
                        if(_loc13_ > _loc4_)
                        {
                           break;
                        }
                     }
                  }
                  _loc14_ = _loc14_.next;
               }
               if(_loc14_ == null)
               {
                  if(_loc5_ != null)
                  {
                     _loc5_.next = _loc6_.next;
                  }
                  else
                  {
                     _loc2_ = _loc6_.next;
                  }
                  if(_loc3_ != null)
                  {
                     _loc3_.next = _loc6_;
                  }
                  else
                  {
                     this.faceList = _loc6_;
                  }
                  _loc3_ = _loc6_;
               }
               else
               {
                  _loc5_ = _loc6_;
               }
               _loc6_ = _loc6_.next;
            }
            if(_loc2_ == null)
            {
               break;
            }
            _loc4_++;
         }
         if(_loc3_ != null)
         {
            _loc3_.next = _loc2_;
         }
      }
      
      override public function intersectRay(param1:Vector3D, param2:Vector3D, param3:Dictionary = null, param4:Camera3D = null) : RayIntersectionData
      {
         var _loc11_:Vector3D = null;
         var _loc12_:Face = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Wrapper = null;
         var _loc25_:Vertex = null;
         var _loc26_:Vertex = null;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:RayIntersectionData = null;
         if(param3 != null && param3[this])
         {
            return null;
         }
         if(!boundIntersectRay(param1,param2,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return null;
         }
         var _loc5_:Number = param1.x;
         var _loc6_:Number = param1.y;
         var _loc7_:Number = param1.z;
         var _loc8_:Number = param2.x;
         var _loc9_:Number = param2.y;
         var _loc10_:Number = param2.z;
         var _loc13_:Number = 1.0e22;
         var _loc14_:Face = this.faceList;
         while(_loc14_ != null)
         {
            _loc15_ = _loc14_.normalX;
            _loc16_ = _loc14_.normalY;
            _loc17_ = _loc14_.normalZ;
            _loc18_ = _loc8_ * _loc15_ + _loc9_ * _loc16_ + _loc10_ * _loc17_;
            if(_loc18_ < 0)
            {
               _loc19_ = _loc5_ * _loc15_ + _loc6_ * _loc16_ + _loc7_ * _loc17_ - _loc14_.offset;
               if(_loc19_ > 0)
               {
                  _loc20_ = -_loc19_ / _loc18_;
                  if(_loc11_ == null || _loc20_ < _loc13_)
                  {
                     _loc21_ = _loc5_ + _loc8_ * _loc20_;
                     _loc22_ = _loc6_ + _loc9_ * _loc20_;
                     _loc23_ = _loc7_ + _loc10_ * _loc20_;
                     _loc24_ = _loc14_.wrapper;
                     while(_loc24_ != null)
                     {
                        _loc25_ = _loc24_.vertex;
                        _loc26_ = _loc24_.next != null?_loc24_.next.vertex:_loc14_.wrapper.vertex;
                        _loc27_ = _loc26_.x - _loc25_.x;
                        _loc28_ = _loc26_.y - _loc25_.y;
                        _loc29_ = _loc26_.z - _loc25_.z;
                        _loc30_ = _loc21_ - _loc25_.x;
                        _loc31_ = _loc22_ - _loc25_.y;
                        _loc32_ = _loc23_ - _loc25_.z;
                        if((_loc32_ * _loc28_ - _loc31_ * _loc29_) * _loc15_ + (_loc30_ * _loc29_ - _loc32_ * _loc27_) * _loc16_ + (_loc31_ * _loc27_ - _loc30_ * _loc28_) * _loc17_ < 0)
                        {
                           break;
                        }
                        _loc24_ = _loc24_.next;
                     }
                     if(_loc24_ == null)
                     {
                        if(_loc20_ < _loc13_)
                        {
                           _loc13_ = _loc20_;
                           if(_loc11_ == null)
                           {
                              _loc11_ = new Vector3D();
                           }
                           _loc11_.x = _loc21_;
                           _loc11_.y = _loc22_;
                           _loc11_.z = _loc23_;
                           _loc12_ = _loc14_;
                        }
                     }
                  }
               }
            }
            _loc14_ = _loc14_.next;
         }
         if(_loc11_ != null)
         {
            _loc33_ = new RayIntersectionData();
            _loc33_.object = this;
            _loc33_.face = _loc12_;
            _loc33_.point = _loc11_;
            _loc33_.uv = _loc12_.getUV(_loc11_);
            _loc33_.time = _loc13_;
            return _loc33_;
         }
         return null;
      }
      
      override alternativa3d function checkIntersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Dictionary) : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Wrapper = null;
         var _loc20_:Vertex = null;
         var _loc21_:Vertex = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc9_:Face = null;
         _loc10_ = NaN;
         _loc11_ = NaN;
         _loc12_ = NaN;
         _loc13_ = NaN;
         _loc14_ = NaN;
         _loc15_ = NaN;
         _loc16_ = NaN;
         _loc17_ = NaN;
         _loc18_ = NaN;
         _loc19_ = null;
         _loc20_ = null;
         _loc21_ = null;
         _loc22_ = NaN;
         _loc23_ = NaN;
         _loc24_ = NaN;
         _loc25_ = NaN;
         _loc26_ = NaN;
         _loc27_ = NaN;
         _loc9_ = this.faceList;
         while(true)
         {
            if(true)
            {
               if(_loc9_ == null)
               {
                  break;
               }
               _loc10_ = _loc9_.normalX;
               _loc11_ = _loc9_.normalY;
               _loc12_ = _loc9_.normalZ;
               _loc13_ = param4 * _loc10_ + param5 * _loc11_ + param6 * _loc12_;
               if(_loc13_ < 0)
               {
                  _loc14_ = param1 * _loc10_ + param2 * _loc11_ + param3 * _loc12_ - _loc9_.offset;
                  if(_loc14_ > 0)
                  {
                     _loc15_ = -_loc14_ / _loc13_;
                     if(_loc15_ < param7)
                     {
                        _loc16_ = param1 + param4 * _loc15_;
                        _loc17_ = param2 + param5 * _loc15_;
                        _loc18_ = param3 + param6 * _loc15_;
                        _loc19_ = _loc9_.wrapper;
                        while(_loc19_ != null)
                        {
                           _loc20_ = _loc19_.vertex;
                           _loc21_ = _loc19_.next != null?_loc19_.next.vertex:_loc9_.wrapper.vertex;
                           _loc22_ = _loc21_.x - _loc20_.x;
                           _loc23_ = _loc21_.y - _loc20_.y;
                           _loc24_ = _loc21_.z - _loc20_.z;
                           _loc25_ = _loc16_ - _loc20_.x;
                           _loc26_ = _loc17_ - _loc20_.y;
                           _loc27_ = _loc18_ - _loc20_.z;
                           if((_loc27_ * _loc23_ - _loc26_ * _loc24_) * _loc10_ + (_loc25_ * _loc24_ - _loc27_ * _loc22_) * _loc11_ + (_loc26_ * _loc22_ - _loc25_ * _loc23_) * _loc12_ < 0)
                           {
                              break;
                           }
                           _loc19_ = _loc19_.next;
                        }
                        if(_loc19_ == null)
                        {
                        }
                     }
                  }
               }
               _loc9_ = _loc9_.next;
               continue;
            }
            return true;
         }
         return false;
      }
      
      override alternativa3d function collectPlanes(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:Vector3D, param6:Vector.<Face>, param7:Dictionary = null) : void
      {
         var _loc9_:Vertex = null;
         var _loc11_:Number = NaN;
         var _loc12_:Wrapper = null;
         var _loc8_:Vector3D = null;
         var _loc10_:Face = null;
         _loc9_ = null;
         _loc11_ = NaN;
         _loc12_ = null;
         if(param7 != null && param7[this])
         {
            return;
         }
         _loc8_ = calculateSphere(param1,param2,param3,param4,param5);
         if(!boundIntersectSphere(_loc8_,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return;
         }
         if(transformId > 500000000)
         {
            transformId = 0;
            _loc9_ = this.vertexList;
            while(_loc9_ != null)
            {
               _loc9_.transformId = 0;
               _loc9_ = _loc9_.next;
            }
         }
         transformId++;
         _loc10_ = this.faceList;
         while(_loc10_ != null)
         {
            _loc11_ = _loc8_.x * _loc10_.normalX + _loc8_.y * _loc10_.normalY + _loc8_.z * _loc10_.normalZ - _loc10_.offset;
            if(_loc11_ < _loc8_.w && _loc11_ > -_loc8_.w)
            {
               _loc12_ = _loc10_.wrapper;
               while(_loc12_ != null)
               {
                  _loc9_ = _loc12_.vertex;
                  if(_loc9_.transformId != transformId)
                  {
                     _loc9_.cameraX = ma * _loc9_.x + mb * _loc9_.y + mc * _loc9_.z + md;
                     _loc9_.cameraY = me * _loc9_.x + mf * _loc9_.y + mg * _loc9_.z + mh;
                     _loc9_.cameraZ = mi * _loc9_.x + mj * _loc9_.y + mk * _loc9_.z + ml;
                     _loc9_.transformId = transformId;
                  }
                  _loc12_ = _loc12_.next;
               }
               param6.push(_loc10_);
            }
            _loc10_ = _loc10_.next;
         }
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Mesh = null;
         _loc1_ = new Mesh();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         var _loc3_:Vertex = null;
         var _loc4_:Vertex = null;
         var _loc5_:Face = null;
         var _loc7_:Vertex = null;
         var _loc8_:Face = null;
         var _loc9_:Wrapper = null;
         var _loc10_:Wrapper = null;
         var _loc11_:Wrapper = null;
         var _loc2_:Mesh = null;
         var _loc6_:Face = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = null;
         _loc11_ = null;
         super.clonePropertiesFrom(param1);
         _loc2_ = param1 as Mesh;
         this.clipping = _loc2_.clipping;
         this.sorting = _loc2_.sorting;
         this.threshold = _loc2_.threshold;
         _loc3_ = _loc2_.vertexList;
         while(_loc3_ != null)
         {
            _loc7_ = new Vertex();
            _loc7_.x = _loc3_.x;
            _loc7_.y = _loc3_.y;
            _loc7_.z = _loc3_.z;
            _loc7_.u = _loc3_.u;
            _loc7_.v = _loc3_.v;
            _loc7_.normalX = _loc3_.normalX;
            _loc7_.normalY = _loc3_.normalY;
            _loc7_.normalZ = _loc3_.normalZ;
            _loc7_.offset = _loc3_.offset;
            _loc7_.id = _loc3_.id;
            _loc3_.value = _loc7_;
            if(_loc4_ != null)
            {
               _loc4_.next = _loc7_;
            }
            else
            {
               this.vertexList = _loc7_;
            }
            _loc4_ = _loc7_;
            _loc3_ = _loc3_.next;
         }
         _loc6_ = _loc2_.faceList;
         while(_loc6_ != null)
         {
            _loc8_ = new Face();
            _loc8_.material = _loc6_.material;
            _loc8_.smoothingGroups = _loc6_.smoothingGroups;
            _loc8_.id = _loc6_.id;
            _loc8_.normalX = _loc6_.normalX;
            _loc8_.normalY = _loc6_.normalY;
            _loc8_.normalZ = _loc6_.normalZ;
            _loc8_.offset = _loc6_.offset;
            _loc9_ = null;
            _loc10_ = _loc6_.wrapper;
            while(_loc10_ != null)
            {
               _loc11_ = new Wrapper();
               _loc11_.vertex = _loc10_.vertex.value;
               if(_loc9_ != null)
               {
                  _loc9_.next = _loc11_;
               }
               else
               {
                  _loc8_.wrapper = _loc11_;
               }
               _loc9_ = _loc11_;
               _loc10_ = _loc10_.next;
            }
            if(_loc5_ != null)
            {
               _loc5_.next = _loc8_;
            }
            else
            {
               this.faceList = _loc8_;
            }
            _loc5_ = _loc8_;
            _loc6_ = _loc6_.next;
         }
         _loc3_ = _loc2_.vertexList;
         while(_loc3_ != null)
         {
            _loc3_.value = null;
            _loc3_ = _loc3_.next;
         }
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         var _loc2_:Face = null;
         var _loc4_:Vertex = null;
         var _loc3_:int = 0;
         _loc2_ = null;
         _loc4_ = null;
         if(this.faceList == null)
         {
            return;
         }
         if(this.clipping == 0)
         {
            if(culling & 1)
            {
               return;
            }
            culling = 0;
         }
         this.prepareResources();
         if(useDepth && (param1.softTransparency && param1.softTransparencyStrength > 0 || param1.ssao && param1.ssaoStrength > 0 || param1.deferredLighting && param1.deferredLightingStrength > 0) && concatenatedAlpha > 0)//>= depthMapAlphaThreshold)
         {
            param1.depthObjects[param1.depthCount] = this;
            param1.depthCount++;
         }
         if(concatenatedAlpha >= 1 && concatenatedBlendMode == "normal")
         {
            this.addOpaque(param1);
            _loc2_ = this.transparentList;
         }
         else
         {
            _loc2_ = this.faceList;
         }
         transformConst[0] = ma;
         transformConst[1] = mb;
         transformConst[2] = mc;
         transformConst[3] = md;
         transformConst[4] = me;
         transformConst[5] = mf;
         transformConst[6] = mg;
         transformConst[7] = mh;
         transformConst[8] = mi;
         transformConst[9] = mj;
         transformConst[10] = mk;
         transformConst[11] = ml;
         _loc3_ = param1.debug?int(int(param1.checkInDebug(this))):int(int(0));
         if(_loc3_ & Debug.BOUNDS)
         {
            Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
         if(_loc2_ == null)
         {
            return;
         }
         if(transformId > 500000000)
         {
            transformId = 0;
            _loc4_ = this.vertexList;
            while(_loc4_ != null)
            {
               _loc4_.transformId = 0;
               _loc4_ = _loc4_.next;
            }
         }
         transformId++;
         calculateInverseMatrix();
         _loc2_ = this.prepareFaces(param1,_loc2_);
         if(_loc2_ == null)
         {
            return;
         }
         if(culling > 0)
         {
            if(this.clipping == 1)
            {
               _loc2_ = param1.cull(_loc2_,culling);
            }
            else
            {
               _loc2_ = param1.clip(_loc2_,culling);
            }
            if(_loc2_ == null)
            {
               return;
            }
         }
         if(_loc2_.processNext != null)
         {
            if(this.sorting == 1)
            {
               _loc2_ = param1.sortByAverageZ(_loc2_);
            }
            else if(this.sorting == 2)
            {
               _loc2_ = param1.sortByDynamicBSP(_loc2_,this.threshold);
            }
         }
         if(_loc3_ & Debug.EDGES)
         {
            Debug.drawEdges(param1,_loc2_,16777215);
         }
         this.drawFaces(param1,_loc2_);
      }
      
      override alternativa3d function getVG(param1:Camera3D) : VG
      {
         var _loc2_:Face = null;
         var _loc4_:Vertex = null;
         var _loc3_:int = 0;
         _loc2_ = null;
         _loc4_ = null;
         if(this.faceList == null)
         {
            return null;
         }
         if(this.clipping == 0)
         {
            if(culling & 1)
            {
               return null;
            }
            culling = 0;
         }
         this.prepareResources();
         if(useDepth && (param1.softTransparency && param1.softTransparencyStrength > 0 || param1.ssao && param1.ssaoStrength > 0 || param1.deferredLighting && param1.deferredLightingStrength > 0) && concatenatedAlpha > 0)//>= depthMapAlphaThreshold)
         {
            param1.depthObjects[param1.depthCount] = this;
            param1.depthCount++;
         }
         if(concatenatedAlpha >= 1 && concatenatedBlendMode == "normal")
         {
            this.addOpaque(param1);
            _loc2_ = this.transparentList;
         }
         else
         {
            _loc2_ = this.faceList;
         }
         transformConst[0] = ma;
         transformConst[1] = mb;
         transformConst[2] = mc;
         transformConst[3] = md;
         transformConst[4] = me;
         transformConst[5] = mf;
         transformConst[6] = mg;
         transformConst[7] = mh;
         transformConst[8] = mi;
         transformConst[9] = mj;
         transformConst[10] = mk;
         transformConst[11] = ml;
         _loc3_ = param1.debug?int(int(param1.checkInDebug(this))):int(int(0));
         if(_loc3_ & Debug.BOUNDS)
         {
            Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
         if(_loc2_ == null)
         {
            return null;
         }
         if(transformId > 500000000)
         {
            transformId = 0;
            _loc4_ = this.vertexList;
            while(_loc4_ != null)
            {
               _loc4_.transformId = 0;
               _loc4_ = _loc4_.next;
            }
         }
         transformId++;
         calculateInverseMatrix();
         _loc2_ = this.prepareFaces(param1,_loc2_);
         if(_loc2_ == null)
         {
            return null;
         }
         if(culling > 0)
         {
            if(this.clipping == 1)
            {
               _loc2_ = param1.cull(_loc2_,culling);
            }
            else
            {
               _loc2_ = param1.clip(_loc2_,culling);
            }
            if(_loc2_ == null)
            {
               return null;
            }
         }
         return VG.create(this,_loc2_,this.sorting,_loc3_,false);
      }
      
      alternativa3d function prepareResources() : void
      {
         var _loc1_:Vector.<Number> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vertex = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Face = null;
         var _loc9_:Face = null;
         var _loc10_:Face = null;
         var _loc11_:Wrapper = null;
         var _loc12_:Dictionary = null;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:int = 0;
         var _loc15_:* = undefined;
         var _loc16_:Face = null;
         _loc1_ = null;
         _loc2_ = 0;
         _loc3_ = 0;
         _loc4_ = null;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = 0;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = null;
         _loc11_ = null;
         _loc12_ = null;
         _loc13_ = null;
         _loc14_ = 0;
         _loc15_ = undefined;
         _loc16_ = null;
         if(this.vertexBuffer == null)
         {
            _loc1_ = new Vector.<Number>();
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = this.vertexList;
            while(_loc4_ != null)
            {
               _loc1_[_loc2_] = _loc4_.x;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.y;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.z;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.u;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.v;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.normalX;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.normalY;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.normalZ;
               _loc2_++;
               _loc4_.index = _loc3_;
               _loc3_++;
               _loc4_ = _loc4_.next;
            }
            if(_loc3_ > 0)
            {
               this.vertexBuffer = new VertexBufferResource(_loc1_,8);
            }
            _loc12_ = new Dictionary();
            _loc8_ = this.faceList;
            while(_loc8_ != null)
            {
               _loc9_ = _loc8_.next;
               _loc8_.next = null;
               if(_loc8_.material != null && (!_loc8_.material.transparent || _loc8_.material.alphaTestThreshold > 0))
               {
                  _loc8_.next = _loc12_[_loc8_.material];
                  _loc12_[_loc8_.material] = _loc8_;
               }
               else
               {
                  if(_loc10_ != null)
                  {
                     _loc10_.next = _loc8_;
                  }
                  else
                  {
                     this.transparentList = _loc8_;
                  }
                  _loc10_ = _loc8_;
               }
               _loc8_ = _loc9_;
            }
            this.faceList = this.transparentList;
            _loc13_ = new Vector.<uint>();
            _loc14_ = 0;
            for(_loc15_ in _loc12_)
            {
               _loc16_ = _loc12_[_loc15_];
               this.opaqueMaterials[this.opaqueLength] = _loc16_.material;
               this.opaqueBegins[this.opaqueLength] = this.numTriangles * 3;
               _loc8_ = _loc16_;
               while(_loc8_ != null)
               {
                  _loc11_ = _loc8_.wrapper;
                  _loc5_ = _loc11_.vertex.index;
                  _loc11_ = _loc11_.next;
                  _loc6_ = _loc11_.vertex.index;
                  _loc11_ = _loc11_.next;
                  while(_loc11_ != null)
                  {
                     _loc7_ = _loc11_.vertex.index;
                     _loc13_[_loc14_] = _loc5_;
                     _loc14_++;
                     _loc13_[_loc14_] = _loc6_;
                     _loc14_++;
                     _loc13_[_loc14_] = _loc7_;
                     _loc14_++;
                     _loc6_ = _loc7_;
                     this.numTriangles++;
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc8_.next == null)
                  {
                     _loc10_ = _loc8_;
                  }
                  _loc8_ = _loc8_.next;
               }
               this.opaqueNums[this.opaqueLength] = this.numTriangles - this.opaqueBegins[this.opaqueLength] / 3;
               this.opaqueLength++;
               _loc10_.next = this.faceList;
               this.faceList = _loc16_;
            }
            this.numOpaqueTriangles = this.numTriangles;
            _loc8_ = this.transparentList;
            while(_loc8_ != null)
            {
               _loc11_ = _loc8_.wrapper;
               _loc5_ = _loc11_.vertex.index;
               _loc11_ = _loc11_.next;
               _loc6_ = _loc11_.vertex.index;
               _loc11_ = _loc11_.next;
               while(_loc11_ != null)
               {
                  _loc7_ = _loc11_.vertex.index;
                  _loc13_[_loc14_] = _loc5_;
                  _loc14_++;
                  _loc13_[_loc14_] = _loc6_;
                  _loc14_++;
                  _loc13_[_loc14_] = _loc7_;
                  _loc14_++;
                  _loc6_ = _loc7_;
                  this.numTriangles++;
                  _loc11_ = _loc11_.next;
               }
               _loc8_ = _loc8_.next;
            }
            if(_loc14_ > 0)
            {
               this.indexBuffer = new IndexBufferResource(_loc13_);
            }
         }
      }
      
      alternativa3d function deleteResources() : void
      {
         if(this.vertexBuffer != null)
         {
            this.vertexBuffer.dispose();
            this.vertexBuffer = null;
            this.indexBuffer.dispose();
            this.indexBuffer = null;
            this.numTriangles = 0;
            this.numOpaqueTriangles = 0;
            this.opaqueMaterials.length = 0;
            this.opaqueBegins.length = 0;
            this.opaqueNums.length = 0;
            this.opaqueLength = 0;
            this.transparentList = null;
         }
      }
      
      alternativa3d function addOpaque(param1:Camera3D) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.opaqueLength)
         {
            param1.addOpaque(this.opaqueMaterials[_loc2_],this.vertexBuffer,this.indexBuffer,this.opaqueBegins[_loc2_],this.opaqueNums[_loc2_],this);
            _loc2_++;
         }
      }
      
      alternativa3d function prepareFaces(param1:Camera3D, param2:Face) : Face
      {
         var _loc3_:Face = null;
         var _loc4_:Face = null;
         var _loc5_:Face = null;
         var _loc6_:Wrapper = null;
         var _loc7_:Vertex = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = null;
         _loc8_ = NaN;
         _loc9_ = NaN;
         _loc10_ = NaN;
         _loc5_ = param2;
         while(_loc5_ != null)
         {
            if(_loc5_.normalX * imd + _loc5_.normalY * imh + _loc5_.normalZ * iml > _loc5_.offset)
            {
               _loc6_ = _loc5_.wrapper;
               while(_loc6_ != null)
               {
                  _loc7_ = _loc6_.vertex;
                  if(_loc7_.transformId != transformId)
                  {
                     _loc8_ = _loc7_.x;
                     _loc9_ = _loc7_.y;
                     _loc10_ = _loc7_.z;
                     _loc7_.cameraX = ma * _loc8_ + mb * _loc9_ + mc * _loc10_ + md;
                     _loc7_.cameraY = me * _loc8_ + mf * _loc9_ + mg * _loc10_ + mh;
                     _loc7_.cameraZ = mi * _loc8_ + mj * _loc9_ + mk * _loc10_ + ml;
                     _loc7_.transformId = transformId;
                     _loc7_.drawId = 0;
                  }
                  _loc6_ = _loc6_.next;
               }
               if(_loc3_ != null)
               {
                  _loc4_.processNext = _loc5_;
               }
               else
               {
                  _loc3_ = _loc5_;
               }
               _loc4_ = _loc5_;
            }
            _loc5_ = _loc5_.next;
         }
         if(_loc4_ != null)
         {
            _loc4_.processNext = null;
         }
         return _loc3_;
      }
      
      alternativa3d function drawFaces(param1:Camera3D, param2:Face) : void
      {
         var _loc3_:Face = null;
         var _loc4_:Face = null;
         var _loc5_:Face = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc5_ = param2;
         while(_loc5_ != null)
         {
            _loc3_ = _loc5_.processNext;
            if(_loc3_ == null || _loc3_.material != param2.material)
            {
               _loc5_.processNext = null;
               if(param2.material != null)
               {
                  param2.processNegative = _loc4_;
                  _loc4_ = param2;
               }
               else
               {
                  while(param2 != null)
                  {
                     _loc5_ = param2.processNext;
                     param2.processNext = null;
                     param2 = _loc5_;
                  }
               }
               param2 = _loc3_;
            }
            _loc5_ = _loc3_;
         }
         param2 = _loc4_;
         while(param2 != null)
         {
            _loc3_ = param2.processNegative;
            param2.processNegative = null;
            param1.addTransparent(param2,this);
            param2 = _loc3_;
         }
      }
      
      override alternativa3d function updateBounds(param1:Object3D, param2:Object3D = null) : void
      {
         var _loc3_:Vertex = null;
         _loc3_ = null;
         _loc3_ = this.vertexList;
         while(_loc3_ != null)
         {
            if(param2 != null)
            {
               _loc3_.cameraX = param2.ma * _loc3_.x + param2.mb * _loc3_.y + param2.mc * _loc3_.z + param2.md;
               _loc3_.cameraY = param2.me * _loc3_.x + param2.mf * _loc3_.y + param2.mg * _loc3_.z + param2.mh;
               _loc3_.cameraZ = param2.mi * _loc3_.x + param2.mj * _loc3_.y + param2.mk * _loc3_.z + param2.ml;
            }
            else
            {
               _loc3_.cameraX = _loc3_.x;
               _loc3_.cameraY = _loc3_.y;
               _loc3_.cameraZ = _loc3_.z;
            }
            if(_loc3_.cameraX < param1.boundMinX)
            {
               param1.boundMinX = _loc3_.cameraX;
            }
            if(_loc3_.cameraX > param1.boundMaxX)
            {
               param1.boundMaxX = _loc3_.cameraX;
            }
            if(_loc3_.cameraY < param1.boundMinY)
            {
               param1.boundMinY = _loc3_.cameraY;
            }
            if(_loc3_.cameraY > param1.boundMaxY)
            {
               param1.boundMaxY = _loc3_.cameraY;
            }
            if(_loc3_.cameraZ < param1.boundMinZ)
            {
               param1.boundMinZ = _loc3_.cameraZ;
            }
            if(_loc3_.cameraZ > param1.boundMaxZ)
            {
               param1.boundMaxZ = _loc3_.cameraZ;
            }
            _loc3_ = _loc3_.next;
         }
      }
      
      override alternativa3d function split(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Number) : Vector.<Object3D>
      {
         var _loc5_:Vector.<Object3D> = null;
         var _loc6_:Vector3D = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Vertex = null;
         var _loc10_:Vertex = null;
         var _loc11_:Face = null;
         var _loc12_:Mesh = null;
         var _loc13_:Mesh = null;
         var _loc14_:Face = null;
         var _loc15_:Face = null;
         var _loc16_:Face = null;
         var _loc17_:Face = null;
         var _loc18_:Wrapper = null;
         var _loc19_:Vertex = null;
         var _loc20_:Vertex = null;
         var _loc21_:Vertex = null;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:Face = null;
         var _loc25_:Face = null;
         var _loc26_:Wrapper = null;
         var _loc27_:Wrapper = null;
         var _loc28_:Wrapper = null;
         var _loc29_:Number = NaN;
         var _loc30_:Vertex = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = NaN;
         _loc8_ = NaN;
         _loc9_ = null;
         _loc10_ = null;
         _loc11_ = null;
         _loc12_ = null;
         _loc13_ = null;
         _loc14_ = null;
         _loc15_ = null;
         _loc16_ = null;
         _loc17_ = null;
         _loc18_ = null;
         _loc19_ = null;
         _loc20_ = null;
         _loc21_ = null;
         _loc22_ = false;
         _loc23_ = false;
         _loc24_ = null;
         _loc25_ = null;
         _loc26_ = null;
         _loc27_ = null;
         _loc28_ = null;
         _loc29_ = NaN;
         _loc30_ = null;
         this.deleteResources();
         _loc5_ = new Vector.<Object3D>(2);
         _loc6_ = calculatePlane(param1,param2,param3);
         _loc7_ = _loc6_.w - param4;
         _loc8_ = _loc6_.w + param4;
         _loc9_ = this.vertexList;
         while(_loc9_ != null)
         {
            _loc10_ = _loc9_.next;
            _loc9_.next = null;
            _loc9_.offset = _loc9_.x * _loc6_.x + _loc9_.y * _loc6_.y + _loc9_.z * _loc6_.z;
            if(_loc9_.offset >= _loc7_ && _loc9_.offset <= _loc8_)
            {
               _loc9_.value = new Vertex();
               _loc9_.value.x = _loc9_.x;
               _loc9_.value.y = _loc9_.y;
               _loc9_.value.z = _loc9_.z;
               _loc9_.value.u = _loc9_.u;
               _loc9_.value.v = _loc9_.v;
               _loc9_.value.normalX = _loc9_.normalX;
               _loc9_.value.normalY = _loc9_.normalY;
               _loc9_.value.normalZ = _loc9_.normalZ;
            }
            _loc9_.transformId = 0;
            _loc9_ = _loc10_;
         }
         this.vertexList = null;
         _loc11_ = this.faceList;
         this.faceList = null;
         _loc12_ = this.clone() as Mesh;
         _loc13_ = this.clone() as Mesh;
         _loc16_ = _loc11_;
         while(_loc16_ != null)
         {
            _loc17_ = _loc16_.next;
            _loc18_ = _loc16_.wrapper;
            _loc19_ = _loc18_.vertex;
            _loc18_ = _loc18_.next;
            _loc20_ = _loc18_.vertex;
            _loc18_ = _loc18_.next;
            _loc21_ = _loc18_.vertex;
            _loc22_ = _loc19_.offset < _loc7_ || _loc20_.offset < _loc7_ || _loc21_.offset < _loc7_;
            _loc23_ = _loc19_.offset > _loc8_ || _loc20_.offset > _loc8_ || _loc21_.offset > _loc8_;
            _loc18_ = _loc18_.next;
            while(_loc18_ != null)
            {
               _loc9_ = _loc18_.vertex;
               if(_loc9_.offset < _loc7_)
               {
                  _loc22_ = true;
               }
               else if(_loc9_.offset > _loc8_)
               {
                  _loc23_ = true;
               }
               _loc18_ = _loc18_.next;
            }
            if(!_loc22_)
            {
               if(_loc15_ != null)
               {
                  _loc15_.next = _loc16_;
               }
               else
               {
                  _loc13_.faceList = _loc16_;
               }
               _loc15_ = _loc16_;
            }
            else if(!_loc23_)
            {
               if(_loc14_ != null)
               {
                  _loc14_.next = _loc16_;
               }
               else
               {
                  _loc12_.faceList = _loc16_;
               }
               _loc14_ = _loc16_;
               _loc18_ = _loc16_.wrapper;
               while(_loc18_ != null)
               {
                  if(_loc18_.vertex.value != null)
                  {
                     _loc18_.vertex = _loc18_.vertex.value;
                  }
                  _loc18_ = _loc18_.next;
               }
            }
            else
            {
               _loc24_ = new Face();
               _loc25_ = new Face();
               _loc26_ = null;
               _loc27_ = null;
               _loc18_ = _loc16_.wrapper.next.next;
               while(_loc18_.next != null)
               {
                  _loc18_ = _loc18_.next;
               }
               _loc19_ = _loc18_.vertex;
               _loc18_ = _loc16_.wrapper;
               while(_loc18_ != null)
               {
                  _loc20_ = _loc18_.vertex;
                  if(_loc19_.offset < _loc7_ && _loc20_.offset > _loc8_ || _loc19_.offset > _loc8_ && _loc20_.offset < _loc7_)
                  {
                     _loc29_ = (_loc6_.w - _loc19_.offset) / (_loc20_.offset - _loc19_.offset);
                     _loc9_ = new Vertex();
                     _loc9_.x = _loc19_.x + (_loc20_.x - _loc19_.x) * _loc29_;
                     _loc9_.y = _loc19_.y + (_loc20_.y - _loc19_.y) * _loc29_;
                     _loc9_.z = _loc19_.z + (_loc20_.z - _loc19_.z) * _loc29_;
                     _loc9_.u = _loc19_.u + (_loc20_.u - _loc19_.u) * _loc29_;
                     _loc9_.v = _loc19_.v + (_loc20_.v - _loc19_.v) * _loc29_;
                     _loc9_.normalX = _loc19_.normalX + (_loc20_.normalX - _loc19_.normalX) * _loc29_;
                     _loc9_.normalY = _loc19_.normalY + (_loc20_.normalY - _loc19_.normalY) * _loc29_;
                     _loc9_.normalZ = _loc19_.normalZ + (_loc20_.normalZ - _loc19_.normalZ) * _loc29_;
                     _loc28_ = new Wrapper();
                     _loc28_.vertex = _loc9_;
                     if(_loc26_ != null)
                     {
                        _loc26_.next = _loc28_;
                     }
                     else
                     {
                        _loc24_.wrapper = _loc28_;
                     }
                     _loc26_ = _loc28_;
                     _loc30_ = new Vertex();
                     _loc30_.x = _loc9_.x;
                     _loc30_.y = _loc9_.y;
                     _loc30_.z = _loc9_.z;
                     _loc30_.u = _loc9_.u;
                     _loc30_.v = _loc9_.v;
                     _loc30_.normalX = _loc9_.normalX;
                     _loc30_.normalY = _loc9_.normalY;
                     _loc30_.normalZ = _loc9_.normalZ;
                     _loc28_ = new Wrapper();
                     _loc28_.vertex = _loc30_;
                     if(_loc27_ != null)
                     {
                        _loc27_.next = _loc28_;
                     }
                     else
                     {
                        _loc25_.wrapper = _loc28_;
                     }
                     _loc27_ = _loc28_;
                  }
                  if(_loc20_.offset < _loc7_)
                  {
                     _loc28_ = _loc18_.create();
                     _loc28_.vertex = _loc20_;
                     if(_loc26_ != null)
                     {
                        _loc26_.next = _loc28_;
                     }
                     else
                     {
                        _loc24_.wrapper = _loc28_;
                     }
                     _loc26_ = _loc28_;
                  }
                  else if(_loc20_.offset > _loc8_)
                  {
                     _loc28_ = _loc18_.create();
                     _loc28_.vertex = _loc20_;
                     if(_loc27_ != null)
                     {
                        _loc27_.next = _loc28_;
                     }
                     else
                     {
                        _loc25_.wrapper = _loc28_;
                     }
                     _loc27_ = _loc28_;
                  }
                  else
                  {
                     _loc28_ = _loc18_.create();
                     _loc28_.vertex = _loc20_.value;
                     if(_loc26_ != null)
                     {
                        _loc26_.next = _loc28_;
                     }
                     else
                     {
                        _loc24_.wrapper = _loc28_;
                     }
                     _loc26_ = _loc28_;
                     _loc28_ = _loc18_.create();
                     _loc28_.vertex = _loc20_;
                     if(_loc27_ != null)
                     {
                        _loc27_.next = _loc28_;
                     }
                     else
                     {
                        _loc25_.wrapper = _loc28_;
                     }
                     _loc27_ = _loc28_;
                  }
                  _loc19_ = _loc20_;
                  _loc18_ = _loc18_.next;
               }
               _loc24_.material = _loc16_.material;
               _loc24_.calculateBestSequenceAndNormal();
               if(_loc14_ != null)
               {
                  _loc14_.next = _loc24_;
               }
               else
               {
                  _loc12_.faceList = _loc24_;
               }
               _loc14_ = _loc24_;
               _loc25_.material = _loc16_.material;
               _loc25_.calculateBestSequenceAndNormal();
               if(_loc15_ != null)
               {
                  _loc15_.next = _loc25_;
               }
               else
               {
                  _loc13_.faceList = _loc25_;
               }
               _loc15_ = _loc25_;
            }
            _loc16_ = _loc17_;
         }
         if(_loc14_ != null)
         {
            _loc14_.next = null;
            _loc12_.transformId++;
            _loc12_.collectVertices();
            _loc12_.calculateBounds();
            _loc5_[0] = _loc12_;
         }
         if(_loc15_ != null)
         {
            _loc15_.next = null;
            _loc13_.transformId++;
            _loc13_.collectVertices();
            _loc13_.calculateBounds();
            _loc5_[1] = _loc13_;
         }
         return _loc5_;
      }
      
      private function collectVertices() : void
      {
         var _loc1_:Face = null;
         var _loc2_:Wrapper = null;
         var _loc3_:Vertex = null;
         _loc1_ = null;
         _loc2_ = null;
         _loc3_ = null;
         _loc1_ = this.faceList;
         while(_loc1_ != null)
         {
            _loc2_ = _loc1_.wrapper;
            while(_loc2_ != null)
            {
               _loc3_ = _loc2_.vertex;
               if(_loc3_.transformId != transformId)
               {
                  _loc3_.next = this.vertexList;
                  this.vertexList = _loc3_;
                  _loc3_.transformId = transformId;
                  _loc3_.value = null;
               }
               _loc2_ = _loc2_.next;
            }
            _loc1_ = _loc1_.next;
         }
      }
   }
}