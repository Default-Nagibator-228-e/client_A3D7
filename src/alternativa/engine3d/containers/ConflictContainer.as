package alternativa.engine3d.containers
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   
   use namespace alternativa3d;
   
   public class ConflictContainer extends Object3DContainer
   {
       
      
      public var resolveByAABB:Boolean = true;
      
      public var resolveByOOBB:Boolean = true;
      
      public var threshold:Number = 0.01;
      
      public function ConflictContainer()
      {
         super();
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:ConflictContainer = new ConflictContainer();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         super.clonePropertiesFrom(param1);
         var _loc2_:ConflictContainer = param1 as ConflictContainer;
         this.resolveByAABB = _loc2_.resolveByAABB;
         this.resolveByOOBB = _loc2_.resolveByOOBB;
         this.threshold = _loc2_.threshold;
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         var _loc2_:int = 0;
         var _loc4_:VG = null;
         var _loc3_:VG = getVG(param1);
         if(_loc3_ != null)
         {
            if(param1.debug && (_loc2_ = param1.checkInDebug(this)) > 0)
            {
               if(_loc2_ & Debug.BOUNDS)
               {
                  Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            if(_loc3_.next != null)
            {
               calculateInverseMatrix();
               if(this.resolveByAABB)
               {
                  _loc4_ = _loc3_;
                  while(_loc4_ != null)
                  {
                     _loc4_.calculateAABB(ima,imb,imc,imd,ime,imf,img,imh,imi,imj,imk,iml);
                     _loc4_ = _loc4_.next;
                  }
                  this.drawAABBGeometry(param1,_loc3_);
               }
               else if(this.resolveByOOBB)
               {
                  _loc4_ = _loc3_;
                  while(_loc4_ != null)
                  {
                     _loc4_.calculateOOBB(this);
                     _loc4_ = _loc4_.next;
                  }
                  this.drawOOBBGeometry(param1,_loc3_);
               }
               else
               {
                  this.drawConflictGeometry(param1,_loc3_);
               }
            }
            else
            {
               _loc3_.draw(param1,this.threshold,this);
               _loc3_.destroy();
            }
         }
      }
      
      alternativa3d function drawAABBGeometry(param1:Camera3D, param2:VG, param3:Boolean = true, param4:Boolean = false, param5:Boolean = true, param6:int = -1) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc10_:VG = !!param5?this.sortGeometry(param2,param3,param4):param2;
         var _loc11_:VG = _loc10_;
         var _loc12_:VG = _loc10_.next;
         var _loc13_:Number = _loc10_.boundMax;
         while(_loc12_ != null)
         {
            _loc14_ = _loc12_.boundMin >= _loc13_ - this.threshold;
            if(_loc14_ || _loc12_.next == null)
            {
               if(_loc14_)
               {
                  _loc11_.next = null;
                  param6 = 0;
               }
               else
               {
                  _loc12_ = null;
                  param6++;
               }
               if(param3)
               {
                  _loc7_ = imd < _loc13_;
                  _loc8_ = false;
                  _loc9_ = true;
               }
               else if(param4)
               {
                  _loc7_ = imh < _loc13_;
                  _loc8_ = false;
                  _loc9_ = false;
               }
               else
               {
                  _loc7_ = iml < _loc13_;
                  _loc8_ = true;
                  _loc9_ = false;
               }
               if(_loc7_)
               {
                  if(_loc10_.next != null)
                  {
                     if(param6 < 2)
                     {
                        this.drawAABBGeometry(param1,_loc10_,_loc8_,_loc9_,true,param6);
                     }
                     else if(this.resolveByOOBB)
                     {
                        _loc11_ = _loc10_;
                        while(_loc11_ != null)
                        {
                           _loc11_.calculateOOBB(this);
                           _loc11_ = _loc11_.next;
                        }
                        this.drawOOBBGeometry(param1,_loc10_);
                     }
                     else
                     {
                        this.drawConflictGeometry(param1,_loc10_);
                     }
                  }
                  else
                  {
                     _loc10_.draw(param1,this.threshold,this);
                     _loc10_.destroy();
                  }
                  if(_loc12_ != null)
                  {
                     if(_loc12_.next != null)
                     {
                        this.drawAABBGeometry(param1,_loc12_,param3,param4,false,-1);
                     }
                     else
                     {
                        _loc12_.draw(param1,this.threshold,this);
                        _loc12_.destroy();
                     }
                  }
               }
               else
               {
                  if(_loc12_ != null)
                  {
                     if(_loc12_.next != null)
                     {
                        this.drawAABBGeometry(param1,_loc12_,param3,param4,false,-1);
                     }
                     else
                     {
                        _loc12_.draw(param1,this.threshold,this);
                        _loc12_.destroy();
                     }
                  }
                  if(_loc10_.next != null)
                  {
                     if(param6 < 2)
                     {
                        this.drawAABBGeometry(param1,_loc10_,_loc8_,_loc9_,true,param6);
                     }
                     else if(this.resolveByOOBB)
                     {
                        _loc11_ = _loc10_;
                        while(_loc11_ != null)
                        {
                           _loc11_.calculateOOBB(this);
                           _loc11_ = _loc11_.next;
                        }
                        this.drawOOBBGeometry(param1,_loc10_);
                     }
                     else
                     {
                        this.drawConflictGeometry(param1,_loc10_);
                     }
                  }
                  else
                  {
                     _loc10_.draw(param1,this.threshold,this);
                     _loc10_.destroy();
                  }
               }
               break;
            }
            if(_loc12_.boundMax > _loc13_)
            {
               _loc13_ = _loc12_.boundMax;
            }
            _loc11_ = _loc12_;
            _loc12_ = _loc12_.next;
         }
      }
      
      private function sortGeometry(param1:VG, param2:Boolean, param3:Boolean) : VG
      {
         var _loc4_:VG = param1;
         var _loc5_:VG = param1.next;
         while(_loc5_ != null && _loc5_.next != null)
         {
            param1 = param1.next;
            _loc5_ = _loc5_.next.next;
         }
         _loc5_ = param1.next;
         param1.next = null;
         if(_loc4_.next != null)
         {
            _loc4_ = this.sortGeometry(_loc4_,param2,param3);
         }
         else if(param2)
         {
            _loc4_.boundMin = _loc4_.boundMinX;
            _loc4_.boundMax = _loc4_.boundMaxX;
         }
         else if(param3)
         {
            _loc4_.boundMin = _loc4_.boundMinY;
            _loc4_.boundMax = _loc4_.boundMaxY;
         }
         else
         {
            _loc4_.boundMin = _loc4_.boundMinZ;
            _loc4_.boundMax = _loc4_.boundMaxZ;
         }
         if(_loc5_.next != null)
         {
            _loc5_ = this.sortGeometry(_loc5_,param2,param3);
         }
         else if(param2)
         {
            _loc5_.boundMin = _loc5_.boundMinX;
            _loc5_.boundMax = _loc5_.boundMaxX;
         }
         else if(param3)
         {
            _loc5_.boundMin = _loc5_.boundMinY;
            _loc5_.boundMax = _loc5_.boundMaxY;
         }
         else
         {
            _loc5_.boundMin = _loc5_.boundMinZ;
            _loc5_.boundMax = _loc5_.boundMaxZ;
         }
         var _loc6_:Boolean = _loc4_.boundMin < _loc5_.boundMin;
         if(_loc6_)
         {
            param1 = _loc4_;
            _loc4_ = _loc4_.next;
         }
         else
         {
            param1 = _loc5_;
            _loc5_ = _loc5_.next;
         }
         var _loc7_:VG = param1;
         while(true)
         {
            if(_loc4_ == null)
            {
               _loc7_.next = _loc5_;
               return param1;
            }
            if(_loc5_ == null)
            {
               _loc7_.next = _loc4_;
               return param1;
            }
            if(_loc6_)
            {
               if(_loc4_.boundMin < _loc5_.boundMin)
               {
                  _loc7_ = _loc4_;
                  _loc4_ = _loc4_.next;
               }
               else
               {
                  _loc7_.next = _loc5_;
                  _loc7_ = _loc5_;
                  _loc5_ = _loc5_.next;
                  _loc6_ = false;
               }
            }
            else if(_loc5_.boundMin < _loc4_.boundMin)
            {
               _loc7_ = _loc5_;
               _loc5_ = _loc5_.next;
            }
            else
            {
               _loc7_.next = _loc4_;
               _loc7_ = _loc4_;
               _loc4_ = _loc4_.next;
               _loc6_ = true;
            }
         }
         return null;
      }
      
      alternativa3d function drawOOBBGeometry(param1:Camera3D, param2:VG) : void
      {
         var _loc3_:Vertex = null;
         var _loc4_:Vertex = null;
         var _loc5_:Wrapper = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:VG = null;
         var _loc14_:VG = null;
         var _loc15_:Boolean = false;
         var _loc16_:VG = null;
         var _loc17_:VG = null;
         var _loc18_:VG = null;
         var _loc19_:VG = null;
         _loc13_ = param2;
         while(_loc13_ != null)
         {
            if(_loc13_.viewAligned)
            {
               _loc10_ = _loc13_.object.ml;
               _loc14_ = param2;
               while(_loc14_ != null)
               {
                  if(!_loc14_.viewAligned)
                  {
                     _loc11_ = false;
                     _loc12_ = false;
                     _loc3_ = _loc14_.boundVertexList;
                     while(_loc3_ != null)
                     {
                        if(_loc3_.cameraZ > _loc10_)
                        {
                           if(_loc11_)
                           {
                              break;
                           }
                           _loc12_ = true;
                        }
                        else
                        {
                           if(_loc12_)
                           {
                              break;
                           }
                           _loc11_ = true;
                        }
                        _loc3_ = _loc3_.next;
                     }
                     if(_loc3_ != null)
                     {
                        break;
                     }
                  }
                  _loc14_ = _loc14_.next;
               }
               if(_loc14_ == null)
               {
                  break;
               }
            }
            else
            {
               _loc4_ = _loc13_.boundPlaneList;
               while(_loc4_ != null)
               {
                  _loc7_ = _loc4_.cameraX;
                  _loc8_ = _loc4_.cameraY;
                  _loc9_ = _loc4_.cameraZ;
                  _loc10_ = _loc4_.offset;
                  _loc15_ = false;
                  _loc14_ = param2;
                  while(_loc14_ != null)
                  {
                     if(_loc13_ != _loc14_)
                     {
                        _loc11_ = false;
                        _loc12_ = false;
                        if(_loc14_.viewAligned)
                        {
                           _loc5_ = _loc14_.faceStruct.wrapper;
                           while(_loc5_ != null)
                           {
                              _loc3_ = _loc5_.vertex;
                              if(_loc3_.cameraX * _loc7_ + _loc3_.cameraY * _loc8_ + _loc3_.cameraZ * _loc9_ >= _loc10_ - this.threshold)
                              {
                                 if(_loc11_)
                                 {
                                    break;
                                 }
                                 _loc15_ = true;
                                 _loc12_ = true;
                              }
                              else
                              {
                                 if(_loc12_)
                                 {
                                    break;
                                 }
                                 _loc11_ = true;
                              }
                              _loc5_ = _loc5_.next;
                           }
                           if(_loc5_ != null)
                           {
                              break;
                           }
                        }
                        else
                        {
                           _loc3_ = _loc14_.boundVertexList;
                           while(_loc3_ != null)
                           {
                              if(_loc3_.cameraX * _loc7_ + _loc3_.cameraY * _loc8_ + _loc3_.cameraZ * _loc9_ >= _loc10_ - this.threshold)
                              {
                                 if(_loc11_)
                                 {
                                    break;
                                 }
                                 _loc15_ = true;
                                 _loc12_ = true;
                              }
                              else
                              {
                                 if(_loc12_)
                                 {
                                    break;
                                 }
                                 _loc11_ = true;
                              }
                              _loc3_ = _loc3_.next;
                           }
                           if(_loc3_ != null)
                           {
                              break;
                           }
                        }
                     }
                     _loc14_ = _loc14_.next;
                  }
                  if(_loc14_ == null && _loc15_)
                  {
                     break;
                  }
                  _loc4_ = _loc4_.next;
               }
               if(_loc4_ != null)
               {
                  break;
               }
            }
            _loc13_ = _loc13_.next;
         }
         if(_loc13_ != null)
         {
            if(_loc13_.viewAligned)
            {
               while(param2 != null)
               {
                  _loc16_ = param2.next;
                  if(param2.viewAligned)
                  {
                     _loc6_ = param2.object.ml - _loc10_;
                     if(_loc6_ < -this.threshold)
                     {
                        param2.next = _loc19_;
                        _loc19_ = param2;
                     }
                     else if(_loc6_ > this.threshold)
                     {
                        param2.next = _loc17_;
                        _loc17_ = param2;
                     }
                     else
                     {
                        param2.next = _loc18_;
                        _loc18_ = param2;
                     }
                  }
                  else
                  {
                     _loc3_ = param2.boundVertexList;
                     while(_loc3_ != null)
                     {
                        _loc6_ = _loc3_.cameraZ - _loc10_;
                        if(_loc6_ < -this.threshold)
                        {
                           param2.next = _loc19_;
                           _loc19_ = param2;
                           break;
                        }
                        if(_loc6_ > this.threshold)
                        {
                           param2.next = _loc17_;
                           _loc17_ = param2;
                           break;
                        }
                        _loc3_ = _loc3_.next;
                     }
                     if(_loc3_ == null)
                     {
                        param2.next = _loc18_;
                        _loc18_ = param2;
                     }
                  }
                  param2 = _loc16_;
               }
            }
            else
            {
               while(param2 != null)
               {
                  _loc16_ = param2.next;
                  if(param2.viewAligned)
                  {
                     _loc5_ = param2.faceStruct.wrapper;
                     while(_loc5_ != null)
                     {
                        _loc3_ = _loc5_.vertex;
                        _loc6_ = _loc3_.cameraX * _loc7_ + _loc3_.cameraY * _loc8_ + _loc3_.cameraZ * _loc9_ - _loc10_;
                        if(_loc6_ < -this.threshold)
                        {
                           param2.next = _loc17_;
                           _loc17_ = param2;
                           break;
                        }
                        if(_loc6_ > this.threshold)
                        {
                           param2.next = _loc19_;
                           _loc19_ = param2;
                           break;
                        }
                        _loc5_ = _loc5_.next;
                     }
                     if(_loc5_ == null)
                     {
                        param2.next = _loc18_;
                        _loc18_ = param2;
                     }
                  }
                  else
                  {
                     _loc3_ = param2.boundVertexList;
                     while(_loc3_ != null)
                     {
                        _loc6_ = _loc3_.cameraX * _loc7_ + _loc3_.cameraY * _loc8_ + _loc3_.cameraZ * _loc9_ - _loc10_;
                        if(_loc6_ < -this.threshold)
                        {
                           param2.next = _loc17_;
                           _loc17_ = param2;
                           break;
                        }
                        if(_loc6_ > this.threshold)
                        {
                           param2.next = _loc19_;
                           _loc19_ = param2;
                           break;
                        }
                        _loc3_ = _loc3_.next;
                     }
                     if(_loc3_ == null)
                     {
                        param2.next = _loc18_;
                        _loc18_ = param2;
                     }
                  }
                  param2 = _loc16_;
               }
            }
            if(_loc13_.viewAligned || _loc10_ < 0)
            {
               if(_loc19_ != null)
               {
                  if(_loc19_.next != null)
                  {
                     this.drawOOBBGeometry(param1,_loc19_);
                  }
                  else
                  {
                     _loc19_.draw(param1,this.threshold,this);
                     _loc19_.destroy();
                  }
               }
               while(_loc18_ != null)
               {
                  _loc16_ = _loc18_.next;
                  _loc18_.draw(param1,this.threshold,this);
                  _loc18_.destroy();
                  _loc18_ = _loc16_;
               }
               if(_loc17_ != null)
               {
                  if(_loc17_.next != null)
                  {
                     this.drawOOBBGeometry(param1,_loc17_);
                  }
                  else
                  {
                     _loc17_.draw(param1,this.threshold,this);
                     _loc17_.destroy();
                  }
               }
            }
            else
            {
               if(_loc17_ != null)
               {
                  if(_loc17_.next != null)
                  {
                     this.drawOOBBGeometry(param1,_loc17_);
                  }
                  else
                  {
                     _loc17_.draw(param1,this.threshold,this);
                     _loc17_.destroy();
                  }
               }
               while(_loc18_ != null)
               {
                  _loc16_ = _loc18_.next;
                  _loc18_.draw(param1,this.threshold,this);
                  _loc18_.destroy();
                  _loc18_ = _loc16_;
               }
               if(_loc19_ != null)
               {
                  if(_loc19_.next != null)
                  {
                     this.drawOOBBGeometry(param1,_loc19_);
                  }
                  else
                  {
                     _loc19_.draw(param1,this.threshold,this);
                     _loc19_.destroy();
                  }
               }
            }
         }
         else
         {
            this.drawConflictGeometry(param1,param2);
         }
      }
      
      alternativa3d function drawConflictGeometry(param1:Camera3D, param2:VG) : void
      {
         var _loc3_:Face = null;
         var _loc4_:Face = null;
         var _loc5_:VG = null;
         var _loc6_:VG = null;
         var _loc7_:VG = null;
         var _loc8_:Face = null;
         var _loc9_:Face = null;
         var _loc10_:Face = null;
         var _loc11_:Face = null;
         var _loc12_:Face = null;
         var _loc13_:Face = null;
         var _loc14_:Face = null;
         var _loc15_:Face = null;
         var _loc16_:Face = null;
         var _loc17_:Boolean = false;
         while(param2 != null)
         {
            _loc5_ = param2.next;
            if(param2.space == 1)
            {
               param2.transformStruct(param2.faceStruct,++param2.object.transformId,ma,mb,mc,md,me,mf,mg,mh,mi,mj,mk,ml);
            }
            if(param2.sorting == 3)
            {
               param2.next = _loc6_;
               _loc6_ = param2;
            }
            else
            {
               if(param2.sorting == 2)
               {
                  if(_loc8_ != null)
                  {
                     _loc9_.processNext = param2.faceStruct;
                  }
                  else
                  {
                     _loc8_ = param2.faceStruct;
                  }
                  _loc9_ = param2.faceStruct;
                  _loc9_.geometry = param2;
                  while(_loc9_.processNext != null)
                  {
                     _loc9_ = _loc9_.processNext;
                     _loc9_.geometry = param2;
                  }
               }
               else
               {
                  if(_loc10_ != null)
                  {
                     _loc11_.processNext = param2.faceStruct;
                  }
                  else
                  {
                     _loc10_ = param2.faceStruct;
                  }
                  _loc11_ = param2.faceStruct;
                  _loc11_.geometry = param2;
                  while(_loc11_.processNext != null)
                  {
                     _loc11_ = _loc11_.processNext;
                     _loc11_.geometry = param2;
                  }
               }
               param2.faceStruct = null;
               param2.next = _loc7_;
               _loc7_ = param2;
            }
            param2 = _loc5_;
         }
         if(_loc7_ != null)
         {
            param2 = _loc7_;
            while(param2.next != null)
            {
               param2 = param2.next;
            }
            param2.next = _loc6_;
         }
         else
         {
            _loc7_ = _loc6_;
         }
         if(_loc8_ != null)
         {
            _loc12_ = _loc8_;
            _loc9_.processNext = _loc10_;
         }
         else
         {
            _loc12_ = _loc10_;
         }
         if(_loc6_ != null)
         {
            _loc6_.faceStruct.geometry = _loc6_;
            _loc12_ = this.collectNode(_loc6_.faceStruct,_loc12_,param1,this.threshold,true);
            _loc6_.faceStruct = null;
            _loc6_ = _loc6_.next;
            while(_loc6_ != null)
            {
               _loc6_.faceStruct.geometry = _loc6_;
               _loc12_ = this.collectNode(_loc6_.faceStruct,_loc12_,param1,this.threshold,false);
               _loc6_.faceStruct = null;
               _loc6_ = _loc6_.next;
            }
         }
         else if(_loc8_ != null)
         {
            _loc12_ = this.collectNode(null,_loc12_,param1,this.threshold,true);
         }
         else if(_loc10_ != null)
         {
            _loc12_ = param1.sortByAverageZ(_loc12_);
         }
         _loc3_ = _loc12_;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.processNext;
            param2 = _loc3_.geometry;
            _loc3_.geometry = null;
            _loc17_ = _loc4_ == null || param2 != _loc4_.geometry;
            if(_loc17_ || _loc3_.material != _loc4_.material)
            {
               _loc3_.processNext = null;
               if(_loc17_)
               {
                  if(_loc13_ != null)
                  {
                     _loc14_.processNegative = _loc12_;
                     _loc13_ = null;
                     _loc14_ = null;
                  }
                  else
                  {
                     _loc12_.processPositive = _loc15_;
                     _loc15_ = _loc12_;
                     _loc15_.geometry = param2;
                  }
               }
               else
               {
                  if(_loc13_ != null)
                  {
                     _loc14_.processNegative = _loc12_;
                  }
                  else
                  {
                     _loc12_.processPositive = _loc15_;
                     _loc15_ = _loc12_;
                     _loc15_.geometry = param2;
                     _loc13_ = _loc12_;
                  }
                  _loc14_ = _loc12_;
               }
               _loc12_ = _loc4_;
            }
            _loc3_ = _loc4_;
         }
         if(param1.debug)
         {
            _loc12_ = _loc15_;
            while(_loc12_ != null)
            {
               if(_loc12_.geometry.debug & Debug.EDGES)
               {
                  _loc3_ = _loc12_;
                  while(_loc3_ != null)
                  {
                     Debug.drawEdges(param1,_loc3_,16711680);
                     _loc3_ = _loc3_.processNegative;
                  }
               }
               _loc12_ = _loc12_.processPositive;
            }
         }
         while(_loc15_ != null)
         {
            _loc12_ = _loc15_;
            _loc15_ = _loc12_.processPositive;
            _loc12_.processPositive = null;
            param2 = _loc12_.geometry;
            _loc12_.geometry = null;
            _loc16_ = null;
            while(_loc12_ != null)
            {
               _loc4_ = _loc12_.processNegative;
               if(_loc12_.material != null)
               {
                  _loc12_.processNegative = _loc16_;
                  _loc16_ = _loc12_;
               }
               else
               {
                  _loc12_.processNegative = null;
                  while(_loc12_ != null)
                  {
                     _loc3_ = _loc12_.processNext;
                     _loc12_.processNext = null;
                     _loc12_ = _loc3_;
                  }
               }
               _loc12_ = _loc4_;
            }
            _loc12_ = _loc16_;
            while(_loc12_ != null)
            {
               _loc4_ = _loc12_.processNegative;
               _loc12_.processNegative = null;
               param1.addTransparent(_loc12_,param2.object);
               _loc12_ = _loc4_;
            }
         }
         param2 = _loc7_;
         while(param2 != null)
         {
            _loc5_ = param2.next;
            param2.destroy();
            param2 = _loc5_;
         }
      }
      
      private function collectNode(param1:Face, param2:Face, param3:Camera3D, param4:Number, param5:Boolean, param6:Face = null) : Face
      {
         var _loc7_:Wrapper = null;
         var _loc8_:Vertex = null;
         var _loc9_:Vertex = null;
         var _loc10_:Vertex = null;
         var _loc11_:Vertex = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Face = null;
         var _loc17_:Face = null;
         var _loc18_:Face = null;
         var _loc19_:VG = null;
         var _loc22_:Face = null;
         var _loc23_:Face = null;
         var _loc24_:Face = null;
         var _loc25_:Face = null;
         var _loc26_:Face = null;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Boolean = false;
         var _loc46_:Boolean = false;
         var _loc47_:Number = NaN;
         var _loc48_:Face = null;
         var _loc49_:Face = null;
         var _loc50_:Wrapper = null;
         var _loc51_:Wrapper = null;
         var _loc52_:Wrapper = null;
         var _loc53_:Boolean = false;
         var _loc54_:Number = NaN;
         if(param1 != null)
         {
            _loc19_ = param1.geometry;
            if(param1.offset < 0)
            {
               _loc17_ = param1.processNegative;
               _loc18_ = param1.processPositive;
               _loc12_ = param1.normalX;
               _loc13_ = param1.normalY;
               _loc14_ = param1.normalZ;
               _loc15_ = param1.offset;
            }
            else
            {
               _loc17_ = param1.processPositive;
               _loc18_ = param1.processNegative;
               _loc12_ = -param1.normalX;
               _loc13_ = -param1.normalY;
               _loc14_ = -param1.normalZ;
               _loc15_ = -param1.offset;
            }
            param1.processNegative = null;
            param1.processPositive = null;
            if(param1.wrapper != null)
            {
               _loc16_ = param1;
               while(_loc16_.processNext != null)
               {
                  _loc16_ = _loc16_.processNext;
                  _loc16_.geometry = _loc19_;
               }
            }
            else
            {
               param1.geometry = null;
               param1 = null;
            }
         }
         else
         {
            param1 = param2;
            param2 = param1.processNext;
            _loc16_ = param1;
            _loc7_ = param1.wrapper;
            _loc8_ = _loc7_.vertex;
            _loc7_ = _loc7_.next;
            _loc9_ = _loc7_.vertex;
            _loc28_ = _loc8_.cameraX;
            _loc29_ = _loc8_.cameraY;
            _loc30_ = _loc8_.cameraZ;
            _loc31_ = _loc9_.cameraX - _loc28_;
            _loc32_ = _loc9_.cameraY - _loc29_;
            _loc33_ = _loc9_.cameraZ - _loc30_;
            _loc12_ = 0;
            _loc13_ = 0;
            _loc14_ = 1;
            _loc15_ = _loc30_;
            _loc34_ = 0;
            _loc7_ = _loc7_.next;
            while(_loc7_ != null)
            {
               _loc11_ = _loc7_.vertex;
               _loc35_ = _loc11_.cameraX - _loc28_;
               _loc36_ = _loc11_.cameraY - _loc29_;
               _loc37_ = _loc11_.cameraZ - _loc30_;
               _loc38_ = _loc37_ * _loc32_ - _loc36_ * _loc33_;
               _loc39_ = _loc35_ * _loc33_ - _loc37_ * _loc31_;
               _loc40_ = _loc36_ * _loc31_ - _loc35_ * _loc32_;
               _loc41_ = _loc38_ * _loc38_ + _loc39_ * _loc39_ + _loc40_ * _loc40_;
               if(_loc41_ > param4)
               {
                  _loc41_ = 1 / Math.sqrt(_loc41_);
                  _loc12_ = _loc38_ * _loc41_;
                  _loc13_ = _loc39_ * _loc41_;
                  _loc14_ = _loc40_ * _loc41_;
                  _loc15_ = _loc28_ * _loc12_ + _loc29_ * _loc13_ + _loc30_ * _loc14_;
                  break;
               }
               if(_loc41_ > _loc34_)
               {
                  _loc41_ = 1 / Math.sqrt(_loc41_);
                  _loc12_ = _loc38_ * _loc41_;
                  _loc13_ = _loc39_ * _loc41_;
                  _loc14_ = _loc40_ * _loc41_;
                  _loc15_ = _loc28_ * _loc12_ + _loc29_ * _loc13_ + _loc30_ * _loc14_;
                  _loc34_ = _loc41_;
               }
               _loc7_ = _loc7_.next;
            }
         }
         var _loc20_:Number = _loc15_ - param4;
         var _loc21_:Number = _loc15_ + param4;
         var _loc27_:Face = param2;
         while(_loc27_ != null)
         {
            _loc26_ = _loc27_.processNext;
            _loc7_ = _loc27_.wrapper;
            _loc8_ = _loc7_.vertex;
            _loc7_ = _loc7_.next;
            _loc9_ = _loc7_.vertex;
            _loc7_ = _loc7_.next;
            _loc10_ = _loc7_.vertex;
            _loc7_ = _loc7_.next;
            _loc42_ = _loc8_.cameraX * _loc12_ + _loc8_.cameraY * _loc13_ + _loc8_.cameraZ * _loc14_;
            _loc43_ = _loc9_.cameraX * _loc12_ + _loc9_.cameraY * _loc13_ + _loc9_.cameraZ * _loc14_;
            _loc44_ = _loc10_.cameraX * _loc12_ + _loc10_.cameraY * _loc13_ + _loc10_.cameraZ * _loc14_;
            _loc45_ = _loc42_ < _loc20_ || _loc43_ < _loc20_ || _loc44_ < _loc20_;
            _loc46_ = _loc42_ > _loc21_ || _loc43_ > _loc21_ || _loc44_ > _loc21_;
            while(_loc7_ != null)
            {
               _loc11_ = _loc7_.vertex;
               _loc47_ = _loc11_.cameraX * _loc12_ + _loc11_.cameraY * _loc13_ + _loc11_.cameraZ * _loc14_;
               if(_loc47_ < _loc20_)
               {
                  _loc45_ = true;
               }
               else if(_loc47_ > _loc21_)
               {
                  _loc46_ = true;
               }
               _loc11_.offset = _loc47_;
               _loc7_ = _loc7_.next;
            }
            if(!_loc45_)
            {
               if(!_loc46_)
               {
                  if(param1 != null)
                  {
                     _loc16_.processNext = _loc27_;
                  }
                  else
                  {
                     param1 = _loc27_;
                  }
                  _loc16_ = _loc27_;
               }
               else
               {
                  if(_loc24_ != null)
                  {
                     _loc25_.processNext = _loc27_;
                  }
                  else
                  {
                     _loc24_ = _loc27_;
                  }
                  _loc25_ = _loc27_;
               }
            }
            else if(!_loc46_)
            {
               if(_loc22_ != null)
               {
                  _loc23_.processNext = _loc27_;
               }
               else
               {
                  _loc22_ = _loc27_;
               }
               _loc23_ = _loc27_;
            }
            else
            {
               _loc8_.offset = _loc42_;
               _loc9_.offset = _loc43_;
               _loc10_.offset = _loc44_;
               _loc48_ = _loc27_.create();
               _loc48_.material = _loc27_.material;
               _loc48_.geometry = _loc27_.geometry;
               param3.lastFace.next = _loc48_;
               param3.lastFace = _loc48_;
               _loc49_ = _loc27_.create();
               _loc49_.material = _loc27_.material;
               _loc49_.geometry = _loc27_.geometry;
               param3.lastFace.next = _loc49_;
               param3.lastFace = _loc49_;
               _loc50_ = null;
               _loc51_ = null;
               _loc7_ = _loc27_.wrapper.next.next;
               while(_loc7_.next != null)
               {
                  _loc7_ = _loc7_.next;
               }
               _loc8_ = _loc7_.vertex;
               _loc42_ = _loc8_.offset;
               _loc53_ = _loc27_.material != null && _loc27_.material.useVerticesNormals;
               _loc7_ = _loc27_.wrapper;
               while(_loc7_ != null)
               {
                  _loc9_ = _loc7_.vertex;
                  _loc43_ = _loc9_.offset;
                  if(_loc42_ < _loc20_ && _loc43_ > _loc21_ || _loc42_ > _loc21_ && _loc43_ < _loc20_)
                  {
                     _loc54_ = (_loc15_ - _loc42_) / (_loc43_ - _loc42_);
                     _loc11_ = _loc9_.create();
                     param3.lastVertex.next = _loc11_;
                     param3.lastVertex = _loc11_;
                     _loc11_.cameraX = _loc8_.cameraX + (_loc9_.cameraX - _loc8_.cameraX) * _loc54_;
                     _loc11_.cameraY = _loc8_.cameraY + (_loc9_.cameraY - _loc8_.cameraY) * _loc54_;
                     _loc11_.cameraZ = _loc8_.cameraZ + (_loc9_.cameraZ - _loc8_.cameraZ) * _loc54_;
                     _loc11_.u = _loc8_.u + (_loc9_.u - _loc8_.u) * _loc54_;
                     _loc11_.v = _loc8_.v + (_loc9_.v - _loc8_.v) * _loc54_;
                     if(_loc53_)
                     {
                        _loc11_.x = _loc8_.x + (_loc9_.x - _loc8_.x) * _loc54_;
                        _loc11_.y = _loc8_.y + (_loc9_.y - _loc8_.y) * _loc54_;
                        _loc11_.z = _loc8_.z + (_loc9_.z - _loc8_.z) * _loc54_;
                        _loc11_.normalX = _loc8_.normalX + (_loc9_.normalX - _loc8_.normalX) * _loc54_;
                        _loc11_.normalY = _loc8_.normalY + (_loc9_.normalY - _loc8_.normalY) * _loc54_;
                        _loc11_.normalZ = _loc8_.normalZ + (_loc9_.normalZ - _loc8_.normalZ) * _loc54_;
                     }
                     _loc52_ = _loc7_.create();
                     _loc52_.vertex = _loc11_;
                     if(_loc50_ != null)
                     {
                        _loc50_.next = _loc52_;
                     }
                     else
                     {
                        _loc48_.wrapper = _loc52_;
                     }
                     _loc50_ = _loc52_;
                     _loc52_ = _loc7_.create();
                     _loc52_.vertex = _loc11_;
                     if(_loc51_ != null)
                     {
                        _loc51_.next = _loc52_;
                     }
                     else
                     {
                        _loc49_.wrapper = _loc52_;
                     }
                     _loc51_ = _loc52_;
                  }
                  if(_loc43_ <= _loc21_)
                  {
                     _loc52_ = _loc7_.create();
                     _loc52_.vertex = _loc9_;
                     if(_loc50_ != null)
                     {
                        _loc50_.next = _loc52_;
                     }
                     else
                     {
                        _loc48_.wrapper = _loc52_;
                     }
                     _loc50_ = _loc52_;
                  }
                  if(_loc43_ >= _loc20_)
                  {
                     _loc52_ = _loc7_.create();
                     _loc52_.vertex = _loc9_;
                     if(_loc51_ != null)
                     {
                        _loc51_.next = _loc52_;
                     }
                     else
                     {
                        _loc49_.wrapper = _loc52_;
                     }
                     _loc51_ = _loc52_;
                  }
                  _loc8_ = _loc9_;
                  _loc42_ = _loc43_;
                  _loc7_ = _loc7_.next;
               }
               if(_loc22_ != null)
               {
                  _loc23_.processNext = _loc48_;
               }
               else
               {
                  _loc22_ = _loc48_;
               }
               _loc23_ = _loc48_;
               if(_loc24_ != null)
               {
                  _loc25_.processNext = _loc49_;
               }
               else
               {
                  _loc24_ = _loc49_;
               }
               _loc25_ = _loc49_;
               _loc27_.processNext = null;
               _loc27_.geometry = null;
            }
            _loc27_ = _loc26_;
         }
         if(_loc18_ != null)
         {
            _loc18_.geometry = _loc19_;
            if(_loc25_ != null)
            {
               _loc25_.processNext = null;
            }
            param6 = this.collectNode(_loc18_,_loc24_,param3,param4,param5,param6);
         }
         else if(_loc24_ != null)
         {
            if(param5 && _loc24_ != _loc25_)
            {
               if(_loc25_ != null)
               {
                  _loc25_.processNext = null;
               }
               if(_loc24_.geometry.sorting == 2)
               {
                  param6 = this.collectNode(null,_loc24_,param3,param4,param5,param6);
               }
               else
               {
                  _loc24_ = param3.sortByAverageZ(_loc24_);
                  _loc25_ = _loc24_.processNext;
                  while(_loc25_.processNext != null)
                  {
                     _loc25_ = _loc25_.processNext;
                  }
                  _loc25_.processNext = param6;
                  param6 = _loc24_;
               }
            }
            else
            {
               _loc25_.processNext = param6;
               param6 = _loc24_;
            }
         }
         if(param1 != null)
         {
            _loc16_.processNext = param6;
            param6 = param1;
         }
         if(_loc17_ != null)
         {
            _loc17_.geometry = _loc19_;
            if(_loc23_ != null)
            {
               _loc23_.processNext = null;
            }
            param6 = this.collectNode(_loc17_,_loc22_,param3,param4,param5,param6);
         }
         else if(_loc22_ != null)
         {
            if(param5 && _loc22_ != _loc23_)
            {
               if(_loc23_ != null)
               {
                  _loc23_.processNext = null;
               }
               if(_loc22_.geometry.sorting == 2)
               {
                  param6 = this.collectNode(null,_loc22_,param3,param4,param5,param6);
               }
               else
               {
                  _loc22_ = param3.sortByAverageZ(_loc22_);
                  _loc23_ = _loc22_.processNext;
                  while(_loc23_.processNext != null)
                  {
                     _loc23_ = _loc23_.processNext;
                  }
                  _loc23_.processNext = param6;
                  param6 = _loc22_;
               }
            }
            else
            {
               _loc23_.processNext = param6;
               param6 = _loc22_;
            }
         }
         return param6;
      }
   }
}
