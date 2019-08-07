package alternativa.engine3d.containers
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.RayIntersectionData;
   import alternativa.engine3d.core.ShadowAtlas;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Occluder;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class KDContainer extends ConflictContainer
   {
      
      private static const treeSphere:Vector3D = new Vector3D();
      
      private static const splitCoordsX:Vector.<Number> = new Vector.<Number>();
      
      private static const splitCoordsY:Vector.<Number> = new Vector.<Number>();
      
      private static const splitCoordsZ:Vector.<Number> = new Vector.<Number>();
       
      
      public var debugAlphaFade:Number = 0.8;
      
      public var ignoreChildrenInCollider:Boolean = false;
      
      alternativa3d var root:KDNode;
      
      private var nearPlaneX:Number;
      
      private var nearPlaneY:Number;
      
      private var nearPlaneZ:Number;
      
      private var nearPlaneOffset:Number;
      
      private var farPlaneX:Number;
      
      private var farPlaneY:Number;
      
      private var farPlaneZ:Number;
      
      private var farPlaneOffset:Number;
      
      private var leftPlaneX:Number;
      
      private var leftPlaneY:Number;
      
      private var leftPlaneZ:Number;
      
      private var leftPlaneOffset:Number;
      
      private var rightPlaneX:Number;
      
      private var rightPlaneY:Number;
      
      private var rightPlaneZ:Number;
      
      private var rightPlaneOffset:Number;
      
      private var topPlaneX:Number;
      
      private var topPlaneY:Number;
      
      private var topPlaneZ:Number;
      
      private var topPlaneOffset:Number;
      
      private var bottomPlaneX:Number;
      
      private var bottomPlaneY:Number;
      
      private var bottomPlaneZ:Number;
      
      private var bottomPlaneOffset:Number;
      
      private var occluders:Vector.<Vertex>;
      
      private var numOccluders:int;
      
      private var materials:Dictionary;
      
      private var opaqueList:Object3D;
      
      private var transparent:Vector.<Object3D>;
      
      private var transparentLength:int = 0;
      
      public var receiversVertexBuffers:Vector.<VertexBufferResource>;
      
      public var receiversIndexBuffers:Vector.<IndexBufferResource>;
      
      private var isCreated:Boolean = false;
      
      public var batched:Boolean = true;
      
      public function KDContainer()
      {
         this.occluders = new Vector.<Vertex>();
         this.materials = new Dictionary();
         this.transparent = new Vector.<Object3D>();
         this.receiversVertexBuffers = new Vector.<VertexBufferResource>();
         this.receiversIndexBuffers = new Vector.<IndexBufferResource>();
         super();
      }
      
      public function createTree(param1:Vector.<Object3D>, param2:Vector.<Occluder> = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object3D = null;
         var _loc5_:Object3D = null;
         var _loc8_:Object3D = null;
         var _loc9_:Object3D = null;
         var _loc10_:Object3D = null;
         var _loc11_:Object3D = null;
         var _loc12_:Material = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Vertex = null;
         var _loc27_:Face = null;
         var _loc28_:Vertex = null;
         var _loc29_:Mesh = null;
         var _loc30_:Mesh = null;
         var _loc31_:BSP = null;
         var _loc32_:Vector.<Vector.<Number>> = null;
         var _loc33_:Vector.<Vector.<uint>> = null;
         this.destroyTree();
         var _loc6_:int = param1.length;
         var _loc7_:int = param2 != null?int(int(param2.length)):int(int(0));
         var _loc13_:Dictionary = new Dictionary();
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = param1[_loc3_];
            _loc12_ = _loc4_ is Mesh?(_loc4_ as Mesh).faceList.material:_loc4_ is BSP?(_loc4_ as BSP).faces[0].material:null;
            if(_loc12_ != null)
            {
               this.materials[_loc12_] = true;
               if(_loc12_.transparent)
               {
                  this.transparent[this.transparentLength] = _loc4_;
                  this.transparentLength++;
               }
               else
               {
                  _loc29_ = _loc13_[_loc12_];
                  if(_loc29_ == null)
                  {
                     _loc29_ = new Mesh();
                     _loc13_[_loc12_] = _loc29_;
                     _loc29_.next = this.opaqueList;
                     this.opaqueList = _loc29_;
                     _loc29_.setParent(this);
                  }
                  _loc4_ = _loc4_.clone();
                  _loc4_.composeMatrix();
                  if(_loc4_ is Mesh)
                  {
                     _loc30_ = _loc4_ as Mesh;
                     if(_loc30_.faceList != null)
                     {
                        _loc26_ = _loc30_.vertexList;
                        while(_loc26_ != null)
                        {
                           _loc20_ = _loc26_.x;
                           _loc21_ = _loc26_.y;
                           _loc22_ = _loc26_.z;
                           _loc26_.x = _loc4_.ma * _loc20_ + _loc4_.mb * _loc21_ + _loc4_.mc * _loc22_ + _loc4_.md;
                           _loc26_.y = _loc4_.me * _loc20_ + _loc4_.mf * _loc21_ + _loc4_.mg * _loc22_ + _loc4_.mh;
                           _loc26_.z = _loc4_.mi * _loc20_ + _loc4_.mj * _loc21_ + _loc4_.mk * _loc22_ + _loc4_.ml;
                           _loc23_ = _loc26_.normalX;
                           _loc24_ = _loc26_.normalY;
                           _loc25_ = _loc26_.normalZ;
                           _loc26_.normalX = _loc4_.ma * _loc23_ + _loc4_.mb * _loc24_ + _loc4_.mc * _loc25_;
                           _loc26_.normalY = _loc4_.me * _loc23_ + _loc4_.mf * _loc24_ + _loc4_.mg * _loc25_;
                           _loc26_.normalZ = _loc4_.mi * _loc23_ + _loc4_.mj * _loc24_ + _loc4_.mk * _loc25_;
                           _loc26_.transformId = 0;
                           if(_loc26_.next == null)
                           {
                              _loc28_ = _loc26_;
                           }
                           _loc26_ = _loc26_.next;
                        }
                        _loc28_.next = _loc29_.vertexList;
                        _loc29_.vertexList = _loc30_.vertexList;
                        _loc30_.vertexList = null;
                        _loc27_ = _loc30_.faceList;
                        while(_loc27_.next != null)
                        {
                           _loc27_ = _loc27_.next;
                        }
                        _loc27_.next = _loc29_.faceList;
                        _loc29_.faceList = _loc30_.faceList;
                        _loc30_.faceList = null;
                     }
                  }
                  else if(_loc4_ is BSP)
                  {
                     _loc31_ = _loc4_ as BSP;
                     if(_loc31_.root != null)
                     {
                        _loc26_ = _loc31_.vertexList;
                        while(_loc26_ != null)
                        {
                           _loc20_ = _loc26_.x;
                           _loc21_ = _loc26_.y;
                           _loc22_ = _loc26_.z;
                           _loc26_.x = _loc4_.ma * _loc20_ + _loc4_.mb * _loc21_ + _loc4_.mc * _loc22_ + _loc4_.md;
                           _loc26_.y = _loc4_.me * _loc20_ + _loc4_.mf * _loc21_ + _loc4_.mg * _loc22_ + _loc4_.mh;
                           _loc26_.z = _loc4_.mi * _loc20_ + _loc4_.mj * _loc21_ + _loc4_.mk * _loc22_ + _loc4_.ml;
                           _loc23_ = _loc26_.normalX;
                           _loc24_ = _loc26_.normalY;
                           _loc25_ = _loc26_.normalZ;
                           _loc26_.normalX = _loc4_.ma * _loc23_ + _loc4_.mb * _loc24_ + _loc4_.mc * _loc25_;
                           _loc26_.normalY = _loc4_.me * _loc23_ + _loc4_.mf * _loc24_ + _loc4_.mg * _loc25_;
                           _loc26_.normalZ = _loc4_.mi * _loc23_ + _loc4_.mj * _loc24_ + _loc4_.mk * _loc25_;
                           _loc26_.transformId = 0;
                           if(_loc26_.next == null)
                           {
                              _loc28_ = _loc26_;
                           }
                           _loc26_ = _loc26_.next;
                        }
                        _loc28_.next = _loc29_.vertexList;
                        _loc29_.vertexList = _loc31_.vertexList;
                        _loc31_.vertexList = null;
                        for each(_loc27_ in _loc31_.faces)
                        {
                           _loc27_.next = _loc29_.faceList;
                           _loc29_.faceList = _loc27_;
                        }
                        _loc31_.faces.length = 0;
                        _loc31_.root = null;
                     }
                  }
               }
            }
            _loc3_++;
         }
         for each(_loc29_ in _loc13_)
         {
            _loc29_.calculateFacesNormals(true);
            _loc29_.calculateBounds();
         }
         _loc14_ = 1.0e22;
         _loc15_ = 1.0e22;
         _loc16_ = 1.0e22;
         _loc17_ = -1.0e22;
         _loc18_ = -1.0e22;
         _loc19_ = -1.0e22;
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = this.createObjectBounds(_loc4_);
            if(_loc5_.boundMinX <= _loc5_.boundMaxX)
            {
               if(_loc4_._parent != null)
               {
                  _loc4_._parent.removeChild(_loc4_);
               }
               _loc4_.setParent(this);
               _loc4_.next = _loc8_;
               _loc8_ = _loc4_;
               _loc5_.next = _loc9_;
               _loc9_ = _loc5_;
               if(_loc5_.boundMinX < _loc14_)
               {
                  _loc14_ = _loc5_.boundMinX;
               }
               if(_loc5_.boundMaxX > _loc17_)
               {
                  _loc17_ = _loc5_.boundMaxX;
               }
               if(_loc5_.boundMinY < _loc15_)
               {
                  _loc15_ = _loc5_.boundMinY;
               }
               if(_loc5_.boundMaxY > _loc18_)
               {
                  _loc18_ = _loc5_.boundMaxY;
               }
               if(_loc5_.boundMinZ < _loc16_)
               {
                  _loc16_ = _loc5_.boundMinZ;
               }
               if(_loc5_.boundMaxZ > _loc19_)
               {
                  _loc19_ = _loc5_.boundMaxZ;
               }
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc4_ = param2[_loc3_];
            _loc5_ = this.createObjectBounds(_loc4_);
            if(_loc5_.boundMinX <= _loc5_.boundMaxX)
            {
               if(!(_loc5_.boundMinX < _loc14_ || _loc5_.boundMaxX > _loc17_ || _loc5_.boundMinY < _loc15_ || _loc5_.boundMaxY > _loc18_ || _loc5_.boundMinZ < _loc16_ || _loc5_.boundMaxZ > _loc19_))
               {
                  if(_loc4_._parent != null)
                  {
                     _loc4_._parent.removeChild(_loc4_);
                  }
                  _loc4_.setParent(this);
                  _loc4_.next = _loc10_;
                  _loc10_ = _loc4_;
                  _loc5_.next = _loc11_;
                  _loc11_ = _loc5_;
               }
            }
            _loc3_++;
         }
         if(_loc8_ != null)
         {
            this.root = this.createNode(_loc8_,_loc9_,_loc10_,_loc11_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_);
            _loc32_ = new Vector.<Vector.<Number>>();
            _loc33_ = new Vector.<Vector.<uint>>();
            _loc32_[0] = new Vector.<Number>();
            _loc33_[0] = new Vector.<uint>();
            this.root.createReceivers(_loc32_,_loc33_);
            _loc3_ = 0;
            while(_loc3_ < _loc32_.length)
            {
               this.receiversVertexBuffers[_loc3_] = new VertexBufferResource(_loc32_[_loc3_],3);
               this.receiversIndexBuffers[_loc3_] = new IndexBufferResource(_loc33_[_loc3_]);
               _loc3_++;
            }
         }
      }
	  
	  public function createTree1(param1:Vector.<Object3D>, param2:Vector.<Occluder> = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object3D = null;
         var _loc5_:Object3D = null;
         var _loc8_:Object3D = null;
         var _loc9_:Object3D = null;
         var _loc10_:Object3D = null;
         var _loc11_:Object3D = null;
         var _loc12_:Material = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Vertex = null;
         var _loc27_:Face = null;
         var _loc28_:Vertex = null;
         var _loc29_:Mesh = null;
         var _loc30_:Mesh = null;
         var _loc31_:BSP = null;
         var _loc32_:Vector.<Vector.<Number>> = null;
         var _loc33_:Vector.<Vector.<uint>> = null;
         //this.destroyTree();
         var _loc6_:int = param1.length;
         var _loc7_:int = param2 != null?int(int(param2.length)):int(int(0));
         var _loc13_:Dictionary = new Dictionary();
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = param1[_loc3_];
            _loc12_ = _loc4_ is Mesh?(_loc4_ as Mesh).faceList.material:_loc4_ is BSP?(_loc4_ as BSP).faces[0].material:null;
            if(_loc12_ != null)
            {
               this.materials[_loc12_] = true;
               if(_loc12_.transparent)
               {
                  this.transparent[this.transparentLength] = _loc4_;
                  this.transparentLength++;
               }
               else
               {
                  _loc29_ = _loc13_[_loc12_];
                  if(_loc29_ == null)
                  {
                     _loc29_ = new Mesh();
                     _loc13_[_loc12_] = _loc29_;
                     _loc29_.next = this.opaqueList;
                     this.opaqueList = _loc29_;
                     _loc29_.setParent(this);
                  }
                  _loc4_ = _loc4_.clone();
                  _loc4_.composeMatrix();
                  if(_loc4_ is Mesh)
                  {
                     _loc30_ = _loc4_ as Mesh;
                     if(_loc30_.faceList != null)
                     {
                        _loc26_ = _loc30_.vertexList;
                        while(_loc26_ != null)
                        {
                           _loc20_ = _loc26_.x;
                           _loc21_ = _loc26_.y;
                           _loc22_ = _loc26_.z;
                           _loc26_.x = _loc4_.ma * _loc20_ + _loc4_.mb * _loc21_ + _loc4_.mc * _loc22_ + _loc4_.md;
                           _loc26_.y = _loc4_.me * _loc20_ + _loc4_.mf * _loc21_ + _loc4_.mg * _loc22_ + _loc4_.mh;
                           _loc26_.z = _loc4_.mi * _loc20_ + _loc4_.mj * _loc21_ + _loc4_.mk * _loc22_ + _loc4_.ml;
                           _loc23_ = _loc26_.normalX;
                           _loc24_ = _loc26_.normalY;
                           _loc25_ = _loc26_.normalZ;
                           _loc26_.normalX = _loc4_.ma * _loc23_ + _loc4_.mb * _loc24_ + _loc4_.mc * _loc25_;
                           _loc26_.normalY = _loc4_.me * _loc23_ + _loc4_.mf * _loc24_ + _loc4_.mg * _loc25_;
                           _loc26_.normalZ = _loc4_.mi * _loc23_ + _loc4_.mj * _loc24_ + _loc4_.mk * _loc25_;
                           _loc26_.transformId = 0;
                           if(_loc26_.next == null)
                           {
                              _loc28_ = _loc26_;
                           }
                           _loc26_ = _loc26_.next;
                        }
                        _loc28_.next = _loc29_.vertexList;
                        _loc29_.vertexList = _loc30_.vertexList;
                        _loc30_.vertexList = null;
                        _loc27_ = _loc30_.faceList;
                        while(_loc27_.next != null)
                        {
                           _loc27_ = _loc27_.next;
                        }
                        _loc27_.next = _loc29_.faceList;
                        _loc29_.faceList = _loc30_.faceList;
                        _loc30_.faceList = null;
                     }
                  }
                  else if(_loc4_ is BSP)
                  {
                     _loc31_ = _loc4_ as BSP;
                     if(_loc31_.root != null)
                     {
                        _loc26_ = _loc31_.vertexList;
                        while(_loc26_ != null)
                        {
                           _loc20_ = _loc26_.x;
                           _loc21_ = _loc26_.y;
                           _loc22_ = _loc26_.z;
                           _loc26_.x = _loc4_.ma * _loc20_ + _loc4_.mb * _loc21_ + _loc4_.mc * _loc22_ + _loc4_.md;
                           _loc26_.y = _loc4_.me * _loc20_ + _loc4_.mf * _loc21_ + _loc4_.mg * _loc22_ + _loc4_.mh;
                           _loc26_.z = _loc4_.mi * _loc20_ + _loc4_.mj * _loc21_ + _loc4_.mk * _loc22_ + _loc4_.ml;
                           _loc23_ = _loc26_.normalX;
                           _loc24_ = _loc26_.normalY;
                           _loc25_ = _loc26_.normalZ;
                           _loc26_.normalX = _loc4_.ma * _loc23_ + _loc4_.mb * _loc24_ + _loc4_.mc * _loc25_;
                           _loc26_.normalY = _loc4_.me * _loc23_ + _loc4_.mf * _loc24_ + _loc4_.mg * _loc25_;
                           _loc26_.normalZ = _loc4_.mi * _loc23_ + _loc4_.mj * _loc24_ + _loc4_.mk * _loc25_;
                           _loc26_.transformId = 0;
                           if(_loc26_.next == null)
                           {
                              _loc28_ = _loc26_;
                           }
                           _loc26_ = _loc26_.next;
                        }
                        _loc28_.next = _loc29_.vertexList;
                        _loc29_.vertexList = _loc31_.vertexList;
                        _loc31_.vertexList = null;
                        for each(_loc27_ in _loc31_.faces)
                        {
                           _loc27_.next = _loc29_.faceList;
                           _loc29_.faceList = _loc27_;
                        }
                        _loc31_.faces.length = 0;
                        _loc31_.root = null;
                     }
                  }
               }
            }
            _loc3_++;
         }
         for each(_loc29_ in _loc13_)
         {
            _loc29_.calculateFacesNormals(true);
            _loc29_.calculateBounds();
         }
         _loc14_ = 1.0e22;
         _loc15_ = 1.0e22;
         _loc16_ = 1.0e22;
         _loc17_ = -1.0e22;
         _loc18_ = -1.0e22;
         _loc19_ = -1.0e22;
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = this.createObjectBounds(_loc4_);
            if(_loc5_.boundMinX <= _loc5_.boundMaxX)
            {
               if(_loc4_._parent != null)
               {
                  _loc4_._parent.removeChild(_loc4_);
               }
               _loc4_.setParent(this);
               _loc4_.next = _loc8_;
               _loc8_ = _loc4_;
               _loc5_.next = _loc9_;
               _loc9_ = _loc5_;
               if(_loc5_.boundMinX < _loc14_)
               {
                  _loc14_ = _loc5_.boundMinX;
               }
               if(_loc5_.boundMaxX > _loc17_)
               {
                  _loc17_ = _loc5_.boundMaxX;
               }
               if(_loc5_.boundMinY < _loc15_)
               {
                  _loc15_ = _loc5_.boundMinY;
               }
               if(_loc5_.boundMaxY > _loc18_)
               {
                  _loc18_ = _loc5_.boundMaxY;
               }
               if(_loc5_.boundMinZ < _loc16_)
               {
                  _loc16_ = _loc5_.boundMinZ;
               }
               if(_loc5_.boundMaxZ > _loc19_)
               {
                  _loc19_ = _loc5_.boundMaxZ;
               }
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc4_ = param2[_loc3_];
            _loc5_ = this.createObjectBounds(_loc4_);
            if(_loc5_.boundMinX <= _loc5_.boundMaxX)
            {
               if(!(_loc5_.boundMinX < _loc14_ || _loc5_.boundMaxX > _loc17_ || _loc5_.boundMinY < _loc15_ || _loc5_.boundMaxY > _loc18_ || _loc5_.boundMinZ < _loc16_ || _loc5_.boundMaxZ > _loc19_))
               {
                  if(_loc4_._parent != null)
                  {
                     _loc4_._parent.removeChild(_loc4_);
                  }
                  _loc4_.setParent(this);
                  _loc4_.next = _loc10_;
                  _loc10_ = _loc4_;
                  _loc5_.next = _loc11_;
                  _loc11_ = _loc5_;
               }
            }
            _loc3_++;
         }
         if(_loc8_ != null)
         {
            this.root = this.createNode(_loc8_,_loc9_,_loc10_,_loc11_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_);
            _loc32_ = new Vector.<Vector.<Number>>();
            _loc33_ = new Vector.<Vector.<uint>>();
            _loc32_[0] = new Vector.<Number>();
            _loc33_[0] = new Vector.<uint>();
            this.root.createReceivers(_loc32_,_loc33_);
            _loc3_ = 0;
            while(_loc3_ < _loc32_.length)
            {
               this.receiversVertexBuffers[_loc3_] = new VertexBufferResource(_loc32_[_loc3_],3);
               this.receiversIndexBuffers[_loc3_] = new IndexBufferResource(_loc33_[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      public function destroyTree() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:Object3D = null;
         var _loc4_:Mesh = null;
         var _loc5_:BSP = null;
         var _loc6_:TextureMaterial = null;
         for(_loc2_ in this.materials)
         {
            _loc6_ = _loc2_ as TextureMaterial;
            if(_loc6_.texture != null)
            {
               _loc6_.textureResource.reset();
            }
            if(_loc6_._textureATF != null)
            {
               _loc6_.textureATFResource.reset();
            }
            if(_loc6_._textureATFAlpha != null)
            {
               _loc6_.textureATFAlphaResource.reset();
            }
         }
         _loc3_ = this.opaqueList;
         while(_loc3_ != null)
         {
            if(_loc3_ is Mesh)
            {
               _loc4_ = _loc3_ as Mesh;
               if(_loc4_.vertexBuffer != null)
               {
                  _loc4_.vertexBuffer.reset();
               }
               if(_loc4_.indexBuffer != null)
               {
                  _loc4_.indexBuffer.reset();
               }
            }
            else if(_loc3_ is BSP)
            {
               _loc5_ = _loc3_ as BSP;
               if(_loc5_.vertexBuffer != null)
               {
                  _loc5_.vertexBuffer.reset();
               }
               if(_loc5_.indexBuffer != null)
               {
                  _loc5_.indexBuffer.reset();
               }
            }
            _loc3_ = _loc3_.next;
         }
         _loc1_ = 0;
         while(_loc1_ < this.transparentLength)
         {
            _loc3_ = this.transparent[_loc1_];
            if(_loc3_ is Mesh)
            {
               _loc4_ = _loc3_ as Mesh;
               if(_loc4_.vertexBuffer != null)
               {
                  _loc4_.vertexBuffer.reset();
               }
               if(_loc4_.indexBuffer != null)
               {
                  _loc4_.indexBuffer.reset();
               }
            }
            else if(_loc3_ is BSP)
            {
               _loc5_ = _loc3_ as BSP;
               if(_loc5_.vertexBuffer != null)
               {
                  _loc5_.vertexBuffer.reset();
               }
               if(_loc5_.indexBuffer != null)
               {
                  _loc5_.indexBuffer.reset();
               }
            }
            _loc1_++;
         }
         this.materials = new Dictionary();
         this.opaqueList = null;
         this.transparent.length = 0;
         this.transparentLength = 0;
         if(this.root != null)
         {
            this.destroyNode(this.root);
            this.root = null;
         }
         _loc1_ = 0;
         while(_loc1_ < this.receiversVertexBuffers.length)
         {
            VertexBufferResource(this.receiversVertexBuffers[_loc1_]).dispose();
            IndexBufferResource(this.receiversIndexBuffers[_loc1_]).dispose();
            _loc1_++;
         }
         this.receiversVertexBuffers.length = 0;
         this.receiversIndexBuffers.length = 0;
         this.isCreated = false;
      }
      
      override public function intersectRay(param1:Vector3D, param2:Vector3D, param3:Dictionary = null, param4:Camera3D = null) : RayIntersectionData
      {
         var _loc6_:RayIntersectionData = null;
         if(param3 != null && param3[this])
         {
            return null;
         }
         if(!boundIntersectRay(param1,param2,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return null;
         }
         var _loc5_:RayIntersectionData = super.intersectRay(param1,param2,param3,param4);
         if(this.root != null && boundIntersectRay(param1,param2,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ))
         {
            _loc6_ = this.intersectRayNode(this.root,param1,param2,param3,param4);
            if(_loc6_ != null && (_loc5_ == null || _loc6_.time < _loc5_.time))
            {
               _loc5_ = _loc6_;
            }
         }
         return _loc5_;
      }
      
      private function intersectRayNode(param1:KDNode, param2:Vector3D, param3:Vector3D, param4:Dictionary, param5:Camera3D) : RayIntersectionData
      {
         var _loc6_:RayIntersectionData = null;
         var _loc7_:Number = NaN;
         var _loc8_:Object3D = null;
         var _loc9_:Object3D = null;
         var _loc10_:Vector3D = null;
         var _loc11_:Vector3D = null;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:RayIntersectionData = null;
         if(param1.negative != null)
         {
            _loc12_ = param1.axis == 0;
            _loc13_ = param1.axis == 1;
            _loc14_ = (_loc12_?param2.x:_loc13_?param2.y:param2.z) - param1.coord;
            if(_loc14_ > 0)
            {
               if(boundIntersectRay(param2,param3,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ))
               {
                  _loc6_ = this.intersectRayNode(param1.positive,param2,param3,param4,param5);
                  if(_loc6_ != null)
                  {
                     return _loc6_;
                  }
               }
               _loc7_ = _loc12_?Number(Number(param3.x)):_loc13_?Number(Number(param3.y)):Number(Number(param3.z));
               if(_loc7_ < 0)
               {
                  _loc8_ = param1.objectList;
                  _loc9_ = param1.objectBoundList;
                  while(_loc8_ != null)
                  {
                     if(boundIntersectRay(param2,param3,_loc9_.boundMinX,_loc9_.boundMinY,_loc9_.boundMinZ,_loc9_.boundMaxX,_loc9_.boundMaxY,_loc9_.boundMaxZ))
                     {
                        _loc8_.composeMatrix();
                        _loc8_.invertMatrix();
                        if(_loc10_ == null)
                        {
                           _loc10_ = new Vector3D();
                           _loc11_ = new Vector3D();
                        }
                        _loc10_.x = _loc8_.ma * param2.x + _loc8_.mb * param2.y + _loc8_.mc * param2.z + _loc8_.md;
                        _loc10_.y = _loc8_.me * param2.x + _loc8_.mf * param2.y + _loc8_.mg * param2.z + _loc8_.mh;
                        _loc10_.z = _loc8_.mi * param2.x + _loc8_.mj * param2.y + _loc8_.mk * param2.z + _loc8_.ml;
                        _loc11_.x = _loc8_.ma * param3.x + _loc8_.mb * param3.y + _loc8_.mc * param3.z;
                        _loc11_.y = _loc8_.me * param3.x + _loc8_.mf * param3.y + _loc8_.mg * param3.z;
                        _loc11_.z = _loc8_.mi * param3.x + _loc8_.mj * param3.y + _loc8_.mk * param3.z;
                        _loc6_ = _loc8_.intersectRay(_loc10_,_loc11_,param4,param5);
                        if(_loc6_ != null)
                        {
                           return _loc6_;
                        }
                     }
                     _loc8_ = _loc8_.next;
                     _loc9_ = _loc9_.next;
                  }
                  if(boundIntersectRay(param2,param3,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ))
                  {
                     return this.intersectRayNode(param1.negative,param2,param3,param4,param5);
                  }
               }
            }
            else
            {
               if(boundIntersectRay(param2,param3,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ))
               {
                  _loc6_ = this.intersectRayNode(param1.negative,param2,param3,param4,param5);
                  if(_loc6_ != null)
                  {
                     return _loc6_;
                  }
               }
               _loc7_ = _loc12_?Number(Number(param3.x)):_loc13_?Number(Number(param3.y)):Number(Number(param3.z));
               if(_loc7_ > 0)
               {
                  _loc8_ = param1.objectList;
                  _loc9_ = param1.objectBoundList;
                  while(_loc8_ != null)
                  {
                     if(boundIntersectRay(param2,param3,_loc9_.boundMinX,_loc9_.boundMinY,_loc9_.boundMinZ,_loc9_.boundMaxX,_loc9_.boundMaxY,_loc9_.boundMaxZ))
                     {
                        _loc8_.composeMatrix();
                        _loc8_.invertMatrix();
                        if(_loc10_ == null)
                        {
                           _loc10_ = new Vector3D();
                           _loc11_ = new Vector3D();
                        }
                        _loc10_.x = _loc8_.ma * param2.x + _loc8_.mb * param2.y + _loc8_.mc * param2.z + _loc8_.md;
                        _loc10_.y = _loc8_.me * param2.x + _loc8_.mf * param2.y + _loc8_.mg * param2.z + _loc8_.mh;
                        _loc10_.z = _loc8_.mi * param2.x + _loc8_.mj * param2.y + _loc8_.mk * param2.z + _loc8_.ml;
                        _loc11_.x = _loc8_.ma * param3.x + _loc8_.mb * param3.y + _loc8_.mc * param3.z;
                        _loc11_.y = _loc8_.me * param3.x + _loc8_.mf * param3.y + _loc8_.mg * param3.z;
                        _loc11_.z = _loc8_.mi * param3.x + _loc8_.mj * param3.y + _loc8_.mk * param3.z;
                        _loc6_ = _loc8_.intersectRay(_loc10_,_loc11_,param4,param5);
                        if(_loc6_ != null)
                        {
                           return _loc6_;
                        }
                     }
                     _loc8_ = _loc8_.next;
                     _loc9_ = _loc9_.next;
                  }
                  if(boundIntersectRay(param2,param3,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ))
                  {
                     return this.intersectRayNode(param1.positive,param2,param3,param4,param5);
                  }
               }
            }
            return null;
         }
         _loc15_ = 1.0e22;
         _loc8_ = param1.objectList;
         while(_loc8_ != null)
         {
            _loc8_.composeMatrix();
            _loc8_.invertMatrix();
            if(_loc10_ == null)
            {
               _loc10_ = new Vector3D();
               _loc11_ = new Vector3D();
            }
            _loc10_.x = _loc8_.ma * param2.x + _loc8_.mb * param2.y + _loc8_.mc * param2.z + _loc8_.md;
            _loc10_.y = _loc8_.me * param2.x + _loc8_.mf * param2.y + _loc8_.mg * param2.z + _loc8_.mh;
            _loc10_.z = _loc8_.mi * param2.x + _loc8_.mj * param2.y + _loc8_.mk * param2.z + _loc8_.ml;
            _loc11_.x = _loc8_.ma * param3.x + _loc8_.mb * param3.y + _loc8_.mc * param3.z;
            _loc11_.y = _loc8_.me * param3.x + _loc8_.mf * param3.y + _loc8_.mg * param3.z;
            _loc11_.z = _loc8_.mi * param3.x + _loc8_.mj * param3.y + _loc8_.mk * param3.z;
            _loc6_ = _loc8_.intersectRay(_loc10_,_loc11_,param4,param5);
            if(_loc6_ != null && _loc6_.time < _loc15_)
            {
               _loc15_ = _loc6_.time;
               _loc16_ = _loc6_;
            }
            _loc8_ = _loc8_.next;
         }
         return _loc16_;
      }
      
      override alternativa3d function checkIntersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Dictionary) : Boolean
      {
         if(super.checkIntersection(param1,param2,param3,param4,param5,param6,param7,param8))
         {
            return true;
         }
         if(this.root != null && boundCheckIntersection(param1,param2,param3,param4,param5,param6,param7,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ))
         {
            return this.checkIntersectionNode(this.root,param1,param2,param3,param4,param5,param6,param7,param8);
         }
         return false;
      }
      
      private function checkIntersectionNode(param1:KDNode, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Dictionary) : Boolean
      {
         var _loc10_:Object3D = null;
         var _loc11_:Object3D = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         if(param1.negative != null)
         {
            _loc19_ = param1.axis == 0;
            _loc20_ = param1.axis == 1;
            _loc21_ = (_loc19_?param2:_loc20_?param3:param4) - param1.coord;
            _loc22_ = _loc19_?Number(Number(param5)):_loc20_?Number(Number(param6)):Number(Number(param7));
            if(_loc21_ > 0)
            {
               if(_loc22_ < 0)
               {
                  _loc18_ = -_loc21_ / _loc22_;
                  if(_loc18_ < param8)
                  {
                     _loc10_ = param1.objectList;
                     _loc11_ = param1.objectBoundList;
                     while(_loc10_ != null)
                     {
                        if(boundCheckIntersection(param2,param3,param4,param5,param6,param7,param8,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ))
                        {
                           _loc10_.composeMatrix();
                           _loc10_.invertMatrix();
                           _loc12_ = _loc10_.ma * param2 + _loc10_.mb * param3 + _loc10_.mc * param4 + _loc10_.md;
                           _loc13_ = _loc10_.me * param2 + _loc10_.mf * param3 + _loc10_.mg * param4 + _loc10_.mh;
                           _loc14_ = _loc10_.mi * param2 + _loc10_.mj * param3 + _loc10_.mk * param4 + _loc10_.ml;
                           _loc15_ = _loc10_.ma * param5 + _loc10_.mb * param6 + _loc10_.mc * param7;
                           _loc16_ = _loc10_.me * param5 + _loc10_.mf * param6 + _loc10_.mg * param7;
                           _loc17_ = _loc10_.mi * param5 + _loc10_.mj * param6 + _loc10_.mk * param7;
                           if(_loc10_.checkIntersection(_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,param8,param9))
                           {
                              return true;
                           }
                        }
                        _loc10_ = _loc10_.next;
                        _loc11_ = _loc11_.next;
                     }
                     if(boundCheckIntersection(param2,param3,param4,param5,param6,param7,param8,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ) && this.checkIntersectionNode(param1.negative,param2,param3,param4,param5,param6,param7,param8,param9))
                     {
                        return true;
                     }
                  }
               }
               return boundCheckIntersection(param2,param3,param4,param5,param6,param7,param8,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ) && this.checkIntersectionNode(param1.positive,param2,param3,param4,param5,param6,param7,param8,param9);
            }
            if(_loc22_ > 0)
            {
               _loc18_ = -_loc21_ / _loc22_;
               if(_loc18_ < param8)
               {
                  _loc10_ = param1.objectList;
                  _loc11_ = param1.objectBoundList;
                  while(_loc10_ != null)
                  {
                     if(boundCheckIntersection(param2,param3,param4,param5,param6,param7,param8,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ))
                     {
                        _loc10_.composeMatrix();
                        _loc10_.invertMatrix();
                        _loc12_ = _loc10_.ma * param2 + _loc10_.mb * param3 + _loc10_.mc * param4 + _loc10_.md;
                        _loc13_ = _loc10_.me * param2 + _loc10_.mf * param3 + _loc10_.mg * param4 + _loc10_.mh;
                        _loc14_ = _loc10_.mi * param2 + _loc10_.mj * param3 + _loc10_.mk * param4 + _loc10_.ml;
                        _loc15_ = _loc10_.ma * param5 + _loc10_.mb * param6 + _loc10_.mc * param7;
                        _loc16_ = _loc10_.me * param5 + _loc10_.mf * param6 + _loc10_.mg * param7;
                        _loc17_ = _loc10_.mi * param5 + _loc10_.mj * param6 + _loc10_.mk * param7;
                        if(_loc10_.checkIntersection(_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,param8,param9))
                        {
                           return true;
                        }
                     }
                     _loc10_ = _loc10_.next;
                     _loc11_ = _loc11_.next;
                  }
                  if(boundCheckIntersection(param2,param3,param4,param5,param6,param7,param8,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ) && this.checkIntersectionNode(param1.positive,param2,param3,param4,param5,param6,param7,param8,param9))
                  {
                     return true;
                  }
               }
            }
            return boundCheckIntersection(param2,param3,param4,param5,param6,param7,param8,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ) && this.checkIntersectionNode(param1.negative,param2,param3,param4,param5,param6,param7,param8,param9);
         }
         _loc10_ = param1.objectList;
         while(_loc10_ != null)
         {
            _loc10_.composeMatrix();
            _loc10_.invertMatrix();
            _loc12_ = _loc10_.ma * param2 + _loc10_.mb * param3 + _loc10_.mc * param4 + _loc10_.md;
            _loc13_ = _loc10_.me * param2 + _loc10_.mf * param3 + _loc10_.mg * param4 + _loc10_.mh;
            _loc14_ = _loc10_.mi * param2 + _loc10_.mj * param3 + _loc10_.mk * param4 + _loc10_.ml;
            _loc15_ = _loc10_.ma * param5 + _loc10_.mb * param6 + _loc10_.mc * param7;
            _loc16_ = _loc10_.me * param5 + _loc10_.mf * param6 + _loc10_.mg * param7;
            _loc17_ = _loc10_.mi * param5 + _loc10_.mj * param6 + _loc10_.mk * param7;
            if(_loc10_.checkIntersection(_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,param8,param9))
            {
               return true;
            }
            _loc10_ = _loc10_.next;
         }
         return false;
      }
      
      override alternativa3d function collectPlanes(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:Vector3D, param6:Vector.<Face>, param7:Dictionary = null) : void
      {
         var _loc9_:Object3D = null;
         if(param7 != null && param7[this])
         {
            return;
         }
         var _loc8_:Vector3D = calculateSphere(param1,param2,param3,param4,param5,treeSphere);
         if(!this.ignoreChildrenInCollider)
         {
            if(!boundIntersectSphere(_loc8_,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
            {
               return;
            }
            _loc9_ = childrenList;
            while(_loc9_ != null)
            {
               _loc9_.composeAndAppend(this);
               _loc9_.collectPlanes(param1,param2,param3,param4,param5,param6,param7);
               _loc9_ = _loc9_.next;
            }
         }
         if(this.root != null && boundIntersectSphere(_loc8_,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ))
         {
            this.collectPlanesNode(this.root,_loc8_,param1,param2,param3,param4,param5,param6,param7);
         }
      }
      
      private function collectPlanesNode(param1:KDNode, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:Vector3D, param6:Vector3D, param7:Vector3D, param8:Vector.<Face>, param9:Dictionary = null) : void
      {
         var _loc10_:Object3D = null;
         var _loc11_:Object3D = null;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Number = NaN;
         if(param1.negative != null)
         {
            _loc12_ = param1.axis == 0;
            _loc13_ = param1.axis == 1;
            _loc14_ = (_loc12_?param2.x:_loc13_?param2.y:param2.z) - param1.coord;
            if(_loc14_ >= param2.w)
            {
               if(boundIntersectSphere(param2,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ))
               {
                  this.collectPlanesNode(param1.positive,param2,param3,param4,param5,param6,param7,param8,param9);
               }
            }
            else if(_loc14_ <= -param2.w)
            {
               if(boundIntersectSphere(param2,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ))
               {
                  this.collectPlanesNode(param1.negative,param2,param3,param4,param5,param6,param7,param8,param9);
               }
            }
            else
            {
               _loc10_ = param1.objectList;
               _loc11_ = param1.objectBoundList;
               while(_loc10_ != null)
               {
                  if(boundIntersectSphere(param2,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ))
                  {
                     _loc10_.composeAndAppend(this);
                     _loc10_.collectPlanes(param3,param4,param5,param6,param7,param8,param9);
                  }
                  _loc10_ = _loc10_.next;
                  _loc11_ = _loc11_.next;
               }
               if(boundIntersectSphere(param2,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ))
               {
                  this.collectPlanesNode(param1.positive,param2,param3,param4,param5,param6,param7,param8,param9);
               }
               if(boundIntersectSphere(param2,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ))
               {
                  this.collectPlanesNode(param1.negative,param2,param3,param4,param5,param6,param7,param8,param9);
               }
            }
         }
         else
         {
            _loc10_ = param1.objectList;
            while(_loc10_ != null)
            {
               _loc10_.composeAndAppend(this);
               _loc10_.collectPlanes(param3,param4,param5,param6,param7,param8,param9);
               _loc10_ = _loc10_.next;
            }
         }
      }
      
      public function createDecal(param1:Vector3D, param2:Vector3D, param3:Number, param4:Number, param5:Number, param6:Number, param7:Material) : Decal
      {
         var _loc8_:Decal = new Decal();
         _loc8_.attenuation = param6;
         var _loc9_:Matrix3D = new Matrix3D();
         _loc9_.appendRotation(param4 * 180 / Math.PI,Vector3D.Z_AXIS);
         _loc9_.appendRotation(Math.atan2(-param2.z,Math.sqrt(param2.x * param2.x + param2.y * param2.y)) * 180 / Math.PI - 90,Vector3D.X_AXIS);
         _loc9_.appendRotation(-Math.atan2(-param2.x,-param2.y) * 180 / Math.PI,Vector3D.Z_AXIS);
         _loc9_.appendTranslation(param1.x,param1.y,param1.z);
         _loc8_.matrix = _loc9_;
         _loc8_.composeMatrix();
         _loc8_.boundMinX = -param3;
         _loc8_.boundMaxX = param3;
         _loc8_.boundMinY = -param3;
         _loc8_.boundMaxY = param3;
         _loc8_.boundMinZ = -param6;
         _loc8_.boundMaxZ = param6;
         var _loc10_:Number = 1.0e22;
         var _loc11_:Number = 1.0e22;
         var _loc12_:Number = 1.0e22;
         var _loc13_:Number = -1.0e22;
         var _loc14_:Number = -1.0e22;
         var _loc15_:Number = -1.0e22;
         var _loc16_:Vertex = boundVertexList;
         _loc16_.x = _loc8_.boundMinX;
         _loc16_.y = _loc8_.boundMinY;
         _loc16_.z = _loc8_.boundMinZ;
         _loc16_ = _loc16_.next;
         _loc16_.x = _loc8_.boundMaxX;
         _loc16_.y = _loc8_.boundMinY;
         _loc16_.z = _loc8_.boundMinZ;
         _loc16_ = _loc16_.next;
         _loc16_.x = _loc8_.boundMinX;
         _loc16_.y = _loc8_.boundMaxY;
         _loc16_.z = _loc8_.boundMinZ;
         _loc16_ = _loc16_.next;
         _loc16_.x = _loc8_.boundMaxX;
         _loc16_.y = _loc8_.boundMaxY;
         _loc16_.z = _loc8_.boundMinZ;
         _loc16_ = _loc16_.next;
         _loc16_.x = _loc8_.boundMinX;
         _loc16_.y = _loc8_.boundMinY;
         _loc16_.z = _loc8_.boundMaxZ;
         _loc16_ = _loc16_.next;
         _loc16_.x = _loc8_.boundMaxX;
         _loc16_.y = _loc8_.boundMinY;
         _loc16_.z = _loc8_.boundMaxZ;
         _loc16_ = _loc16_.next;
         _loc16_.x = _loc8_.boundMinX;
         _loc16_.y = _loc8_.boundMaxY;
         _loc16_.z = _loc8_.boundMaxZ;
         _loc16_ = _loc16_.next;
         _loc16_.x = _loc8_.boundMaxX;
         _loc16_.y = _loc8_.boundMaxY;
         _loc16_.z = _loc8_.boundMaxZ;
         _loc16_ = boundVertexList;
         while(_loc16_ != null)
         {
            _loc16_.cameraX = _loc8_.ma * _loc16_.x + _loc8_.mb * _loc16_.y + _loc8_.mc * _loc16_.z + _loc8_.md;
            _loc16_.cameraY = _loc8_.me * _loc16_.x + _loc8_.mf * _loc16_.y + _loc8_.mg * _loc16_.z + _loc8_.mh;
            _loc16_.cameraZ = _loc8_.mi * _loc16_.x + _loc8_.mj * _loc16_.y + _loc8_.mk * _loc16_.z + _loc8_.ml;
            if(_loc16_.cameraX < _loc10_)
            {
               _loc10_ = _loc16_.cameraX;
            }
            if(_loc16_.cameraX > _loc13_)
            {
               _loc13_ = _loc16_.cameraX;
            }
            if(_loc16_.cameraY < _loc11_)
            {
               _loc11_ = _loc16_.cameraY;
            }
            if(_loc16_.cameraY > _loc14_)
            {
               _loc14_ = _loc16_.cameraY;
            }
            if(_loc16_.cameraZ < _loc12_)
            {
               _loc12_ = _loc16_.cameraZ;
            }
            if(_loc16_.cameraZ > _loc15_)
            {
               _loc15_ = _loc16_.cameraZ;
            }
            _loc16_ = _loc16_.next;
         }
         _loc8_.invertMatrix();
         if(param5 > Math.PI / 2)
         {
            param5 = Math.PI / 2;
         }
         if(this.root != null)
         {
            this.root.collectPolygons(_loc8_,Math.sqrt(-param3 * param3 + -param3 * param3 + param6 * param6),Math.cos(param5) - 0.001,_loc10_,_loc13_,_loc11_,_loc14_,_loc12_,_loc15_);
         }
         if(_loc8_.faceList != null)
         {
            _loc8_.calculateBounds();
         }
         else
         {
            _loc8_.boundMinX = -1;
            _loc8_.boundMinY = -1;
            _loc8_.boundMinZ = -1;
            _loc8_.boundMaxX = 1;
            _loc8_.boundMaxY = 1;
            _loc8_.boundMaxZ = 1;
         }
         _loc8_.setMaterialToAllFaces(param7);
         return _loc8_;
      }
	  
	  public function createShad(param1:Vector3D, param2:Vector3D, param3:Object3D, param4:Number, param7:Material) : Decal
      {
         var _loc8_:Decal = new Decal();
         _loc8_.attenuation = 300;
         var _loc9_:Matrix3D = new Matrix3D();
         _loc9_.appendRotation(param4 * 180 / Math.PI,Vector3D.Z_AXIS);
         _loc9_.appendRotation(Math.atan2(-param2.z,Math.sqrt(param2.x * param2.x + param2.y * param2.y)) * 180 / Math.PI - 90,Vector3D.X_AXIS);
         _loc9_.appendRotation(-Math.atan2(-param2.x,-param2.y) * 180 / Math.PI,Vector3D.Z_AXIS);
         _loc9_.appendTranslation(param1.x,param1.y,param1.z);
         _loc8_.matrix = _loc9_;
         _loc8_.composeMatrix();
		 _loc8_.createGeometry(param3);
         _loc8_.setMaterialToAllFaces(param7);
         return _loc8_;
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:KDContainer = new KDContainer();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         super.clonePropertiesFrom(param1);
         var _loc2_:KDContainer = param1 as KDContainer;
         this.debugAlphaFade = _loc2_.debugAlphaFade;
         if(_loc2_.root != null)
         {
            this.root = _loc2_.cloneNode(_loc2_.root,this);
         }
      }
      
      private function cloneNode(param1:KDNode, param2:Object3DContainer) : KDNode
      {
         var _loc4_:Object3D = null;
         var _loc5_:Object3D = null;
         var _loc6_:Object3D = null;
         var _loc3_:KDNode = new KDNode();
         _loc3_.axis = param1.axis;
         _loc3_.coord = param1.coord;
         _loc3_.minCoord = param1.minCoord;
         _loc3_.maxCoord = param1.maxCoord;
         _loc3_.boundMinX = param1.boundMinX;
         _loc3_.boundMinY = param1.boundMinY;
         _loc3_.boundMinZ = param1.boundMinZ;
         _loc3_.boundMaxX = param1.boundMaxX;
         _loc3_.boundMaxY = param1.boundMaxY;
         _loc3_.boundMaxZ = param1.boundMaxZ;
         _loc4_ = param1.objectList;
         _loc5_ = null;
         while(_loc4_ != null)
         {
            _loc6_ = _loc4_.clone();
            if(_loc3_.objectList != null)
            {
               _loc5_.next = _loc6_;
            }
            else
            {
               _loc3_.objectList = _loc6_;
            }
            _loc5_ = _loc6_;
            _loc6_.setParent(param2);
            _loc4_ = _loc4_.next;
         }
         _loc4_ = param1.objectBoundList;
         _loc5_ = null;
         while(_loc4_ != null)
         {
            _loc6_ = _loc4_.clone();
            if(_loc3_.objectBoundList != null)
            {
               _loc5_.next = _loc6_;
            }
            else
            {
               _loc3_.objectBoundList = _loc6_;
            }
            _loc5_ = _loc6_;
            _loc4_ = _loc4_.next;
         }
         _loc4_ = param1.occluderList;
         _loc5_ = null;
         while(_loc4_ != null)
         {
            _loc6_ = _loc4_.clone();
            if(_loc3_.occluderList != null)
            {
               _loc5_.next = _loc6_;
            }
            else
            {
               _loc3_.occluderList = _loc6_;
            }
            _loc5_ = _loc6_;
            _loc6_.setParent(param2);
            _loc4_ = _loc4_.next;
         }
         _loc4_ = param1.occluderBoundList;
         _loc5_ = null;
         while(_loc4_ != null)
         {
            _loc6_ = _loc4_.clone();
            if(_loc3_.occluderBoundList != null)
            {
               _loc5_.next = _loc6_;
            }
            else
            {
               _loc3_.occluderBoundList = _loc6_;
            }
            _loc5_ = _loc6_;
            _loc4_ = _loc4_.next;
         }
         if(param1.negative != null)
         {
            _loc3_.negative = this.cloneNode(param1.negative,param2);
         }
         if(param1.positive != null)
         {
            _loc3_.positive = this.cloneNode(param1.positive,param2);
         }
         return _loc3_;
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object3D = null;
         var _loc4_:VG = null;
         var _loc5_:VG = null;
         var _loc7_:Boolean = false;
         var _loc8_:Object3D = null;
         var _loc9_:VG = null;
         var _loc10_:int = 0;
         var _loc11_:Vertex = null;
         var _loc12_:Vertex = null;
         var _loc13_:ShadowAtlas = null;
         this.uploadResources(param1.device);
         calculateInverseMatrix();
         var _loc6_:int = param1.debug?int(int(param1.checkInDebug(this))):int(int(0));
         if(_loc6_ & Debug.BOUNDS)
         {
            Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
         if(this.batched)
         {
            _loc7_ = param1.debug;
            if(_loc6_ && _loc6_ & Debug.NODES)
            {
               param1.debug = false;
            }
            _loc3_ = this.opaqueList;
            while(_loc3_ != null)
            {
               _loc3_.ma = ma;
               _loc3_.mb = mb;
               _loc3_.mc = mc;
               _loc3_.md = md;
               _loc3_.me = me;
               _loc3_.mf = mf;
               _loc3_.mg = mg;
               _loc3_.mh = mh;
               _loc3_.mi = mi;
               _loc3_.mj = mj;
               _loc3_.mk = mk;
               _loc3_.ml = ml;
               _loc3_.concat(this);
               _loc3_.draw(param1);
               if(!param1.view.constrained && param1.shadowMap != null && param1.shadowMapStrength > 0 && _loc3_.concatenatedAlpha >= _loc3_.shadowMapAlphaThreshold && _loc3_.useDepth)
               {
					param1.casterObjects[param1.casterCount] = _loc3_;
					param1.casterCount++;
               }
               _loc3_ = _loc3_.next;
            }
            param1.debug = _loc7_;
            _loc5_ = super.getVG(param1);
            if(!param1.view.constrained && param1.shadowMap != null && param1.shadowMapStrength > 0)
            {
               _loc3_ = childrenList;
               while(_loc3_ != null)
               {
                  if(_loc3_.visible)
                  {
                     if(_loc3_ is Mesh || _loc3_ is BSP || _loc3_ is Sprite3D)
                     {
                        if(_loc3_.concatenatedAlpha > 0 && _loc3_.useDepth)//>= _loc3_.shadowMapAlphaThreshold)
                        {
								param1.casterObjects[param1.casterCount] = _loc3_;
								param1.casterCount++;
                        }
                     }
                     else if(_loc3_ is Object3DContainer)
                     {
                        _loc8_ = Object3DContainer(_loc3_).childrenList;
                        while(_loc8_ != null)
                        {
                           if((_loc8_ is Mesh || _loc8_ is BSP || _loc8_ is Sprite3D) && _loc8_.concatenatedAlpha > 0 && _loc3_.useDepth)//>= _loc8_.shadowMapAlphaThreshold)
                           {
									param1.casterObjects[param1.casterCount] = _loc8_;
									param1.casterCount++;
                           }
                           _loc8_ = _loc8_.next;
                        }
                     }
                  }
                  _loc3_ = _loc3_.next;
               }
            }
            _loc2_ = 0;
            while(_loc2_ < this.transparentLength)
            {
               _loc3_ = this.transparent[_loc2_];
               _loc3_.composeAndAppend(this);
               if(_loc3_.cullingInCamera(param1,culling) >= 0)
               {
                  _loc3_.concat(this);
                  _loc9_ = _loc3_.getVG(param1);
                  if(_loc9_ != null)
                  {
                     _loc9_.next = _loc5_;
                     _loc5_ = _loc9_;
                  }
               }
               if(!param1.view.constrained && param1.shadowMap != null && param1.shadowMapStrength > 0 && _loc3_.concatenatedAlpha > 0 && _loc3_.useDepth)//>= _loc3_.shadowMapAlphaThreshold)
               if(!param1.view.constrained && param1.shadowMap != null && param1.shadowMapStrength > 0 && _loc3_.concatenatedAlpha > 0 && _loc3_.useDepth)//>= _loc3_.shadowMapAlphaThreshold)
               {
                  param1.casterObjects[param1.casterCount] = _loc3_;
                  param1.casterCount++;
               }
               _loc2_++;
            }
            if(_loc5_ != null)
            {
               if(_loc5_.next != null)
               {
                  if(resolveByAABB)
                  {
                     _loc4_ = _loc5_;
                     while(_loc4_ != null)
                     {
                        _loc4_.calculateAABB(ima,imb,imc,imd,ime,imf,img,imh,imi,imj,imk,iml);
                        _loc4_ = _loc4_.next;
                     }
                     drawAABBGeometry(param1,_loc5_);
                  }
                  else if(resolveByOOBB)
                  {
                     _loc4_ = _loc5_;
                     while(_loc4_ != null)
                     {
                        _loc4_.calculateOOBB(this);
                        _loc4_ = _loc4_.next;
                     }
                     drawOOBBGeometry(param1,_loc5_);
                  }
                  else
                  {
                     drawConflictGeometry(param1,_loc5_);
                  }
               }
               else
               {
                  _loc5_.draw(param1,threshold,this);
                  _loc5_.destroy();
               }
            }
         }
         else if(this.root != null)
         {
            this.calculateCameraPlanes(param1.nearClipping,param1.farClipping);
            _loc10_ = this.cullingInContainer(culling,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ);
            if(_loc10_ >= 0)
            {
               this.numOccluders = 0;
               if(param1.numOccluders > 0)
               {
                  this.updateOccluders(param1);
               }
               _loc5_ = super.getVG(param1);
               _loc4_ = _loc5_;
               while(_loc4_ != null)
               {
                  _loc4_.calculateAABB(ima,imb,imc,imd,ime,imf,img,imh,imi,imj,imk,iml);
                  _loc4_ = _loc4_.next;
               }
               this.drawNode(this.root,_loc10_,param1,_loc5_);
               _loc2_ = 0;
               while(_loc2_ < this.numOccluders)
               {
                  _loc11_ = this.occluders[_loc2_];
                  _loc12_ = _loc11_;
                  while(_loc12_.next != null)
                  {
                     _loc12_ = _loc12_.next;
                  }
                  _loc12_.next = Vertex.collector;
                  Vertex.collector = _loc11_;
                  this.occluders[_loc2_] = null;
                  _loc2_++;
               }
               this.numOccluders = 0;
            }
            else
            {
               super.draw(param1);
            }
         }
         else
         {
            super.draw(param1);
         }
         if(this.root != null && _loc6_ & Debug.NODES)
         {
            this.debugNode(this.root,_loc10_,param1,1);
            Debug.drawBounds(param1,this,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ,14496733);
         }
         if(this.root != null)
         {
            param1.receiversVertexBuffers = this.receiversVertexBuffers;
            param1.receiversIndexBuffers = this.receiversIndexBuffers;
            for each(_loc13_ in param1.shadowAtlases)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc13_.shadowsCount)
               {
                  this.root.collectReceivers(_loc13_.shadows[_loc2_]);
                  _loc2_++;
               }
            }
         }
      }
      
      override alternativa3d function getVG(param1:Camera3D) : VG
      {
         var _loc3_:int = 0;
         var _loc2_:VG = super.getVG(param1);
         if(this.root != null)
         {
            this.numOccluders = 0;
            calculateInverseMatrix();
            this.calculateCameraPlanes(param1.nearClipping,param1.farClipping);
            _loc3_ = this.cullingInContainer(culling,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ);
            if(_loc3_ >= 0)
            {
               _loc2_ = this.collectVGNode(this.root,_loc3_,param1,_loc2_);
            }
         }
         return _loc2_;
      }
      
      private function collectVGNode(param1:KDNode, param2:int, param3:Camera3D, param4:VG = null) : VG
      {
         var _loc5_:VG = null;
         var _loc6_:VG = null;
         var _loc9_:VG = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc7_:Object3D = param1.objectList;
         var _loc8_:Object3D = param1.objectBoundList;
         while(_loc7_ != null)
         {
            if(_loc7_.visible && ((_loc7_.culling = param2) == 0 || (_loc7_.culling = this.cullingInContainer(param2,_loc8_.boundMinX,_loc8_.boundMinY,_loc8_.boundMinZ,_loc8_.boundMaxX,_loc8_.boundMaxY,_loc8_.boundMaxZ)) >= 0))
            {
               _loc7_.composeAndAppend(this);
               _loc7_.concat(this);
               _loc9_ = _loc7_.getVG(param3);
               if(_loc9_ != null)
               {
                  if(_loc5_ != null)
                  {
                     _loc6_.next = _loc9_;
                  }
                  else
                  {
                     _loc5_ = _loc9_;
                     _loc6_ = _loc9_;
                  }
                  while(_loc6_.next != null)
                  {
                     _loc6_ = _loc6_.next;
                  }
               }
            }
            _loc7_ = _loc7_.next;
            _loc8_ = _loc8_.next;
         }
         if(_loc5_ != null)
         {
            _loc6_.next = param4;
            param4 = _loc5_;
         }
         if(param1.negative != null)
         {
            _loc10_ = param2 > 0?int(int(this.cullingInContainer(param2,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ))):int(int(0));
            _loc11_ = param2 > 0?int(int(this.cullingInContainer(param2,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ))):int(int(0));
            if(_loc10_ >= 0)
            {
               param4 = this.collectVGNode(param1.negative,_loc10_,param3,param4);
            }
            if(_loc11_ >= 0)
            {
               param4 = this.collectVGNode(param1.positive,_loc11_,param3,param4);
            }
         }
         return param4;
      }
      
      private function uploadResources(param1:Device) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object3D = null;
         var _loc4_:Mesh = null;
         var _loc5_:BSP = null;
         var _loc7_:TextureMaterial = null;
         if(this.isCreated)
         {
            return;
         }
         this.isCreated = true;
         for(_loc2_ in this.materials)
         {
            _loc7_ = _loc2_ as TextureMaterial;
            if(_loc7_.texture != null)
            {
               param1.uploadResource(_loc7_.textureResource);
            }
            if(_loc7_._textureATF != null)
            {
               param1.uploadResource(_loc7_.textureATFResource);
            }
            if(_loc7_._textureATFAlpha != null)
            {
               param1.uploadResource(_loc7_.textureATFAlphaResource);
            }
         }
         _loc3_ = this.opaqueList;
         while(_loc3_ != null)
         {
            if(_loc3_ is Mesh)
            {
               _loc4_ = _loc3_ as Mesh;
               _loc4_.prepareResources();
               param1.uploadResource(_loc4_.vertexBuffer);
               param1.uploadResource(_loc4_.indexBuffer);
            }
            else if(_loc3_ is BSP)
            {
               _loc5_ = _loc3_ as BSP;
               _loc5_.prepareResources();
               param1.uploadResource(_loc5_.vertexBuffer);
               param1.uploadResource(_loc5_.indexBuffer);
            }
            _loc3_ = _loc3_.next;
         }
         var _loc6_:int = 0;
         while(_loc6_ < this.transparentLength)
         {
            _loc3_ = this.transparent[_loc6_];
            if(_loc3_ is Mesh)
            {
               _loc4_ = _loc3_ as Mesh;
               _loc4_.prepareResources();
               param1.uploadResource(_loc4_.vertexBuffer);
               param1.uploadResource(_loc4_.indexBuffer);
            }
            else if(_loc3_ is BSP)
            {
               _loc5_ = _loc3_ as BSP;
               _loc5_.prepareResources();
               param1.uploadResource(_loc5_.vertexBuffer);
               param1.uploadResource(_loc5_.indexBuffer);
            }
            _loc6_++;
         }
         _loc6_ = 0;
         //while(_loc6_ < this.receiversVertexBuffers.length)
         //{
            //param1.uploadResource(this.receiversVertexBuffers[_loc6_]);
            //param1.uploadResource(this.receiversIndexBuffers[_loc6_]);
            //_loc6_++;
         //}
      }
      
      override alternativa3d function updateBounds(param1:Object3D, param2:Object3D = null) : void
      {
         super.updateBounds(param1,param2);
         if(this.root != null)
         {
            if(param2 != null)
            {
               this.updateBoundsNode(this.root,param1,param2);
            }
            else
            {
               if(this.root.boundMinX < param1.boundMinX)
               {
                  param1.boundMinX = this.root.boundMinX;
               }
               if(this.root.boundMaxX > param1.boundMaxX)
               {
                  param1.boundMaxX = this.root.boundMaxX;
               }
               if(this.root.boundMinY < param1.boundMinY)
               {
                  param1.boundMinY = this.root.boundMinY;
               }
               if(this.root.boundMaxY > param1.boundMaxY)
               {
                  param1.boundMaxY = this.root.boundMaxY;
               }
               if(this.root.boundMinZ < param1.boundMinZ)
               {
                  param1.boundMinZ = this.root.boundMinZ;
               }
               if(this.root.boundMaxZ > param1.boundMaxZ)
               {
                  param1.boundMaxZ = this.root.boundMaxZ;
               }
            }
         }
      }
      
      private function updateBoundsNode(param1:KDNode, param2:Object3D, param3:Object3D) : void
      {
         var _loc4_:Object3D = param1.objectList;
         while(_loc4_ != null)
         {
            if(param3 != null)
            {
               _loc4_.composeAndAppend(param3);
            }
            else
            {
               _loc4_.composeMatrix();
            }
            _loc4_.updateBounds(param2,_loc4_);
            _loc4_ = _loc4_.next;
         }
         if(param1.negative != null)
         {
            this.updateBoundsNode(param1.negative,param2,param3);
            this.updateBoundsNode(param1.positive,param2,param3);
         }
      }
      
      private function debugNode(param1:KDNode, param2:int, param3:Camera3D, param4:Number) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 != null && param1.negative != null)
         {
            _loc5_ = param2 > 0?int(int(this.cullingInContainer(param2,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ))):int(int(0));
            _loc6_ = param2 > 0?int(int(this.cullingInContainer(param2,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ))):int(int(0));
            if(_loc5_ >= 0)
            {
               this.debugNode(param1.negative,_loc5_,param3,param4 * this.debugAlphaFade);
            }
            Debug.drawKDNode(param3,this,param1.axis,param1.coord,param1.boundMinX,param1.boundMinY,param1.boundMinZ,param1.boundMaxX,param1.boundMaxY,param1.boundMaxZ,param4);
            if(_loc6_ >= 0)
            {
               this.debugNode(param1.positive,_loc6_,param3,param4 * this.debugAlphaFade);
            }
         }
      }
      
      private function drawNode(param1:KDNode, param2:int, param3:Camera3D, param4:VG) : void
      {
         var _loc5_:int = 0;
         var _loc6_:VG = null;
         var _loc7_:VG = null;
         var _loc8_:VG = null;
         var _loc9_:VG = null;
         var _loc10_:Object3D = null;
         var _loc11_:Object3D = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         if(param3.occludedAll)
         {
            while(param4 != null)
            {
               _loc6_ = param4.next;
               param4.destroy();
               param4 = _loc6_;
            }
            return;
         }
         if(param1.negative != null)
         {
            _loc12_ = param2 > 0 || this.numOccluders > 0?int(int(this.cullingInContainer(param2,param1.negative.boundMinX,param1.negative.boundMinY,param1.negative.boundMinZ,param1.negative.boundMaxX,param1.negative.boundMaxY,param1.negative.boundMaxZ))):int(int(0));
            _loc13_ = param2 > 0 || this.numOccluders > 0?int(int(this.cullingInContainer(param2,param1.positive.boundMinX,param1.positive.boundMinY,param1.positive.boundMinZ,param1.positive.boundMaxX,param1.positive.boundMaxY,param1.positive.boundMaxZ))):int(int(0));
            _loc14_ = param1.axis == 0;
            _loc15_ = param1.axis == 1;
            if(_loc12_ >= 0 && _loc13_ >= 0)
            {
               while(param4 != null)
               {
                  _loc6_ = param4.next;
                  if(param4.numOccluders < this.numOccluders && this.occludeGeometry(param3,param4))
                  {
                     param4.destroy();
                  }
                  else
                  {
                     _loc16_ = _loc14_?Number(Number(param4.boundMinX)):_loc15_?Number(Number(param4.boundMinY)):Number(Number(param4.boundMinZ));
                     _loc17_ = _loc14_?Number(Number(param4.boundMaxX)):_loc15_?Number(Number(param4.boundMaxY)):Number(Number(param4.boundMaxZ));
                     if(_loc17_ <= param1.maxCoord)
                     {
                        if(_loc16_ < param1.minCoord)
                        {
                           param4.next = _loc7_;
                           _loc7_ = param4;
                        }
                        else
                        {
                           param4.next = _loc8_;
                           _loc8_ = param4;
                        }
                     }
                     else if(_loc16_ >= param1.minCoord)
                     {
                        param4.next = _loc9_;
                        _loc9_ = param4;
                     }
                     else
                     {
                        param4.split(param3,param1.axis == 0?Number(Number(1)):Number(Number(0)),param1.axis == 1?Number(Number(1)):Number(Number(0)),param1.axis == 2?Number(Number(1)):Number(Number(0)),param1.coord,threshold);
                        if(param4.next != null)
                        {
                           param4.next.next = _loc7_;
                           _loc7_ = param4.next;
                        }
                        if(param4.faceStruct != null)
                        {
                           param4.next = _loc9_;
                           _loc9_ = param4;
                        }
                        else
                        {
                           param4.destroy();
                        }
                     }
                  }
                  param4 = _loc6_;
               }
               if(_loc14_ && imd > param1.coord || _loc15_ && imh > param1.coord || !_loc14_ && !_loc15_ && iml > param1.coord)
               {
                  this.drawNode(param1.positive,_loc13_,param3,_loc9_);
                  while(_loc8_ != null)
                  {
                     _loc6_ = _loc8_.next;
                     if(_loc8_.numOccluders >= this.numOccluders || !this.occludeGeometry(param3,_loc8_))
                     {
                        _loc8_.draw(param3,threshold,this);
                     }
                     _loc8_.destroy();
                     _loc8_ = _loc6_;
                  }
                  _loc10_ = param1.objectList;
                  _loc11_ = param1.objectBoundList;
                  while(_loc10_ != null)
                  {
                     if(_loc10_.visible && ((_loc10_.culling = param2) == 0 && this.numOccluders == 0 || (_loc10_.culling = this.cullingInContainer(param2,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ)) >= 0))
                     {
                        _loc10_.copyAndAppend(_loc11_,this);
                        _loc10_.concat(this);
                        _loc10_.draw(param3);
                     }
                     _loc10_ = _loc10_.next;
                     _loc11_ = _loc11_.next;
                  }
                  _loc10_ = param1.occluderList;
                  _loc11_ = param1.occluderBoundList;
                  while(_loc10_ != null)
                  {
                     if(_loc10_.visible && ((_loc10_.culling = param2) == 0 && this.numOccluders == 0 || (_loc10_.culling = this.cullingInContainer(param2,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ)) >= 0))
                     {
                        _loc10_.copyAndAppend(_loc11_,this);
                        _loc10_.concat(this);
                        _loc10_.draw(param3);
                     }
                     _loc10_ = _loc10_.next;
                     _loc11_ = _loc11_.next;
                  }
                  if(param1.occluderList != null)
                  {
                     this.updateOccluders(param3);
                  }
                  this.drawNode(param1.negative,_loc12_,param3,_loc7_);
               }
               else
               {
                  this.drawNode(param1.negative,_loc12_,param3,_loc7_);
                  while(_loc8_ != null)
                  {
                     _loc6_ = _loc8_.next;
                     if(_loc8_.numOccluders >= this.numOccluders || !this.occludeGeometry(param3,_loc8_))
                     {
                        _loc8_.draw(param3,threshold,this);
                     }
                     _loc8_.destroy();
                     _loc8_ = _loc6_;
                  }
                  _loc10_ = param1.objectList;
                  _loc11_ = param1.objectBoundList;
                  while(_loc10_ != null)
                  {
                     if(_loc10_.visible && ((_loc10_.culling = param2) == 0 && this.numOccluders == 0 || (_loc10_.culling = this.cullingInContainer(param2,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ)) >= 0))
                     {
                        _loc10_.copyAndAppend(_loc11_,this);
                        _loc10_.concat(this);
                        _loc10_.draw(param3);
                     }
                     _loc10_ = _loc10_.next;
                     _loc11_ = _loc11_.next;
                  }
                  _loc10_ = param1.occluderList;
                  _loc11_ = param1.occluderBoundList;
                  while(_loc10_ != null)
                  {
                     if(_loc10_.visible && ((_loc10_.culling = param2) == 0 && this.numOccluders == 0 || (_loc10_.culling = this.cullingInContainer(param2,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ)) >= 0))
                     {
                        _loc10_.copyAndAppend(_loc11_,this);
                        _loc10_.concat(this);
                        _loc10_.draw(param3);
                     }
                     _loc10_ = _loc10_.next;
                     _loc11_ = _loc11_.next;
                  }
                  if(param1.occluderList != null)
                  {
                     this.updateOccluders(param3);
                  }
                  this.drawNode(param1.positive,_loc13_,param3,_loc9_);
               }
            }
            else if(_loc12_ >= 0)
            {
               while(param4 != null)
               {
                  _loc6_ = param4.next;
                  if(param4.numOccluders < this.numOccluders && this.occludeGeometry(param3,param4))
                  {
                     param4.destroy();
                  }
                  else
                  {
                     _loc16_ = _loc14_?Number(Number(param4.boundMinX)):_loc15_?Number(Number(param4.boundMinY)):Number(Number(param4.boundMinZ));
                     _loc17_ = _loc14_?Number(Number(param4.boundMaxX)):_loc15_?Number(Number(param4.boundMaxY)):Number(Number(param4.boundMaxZ));
                     if(_loc17_ <= param1.maxCoord)
                     {
                        param4.next = _loc7_;
                        _loc7_ = param4;
                     }
                     else if(_loc16_ >= param1.minCoord)
                     {
                        param4.destroy();
                     }
                     else
                     {
                        param4.crop(param3,param1.axis == 0?Number(Number(-1)):Number(Number(0)),param1.axis == 1?Number(Number(-1)):Number(Number(0)),param1.axis == 2?Number(Number(-1)):Number(Number(0)),-param1.coord,threshold);
                        if(param4.faceStruct != null)
                        {
                           param4.next = _loc7_;
                           _loc7_ = param4;
                        }
                        else
                        {
                           param4.destroy();
                        }
                     }
                  }
                  param4 = _loc6_;
               }
               this.drawNode(param1.negative,_loc12_,param3,_loc7_);
            }
            else if(_loc13_ >= 0)
            {
               while(param4 != null)
               {
                  _loc6_ = param4.next;
                  if(param4.numOccluders < this.numOccluders && this.occludeGeometry(param3,param4))
                  {
                     param4.destroy();
                  }
                  else
                  {
                     _loc16_ = _loc14_?Number(Number(param4.boundMinX)):_loc15_?Number(Number(param4.boundMinY)):Number(Number(param4.boundMinZ));
                     _loc17_ = _loc14_?Number(Number(param4.boundMaxX)):_loc15_?Number(Number(param4.boundMaxY)):Number(Number(param4.boundMaxZ));
                     if(_loc17_ <= param1.maxCoord)
                     {
                        param4.destroy();
                     }
                     else if(_loc16_ >= param1.minCoord)
                     {
                        param4.next = _loc9_;
                        _loc9_ = param4;
                     }
                     else
                     {
                        param4.crop(param3,param1.axis == 0?Number(Number(1)):Number(Number(0)),param1.axis == 1?Number(Number(1)):Number(Number(0)),param1.axis == 2?Number(Number(1)):Number(Number(0)),param1.coord,threshold);
                        if(param4.faceStruct != null)
                        {
                           param4.next = _loc9_;
                           _loc9_ = param4;
                        }
                        else
                        {
                           param4.destroy();
                        }
                     }
                  }
                  param4 = _loc6_;
               }
               this.drawNode(param1.positive,_loc13_,param3,_loc9_);
            }
            else
            {
               while(param4 != null)
               {
                  _loc6_ = param4.next;
                  param4.destroy();
                  param4 = _loc6_;
               }
            }
         }
         else
         {
            if(param1.objectList != null)
            {
               if(param1.objectList.next != null || param4 != null)
               {
                  while(param4 != null)
                  {
                     _loc6_ = param4.next;
                     if(param4.numOccluders < this.numOccluders && this.occludeGeometry(param3,param4))
                     {
                        param4.destroy();
                     }
                     else
                     {
                        param4.next = _loc8_;
                        _loc8_ = param4;
                     }
                     param4 = _loc6_;
                  }
                  _loc10_ = param1.objectList;
                  _loc11_ = param1.objectBoundList;
                  while(_loc10_ != null)
                  {
                     if(_loc10_.visible && ((_loc10_.culling = param2) == 0 && this.numOccluders == 0 || (_loc10_.culling = this.cullingInContainer(param2,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ)) >= 0))
                     {
                        _loc10_.copyAndAppend(_loc11_,this);
                        _loc10_.concat(this);
                        param4 = _loc10_.getVG(param3);
                        while(param4 != null)
                        {
                           _loc6_ = param4.next;
                           param4.next = _loc8_;
                           _loc8_ = param4;
                           param4 = _loc6_;
                        }
                     }
                     _loc10_ = _loc10_.next;
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc8_ != null)
                  {
                     if(_loc8_.next != null)
                     {
                        drawConflictGeometry(param3,_loc8_);
                     }
                     else
                     {
                        _loc8_.draw(param3,threshold,this);
                        _loc8_.destroy();
                     }
                  }
               }
               else
               {
                  _loc10_ = param1.objectList;
                  if(_loc10_.visible)
                  {
                     _loc10_.copyAndAppend(param1.objectBoundList,this);
                     _loc10_.culling = param2;
                     _loc10_.concat(this);
                     _loc10_.draw(param3);
                  }
               }
            }
            else if(param4 != null)
            {
               if(param4.next != null)
               {
                  if(this.numOccluders > 0)
                  {
                     while(param4 != null)
                     {
                        _loc6_ = param4.next;
                        if(param4.numOccluders < this.numOccluders && this.occludeGeometry(param3,param4))
                        {
                           param4.destroy();
                        }
                        else
                        {
                           param4.next = _loc8_;
                           _loc8_ = param4;
                        }
                        param4 = _loc6_;
                     }
                     if(_loc8_ != null)
                     {
                        if(_loc8_.next != null)
                        {
                           if(resolveByAABB)
                           {
                              drawAABBGeometry(param3,_loc8_);
                           }
                           else if(resolveByOOBB)
                           {
                              param4 = _loc8_;
                              while(param4 != null)
                              {
                                 param4.calculateOOBB(this);
                                 param4 = param4.next;
                              }
                              drawOOBBGeometry(param3,_loc8_);
                           }
                           else
                           {
                              drawConflictGeometry(param3,_loc8_);
                           }
                        }
                        else
                        {
                           _loc8_.draw(param3,threshold,this);
                           _loc8_.destroy();
                        }
                     }
                  }
                  else
                  {
                     _loc8_ = param4;
                     if(resolveByAABB)
                     {
                        drawAABBGeometry(param3,_loc8_);
                     }
                     else if(resolveByOOBB)
                     {
                        param4 = _loc8_;
                        while(param4 != null)
                        {
                           param4.calculateOOBB(this);
                           param4 = param4.next;
                        }
                        drawOOBBGeometry(param3,_loc8_);
                     }
                     else
                     {
                        drawConflictGeometry(param3,_loc8_);
                     }
                  }
               }
               else
               {
                  if(param4.numOccluders >= this.numOccluders || !this.occludeGeometry(param3,param4))
                  {
                     param4.draw(param3,threshold,this);
                  }
                  param4.destroy();
               }
            }
            _loc10_ = param1.occluderList;
            _loc11_ = param1.occluderBoundList;
            while(_loc10_ != null)
            {
               if(_loc10_.visible && ((_loc10_.culling = param2) == 0 && this.numOccluders == 0 || (_loc10_.culling = this.cullingInContainer(param2,_loc11_.boundMinX,_loc11_.boundMinY,_loc11_.boundMinZ,_loc11_.boundMaxX,_loc11_.boundMaxY,_loc11_.boundMaxZ)) >= 0))
               {
                  _loc10_.copyAndAppend(_loc11_,this);
                  _loc10_.concat(this);
                  _loc10_.draw(param3);
               }
               _loc10_ = _loc10_.next;
               _loc11_ = _loc11_.next;
            }
            if(param1.occluderList != null)
            {
               this.updateOccluders(param3);
            }
         }
      }
      
      private function createObjectBounds(param1:Object3D) : Object3D
      {
         var _loc2_:Object3D = new Object3D();
         _loc2_.boundMinX = 1.0e22;
         _loc2_.boundMinY = 1.0e22;
         _loc2_.boundMinZ = 1.0e22;
         _loc2_.boundMaxX = -1.0e22;
         _loc2_.boundMaxY = -1.0e22;
         _loc2_.boundMaxZ = -1.0e22;
         param1.composeMatrix();
         param1.updateBounds(_loc2_,param1);
         _loc2_.ma = param1.ma;
         _loc2_.mb = param1.mb;
         _loc2_.mc = param1.mc;
         _loc2_.md = param1.md;
         _loc2_.me = param1.me;
         _loc2_.mf = param1.mf;
         _loc2_.mg = param1.mg;
         _loc2_.mh = param1.mh;
         _loc2_.mi = param1.mi;
         _loc2_.mj = param1.mj;
         _loc2_.mk = param1.mk;
         _loc2_.ml = param1.ml;
         return _loc2_;
      }
      
      private function createNode(param1:Object3D, param2:Object3D, param3:Object3D, param4:Object3D, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number) : KDNode
      {
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Object3D = null;
         var _loc15_:Object3D = null;
         var _loc16_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Object3D = null;
         var _loc30_:Object3D = null;
         var _loc31_:Object3D = null;
         var _loc32_:Object3D = null;
         var _loc33_:Object3D = null;
         var _loc34_:Object3D = null;
         var _loc35_:Object3D = null;
         var _loc36_:Object3D = null;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Object3D = null;
         var _loc40_:Object3D = null;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc47_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc50_:Number = NaN;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc11_:KDNode = new KDNode();
         _loc11_.boundMinX = param5;
         _loc11_.boundMinY = param6;
         _loc11_.boundMinZ = param7;
         _loc11_.boundMaxX = param8;
         _loc11_.boundMaxY = param9;
         _loc11_.boundMaxZ = param10;
         if(param1 == null)
         {
            if(param3 != null)
            {
            }
            return _loc11_;
         }
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         _loc15_ = param2;
         while(_loc15_ != null)
         {
            if(_loc15_.boundMinX > param5 + threshold)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc17_)
               {
                  if(_loc15_.boundMinX >= splitCoordsX[_loc13_] - threshold && _loc15_.boundMinX <= splitCoordsX[_loc13_] + threshold)
                  {
                     break;
                  }
                  _loc13_++;
               }
               if(_loc13_ == _loc17_)
               {
                  splitCoordsX[_loc17_++] = _loc15_.boundMinX;
               }
            }
            if(_loc15_.boundMaxX < param8 - threshold)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc17_)
               {
                  if(_loc15_.boundMaxX >= splitCoordsX[_loc13_] - threshold && _loc15_.boundMaxX <= splitCoordsX[_loc13_] + threshold)
                  {
                     break;
                  }
                  _loc13_++;
               }
               if(_loc13_ == _loc17_)
               {
                  splitCoordsX[_loc17_++] = _loc15_.boundMaxX;
               }
            }
            if(_loc15_.boundMinY > param6 + threshold)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc18_)
               {
                  if(_loc15_.boundMinY >= splitCoordsY[_loc13_] - threshold && _loc15_.boundMinY <= splitCoordsY[_loc13_] + threshold)
                  {
                     break;
                  }
                  _loc13_++;
               }
               if(_loc13_ == _loc18_)
               {
                  splitCoordsY[_loc18_++] = _loc15_.boundMinY;
               }
            }
            if(_loc15_.boundMaxY < param9 - threshold)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc18_)
               {
                  if(_loc15_.boundMaxY >= splitCoordsY[_loc13_] - threshold && _loc15_.boundMaxY <= splitCoordsY[_loc13_] + threshold)
                  {
                     break;
                  }
                  _loc13_++;
               }
               if(_loc13_ == _loc18_)
               {
                  splitCoordsY[_loc18_++] = _loc15_.boundMaxY;
               }
            }
            if(_loc15_.boundMinZ > param7 + threshold)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc19_)
               {
                  if(_loc15_.boundMinZ >= splitCoordsZ[_loc13_] - threshold && _loc15_.boundMinZ <= splitCoordsZ[_loc13_] + threshold)
                  {
                     break;
                  }
                  _loc13_++;
               }
               if(_loc13_ == _loc19_)
               {
                  splitCoordsZ[_loc19_++] = _loc15_.boundMinZ;
               }
            }
            if(_loc15_.boundMaxZ < param10 - threshold)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc19_)
               {
                  if(_loc15_.boundMaxZ >= splitCoordsZ[_loc13_] - threshold && _loc15_.boundMaxZ <= splitCoordsZ[_loc13_] + threshold)
                  {
                     break;
                  }
                  _loc13_++;
               }
               if(_loc13_ == _loc19_)
               {
                  splitCoordsZ[_loc19_++] = _loc15_.boundMaxZ;
               }
            }
            _loc15_ = _loc15_.next;
         }
         var _loc20_:int = -1;
         var _loc22_:Number = 1.0e22;
         _loc25_ = (param9 - param6) * (param10 - param7);
         _loc12_ = 0;
         while(_loc12_ < _loc17_)
         {
            _loc16_ = splitCoordsX[_loc12_];
            _loc26_ = _loc25_ * (_loc16_ - param5);
            _loc27_ = _loc25_ * (param8 - _loc16_);
            _loc23_ = 0;
            _loc24_ = 0;
            _loc15_ = param2;
            while(_loc15_ != null)
            {
               if(_loc15_.boundMaxX <= _loc16_ + threshold)
               {
                  if(_loc15_.boundMinX < _loc16_ - threshold)
                  {
                     _loc23_++;
                  }
               }
               else if(_loc15_.boundMinX >= _loc16_ - threshold)
               {
                  _loc24_++;
               }
               else
               {
                  break;
               }
               _loc15_ = _loc15_.next;
            }
            if(_loc15_ == null)
            {
               _loc28_ = _loc26_ * _loc23_ + _loc27_ * _loc24_;
               if(_loc28_ < _loc22_)
               {
                  _loc22_ = _loc28_;
                  _loc20_ = 0;
                  _loc21_ = _loc16_;
               }
            }
            _loc12_++;
         }
         _loc25_ = (param8 - param5) * (param10 - param7);
         _loc12_ = 0;
         while(_loc12_ < _loc18_)
         {
            _loc16_ = splitCoordsY[_loc12_];
            _loc26_ = _loc25_ * (_loc16_ - param6);
            _loc27_ = _loc25_ * (param9 - _loc16_);
            _loc23_ = 0;
            _loc24_ = 0;
            _loc15_ = param2;
            while(_loc15_ != null)
            {
               if(_loc15_.boundMaxY <= _loc16_ + threshold)
               {
                  if(_loc15_.boundMinY < _loc16_ - threshold)
                  {
                     _loc23_++;
                  }
               }
               else if(_loc15_.boundMinY >= _loc16_ - threshold)
               {
                  _loc24_++;
               }
               else
               {
                  break;
               }
               _loc15_ = _loc15_.next;
            }
            if(_loc15_ == null)
            {
               _loc28_ = _loc26_ * _loc23_ + _loc27_ * _loc24_;
               if(_loc28_ < _loc22_)
               {
                  _loc22_ = _loc28_;
                  _loc20_ = 1;
                  _loc21_ = _loc16_;
               }
            }
            _loc12_++;
         }
         _loc25_ = (param8 - param5) * (param9 - param6);
         _loc12_ = 0;
         while(_loc12_ < _loc19_)
         {
            _loc16_ = splitCoordsZ[_loc12_];
            _loc26_ = _loc25_ * (_loc16_ - param7);
            _loc27_ = _loc25_ * (param10 - _loc16_);
            _loc23_ = 0;
            _loc24_ = 0;
            _loc15_ = param2;
            while(_loc15_ != null)
            {
               if(_loc15_.boundMaxZ <= _loc16_ + threshold)
               {
                  if(_loc15_.boundMinZ < _loc16_ - threshold)
                  {
                     _loc23_++;
                  }
               }
               else if(_loc15_.boundMinZ >= _loc16_ - threshold)
               {
                  _loc24_++;
               }
               else
               {
                  break;
               }
               _loc15_ = _loc15_.next;
            }
            if(_loc15_ == null)
            {
               _loc28_ = _loc26_ * _loc23_ + _loc27_ * _loc24_;
               if(_loc28_ < _loc22_)
               {
                  _loc22_ = _loc28_;
                  _loc20_ = 2;
                  _loc21_ = _loc16_;
               }
            }
            _loc12_++;
         }
         if(_loc20_ < 0)
         {
            _loc11_.objectList = param1;
            _loc11_.objectBoundList = param2;
            _loc11_.occluderList = param3;
            _loc11_.occluderBoundList = param4;
         }
         else
         {
            _loc11_.axis = _loc20_;
            _loc11_.coord = _loc21_;
            _loc11_.minCoord = _loc21_ - threshold;
            _loc11_.maxCoord = _loc21_ + threshold;
            _loc14_ = param1;
            _loc15_ = param2;
            while(_loc14_ != null)
            {
               _loc39_ = _loc14_.next;
               _loc40_ = _loc15_.next;
               _loc14_.next = null;
               _loc15_.next = null;
               _loc37_ = _loc20_ == 0?Number(Number(_loc15_.boundMinX)):_loc20_ == 1?Number(Number(_loc15_.boundMinY)):Number(Number(_loc15_.boundMinZ));
               _loc38_ = _loc20_ == 0?Number(Number(_loc15_.boundMaxX)):_loc20_ == 1?Number(Number(_loc15_.boundMaxY)):Number(Number(_loc15_.boundMaxZ));
               if(_loc38_ <= _loc21_ + threshold)
               {
                  if(_loc37_ < _loc21_ - threshold)
                  {
                     _loc14_.next = _loc29_;
                     _loc29_ = _loc14_;
                     _loc15_.next = _loc30_;
                     _loc30_ = _loc15_;
                  }
                  else
                  {
                     _loc14_.next = _loc11_.objectList;
                     _loc11_.objectList = _loc14_;
                     _loc15_.next = _loc11_.objectBoundList;
                     _loc11_.objectBoundList = _loc15_;
                  }
               }
               else if(_loc37_ >= _loc21_ - threshold)
               {
                  _loc14_.next = _loc33_;
                  _loc33_ = _loc14_;
                  _loc15_.next = _loc34_;
                  _loc34_ = _loc15_;
               }
               _loc14_ = _loc39_;
               _loc15_ = _loc40_;
            }
            _loc14_ = param3;
            _loc15_ = param4;
            while(_loc14_ != null)
            {
               _loc39_ = _loc14_.next;
               _loc40_ = _loc15_.next;
               _loc14_.next = null;
               _loc15_.next = null;
               _loc37_ = _loc20_ == 0?Number(Number(_loc15_.boundMinX)):_loc20_ == 1?Number(Number(_loc15_.boundMinY)):Number(Number(_loc15_.boundMinZ));
               _loc38_ = _loc20_ == 0?Number(Number(_loc15_.boundMaxX)):_loc20_ == 1?Number(Number(_loc15_.boundMaxY)):Number(Number(_loc15_.boundMaxZ));
               if(_loc38_ <= _loc21_ + threshold)
               {
                  if(_loc37_ < _loc21_ - threshold)
                  {
                     _loc14_.next = _loc31_;
                     _loc31_ = _loc14_;
                     _loc15_.next = _loc32_;
                     _loc32_ = _loc15_;
                  }
                  else
                  {
                     _loc14_.next = _loc11_.occluderList;
                     _loc11_.occluderList = _loc14_;
                     _loc15_.next = _loc11_.occluderBoundList;
                     _loc11_.occluderBoundList = _loc15_;
                  }
               }
               else if(_loc37_ >= _loc21_ - threshold)
               {
                  _loc14_.next = _loc35_;
                  _loc35_ = _loc14_;
                  _loc15_.next = _loc36_;
                  _loc36_ = _loc15_;
               }
               _loc14_ = _loc39_;
               _loc15_ = _loc40_;
            }
            _loc41_ = _loc11_.boundMinX;
            _loc42_ = _loc11_.boundMinY;
            _loc43_ = _loc11_.boundMinZ;
            _loc44_ = _loc11_.boundMaxX;
            _loc45_ = _loc11_.boundMaxY;
            _loc46_ = _loc11_.boundMaxZ;
            _loc47_ = _loc11_.boundMinX;
            _loc48_ = _loc11_.boundMinY;
            _loc49_ = _loc11_.boundMinZ;
            _loc50_ = _loc11_.boundMaxX;
            _loc51_ = _loc11_.boundMaxY;
            _loc52_ = _loc11_.boundMaxZ;
            if(_loc20_ == 0)
            {
               _loc44_ = _loc21_;
               _loc47_ = _loc21_;
            }
            else if(_loc20_ == 1)
            {
               _loc45_ = _loc21_;
               _loc48_ = _loc21_;
            }
            else
            {
               _loc46_ = _loc21_;
               _loc49_ = _loc21_;
            }
            _loc11_.negative = this.createNode(_loc29_,_loc30_,_loc31_,_loc32_,_loc41_,_loc42_,_loc43_,_loc44_,_loc45_,_loc46_);
            _loc11_.positive = this.createNode(_loc33_,_loc34_,_loc35_,_loc36_,_loc47_,_loc48_,_loc49_,_loc50_,_loc51_,_loc52_);
         }
         return _loc11_;
      }
      
      private function destroyNode(param1:KDNode) : void
      {
         var _loc2_:Object3D = null;
         var _loc3_:Object3D = null;
         var _loc5_:Receiver = null;
         if(param1.negative != null)
         {
            this.destroyNode(param1.negative);
            param1.negative = null;
         }
         if(param1.positive != null)
         {
            this.destroyNode(param1.positive);
            param1.positive = null;
         }
         _loc2_ = param1.objectList;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.setParent(null);
            _loc2_.next = null;
            _loc2_ = _loc3_;
         }
         _loc2_ = param1.objectBoundList;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.next = null;
            _loc2_ = _loc3_;
         }
         _loc2_ = param1.occluderList;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.setParent(null);
            _loc2_.next = null;
            _loc2_ = _loc3_;
         }
         _loc2_ = param1.occluderBoundList;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.next = null;
            _loc2_ = _loc3_;
         }
         var _loc4_:Receiver = param1.receiverList;
         while(_loc4_ != null)
         {
            _loc5_ = _loc4_.next;
            _loc4_.next = null;
            _loc4_ = _loc5_;
         }
         param1.objectList = null;
         param1.objectBoundList = null;
         param1.occluderList = null;
         param1.occluderBoundList = null;
         param1.receiverList = null;
      }
      
      private function calculateCameraPlanes(param1:Number, param2:Number) : void
      {
         this.nearPlaneX = imc;
         this.nearPlaneY = img;
         this.nearPlaneZ = imk;
         this.nearPlaneOffset = (imc * param1 + imd) * this.nearPlaneX + (img * param1 + imh) * this.nearPlaneY + (imk * param1 + iml) * this.nearPlaneZ;
         this.farPlaneX = -imc;
         this.farPlaneY = -img;
         this.farPlaneZ = -imk;
         this.farPlaneOffset = (imc * param2 + imd) * this.farPlaneX + (img * param2 + imh) * this.farPlaneY + (imk * param2 + iml) * this.farPlaneZ;
         var _loc3_:Number = -ima - imb + imc;
         var _loc4_:Number = -ime - imf + img;
         var _loc5_:Number = -imi - imj + imk;
         var _loc6_:Number = ima - imb + imc;
         var _loc7_:Number = ime - imf + img;
         var _loc8_:Number = imi - imj + imk;
         this.topPlaneX = _loc8_ * _loc4_ - _loc7_ * _loc5_;
         this.topPlaneY = _loc6_ * _loc5_ - _loc8_ * _loc3_;
         this.topPlaneZ = _loc7_ * _loc3_ - _loc6_ * _loc4_;
         this.topPlaneOffset = imd * this.topPlaneX + imh * this.topPlaneY + iml * this.topPlaneZ;
         _loc3_ = _loc6_;
         _loc4_ = _loc7_;
         _loc5_ = _loc8_;
         _loc6_ = ima + imb + imc;
         _loc7_ = ime + imf + img;
         _loc8_ = imi + imj + imk;
         this.rightPlaneX = _loc8_ * _loc4_ - _loc7_ * _loc5_;
         this.rightPlaneY = _loc6_ * _loc5_ - _loc8_ * _loc3_;
         this.rightPlaneZ = _loc7_ * _loc3_ - _loc6_ * _loc4_;
         this.rightPlaneOffset = imd * this.rightPlaneX + imh * this.rightPlaneY + iml * this.rightPlaneZ;
         _loc3_ = _loc6_;
         _loc4_ = _loc7_;
         _loc5_ = _loc8_;
         _loc6_ = -ima + imb + imc;
         _loc7_ = -ime + imf + img;
         _loc8_ = -imi + imj + imk;
         this.bottomPlaneX = _loc8_ * _loc4_ - _loc7_ * _loc5_;
         this.bottomPlaneY = _loc6_ * _loc5_ - _loc8_ * _loc3_;
         this.bottomPlaneZ = _loc7_ * _loc3_ - _loc6_ * _loc4_;
         this.bottomPlaneOffset = imd * this.bottomPlaneX + imh * this.bottomPlaneY + iml * this.bottomPlaneZ;
         _loc3_ = _loc6_;
         _loc4_ = _loc7_;
         _loc5_ = _loc8_;
         _loc6_ = -ima - imb + imc;
         _loc7_ = -ime - imf + img;
         _loc8_ = -imi - imj + imk;
         this.leftPlaneX = _loc8_ * _loc4_ - _loc7_ * _loc5_;
         this.leftPlaneY = _loc6_ * _loc5_ - _loc8_ * _loc3_;
         this.leftPlaneZ = _loc7_ * _loc3_ - _loc6_ * _loc4_;
         this.leftPlaneOffset = imd * this.leftPlaneX + imh * this.leftPlaneY + iml * this.leftPlaneZ;
      }
      
      private function updateOccluders(param1:Camera3D) : void
      {
         var _loc3_:Vertex = null;
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc2_:int = this.numOccluders;
         while(_loc2_ < param1.numOccluders)
         {
            _loc3_ = null;
            _loc4_ = param1.occluders[_loc2_];
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_.create();
               _loc5_.next = _loc3_;
               _loc3_ = _loc5_;
               _loc6_ = ima * _loc4_.x + imb * _loc4_.y + imc * _loc4_.z;
               _loc7_ = ime * _loc4_.x + imf * _loc4_.y + img * _loc4_.z;
               _loc8_ = imi * _loc4_.x + imj * _loc4_.y + imk * _loc4_.z;
               _loc9_ = ima * _loc4_.u + imb * _loc4_.v + imc * _loc4_.offset;
               _loc10_ = ime * _loc4_.u + imf * _loc4_.v + img * _loc4_.offset;
               _loc11_ = imi * _loc4_.u + imj * _loc4_.v + imk * _loc4_.offset;
               _loc3_.x = _loc11_ * _loc7_ - _loc10_ * _loc8_;
               _loc3_.y = _loc9_ * _loc8_ - _loc11_ * _loc6_;
               _loc3_.z = _loc10_ * _loc6_ - _loc9_ * _loc7_;
               _loc3_.offset = imd * _loc3_.x + imh * _loc3_.y + iml * _loc3_.z;
               _loc4_ = _loc4_.next;
            }
            this.occluders[this.numOccluders] = _loc3_;
            this.numOccluders++;
            _loc2_++;
         }
      }
      
      private function cullingInContainer(param1:int, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : int
      {
         var _loc9_:Vertex = null;
         if(param1 > 0)
         {
            if(param1 & 1)
            {
               if(this.nearPlaneX >= 0)
               {
                  if(this.nearPlaneY >= 0)
                  {
                     if(this.nearPlaneZ >= 0)
                     {
                        if(param5 * this.nearPlaneX + param6 * this.nearPlaneY + param7 * this.nearPlaneZ <= this.nearPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.nearPlaneX + param3 * this.nearPlaneY + param4 * this.nearPlaneZ > this.nearPlaneOffset)
                        {
                           param1 = param1 & 62;
                        }
                     }
                     else
                     {
                        if(param5 * this.nearPlaneX + param6 * this.nearPlaneY + param4 * this.nearPlaneZ <= this.nearPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.nearPlaneX + param3 * this.nearPlaneY + param7 * this.nearPlaneZ > this.nearPlaneOffset)
                        {
                           param1 = param1 & 62;
                        }
                     }
                  }
                  else if(this.nearPlaneZ >= 0)
                  {
                     if(param5 * this.nearPlaneX + param3 * this.nearPlaneY + param7 * this.nearPlaneZ <= this.nearPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.nearPlaneX + param6 * this.nearPlaneY + param4 * this.nearPlaneZ > this.nearPlaneOffset)
                     {
                        param1 = param1 & 62;
                     }
                  }
                  else
                  {
                     if(param5 * this.nearPlaneX + param3 * this.nearPlaneY + param4 * this.nearPlaneZ <= this.nearPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.nearPlaneX + param6 * this.nearPlaneY + param7 * this.nearPlaneZ > this.nearPlaneOffset)
                     {
                        param1 = param1 & 62;
                     }
                  }
               }
               else if(this.nearPlaneY >= 0)
               {
                  if(this.nearPlaneZ >= 0)
                  {
                     if(param2 * this.nearPlaneX + param6 * this.nearPlaneY + param7 * this.nearPlaneZ <= this.nearPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.nearPlaneX + param3 * this.nearPlaneY + param4 * this.nearPlaneZ > this.nearPlaneOffset)
                     {
                        param1 = param1 & 62;
                     }
                  }
                  else
                  {
                     if(param2 * this.nearPlaneX + param6 * this.nearPlaneY + param4 * this.nearPlaneZ <= this.nearPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.nearPlaneX + param3 * this.nearPlaneY + param7 * this.nearPlaneZ > this.nearPlaneOffset)
                     {
                        param1 = param1 & 62;
                     }
                  }
               }
               else if(this.nearPlaneZ >= 0)
               {
                  if(param2 * this.nearPlaneX + param3 * this.nearPlaneY + param7 * this.nearPlaneZ <= this.nearPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.nearPlaneX + param6 * this.nearPlaneY + param4 * this.nearPlaneZ > this.nearPlaneOffset)
                  {
                     param1 = param1 & 62;
                  }
               }
               else
               {
                  if(param2 * this.nearPlaneX + param3 * this.nearPlaneY + param4 * this.nearPlaneZ <= this.nearPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.nearPlaneX + param6 * this.nearPlaneY + param7 * this.nearPlaneZ > this.nearPlaneOffset)
                  {
                     param1 = param1 & 62;
                  }
               }
            }
            if(param1 & 2)
            {
               if(this.farPlaneX >= 0)
               {
                  if(this.farPlaneY >= 0)
                  {
                     if(this.farPlaneZ >= 0)
                     {
                        if(param5 * this.farPlaneX + param6 * this.farPlaneY + param7 * this.farPlaneZ <= this.farPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.farPlaneX + param3 * this.farPlaneY + param4 * this.farPlaneZ > this.farPlaneOffset)
                        {
                           param1 = param1 & 61;
                        }
                     }
                     else
                     {
                        if(param5 * this.farPlaneX + param6 * this.farPlaneY + param4 * this.farPlaneZ <= this.farPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.farPlaneX + param3 * this.farPlaneY + param7 * this.farPlaneZ > this.farPlaneOffset)
                        {
                           param1 = param1 & 61;
                        }
                     }
                  }
                  else if(this.farPlaneZ >= 0)
                  {
                     if(param5 * this.farPlaneX + param3 * this.farPlaneY + param7 * this.farPlaneZ <= this.farPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.farPlaneX + param6 * this.farPlaneY + param4 * this.farPlaneZ > this.farPlaneOffset)
                     {
                        param1 = param1 & 61;
                     }
                  }
                  else
                  {
                     if(param5 * this.farPlaneX + param3 * this.farPlaneY + param4 * this.farPlaneZ <= this.farPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.farPlaneX + param6 * this.farPlaneY + param7 * this.farPlaneZ > this.farPlaneOffset)
                     {
                        param1 = param1 & 61;
                     }
                  }
               }
               else if(this.farPlaneY >= 0)
               {
                  if(this.farPlaneZ >= 0)
                  {
                     if(param2 * this.farPlaneX + param6 * this.farPlaneY + param7 * this.farPlaneZ <= this.farPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.farPlaneX + param3 * this.farPlaneY + param4 * this.farPlaneZ > this.farPlaneOffset)
                     {
                        param1 = param1 & 61;
                     }
                  }
                  else
                  {
                     if(param2 * this.farPlaneX + param6 * this.farPlaneY + param4 * this.farPlaneZ <= this.farPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.farPlaneX + param3 * this.farPlaneY + param7 * this.farPlaneZ > this.farPlaneOffset)
                     {
                        param1 = param1 & 61;
                     }
                  }
               }
               else if(this.farPlaneZ >= 0)
               {
                  if(param2 * this.farPlaneX + param3 * this.farPlaneY + param7 * this.farPlaneZ <= this.farPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.farPlaneX + param6 * this.farPlaneY + param4 * this.farPlaneZ > this.farPlaneOffset)
                  {
                     param1 = param1 & 61;
                  }
               }
               else
               {
                  if(param2 * this.farPlaneX + param3 * this.farPlaneY + param4 * this.farPlaneZ <= this.farPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.farPlaneX + param6 * this.farPlaneY + param7 * this.farPlaneZ > this.farPlaneOffset)
                  {
                     param1 = param1 & 61;
                  }
               }
            }
            if(param1 & 4)
            {
               if(this.leftPlaneX >= 0)
               {
                  if(this.leftPlaneY >= 0)
                  {
                     if(this.leftPlaneZ >= 0)
                     {
                        if(param5 * this.leftPlaneX + param6 * this.leftPlaneY + param7 * this.leftPlaneZ <= this.leftPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.leftPlaneX + param3 * this.leftPlaneY + param4 * this.leftPlaneZ > this.leftPlaneOffset)
                        {
                           param1 = param1 & 59;
                        }
                     }
                     else
                     {
                        if(param5 * this.leftPlaneX + param6 * this.leftPlaneY + param4 * this.leftPlaneZ <= this.leftPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.leftPlaneX + param3 * this.leftPlaneY + param7 * this.leftPlaneZ > this.leftPlaneOffset)
                        {
                           param1 = param1 & 59;
                        }
                     }
                  }
                  else if(this.leftPlaneZ >= 0)
                  {
                     if(param5 * this.leftPlaneX + param3 * this.leftPlaneY + param7 * this.leftPlaneZ <= this.leftPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.leftPlaneX + param6 * this.leftPlaneY + param4 * this.leftPlaneZ > this.leftPlaneOffset)
                     {
                        param1 = param1 & 59;
                     }
                  }
                  else
                  {
                     if(param5 * this.leftPlaneX + param3 * this.leftPlaneY + param4 * this.leftPlaneZ <= this.leftPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.leftPlaneX + param6 * this.leftPlaneY + param7 * this.leftPlaneZ > this.leftPlaneOffset)
                     {
                        param1 = param1 & 59;
                     }
                  }
               }
               else if(this.leftPlaneY >= 0)
               {
                  if(this.leftPlaneZ >= 0)
                  {
                     if(param2 * this.leftPlaneX + param6 * this.leftPlaneY + param7 * this.leftPlaneZ <= this.leftPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.leftPlaneX + param3 * this.leftPlaneY + param4 * this.leftPlaneZ > this.leftPlaneOffset)
                     {
                        param1 = param1 & 59;
                     }
                  }
                  else
                  {
                     if(param2 * this.leftPlaneX + param6 * this.leftPlaneY + param4 * this.leftPlaneZ <= this.leftPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.leftPlaneX + param3 * this.leftPlaneY + param7 * this.leftPlaneZ > this.leftPlaneOffset)
                     {
                        param1 = param1 & 59;
                     }
                  }
               }
               else if(this.leftPlaneZ >= 0)
               {
                  if(param2 * this.leftPlaneX + param3 * this.leftPlaneY + param7 * this.leftPlaneZ <= this.leftPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.leftPlaneX + param6 * this.leftPlaneY + param4 * this.leftPlaneZ > this.leftPlaneOffset)
                  {
                     param1 = param1 & 59;
                  }
               }
               else
               {
                  if(param2 * this.leftPlaneX + param3 * this.leftPlaneY + param4 * this.leftPlaneZ <= this.leftPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.leftPlaneX + param6 * this.leftPlaneY + param7 * this.leftPlaneZ > this.leftPlaneOffset)
                  {
                     param1 = param1 & 59;
                  }
               }
            }
            if(param1 & 8)
            {
               if(this.rightPlaneX >= 0)
               {
                  if(this.rightPlaneY >= 0)
                  {
                     if(this.rightPlaneZ >= 0)
                     {
                        if(param5 * this.rightPlaneX + param6 * this.rightPlaneY + param7 * this.rightPlaneZ <= this.rightPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.rightPlaneX + param3 * this.rightPlaneY + param4 * this.rightPlaneZ > this.rightPlaneOffset)
                        {
                           param1 = param1 & 55;
                        }
                     }
                     else
                     {
                        if(param5 * this.rightPlaneX + param6 * this.rightPlaneY + param4 * this.rightPlaneZ <= this.rightPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.rightPlaneX + param3 * this.rightPlaneY + param7 * this.rightPlaneZ > this.rightPlaneOffset)
                        {
                           param1 = param1 & 55;
                        }
                     }
                  }
                  else if(this.rightPlaneZ >= 0)
                  {
                     if(param5 * this.rightPlaneX + param3 * this.rightPlaneY + param7 * this.rightPlaneZ <= this.rightPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.rightPlaneX + param6 * this.rightPlaneY + param4 * this.rightPlaneZ > this.rightPlaneOffset)
                     {
                        param1 = param1 & 55;
                     }
                  }
                  else
                  {
                     if(param5 * this.rightPlaneX + param3 * this.rightPlaneY + param4 * this.rightPlaneZ <= this.rightPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.rightPlaneX + param6 * this.rightPlaneY + param7 * this.rightPlaneZ > this.rightPlaneOffset)
                     {
                        param1 = param1 & 55;
                     }
                  }
               }
               else if(this.rightPlaneY >= 0)
               {
                  if(this.rightPlaneZ >= 0)
                  {
                     if(param2 * this.rightPlaneX + param6 * this.rightPlaneY + param7 * this.rightPlaneZ <= this.rightPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.rightPlaneX + param3 * this.rightPlaneY + param4 * this.rightPlaneZ > this.rightPlaneOffset)
                     {
                        param1 = param1 & 55;
                     }
                  }
                  else
                  {
                     if(param2 * this.rightPlaneX + param6 * this.rightPlaneY + param4 * this.rightPlaneZ <= this.rightPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.rightPlaneX + param3 * this.rightPlaneY + param7 * this.rightPlaneZ > this.rightPlaneOffset)
                     {
                        param1 = param1 & 55;
                     }
                  }
               }
               else if(this.rightPlaneZ >= 0)
               {
                  if(param2 * this.rightPlaneX + param3 * this.rightPlaneY + param7 * this.rightPlaneZ <= this.rightPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.rightPlaneX + param6 * this.rightPlaneY + param4 * this.rightPlaneZ > this.rightPlaneOffset)
                  {
                     param1 = param1 & 55;
                  }
               }
               else
               {
                  if(param2 * this.rightPlaneX + param3 * this.rightPlaneY + param4 * this.rightPlaneZ <= this.rightPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.rightPlaneX + param6 * this.rightPlaneY + param7 * this.rightPlaneZ > this.rightPlaneOffset)
                  {
                     param1 = param1 & 55;
                  }
               }
            }
            if(param1 & 16)
            {
               if(this.topPlaneX >= 0)
               {
                  if(this.topPlaneY >= 0)
                  {
                     if(this.topPlaneZ >= 0)
                     {
                        if(param5 * this.topPlaneX + param6 * this.topPlaneY + param7 * this.topPlaneZ <= this.topPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.topPlaneX + param3 * this.topPlaneY + param4 * this.topPlaneZ > this.topPlaneOffset)
                        {
                           param1 = param1 & 47;
                        }
                     }
                     else
                     {
                        if(param5 * this.topPlaneX + param6 * this.topPlaneY + param4 * this.topPlaneZ <= this.topPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.topPlaneX + param3 * this.topPlaneY + param7 * this.topPlaneZ > this.topPlaneOffset)
                        {
                           param1 = param1 & 47;
                        }
                     }
                  }
                  else if(this.topPlaneZ >= 0)
                  {
                     if(param5 * this.topPlaneX + param3 * this.topPlaneY + param7 * this.topPlaneZ <= this.topPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.topPlaneX + param6 * this.topPlaneY + param4 * this.topPlaneZ > this.topPlaneOffset)
                     {
                        param1 = param1 & 47;
                     }
                  }
                  else
                  {
                     if(param5 * this.topPlaneX + param3 * this.topPlaneY + param4 * this.topPlaneZ <= this.topPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.topPlaneX + param6 * this.topPlaneY + param7 * this.topPlaneZ > this.topPlaneOffset)
                     {
                        param1 = param1 & 47;
                     }
                  }
               }
               else if(this.topPlaneY >= 0)
               {
                  if(this.topPlaneZ >= 0)
                  {
                     if(param2 * this.topPlaneX + param6 * this.topPlaneY + param7 * this.topPlaneZ <= this.topPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.topPlaneX + param3 * this.topPlaneY + param4 * this.topPlaneZ > this.topPlaneOffset)
                     {
                        param1 = param1 & 47;
                     }
                  }
                  else
                  {
                     if(param2 * this.topPlaneX + param6 * this.topPlaneY + param4 * this.topPlaneZ <= this.topPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.topPlaneX + param3 * this.topPlaneY + param7 * this.topPlaneZ > this.topPlaneOffset)
                     {
                        param1 = param1 & 47;
                     }
                  }
               }
               else if(this.topPlaneZ >= 0)
               {
                  if(param2 * this.topPlaneX + param3 * this.topPlaneY + param7 * this.topPlaneZ <= this.topPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.topPlaneX + param6 * this.topPlaneY + param4 * this.topPlaneZ > this.topPlaneOffset)
                  {
                     param1 = param1 & 47;
                  }
               }
               else
               {
                  if(param2 * this.topPlaneX + param3 * this.topPlaneY + param4 * this.topPlaneZ <= this.topPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.topPlaneX + param6 * this.topPlaneY + param7 * this.topPlaneZ > this.topPlaneOffset)
                  {
                     param1 = param1 & 47;
                  }
               }
            }
            if(param1 & 32)
            {
               if(this.bottomPlaneX >= 0)
               {
                  if(this.bottomPlaneY >= 0)
                  {
                     if(this.bottomPlaneZ >= 0)
                     {
                        if(param5 * this.bottomPlaneX + param6 * this.bottomPlaneY + param7 * this.bottomPlaneZ <= this.bottomPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.bottomPlaneX + param3 * this.bottomPlaneY + param4 * this.bottomPlaneZ > this.bottomPlaneOffset)
                        {
                           param1 = param1 & 31;
                        }
                     }
                     else
                     {
                        if(param5 * this.bottomPlaneX + param6 * this.bottomPlaneY + param4 * this.bottomPlaneZ <= this.bottomPlaneOffset)
                        {
                           return -1;
                        }
                        if(param2 * this.bottomPlaneX + param3 * this.bottomPlaneY + param7 * this.bottomPlaneZ > this.bottomPlaneOffset)
                        {
                           param1 = param1 & 31;
                        }
                     }
                  }
                  else if(this.bottomPlaneZ >= 0)
                  {
                     if(param5 * this.bottomPlaneX + param3 * this.bottomPlaneY + param7 * this.bottomPlaneZ <= this.bottomPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.bottomPlaneX + param6 * this.bottomPlaneY + param4 * this.bottomPlaneZ > this.bottomPlaneOffset)
                     {
                        param1 = param1 & 31;
                     }
                  }
                  else
                  {
                     if(param5 * this.bottomPlaneX + param3 * this.bottomPlaneY + param4 * this.bottomPlaneZ <= this.bottomPlaneOffset)
                     {
                        return -1;
                     }
                     if(param2 * this.bottomPlaneX + param6 * this.bottomPlaneY + param7 * this.bottomPlaneZ > this.bottomPlaneOffset)
                     {
                        param1 = param1 & 31;
                     }
                  }
               }
               else if(this.bottomPlaneY >= 0)
               {
                  if(this.bottomPlaneZ >= 0)
                  {
                     if(param2 * this.bottomPlaneX + param6 * this.bottomPlaneY + param7 * this.bottomPlaneZ <= this.bottomPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.bottomPlaneX + param3 * this.bottomPlaneY + param4 * this.bottomPlaneZ > this.bottomPlaneOffset)
                     {
                        param1 = param1 & 31;
                     }
                  }
                  else
                  {
                     if(param2 * this.bottomPlaneX + param6 * this.bottomPlaneY + param4 * this.bottomPlaneZ <= this.bottomPlaneOffset)
                     {
                        return -1;
                     }
                     if(param5 * this.bottomPlaneX + param3 * this.bottomPlaneY + param7 * this.bottomPlaneZ > this.bottomPlaneOffset)
                     {
                        param1 = param1 & 31;
                     }
                  }
               }
               else if(this.bottomPlaneZ >= 0)
               {
                  if(param2 * this.bottomPlaneX + param3 * this.bottomPlaneY + param7 * this.bottomPlaneZ <= this.bottomPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.bottomPlaneX + param6 * this.bottomPlaneY + param4 * this.bottomPlaneZ > this.bottomPlaneOffset)
                  {
                     param1 = param1 & 31;
                  }
               }
               else
               {
                  if(param2 * this.bottomPlaneX + param3 * this.bottomPlaneY + param4 * this.bottomPlaneZ <= this.bottomPlaneOffset)
                  {
                     return -1;
                  }
                  if(param5 * this.bottomPlaneX + param6 * this.bottomPlaneY + param7 * this.bottomPlaneZ > this.bottomPlaneOffset)
                  {
                     param1 = param1 & 31;
                  }
               }
            }
         }
         var _loc8_:int = 0;
         while(true)
         {
            if(true)
            {
               if(_loc8_ >= this.numOccluders)
               {
                  break;
               }
               _loc9_ = this.occluders[_loc8_];
               while(_loc9_ != null)
               {
                  if(_loc9_.x >= 0)
                  {
                     if(_loc9_.y >= 0)
                     {
                        if(_loc9_.z >= 0)
                        {
                           if(param5 * _loc9_.x + param6 * _loc9_.y + param7 * _loc9_.z > _loc9_.offset)
                           {
                              break;
                           }
                        }
                        else if(param5 * _loc9_.x + param6 * _loc9_.y + param4 * _loc9_.z > _loc9_.offset)
                        {
                           break;
                        }
                     }
                     else if(_loc9_.z >= 0)
                     {
                        if(param5 * _loc9_.x + param3 * _loc9_.y + param7 * _loc9_.z > _loc9_.offset)
                        {
                           break;
                        }
                     }
                     else if(param5 * _loc9_.x + param3 * _loc9_.y + param4 * _loc9_.z > _loc9_.offset)
                     {
                        break;
                     }
                  }
                  else if(_loc9_.y >= 0)
                  {
                     if(_loc9_.z >= 0)
                     {
                        if(param2 * _loc9_.x + param6 * _loc9_.y + param7 * _loc9_.z > _loc9_.offset)
                        {
                           break;
                        }
                     }
                     else if(param2 * _loc9_.x + param6 * _loc9_.y + param4 * _loc9_.z > _loc9_.offset)
                     {
                        break;
                     }
                  }
                  else if(_loc9_.z >= 0)
                  {
                     if(param2 * _loc9_.x + param3 * _loc9_.y + param7 * _loc9_.z > _loc9_.offset)
                     {
                        break;
                     }
                  }
                  else if(param2 * _loc9_.x + param3 * _loc9_.y + param4 * _loc9_.z > _loc9_.offset)
                  {
                     break;
                  }
                  _loc9_ = _loc9_.next;
               }
               if(_loc9_ != null)
               {
                  _loc8_++;
                  continue;
               }
            }
            return -1;
         }
         return param1;
      }
      
      private function occludeGeometry(param1:Camera3D, param2:VG) : Boolean
      {
         var _loc4_:Vertex = null;
         var _loc3_:int = param2.numOccluders;
         while(true)
         {
            if(true)
            {
               if(_loc3_ >= this.numOccluders)
               {
                  break;
               }
               _loc4_ = this.occluders[_loc3_];
               while(_loc4_ != null)
               {
                  if(_loc4_.x >= 0)
                  {
                     if(_loc4_.y >= 0)
                     {
                        if(_loc4_.z >= 0)
                        {
                           if(param2.boundMaxX * _loc4_.x + param2.boundMaxY * _loc4_.y + param2.boundMaxZ * _loc4_.z > _loc4_.offset)
                           {
                              break;
                           }
                        }
                        else if(param2.boundMaxX * _loc4_.x + param2.boundMaxY * _loc4_.y + param2.boundMinZ * _loc4_.z > _loc4_.offset)
                        {
                           break;
                        }
                     }
                     else if(_loc4_.z >= 0)
                     {
                        if(param2.boundMaxX * _loc4_.x + param2.boundMinY * _loc4_.y + param2.boundMaxZ * _loc4_.z > _loc4_.offset)
                        {
                           break;
                        }
                     }
                     else if(param2.boundMaxX * _loc4_.x + param2.boundMinY * _loc4_.y + param2.boundMinZ * _loc4_.z > _loc4_.offset)
                     {
                        break;
                     }
                  }
                  else if(_loc4_.y >= 0)
                  {
                     if(_loc4_.z >= 0)
                     {
                        if(param2.boundMinX * _loc4_.x + param2.boundMaxY * _loc4_.y + param2.boundMaxZ * _loc4_.z > _loc4_.offset)
                        {
                           break;
                        }
                     }
                     else if(param2.boundMinX * _loc4_.x + param2.boundMaxY * _loc4_.y + param2.boundMinZ * _loc4_.z > _loc4_.offset)
                     {
                        break;
                     }
                  }
                  else if(_loc4_.z >= 0)
                  {
                     if(param2.boundMinX * _loc4_.x + param2.boundMinY * _loc4_.y + param2.boundMaxZ * _loc4_.z > _loc4_.offset)
                     {
                        break;
                     }
                  }
                  else if(param2.boundMinX * _loc4_.x + param2.boundMinY * _loc4_.y + param2.boundMinZ * _loc4_.z > _loc4_.offset)
                  {
                     break;
                  }
                  _loc4_ = _loc4_.next;
               }
               if(_loc4_ != null)
               {
                  _loc3_++;
                  continue;
               }
            }
            return true;
         }
         param2.numOccluders = this.numOccluders;
         return false;
      }
   }
}

