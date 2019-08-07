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
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class BSP extends Object3D
   {
       
      
      public var clipping:int = 2;
      
      public var threshold:Number = 0.01;
      
      public var splitAnalysis:Boolean = true;
      
      alternativa3d var vertexList:Vertex;
      
      alternativa3d var root:Node;
      
      alternativa3d var faces:Vector.<Face>;
      
      alternativa3d var vertexBuffer:VertexBufferResource;
      
      alternativa3d var indexBuffer:IndexBufferResource;
      
      alternativa3d var numTriangles:int;
      
      public function BSP()
      {
         this.faces = new Vector.<Face>();
         super();
      }
      
      public function createTree(param1:Mesh, param2:Boolean = false) : void
      {
         this.destroyTree();
         if(!param2)
         {
            param1 = param1.clone() as Mesh;
         }
         var _loc3_:Face = param1.faceList;
         this.vertexList = param1.vertexList;
         param1.faceList = null;
         param1.vertexList = null;
         var _loc4_:Vertex = this.vertexList;
         while(_loc4_ != null)
         {
            _loc4_.transformId = 0;
            _loc4_.id = null;
            _loc4_ = _loc4_.next;
         }
         var _loc5_:int = 0;
         var _loc6_:Face = _loc3_;
         while(_loc6_ != null)
         {
            _loc6_.calculateBestSequenceAndNormal();
            _loc6_.id = null;
            this.faces[_loc5_] = _loc6_;
            _loc5_++;
            _loc6_ = _loc6_.next;
         }
         if(_loc3_ != null)
         {
            this.root = this.createNode(_loc3_);
         }
         calculateBounds();
      }
      
      public function destroyTree() : void
      {
         this.deleteResources();
         this.vertexList = null;
         if(this.root != null)
         {
            this.destroyNode(this.root);
            this.root = null;
         }
         this.faces.length = 0;
      }
      
      public function setMaterialToAllFaces(param1:Material) : void
      {
         var _loc4_:Face = null;
         this.deleteResources();
         var _loc2_:int = this.faces.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.faces[_loc3_];
            _loc4_.material = param1;
            _loc3_++;
         }
         if(this.root != null)
         {
            this.setMaterialToNode(this.root,param1);
         }
      }
      
      override public function intersectRay(param1:Vector3D, param2:Vector3D, param3:Dictionary = null, param4:Camera3D = null) : RayIntersectionData
      {
         if(param3 != null && param3[this] || this.root == null)
         {
            return null;
         }
         if(!boundIntersectRay(param1,param2,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return null;
         }
         return this.intersectRayNode(this.root,param1.x,param1.y,param1.z,param2.x,param2.y,param2.z);
      }
      
      private function intersectRayNode(param1:Node, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : RayIntersectionData
      {
         var _loc8_:RayIntersectionData = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Face = null;
         var _loc19_:Wrapper = null;
         var _loc20_:Vertex = null;
         var _loc21_:Vertex = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc9_:Number = param1.normalX;
         var _loc10_:Number = param1.normalY;
         var _loc11_:Number = param1.normalZ;
         var _loc12_:Number = _loc9_ * param2 + _loc10_ * param3 + _loc11_ * param4 - param1.offset;
         if(_loc12_ > 0)
         {
            if(param1.positive != null)
            {
               _loc8_ = this.intersectRayNode(param1.positive,param2,param3,param4,param5,param6,param7);
               if(_loc8_ != null)
               {
                  return _loc8_;
               }
            }
            _loc13_ = param5 * _loc9_ + param6 * _loc10_ + param7 * _loc11_;
            if(_loc13_ < 0)
            {
               _loc14_ = -_loc12_ / _loc13_;
               _loc15_ = param2 + param5 * _loc14_;
               _loc16_ = param3 + param6 * _loc14_;
               _loc17_ = param4 + param7 * _loc14_;
               _loc18_ = param1.faceList;
               while(true)
               {
                  if(true)
                  {
                     if(_loc18_ == null)
                     {
                        if(param1.negative != null)
                        {
                           break;
                        }
                        continue;
                     }
                     _loc19_ = _loc18_.wrapper;
                     while(_loc19_ != null)
                     {
                        _loc20_ = _loc19_.vertex;
                        _loc21_ = _loc19_.next != null?_loc19_.next.vertex:_loc18_.wrapper.vertex;
                        _loc22_ = _loc21_.x - _loc20_.x;
                        _loc23_ = _loc21_.y - _loc20_.y;
                        _loc24_ = _loc21_.z - _loc20_.z;
                        _loc25_ = _loc15_ - _loc20_.x;
                        _loc26_ = _loc16_ - _loc20_.y;
                        _loc27_ = _loc17_ - _loc20_.z;
                        if((_loc27_ * _loc23_ - _loc26_ * _loc24_) * _loc9_ + (_loc25_ * _loc24_ - _loc27_ * _loc22_) * _loc10_ + (_loc26_ * _loc22_ - _loc25_ * _loc23_) * _loc11_ < 0)
                        {
                           break;
                        }
                        _loc19_ = _loc19_.next;
                     }
                     if(_loc19_ != null)
                     {
                        _loc18_ = _loc18_.next;
                        continue;
                     }
                  }
                  _loc8_ = new RayIntersectionData();
                  _loc8_.object = this;
                  _loc8_.face = _loc18_;
                  _loc8_.point = new Vector3D(_loc15_,_loc16_,_loc17_);
                  _loc8_.uv = _loc18_.getUV(_loc8_.point);
                  _loc8_.time = _loc14_;
                  return _loc8_;
               }
               return this.intersectRayNode(param1.negative,param2,param3,param4,param5,param6,param7);
            }
         }
         else
         {
            if(param1.negative != null)
            {
               _loc8_ = this.intersectRayNode(param1.negative,param2,param3,param4,param5,param6,param7);
               if(_loc8_ != null)
               {
                  return _loc8_;
               }
            }
            if(param1.positive != null && param5 * _loc9_ + param6 * _loc10_ + param7 * _loc11_ > 0)
            {
               return this.intersectRayNode(param1.positive,param2,param3,param4,param5,param6,param7);
            }
         }
         return null;
      }
      
      override alternativa3d function checkIntersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Dictionary) : Boolean
      {
         return this.root != null?Boolean(Boolean(this.checkIntersectionNode(this.root,param1,param2,param3,param4,param5,param6,param7))):Boolean(Boolean(false));
      }
      
      private function checkIntersectionNode(param1:Node, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         var _loc9_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Face = null;
         var _loc19_:Wrapper = null;
         var _loc20_:Vertex = null;
         var _loc21_:Vertex = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc10_:Number = param1.normalX;
         var _loc11_:Number = param1.normalY;
         var _loc12_:Number = param1.normalZ;
         var _loc13_:Number = _loc10_ * param2 + _loc11_ * param3 + _loc12_ * param4 - param1.offset;
         if(_loc13_ > 0)
         {
            _loc9_ = param5 * _loc10_ + param6 * _loc11_ + param7 * _loc12_;
            if(_loc9_ < 0)
            {
               _loc14_ = -_loc13_ / _loc9_;
               if(_loc14_ < param8)
               {
                  _loc15_ = param2 + param5 * _loc14_;
                  _loc16_ = param3 + param6 * _loc14_;
                  _loc17_ = param4 + param7 * _loc14_;
                  _loc18_ = param1.faceList;
                  while(true)
                  {
                     if(true)
                     {
                        if(_loc18_ == null)
                        {
                           if(param1.negative != null && this.checkIntersectionNode(param1.negative,param2,param3,param4,param5,param6,param7,param8))
                           {
                              break;
                           }
                           continue;
                        }
                        _loc19_ = _loc18_.wrapper;
                        while(_loc19_ != null)
                        {
                           _loc20_ = _loc19_.vertex;
                           _loc21_ = _loc19_.next != null?_loc19_.next.vertex:_loc18_.wrapper.vertex;
                           _loc22_ = _loc21_.x - _loc20_.x;
                           _loc23_ = _loc21_.y - _loc20_.y;
                           _loc24_ = _loc21_.z - _loc20_.z;
                           _loc25_ = _loc15_ - _loc20_.x;
                           _loc26_ = _loc16_ - _loc20_.y;
                           _loc27_ = _loc17_ - _loc20_.z;
                           if((_loc27_ * _loc23_ - _loc26_ * _loc24_) * _loc10_ + (_loc25_ * _loc24_ - _loc27_ * _loc22_) * _loc11_ + (_loc26_ * _loc22_ - _loc25_ * _loc23_) * _loc12_ < 0)
                           {
                              break;
                           }
                           _loc19_ = _loc19_.next;
                        }
                        if(_loc19_ != null)
                        {
                           _loc18_ = _loc18_.next;
                           continue;
                        }
                     }
                     return true;
                  }
                  return true;
               }
            }
            return param1.positive != null && this.checkIntersectionNode(param1.positive,param2,param3,param4,param5,param6,param7,param8);
         }
         if(param1.negative != null && this.checkIntersectionNode(param1.negative,param2,param3,param4,param5,param6,param7,param8))
         {
            return true;
         }
         if(param1.positive != null)
         {
            _loc9_ = param5 * _loc10_ + param6 * _loc11_ + param7 * _loc12_;
            return _loc9_ > 0 && -_loc13_ / _loc9_ < param8 && this.checkIntersectionNode(param1.positive,param2,param3,param4,param5,param6,param7,param8);
         }
         return false;
      }
      
      override alternativa3d function collectPlanes(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:Vector3D, param6:Vector.<Face>, param7:Dictionary = null) : void
      {
         if(param7 != null && param7[this] || this.root == null)
         {
            return;
         }
         var _loc8_:Vector3D = calculateSphere(param1,param2,param3,param4,param5);
         if(!boundIntersectSphere(_loc8_,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return;
         }
         this.collectPlanesNode(this.root,_loc8_,param6);
      }
      
      private function collectPlanesNode(param1:Node, param2:Vector3D, param3:Vector.<Face>) : void
      {
         var _loc5_:Face = null;
         var _loc6_:Wrapper = null;
         var _loc7_:Vertex = null;
         var _loc4_:Number = param1.normalX * param2.x + param1.normalY * param2.y + param1.normalZ * param2.z - param1.offset;
         if(_loc4_ >= param2.w)
         {
            if(param1.positive != null)
            {
               this.collectPlanesNode(param1.positive,param2,param3);
            }
         }
         else if(_loc4_ <= -param2.w)
         {
            if(param1.negative != null)
            {
               this.collectPlanesNode(param1.negative,param2,param3);
            }
         }
         else
         {
            _loc5_ = param1.faceList;
            while(_loc5_ != null)
            {
               _loc6_ = _loc5_.wrapper;
               while(_loc6_ != null)
               {
                  _loc7_ = _loc6_.vertex;
                  _loc7_.cameraX = ma * _loc7_.x + mb * _loc7_.y + mc * _loc7_.z + md;
                  _loc7_.cameraY = me * _loc7_.x + mf * _loc7_.y + mg * _loc7_.z + mh;
                  _loc7_.cameraZ = mi * _loc7_.x + mj * _loc7_.y + mk * _loc7_.z + ml;
                  _loc6_ = _loc6_.next;
               }
               param3.push(_loc5_);
               _loc5_ = _loc5_.next;
            }
            if(param1.positive != null)
            {
               this.collectPlanesNode(param1.positive,param2,param3);
            }
            if(param1.negative != null)
            {
               this.collectPlanesNode(param1.negative,param2,param3);
            }
         }
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:BSP = new BSP();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         var _loc3_:Vertex = null;
         var _loc4_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc9_:Face = null;
         var _loc10_:Face = null;
         var _loc11_:Wrapper = null;
         var _loc12_:Wrapper = null;
         var _loc13_:Wrapper = null;
         super.clonePropertiesFrom(param1);
         var _loc2_:BSP = param1 as BSP;
         this.clipping = _loc2_.clipping;
         this.threshold = _loc2_.threshold;
         this.splitAnalysis = _loc2_.splitAnalysis;
         _loc3_ = _loc2_.vertexList;
         while(_loc3_ != null)
         {
            _loc8_ = new Vertex();
            _loc8_.x = _loc3_.x;
            _loc8_.y = _loc3_.y;
            _loc8_.z = _loc3_.z;
            _loc8_.u = _loc3_.u;
            _loc8_.v = _loc3_.v;
            _loc8_.normalX = _loc3_.normalX;
            _loc8_.normalY = _loc3_.normalY;
            _loc8_.normalZ = _loc3_.normalZ;
            _loc3_.value = _loc8_;
            if(_loc4_ != null)
            {
               _loc4_.next = _loc8_;
            }
            else
            {
               this.vertexList = _loc8_;
            }
            _loc4_ = _loc8_;
            _loc3_ = _loc3_.next;
         }
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:int = _loc2_.faces.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = _loc2_.faces[_loc7_];
            _loc10_ = new Face();
            _loc10_.material = _loc9_.material;
            _loc10_.smoothingGroups = _loc9_.smoothingGroups;
            _loc10_.normalX = _loc9_.normalX;
            _loc10_.normalY = _loc9_.normalY;
            _loc10_.normalZ = _loc9_.normalZ;
            _loc10_.offset = _loc9_.offset;
            _loc11_ = null;
            _loc12_ = _loc9_.wrapper;
            while(_loc12_ != null)
            {
               _loc13_ = new Wrapper();
               _loc13_.vertex = _loc12_.vertex.value;
               if(_loc11_ != null)
               {
                  _loc11_.next = _loc13_;
               }
               else
               {
                  _loc10_.wrapper = _loc13_;
               }
               _loc11_ = _loc13_;
               _loc12_ = _loc12_.next;
            }
            this.faces[_loc7_] = _loc10_;
            _loc5_[_loc9_] = _loc10_;
            _loc7_++;
         }
         if(_loc2_.root != null)
         {
            this.root = _loc2_.cloneNode(_loc2_.root,_loc5_);
         }
         _loc3_ = _loc2_.vertexList;
         while(_loc3_ != null)
         {
            _loc3_.value = null;
            _loc3_ = _loc3_.next;
         }
      }
      
      private function cloneNode(param1:Node, param2:Dictionary) : Node
      {
         var _loc4_:Face = null;
         var _loc6_:Face = null;
         var _loc7_:Wrapper = null;
         var _loc8_:Wrapper = null;
         var _loc9_:Wrapper = null;
         var _loc3_:Node = new Node();
         var _loc5_:Face = param1.faceList;
         while(_loc5_ != null)
         {
            _loc6_ = param2[_loc5_];
            if(_loc6_ == null)
            {
               _loc6_ = new Face();
               _loc6_.material = _loc5_.material;
               _loc6_.normalX = _loc5_.normalX;
               _loc6_.normalY = _loc5_.normalY;
               _loc6_.normalZ = _loc5_.normalZ;
               _loc6_.offset = _loc5_.offset;
               _loc7_ = null;
               _loc8_ = _loc5_.wrapper;
               while(_loc8_ != null)
               {
                  _loc9_ = new Wrapper();
                  _loc9_.vertex = _loc8_.vertex.value;
                  if(_loc7_ != null)
                  {
                     _loc7_.next = _loc9_;
                  }
                  else
                  {
                     _loc6_.wrapper = _loc9_;
                  }
                  _loc7_ = _loc9_;
                  _loc8_ = _loc8_.next;
               }
            }
            if(_loc3_.faceList != null)
            {
               _loc4_.next = _loc6_;
            }
            else
            {
               _loc3_.faceList = _loc6_;
            }
            _loc4_ = _loc6_;
            _loc5_ = _loc5_.next;
         }
         _loc3_.normalX = param1.normalX;
         _loc3_.normalY = param1.normalY;
         _loc3_.normalZ = param1.normalZ;
         _loc3_.offset = param1.offset;
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
      
      private function setMaterialToNode(param1:Node, param2:Material) : void
      {
         var _loc3_:Face = param1.faceList;
         while(_loc3_ != null)
         {
            _loc3_.material = param2;
            _loc3_ = _loc3_.next;
         }
         if(param1.negative != null)
         {
            this.setMaterialToNode(param1.negative,param2);
         }
         if(param1.positive != null)
         {
            this.setMaterialToNode(param1.positive,param2);
         }
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         var _loc4_:Face = null;
         var _loc5_:Face = null;
         var _loc6_:Face = null;
         var _loc7_:Face = null;
         var _loc8_:Vertex = null;
         if(this.root == null)
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
         var _loc2_:int = !!param1.debug?int(int(param1.checkInDebug(this))):int(int(0));
         var _loc3_:Face = this.faces[0];
         if(concatenatedAlpha >= 1 && concatenatedBlendMode == "normal" && _loc3_.material != null && (!_loc3_.material.transparent || _loc3_.material.alphaTestThreshold > 0))
         {
            param1.addOpaque(_loc3_.material,this.vertexBuffer,this.indexBuffer,0,this.numTriangles,this);
            if(_loc2_ > 0)
            {
               if(_loc2_ & Debug.EDGES)
               {
                  Debug.drawEdges(param1,null,16777215);
               }
               if(_loc2_ & Debug.BOUNDS)
               {
                  Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
         }
         else
         {
            if(transformId > 500000000)
            {
               transformId = 0;
               _loc8_ = this.vertexList;
               while(_loc8_ != null)
               {
                  _loc8_.transformId = 0;
                  _loc8_ = _loc8_.next;
               }
            }
            transformId++;
            calculateInverseMatrix();
            _loc4_ = this.collectNode(this.root);
            if(_loc4_ == null)
            {
               return;
            }
            if(culling > 0)
            {
               if(this.clipping == 1)
               {
                  _loc4_ = param1.cull(_loc4_,culling);
               }
               else
               {
                  _loc4_ = param1.clip(_loc4_,culling);
               }
               if(_loc4_ == null)
               {
                  return;
               }
            }
            if(_loc2_ > 0)
            {
               if(_loc2_ & Debug.EDGES)
               {
                  Debug.drawEdges(param1,_loc4_,16777215);
               }
               if(_loc2_ & Debug.BOUNDS)
               {
                  Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            _loc7_ = _loc4_;
            while(_loc7_ != null)
            {
               _loc5_ = _loc7_.processNext;
               if(_loc5_ == null || _loc5_.material != _loc4_.material)
               {
                  _loc7_.processNext = null;
                  if(_loc4_.material != null)
                  {
                     _loc4_.processNegative = _loc6_;
                     _loc6_ = _loc4_;
                  }
                  else
                  {
                     while(_loc4_ != null)
                     {
                        _loc7_ = _loc4_.processNext;
                        _loc4_.processNext = null;
                        _loc4_ = _loc7_;
                     }
                  }
                  _loc4_ = _loc5_;
               }
               _loc7_ = _loc5_;
            }
            _loc4_ = _loc6_;
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_.processNegative;
               _loc4_.processNegative = null;
               param1.addTransparent(_loc4_,this);
               _loc4_ = _loc5_;
            }
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
      }
      
      override alternativa3d function getVG(param1:Camera3D) : VG
      {
         var _loc4_:Face = null;
         var _loc5_:Vertex = null;
         if(this.root == null)
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
         var _loc2_:int = !!param1.debug?int(int(param1.checkInDebug(this))):int(int(0));
         var _loc3_:Face = this.faces[0];
         if(concatenatedAlpha >= 1 && concatenatedBlendMode == "normal" && _loc3_.material != null && (!_loc3_.material.transparent || _loc3_.material.alphaTestThreshold > 0))
         {
            param1.addOpaque(_loc3_.material,this.vertexBuffer,this.indexBuffer,0,this.numTriangles,this);
            if(_loc2_ > 0)
            {
               if(_loc2_ & Debug.EDGES)
               {
                  Debug.drawEdges(param1,null,16777215);
               }
               if(_loc2_ & Debug.BOUNDS)
               {
                  Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
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
            return null;
         }
         if(transformId > 500000000)
         {
            transformId = 0;
            _loc5_ = this.vertexList;
            while(_loc5_ != null)
            {
               _loc5_.transformId = 0;
               _loc5_ = _loc5_.next;
            }
         }
         transformId++;
         calculateInverseMatrix();
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
         _loc4_ = this.prepareNode(this.root,culling,param1);
         if(_loc4_ != null)
         {
            return VG.create(this,_loc4_,3,_loc2_,false);
         }
         return null;
      }
      
      alternativa3d function prepareResources() : void
      {
         var _loc1_:Vector.<Number> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vertex = null;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:int = 0;
         var _loc7_:Face = null;
         var _loc8_:Wrapper = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
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
            this.vertexBuffer = new VertexBufferResource(_loc1_,8);
            _loc5_ = new Vector.<uint>();
            _loc6_ = 0;
            this.numTriangles = 0;
            for each(_loc7_ in this.faces)
            {
               _loc8_ = _loc7_.wrapper;
               _loc9_ = _loc8_.vertex.index;
               _loc8_ = _loc8_.next;
               _loc10_ = _loc8_.vertex.index;
               _loc8_ = _loc8_.next;
               while(_loc8_ != null)
               {
                  _loc11_ = _loc8_.vertex.index;
                  _loc5_[_loc6_] = _loc9_;
                  _loc6_++;
                  _loc5_[_loc6_] = _loc10_;
                  _loc6_++;
                  _loc5_[_loc6_] = _loc11_;
                  _loc6_++;
                  _loc10_ = _loc11_;
                  this.numTriangles++;
                  _loc8_ = _loc8_.next;
               }
            }
            this.indexBuffer = new IndexBufferResource(_loc5_);
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
         }
      }
      
      private function collectNode(param1:Node, param2:Face = null) : Face
      {
         var _loc3_:Face = null;
         var _loc4_:Wrapper = null;
         var _loc5_:Vertex = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param1.normalX * imd + param1.normalY * imh + param1.normalZ * iml > param1.offset)
         {
            if(param1.positive != null)
            {
               param2 = this.collectNode(param1.positive,param2);
            }
            _loc3_ = param1.faceList;
            while(_loc3_ != null)
            {
               _loc4_ = _loc3_.wrapper;
               while(_loc4_ != null)
               {
                  _loc5_ = _loc4_.vertex;
                  if(_loc5_.transformId != transformId)
                  {
                     _loc6_ = _loc5_.x;
                     _loc7_ = _loc5_.y;
                     _loc8_ = _loc5_.z;
                     _loc5_.cameraX = ma * _loc6_ + mb * _loc7_ + mc * _loc8_ + md;
                     _loc5_.cameraY = me * _loc6_ + mf * _loc7_ + mg * _loc8_ + mh;
                     _loc5_.cameraZ = mi * _loc6_ + mj * _loc7_ + mk * _loc8_ + ml;
                     _loc5_.transformId = transformId;
                     _loc5_.drawId = 0;
                  }
                  _loc4_ = _loc4_.next;
               }
               _loc3_.processNext = param2;
               param2 = _loc3_;
               _loc3_ = _loc3_.next;
            }
            if(param1.negative != null)
            {
               param2 = this.collectNode(param1.negative,param2);
            }
         }
         else
         {
            if(param1.negative != null)
            {
               param2 = this.collectNode(param1.negative,param2);
            }
            if(param1.positive != null)
            {
               param2 = this.collectNode(param1.positive,param2);
            }
         }
         return param2;
      }
      
      private function prepareNode(param1:Node, param2:int, param3:Camera3D) : Face
      {
         var _loc4_:Face = null;
         var _loc5_:Wrapper = null;
         var _loc8_:Face = null;
         var _loc9_:Vertex = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Vertex = null;
         var _loc14_:Vertex = null;
         var _loc15_:Vertex = null;
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
         if(imd * param1.normalX + imh * param1.normalY + iml * param1.normalZ > param1.offset)
         {
            _loc4_ = param1.faceList;
            _loc8_ = _loc4_;
            while(_loc8_ != null)
            {
               _loc5_ = _loc8_.wrapper;
               while(_loc5_ != null)
               {
                  _loc9_ = _loc5_.vertex;
                  if(_loc9_.transformId != transformId)
                  {
                     _loc10_ = _loc9_.x;
                     _loc11_ = _loc9_.y;
                     _loc12_ = _loc9_.z;
                     _loc9_.cameraX = ma * _loc10_ + mb * _loc11_ + mc * _loc12_ + md;
                     _loc9_.cameraY = me * _loc10_ + mf * _loc11_ + mg * _loc12_ + mh;
                     _loc9_.cameraZ = mi * _loc10_ + mj * _loc11_ + mk * _loc12_ + ml;
                     _loc9_.transformId = transformId;
                     _loc9_.drawId = 0;
                  }
                  _loc5_ = _loc5_.next;
               }
               _loc8_.processNext = _loc8_.next;
               _loc8_ = _loc8_.next;
            }
            if(param2 > 0)
            {
               if(this.clipping == 1)
               {
                  _loc4_ = param3.cull(_loc4_,param2);
               }
               else
               {
                  _loc4_ = param3.clip(_loc4_,param2);
               }
            }
         }
         var _loc6_:Face = param1.negative != null?this.prepareNode(param1.negative,param2,param3):null;
         var _loc7_:Face = param1.positive != null?this.prepareNode(param1.positive,param2,param3):null;
         if(_loc4_ != null || _loc6_ != null && _loc7_ != null)
         {
            if(_loc4_ == null)
            {
               _loc4_ = param1.faceList.create();
               param3.lastFace.next = _loc4_;
               param3.lastFace = _loc4_;
            }
            _loc5_ = param1.faceList.wrapper;
            _loc13_ = _loc5_.vertex;
            _loc5_ = _loc5_.next;
            _loc14_ = _loc5_.vertex;
            _loc5_ = _loc5_.next;
            _loc15_ = _loc5_.vertex;
            if(_loc13_.transformId != transformId)
            {
               _loc13_.cameraX = ma * _loc13_.x + mb * _loc13_.y + mc * _loc13_.z + md;
               _loc13_.cameraY = me * _loc13_.x + mf * _loc13_.y + mg * _loc13_.z + mh;
               _loc13_.cameraZ = mi * _loc13_.x + mj * _loc13_.y + mk * _loc13_.z + ml;
               _loc13_.transformId = transformId;
               _loc13_.drawId = 0;
            }
            if(_loc14_.transformId != transformId)
            {
               _loc14_.cameraX = ma * _loc14_.x + mb * _loc14_.y + mc * _loc14_.z + md;
               _loc14_.cameraY = me * _loc14_.x + mf * _loc14_.y + mg * _loc14_.z + mh;
               _loc14_.cameraZ = mi * _loc14_.x + mj * _loc14_.y + mk * _loc14_.z + ml;
               _loc14_.transformId = transformId;
               _loc14_.drawId = 0;
            }
            if(_loc15_.transformId != transformId)
            {
               _loc15_.cameraX = ma * _loc15_.x + mb * _loc15_.y + mc * _loc15_.z + md;
               _loc15_.cameraY = me * _loc15_.x + mf * _loc15_.y + mg * _loc15_.z + mh;
               _loc15_.cameraZ = mi * _loc15_.x + mj * _loc15_.y + mk * _loc15_.z + ml;
               _loc15_.transformId = transformId;
               _loc15_.drawId = 0;
            }
            _loc16_ = _loc14_.cameraX - _loc13_.cameraX;
            _loc17_ = _loc14_.cameraY - _loc13_.cameraY;
            _loc18_ = _loc14_.cameraZ - _loc13_.cameraZ;
            _loc19_ = _loc15_.cameraX - _loc13_.cameraX;
            _loc20_ = _loc15_.cameraY - _loc13_.cameraY;
            _loc21_ = _loc15_.cameraZ - _loc13_.cameraZ;
            _loc22_ = _loc21_ * _loc17_ - _loc20_ * _loc18_;
            _loc23_ = _loc19_ * _loc18_ - _loc21_ * _loc16_;
            _loc24_ = _loc20_ * _loc16_ - _loc19_ * _loc17_;
            _loc25_ = _loc22_ * _loc22_ + _loc23_ * _loc23_ + _loc24_ * _loc24_;
            if(_loc25_ > 0)
            {
               _loc25_ = 1 / Math.sqrt(length);
               _loc22_ = _loc22_ * _loc25_;
               _loc23_ = _loc23_ * _loc25_;
               _loc24_ = _loc24_ * _loc25_;
            }
            _loc4_.normalX = _loc22_;
            _loc4_.normalY = _loc23_;
            _loc4_.normalZ = _loc24_;
            _loc4_.offset = _loc13_.cameraX * _loc22_ + _loc13_.cameraY * _loc23_ + _loc13_.cameraZ * _loc24_;
            _loc4_.processNegative = _loc6_;
            _loc4_.processPositive = _loc7_;
         }
         else
         {
            _loc4_ = _loc6_ != null?_loc6_:_loc7_;
         }
         return _loc4_;
      }
      
      override alternativa3d function updateBounds(param1:Object3D, param2:Object3D = null) : void
      {
         var _loc3_:Vertex = this.vertexList;
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
         var _loc9_:Vertex = null;
         var _loc10_:Vertex = null;
         var _loc14_:Face = null;
         var _loc15_:Face = null;
         var _loc16_:Face = null;
         var _loc17_:Face = null;
         var _loc22_:Face = null;
         var _loc23_:Face = null;
         var _loc24_:Wrapper = null;
         var _loc25_:Vertex = null;
         var _loc26_:Vertex = null;
         var _loc27_:Vertex = null;
         var _loc28_:Boolean = false;
         var _loc29_:Boolean = false;
         var _loc30_:Face = null;
         var _loc31_:Face = null;
         var _loc32_:Wrapper = null;
         var _loc33_:Wrapper = null;
         var _loc34_:Wrapper = null;
         var _loc35_:Number = NaN;
         var _loc36_:Vertex = null;
         var _loc5_:Vector.<Object3D> = new Vector.<Object3D>(2);
         var _loc6_:Vector3D = calculatePlane(param1,param2,param3);
         var _loc7_:Number = _loc6_.w - param4;
         var _loc8_:Number = _loc6_.w + param4;
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
         if(this.root != null)
         {
            this.destroyNode(this.root);
            this.root = null;
         }
         var _loc11_:Vector.<Face> = this.faces;
         this.faces = new Vector.<Face>();
         var _loc12_:BSP = this.clone() as BSP;
         var _loc13_:BSP = this.clone() as BSP;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = _loc11_.length;
         var _loc21_:int = 0;
         while(_loc21_ < _loc20_)
         {
            _loc22_ = _loc11_[_loc21_];
            _loc23_ = _loc22_.next;
            _loc24_ = _loc22_.wrapper;
            _loc25_ = _loc24_.vertex;
            _loc24_ = _loc24_.next;
            _loc26_ = _loc24_.vertex;
            _loc24_ = _loc24_.next;
            _loc27_ = _loc24_.vertex;
            _loc28_ = _loc25_.offset < _loc7_ || _loc26_.offset < _loc7_ || _loc27_.offset < _loc7_;
            _loc29_ = _loc25_.offset > _loc8_ || _loc26_.offset > _loc8_ || _loc27_.offset > _loc8_;
            _loc24_ = _loc24_.next;
            while(_loc24_ != null)
            {
               _loc9_ = _loc24_.vertex;
               if(_loc9_.offset < _loc7_)
               {
                  _loc28_ = true;
               }
               else if(_loc9_.offset > _loc8_)
               {
                  _loc29_ = true;
               }
               _loc24_ = _loc24_.next;
            }
            if(!_loc28_)
            {
               if(_loc17_ != null)
               {
                  _loc17_.next = _loc22_;
               }
               else
               {
                  _loc16_ = _loc22_;
               }
               _loc17_ = _loc22_;
               _loc13_.faces[_loc19_] = _loc22_;
               _loc19_++;
            }
            else if(!_loc29_)
            {
               if(_loc15_ != null)
               {
                  _loc15_.next = _loc22_;
               }
               else
               {
                  _loc14_ = _loc22_;
               }
               _loc15_ = _loc22_;
               _loc12_.faces[_loc18_] = _loc22_;
               _loc18_++;
               _loc24_ = _loc22_.wrapper;
               while(_loc24_ != null)
               {
                  if(_loc24_.vertex.value != null)
                  {
                     _loc24_.vertex = _loc24_.vertex.value;
                  }
                  _loc24_ = _loc24_.next;
               }
            }
            else
            {
               _loc30_ = new Face();
               _loc31_ = new Face();
               _loc32_ = null;
               _loc33_ = null;
               _loc24_ = _loc22_.wrapper.next.next;
               while(_loc24_.next != null)
               {
                  _loc24_ = _loc24_.next;
               }
               _loc25_ = _loc24_.vertex;
               _loc24_ = _loc22_.wrapper;
               while(_loc24_ != null)
               {
                  _loc26_ = _loc24_.vertex;
                  if(_loc25_.offset < _loc7_ && _loc26_.offset > _loc8_ || _loc25_.offset > _loc8_ && _loc26_.offset < _loc7_)
                  {
                     _loc35_ = (_loc6_.w - _loc25_.offset) / (_loc26_.offset - _loc25_.offset);
                     _loc9_ = new Vertex();
                     _loc9_.x = _loc25_.x + (_loc26_.x - _loc25_.x) * _loc35_;
                     _loc9_.y = _loc25_.y + (_loc26_.y - _loc25_.y) * _loc35_;
                     _loc9_.z = _loc25_.z + (_loc26_.z - _loc25_.z) * _loc35_;
                     _loc9_.u = _loc25_.u + (_loc26_.u - _loc25_.u) * _loc35_;
                     _loc9_.v = _loc25_.v + (_loc26_.v - _loc25_.v) * _loc35_;
                     _loc9_.normalX = _loc25_.normalX + (_loc26_.normalX - _loc25_.normalX) * _loc35_;
                     _loc9_.normalY = _loc25_.normalY + (_loc26_.normalY - _loc25_.normalY) * _loc35_;
                     _loc9_.normalZ = _loc25_.normalZ + (_loc26_.normalZ - _loc25_.normalZ) * _loc35_;
                     _loc34_ = new Wrapper();
                     _loc34_.vertex = _loc9_;
                     if(_loc32_ != null)
                     {
                        _loc32_.next = _loc34_;
                     }
                     else
                     {
                        _loc30_.wrapper = _loc34_;
                     }
                     _loc32_ = _loc34_;
                     _loc36_ = new Vertex();
                     _loc36_.x = _loc9_.x;
                     _loc36_.y = _loc9_.y;
                     _loc36_.z = _loc9_.z;
                     _loc36_.u = _loc9_.u;
                     _loc36_.v = _loc9_.v;
                     _loc36_.normalX = _loc9_.normalX;
                     _loc36_.normalY = _loc9_.normalY;
                     _loc36_.normalZ = _loc9_.normalZ;
                     _loc34_ = new Wrapper();
                     _loc34_.vertex = _loc36_;
                     if(_loc33_ != null)
                     {
                        _loc33_.next = _loc34_;
                     }
                     else
                     {
                        _loc31_.wrapper = _loc34_;
                     }
                     _loc33_ = _loc34_;
                  }
                  if(_loc26_.offset < _loc7_)
                  {
                     _loc34_ = _loc24_.create();
                     _loc34_.vertex = _loc26_;
                     if(_loc32_ != null)
                     {
                        _loc32_.next = _loc34_;
                     }
                     else
                     {
                        _loc30_.wrapper = _loc34_;
                     }
                     _loc32_ = _loc34_;
                  }
                  else if(_loc26_.offset > _loc8_)
                  {
                     _loc34_ = _loc24_.create();
                     _loc34_.vertex = _loc26_;
                     if(_loc33_ != null)
                     {
                        _loc33_.next = _loc34_;
                     }
                     else
                     {
                        _loc31_.wrapper = _loc34_;
                     }
                     _loc33_ = _loc34_;
                  }
                  else
                  {
                     _loc34_ = _loc24_.create();
                     _loc34_.vertex = _loc26_.value;
                     if(_loc32_ != null)
                     {
                        _loc32_.next = _loc34_;
                     }
                     else
                     {
                        _loc30_.wrapper = _loc34_;
                     }
                     _loc32_ = _loc34_;
                     _loc34_ = _loc24_.create();
                     _loc34_.vertex = _loc26_;
                     if(_loc33_ != null)
                     {
                        _loc33_.next = _loc34_;
                     }
                     else
                     {
                        _loc31_.wrapper = _loc34_;
                     }
                     _loc33_ = _loc34_;
                  }
                  _loc25_ = _loc26_;
                  _loc24_ = _loc24_.next;
               }
               _loc30_.material = _loc22_.material;
               _loc30_.calculateBestSequenceAndNormal();
               if(_loc15_ != null)
               {
                  _loc15_.next = _loc30_;
               }
               else
               {
                  _loc14_ = _loc30_;
               }
               _loc15_ = _loc30_;
               _loc12_.faces[_loc18_] = _loc30_;
               _loc18_++;
               _loc31_.material = _loc22_.material;
               _loc31_.calculateBestSequenceAndNormal();
               if(_loc17_ != null)
               {
                  _loc17_.next = _loc31_;
               }
               else
               {
                  _loc16_ = _loc31_;
               }
               _loc17_ = _loc31_;
               _loc13_.faces[_loc19_] = _loc31_;
               _loc19_++;
            }
            _loc21_++;
         }
         if(_loc15_ != null)
         {
            _loc15_.next = null;
            _loc12_.transformId++;
            _loc12_.collectVertices();
            _loc12_.root = _loc12_.createNode(_loc14_);
            _loc12_.calculateBounds();
            _loc5_[0] = _loc12_;
         }
         if(_loc17_ != null)
         {
            _loc17_.next = null;
            _loc13_.transformId++;
            _loc13_.collectVertices();
            _loc13_.root = _loc13_.createNode(_loc16_);
            _loc13_.calculateBounds();
            _loc5_[1] = _loc13_;
         }
         return _loc5_;
      }
      
      private function collectVertices() : void
      {
         var _loc3_:Face = null;
         var _loc4_:Wrapper = null;
         var _loc5_:Vertex = null;
         var _loc1_:int = this.faces.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.faces[_loc2_];
            _loc4_ = _loc3_.wrapper;
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_.vertex;
               if(_loc5_.transformId != transformId)
               {
                  _loc5_.next = this.vertexList;
                  this.vertexList = _loc5_;
                  _loc5_.transformId = transformId;
                  _loc5_.value = null;
               }
               _loc4_ = _loc4_.next;
            }
            _loc2_++;
         }
      }
      
      private function createNode(param1:Face) : Node
      {
         var _loc3_:Wrapper = null;
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Vertex = null;
         var _loc7_:Vertex = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc21_:Face = null;
         var _loc22_:Face = null;
         var _loc25_:Face = null;
         var _loc26_:Face = null;
         var _loc27_:int = 0;
         var _loc28_:Face = null;
         var _loc29_:int = 0;
         var _loc30_:Face = null;
         var _loc31_:Face = null;
         var _loc32_:Face = null;
         var _loc33_:Face = null;
         var _loc34_:Wrapper = null;
         var _loc35_:Wrapper = null;
         var _loc36_:Wrapper = null;
         var _loc37_:Number = NaN;
         var _loc2_:Node = new Node();
         var _loc20_:Face = param1;
         if(this.splitAnalysis && param1.next != null)
         {
            _loc27_ = 2147483647;
            _loc28_ = param1;
            while(_loc28_ != null)
            {
               _loc14_ = _loc28_.normalX;
               _loc15_ = _loc28_.normalY;
               _loc16_ = _loc28_.normalZ;
               _loc17_ = _loc28_.offset;
               _loc18_ = _loc17_ - this.threshold;
               _loc19_ = _loc17_ + this.threshold;
               _loc29_ = 0;
               _loc30_ = param1;
               while(_loc30_ != null)
               {
                  if(_loc30_ != _loc28_)
                  {
                     _loc3_ = _loc30_.wrapper;
                     _loc4_ = _loc3_.vertex;
                     _loc3_ = _loc3_.next;
                     _loc5_ = _loc3_.vertex;
                     _loc3_ = _loc3_.next;
                     _loc6_ = _loc3_.vertex;
                     _loc3_ = _loc3_.next;
                     _loc10_ = _loc4_.x * _loc14_ + _loc4_.y * _loc15_ + _loc4_.z * _loc16_;
                     _loc11_ = _loc5_.x * _loc14_ + _loc5_.y * _loc15_ + _loc5_.z * _loc16_;
                     _loc12_ = _loc6_.x * _loc14_ + _loc6_.y * _loc15_ + _loc6_.z * _loc16_;
                     _loc8_ = _loc10_ < _loc18_ || _loc11_ < _loc18_ || _loc12_ < _loc18_;
                     _loc9_ = _loc10_ > _loc19_ || _loc11_ > _loc19_ || _loc12_ > _loc19_;
                     while(_loc3_ != null)
                     {
                        _loc7_ = _loc3_.vertex;
                        _loc13_ = _loc7_.x * _loc14_ + _loc7_.y * _loc15_ + _loc7_.z * _loc16_;
                        if(_loc13_ < _loc18_)
                        {
                           _loc8_ = true;
                           if(_loc9_)
                           {
                              break;
                           }
                        }
                        else if(_loc13_ > _loc19_)
                        {
                           _loc9_ = true;
                           if(_loc8_)
                           {
                              break;
                           }
                        }
                        _loc3_ = _loc3_.next;
                     }
                     if(_loc9_ && _loc8_)
                     {
                        _loc29_++;
                        if(_loc29_ >= _loc27_)
                        {
                           break;
                        }
                     }
                  }
                  _loc30_ = _loc30_.next;
               }
               if(_loc29_ < _loc27_)
               {
                  _loc20_ = _loc28_;
                  _loc27_ = _loc29_;
                  if(_loc27_ == 0)
                  {
                     break;
                  }
               }
               _loc28_ = _loc28_.next;
            }
         }
         var _loc23_:Face = _loc20_;
         var _loc24_:Face = _loc20_.next;
         _loc14_ = _loc20_.normalX;
         _loc15_ = _loc20_.normalY;
         _loc16_ = _loc20_.normalZ;
         _loc17_ = _loc20_.offset;
         _loc18_ = _loc17_ - this.threshold;
         _loc19_ = _loc17_ + this.threshold;
         while(param1 != null)
         {
            if(param1 != _loc20_)
            {
               _loc31_ = param1.next;
               _loc3_ = param1.wrapper;
               _loc4_ = _loc3_.vertex;
               _loc3_ = _loc3_.next;
               _loc5_ = _loc3_.vertex;
               _loc3_ = _loc3_.next;
               _loc6_ = _loc3_.vertex;
               _loc3_ = _loc3_.next;
               _loc10_ = _loc4_.x * _loc14_ + _loc4_.y * _loc15_ + _loc4_.z * _loc16_;
               _loc11_ = _loc5_.x * _loc14_ + _loc5_.y * _loc15_ + _loc5_.z * _loc16_;
               _loc12_ = _loc6_.x * _loc14_ + _loc6_.y * _loc15_ + _loc6_.z * _loc16_;
               _loc8_ = _loc10_ < _loc18_ || _loc11_ < _loc18_ || _loc12_ < _loc18_;
               _loc9_ = _loc10_ > _loc19_ || _loc11_ > _loc19_ || _loc12_ > _loc19_;
               while(_loc3_ != null)
               {
                  _loc7_ = _loc3_.vertex;
                  _loc13_ = _loc7_.x * _loc14_ + _loc7_.y * _loc15_ + _loc7_.z * _loc16_;
                  if(_loc13_ < _loc18_)
                  {
                     _loc8_ = true;
                  }
                  else if(_loc13_ > _loc19_)
                  {
                     _loc9_ = true;
                  }
                  _loc7_.offset = _loc13_;
                  _loc3_ = _loc3_.next;
               }
               if(!_loc8_)
               {
                  if(!_loc9_)
                  {
                     if(param1.normalX * _loc14_ + param1.normalY * _loc15_ + param1.normalZ * _loc16_ > 0)
                     {
                        _loc23_.next = param1;
                        _loc23_ = param1;
                     }
                     else
                     {
                        if(_loc21_ != null)
                        {
                           _loc22_.next = param1;
                        }
                        else
                        {
                           _loc21_ = param1;
                        }
                        _loc22_ = param1;
                     }
                  }
                  else
                  {
                     if(_loc25_ != null)
                     {
                        _loc26_.next = param1;
                     }
                     else
                     {
                        _loc25_ = param1;
                     }
                     _loc26_ = param1;
                  }
               }
               else if(!_loc9_)
               {
                  if(_loc21_ != null)
                  {
                     _loc22_.next = param1;
                  }
                  else
                  {
                     _loc21_ = param1;
                  }
                  _loc22_ = param1;
               }
               else
               {
                  _loc4_.offset = _loc10_;
                  _loc5_.offset = _loc11_;
                  _loc6_.offset = _loc12_;
                  _loc32_ = new Face();
                  _loc33_ = new Face();
                  _loc34_ = null;
                  _loc35_ = null;
                  _loc3_ = param1.wrapper.next.next;
                  while(_loc3_.next != null)
                  {
                     _loc3_ = _loc3_.next;
                  }
                  _loc4_ = _loc3_.vertex;
                  _loc10_ = _loc4_.offset;
                  _loc3_ = param1.wrapper;
                  while(_loc3_ != null)
                  {
                     _loc5_ = _loc3_.vertex;
                     _loc11_ = _loc5_.offset;
                     if(_loc10_ < _loc18_ && _loc11_ > _loc19_ || _loc10_ > _loc19_ && _loc11_ < _loc18_)
                     {
                        _loc37_ = (_loc17_ - _loc10_) / (_loc11_ - _loc10_);
                        _loc7_ = new Vertex();
                        _loc7_.next = this.vertexList;
                        this.vertexList = _loc7_;
                        _loc7_.x = _loc4_.x + (_loc5_.x - _loc4_.x) * _loc37_;
                        _loc7_.y = _loc4_.y + (_loc5_.y - _loc4_.y) * _loc37_;
                        _loc7_.z = _loc4_.z + (_loc5_.z - _loc4_.z) * _loc37_;
                        _loc7_.u = _loc4_.u + (_loc5_.u - _loc4_.u) * _loc37_;
                        _loc7_.v = _loc4_.v + (_loc5_.v - _loc4_.v) * _loc37_;
                        _loc7_.normalX = _loc4_.normalX + (_loc5_.normalX - _loc4_.normalX) * _loc37_;
                        _loc7_.normalY = _loc4_.normalY + (_loc5_.normalY - _loc4_.normalY) * _loc37_;
                        _loc7_.normalZ = _loc4_.normalZ + (_loc5_.normalZ - _loc4_.normalZ) * _loc37_;
                        _loc36_ = new Wrapper();
                        _loc36_.vertex = _loc7_;
                        if(_loc34_ != null)
                        {
                           _loc34_.next = _loc36_;
                        }
                        else
                        {
                           _loc32_.wrapper = _loc36_;
                        }
                        _loc34_ = _loc36_;
                        _loc36_ = new Wrapper();
                        _loc36_.vertex = _loc7_;
                        if(_loc35_ != null)
                        {
                           _loc35_.next = _loc36_;
                        }
                        else
                        {
                           _loc33_.wrapper = _loc36_;
                        }
                        _loc35_ = _loc36_;
                     }
                     if(_loc11_ <= _loc19_)
                     {
                        _loc36_ = new Wrapper();
                        _loc36_.vertex = _loc5_;
                        if(_loc34_ != null)
                        {
                           _loc34_.next = _loc36_;
                        }
                        else
                        {
                           _loc32_.wrapper = _loc36_;
                        }
                        _loc34_ = _loc36_;
                     }
                     if(_loc11_ >= _loc18_)
                     {
                        _loc36_ = new Wrapper();
                        _loc36_.vertex = _loc5_;
                        if(_loc35_ != null)
                        {
                           _loc35_.next = _loc36_;
                        }
                        else
                        {
                           _loc33_.wrapper = _loc36_;
                        }
                        _loc35_ = _loc36_;
                     }
                     _loc4_ = _loc5_;
                     _loc10_ = _loc11_;
                     _loc3_ = _loc3_.next;
                  }
                  _loc32_.material = param1.material;
                  _loc32_.smoothingGroups = param1.smoothingGroups;
                  _loc32_.calculateBestSequenceAndNormal();
                  if(_loc21_ != null)
                  {
                     _loc22_.next = _loc32_;
                  }
                  else
                  {
                     _loc21_ = _loc32_;
                  }
                  _loc22_ = _loc32_;
                  _loc33_.material = param1.material;
                  _loc33_.smoothingGroups = param1.smoothingGroups;
                  _loc33_.calculateBestSequenceAndNormal();
                  if(_loc25_ != null)
                  {
                     _loc26_.next = _loc33_;
                  }
                  else
                  {
                     _loc25_ = _loc33_;
                  }
                  _loc26_ = _loc33_;
               }
               param1 = _loc31_;
            }
            else
            {
               param1 = _loc24_;
            }
         }
         if(_loc21_ != null)
         {
            _loc22_.next = null;
            _loc2_.negative = this.createNode(_loc21_);
         }
         _loc23_.next = null;
         _loc2_.faceList = _loc20_;
         _loc2_.normalX = _loc14_;
         _loc2_.normalY = _loc15_;
         _loc2_.normalZ = _loc16_;
         _loc2_.offset = _loc17_;
         if(_loc25_ != null)
         {
            _loc26_.next = null;
            _loc2_.positive = this.createNode(_loc25_);
         }
         return _loc2_;
      }
      
      private function destroyNode(param1:Node) : void
      {
         var _loc3_:Face = null;
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
         var _loc2_:Face = param1.faceList;
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            _loc2_.next = null;
            _loc2_ = _loc3_;
         }
      }
   }
}

import alternativa.engine3d.core.Face;

class Node
{
    
   
   public var negative:Node;
   
   public var positive:Node;
   
   public var faceList:Face;
   
   public var normalX:Number;
   
   public var normalY:Number;
   
   public var normalZ:Number;
   
   public var offset:Number;
   
   function Node()
   {
      super();
   }
}
