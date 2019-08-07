package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class SkyBox extends Mesh
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const BACK:String = "back";
      
      public static const FRONT:String = "front";
      
      public static const BOTTOM:String = "bottom";
      
      public static const TOP:String = "top";
       
      
      private var leftFace:Face;
      
      private var rightFace:Face;
      
      private var backFace:Face;
      
      private var frontFace:Face;
      
      private var bottomFace:Face;
      
      private var topFace:Face;
      
      public var autoSize:Boolean = true;
      
      alternativa3d var reduceConst:Vector.<Number>;
      
      public function SkyBox(param1:Number, param2:Material = null, param3:Material = null, param4:Material = null, param5:Material = null, param6:Material = null, param7:Material = null, param8:Number = 0)
      {
         this.reduceConst = Vector.<Number>([0,0,0,1]);
         super();
         param1 = param1 * 0.5;
         var _loc9_:Vertex = this.createVertex(-param1,-param1,param1,param8,param8);
         var _loc10_:Vertex = this.createVertex(-param1,-param1,-param1,param8,1 - param8);
         var _loc11_:Vertex = this.createVertex(-param1,param1,-param1,1 - param8,1 - param8);
         var _loc12_:Vertex = this.createVertex(-param1,param1,param1,1 - param8,param8);
         this.leftFace = this.createQuad(_loc9_,_loc10_,_loc11_,_loc12_,param2);
         _loc9_ = this.createVertex(param1,param1,param1,param8,param8);
         _loc10_ = this.createVertex(param1,param1,-param1,param8,1 - param8);
         _loc11_ = this.createVertex(param1,-param1,-param1,1 - param8,1 - param8);
         _loc12_ = this.createVertex(param1,-param1,param1,1 - param8,param8);
         this.rightFace = this.createQuad(_loc9_,_loc10_,_loc11_,_loc12_,param3);
         _loc9_ = this.createVertex(param1,-param1,param1,param8,param8);
         _loc10_ = this.createVertex(param1,-param1,-param1,param8,1 - param8);
         _loc11_ = this.createVertex(-param1,-param1,-param1,1 - param8,1 - param8);
         _loc12_ = this.createVertex(-param1,-param1,param1,1 - param8,param8);
         this.backFace = this.createQuad(_loc9_,_loc10_,_loc11_,_loc12_,param4);
         _loc9_ = this.createVertex(-param1,param1,param1,param8,param8);
         _loc10_ = this.createVertex(-param1,param1,-param1,param8,1 - param8);
         _loc11_ = this.createVertex(param1,param1,-param1,1 - param8,1 - param8);
         _loc12_ = this.createVertex(param1,param1,param1,1 - param8,param8);
         this.frontFace = this.createQuad(_loc9_,_loc10_,_loc11_,_loc12_,param5);
         _loc9_ = this.createVertex(-param1,param1,-param1,param8,param8);
         _loc10_ = this.createVertex(-param1,-param1,-param1,param8,1 - param8);
         _loc11_ = this.createVertex(param1,-param1,-param1,1 - param8,1 - param8);
         _loc12_ = this.createVertex(param1,param1,-param1,1 - param8,param8);
         this.bottomFace = this.createQuad(_loc9_,_loc10_,_loc11_,_loc12_,param6);
         _loc9_ = this.createVertex(-param1,-param1,param1,param8,param8);
         _loc10_ = this.createVertex(-param1,param1,param1,param8,1 - param8);
         _loc11_ = this.createVertex(param1,param1,param1,1 - param8,1 - param8);
         _loc12_ = this.createVertex(param1,-param1,param1,1 - param8,param8);
         this.topFace = this.createQuad(_loc9_,_loc10_,_loc11_,_loc12_,param7);
         calculateBounds();
         calculateFacesNormals(true);
         clipping = Clipping.FACE_CLIPPING;
         sorting = Sorting.NONE;
         shadowMapAlphaThreshold = 0.1;
         useLight = true;
      }
      
      public function getSide(param1:String) : Face
      {
         switch(param1)
         {
            case LEFT:
               return this.leftFace;
            case RIGHT:
               return this.rightFace;
            case BACK:
               return this.backFace;
            case FRONT:
               return this.frontFace;
            case BOTTOM:
               return this.bottomFace;
            case TOP:
               return this.topFace;
            default:
               return null;
         }
      }
      
      public function transformUV(param1:String, param2:Matrix) : void
      {
         var _loc4_:Wrapper = null;
         var _loc5_:Vertex = null;
         var _loc6_:Point = null;
         var _loc3_:Face = this.getSide(param1);
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.wrapper;
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_.vertex;
               _loc6_ = param2.transformPoint(new Point(_loc5_.u,_loc5_.v));
               _loc5_.u = _loc6_.x;
               _loc5_.v = _loc6_.y;
               _loc4_ = _loc4_.next;
            }
         }
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:SkyBox = new SkyBox(0);
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         super.clonePropertiesFrom(param1);
         var _loc2_:SkyBox = param1 as SkyBox;
         this.autoSize = _loc2_.autoSize;
         var _loc3_:Face = _loc2_.faceList;
         var _loc4_:Face = faceList;
         while(_loc3_ != null)
         {
            if(_loc3_ == _loc2_.leftFace)
            {
               this.leftFace = _loc4_;
            }
            else if(_loc3_ == _loc2_.rightFace)
            {
               this.rightFace = _loc4_;
            }
            else if(_loc3_ == _loc2_.backFace)
            {
               this.backFace = _loc4_;
            }
            else if(_loc3_ == _loc2_.frontFace)
            {
               this.frontFace = _loc4_;
            }
            else if(_loc3_ == _loc2_.bottomFace)
            {
               this.bottomFace = _loc4_;
            }
            else if(_loc3_ == _loc2_.topFace)
            {
               this.topFace = _loc4_;
            }
            _loc3_ = _loc3_.next;
            _loc4_ = _loc4_.next;
         }
      }
      
      private function createVertex(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Vertex
      {
         var _loc6_:Vertex = new Vertex();
         _loc6_.next = vertexList;
         vertexList = _loc6_;
         _loc6_.x = param1;
         _loc6_.y = param2;
         _loc6_.z = param3;
         _loc6_.u = param4;
         _loc6_.v = param5;
         return _loc6_;
      }
      
      private function createQuad(param1:Vertex, param2:Vertex, param3:Vertex, param4:Vertex, param5:Material) : Face
      {
         var _loc6_:Face = new Face();
         _loc6_.material = param5;
         _loc6_.next = faceList;
         faceList = _loc6_;
         _loc6_.wrapper = new Wrapper();
         _loc6_.wrapper.vertex = param1;
         _loc6_.wrapper.next = new Wrapper();
         _loc6_.wrapper.next.vertex = param2;
         _loc6_.wrapper.next.next = new Wrapper();
         _loc6_.wrapper.next.next.vertex = param3;
         _loc6_.wrapper.next.next.next = new Wrapper();
         _loc6_.wrapper.next.next.next.vertex = param4;
         return _loc6_;
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         if(faceList == null)
         {
            return;
         }
         if(this.autoSize)
         {
            this.calculateTransform(param1);
         }
         if(clipping == 0)
         {
            if(culling & 1)
            {
               return;
            }
            culling = 0;
         }
         this.prepareResources();
         this.addOpaque(param1);
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
         var _loc2_:int = !!param1.debug?int(int(param1.checkInDebug(this))):int(int(0));
         if(_loc2_ & Debug.BOUNDS)
         {
            Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
      }
      
      override alternativa3d function prepareResources() : void
      {
         var _loc1_:Vector.<Number> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vertex = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Face = null;
         var _loc9_:Array = null;
         var _loc10_:Wrapper = null;
         var _loc11_:Dictionary = null;
         var _loc12_:Vector.<uint> = null;
         var _loc13_:int = 0;
         var _loc14_:* = undefined;
         if(vertexBuffer == null)
         {
            _loc1_ = new Vector.<Number>();
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = vertexList;
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
               vertexBuffer = new VertexBufferResource(_loc1_,8);
            }
            _loc11_ = new Dictionary();
            _loc8_ = faceList;
            while(_loc8_ != null)
            {
               if(_loc8_.material != null)
               {
                  _loc9_ = _loc11_[_loc8_.material];
                  if(_loc9_ == null)
                  {
                     _loc9_ = new Array();
                     _loc11_[_loc8_.material] = _loc9_;
                  }
                  _loc9_.push(_loc8_);
               }
               _loc8_ = _loc8_.next;
            }
            _loc12_ = new Vector.<uint>();
            _loc13_ = 0;
            for(_loc14_ in _loc11_)
            {
               _loc9_ = _loc11_[_loc14_];
               opaqueMaterials[opaqueLength] = _loc14_;
               opaqueBegins[opaqueLength] = numTriangles * 3;
               for each(_loc8_ in _loc9_)
               {
                  _loc10_ = _loc8_.wrapper;
                  _loc5_ = _loc10_.vertex.index;
                  _loc10_ = _loc10_.next;
                  _loc6_ = _loc10_.vertex.index;
                  _loc10_ = _loc10_.next;
                  while(_loc10_ != null)
                  {
                     _loc7_ = _loc10_.vertex.index;
                     _loc12_[_loc13_] = _loc5_;
                     _loc13_++;
                     _loc12_[_loc13_] = _loc6_;
                     _loc13_++;
                     _loc12_[_loc13_] = _loc7_;
                     _loc13_++;
                     _loc6_ = _loc7_;
                     numTriangles++;
                     _loc10_ = _loc10_.next;
                  }
               }
               opaqueNums[opaqueLength] = numTriangles - opaqueBegins[opaqueLength] / 3;
               opaqueLength++;
            }
            if(_loc13_ > 0)
            {
               indexBuffer = new IndexBufferResource(_loc12_);
            }
         }
      }
      
      override alternativa3d function addOpaque(param1:Camera3D) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < opaqueLength)
         {
            param1.addSky(opaqueMaterials[_loc2_],vertexBuffer,indexBuffer,opaqueBegins[_loc2_],opaqueNums[_loc2_],this);
            _loc2_++;
         }
      }
      
      override alternativa3d function getVG(param1:Camera3D) : VG
      {
         this.draw(param1);
         return null;
      }
      
      override alternativa3d function cullingInCamera(param1:Camera3D, param2:int) : int
      {
         return super.cullingInCamera(param1,param2 = int(int(param2 & ~3)));
      }
      
      private function calculateTransform(param1:Camera3D) : void
      {
         var _loc2_:Number = mi * boundMinX + mj * boundMinY + mk * boundMinZ + ml;
         var _loc3_:Number = _loc2_;
         _loc2_ = mi * boundMaxX + mj * boundMinY + mk * boundMinZ + ml;
         if(_loc2_ > _loc3_)
         {
            _loc3_ = _loc2_;
         }
         _loc2_ = mi * boundMaxX + mj * boundMaxY + mk * boundMinZ + ml;
         if(_loc2_ > _loc3_)
         {
            _loc3_ = _loc2_;
         }
         _loc2_ = mi * boundMinX + mj * boundMaxY + mk * boundMinZ + ml;
         if(_loc2_ > _loc3_)
         {
            _loc3_ = _loc2_;
         }
         _loc2_ = mi * boundMinX + mj * boundMinY + mk * boundMaxZ + ml;
         if(_loc2_ > _loc3_)
         {
            _loc3_ = _loc2_;
         }
         _loc2_ = mi * boundMaxX + mj * boundMinY + mk * boundMaxZ + ml;
         if(_loc2_ > _loc3_)
         {
            _loc3_ = _loc2_;
         }
         _loc2_ = mi * boundMaxX + mj * boundMaxY + mk * boundMaxZ + ml;
         if(_loc2_ > _loc3_)
         {
            _loc3_ = _loc2_;
         }
         _loc2_ = mi * boundMinX + mj * boundMaxY + mk * boundMaxZ + ml;
         if(_loc2_ > _loc3_)
         {
            _loc3_ = _loc2_;
         }
         var _loc4_:Number = 1;
         if(_loc3_ > param1.farClipping)
         {
            _loc4_ = param1.farClipping / _loc3_;
         }
         this.reduceConst[0] = _loc4_;
         this.reduceConst[1] = _loc4_;
         this.reduceConst[2] = _loc4_;
      }
   }
}