import alternativa.engine3d.alternativa3d;
import alternativa.engine3d.core.Face;
import alternativa.engine3d.core.Object3D;
import alternativa.engine3d.core.Shadow;
import alternativa.engine3d.core.Vertex;
import alternativa.engine3d.core.Wrapper;
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.objects.BSP;
import alternativa.engine3d.objects.Decal;
import alternativa.engine3d.objects.Mesh;

use namespace alternativa3d;

class KDNode
{
    
   
   public var negative:KDNode;
   
   public var positive:KDNode;
   
   public var axis:int;
   
   public var coord:Number;
   
   public var minCoord:Number;
   
   public var maxCoord:Number;
   
   public var boundMinX:Number;
   
   public var boundMinY:Number;
   
   public var boundMinZ:Number;
   
   public var boundMaxX:Number;
   
   public var boundMaxY:Number;
   
   public var boundMaxZ:Number;
   
   public var objectList:Object3D;
   
   public var objectBoundList:Object3D;
   
   public var occluderList:Object3D;
   
   public var occluderBoundList:Object3D;
   
   public var receiverList:Receiver;
   
   function KDNode()
   {
      super();
   }
   
   public function createReceivers(param1:Vector.<Vector.<Number>>, param2:Vector.<Vector.<uint>>) : void
   {
      var _loc3_:Receiver = null;
      var _loc5_:Receiver = null;
      var _loc6_:Vertex = null;
      var _loc7_:Vertex = null;
      var _loc8_:Vector.<Face> = null;
      var _loc9_:int = 0;
      var _loc10_:TextureMaterial = null;
      var _loc11_:int = 0;
      var _loc12_:int = 0;
      var _loc13_:Vector.<Number> = null;
      var _loc14_:Vector.<uint> = null;
      var _loc15_:int = 0;
      var _loc16_:int = 0;
      var _loc17_:int = 0;
      var _loc18_:int = 0;
      var _loc19_:Face = null;
      var _loc20_:Wrapper = null;
      var _loc21_:uint = 0;
      var _loc22_:uint = 0;
      var _loc23_:uint = 0;
      var _loc4_:Object3D = null;
      _loc3_ = null;
      _loc5_ = null;
      _loc6_ = null;
      _loc7_ = null;
      _loc8_ = null;
      _loc9_ = 0;
      _loc10_ = null;
      _loc11_ = 0;
      _loc12_ = 0;
      _loc13_ = null;
      _loc14_ = null;
      _loc15_ = 0;
      _loc16_ = 0;
      _loc17_ = 0;
      _loc18_ = 0;
      _loc19_ = null;
      _loc20_ = null;
      _loc21_ = 0;
      _loc22_ = 0;
      _loc23_ = 0;
      this.receiverList = null;
      _loc4_ = this.objectList;
      while(_loc4_ != null)
      {
         _loc4_.composeMatrix();
         _loc5_ = new Receiver();
         if(_loc3_ != null)
         {
            _loc3_.next = _loc5_;
         }
         else
         {
            this.receiverList = _loc5_;
         }
         _loc3_ = _loc5_;
         if(_loc4_ is Mesh)
         {
            _loc7_ = (_loc4_ as Mesh).vertexList;
            _loc8_ = (_loc4_ as Mesh).faces;
         }
         else if(_loc4_ is BSP)
         {
            _loc7_ = (_loc4_ as BSP).vertexList;
            _loc8_ = (_loc4_ as BSP).faces;
         }
         _loc9_ = _loc8_.length;
         _loc10_ = _loc8_[0].material as TextureMaterial;
         if(_loc9_ > 0 && _loc10_ != null)
         {
            _loc11_ = 0;
            _loc6_ = _loc7_;
            while(_loc6_ != null)
            {
               _loc11_++;
               _loc6_ = _loc6_.next;
            }
            _loc12_ = param1.length - 1;
            _loc13_ = param1[_loc12_];
            if(_loc13_.length / 3 + _loc11_ > 65535)
            {
               _loc12_++;
               param1[_loc12_] = new Vector.<Number>();
               param2[_loc12_] = new Vector.<uint>();
               _loc13_ = param1[_loc12_];
            }
            _loc14_ = param2[_loc12_];
            _loc15_ = _loc13_.length;
            _loc16_ = _loc15_ / 3;
            _loc17_ = _loc14_.length;
            _loc5_.buffer = _loc12_;
            _loc5_.firstIndex = _loc17_;
            _loc5_.transparent = _loc10_.transparent;
            _loc6_ = _loc7_;
            while(_loc6_ != null)
            {
               _loc13_[_loc15_] = _loc6_.x * _loc4_.ma + _loc6_.y * _loc4_.mb + _loc6_.z * _loc4_.mc + _loc4_.md;
               _loc15_++;
               _loc13_[_loc15_] = _loc6_.x * _loc4_.me + _loc6_.y * _loc4_.mf + _loc6_.z * _loc4_.mg + _loc4_.mh;
               _loc15_++;
               _loc13_[_loc15_] = _loc6_.x * _loc4_.mi + _loc6_.y * _loc4_.mj + _loc6_.z * _loc4_.mk + _loc4_.ml;
               _loc15_++;
               _loc6_.index = _loc16_;
               _loc16_++;
               _loc6_ = _loc6_.next;
            }
            _loc18_ = 0;
            while(_loc18_ < _loc9_)
            {
               _loc19_ = _loc8_[_loc18_];
               if(_loc19_.normalX * _loc4_.mi + _loc19_.normalY * _loc4_.mj + _loc19_.normalZ * _loc4_.mk >= -0.5)
               {
                  _loc20_ = _loc19_.wrapper;
                  _loc21_ = _loc20_.vertex.index;
                  _loc20_ = _loc20_.next;
                  _loc22_ = _loc20_.vertex.index;
                  _loc20_ = _loc20_.next;
                  while(_loc20_ != null)
                  {
                     _loc23_ = _loc20_.vertex.index;
                     _loc14_[_loc17_] = _loc21_;
                     _loc17_++;
                     _loc14_[_loc17_] = _loc22_;
                     _loc17_++;
                     _loc14_[_loc17_] = _loc23_;
                     _loc17_++;
                     _loc5_.numTriangles++;
                     _loc22_ = _loc23_;
                     _loc20_ = _loc20_.next;
                  }
               }
               _loc18_++;
            }
         }
         _loc4_ = _loc4_.next;
      }
      if(this.negative != null)
      {
         this.negative.createReceivers(param1,param2);
      }
      if(this.positive != null)
      {
         this.positive.createReceivers(param1,param2);
      }
   }
   
