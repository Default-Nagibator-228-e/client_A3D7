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
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.lights.SpotLight;
   import alternativa.engine3d.lights.TubeLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class Sprite3D extends Object3D
   {
       
      
      public var material:Material;
      
      public var originX:Number = 0.5;
      
      public var originY:Number = 0.5;
      
      public var sorting:int = 0;
      
      public var clipping:int = 2;
      
      public var rotation:Number = 0;
      
      public var autoSize:Boolean = false;
      
      public var width:Number;
      
      public var height:Number;
      
      public var perspectiveScale:Boolean = true;
      
      public var topLeftU:Number = 0;
      
      public var topLeftV:Number = 0;
      
      public var bottomRightU:Number = 1;
      
      public var bottomRightV:Number = 1;
      
      public var depthTest:Boolean = true;
      
      alternativa3d var lightConst:Vector.<Number>;
      
      alternativa3d var lighted:Boolean;
      
      public function Sprite3D(param1:Number, param2:Number, param3:Material = null)
      {
         this.lightConst = Vector.<Number>([0,0,0,1]);
         super();
         this.width = param1;
         this.height = param2;
         this.material = param3;
         shadowMapAlphaThreshold = 0;
		 this.useDepth = false;
      }
      
      override public function intersectRay(param1:Vector3D, param2:Vector3D, param3:Dictionary = null, param4:Camera3D = null) : RayIntersectionData
      {
         var _loc5_:RayIntersectionData = null;
         var _loc24_:Vertex = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Vector3D = null;
         if(param4 == null || param3 != null && param3[this])
         {
            return null;
         }
         param4.composeCameraMatrix();
         var _loc6_:Object3D = param4;
         while(_loc6_._parent != null)
         {
            _loc6_ = _loc6_._parent;
            _loc6_.composeMatrix();
            param4.appendMatrix(_loc6_);
         }
         param4.invertMatrix();
         composeMatrix();
         _loc6_ = this;
         while(_loc6_._parent != null)
         {
            _loc6_ = _loc6_._parent;
            _loc6_.composeMatrix();
            appendMatrix(_loc6_);
         }
         appendMatrix(param4);
         calculateInverseMatrix();
         var _loc7_:Number = param4.nearClipping;
         var _loc8_:Number = param4.farClipping;
         param4.nearClipping = -Number.MAX_VALUE;
         param4.farClipping = Number.MAX_VALUE;
         culling = 0;
         var _loc9_:Face = this.calculateFace(param4);
         param4.nearClipping = _loc7_;
         param4.farClipping = _loc8_;
         var _loc10_:Wrapper = _loc9_.wrapper;
         while(_loc10_ != null)
         {
            _loc24_ = _loc10_.vertex;
            _loc24_.x = ima * _loc24_.cameraX + imb * _loc24_.cameraY + imc * _loc24_.cameraZ + imd;
            _loc24_.y = ime * _loc24_.cameraX + imf * _loc24_.cameraY + img * _loc24_.cameraZ + imh;
            _loc24_.z = imi * _loc24_.cameraX + imj * _loc24_.cameraY + imk * _loc24_.cameraZ + iml;
            _loc10_ = _loc10_.next;
         }
         var _loc11_:Wrapper = _loc9_.wrapper;
         var _loc12_:Vertex = _loc11_.vertex;
         _loc11_ = _loc11_.next;
         var _loc13_:Vertex = _loc11_.vertex;
         _loc11_ = _loc11_.next;
         var _loc14_:Vertex = _loc11_.vertex;
         _loc11_ = _loc11_.next;
         var _loc15_:Vertex = _loc11_.vertex;
         _loc12_.u = this.topLeftU;
         _loc12_.v = this.topLeftV;
         _loc13_.u = this.topLeftU;
         _loc13_.v = this.bottomRightV;
         _loc14_.u = this.bottomRightU;
         _loc14_.v = this.bottomRightV;
         _loc15_.u = this.bottomRightU;
         _loc15_.v = this.topLeftV;
         var _loc16_:Number = _loc13_.x - _loc12_.x;
         var _loc17_:Number = _loc13_.y - _loc12_.y;
         var _loc18_:Number = _loc13_.z - _loc12_.z;
         var _loc19_:Number = _loc14_.x - _loc12_.x;
         var _loc20_:Number = _loc14_.y - _loc12_.y;
         var _loc21_:Number = _loc14_.z - _loc12_.z;
         _loc9_.normalX = _loc21_ * _loc17_ - _loc20_ * _loc18_;
         _loc9_.normalY = _loc19_ * _loc18_ - _loc21_ * _loc16_;
         _loc9_.normalZ = _loc20_ * _loc16_ - _loc19_ * _loc17_;
         var _loc22_:Number = 1 / Math.sqrt(_loc9_.normalX * _loc9_.normalX + _loc9_.normalY * _loc9_.normalY + _loc9_.normalZ * _loc9_.normalZ);
         _loc9_.normalX = _loc9_.normalX * _loc22_;
         _loc9_.normalY = _loc9_.normalY * _loc22_;
         _loc9_.normalZ = _loc9_.normalZ * _loc22_;
         _loc9_.offset = _loc12_.x * _loc9_.normalX + _loc12_.y * _loc9_.normalY + _loc12_.z * _loc9_.normalZ;
         var _loc23_:Number = param2.x * _loc9_.normalX + param2.y * _loc9_.normalY + param2.z * _loc9_.normalZ;
         if(_loc23_ < 0)
         {
            _loc25_ = param1.x * _loc9_.normalX + param1.y * _loc9_.normalY + param1.z * _loc9_.normalZ - _loc9_.offset;
            if(_loc25_ > 0)
            {
               _loc26_ = -_loc25_ / _loc23_;
               _loc27_ = param1.x + param2.x * _loc26_;
               _loc28_ = param1.y + param2.y * _loc26_;
               _loc29_ = param1.z + param2.z * _loc26_;
               _loc10_ = _loc9_.wrapper;
               while(_loc10_ != null)
               {
                  _loc12_ = _loc10_.vertex;
                  _loc13_ = _loc10_.next != null?_loc10_.next.vertex:_loc9_.wrapper.vertex;
                  _loc16_ = _loc13_.x - _loc12_.x;
                  _loc17_ = _loc13_.y - _loc12_.y;
                  _loc18_ = _loc13_.z - _loc12_.z;
                  _loc19_ = _loc27_ - _loc12_.x;
                  _loc20_ = _loc28_ - _loc12_.y;
                  _loc21_ = _loc29_ - _loc12_.z;
                  if((_loc21_ * _loc17_ - _loc20_ * _loc18_) * _loc9_.normalX + (_loc19_ * _loc18_ - _loc21_ * _loc16_) * _loc9_.normalY + (_loc20_ * _loc16_ - _loc19_ * _loc17_) * _loc9_.normalZ < 0)
                  {
                     break;
                  }
                  _loc10_ = _loc10_.next;
               }
               if(_loc10_ == null)
               {
                  _loc30_ = new Vector3D(_loc27_,_loc28_,_loc29_);
                  _loc5_ = new RayIntersectionData();
                  _loc5_.object = this;
                  _loc5_.face = null;
                  _loc5_.point = _loc30_;
                  _loc5_.uv = _loc9_.getUV(_loc30_);
                  _loc5_.time = _loc26_;
               }
            }
         }
         param4.deferredDestroy();
         return _loc5_;
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Sprite3D = new Sprite3D(this.width,this.height);
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         super.clonePropertiesFrom(param1);
         var _loc2_:Sprite3D = param1 as Sprite3D;
         this.width = _loc2_.width;
         this.height = _loc2_.height;
         this.autoSize = _loc2_.autoSize;
         this.material = _loc2_.material;
         this.clipping = _loc2_.clipping;
         this.sorting = _loc2_.sorting;
         this.originX = _loc2_.originX;
         this.originY = _loc2_.originY;
         this.topLeftU = _loc2_.topLeftU;
         this.topLeftV = _loc2_.topLeftV;
         this.bottomRightU = _loc2_.bottomRightU;
         this.bottomRightV = _loc2_.bottomRightV;
         this.rotation = _loc2_.rotation;
         this.perspectiveScale = _loc2_.perspectiveScale;
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         var _loc2_:int = 0;
         if(this.material == null)
         {
            return;
         }
         var _loc3_:Face = this.calculateFace(param1);
         if(_loc3_ != null)
         {
            this.lighted = false;
            if(useLight && !param1.view.constrained && param1.deferredLighting && param1.deferredLightingStrength > 0)
            {
               this.calculateLight(param1);
            }
            if(param1.debug && (_loc2_ = param1.checkInDebug(this)) > 0)
            {
               if(_loc2_ & Debug.EDGES)
               {
                  Debug.drawEdges(param1,_loc3_,16777215);
               }
               if(_loc2_ & Debug.BOUNDS)
               {
                  Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            param1.addTransparent(_loc3_,this);
         }
      }
      
      override alternativa3d function getVG(param1:Camera3D) : VG
      {
         if(this.material == null)
         {
            return null;
         }
         var _loc2_:Face = this.calculateFace(param1);
         if(_loc2_ != null)
         {
            this.lighted = false;
            if(useLight && !param1.view.constrained && param1.deferredLighting && param1.deferredLightingStrength > 0)
            {
               this.calculateLight(param1);
            }
            _loc2_.normalX = 0;
            _loc2_.normalY = 0;
            _loc2_.normalZ = -1;
            _loc2_.offset = -ml;
            return VG.create(this,_loc2_,this.sorting,!!param1.debug?int(int(param1.checkInDebug(this))):int(int(0)),true);
         }
         return null;
      }
      
      private function calculateLight(param1:Camera3D) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc20_:OmniLight = null;
         var _loc21_:SpotLight = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:TubeLight = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc2_:Number = param1.viewSizeX / param1.focalLength;
         var _loc3_:Number = param1.viewSizeY / param1.focalLength;
         if(!param1.view.constrained && (param1.directionalLight != null && param1.directionalLightStrength > 0 || param1.shadowMap != null && param1.shadowMapStrength > 0))
         {
            this.lightConst[0] = 0;
            this.lightConst[1] = 0;
            this.lightConst[2] = 0;
         }
         else
         {
            this.lightConst[0] = 1;
            this.lightConst[1] = 1;
            this.lightConst[2] = 1;
         }
         var _loc13_:Number = md * _loc2_;
         var _loc14_:Number = mh * _loc3_;
         var _loc15_:Number = ml;
         var _loc16_:Number = Math.sqrt(_loc13_ * _loc13_ + _loc14_ * _loc14_ + _loc15_ * _loc15_);
         var _loc17_:Number = -_loc13_ / _loc16_;
         var _loc18_:Number = -_loc14_ / _loc16_;
         var _loc19_:Number = -_loc15_ / _loc16_;
         _loc4_ = 0;
         while(_loc4_ < param1.omniesCount)
         {
            _loc20_ = param1.omnies[_loc4_];
            _loc5_ = _loc20_.cmd * _loc2_;
            _loc6_ = _loc20_.cmh * _loc3_;
            _loc7_ = _loc20_.cml;
            _loc8_ = _loc20_.attenuationEnd;
            if(_loc5_ - _loc8_ < _loc13_ && _loc5_ + _loc8_ > _loc13_ && _loc6_ - _loc8_ < _loc14_ && _loc6_ + _loc8_ > _loc14_ && _loc7_ - _loc8_ < _loc15_ && _loc7_ + _loc8_ > _loc15_)
            {
               _loc5_ = _loc5_ - _loc13_;
               _loc6_ = _loc6_ - _loc14_;
               _loc7_ = _loc7_ - _loc15_;
               _loc16_ = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
               if(_loc16_ > 0 && _loc16_ < _loc8_)
               {
                  _loc5_ = _loc5_ / _loc16_;
                  _loc6_ = _loc6_ / _loc16_;
                  _loc7_ = _loc7_ / _loc16_;
                  _loc9_ = (_loc8_ - _loc16_) / (_loc20_.attenuationEnd - _loc20_.attenuationBegin);
                  if(_loc9_ > 1)
                  {
                     _loc9_ = 1;
                  }
                  if(_loc9_ < 0)
                  {
                     _loc9_ = 0;
                  }
                  _loc9_ = _loc9_ * _loc9_;
                  _loc11_ = _loc5_ * _loc17_ + _loc6_ * _loc18_ + _loc7_ * _loc19_;
                  _loc11_ = _loc11_ * 0.5;
                  _loc11_ = _loc11_ + 0.5;
                  _loc12_ = _loc9_ * _loc11_ * _loc20_.intensity * 2 * param1.deferredLightingStrength;
                  this.lightConst[0] = this.lightConst[0] + _loc12_ * (_loc20_.color >> 16 & 255) / 255;
                  this.lightConst[1] = this.lightConst[1] + _loc12_ * (_loc20_.color >> 8 & 255) / 255;
                  this.lightConst[2] = this.lightConst[2] + _loc12_ * (_loc20_.color & 255) / 255;
                  this.lighted = true;
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.spotsCount)
         {
            _loc21_ = param1.spots[_loc4_];
            _loc5_ = _loc21_.cmd * _loc2_;
            _loc6_ = _loc21_.cmh * _loc3_;
            _loc7_ = _loc21_.cml;
            _loc8_ = _loc21_.attenuationEnd;
            if(_loc5_ - _loc8_ < _loc13_ && _loc5_ + _loc8_ > _loc13_ && _loc6_ - _loc8_ < _loc14_ && _loc6_ + _loc8_ > _loc14_ && _loc7_ - _loc8_ < _loc15_ && _loc7_ + _loc8_ > _loc15_)
            {
               _loc5_ = _loc5_ - _loc13_;
               _loc6_ = _loc6_ - _loc14_;
               _loc7_ = _loc7_ - _loc15_;
               _loc16_ = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
               if(_loc16_ > 0 && _loc16_ < _loc8_)
               {
                  _loc5_ = _loc5_ / _loc16_;
                  _loc6_ = _loc6_ / _loc16_;
                  _loc7_ = _loc7_ / _loc16_;
                  _loc22_ = -_loc5_ * _loc21_.cmc * _loc2_ - _loc6_ * _loc21_.cmg * _loc3_ - _loc7_ * _loc21_.cmk;
                  _loc23_ = Math.cos(_loc21_.falloff * 0.5);
                  if(_loc22_ > _loc23_)
                  {
                     _loc11_ = _loc5_ * _loc17_ + _loc6_ * _loc18_ + _loc7_ * _loc19_;
                     _loc11_ = _loc11_ * 0.5;
                     _loc11_ = _loc11_ + 0.5;
                     _loc9_ = (_loc8_ - _loc16_) / (_loc21_.attenuationEnd - _loc21_.attenuationBegin);
                     if(_loc9_ > 1)
                     {
                        _loc9_ = 1;
                     }
                     if(_loc9_ < 0)
                     {
                        _loc9_ = 0;
                     }
                     _loc9_ = _loc9_ * _loc9_;
                     _loc10_ = (_loc22_ - _loc23_) / (Math.cos(_loc21_.hotspot * 0.5) - _loc23_);
                     if(_loc10_ > 1)
                     {
                        _loc10_ = 1;
                     }
                     if(_loc10_ < 0)
                     {
                        _loc10_ = 0;
                     }
                     _loc10_ = _loc10_ * _loc10_;
                     _loc12_ = _loc9_ * _loc10_ * _loc11_ * _loc21_.intensity * 2 * param1.deferredLightingStrength;
                     this.lightConst[0] = this.lightConst[0] + _loc12_ * (_loc21_.color >> 16 & 255) / 255;
                     this.lightConst[1] = this.lightConst[1] + _loc12_ * (_loc21_.color >> 8 & 255) / 255;
                     this.lightConst[2] = this.lightConst[2] + _loc12_ * (_loc21_.color & 255) / 255;
                     this.lighted = true;
                  }
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.tubesCount)
         {
            _loc24_ = param1.tubes[_loc4_];
            _loc25_ = _loc24_.length * 0.5;
            _loc26_ = _loc25_ + _loc24_.falloff;
            _loc27_ = _loc24_.cmc * _loc2_;
            _loc28_ = _loc24_.cmg * _loc2_;
            _loc29_ = _loc24_.cmk;
            _loc5_ = _loc24_.cmd * _loc2_ + _loc27_ * _loc25_;
            _loc6_ = _loc24_.cmh * _loc3_ + _loc28_ * _loc25_;
            _loc7_ = _loc24_.cml + _loc29_ * _loc25_;
            _loc30_ = _loc27_ * (_loc13_ - _loc5_) + _loc28_ * (_loc14_ - _loc6_) + _loc29_ * (_loc15_ - _loc7_);
            if(_loc30_ > -_loc26_ && _loc30_ < _loc26_)
            {
               _loc5_ = _loc5_ + (_loc27_ * _loc30_ - _loc13_);
               _loc6_ = _loc6_ + (_loc28_ * _loc30_ - _loc14_);
               _loc7_ = _loc7_ + (_loc29_ * _loc30_ - _loc15_);
               _loc16_ = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
               if(_loc16_ > 0 && _loc16_ < _loc24_.attenuationEnd)
               {
                  _loc5_ = _loc5_ / _loc16_;
                  _loc6_ = _loc6_ / _loc16_;
                  _loc7_ = _loc7_ / _loc16_;
                  _loc11_ = _loc5_ * _loc17_ + _loc6_ * _loc18_ + _loc7_ * _loc19_;
                  _loc11_ = _loc11_ * 0.5;
                  _loc11_ = _loc11_ + 0.5;
                  _loc9_ = (_loc24_.attenuationEnd - _loc16_) / (_loc24_.attenuationEnd - _loc24_.attenuationBegin);
                  if(_loc9_ > 1)
                  {
                     _loc9_ = 1;
                  }
                  if(_loc9_ < 0)
                  {
                     _loc9_ = 0;
                  }
                  _loc9_ = _loc9_ * _loc9_;
                  if(_loc30_ < 0)
                  {
                     _loc30_ = -_loc30_;
                  }
                  _loc10_ = (_loc26_ - _loc30_) / (_loc26_ - _loc25_);
                  if(_loc10_ > 1)
                  {
                     _loc10_ = 1;
                  }
                  if(_loc10_ < 0)
                  {
                     _loc10_ = 0;
                  }
                  _loc10_ = _loc10_ * _loc10_;
                  _loc12_ = _loc9_ * _loc10_ * _loc11_ * _loc24_.intensity * 2 * param1.deferredLightingStrength;
                  this.lightConst[0] = this.lightConst[0] + _loc12_ * (_loc24_.color >> 16 & 255) / 255;
                  this.lightConst[1] = this.lightConst[1] + _loc12_ * (_loc24_.color >> 8 & 255) / 255;
                  this.lightConst[2] = this.lightConst[2] + _loc12_ * (_loc24_.color & 255) / 255;
                  this.lighted = true;
               }
            }
            _loc4_++;
         }
      }
      
      private function calculateFace(param1:Camera3D) : Face
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Vertex = null;
         var _loc12_:Vertex = null;
         var _loc22_:Number = NaN;
         var _loc25_:BitmapData = null;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         culling = culling & 60;
         var _loc2_:Number = ml;
         if(_loc2_ <= param1.nearClipping || _loc2_ >= param1.farClipping)
         {
            return null;
         }
         var _loc13_:Number = this.width;
         var _loc14_:Number = this.height;
         var _loc15_:Number = this.bottomRightU - this.topLeftU;
         var _loc16_:Number = this.bottomRightV - this.topLeftV;
         if(this.autoSize && this.material is TextureMaterial)
         {
            _loc25_ = (this.material as TextureMaterial).texture;
            if(_loc25_ != null)
            {
               _loc13_ = _loc25_.width * _loc15_;
               _loc14_ = _loc25_.height * _loc16_;
            }
         }
         var _loc17_:Number = param1.viewSizeX / _loc2_;
         var _loc18_:Number = param1.viewSizeY / _loc2_;
         var _loc19_:Number = param1.focalLength / _loc2_;
         var _loc20_:Number = param1.focalLength / param1.viewSizeX;
         var _loc21_:Number = param1.focalLength / param1.viewSizeY;
         _loc3_ = ma / _loc20_;
         _loc4_ = me / _loc21_;
         _loc22_ = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + mi * mi);
         _loc3_ = mb / _loc20_;
         _loc4_ = mf / _loc21_;
         _loc22_ = _loc22_ + Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + mj * mj);
         _loc3_ = mc / _loc20_;
         _loc4_ = mg / _loc21_;
         _loc22_ = _loc22_ + Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + mk * mk);
         _loc22_ = _loc22_ / 3;
         if(!this.perspectiveScale)
         {
            _loc22_ = _loc22_ / _loc19_;
         }
         if(this.rotation == 0)
         {
            _loc26_ = _loc22_ * _loc13_ * _loc20_;
            _loc27_ = _loc22_ * _loc14_ * _loc21_;
            _loc3_ = md - this.originX * _loc26_;
            _loc4_ = mh - this.originY * _loc27_;
            _loc7_ = _loc3_ + _loc26_;
            _loc8_ = _loc4_ + _loc27_;
            if(culling > 0 && (_loc3_ > _loc2_ || _loc4_ > _loc2_ || _loc7_ < -_loc2_ || _loc8_ < -_loc2_))
            {
               return null;
            }
            _loc11_ = Vertex.createList(4);
            _loc12_ = _loc11_;
            _loc12_.cameraX = _loc3_;
            _loc12_.cameraY = _loc4_;
            _loc12_.cameraZ = _loc2_;
            _loc12_.u = this.topLeftU;
            _loc12_.v = this.topLeftV;
            _loc12_ = _loc12_.next;
            _loc12_.cameraX = _loc3_;
            _loc12_.cameraY = _loc8_;
            _loc12_.cameraZ = _loc2_;
            _loc12_.u = this.topLeftU;
            _loc12_.v = this.bottomRightV;
            _loc12_ = _loc12_.next;
            _loc12_.cameraX = _loc7_;
            _loc12_.cameraY = _loc8_;
            _loc12_.cameraZ = _loc2_;
            _loc12_.u = this.bottomRightU;
            _loc12_.v = this.bottomRightV;
            _loc12_ = _loc12_.next;
            _loc12_.cameraX = _loc7_;
            _loc12_.cameraY = _loc4_;
            _loc12_.cameraZ = _loc2_;
            _loc12_.u = this.bottomRightU;
            _loc12_.v = this.topLeftV;
         }
         else
         {
            _loc28_ = -Math.sin(this.rotation) * _loc22_;
            _loc29_ = Math.cos(this.rotation) * _loc22_;
            _loc30_ = _loc29_ * _loc13_ * _loc20_;
            _loc31_ = -_loc28_ * _loc13_ * _loc21_;
            _loc32_ = _loc28_ * _loc14_ * _loc20_;
            _loc33_ = _loc29_ * _loc14_ * _loc21_;
            _loc3_ = md - this.originX * _loc30_ - this.originY * _loc32_;
            _loc4_ = mh - this.originX * _loc31_ - this.originY * _loc33_;
            _loc5_ = _loc3_ + _loc32_;
            _loc6_ = _loc4_ + _loc33_;
            _loc7_ = _loc3_ + _loc30_ + _loc32_;
            _loc8_ = _loc4_ + _loc31_ + _loc33_;
            _loc9_ = _loc3_ + _loc30_;
            _loc10_ = _loc4_ + _loc31_;
            if(culling > 0)
            {
               if(this.clipping == 1)
               {
                  if(culling & 4 && _loc2_ <= -_loc3_ && _loc2_ <= -_loc5_ && _loc2_ <= -_loc7_ && _loc2_ <= -_loc9_)
                  {
                     return null;
                  }
                  if(culling & 8 && _loc2_ <= _loc3_ && _loc2_ <= _loc5_ && _loc2_ <= _loc7_ && _loc2_ <= _loc9_)
                  {
                     return null;
                  }
                  if(culling & 16 && _loc2_ <= -_loc4_ && _loc2_ <= -_loc6_ && _loc2_ <= -_loc8_ && _loc2_ <= -_loc10_)
                  {
                     return null;
                  }
                  if(culling & 32 && _loc2_ <= _loc4_ && _loc2_ <= _loc6_ && _loc2_ <= _loc8_ && _loc2_ <= _loc10_)
                  {
                     return null;
                  }
                  _loc11_ = Vertex.createList(4);
                  _loc12_ = _loc11_;
                  _loc12_.cameraX = _loc3_;
                  _loc12_.cameraY = _loc4_;
                  _loc12_.cameraZ = _loc2_;
                  _loc12_.u = this.topLeftU;
                  _loc12_.v = this.topLeftV;
                  _loc12_ = _loc12_.next;
                  _loc12_.cameraX = _loc3_ + _loc32_;
                  _loc12_.cameraY = _loc4_ + _loc33_;
                  _loc12_.cameraZ = _loc2_;
                  _loc12_.u = this.topLeftU;
                  _loc12_.v = this.bottomRightV;
                  _loc12_ = _loc12_.next;
                  _loc12_.cameraX = _loc3_ + _loc30_ + _loc32_;
                  _loc12_.cameraY = _loc4_ + _loc31_ + _loc33_;
                  _loc12_.cameraZ = _loc2_;
                  _loc12_.u = this.bottomRightU;
                  _loc12_.v = this.bottomRightV;
                  _loc12_ = _loc12_.next;
                  _loc12_.cameraX = _loc3_ + _loc30_;
                  _loc12_.cameraY = _loc4_ + _loc31_;
                  _loc12_.cameraZ = _loc2_;
                  _loc12_.u = this.bottomRightU;
                  _loc12_.v = this.topLeftV;
               }
               else
               {
                  if(culling & 4)
                  {
                     if(_loc2_ <= -_loc3_ && _loc2_ <= -_loc5_ && _loc2_ <= -_loc7_ && _loc2_ <= -_loc9_)
                     {
                        return null;
                     }
                     if(_loc2_ > -_loc3_ && _loc2_ > -_loc5_ && _loc2_ > -_loc7_ && _loc2_ > -_loc9_)
                     {
                        culling = culling & 59;
                     }
                  }
                  if(culling & 8)
                  {
                     if(_loc2_ <= _loc3_ && _loc2_ <= _loc5_ && _loc2_ <= _loc7_ && _loc2_ <= _loc9_)
                     {
                        return null;
                     }
                     if(_loc2_ > _loc3_ && _loc2_ > _loc5_ && _loc2_ > _loc7_ && _loc2_ > _loc9_)
                     {
                        culling = culling & 55;
                     }
                  }
                  if(culling & 16)
                  {
                     if(_loc2_ <= -_loc4_ && _loc2_ <= -_loc6_ && _loc2_ <= -_loc8_ && _loc2_ <= -_loc10_)
                     {
                        return null;
                     }
                     if(_loc2_ > -_loc4_ && _loc2_ > -_loc6_ && _loc2_ > -_loc8_ && _loc2_ > -_loc10_)
                     {
                        culling = culling & 47;
                     }
                  }
                  if(culling & 32)
                  {
                     if(_loc2_ <= _loc4_ && _loc2_ <= _loc6_ && _loc2_ <= _loc8_ && _loc2_ <= _loc10_)
                     {
                        return null;
                     }
                     if(_loc2_ > _loc4_ && _loc2_ > _loc6_ && _loc2_ > _loc8_ && _loc2_ > _loc10_)
                     {
                        culling = culling & 31;
                     }
                  }
                  _loc11_ = Vertex.createList(4);
                  _loc12_ = _loc11_;
                  _loc12_.cameraX = _loc3_;
                  _loc12_.cameraY = _loc4_;
                  _loc12_.cameraZ = _loc2_;
                  _loc12_.u = this.topLeftU;
                  _loc12_.v = this.topLeftV;
                  _loc12_ = _loc12_.next;
                  _loc12_.cameraX = _loc3_ + _loc32_;
                  _loc12_.cameraY = _loc4_ + _loc33_;
                  _loc12_.cameraZ = _loc2_;
                  _loc12_.u = this.topLeftU;
                  _loc12_.v = this.bottomRightV;
                  _loc12_ = _loc12_.next;
                  _loc12_.cameraX = _loc3_ + _loc30_ + _loc32_;
                  _loc12_.cameraY = _loc4_ + _loc31_ + _loc33_;
                  _loc12_.cameraZ = _loc2_;
                  _loc12_.u = this.bottomRightU;
                  _loc12_.v = this.bottomRightV;
                  _loc12_ = _loc12_.next;
                  _loc12_.cameraX = _loc3_ + _loc30_;
                  _loc12_.cameraY = _loc4_ + _loc31_;
                  _loc12_.cameraZ = _loc2_;
                  _loc12_.u = this.bottomRightU;
                  _loc12_.v = this.topLeftV;
               }
            }
            else
            {
               _loc11_ = Vertex.createList(4);
               _loc12_ = _loc11_;
               _loc12_.cameraX = _loc3_;
               _loc12_.cameraY = _loc4_;
               _loc12_.cameraZ = _loc2_;
               _loc12_.u = this.topLeftU;
               _loc12_.v = this.topLeftV;
               _loc12_ = _loc12_.next;
               _loc12_.cameraX = _loc3_ + _loc32_;
               _loc12_.cameraY = _loc4_ + _loc33_;
               _loc12_.cameraZ = _loc2_;
               _loc12_.u = this.topLeftU;
               _loc12_.v = this.bottomRightV;
               _loc12_ = _loc12_.next;
               _loc12_.cameraX = _loc3_ + _loc30_ + _loc32_;
               _loc12_.cameraY = _loc4_ + _loc31_ + _loc33_;
               _loc12_.cameraZ = _loc2_;
               _loc12_.u = this.bottomRightU;
               _loc12_.v = this.bottomRightV;
               _loc12_ = _loc12_.next;
               _loc12_.cameraX = _loc3_ + _loc30_;
               _loc12_.cameraY = _loc4_ + _loc31_;
               _loc12_.cameraZ = _loc2_;
               _loc12_.u = this.bottomRightU;
               _loc12_.v = this.topLeftV;
            }
         }
         param1.lastVertex.next = _loc11_;
         param1.lastVertex = _loc12_;
         var _loc23_:Face = Face.create();
         _loc23_.material = this.material;
         param1.lastFace.next = _loc23_;
         param1.lastFace = _loc23_;
         var _loc24_:Wrapper = Wrapper.create();
         _loc23_.wrapper = _loc24_;
         _loc24_.vertex = _loc11_;
         _loc11_ = _loc11_.next;
         while(_loc11_ != null)
         {
            _loc24_.next = _loc24_.create();
            _loc24_ = _loc24_.next;
            _loc24_.vertex = _loc11_;
            _loc11_ = _loc11_.next;
         }
         return _loc23_;
      }
      
      override alternativa3d function updateBounds(param1:Object3D, param2:Object3D = null) : void
      {
         var _loc11_:BitmapData = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc3_:Number = this.width;
         var _loc4_:Number = this.height;
         if(this.autoSize && this.material is TextureMaterial)
         {
            _loc11_ = (this.material as TextureMaterial).texture;
            if(_loc11_ != null)
            {
               _loc3_ = _loc11_.width * (this.bottomRightU - this.topLeftU);
               _loc4_ = _loc11_.height * (this.bottomRightV - this.topLeftV);
            }
         }
         var _loc5_:Number = (this.originX >= 0.5?this.originX:1 - this.originX) * _loc3_;
         var _loc6_:Number = (this.originY >= 0.5?this.originY:1 - this.originY) * _loc4_;
         var _loc7_:Number = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         if(param2 != null)
         {
            _loc12_ = param2.ma;
            _loc13_ = param2.me;
            _loc14_ = param2.mi;
            _loc15_ = Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_ + _loc14_ * _loc14_);
            _loc12_ = param2.mb;
            _loc13_ = param2.mf;
            _loc14_ = param2.mj;
            _loc15_ = _loc15_ + Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_ + _loc14_ * _loc14_);
            _loc12_ = param2.mc;
            _loc13_ = param2.mg;
            _loc14_ = param2.mk;
            _loc15_ = _loc15_ + Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_ + _loc14_ * _loc14_);
            _loc7_ = _loc7_ * (_loc15_ / 3);
            _loc8_ = param2.md;
            _loc9_ = param2.mh;
            _loc10_ = param2.ml;
         }
         if(_loc8_ - _loc7_ < param1.boundMinX)
         {
            param1.boundMinX = _loc8_ - _loc7_;
         }
         if(_loc8_ + _loc7_ > param1.boundMaxX)
         {
            param1.boundMaxX = _loc8_ + _loc7_;
         }
         if(_loc9_ - _loc7_ < param1.boundMinY)
         {
            param1.boundMinY = _loc9_ - _loc7_;
         }
         if(_loc9_ + _loc7_ > param1.boundMaxY)
         {
            param1.boundMaxY = _loc9_ + _loc7_;
         }
         if(_loc10_ - _loc7_ < param1.boundMinZ)
         {
            param1.boundMinZ = _loc10_ - _loc7_;
         }
         if(_loc10_ + _loc7_ > param1.boundMaxZ)
         {
            param1.boundMaxZ = _loc10_ + _loc7_;
         }
      }
   }
}
