package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import flash.display.Sprite;
   
   use namespace alternativa3d;
   
   public class Occluder extends Object3D
   {
       
      
      alternativa3d var faceList:Face;
      
      alternativa3d var edgeList:Edge;
      
      alternativa3d var vertexList:Vertex;
      
      public var minSize:Number = 0;
      
      public function Occluder()
      {
         super();
      }
      
      public function createForm(param1:Mesh, param2:Boolean = false) : void
      {
         this.destroyForm();
         if(!param2)
         {
            param1 = param1.clone() as Mesh;
         }
         this.faceList = param1.faceList;
         this.vertexList = param1.vertexList;
         param1.faceList = null;
         param1.vertexList = null;
         var _loc3_:Vertex = this.vertexList;
         while(_loc3_ != null)
         {
            _loc3_.transformId = 0;
            _loc3_.id = null;
            _loc3_ = _loc3_.next;
         }
         var _loc4_:Face = this.faceList;
         while(_loc4_ != null)
         {
            _loc4_.id = null;
            _loc4_ = _loc4_.next;
         }
         var _loc5_:String = this.calculateEdges();
         if(_loc5_ != null)
         {
            this.destroyForm();
            throw new ArgumentError(_loc5_);
         }
         calculateBounds();
      }
      
      public function destroyForm() : void
      {
         this.faceList = null;
         this.edgeList = null;
         this.vertexList = null;
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Occluder = new Occluder();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         var _loc3_:Vertex = null;
         var _loc4_:Face = null;
         var _loc5_:Vertex = null;
         var _loc6_:Face = null;
         var _loc7_:Edge = null;
         var _loc9_:Vertex = null;
         var _loc10_:Face = null;
         var _loc11_:Wrapper = null;
         var _loc12_:Wrapper = null;
         var _loc13_:Wrapper = null;
         var _loc14_:Edge = null;
         super.clonePropertiesFrom(param1);
         var _loc2_:Occluder = param1 as Occluder;
         this.minSize = _loc2_.minSize;
         _loc3_ = _loc2_.vertexList;
         while(_loc3_ != null)
         {
            _loc9_ = new Vertex();
            _loc9_.x = _loc3_.x;
            _loc9_.y = _loc3_.y;
            _loc9_.z = _loc3_.z;
            _loc9_.u = _loc3_.u;
            _loc9_.v = _loc3_.v;
            _loc9_.normalX = _loc3_.normalX;
            _loc9_.normalY = _loc3_.normalY;
            _loc9_.normalZ = _loc3_.normalZ;
            _loc3_.value = _loc9_;
            if(_loc5_ != null)
            {
               _loc5_.next = _loc9_;
            }
            else
            {
               this.vertexList = _loc9_;
            }
            _loc5_ = _loc9_;
            _loc3_ = _loc3_.next;
         }
         _loc4_ = _loc2_.faceList;
         while(_loc4_ != null)
         {
            _loc10_ = new Face();
            _loc10_.material = _loc4_.material;
            _loc10_.normalX = _loc4_.normalX;
            _loc10_.normalY = _loc4_.normalY;
            _loc10_.normalZ = _loc4_.normalZ;
            _loc10_.offset = _loc4_.offset;
            _loc4_.processNext = _loc10_;
            _loc11_ = null;
            _loc12_ = _loc4_.wrapper;
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
            if(_loc6_ != null)
            {
               _loc6_.next = _loc10_;
            }
            else
            {
               this.faceList = _loc10_;
            }
            _loc6_ = _loc10_;
            _loc4_ = _loc4_.next;
         }
         var _loc8_:Edge = _loc2_.edgeList;
         while(_loc8_ != null)
         {
            _loc14_ = new Edge();
            _loc14_.a = _loc8_.a.value;
            _loc14_.b = _loc8_.b.value;
            _loc14_.left = _loc8_.left.processNext;
            _loc14_.right = _loc8_.right.processNext;
            if(_loc7_ != null)
            {
               _loc7_.next = _loc14_;
            }
            else
            {
               this.edgeList = _loc14_;
            }
            _loc7_ = _loc14_;
            _loc8_ = _loc8_.next;
         }
         _loc3_ = _loc2_.vertexList;
         while(_loc3_ != null)
         {
            _loc3_.value = null;
            _loc3_ = _loc3_.next;
         }
         _loc4_ = _loc2_.faceList;
         while(_loc4_ != null)
         {
            _loc4_.processNext = null;
            _loc4_ = _loc4_.next;
         }
      }
      
      private function calculateEdges() : String
      {
         var _loc1_:Face = null;
         var _loc2_:Wrapper = null;
         var _loc3_:Edge = null;
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         _loc1_ = this.faceList;
         while(_loc1_ != null)
         {
            _loc1_.calculateBestSequenceAndNormal();
            _loc2_ = _loc1_.wrapper;
            while(_loc2_ != null)
            {
               _loc4_ = _loc2_.vertex;
               _loc5_ = _loc2_.next != null?_loc2_.next.vertex:_loc1_.wrapper.vertex;
               _loc3_ = this.edgeList;
               while(true)
               {
                  if(true)
                  {
                     if(_loc3_ != null)
                     {
                        if(!(_loc3_.a == _loc4_ && _loc3_.b == _loc5_))
                        {
                           if(!(_loc3_.a == _loc5_ && _loc3_.b == _loc4_))
                           {
                              _loc3_ = _loc3_.next;
                              continue;
                           }
                           break;
                        }
                     }
                     break;
                  }
                  return "The supplied geometry is not valid.";
               }
               if(_loc3_ != null)
               {
                  _loc3_.right = _loc1_;
               }
               else
               {
                  _loc3_ = new Edge();
                  _loc3_.a = _loc4_;
                  _loc3_.b = _loc5_;
                  _loc3_.left = _loc1_;
                  _loc3_.next = this.edgeList;
                  this.edgeList = _loc3_;
               }
               _loc2_ = _loc2_.next;
               _loc4_ = _loc5_;
            }
            _loc1_ = _loc1_.next;
         }
         _loc3_ = this.edgeList;
         while(_loc3_ != null)
         {
            if(_loc3_.left == null || _loc3_.right == null)
            {
               return "The supplied geometry is non whole.";
            }
            _loc6_ = _loc3_.b.x - _loc3_.a.x;
            _loc7_ = _loc3_.b.y - _loc3_.a.y;
            _loc8_ = _loc3_.b.z - _loc3_.a.z;
            _loc9_ = _loc3_.right.normalZ * _loc3_.left.normalY - _loc3_.right.normalY * _loc3_.left.normalZ;
            _loc10_ = _loc3_.right.normalX * _loc3_.left.normalZ - _loc3_.right.normalZ * _loc3_.left.normalX;
            _loc11_ = _loc3_.right.normalY * _loc3_.left.normalX - _loc3_.right.normalX * _loc3_.left.normalY;
            if(_loc6_ * _loc9_ + _loc7_ * _loc10_ + _loc8_ * _loc11_ < 0)
            {
            }
            _loc3_ = _loc3_.next;
         }
         return null;
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc6_:Vertex = null;
         var _loc11_:Vertex = null;
         var _loc12_:Vertex = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc21_:Vertex = null;
         var _loc22_:Vertex = null;
         var _loc23_:Number = NaN;
         if(this.faceList == null || this.edgeList == null)
         {
            return;
         }
         calculateInverseMatrix();
         var _loc4_:Boolean = true;
         var _loc5_:Face = this.faceList;
         while(_loc5_ != null)
         {
            if(_loc5_.normalX * imd + _loc5_.normalY * imh + _loc5_.normalZ * iml > _loc5_.offset)
            {
               _loc5_.distance = 1;
               _loc4_ = false;
            }
            else
            {
               _loc5_.distance = 0;
            }
            _loc5_ = _loc5_.next;
         }
         if(_loc4_)
         {
            return;
         }
         var _loc7_:int = 0;
         var _loc8_:Boolean = true;
         var _loc9_:Number = param1.viewSizeX;
         var _loc10_:Number = param1.viewSizeY;
         for(var _loc20_:Edge = this.edgeList; _loc20_ != null; _loc20_ = _loc20_.next)
         {
            if(_loc20_.left.distance != _loc20_.right.distance)
            {
               if(_loc20_.left.distance > 0)
               {
                  _loc11_ = _loc20_.a;
                  _loc12_ = _loc20_.b;
               }
               else
               {
                  _loc11_ = _loc20_.b;
                  _loc12_ = _loc20_.a;
               }
               _loc13_ = ma * _loc11_.x + mb * _loc11_.y + mc * _loc11_.z + md;
               _loc14_ = me * _loc11_.x + mf * _loc11_.y + mg * _loc11_.z + mh;
               _loc15_ = mi * _loc11_.x + mj * _loc11_.y + mk * _loc11_.z + ml;
               _loc16_ = ma * _loc12_.x + mb * _loc12_.y + mc * _loc12_.z + md;
               _loc17_ = me * _loc12_.x + mf * _loc12_.y + mg * _loc12_.z + mh;
               _loc18_ = mi * _loc12_.x + mj * _loc12_.y + mk * _loc12_.z + ml;
               if(culling > 0)
               {
                  if(_loc15_ <= -_loc13_ && _loc18_ <= -_loc16_)
                  {
                     if(_loc8_ && _loc17_ * _loc13_ - _loc16_ * _loc14_ > 0)
                     {
                        _loc8_ = false;
                     }
                     continue;
                  }
                  if(_loc18_ > -_loc16_ && _loc15_ <= -_loc13_)
                  {
                     _loc19_ = (_loc13_ + _loc15_) / (_loc13_ + _loc15_ - _loc16_ - _loc18_);
                     _loc13_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                     _loc14_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                     _loc15_ = _loc15_ + (_loc18_ - _loc15_) * _loc19_;
                  }
                  else if(_loc18_ <= -_loc16_ && _loc15_ > -_loc13_)
                  {
                     _loc19_ = (_loc13_ + _loc15_) / (_loc13_ + _loc15_ - _loc16_ - _loc18_);
                     _loc16_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                     _loc17_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                     _loc18_ = _loc15_ + (_loc18_ - _loc15_) * _loc19_;
                  }
                  if(_loc15_ <= _loc13_ && _loc18_ <= _loc16_)
                  {
                     if(_loc8_ && _loc17_ * _loc13_ - _loc16_ * _loc14_ > 0)
                     {
                        _loc8_ = false;
                     }
                     continue;
                  }
                  if(_loc18_ > _loc16_ && _loc15_ <= _loc13_)
                  {
                     _loc19_ = (_loc15_ - _loc13_) / (_loc15_ - _loc13_ + _loc16_ - _loc18_);
                     _loc13_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                     _loc14_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                     _loc15_ = _loc15_ + (_loc18_ - _loc15_) * _loc19_;
                  }
                  else if(_loc18_ <= _loc16_ && _loc15_ > _loc13_)
                  {
                     _loc19_ = (_loc15_ - _loc13_) / (_loc15_ - _loc13_ + _loc16_ - _loc18_);
                     _loc16_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                     _loc17_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                     _loc18_ = _loc15_ + (_loc18_ - _loc15_) * _loc19_;
                  }
                  if(_loc15_ <= -_loc14_ && _loc18_ <= -_loc17_)
                  {
                     if(_loc8_ && _loc17_ * _loc13_ - _loc16_ * _loc14_ > 0)
                     {
                        _loc8_ = false;
                     }
                     continue;
                  }
                  if(_loc18_ > -_loc17_ && _loc15_ <= -_loc14_)
                  {
                     _loc19_ = (_loc14_ + _loc15_) / (_loc14_ + _loc15_ - _loc17_ - _loc18_);
                     _loc13_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                     _loc14_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                     _loc15_ = _loc15_ + (_loc18_ - _loc15_) * _loc19_;
                  }
                  else if(_loc18_ <= -_loc17_ && _loc15_ > -_loc14_)
                  {
                     _loc19_ = (_loc14_ + _loc15_) / (_loc14_ + _loc15_ - _loc17_ - _loc18_);
                     _loc16_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                     _loc17_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                     _loc18_ = _loc15_ + (_loc18_ - _loc15_) * _loc19_;
                  }
                  if(_loc15_ <= _loc14_ && _loc18_ <= _loc17_)
                  {
                     if(_loc8_ && _loc17_ * _loc13_ - _loc16_ * _loc14_ > 0)
                     {
                        _loc8_ = false;
                     }
                     continue;
                  }
                  if(_loc18_ > _loc17_ && _loc15_ <= _loc14_)
                  {
                     _loc19_ = (_loc15_ - _loc14_) / (_loc15_ - _loc14_ + _loc17_ - _loc18_);
                     _loc13_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                     _loc14_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                     _loc15_ = _loc15_ + (_loc18_ - _loc15_) * _loc19_;
                  }
                  else if(_loc18_ <= _loc17_ && _loc15_ > _loc14_)
                  {
                     _loc19_ = (_loc15_ - _loc14_) / (_loc15_ - _loc14_ + _loc17_ - _loc18_);
                     _loc16_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                     _loc17_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                     _loc18_ = _loc15_ + (_loc18_ - _loc15_) * _loc19_;
                  }
                  _loc8_ = false;
               }
               _loc11_ = _loc11_.create();
               _loc11_.next = _loc6_;
               _loc7_++;
               _loc6_ = _loc11_;
               _loc6_.cameraX = _loc18_ * _loc14_ - _loc17_ * _loc15_;
               _loc6_.cameraY = _loc16_ * _loc15_ - _loc18_ * _loc13_;
               _loc6_.cameraZ = _loc17_ * _loc13_ - _loc16_ * _loc14_;
               _loc6_.x = _loc13_;
               _loc6_.y = _loc14_;
               _loc6_.z = _loc15_;
               _loc6_.u = _loc16_;
               _loc6_.v = _loc17_;
               _loc6_.offset = _loc18_;
               continue;
            }
         }
         if(_loc6_ != null)
         {
            if(this.minSize > 0)
            {
               _loc21_ = Vertex.createList(_loc7_);
               _loc11_ = _loc6_;
               _loc12_ = _loc21_;
               while(_loc11_ != null)
               {
                  _loc12_.x = _loc11_.x * _loc9_ / _loc11_.z;
                  _loc12_.y = _loc11_.y * _loc10_ / _loc11_.z;
                  _loc12_.u = _loc11_.u * _loc9_ / _loc11_.offset;
                  _loc12_.v = _loc11_.v * _loc10_ / _loc11_.offset;
                  _loc12_.cameraX = _loc12_.y - _loc12_.v;
                  _loc12_.cameraY = _loc12_.u - _loc12_.x;
                  _loc12_.offset = _loc12_.cameraX * _loc12_.x + _loc12_.cameraY * _loc12_.y;
                  _loc11_ = _loc11_.next;
                  _loc12_ = _loc12_.next;
               }
               if(culling > 0)
               {
                  if(culling & 4)
                  {
                     _loc13_ = -param1.viewSizeX;
                     _loc14_ = -param1.viewSizeY;
                     _loc16_ = -param1.viewSizeX;
                     _loc17_ = param1.viewSizeY;
                     _loc11_ = _loc21_;
                     while(_loc11_ != null)
                     {
                        _loc15_ = _loc13_ * _loc11_.cameraX + _loc14_ * _loc11_.cameraY - _loc11_.offset;
                        _loc18_ = _loc16_ * _loc11_.cameraX + _loc17_ * _loc11_.cameraY - _loc11_.offset;
                        if(_loc15_ < 0 || _loc18_ < 0)
                        {
                           if(_loc15_ >= 0 && _loc18_ < 0)
                           {
                              _loc19_ = _loc15_ / (_loc15_ - _loc18_);
                              _loc13_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                              _loc14_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                           }
                           else if(_loc15_ < 0 && _loc18_ >= 0)
                           {
                              _loc19_ = _loc15_ / (_loc15_ - _loc18_);
                              _loc16_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                              _loc17_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                           }
                           _loc11_ = _loc11_.next;
                           continue;
                        }
                        break;
                     }
                     if(_loc11_ == null)
                     {
                        _loc12_ = _loc6_.create();
                        _loc12_.next = _loc22_;
                        _loc22_ = _loc12_;
                        _loc22_.x = _loc13_;
                        _loc22_.y = _loc14_;
                        _loc22_.u = _loc16_;
                        _loc22_.v = _loc17_;
                     }
                  }
                  if(culling & 8)
                  {
                     _loc13_ = param1.viewSizeX;
                     _loc14_ = param1.viewSizeY;
                     _loc16_ = param1.viewSizeX;
                     _loc17_ = -param1.viewSizeY;
                     _loc11_ = _loc21_;
                     while(_loc11_ != null)
                     {
                        _loc15_ = _loc13_ * _loc11_.cameraX + _loc14_ * _loc11_.cameraY - _loc11_.offset;
                        _loc18_ = _loc16_ * _loc11_.cameraX + _loc17_ * _loc11_.cameraY - _loc11_.offset;
                        if(_loc15_ < 0 || _loc18_ < 0)
                        {
                           if(_loc15_ >= 0 && _loc18_ < 0)
                           {
                              _loc19_ = _loc15_ / (_loc15_ - _loc18_);
                              _loc13_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                              _loc14_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                           }
                           else if(_loc15_ < 0 && _loc18_ >= 0)
                           {
                              _loc19_ = _loc15_ / (_loc15_ - _loc18_);
                              _loc16_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                              _loc17_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                           }
                           _loc11_ = _loc11_.next;
                           continue;
                        }
                        break;
                     }
                     if(_loc11_ == null)
                     {
                        _loc12_ = _loc6_.create();
                        _loc12_.next = _loc22_;
                        _loc22_ = _loc12_;
                        _loc22_.x = _loc13_;
                        _loc22_.y = _loc14_;
                        _loc22_.u = _loc16_;
                        _loc22_.v = _loc17_;
                     }
                  }
                  if(culling & 16)
                  {
                     _loc13_ = param1.viewSizeX;
                     _loc14_ = -param1.viewSizeY;
                     _loc16_ = -param1.viewSizeX;
                     _loc17_ = -param1.viewSizeY;
                     _loc11_ = _loc21_;
                     while(_loc11_ != null)
                     {
                        _loc15_ = _loc13_ * _loc11_.cameraX + _loc14_ * _loc11_.cameraY - _loc11_.offset;
                        _loc18_ = _loc16_ * _loc11_.cameraX + _loc17_ * _loc11_.cameraY - _loc11_.offset;
                        if(_loc15_ < 0 || _loc18_ < 0)
                        {
                           if(_loc15_ >= 0 && _loc18_ < 0)
                           {
                              _loc19_ = _loc15_ / (_loc15_ - _loc18_);
                              _loc13_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                              _loc14_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                           }
                           else if(_loc15_ < 0 && _loc18_ >= 0)
                           {
                              _loc19_ = _loc15_ / (_loc15_ - _loc18_);
                              _loc16_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                              _loc17_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                           }
                           _loc11_ = _loc11_.next;
                           continue;
                        }
                        break;
                     }
                     if(_loc11_ == null)
                     {
                        _loc12_ = _loc6_.create();
                        _loc12_.next = _loc22_;
                        _loc22_ = _loc12_;
                        _loc22_.x = _loc13_;
                        _loc22_.y = _loc14_;
                        _loc22_.u = _loc16_;
                        _loc22_.v = _loc17_;
                     }
                  }
                  if(culling & 32)
                  {
                     _loc13_ = -param1.viewSizeX;
                     _loc14_ = param1.viewSizeY;
                     _loc16_ = param1.viewSizeX;
                     _loc17_ = param1.viewSizeY;
                     _loc11_ = _loc21_;
                     while(_loc11_ != null)
                     {
                        _loc15_ = _loc13_ * _loc11_.cameraX + _loc14_ * _loc11_.cameraY - _loc11_.offset;
                        _loc18_ = _loc16_ * _loc11_.cameraX + _loc17_ * _loc11_.cameraY - _loc11_.offset;
                        if(_loc15_ < 0 || _loc18_ < 0)
                        {
                           if(_loc15_ >= 0 && _loc18_ < 0)
                           {
                              _loc19_ = _loc15_ / (_loc15_ - _loc18_);
                              _loc13_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                              _loc14_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                           }
                           else if(_loc15_ < 0 && _loc18_ >= 0)
                           {
                              _loc19_ = _loc15_ / (_loc15_ - _loc18_);
                              _loc16_ = _loc13_ + (_loc16_ - _loc13_) * _loc19_;
                              _loc17_ = _loc14_ + (_loc17_ - _loc14_) * _loc19_;
                           }
                           _loc11_ = _loc11_.next;
                           continue;
                        }
                        break;
                     }
                     if(_loc11_ == null)
                     {
                        _loc12_ = _loc6_.create();
                        _loc12_.next = _loc22_;
                        _loc22_ = _loc12_;
                        _loc22_.x = _loc13_;
                        _loc22_.y = _loc14_;
                        _loc22_.u = _loc16_;
                        _loc22_.v = _loc17_;
                     }
                  }
               }
               _loc23_ = 0;
               _loc15_ = _loc21_.x;
               _loc18_ = _loc21_.y;
               _loc11_ = _loc21_;
               while(_loc11_.next != null)
               {
                  _loc11_ = _loc11_.next;
               }
               _loc11_.next = _loc22_;
               _loc11_ = _loc21_;
               while(_loc11_ != null)
               {
                  _loc23_ = _loc23_ + ((_loc11_.u - _loc15_) * (_loc11_.y - _loc18_) - (_loc11_.v - _loc18_) * (_loc11_.x - _loc15_));
                  if(_loc11_.next == null)
                  {
                     break;
                  }
                  _loc11_ = _loc11_.next;
               }
               _loc11_.next = Vertex.collector;
               Vertex.collector = _loc21_;
               if(_loc23_ / (param1.viewSizeX * param1.viewSizeY * 8) < this.minSize)
               {
                  _loc11_ = _loc6_;
                  while(_loc11_.next != null)
                  {
                     _loc11_ = _loc11_.next;
                  }
                  _loc11_.next = Vertex.collector;
                  Vertex.collector = _loc6_;
                  return;
               }
            }
            if(param1.debug && (_loc2_ = param1.checkInDebug(this)) > 0)
            {
               if(_loc2_ & Debug.EDGES)
               {
                  _loc11_ = _loc6_;
                  while(_loc11_ != null)
                  {
                     _loc13_ = _loc11_.x * _loc9_ / _loc11_.z;
                     _loc14_ = _loc11_.y * _loc10_ / _loc11_.z;
                     _loc16_ = _loc11_.u * _loc9_ / _loc11_.offset;
                     _loc17_ = _loc11_.v * _loc10_ / _loc11_.offset;
                     _loc3_ = param1.view.canvas;
                     _loc3_.graphics.moveTo(_loc13_,_loc14_);
                     _loc3_.graphics.lineStyle(3,255);
                     _loc3_.graphics.lineTo(_loc13_ + (_loc16_ - _loc13_) * 0.8,_loc14_ + (_loc17_ - _loc14_) * 0.8);
                     _loc3_.graphics.lineStyle(3,16711680);
                     _loc3_.graphics.lineTo(_loc16_,_loc17_);
                     _loc11_ = _loc11_.next;
                  }
               }
               if(_loc2_ & Debug.BOUNDS)
               {
                  Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            param1.occluders[param1.numOccluders] = _loc6_;
            param1.numOccluders++;
         }
         else if(_loc8_)
         {
            if(param1.debug && (_loc2_ = param1.checkInDebug(this)) > 0)
            {
               if(_loc2_ & Debug.EDGES)
               {
                  _loc19_ = 1.5;
                  _loc3_ = param1.view.canvas;
                  _loc3_.graphics.moveTo(-_loc9_ + _loc19_,-_loc10_ + _loc19_);
                  _loc3_.graphics.lineStyle(3,255);
                  _loc3_.graphics.lineTo(-_loc9_ + _loc19_,_loc10_ * 0.6);
                  _loc3_.graphics.lineStyle(3,16711680);
                  _loc3_.graphics.lineTo(-_loc9_ + _loc19_,_loc10_ - _loc19_);
                  _loc3_.graphics.lineStyle(3,255);
                  _loc3_.graphics.lineTo(_loc9_ * 0.6,_loc10_ - _loc19_);
                  _loc3_.graphics.lineStyle(3,16711680);
                  _loc3_.graphics.lineTo(_loc9_ - _loc19_,_loc10_ - _loc19_);
                  _loc3_.graphics.lineStyle(3,255);
                  _loc3_.graphics.lineTo(_loc9_ - _loc19_,-_loc10_ * 0.6);
                  _loc3_.graphics.lineStyle(3,16711680);
                  _loc3_.graphics.lineTo(_loc9_ - _loc19_,-_loc10_ + _loc19_);
                  _loc3_.graphics.lineStyle(3,255);
                  _loc3_.graphics.lineTo(-_loc9_ * 0.6,-_loc10_ + _loc19_);
                  _loc3_.graphics.lineStyle(3,16711680);
                  _loc3_.graphics.lineTo(-_loc9_ + _loc19_,-_loc10_ + _loc19_);
               }
               if(_loc2_ & Debug.BOUNDS)
               {
                  Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            param1.clearOccluders();
            param1.occludedAll = true;
         }
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
   }
}

import alternativa.engine3d.core.Face;
import alternativa.engine3d.core.Vertex;

class Edge
{
    
   
   public var next:Edge;
   
   public var a:Vertex;
   
   public var b:Vertex;
   
   public var left:Face;
   
   public var right:Face;
   
   function Edge()
   {
      super();
   }
}