   public function collectReceivers(param1:Shadow) : void
   {
      var _loc2_:Object3D = null;
      var _loc3_:Object3D = null;
      var _loc4_:Receiver = null;
      var _loc5_:Boolean = false;
      var _loc6_:Boolean = false;
      var _loc7_:Number = NaN;
      var _loc8_:Number = NaN;
      _loc2_ = null;
      _loc3_ = null;
      _loc4_ = null;
      _loc5_ = false;
      _loc6_ = false;
      _loc7_ = NaN;
      _loc8_ = NaN;
      if(this.negative != null)
      {
         _loc5_ = this.axis == 0;
         _loc6_ = this.axis == 1;
         _loc7_ = _loc5_?Number(Number(param1.boundMinX)):_loc6_?Number(Number(param1.boundMinY)):Number(Number(param1.boundMinZ));
         _loc8_ = _loc5_?Number(Number(param1.boundMaxX)):_loc6_?Number(Number(param1.boundMaxY)):Number(Number(param1.boundMaxZ));
         if(_loc8_ <= this.maxCoord)
         {
            this.negative.collectReceivers(param1);
         }
         else if(_loc7_ >= this.minCoord)
         {
            this.positive.collectReceivers(param1);
         }
         else
         {
            if(_loc5_)
            {
               _loc3_ = this.objectBoundList;
               _loc2_ = this.objectList;
               _loc4_ = this.receiverList;
               while(_loc3_ != null)
               {
                  if(_loc4_.numTriangles > 0 && param1.boundMinY < _loc3_.boundMaxY && param1.boundMaxY > _loc3_.boundMinY && param1.boundMinZ < _loc3_.boundMaxZ && param1.boundMaxZ > _loc3_.boundMinZ)
                  {
                     if(!_loc4_.transparent)
                     {
                        param1.receiversBuffers[param1.receiversCount] = _loc4_.buffer;
                        param1.receiversFirstIndexes[param1.receiversCount] = _loc4_.firstIndex;
                        param1.receiversNumsTriangles[param1.receiversCount] = _loc4_.numTriangles;
                        param1.receiversCount++;
                     }
                  }
                  _loc3_ = _loc3_.next;
                  _loc2_ = _loc2_.next;
                  _loc4_ = _loc4_.next;
               }
            }
            else if(_loc6_)
            {
               _loc3_ = this.objectBoundList;
               _loc2_ = this.objectList;
               _loc4_ = this.receiverList;
               while(_loc3_ != null)
               {
                  if(_loc4_.numTriangles > 0 && param1.boundMinX < _loc3_.boundMaxX && param1.boundMaxX > _loc3_.boundMinX && param1.boundMinZ < _loc3_.boundMaxZ && param1.boundMaxZ > _loc3_.boundMinZ)
                  {
                     if(!_loc4_.transparent)
                     {
                        param1.receiversBuffers[param1.receiversCount] = _loc4_.buffer;
                        param1.receiversFirstIndexes[param1.receiversCount] = _loc4_.firstIndex;
                        param1.receiversNumsTriangles[param1.receiversCount] = _loc4_.numTriangles;
                        param1.receiversCount++;
                     }
                  }
                  _loc3_ = _loc3_.next;
                  _loc2_ = _loc2_.next;
                  _loc4_ = _loc4_.next;
               }
            }
            else
            {
               _loc3_ = this.objectBoundList;
               _loc2_ = this.objectList;
               _loc4_ = this.receiverList;
               while(_loc3_ != null)
               {
                  if(_loc4_.numTriangles > 0 && param1.boundMinX < _loc3_.boundMaxX && param1.boundMaxX > _loc3_.boundMinX && param1.boundMinY < _loc3_.boundMaxY && param1.boundMaxY > _loc3_.boundMinY)
                  {
                     if(!_loc4_.transparent)
                     {
                        param1.receiversBuffers[param1.receiversCount] = _loc4_.buffer;
                        param1.receiversFirstIndexes[param1.receiversCount] = _loc4_.firstIndex;
                        param1.receiversNumsTriangles[param1.receiversCount] = _loc4_.numTriangles;
                        param1.receiversCount++;
                     }
                  }
                  _loc3_ = _loc3_.next;
                  _loc2_ = _loc2_.next;
                  _loc4_ = _loc4_.next;
               }
            }
            this.negative.collectReceivers(param1);
            this.positive.collectReceivers(param1);
         }
      }
      else
      {
         _loc2_ = this.objectList;
         _loc4_ = this.receiverList;
         while(_loc4_ != null)
         {
            if(_loc4_.numTriangles > 0)
            {
               if(!_loc4_.transparent)
               {
                  param1.receiversBuffers[param1.receiversCount] = _loc4_.buffer;
                  param1.receiversFirstIndexes[param1.receiversCount] = _loc4_.firstIndex;
                  param1.receiversNumsTriangles[param1.receiversCount] = _loc4_.numTriangles;
                  param1.receiversCount++;
               }
            }
            _loc2_ = _loc2_.next;
            _loc4_ = _loc4_.next;
         }
      }
   }
   
