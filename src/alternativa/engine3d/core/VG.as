package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class VG
   {
      
      private static var collector:VG;
       
      
      alternativa3d var next:VG;
      
      alternativa3d var faceStruct:Face;
      
      alternativa3d var object:Object3D;
      
      alternativa3d var sorting:int;
      
      alternativa3d var debug:int = 0;
      
      alternativa3d var space:int = 0;
      
      alternativa3d var viewAligned:Boolean = false;
      
      alternativa3d var boundMinX:Number;
      
      alternativa3d var boundMinY:Number;
      
      alternativa3d var boundMinZ:Number;
      
      alternativa3d var boundMaxX:Number;
      
      alternativa3d var boundMaxY:Number;
      
      alternativa3d var boundMaxZ:Number;
      
      alternativa3d var boundMin:Number;
      
      alternativa3d var boundMax:Number;
      
      alternativa3d var boundVertexList:Vertex;
      
      alternativa3d var boundPlaneList:Vertex;
      
      alternativa3d var numOccluders:int;
      
      public function VG()
      {
         this.boundVertexList = Vertex.createList(8);
         this.boundPlaneList = Vertex.createList(6);
         super();
      }
      
      alternativa3d static function create(param1:Object3D, param2:Face, param3:int, param4:int, param5:Boolean) : VG
      {
         var _loc6_:VG = null;
         if(collector != null)
         {
            _loc6_ = collector;
            collector = collector.next;
            _loc6_.next = null;
         }
         else
         {
            _loc6_ = new VG();
         }
         _loc6_.object = param1;
         _loc6_.faceStruct = param2;
         _loc6_.sorting = param3;
         _loc6_.debug = param4;
         _loc6_.viewAligned = param5;
         return _loc6_;
      }
      
      alternativa3d function destroy() : void
      {
         if(this.faceStruct != null)
         {
            this.destroyFaceStruct(this.faceStruct);
            this.faceStruct = null;
         }
         this.object = null;
         this.numOccluders = 0;
         this.debug = 0;
         this.space = 0;
         this.next = collector;
         collector = this;
      }
      
      private function destroyFaceStruct(param1:Face) : void
      {
         if(param1.processNegative != null)
         {
            this.destroyFaceStruct(param1.processNegative);
            param1.processNegative = null;
         }
         if(param1.processPositive != null)
         {
            this.destroyFaceStruct(param1.processPositive);
            param1.processPositive = null;
         }
         var _loc2_:Face = param1.processNext;
         while(_loc2_ != null)
         {
            param1.processNext = null;
            param1 = _loc2_;
            _loc2_ = param1.processNext;
         }
      }
      
      alternativa3d function calculateAABB(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number) : void
      {
         this.boundMinX = 1.0e22;
         this.boundMinY = 1.0e22;
         this.boundMinZ = 1.0e22;
         this.boundMaxX = -1.0e22;
         this.boundMaxY = -1.0e22;
         this.boundMaxZ = -1.0e22;
         this.calculateAABBStruct(this.faceStruct,++this.object.transformId,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         this.space = 1;
      }
      
      alternativa3d function calculateOOBB(param1:Object3D) : void
      {
         var _loc2_:Vertex = null;
         var _loc3_:Vertex = null;
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Vertex = null;
         var _loc7_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc9_:Vertex = null;
         var _loc10_:Vertex = null;
         var _loc11_:Vertex = null;
         var _loc12_:Vertex = null;
         var _loc13_:Number = NaN;
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
         var _loc27_:Vertex = null;
         var _loc28_:Vertex = null;
         var _loc29_:Vertex = null;
         if(this.space == 1)
         {
            this.transformStruct(this.faceStruct,++this.object.transformId,param1.ma,param1.mb,param1.mc,param1.md,param1.me,param1.mf,param1.mg,param1.mh,param1.mi,param1.mj,param1.mk,param1.ml);
         }
         if(!this.viewAligned)
         {
            this.boundMinX = 1.0e22;
            this.boundMinY = 1.0e22;
            this.boundMinZ = 1.0e22;
            this.boundMaxX = -1.0e22;
            this.boundMaxY = -1.0e22;
            this.boundMaxZ = -1.0e22;
            this.calculateOOBBStruct(this.faceStruct,++this.object.transformId,this.object.ima,this.object.imb,this.object.imc,this.object.imd,this.object.ime,this.object.imf,this.object.img,this.object.imh,this.object.imi,this.object.imj,this.object.imk,this.object.iml);
            if(this.boundMaxX - this.boundMinX < 1)
            {
               this.boundMaxX = this.boundMinX + 1;
            }
            if(this.boundMaxY - this.boundMinY < 1)
            {
               this.boundMaxY = this.boundMinY + 1;
            }
            if(this.boundMaxZ - this.boundMinZ < 1)
            {
               this.boundMaxZ = this.boundMinZ + 1;
            }
            _loc2_ = this.boundVertexList;
            _loc2_.x = this.boundMinX;
            _loc2_.y = this.boundMinY;
            _loc2_.z = this.boundMinZ;
            _loc3_ = _loc2_.next;
            _loc3_.x = this.boundMaxX;
            _loc3_.y = this.boundMinY;
            _loc3_.z = this.boundMinZ;
            _loc4_ = _loc3_.next;
            _loc4_.x = this.boundMinX;
            _loc4_.y = this.boundMaxY;
            _loc4_.z = this.boundMinZ;
            _loc5_ = _loc4_.next;
            _loc5_.x = this.boundMaxX;
            _loc5_.y = this.boundMaxY;
            _loc5_.z = this.boundMinZ;
            _loc6_ = _loc5_.next;
            _loc6_.x = this.boundMinX;
            _loc6_.y = this.boundMinY;
            _loc6_.z = this.boundMaxZ;
            _loc7_ = _loc6_.next;
            _loc7_.x = this.boundMaxX;
            _loc7_.y = this.boundMinY;
            _loc7_.z = this.boundMaxZ;
            _loc8_ = _loc7_.next;
            _loc8_.x = this.boundMinX;
            _loc8_.y = this.boundMaxY;
            _loc8_.z = this.boundMaxZ;
            _loc9_ = _loc8_.next;
            _loc9_.x = this.boundMaxX;
            _loc9_.y = this.boundMaxY;
            _loc9_.z = this.boundMaxZ;
            _loc10_ = _loc2_;
            while(_loc10_ != null)
            {
               _loc10_.cameraX = this.object.ma * _loc10_.x + this.object.mb * _loc10_.y + this.object.mc * _loc10_.z + this.object.md;
               _loc10_.cameraY = this.object.me * _loc10_.x + this.object.mf * _loc10_.y + this.object.mg * _loc10_.z + this.object.mh;
               _loc10_.cameraZ = this.object.mi * _loc10_.x + this.object.mj * _loc10_.y + this.object.mk * _loc10_.z + this.object.ml;
               _loc10_ = _loc10_.next;
            }
            _loc11_ = this.boundPlaneList;
            _loc12_ = _loc11_.next;
            _loc13_ = _loc2_.cameraX;
            _loc14_ = _loc2_.cameraY;
            _loc15_ = _loc2_.cameraZ;
            _loc16_ = _loc3_.cameraX - _loc13_;
            _loc17_ = _loc3_.cameraY - _loc14_;
            _loc18_ = _loc3_.cameraZ - _loc15_;
            _loc19_ = _loc6_.cameraX - _loc13_;
            _loc20_ = _loc6_.cameraY - _loc14_;
            _loc21_ = _loc6_.cameraZ - _loc15_;
            _loc22_ = _loc21_ * _loc17_ - _loc20_ * _loc18_;
            _loc23_ = _loc19_ * _loc18_ - _loc21_ * _loc16_;
            _loc24_ = _loc20_ * _loc16_ - _loc19_ * _loc17_;
            _loc25_ = 1 / Math.sqrt(_loc22_ * _loc22_ + _loc23_ * _loc23_ + _loc24_ * _loc24_);
            _loc22_ = _loc22_ * _loc25_;
            _loc23_ = _loc23_ * _loc25_;
            _loc24_ = _loc24_ * _loc25_;
            _loc11_.cameraX = _loc22_;
            _loc11_.cameraY = _loc23_;
            _loc11_.cameraZ = _loc24_;
            _loc11_.offset = _loc13_ * _loc22_ + _loc14_ * _loc23_ + _loc15_ * _loc24_;
            _loc12_.cameraX = -_loc22_;
            _loc12_.cameraY = -_loc23_;
            _loc12_.cameraZ = -_loc24_;
            _loc12_.offset = -_loc4_.cameraX * _loc22_ - _loc4_.cameraY * _loc23_ - _loc4_.cameraZ * _loc24_;
            _loc26_ = _loc12_.next;
            _loc27_ = _loc26_.next;
            _loc13_ = _loc2_.cameraX;
            _loc14_ = _loc2_.cameraY;
            _loc15_ = _loc2_.cameraZ;
            _loc16_ = _loc6_.cameraX - _loc13_;
            _loc17_ = _loc6_.cameraY - _loc14_;
            _loc18_ = _loc6_.cameraZ - _loc15_;
            _loc19_ = _loc4_.cameraX - _loc13_;
            _loc20_ = _loc4_.cameraY - _loc14_;
            _loc21_ = _loc4_.cameraZ - _loc15_;
            _loc22_ = _loc21_ * _loc17_ - _loc20_ * _loc18_;
            _loc23_ = _loc19_ * _loc18_ - _loc21_ * _loc16_;
            _loc24_ = _loc20_ * _loc16_ - _loc19_ * _loc17_;
            _loc25_ = 1 / Math.sqrt(_loc22_ * _loc22_ + _loc23_ * _loc23_ + _loc24_ * _loc24_);
            _loc22_ = _loc22_ * _loc25_;
            _loc23_ = _loc23_ * _loc25_;
            _loc24_ = _loc24_ * _loc25_;
            _loc26_.cameraX = _loc22_;
            _loc26_.cameraY = _loc23_;
            _loc26_.cameraZ = _loc24_;
            _loc26_.offset = _loc13_ * _loc22_ + _loc14_ * _loc23_ + _loc15_ * _loc24_;
            _loc27_.cameraX = -_loc22_;
            _loc27_.cameraY = -_loc23_;
            _loc27_.cameraZ = -_loc24_;
            _loc27_.offset = -_loc3_.cameraX * _loc22_ - _loc3_.cameraY * _loc23_ - _loc3_.cameraZ * _loc24_;
            _loc28_ = _loc27_.next;
            _loc29_ = _loc28_.next;
            _loc13_ = _loc6_.cameraX;
            _loc14_ = _loc6_.cameraY;
            _loc15_ = _loc6_.cameraZ;
            _loc16_ = _loc7_.cameraX - _loc13_;
            _loc17_ = _loc7_.cameraY - _loc14_;
            _loc18_ = _loc7_.cameraZ - _loc15_;
            _loc19_ = _loc8_.cameraX - _loc13_;
            _loc20_ = _loc8_.cameraY - _loc14_;
            _loc21_ = _loc8_.cameraZ - _loc15_;
            _loc22_ = _loc21_ * _loc17_ - _loc20_ * _loc18_;
            _loc23_ = _loc19_ * _loc18_ - _loc21_ * _loc16_;
            _loc24_ = _loc20_ * _loc16_ - _loc19_ * _loc17_;
            _loc25_ = 1 / Math.sqrt(_loc22_ * _loc22_ + _loc23_ * _loc23_ + _loc24_ * _loc24_);
            _loc22_ = _loc22_ * _loc25_;
            _loc23_ = _loc23_ * _loc25_;
            _loc24_ = _loc24_ * _loc25_;
            _loc28_.cameraX = _loc22_;
            _loc28_.cameraY = _loc23_;
            _loc28_.cameraZ = _loc24_;
            _loc28_.offset = _loc13_ * _loc22_ + _loc14_ * _loc23_ + _loc15_ * _loc24_;
            _loc29_.cameraX = -_loc22_;
            _loc29_.cameraY = -_loc23_;
            _loc29_.cameraZ = -_loc24_;
            _loc29_.offset = -_loc2_.cameraX * _loc22_ - _loc2_.cameraY * _loc23_ - _loc2_.cameraZ * _loc24_;
            if(_loc11_.offset < -_loc12_.offset)
            {
               _loc12_.cameraX = -_loc12_.cameraX;
               _loc12_.cameraY = -_loc12_.cameraY;
               _loc12_.cameraZ = -_loc12_.cameraZ;
               _loc12_.offset = -_loc12_.offset;
               _loc11_.cameraX = -_loc11_.cameraX;
               _loc11_.cameraY = -_loc11_.cameraY;
               _loc11_.cameraZ = -_loc11_.cameraZ;
               _loc11_.offset = -_loc11_.offset;
            }
            if(_loc26_.offset < -_loc27_.offset)
            {
               _loc26_.cameraX = -_loc26_.cameraX;
               _loc26_.cameraY = -_loc26_.cameraY;
               _loc26_.cameraZ = -_loc26_.cameraZ;
               _loc26_.offset = -_loc26_.offset;
               _loc27_.cameraX = -_loc27_.cameraX;
               _loc27_.cameraY = -_loc27_.cameraY;
               _loc27_.cameraZ = -_loc27_.cameraZ;
               _loc27_.offset = -_loc27_.offset;
            }
            if(_loc29_.offset < -_loc28_.offset)
            {
               _loc29_.cameraX = -_loc29_.cameraX;
               _loc29_.cameraY = -_loc29_.cameraY;
               _loc29_.cameraZ = -_loc29_.cameraZ;
               _loc29_.offset = -_loc29_.offset;
               _loc28_.cameraX = -_loc28_.cameraX;
               _loc28_.cameraY = -_loc28_.cameraY;
               _loc28_.cameraZ = -_loc28_.cameraZ;
               _loc28_.offset = -_loc28_.offset;
            }
         }
         this.space = 2;
      }
      
      private function calculateAABBStruct(param1:Face, param2:int, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number) : void
      {
         var _loc16_:Wrapper = null;
         var _loc17_:Vertex = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc15_:Face = param1;
         while(_loc15_ != null)
         {
            _loc16_ = _loc15_.wrapper;
            while(_loc16_ != null)
            {
               _loc17_ = _loc16_.vertex;
               if(_loc17_.transformId != param2)
               {
                  _loc18_ = _loc17_.cameraX;
                  _loc19_ = _loc17_.cameraY;
                  _loc20_ = _loc17_.cameraZ;
                  _loc17_.cameraX = param3 * _loc18_ + param4 * _loc19_ + param5 * _loc20_ + param6;
                  _loc17_.cameraY = param7 * _loc18_ + param8 * _loc19_ + param9 * _loc20_ + param10;
                  _loc17_.cameraZ = param11 * _loc18_ + param12 * _loc19_ + param13 * _loc20_ + param14;
                  if(_loc17_.cameraX < this.boundMinX)
                  {
                     this.boundMinX = _loc17_.cameraX;
                  }
                  if(_loc17_.cameraX > this.boundMaxX)
                  {
                     this.boundMaxX = _loc17_.cameraX;
                  }
                  if(_loc17_.cameraY < this.boundMinY)
                  {
                     this.boundMinY = _loc17_.cameraY;
                  }
                  if(_loc17_.cameraY > this.boundMaxY)
                  {
                     this.boundMaxY = _loc17_.cameraY;
                  }
                  if(_loc17_.cameraZ < this.boundMinZ)
                  {
                     this.boundMinZ = _loc17_.cameraZ;
                  }
                  if(_loc17_.cameraZ > this.boundMaxZ)
                  {
                     this.boundMaxZ = _loc17_.cameraZ;
                  }
                  _loc17_.transformId = param2;
               }
               _loc16_ = _loc16_.next;
            }
            _loc15_ = _loc15_.processNext;
         }
         if(param1.processNegative != null)
         {
            this.calculateAABBStruct(param1.processNegative,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         }
         if(param1.processPositive != null)
         {
            this.calculateAABBStruct(param1.processPositive,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         }
      }
      
      private function calculateOOBBStruct(param1:Face, param2:int, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number) : void
      {
         var _loc16_:Wrapper = null;
         var _loc17_:Vertex = null;
         var _loc15_:Face = param1;
         while(_loc15_ != null)
         {
            _loc16_ = _loc15_.wrapper;
            while(_loc16_ != null)
            {
               _loc17_ = _loc16_.vertex;
               if(_loc17_.transformId != param2)
               {
                  if(_loc17_.x < this.boundMinX)
                  {
                     this.boundMinX = _loc17_.x;
                  }
                  if(_loc17_.x > this.boundMaxX)
                  {
                     this.boundMaxX = _loc17_.x;
                  }
                  if(_loc17_.y < this.boundMinY)
                  {
                     this.boundMinY = _loc17_.y;
                  }
                  if(_loc17_.y > this.boundMaxY)
                  {
                     this.boundMaxY = _loc17_.y;
                  }
                  if(_loc17_.z < this.boundMinZ)
                  {
                     this.boundMinZ = _loc17_.z;
                  }
                  if(_loc17_.z > this.boundMaxZ)
                  {
                     this.boundMaxZ = _loc17_.z;
                  }
                  _loc17_.transformId = param2;
               }
               _loc16_ = _loc16_.next;
            }
            _loc15_ = _loc15_.processNext;
         }
         if(param1.processNegative != null)
         {
            this.calculateOOBBStruct(param1.processNegative,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         }
         if(param1.processPositive != null)
         {
            this.calculateOOBBStruct(param1.processPositive,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         }
      }
      
      private function updateAABBStruct(param1:Face, param2:int) : void
      {
         var _loc4_:Wrapper = null;
         var _loc5_:Vertex = null;
         var _loc3_:Face = param1;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.wrapper;
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_.vertex;
               if(_loc5_.transformId != param2)
               {
                  if(_loc5_.cameraX < this.boundMinX)
                  {
                     this.boundMinX = _loc5_.cameraX;
                  }
                  if(_loc5_.cameraX > this.boundMaxX)
                  {
                     this.boundMaxX = _loc5_.cameraX;
                  }
                  if(_loc5_.cameraY < this.boundMinY)
                  {
                     this.boundMinY = _loc5_.cameraY;
                  }
                  if(_loc5_.cameraY > this.boundMaxY)
                  {
                     this.boundMaxY = _loc5_.cameraY;
                  }
                  if(_loc5_.cameraZ < this.boundMinZ)
                  {
                     this.boundMinZ = _loc5_.cameraZ;
                  }
                  if(_loc5_.cameraZ > this.boundMaxZ)
                  {
                     this.boundMaxZ = _loc5_.cameraZ;
                  }
                  _loc5_.transformId = param2;
               }
               _loc4_ = _loc4_.next;
            }
            _loc3_ = _loc3_.processNext;
         }
         if(param1.processNegative != null)
         {
            this.updateAABBStruct(param1.processNegative,param2);
         }
         if(param1.processPositive != null)
         {
            this.updateAABBStruct(param1.processPositive,param2);
         }
      }
      
      alternativa3d function split(param1:Camera3D, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc8_:VG = null;
         var _loc7_:Face = this.faceStruct.create();
         this.splitFaceStruct(param1,this.faceStruct,_loc7_,param2,param3,param4,param5,param5 - param6,param5 + param6);
         if(_loc7_.processNegative != null)
         {
            if(collector != null)
            {
               _loc8_ = collector;
               collector = collector.next;
               _loc8_.next = null;
            }
            else
            {
               _loc8_ = new VG();
            }
            this.next = _loc8_;
            _loc8_.faceStruct = _loc7_.processNegative;
            _loc7_.processNegative = null;
            _loc8_.object = this.object;
            _loc8_.sorting = this.sorting;
            _loc8_.debug = this.debug;
            _loc8_.space = this.space;
            _loc8_.viewAligned = this.viewAligned;
            _loc8_.boundMinX = 1.0e22;
            _loc8_.boundMinY = 1.0e22;
            _loc8_.boundMinZ = 1.0e22;
            _loc8_.boundMaxX = -1.0e22;
            _loc8_.boundMaxY = -1.0e22;
            _loc8_.boundMaxZ = -1.0e22;
            _loc8_.updateAABBStruct(_loc8_.faceStruct,++this.object.transformId);
         }
         else
         {
            this.next = null;
         }
         if(_loc7_.processPositive != null)
         {
            this.faceStruct = _loc7_.processPositive;
            _loc7_.processPositive = null;
            this.boundMinX = 1.0e22;
            this.boundMinY = 1.0e22;
            this.boundMinZ = 1.0e22;
            this.boundMaxX = -1.0e22;
            this.boundMaxY = -1.0e22;
            this.boundMaxZ = -1.0e22;
            this.updateAABBStruct(this.faceStruct,++this.object.transformId);
         }
         else
         {
            this.faceStruct = null;
         }
         _loc7_.next = Face.collector;
         Face.collector = _loc7_;
      }
      
      alternativa3d function crop(param1:Camera3D, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.faceStruct = this.cropFaceStruct(param1,this.faceStruct,param2,param3,param4,param5,param5 - param6,param5 + param6);
         if(this.faceStruct != null)
         {
            this.boundMinX = 1.0e22;
            this.boundMinY = 1.0e22;
            this.boundMinZ = 1.0e22;
            this.boundMaxX = -1.0e22;
            this.boundMaxY = -1.0e22;
            this.boundMaxZ = -1.0e22;
            this.updateAABBStruct(this.faceStruct,++this.object.transformId);
         }
      }
      
      private function splitFaceStruct(param1:Camera3D, param2:Face, param3:Face, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
      {
         var _loc10_:Face = null;
         var _loc11_:Face = null;
         var _loc12_:Wrapper = null;
         var _loc13_:Vertex = null;
         var _loc14_:Vertex = null;
         var _loc15_:Face = null;
         var _loc16_:Face = null;
         var _loc17_:Face = null;
         var _loc18_:Face = null;
         var _loc19_:Face = null;
         var _loc20_:Face = null;
         var _loc21_:Face = null;
         var _loc22_:Face = null;
         var _loc23_:Face = null;
         var _loc24_:Face = null;
         var _loc25_:Wrapper = null;
         var _loc26_:Wrapper = null;
         var _loc27_:Wrapper = null;
         var _loc28_:Boolean = false;
         var _loc29_:Vertex = null;
         var _loc30_:Vertex = null;
         var _loc31_:Vertex = null;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Boolean = false;
         var _loc36_:Boolean = false;
         var _loc37_:Boolean = false;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         if(param2.processNegative != null)
         {
            this.splitFaceStruct(param1,param2.processNegative,param3,param4,param5,param6,param7,param8,param9);
            param2.processNegative = null;
            _loc15_ = param3.processNegative;
            _loc16_ = param3.processPositive;
         }
         if(param2.processPositive != null)
         {
            this.splitFaceStruct(param1,param2.processPositive,param3,param4,param5,param6,param7,param8,param9);
            param2.processPositive = null;
            _loc17_ = param3.processNegative;
            _loc18_ = param3.processPositive;
         }
         if(param2.wrapper != null)
         {
            _loc10_ = param2;
            while(_loc10_ != null)
            {
               _loc11_ = _loc10_.processNext;
               _loc12_ = _loc10_.wrapper;
               _loc29_ = _loc12_.vertex;
               _loc12_ = _loc12_.next;
               _loc30_ = _loc12_.vertex;
               _loc12_ = _loc12_.next;
               _loc31_ = _loc12_.vertex;
               _loc12_ = _loc12_.next;
               _loc32_ = _loc29_.cameraX * param4 + _loc29_.cameraY * param5 + _loc29_.cameraZ * param6;
               _loc33_ = _loc30_.cameraX * param4 + _loc30_.cameraY * param5 + _loc30_.cameraZ * param6;
               _loc34_ = _loc31_.cameraX * param4 + _loc31_.cameraY * param5 + _loc31_.cameraZ * param6;
               _loc35_ = _loc32_ < param8 || _loc33_ < param8 || _loc34_ < param8;
               _loc36_ = _loc32_ > param9 || _loc33_ > param9 || _loc34_ > param9;
               _loc37_ = _loc32_ < param8 && _loc33_ < param8 && _loc34_ < param8;
               while(_loc12_ != null)
               {
                  _loc13_ = _loc12_.vertex;
                  _loc38_ = _loc13_.cameraX * param4 + _loc13_.cameraY * param5 + _loc13_.cameraZ * param6;
                  if(_loc38_ < param8)
                  {
                     _loc35_ = true;
                  }
                  else
                  {
                     _loc37_ = false;
                     if(_loc38_ > param9)
                     {
                        _loc36_ = true;
                     }
                  }
                  _loc13_.offset = _loc38_;
                  _loc12_ = _loc12_.next;
               }
               if(!_loc35_)
               {
                  if(_loc21_ != null)
                  {
                     _loc22_.processNext = _loc10_;
                  }
                  else
                  {
                     _loc21_ = _loc10_;
                  }
                  _loc22_ = _loc10_;
               }
               else if(!_loc36_)
               {
                  if(_loc37_)
                  {
                     if(_loc19_ != null)
                     {
                        _loc20_.processNext = _loc10_;
                     }
                     else
                     {
                        _loc19_ = _loc10_;
                     }
                     _loc20_ = _loc10_;
                  }
                  else
                  {
                     _loc29_.offset = _loc32_;
                     _loc30_.offset = _loc33_;
                     _loc31_.offset = _loc34_;
                     _loc23_ = _loc10_.create();
                     _loc23_.material = _loc10_.material;
                     param1.lastFace.next = _loc23_;
                     param1.lastFace = _loc23_;
                     _loc25_ = null;
                     _loc28_ = _loc10_.material != null && _loc10_.material.useVerticesNormals;
                     _loc12_ = _loc10_.wrapper;
                     while(_loc12_ != null)
                     {
                        _loc30_ = _loc12_.vertex;
                        if(_loc30_.offset >= param8)
                        {
                           _loc14_ = _loc30_.create();
                           param1.lastVertex.next = _loc14_;
                           param1.lastVertex = _loc14_;
                           _loc14_.x = _loc30_.x;
                           _loc14_.y = _loc30_.y;
                           _loc14_.z = _loc30_.z;
                           _loc14_.u = _loc30_.u;
                           _loc14_.v = _loc30_.v;
                           _loc14_.cameraX = _loc30_.cameraX;
                           _loc14_.cameraY = _loc30_.cameraY;
                           _loc14_.cameraZ = _loc30_.cameraZ;
                           if(_loc28_)
                           {
                              _loc14_.normalX = _loc30_.normalX;
                              _loc14_.normalY = _loc30_.normalY;
                              _loc14_.normalZ = _loc30_.normalZ;
                           }
                           _loc30_ = _loc14_;
                        }
                        _loc27_ = _loc12_.create();
                        _loc27_.vertex = _loc30_;
                        if(_loc25_ != null)
                        {
                           _loc25_.next = _loc27_;
                        }
                        else
                        {
                           _loc23_.wrapper = _loc27_;
                        }
                        _loc25_ = _loc27_;
                        _loc12_ = _loc12_.next;
                     }
                     if(_loc19_ != null)
                     {
                        _loc20_.processNext = _loc23_;
                     }
                     else
                     {
                        _loc19_ = _loc23_;
                     }
                     _loc20_ = _loc23_;
                     _loc10_.processNext = null;
                  }
               }
               else
               {
                  _loc29_.offset = _loc32_;
                  _loc30_.offset = _loc33_;
                  _loc31_.offset = _loc34_;
                  _loc23_ = _loc10_.create();
                  _loc23_.material = _loc10_.material;
                  param1.lastFace.next = _loc23_;
                  param1.lastFace = _loc23_;
                  _loc24_ = _loc10_.create();
                  _loc24_.material = _loc10_.material;
                  param1.lastFace.next = _loc24_;
                  param1.lastFace = _loc24_;
                  _loc25_ = null;
                  _loc26_ = null;
                  _loc12_ = _loc10_.wrapper.next.next;
                  while(_loc12_.next != null)
                  {
                     _loc12_ = _loc12_.next;
                  }
                  _loc29_ = _loc12_.vertex;
                  _loc32_ = _loc29_.offset;
                  _loc28_ = _loc10_.material != null && _loc10_.material.useVerticesNormals;
                  _loc12_ = _loc10_.wrapper;
                  while(_loc12_ != null)
                  {
                     _loc30_ = _loc12_.vertex;
                     _loc33_ = _loc30_.offset;
                     if(_loc32_ < param8 && _loc33_ > param9 || _loc32_ > param9 && _loc33_ < param8)
                     {
                        _loc39_ = (param7 - _loc32_) / (_loc33_ - _loc32_);
                        _loc13_ = _loc30_.create();
                        param1.lastVertex.next = _loc13_;
                        param1.lastVertex = _loc13_;
                        _loc13_.x = _loc29_.x + (_loc30_.x - _loc29_.x) * _loc39_;
                        _loc13_.y = _loc29_.y + (_loc30_.y - _loc29_.y) * _loc39_;
                        _loc13_.z = _loc29_.z + (_loc30_.z - _loc29_.z) * _loc39_;
                        _loc13_.u = _loc29_.u + (_loc30_.u - _loc29_.u) * _loc39_;
                        _loc13_.v = _loc29_.v + (_loc30_.v - _loc29_.v) * _loc39_;
                        _loc13_.cameraX = _loc29_.cameraX + (_loc30_.cameraX - _loc29_.cameraX) * _loc39_;
                        _loc13_.cameraY = _loc29_.cameraY + (_loc30_.cameraY - _loc29_.cameraY) * _loc39_;
                        _loc13_.cameraZ = _loc29_.cameraZ + (_loc30_.cameraZ - _loc29_.cameraZ) * _loc39_;
                        if(_loc28_)
                        {
                           _loc13_.normalX = _loc29_.normalX + (_loc30_.normalX - _loc29_.normalX) * _loc39_;
                           _loc13_.normalY = _loc29_.normalY + (_loc30_.normalY - _loc29_.normalY) * _loc39_;
                           _loc13_.normalZ = _loc29_.normalZ + (_loc30_.normalZ - _loc29_.normalZ) * _loc39_;
                        }
                        _loc27_ = _loc12_.create();
                        _loc27_.vertex = _loc13_;
                        if(_loc25_ != null)
                        {
                           _loc25_.next = _loc27_;
                        }
                        else
                        {
                           _loc23_.wrapper = _loc27_;
                        }
                        _loc25_ = _loc27_;
                        _loc14_ = _loc30_.create();
                        param1.lastVertex.next = _loc14_;
                        param1.lastVertex = _loc14_;
                        _loc14_.x = _loc13_.x;
                        _loc14_.y = _loc13_.y;
                        _loc14_.z = _loc13_.z;
                        _loc14_.u = _loc13_.u;
                        _loc14_.v = _loc13_.v;
                        _loc14_.cameraX = _loc13_.cameraX;
                        _loc14_.cameraY = _loc13_.cameraY;
                        _loc14_.cameraZ = _loc13_.cameraZ;
                        if(_loc28_)
                        {
                           _loc14_.normalX = _loc13_.normalX;
                           _loc14_.normalY = _loc13_.normalY;
                           _loc14_.normalZ = _loc13_.normalZ;
                        }
                        _loc27_ = _loc12_.create();
                        _loc27_.vertex = _loc14_;
                        if(_loc26_ != null)
                        {
                           _loc26_.next = _loc27_;
                        }
                        else
                        {
                           _loc24_.wrapper = _loc27_;
                        }
                        _loc26_ = _loc27_;
                     }
                     if(_loc30_.offset < param8)
                     {
                        _loc27_ = _loc12_.create();
                        _loc27_.vertex = _loc30_;
                        if(_loc25_ != null)
                        {
                           _loc25_.next = _loc27_;
                        }
                        else
                        {
                           _loc23_.wrapper = _loc27_;
                        }
                        _loc25_ = _loc27_;
                     }
                     else if(_loc30_.offset > param9)
                     {
                        _loc27_ = _loc12_.create();
                        _loc27_.vertex = _loc30_;
                        if(_loc26_ != null)
                        {
                           _loc26_.next = _loc27_;
                        }
                        else
                        {
                           _loc24_.wrapper = _loc27_;
                        }
                        _loc26_ = _loc27_;
                     }
                     else
                     {
                        _loc27_ = _loc12_.create();
                        _loc27_.vertex = _loc30_;
                        if(_loc26_ != null)
                        {
                           _loc26_.next = _loc27_;
                        }
                        else
                        {
                           _loc24_.wrapper = _loc27_;
                        }
                        _loc26_ = _loc27_;
                        _loc14_ = _loc30_.create();
                        param1.lastVertex.next = _loc14_;
                        param1.lastVertex = _loc14_;
                        _loc14_.x = _loc30_.x;
                        _loc14_.y = _loc30_.y;
                        _loc14_.z = _loc30_.z;
                        _loc14_.u = _loc30_.u;
                        _loc14_.v = _loc30_.v;
                        _loc14_.cameraX = _loc30_.cameraX;
                        _loc14_.cameraY = _loc30_.cameraY;
                        _loc14_.cameraZ = _loc30_.cameraZ;
                        if(_loc28_)
                        {
                           _loc14_.normalX = _loc30_.normalX;
                           _loc14_.normalY = _loc30_.normalY;
                           _loc14_.normalZ = _loc30_.normalZ;
                        }
                        _loc27_ = _loc12_.create();
                        _loc27_.vertex = _loc14_;
                        if(_loc25_ != null)
                        {
                           _loc25_.next = _loc27_;
                        }
                        else
                        {
                           _loc23_.wrapper = _loc27_;
                        }
                        _loc25_ = _loc27_;
                     }
                     _loc29_ = _loc30_;
                     _loc32_ = _loc33_;
                     _loc12_ = _loc12_.next;
                  }
                  if(_loc19_ != null)
                  {
                     _loc20_.processNext = _loc23_;
                  }
                  else
                  {
                     _loc19_ = _loc23_;
                  }
                  _loc20_ = _loc23_;
                  if(_loc21_ != null)
                  {
                     _loc22_.processNext = _loc24_;
                  }
                  else
                  {
                     _loc21_ = _loc24_;
                  }
                  _loc22_ = _loc24_;
                  _loc10_.processNext = null;
               }
               _loc10_ = _loc11_;
            }
         }
         if(_loc19_ != null || _loc15_ != null && _loc17_ != null)
         {
            if(_loc19_ == null)
            {
               _loc19_ = param2.create();
               param1.lastFace.next = _loc19_;
               param1.lastFace = _loc19_;
            }
            else
            {
               _loc20_.processNext = null;
            }
            if(this.sorting == 3)
            {
               _loc19_.normalX = param2.normalX;
               _loc19_.normalY = param2.normalY;
               _loc19_.normalZ = param2.normalZ;
               _loc19_.offset = param2.offset;
            }
            _loc19_.processNegative = _loc15_;
            _loc19_.processPositive = _loc17_;
            param3.processNegative = _loc19_;
         }
         else
         {
            param3.processNegative = _loc15_ != null?_loc15_:_loc17_;
         }
         if(_loc21_ != null || _loc16_ != null && _loc18_ != null)
         {
            if(_loc21_ == null)
            {
               _loc21_ = param2.create();
               param1.lastFace.next = _loc21_;
               param1.lastFace = _loc21_;
            }
            else
            {
               _loc22_.processNext = null;
            }
            if(this.sorting == 3)
            {
               _loc21_.normalX = param2.normalX;
               _loc21_.normalY = param2.normalY;
               _loc21_.normalZ = param2.normalZ;
               _loc21_.offset = param2.offset;
            }
            _loc21_.processNegative = _loc16_;
            _loc21_.processPositive = _loc18_;
            param3.processPositive = _loc21_;
         }
         else
         {
            param3.processPositive = _loc16_ != null?_loc16_:_loc18_;
         }
      }
      
      private function cropFaceStruct(param1:Camera3D, param2:Face, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Face
      {
         var _loc9_:Face = null;
         var _loc10_:Face = null;
         var _loc11_:Wrapper = null;
         var _loc12_:Vertex = null;
         var _loc13_:Face = null;
         var _loc14_:Face = null;
         var _loc15_:Face = null;
         var _loc16_:Face = null;
         var _loc17_:Vertex = null;
         var _loc18_:Vertex = null;
         var _loc19_:Vertex = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Boolean = false;
         var _loc24_:Boolean = false;
         var _loc25_:Number = NaN;
         var _loc26_:Face = null;
         var _loc27_:Wrapper = null;
         var _loc28_:Wrapper = null;
         var _loc29_:Boolean = false;
         var _loc30_:Number = NaN;
         if(param2.processNegative != null)
         {
            _loc13_ = this.cropFaceStruct(param1,param2.processNegative,param3,param4,param5,param6,param7,param8);
            param2.processNegative = null;
         }
         if(param2.processPositive != null)
         {
            _loc14_ = this.cropFaceStruct(param1,param2.processPositive,param3,param4,param5,param6,param7,param8);
            param2.processPositive = null;
         }
         if(param2.wrapper != null)
         {
            _loc9_ = param2;
            while(_loc9_ != null)
            {
               _loc10_ = _loc9_.processNext;
               _loc11_ = _loc9_.wrapper;
               _loc17_ = _loc11_.vertex;
               _loc11_ = _loc11_.next;
               _loc18_ = _loc11_.vertex;
               _loc11_ = _loc11_.next;
               _loc19_ = _loc11_.vertex;
               _loc11_ = _loc11_.next;
               _loc20_ = _loc17_.cameraX * param3 + _loc17_.cameraY * param4 + _loc17_.cameraZ * param5;
               _loc21_ = _loc18_.cameraX * param3 + _loc18_.cameraY * param4 + _loc18_.cameraZ * param5;
               _loc22_ = _loc19_.cameraX * param3 + _loc19_.cameraY * param4 + _loc19_.cameraZ * param5;
               _loc23_ = _loc20_ < param7 || _loc21_ < param7 || _loc22_ < param7;
               _loc24_ = _loc20_ > param8 || _loc21_ > param8 || _loc22_ > param8;
               while(_loc11_ != null)
               {
                  _loc12_ = _loc11_.vertex;
                  _loc25_ = _loc12_.cameraX * param3 + _loc12_.cameraY * param4 + _loc12_.cameraZ * param5;
                  if(_loc25_ < param7)
                  {
                     _loc23_ = true;
                  }
                  else if(_loc25_ > param8)
                  {
                     _loc24_ = true;
                  }
                  _loc12_.offset = _loc25_;
                  _loc11_ = _loc11_.next;
               }
               if(!_loc24_)
               {
                  _loc9_.processNext = null;
               }
               else if(!_loc23_)
               {
                  if(_loc15_ != null)
                  {
                     _loc16_.processNext = _loc9_;
                  }
                  else
                  {
                     _loc15_ = _loc9_;
                  }
                  _loc16_ = _loc9_;
               }
               else
               {
                  _loc17_.offset = _loc20_;
                  _loc18_.offset = _loc21_;
                  _loc19_.offset = _loc22_;
                  _loc26_ = _loc9_.create();
                  _loc26_.material = _loc9_.material;
                  param1.lastFace.next = _loc26_;
                  param1.lastFace = _loc26_;
                  _loc27_ = null;
                  _loc11_ = _loc9_.wrapper.next.next;
                  while(_loc11_.next != null)
                  {
                     _loc11_ = _loc11_.next;
                  }
                  _loc17_ = _loc11_.vertex;
                  _loc20_ = _loc17_.offset;
                  _loc29_ = _loc9_.material != null && _loc9_.material.useVerticesNormals;
                  _loc11_ = _loc9_.wrapper;
                  while(_loc11_ != null)
                  {
                     _loc18_ = _loc11_.vertex;
                     _loc21_ = _loc18_.offset;
                     if(_loc20_ < param7 && _loc21_ > param8 || _loc20_ > param8 && _loc21_ < param7)
                     {
                        _loc30_ = (param6 - _loc20_) / (_loc21_ - _loc20_);
                        _loc12_ = _loc18_.create();
                        param1.lastVertex.next = _loc12_;
                        param1.lastVertex = _loc12_;
                        _loc12_.x = _loc17_.x + (_loc18_.x - _loc17_.x) * _loc30_;
                        _loc12_.y = _loc17_.y + (_loc18_.y - _loc17_.y) * _loc30_;
                        _loc12_.z = _loc17_.z + (_loc18_.z - _loc17_.z) * _loc30_;
                        _loc12_.u = _loc17_.u + (_loc18_.u - _loc17_.u) * _loc30_;
                        _loc12_.v = _loc17_.v + (_loc18_.v - _loc17_.v) * _loc30_;
                        _loc12_.cameraX = _loc17_.cameraX + (_loc18_.cameraX - _loc17_.cameraX) * _loc30_;
                        _loc12_.cameraY = _loc17_.cameraY + (_loc18_.cameraY - _loc17_.cameraY) * _loc30_;
                        _loc12_.cameraZ = _loc17_.cameraZ + (_loc18_.cameraZ - _loc17_.cameraZ) * _loc30_;
                        if(_loc29_)
                        {
                           _loc12_.normalX = _loc17_.normalX + (_loc18_.normalX - _loc17_.normalX) * _loc30_;
                           _loc12_.normalY = _loc17_.normalY + (_loc18_.normalY - _loc17_.normalY) * _loc30_;
                           _loc12_.normalZ = _loc17_.normalZ + (_loc18_.normalZ - _loc17_.normalZ) * _loc30_;
                        }
                        _loc28_ = _loc11_.create();
                        _loc28_.vertex = _loc12_;
                        if(_loc27_ != null)
                        {
                           _loc27_.next = _loc28_;
                        }
                        else
                        {
                           _loc26_.wrapper = _loc28_;
                        }
                        _loc27_ = _loc28_;
                     }
                     if(_loc21_ >= param7)
                     {
                        _loc28_ = _loc11_.create();
                        _loc28_.vertex = _loc18_;
                        if(_loc27_ != null)
                        {
                           _loc27_.next = _loc28_;
                        }
                        else
                        {
                           _loc26_.wrapper = _loc28_;
                        }
                        _loc27_ = _loc28_;
                     }
                     _loc17_ = _loc18_;
                     _loc20_ = _loc21_;
                     _loc11_ = _loc11_.next;
                  }
                  if(_loc15_ != null)
                  {
                     _loc16_.processNext = _loc26_;
                  }
                  else
                  {
                     _loc15_ = _loc26_;
                  }
                  _loc16_ = _loc26_;
                  _loc9_.processNext = null;
               }
               _loc9_ = _loc10_;
            }
         }
         if(_loc15_ != null || _loc13_ != null && _loc14_ != null)
         {
            if(_loc15_ == null)
            {
               _loc15_ = param2.create();
               param1.lastFace.next = _loc15_;
               param1.lastFace = _loc15_;
            }
            else
            {
               _loc16_.processNext = null;
            }
            if(this.sorting == 3)
            {
               _loc15_.normalX = param2.normalX;
               _loc15_.normalY = param2.normalY;
               _loc15_.normalZ = param2.normalZ;
               _loc15_.offset = param2.offset;
            }
            _loc15_.processNegative = _loc13_;
            _loc15_.processPositive = _loc14_;
            return _loc15_;
         }
         return _loc13_ != null?_loc13_:_loc14_;
      }
      
      alternativa3d function transformStruct(param1:Face, param2:int, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number) : void
      {
         var _loc16_:Wrapper = null;
         var _loc17_:Vertex = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc15_:Face = param1;
         while(_loc15_ != null)
         {
            _loc16_ = _loc15_.wrapper;
            while(_loc16_ != null)
            {
               _loc17_ = _loc16_.vertex;
               if(_loc17_.transformId != param2)
               {
                  _loc18_ = _loc17_.cameraX;
                  _loc19_ = _loc17_.cameraY;
                  _loc20_ = _loc17_.cameraZ;
                  _loc17_.cameraX = param3 * _loc18_ + param4 * _loc19_ + param5 * _loc20_ + param6;
                  _loc17_.cameraY = param7 * _loc18_ + param8 * _loc19_ + param9 * _loc20_ + param10;
                  _loc17_.cameraZ = param11 * _loc18_ + param12 * _loc19_ + param13 * _loc20_ + param14;
                  _loc17_.transformId = param2;
               }
               _loc16_ = _loc16_.next;
            }
            _loc15_ = _loc15_.processNext;
         }
         if(param1.processNegative != null)
         {
            this.transformStruct(param1.processNegative,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         }
         if(param1.processPositive != null)
         {
            this.transformStruct(param1.processPositive,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14);
         }
      }
      
      alternativa3d function draw(param1:Camera3D, param2:Number, param3:Object3D) : void
      {
         var _loc4_:Face = null;
         var _loc5_:Face = null;
         var _loc6_:Face = null;
         var _loc7_:Face = null;
         if(this.space == 1)
         {
            this.transformStruct(this.faceStruct,++this.object.transformId,param3.ma,param3.mb,param3.mc,param3.md,param3.me,param3.mf,param3.mg,param3.mh,param3.mi,param3.mj,param3.mk,param3.ml);
         }
         if(this.viewAligned)
         {
            _loc4_ = this.faceStruct;
            if(this.debug > 0)
            {
               if(this.debug & Debug.EDGES)
               {
                  Debug.drawEdges(param1,_loc4_,this.space != 2?int(int(16777215)):int(int(16750848)));
               }
               if(this.debug & Debug.BOUNDS)
               {
                  if(this.space == 1)
                  {
                     Debug.drawBounds(param1,param3,this.boundMinX,this.boundMinY,this.boundMinZ,this.boundMaxX,this.boundMaxY,this.boundMaxZ,10092288);
                  }
               }
            }
            param1.addTransparent(_loc4_,this.object);
         }
         else
         {
            switch(this.sorting)
            {
               case 0:
                  _loc4_ = this.faceStruct;
                  break;
               case 1:
                  _loc4_ = this.faceStruct.processNext != null?param1.sortByAverageZ(this.faceStruct):this.faceStruct;
                  break;
               case 2:
                  _loc4_ = this.faceStruct.processNext != null?param1.sortByDynamicBSP(this.faceStruct,param2):this.faceStruct;
                  break;
               case 3:
                  _loc4_ = this.collectNode(this.faceStruct);
            }
            if(this.debug > 0)
            {
               if(this.debug & Debug.EDGES)
               {
                  Debug.drawEdges(param1,_loc4_,16777215);
               }
               if(this.debug & Debug.BOUNDS)
               {
                  if(this.space == 1)
                  {
                     Debug.drawBounds(param1,param3,this.boundMinX,this.boundMinY,this.boundMinZ,this.boundMaxX,this.boundMaxY,this.boundMaxZ,10092288);
                  }
                  else if(this.space == 2)
                  {
                     Debug.drawBounds(param1,this.object,this.boundMinX,this.boundMinY,this.boundMinZ,this.boundMaxX,this.boundMaxY,this.boundMaxZ,16750848);
                  }
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
               param1.addTransparent(_loc4_,this.object);
               _loc4_ = _loc5_;
            }
         }
         this.faceStruct = null;
      }
      
      private function collectNode(param1:Face, param2:Face = null) : Face
      {
         var _loc3_:Face = null;
         var _loc4_:Face = null;
         var _loc5_:Face = null;
         if(param1.offset < 0)
         {
            _loc4_ = param1.processNegative;
            _loc5_ = param1.processPositive;
         }
         else
         {
            _loc4_ = param1.processPositive;
            _loc5_ = param1.processNegative;
         }
         param1.processNegative = null;
         param1.processPositive = null;
         if(_loc5_ != null)
         {
            param2 = this.collectNode(_loc5_,param2);
         }
         if(param1.wrapper != null)
         {
            _loc3_ = param1;
            while(_loc3_.processNext != null)
            {
               _loc3_ = _loc3_.processNext;
            }
            _loc3_.processNext = param2;
            param2 = param1;
         }
         if(_loc4_ != null)
         {
            param2 = this.collectNode(_loc4_,param2);
         }
         return param2;
      }
   }
}
