package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   use namespace alternativa3d;
   public class Light3D extends Object3D
   {
       
      
      public var color:uint;
      
      public var intensity:Number = 1;
      
      alternativa3d var localWeight:Number;
      
      alternativa3d var localRed:Number;
      
      alternativa3d var localGreen:Number;
      
      alternativa3d var localBlue:Number;
      
      alternativa3d var cma:Number;
      
      alternativa3d var cmb:Number;
      
      alternativa3d var cmc:Number;
      
      alternativa3d var cmd:Number;
      
      alternativa3d var cme:Number;
      
      alternativa3d var cmf:Number;
      
      alternativa3d var cmg:Number;
      
      alternativa3d var cmh:Number;
      
      alternativa3d var cmi:Number;
      
      alternativa3d var cmj:Number;
      
      alternativa3d var cmk:Number;
      
      alternativa3d var cml:Number;
      
      alternativa3d var oma:Number;
      
      alternativa3d var omb:Number;
      
      alternativa3d var omc:Number;
      
      alternativa3d var omd:Number;
      
      alternativa3d var ome:Number;
      
      alternativa3d var omf:Number;
      
      alternativa3d var omg:Number;
      
      alternativa3d var omh:Number;
      
      alternativa3d var omi:Number;
      
      alternativa3d var omj:Number;
      
      alternativa3d var omk:Number;
      
      alternativa3d var oml:Number;
      
      alternativa3d var nextLight:Light3D;
      
      public function Light3D()
      {
         super();
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Light3D = new Light3D();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         super.clonePropertiesFrom(param1);
         var _loc2_:Light3D = param1 as Light3D;
         this.color = _loc2_.color;
         this.intensity = _loc2_.intensity;
      }
      
      alternativa3d function calculateCameraMatrix(param1:Camera3D) : void
      {
         composeMatrix();
         var _loc2_:Object3D = this;
         while(_loc2_._parent != null)
         {
            _loc2_ = _loc2_._parent;
            _loc2_.composeMatrix();
            appendMatrix(_loc2_);
         }
         appendMatrix(param1);
         this.cma = ma;
         this.cmb = mb;
         this.cmc = mc;
         this.cmd = md;
         this.cme = me;
         this.cmf = mf;
         this.cmg = mg;
         this.cmh = mh;
         this.cmi = mi;
         this.cmj = mj;
         this.cmk = mk;
         this.cml = ml;
      }
      
      alternativa3d function calculateObjectMatrix(param1:Object3D) : void
      {
         this.oma = param1.ima * this.cma + param1.imb * this.cme + param1.imc * this.cmi;
         this.omb = param1.ima * this.cmb + param1.imb * this.cmf + param1.imc * this.cmj;
         this.omc = param1.ima * this.cmc + param1.imb * this.cmg + param1.imc * this.cmk;
         this.omd = param1.ima * this.cmd + param1.imb * this.cmh + param1.imc * this.cml + param1.imd;
         this.ome = param1.ime * this.cma + param1.imf * this.cme + param1.img * this.cmi;
         this.omf = param1.ime * this.cmb + param1.imf * this.cmf + param1.img * this.cmj;
         this.omg = param1.ime * this.cmc + param1.imf * this.cmg + param1.img * this.cmk;
         this.omh = param1.ime * this.cmd + param1.imf * this.cmh + param1.img * this.cml + param1.imh;
         this.omi = param1.imi * this.cma + param1.imj * this.cme + param1.imk * this.cmi;
         this.omj = param1.imi * this.cmb + param1.imj * this.cmf + param1.imk * this.cmj;
         this.omk = param1.imi * this.cmc + param1.imj * this.cmg + param1.imk * this.cmk;
         this.oml = param1.imi * this.cmd + param1.imj * this.cmh + param1.imk * this.cml + param1.iml;
      }
      
      override alternativa3d function setParent(param1:Object3DContainer) : void
      {
         var _loc2_:Object3DContainer = null;
         var _loc3_:Light3D = null;
         var _loc4_:Light3D = null;
         if(param1 == null)
         {
            _loc2_ = _parent;
            while(_loc2_._parent != null)
            {
               _loc2_ = _loc2_._parent;
            }
            _loc4_ = _loc2_.lightList;
            while(_loc4_ != null)
            {
               if(_loc4_ == this)
               {
                  if(_loc3_ != null)
                  {
                     _loc3_.nextLight = this.nextLight;
                  }
                  else
                  {
                     _loc2_.lightList = this.nextLight;
                  }
                  this.nextLight = null;
                  break;
               }
               _loc3_ = _loc4_;
               _loc4_ = _loc4_.nextLight;
            }
         }
         else
         {
            _loc2_ = param1;
            while(_loc2_._parent != null)
            {
               _loc2_ = _loc2_._parent;
            }
            this.nextLight = _loc2_.lightList;
            _loc2_.lightList = this;
         }
         _parent = param1;
      }
      
      alternativa3d function drawDebug(param1:Camera3D) : void
      {
      }
      
      override alternativa3d function updateBounds(param1:Object3D, param2:Object3D = null) : void
      {
         param1.boundMinX = -1.0e22;
         param1.boundMinY = -1.0e22;
         param1.boundMinZ = -1.0e22;
         param1.boundMaxX = 1.0e22;
         param1.boundMaxY = 1.0e22;
         param1.boundMaxZ = 1.0e22;
      }
      
      override alternativa3d function cullingInCamera(param1:Camera3D, param2:int) : int
      {
         return -1;
      }
      
      alternativa3d function checkFrustumCulling(param1:Camera3D) : Boolean
      {
         var _loc2_:Vertex = boundVertexList;
         _loc2_.x = boundMinX;
         _loc2_.y = boundMinY;
         _loc2_.z = boundMinZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = boundMaxX;
         _loc2_.y = boundMinY;
         _loc2_.z = boundMinZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = boundMinX;
         _loc2_.y = boundMaxY;
         _loc2_.z = boundMinZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = boundMaxX;
         _loc2_.y = boundMaxY;
         _loc2_.z = boundMinZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = boundMinX;
         _loc2_.y = boundMinY;
         _loc2_.z = boundMaxZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = boundMaxX;
         _loc2_.y = boundMinY;
         _loc2_.z = boundMaxZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = boundMinX;
         _loc2_.y = boundMaxY;
         _loc2_.z = boundMaxZ;
         _loc2_ = _loc2_.next;
         _loc2_.x = boundMaxX;
         _loc2_.y = boundMaxY;
         _loc2_.z = boundMaxZ;
         _loc2_ = boundVertexList;
         while(_loc2_ != null)
         {
            _loc2_.cameraX = ma * _loc2_.x + mb * _loc2_.y + mc * _loc2_.z + md;
            _loc2_.cameraY = me * _loc2_.x + mf * _loc2_.y + mg * _loc2_.z + mh;
            _loc2_.cameraZ = mi * _loc2_.x + mj * _loc2_.y + mk * _loc2_.z + ml;
            _loc2_ = _loc2_.next;
         }
         _loc2_ = boundVertexList;
         while(_loc2_ != null)
         {
            if(_loc2_.cameraZ > param1.nearClipping)
            {
               break;
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            return false;
         }
         _loc2_ = boundVertexList;
         while(_loc2_ != null)
         {
            if(_loc2_.cameraZ < param1.farClipping)
            {
               break;
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            return false;
         }
         _loc2_ = boundVertexList;
         while(_loc2_ != null)
         {
            if(-_loc2_.cameraX < _loc2_.cameraZ)
            {
               break;
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            return false;
         }
         _loc2_ = boundVertexList;
         while(_loc2_ != null)
         {
            if(_loc2_.cameraX < _loc2_.cameraZ)
            {
               break;
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            return false;
         }
         _loc2_ = boundVertexList;
         while(_loc2_ != null)
         {
            if(-_loc2_.cameraY < _loc2_.cameraZ)
            {
               break;
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            return false;
         }
         _loc2_ = boundVertexList;
         while(_loc2_ != null)
         {
            if(_loc2_.cameraY < _loc2_.cameraZ)
            {
               break;
            }
            _loc2_ = _loc2_.next;
         }
         if(_loc2_ == null)
         {
            return false;
         }
         return true;
      }
      
      alternativa3d function checkBoundsIntersection(param1:Object3D) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = (boundMaxX - boundMinX) * 0.5;
         var _loc5_:Number = (boundMaxY - boundMinY) * 0.5;
         var _loc6_:Number = (boundMaxZ - boundMinZ) * 0.5;
         var _loc7_:Number = this.oma * _loc4_;
         var _loc8_:Number = this.ome * _loc4_;
         var _loc9_:Number = this.omi * _loc4_;
         var _loc10_:Number = this.omb * _loc5_;
         var _loc11_:Number = this.omf * _loc5_;
         var _loc12_:Number = this.omj * _loc5_;
         var _loc13_:Number = this.omc * _loc6_;
         var _loc14_:Number = this.omg * _loc6_;
         var _loc15_:Number = this.omk * _loc6_;
         var _loc16_:Number = (param1.boundMaxX - param1.boundMinX) * 0.5;
         var _loc17_:Number = (param1.boundMaxY - param1.boundMinY) * 0.5;
         var _loc18_:Number = (param1.boundMaxZ - param1.boundMinZ) * 0.5;
         var _loc19_:Number = this.oma * (boundMinX + _loc4_) + this.omb * (boundMinY + _loc5_) + this.omc * (boundMinZ + _loc6_) + this.omd - param1.boundMinX - _loc16_;
         var _loc20_:Number = this.ome * (boundMinX + _loc4_) + this.omf * (boundMinY + _loc5_) + this.omg * (boundMinZ + _loc6_) + this.omh - param1.boundMinY - _loc17_;
         var _loc21_:Number = this.omi * (boundMinX + _loc4_) + this.omj * (boundMinY + _loc5_) + this.omk * (boundMinZ + _loc6_) + this.oml - param1.boundMinZ - _loc18_;
         _loc2_ = 0;
         _loc3_ = _loc7_ >= 0?Number(Number(_loc7_)):Number(Number(-_loc7_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = _loc10_ >= 0?Number(Number(_loc10_)):Number(Number(-_loc10_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = _loc13_ >= 0?Number(Number(_loc13_)):Number(Number(-_loc13_));
         _loc2_ = _loc2_ + _loc3_;
         _loc2_ = _loc2_ + _loc16_;
         _loc3_ = _loc19_ >= 0?Number(Number(_loc19_)):Number(Number(-_loc19_));
         _loc2_ = _loc2_ - _loc3_;
         if(_loc2_ <= 0)
         {
            return false;
         }
         _loc2_ = 0;
         _loc3_ = _loc8_ >= 0?Number(Number(_loc8_)):Number(Number(-_loc8_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = _loc11_ >= 0?Number(Number(_loc11_)):Number(Number(-_loc11_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = _loc14_ >= 0?Number(Number(_loc14_)):Number(Number(-_loc14_));
         _loc2_ = _loc2_ + _loc3_;
         _loc2_ = _loc2_ + _loc17_;
         _loc3_ = _loc20_ >= 0?Number(Number(_loc20_)):Number(Number(-_loc20_));
         _loc2_ = _loc2_ - _loc3_;
         if(_loc2_ <= 0)
         {
            return false;
         }
         _loc2_ = 0;
         _loc3_ = _loc9_ >= 0?Number(Number(_loc9_)):Number(Number(-_loc9_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = _loc12_ >= 0?Number(Number(_loc12_)):Number(Number(-_loc12_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = _loc15_ >= 0?Number(Number(_loc15_)):Number(Number(-_loc15_));
         _loc2_ = _loc2_ + _loc3_;
         _loc2_ = _loc2_ + _loc17_;
         _loc3_ = _loc21_ >= 0?Number(Number(_loc21_)):Number(Number(-_loc21_));
         _loc2_ = _loc2_ - _loc3_;
         if(_loc2_ <= 0)
         {
            return false;
         }
         _loc2_ = 0;
         _loc3_ = this.oma * _loc7_ + this.ome * _loc8_ + this.omi * _loc9_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.oma * _loc10_ + this.ome * _loc11_ + this.omi * _loc12_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.oma * _loc13_ + this.ome * _loc14_ + this.omi * _loc15_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.oma >= 0?Number(Number(this.oma * _loc16_)):Number(Number(-this.oma * _loc16_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.ome >= 0?Number(Number(this.ome * _loc17_)):Number(Number(-this.ome * _loc17_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omi >= 0?Number(Number(this.omi * _loc18_)):Number(Number(-this.omi * _loc18_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.oma * _loc19_ + this.ome * _loc20_ + this.omi * _loc21_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ - _loc3_;
         if(_loc2_ <= 0)
         {
            return false;
         }
         _loc2_ = 0;
         _loc3_ = this.omb * _loc7_ + this.omf * _loc8_ + this.omj * _loc9_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omb * _loc10_ + this.omf * _loc11_ + this.omj * _loc12_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omb * _loc13_ + this.omf * _loc14_ + this.omj * _loc15_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omb >= 0?Number(Number(this.omb * _loc16_)):Number(Number(-this.omb * _loc16_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omf >= 0?Number(Number(this.omf * _loc17_)):Number(Number(-this.omf * _loc17_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omj >= 0?Number(Number(this.omj * _loc18_)):Number(Number(-this.omj * _loc18_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omb * _loc19_ + this.omf * _loc20_ + this.omj * _loc21_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ - _loc3_;
         if(_loc2_ <= 0)
         {
            return false;
         }
         _loc2_ = 0;
         _loc3_ = this.omc * _loc7_ + this.omg * _loc8_ + this.omk * _loc9_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omc * _loc10_ + this.omg * _loc11_ + this.omk * _loc12_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omc * _loc13_ + this.omg * _loc14_ + this.omk * _loc15_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omc >= 0?Number(Number(this.omc * _loc16_)):Number(Number(-this.omc * _loc16_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omg >= 0?Number(Number(this.omg * _loc17_)):Number(Number(-this.omg * _loc17_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omk >= 0?Number(Number(this.omk * _loc18_)):Number(Number(-this.omk * _loc18_));
         _loc2_ = _loc2_ + _loc3_;
         _loc3_ = this.omc * _loc19_ + this.omg * _loc20_ + this.omk * _loc21_;
         _loc3_ = _loc3_ >= 0?Number(Number(_loc3_)):Number(Number(-_loc3_));
         _loc2_ = _loc2_ - _loc3_;
         if(_loc2_ <= 0)
         {
            return false;
         }
         return true;
      }
   }
}