   public function collectPolygons(param1:Decal, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
   {
      var _loc10_:Object3D = null;
      var _loc11_:Object3D = null;
      var _loc12_:Boolean = false;
      var _loc13_:Boolean = false;
      var _loc14_:Number = NaN;
      var _loc15_:Number = NaN;
      _loc10_ = null;
      _loc11_ = null;
      _loc12_ = false;
      _loc13_ = false;
      _loc14_ = NaN;
      _loc15_ = NaN;
      if(this.negative != null)
      {
         _loc12_ = this.axis == 0;
         _loc13_ = this.axis == 1;
         _loc14_ = _loc12_?Number(Number(param4)):_loc13_?Number(Number(param6)):Number(Number(param8));
         _loc15_ = _loc12_?Number(Number(param5)):_loc13_?Number(Number(param7)):Number(Number(param9));
         if(_loc15_ <= this.maxCoord)
         {
            this.negative.collectPolygons(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         }
         else if(_loc14_ >= this.minCoord)
         {
            this.positive.collectPolygons(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         }
         else
         {
            _loc11_ = this.objectBoundList;
            _loc10_ = this.objectList;
            while(_loc11_ != null)
            {
               if(_loc12_)
               {
                  if(param6 < _loc11_.boundMaxY && param7 > _loc11_.boundMinY && param8 < _loc11_.boundMaxZ && param9 > _loc11_.boundMinZ)
                  {
                     this.clip(param1,param2,param3,_loc10_);
                  }
               }
               else if(_loc13_)
               {
                  if(param4 < _loc11_.boundMaxX && param5 > _loc11_.boundMinX && param8 < _loc11_.boundMaxZ && param9 > _loc11_.boundMinZ)
                  {
                     this.clip(param1,param2,param3,_loc10_);
                  }
               }
               else if(param4 < _loc11_.boundMaxX && param5 > _loc11_.boundMinX && param6 < _loc11_.boundMaxY && param7 > _loc11_.boundMinY)
               {
                  this.clip(param1,param2,param3,_loc10_);
               }
               _loc11_ = _loc11_.next;
               _loc10_ = _loc10_.next;
            }
            this.negative.collectPolygons(param1,param2,param3,param4,param5,param6,param7,param8,param9);
            this.positive.collectPolygons(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         }
      }
      else
      {
         _loc10_ = this.objectList;
         while(_loc10_ != null)
         {
            this.clip(param1,param2,param3,_loc10_);
            _loc10_ = _loc10_.next;
         }
      }
   }
   
   private function clip(param1:Decal, param2:Number, param3:Number, param4:Object3D) : void
   {
      var _loc5_:Face = null;
      var _loc6_:Vertex = null;
      var _loc7_:Wrapper = null;
      var _loc9_:Vector.<Face> = null;
      var _loc10_:int = 0;
      var _loc11_:int = 0;
      var _loc12_:Number = NaN;
      var _loc13_:Number = NaN;
      var _loc14_:Vertex = null;
      var _loc15_:Vertex = null;
      var _loc16_:Vertex = null;
      var _loc17_:Vertex = null;
      var _loc18_:Vertex = null;
      var _loc19_:Vertex = null;
      var _loc20_:Wrapper = null;
      _loc5_ = null;
      _loc6_ = null;
      _loc7_ = null;
      var _loc8_:Vertex = null;
      _loc9_ = null;
      _loc10_ = 0;
      _loc11_ = 0;
      _loc12_ = NaN;
      _loc13_ = NaN;
      _loc14_ = null;
      _loc15_ = null;
      _loc16_ = null;
      _loc17_ = null;
      _loc18_ = null;
      _loc19_ = null;
      _loc20_ = null;
      if(param4 is Mesh)
      {
         _loc8_ = Mesh(param4).vertexList;
         _loc5_ = Mesh(param4).faceList;
         if(_loc5_.material == null || _loc5_.material.transparent)
         {
            return;
         }
         _loc9_ = Mesh(param4).faces;
      }
      else if(param4 is BSP)
      {
         _loc8_ = BSP(param4).vertexList;
         _loc9_ = BSP(param4).faces;
         _loc5_ = _loc9_[0];
         if(_loc5_.material == null || _loc5_.material.transparent)
         {
            return;
         }
      }
      param4.composeAndAppend(param1);
      param4.calculateInverseMatrix();
      param4.transformId++;
      _loc10_ = _loc9_.length;
      _loc11_ = 0;
      while(_loc11_ < _loc10_)
      {
         _loc5_ = _loc9_[_loc11_];
         if(-_loc5_.normalX * param4.imc - _loc5_.normalY * param4.img - _loc5_.normalZ * param4.imk >= param3)
         {
            _loc12_ = _loc5_.normalX * param4.imd + _loc5_.normalY * param4.imh + _loc5_.normalZ * param4.iml;
            if(!(_loc12_ <= _loc5_.offset - param2 || _loc12_ >= _loc5_.offset + param2))
            {
               _loc7_ = _loc5_.wrapper;
               while(_loc7_ != null)
               {
                  _loc6_ = _loc7_.vertex;
                  if(_loc6_.transformId != param4.transformId)
                  {
                     _loc6_.cameraX = param4.ma * _loc6_.x + param4.mb * _loc6_.y + param4.mc * _loc6_.z + param4.md;
                     _loc6_.cameraY = param4.me * _loc6_.x + param4.mf * _loc6_.y + param4.mg * _loc6_.z + param4.mh;
                     _loc6_.cameraZ = param4.mi * _loc6_.x + param4.mj * _loc6_.y + param4.mk * _loc6_.z + param4.ml;
                     _loc6_.transformId = param4.transformId;
                  }
                  _loc7_ = _loc7_.next;
               }
               _loc7_ = _loc5_.wrapper;
               while(_loc7_ != null)
               {
                  if(_loc7_.vertex.cameraX > param1.boundMinX)
                  {
                     break;
                  }
                  _loc7_ = _loc7_.next;
               }
               if(_loc7_ != null)
               {
                  _loc7_ = _loc5_.wrapper;
                  while(_loc7_ != null)
                  {
                     if(_loc7_.vertex.cameraX < param1.boundMaxX)
                     {
                        break;
                     }
                     _loc7_ = _loc7_.next;
                  }
                  if(_loc7_ != null)
                  {
                     _loc7_ = _loc5_.wrapper;
                     while(_loc7_ != null)
                     {
                        if(_loc7_.vertex.cameraY > param1.boundMinY)
                        {
                           break;
                        }
                        _loc7_ = _loc7_.next;
                     }
                     if(_loc7_ != null)
                     {
                        _loc7_ = _loc5_.wrapper;
                        while(_loc7_ != null)
                        {
                           if(_loc7_.vertex.cameraY < param1.boundMaxY)
                           {
                              break;
                           }
                           _loc7_ = _loc7_.next;
                        }
                        if(_loc7_ != null)
                        {
                           _loc7_ = _loc5_.wrapper;
                           while(_loc7_ != null)
                           {
                              if(_loc7_.vertex.cameraZ > param1.boundMinZ)
                              {
                                 break;
                              }
                              _loc7_ = _loc7_.next;
                           }
                           if(_loc7_ != null)
                           {
                              _loc7_ = _loc5_.wrapper;
                              while(_loc7_ != null)
                              {
                                 if(_loc7_.vertex.cameraZ < param1.boundMaxZ)
                                 {
                                    break;
                                 }
                                 _loc7_ = _loc7_.next;
                              }
                              if(_loc7_ != null)
                              {
                                 _loc18_ = null;
                                 _loc19_ = null;
                                 _loc7_ = _loc5_.wrapper;
                                 while(_loc7_ != null)
                                 {
                                    _loc6_ = _loc7_.vertex;
                                    _loc16_ = new Vertex();
                                    _loc16_.x = _loc6_.cameraX;
                                    _loc16_.y = _loc6_.cameraY;
                                    _loc16_.z = _loc6_.cameraZ;
                                    _loc16_.normalX = param4.ma * _loc6_.normalX + param4.mb * _loc6_.normalY + param4.mc * _loc6_.normalZ;
                                    _loc16_.normalY = param4.me * _loc6_.normalX + param4.mf * _loc6_.normalY + param4.mg * _loc6_.normalZ;
                                    _loc16_.normalZ = param4.mi * _loc6_.normalX + param4.mj * _loc6_.normalY + param4.mk * _loc6_.normalZ;
                                    if(_loc19_ != null)
                                    {
                                       _loc19_.next = _loc16_;
                                    }
                                    else
                                    {
                                       _loc18_ = _loc16_;
                                    }
                                    _loc19_ = _loc16_;
                                    _loc7_ = _loc7_.next;
                                 }
                                 _loc14_ = _loc19_;
                                 _loc15_ = _loc18_;
                                 _loc18_ = null;
                                 _loc19_ = null;
                                 while(_loc15_ != null)
                                 {
                                    _loc17_ = _loc15_.next;
                                    _loc15_.next = null;
                                    if(_loc15_.z > param1.boundMinZ && _loc14_.z <= param1.boundMinZ || _loc15_.z <= param1.boundMinZ && _loc14_.z > param1.boundMinZ)
                                    {
                                       _loc13_ = (param1.boundMinZ - _loc14_.z) / (_loc15_.z - _loc14_.z);
                                       _loc16_ = new Vertex();
                                       _loc16_.x = _loc14_.x + (_loc15_.x - _loc14_.x) * _loc13_;
                                       _loc16_.y = _loc14_.y + (_loc15_.y - _loc14_.y) * _loc13_;
                                       _loc16_.z = _loc14_.z + (_loc15_.z - _loc14_.z) * _loc13_;
                                       _loc16_.normalX = _loc14_.normalX + (_loc15_.normalX - _loc14_.normalX) * _loc13_;
                                       _loc16_.normalY = _loc14_.normalY + (_loc15_.normalY - _loc14_.normalY) * _loc13_;
                                       _loc16_.normalZ = _loc14_.normalZ + (_loc15_.normalZ - _loc14_.normalZ) * _loc13_;
                                       if(_loc19_ != null)
                                       {
                                          _loc19_.next = _loc16_;
                                       }
                                       else
                                       {
                                          _loc18_ = _loc16_;
                                       }
                                       _loc19_ = _loc16_;
                                    }
                                    if(_loc15_.z > param1.boundMinZ)
                                    {
                                       if(_loc19_ != null)
                                       {
                                          _loc19_.next = _loc15_;
                                       }
                                       else
                                       {
                                          _loc18_ = _loc15_;
                                       }
                                       _loc19_ = _loc15_;
                                    }
                                    _loc14_ = _loc15_;
                                    _loc15_ = _loc17_;
                                 }
                                 if(_loc18_ != null)
                                 {
                                    _loc14_ = _loc19_;
                                    _loc15_ = _loc18_;
                                    _loc18_ = null;
                                    _loc19_ = null;
                                    while(_loc15_ != null)
                                    {
                                       _loc17_ = _loc15_.next;
                                       _loc15_.next = null;
                                       if(_loc15_.z < param1.boundMaxZ && _loc14_.z >= param1.boundMaxZ || _loc15_.z >= param1.boundMaxZ && _loc14_.z < param1.boundMaxZ)
                                       {
                                          _loc13_ = (param1.boundMaxZ - _loc14_.z) / (_loc15_.z - _loc14_.z);
                                          _loc16_ = new Vertex();
                                          _loc16_.x = _loc14_.x + (_loc15_.x - _loc14_.x) * _loc13_;
                                          _loc16_.y = _loc14_.y + (_loc15_.y - _loc14_.y) * _loc13_;
                                          _loc16_.z = _loc14_.z + (_loc15_.z - _loc14_.z) * _loc13_;
                                          _loc16_.normalX = _loc14_.normalX + (_loc15_.normalX - _loc14_.normalX) * _loc13_;
                                          _loc16_.normalY = _loc14_.normalY + (_loc15_.normalY - _loc14_.normalY) * _loc13_;
                                          _loc16_.normalZ = _loc14_.normalZ + (_loc15_.normalZ - _loc14_.normalZ) * _loc13_;
                                          if(_loc19_ != null)
                                          {
                                             _loc19_.next = _loc16_;
                                          }
                                          else
                                          {
                                             _loc18_ = _loc16_;
                                          }
                                          _loc19_ = _loc16_;
                                       }
                                       if(_loc15_.z < param1.boundMaxZ)
                                       {
                                          if(_loc19_ != null)
                                          {
                                             _loc19_.next = _loc15_;
                                          }
                                          else
                                          {
                                             _loc18_ = _loc15_;
                                          }
                                          _loc19_ = _loc15_;
                                       }
                                       _loc14_ = _loc15_;
                                       _loc15_ = _loc17_;
                                    }
                                    if(_loc18_ != null)
                                    {
                                       _loc14_ = _loc19_;
                                       _loc15_ = _loc18_;
                                       _loc18_ = null;
                                       _loc19_ = null;
                                       while(_loc15_ != null)
                                       {
                                          _loc17_ = _loc15_.next;
                                          _loc15_.next = null;
                                          if(_loc15_.x > param1.boundMinX && _loc14_.x <= param1.boundMinX || _loc15_.x <= param1.boundMinX && _loc14_.x > param1.boundMinX)
                                          {
                                             _loc13_ = (param1.boundMinX - _loc14_.x) / (_loc15_.x - _loc14_.x);
                                             _loc16_ = new Vertex();
                                             _loc16_.x = _loc14_.x + (_loc15_.x - _loc14_.x) * _loc13_;
                                             _loc16_.y = _loc14_.y + (_loc15_.y - _loc14_.y) * _loc13_;
                                             _loc16_.z = _loc14_.z + (_loc15_.z - _loc14_.z) * _loc13_;
                                             _loc16_.normalX = _loc14_.normalX + (_loc15_.normalX - _loc14_.normalX) * _loc13_;
                                             _loc16_.normalY = _loc14_.normalY + (_loc15_.normalY - _loc14_.normalY) * _loc13_;
                                             _loc16_.normalZ = _loc14_.normalZ + (_loc15_.normalZ - _loc14_.normalZ) * _loc13_;
                                             if(_loc19_ != null)
                                             {
                                                _loc19_.next = _loc16_;
                                             }
                                             else
                                             {
                                                _loc18_ = _loc16_;
                                             }
                                             _loc19_ = _loc16_;
                                          }
                                          if(_loc15_.x > param1.boundMinX)
                                          {
                                             if(_loc19_ != null)
                                             {
                                                _loc19_.next = _loc15_;
                                             }
                                             else
                                             {
                                                _loc18_ = _loc15_;
                                             }
                                             _loc19_ = _loc15_;
                                          }
                                          _loc14_ = _loc15_;
                                          _loc15_ = _loc17_;
                                       }
                                       if(_loc18_ != null)
                                       {
                                          _loc14_ = _loc19_;
                                          _loc15_ = _loc18_;
                                          _loc18_ = null;
                                          _loc19_ = null;
                                          while(_loc15_ != null)
                                          {
                                             _loc17_ = _loc15_.next;
                                             _loc15_.next = null;
                                             if(_loc15_.x < param1.boundMaxX && _loc14_.x >= param1.boundMaxX || _loc15_.x >= param1.boundMaxX && _loc14_.x < param1.boundMaxX)
                                             {
                                                _loc13_ = (param1.boundMaxX - _loc14_.x) / (_loc15_.x - _loc14_.x);
                                                _loc16_ = new Vertex();
                                                _loc16_.x = _loc14_.x + (_loc15_.x - _loc14_.x) * _loc13_;
                                                _loc16_.y = _loc14_.y + (_loc15_.y - _loc14_.y) * _loc13_;
                                                _loc16_.z = _loc14_.z + (_loc15_.z - _loc14_.z) * _loc13_;
                                                _loc16_.normalX = _loc14_.normalX + (_loc15_.normalX - _loc14_.normalX) * _loc13_;
                                                _loc16_.normalY = _loc14_.normalY + (_loc15_.normalY - _loc14_.normalY) * _loc13_;
                                                _loc16_.normalZ = _loc14_.normalZ + (_loc15_.normalZ - _loc14_.normalZ) * _loc13_;
                                                if(_loc19_ != null)
                                                {
                                                   _loc19_.next = _loc16_;
                                                }
                                                else
                                                {
                                                   _loc18_ = _loc16_;
                                                }
                                                _loc19_ = _loc16_;
                                             }
                                             if(_loc15_.x < param1.boundMaxX)
                                             {
                                                if(_loc19_ != null)
                                                {
                                                   _loc19_.next = _loc15_;
                                                }
                                                else
                                                {
                                                   _loc18_ = _loc15_;
                                                }
                                                _loc19_ = _loc15_;
                                             }
                                             _loc14_ = _loc15_;
                                             _loc15_ = _loc17_;
                                          }
                                          if(_loc18_ != null)
                                          {
                                             _loc14_ = _loc19_;
                                             _loc15_ = _loc18_;
                                             _loc18_ = null;
                                             _loc19_ = null;
                                             while(_loc15_ != null)
                                             {
                                                _loc17_ = _loc15_.next;
                                                _loc15_.next = null;
                                                if(_loc15_.y > param1.boundMinY && _loc14_.y <= param1.boundMinY || _loc15_.y <= param1.boundMinY && _loc14_.y > param1.boundMinY)
                                                {
                                                   _loc13_ = (param1.boundMinY - _loc14_.y) / (_loc15_.y - _loc14_.y);
                                                   _loc16_ = new Vertex();
                                                   _loc16_.x = _loc14_.x + (_loc15_.x - _loc14_.x) * _loc13_;
                                                   _loc16_.y = _loc14_.y + (_loc15_.y - _loc14_.y) * _loc13_;
                                                   _loc16_.z = _loc14_.z + (_loc15_.z - _loc14_.z) * _loc13_;
                                                   _loc16_.normalX = _loc14_.normalX + (_loc15_.normalX - _loc14_.normalX) * _loc13_;
                                                   _loc16_.normalY = _loc14_.normalY + (_loc15_.normalY - _loc14_.normalY) * _loc13_;
                                                   _loc16_.normalZ = _loc14_.normalZ + (_loc15_.normalZ - _loc14_.normalZ) * _loc13_;
                                                   if(_loc19_ != null)
                                                   {
                                                      _loc19_.next = _loc16_;
                                                   }
                                                   else
                                                   {
                                                      _loc18_ = _loc16_;
                                                   }
                                                   _loc19_ = _loc16_;
                                                }
                                                if(_loc15_.y > param1.boundMinY)
                                                {
                                                   if(_loc19_ != null)
                                                   {
                                                      _loc19_.next = _loc15_;
                                                   }
                                                   else
                                                   {
                                                      _loc18_ = _loc15_;
                                                   }
                                                   _loc19_ = _loc15_;
                                                }
                                                _loc14_ = _loc15_;
                                                _loc15_ = _loc17_;
                                             }
                                             if(_loc18_ != null)
                                             {
                                                _loc14_ = _loc19_;
                                                _loc15_ = _loc18_;
                                                _loc18_ = null;
                                                _loc19_ = null;
                                                while(_loc15_ != null)
                                                {
                                                   _loc17_ = _loc15_.next;
                                                   _loc15_.next = null;
                                                   if(_loc15_.y < param1.boundMaxY && _loc14_.y >= param1.boundMaxY || _loc15_.y >= param1.boundMaxY && _loc14_.y < param1.boundMaxY)
                                                   {
                                                      _loc13_ = (param1.boundMaxY - _loc14_.y) / (_loc15_.y - _loc14_.y);
                                                      _loc16_ = new Vertex();
                                                      _loc16_.x = _loc14_.x + (_loc15_.x - _loc14_.x) * _loc13_;
                                                      _loc16_.y = _loc14_.y + (_loc15_.y - _loc14_.y) * _loc13_;
                                                      _loc16_.z = _loc14_.z + (_loc15_.z - _loc14_.z) * _loc13_;
                                                      _loc16_.normalX = _loc14_.normalX + (_loc15_.normalX - _loc14_.normalX) * _loc13_;
                                                      _loc16_.normalY = _loc14_.normalY + (_loc15_.normalY - _loc14_.normalY) * _loc13_;
                                                      _loc16_.normalZ = _loc14_.normalZ + (_loc15_.normalZ - _loc14_.normalZ) * _loc13_;
                                                      if(_loc19_ != null)
                                                      {
                                                         _loc19_.next = _loc16_;
                                                      }
                                                      else
                                                      {
                                                         _loc18_ = _loc16_;
                                                      }
                                                      _loc19_ = _loc16_;
                                                   }
                                                   if(_loc15_.y < param1.boundMaxY)
                                                   {
                                                      if(_loc19_ != null)
                                                      {
                                                         _loc19_.next = _loc15_;
                                                      }
                                                      else
                                                      {
                                                         _loc18_ = _loc15_;
                                                      }
                                                      _loc19_ = _loc15_;
                                                   }
                                                   _loc14_ = _loc15_;
                                                   _loc15_ = _loc17_;
                                                }
                                                if(_loc18_ != null)
                                                {
                                                   _loc5_ = new Face();
                                                   _loc20_ = null;
                                                   _loc6_ = _loc18_;
                                                   while(_loc6_ != null)
                                                   {
                                                      _loc17_ = _loc6_.next;
                                                      _loc6_.next = param1.vertexList;
                                                      param1.vertexList = _loc6_;
                                                      _loc6_.u = (_loc6_.x - param1.boundMinX) / (param1.boundMaxX - param1.boundMinX);
                                                      _loc6_.v = (_loc6_.y - param1.boundMinY) / (param1.boundMaxY - param1.boundMinY);
                                                      if(_loc20_ != null)
                                                      {
                                                         _loc20_.next = new Wrapper();
                                                         _loc20_ = _loc20_.next;
                                                      }
                                                      else
                                                      {
                                                         _loc5_.wrapper = new Wrapper();
                                                         _loc20_ = _loc5_.wrapper;
                                                      }
                                                      _loc20_.vertex = _loc6_;
                                                      _loc6_ = _loc17_;
                                                   }
                                                   _loc5_.calculateBestSequenceAndNormal();
                                                   _loc5_.next = param1.faceList;
                                                   param1.faceList = _loc5_;
                                                }
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         _loc11_++;
      }
   }
}

class Receiver
{
    
   
   public var next:Receiver;
   
   public var transparent:Boolean = false;
   
   public var buffer:int = -1;
   
   public var firstIndex:int = -1;
   
   public var numTriangles:int = 0;
   
   function Receiver()
   {
      super();
   }
}